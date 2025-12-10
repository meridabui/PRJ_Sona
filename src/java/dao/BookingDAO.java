package dao;

import model.Booking;
import model.Room;
import model.Service;
import model.User;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class BookingDAO {

    //1. Thêm một đơn đặt phòng mới vào CSDL, bao gồm cả số lượng dịch (dùng cho add và book)
    public boolean addBooking(Booking booking, Map<Integer, Integer> servicesWithQuantities) {
        String sqlBooking = "INSERT INTO Bookings (user_id, room_id, check_in, check_out, total_price, status) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        boolean success = false;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Thêm vào bảng Bookings và lấy ID vừa được tạo
            try (PreparedStatement psBooking = conn.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS)) {
                psBooking.setInt(1, booking.getUserId());
                psBooking.setInt(2, booking.getRoomId());
                psBooking.setDate(3, booking.getCheckIn());
                psBooking.setDate(4, booking.getCheckOut());
                psBooking.setDouble(5, booking.getTotalPrice());
                psBooking.setString(6, booking.getStatus());

                if (psBooking.executeUpdate() > 0) {
                    try (ResultSet generatedKeys = psBooking.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            booking.setBookingId(generatedKeys.getInt(1));
                        }
                    }
                } else {
                    throw new SQLException("Creating booking failed, no rows affected.");
                }
            }

            // Thêm các dịch vụ đã chọn vào bảng BookingServices
            updateBookingServices(conn, booking.getBookingId(), servicesWithQuantities, false);

            conn.commit();
            success = true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            closeConnection(conn);
        }
        return success;
    }

// 2. Cập nhật thông tin của một booking đã có. Sử dụng transaction để đảm bảo tính toàn vẹn dữ liệu.
    public boolean updateBooking(Booking booking, Map<Integer, Integer> servicesWithQuantities) {
        String sqlUpdateBooking = "UPDATE Bookings SET user_id=?, room_id=?, check_in=?, check_out=?, total_price=?, status=? WHERE booking_id=?";
        Connection conn = null;
        boolean success = false;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Cập nhật thông tin chính trong bảng Bookings
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdateBooking)) {
                ps.setInt(1, booking.getUserId());
                ps.setInt(2, booking.getRoomId());
                ps.setDate(3, booking.getCheckIn());
                ps.setDate(4, booking.getCheckOut());
                ps.setDouble(5, booking.getTotalPrice());
                ps.setString(6, booking.getStatus());
                ps.setInt(7, booking.getBookingId());
                ps.executeUpdate();
            }

            // Cập nhật lại toàn bộ dịch vụ cho booking này
            updateBookingServices(conn, booking.getBookingId(), servicesWithQuantities, true);

            conn.commit();
            success = true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            closeConnection(conn);
        }
        return success;
    }

    //3. Cập nhật trạng thái của một đơn đặt phòng.
    public boolean updateStatus(int bookingId, String newStatus) {
        String sql = "UPDATE Bookings SET status = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //4. Xóa một đơn đặt phòng (sẽ tự động xóa các record liên quan trong BookingServices nhờ ON DELETE CASCADE).
    public boolean deleteBooking(int bookingId) {
        String sql = "DELETE FROM Bookings WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

//5. Lấy thông tin chi tiết của một booking duy nhất dựa vào ID.
    public Booking getBookingById(int bookingId) {
        Booking booking = null;
        String sql = "SELECT b.*, u.full_name, u.user_id, r.room_name, r.room_id "
                + "FROM Bookings b "
                + "JOIN Users u ON b.user_id = u.user_id "
                + "JOIN Rooms r ON b.room_id = r.room_id "
                + "WHERE b.booking_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = mapResultSetToBooking(rs);
                    booking.setServices(getServicesForBooking(bookingId));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return booking;
    }

    //6. Lấy danh sách tất cả các đơn đặt phòng.
    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name, u.user_id, r.room_name, r.room_id "
                + "FROM Bookings b "
                + "JOIN Users u ON b.user_id = u.user_id "
                + "JOIN Rooms r ON b.room_id = r.room_id "
                + "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Booking b = mapResultSetToBooking(rs);
                b.setServices(getServicesForBooking(b.getBookingId()));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //7. Lấy danh sách các đơn đặt phòng của một người dùng cụ thể.
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name, u.user_id, r.room_name, r.room_id "
                + "FROM Bookings b "
                + "JOIN Users u ON b.user_id = u.user_id "
                + "JOIN Rooms r ON b.room_id = r.room_id "
                + "WHERE b.user_id = ? "
                + "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = mapResultSetToBooking(rs);
                    b.setServices(getServicesForBooking(b.getBookingId()));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //8. Lấy một số lượng giới hạn các đơn đặt phòng gần đây nhất cho dashboard.
    public List<Booking> getRecentBookings(int limit) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT TOP (?) b.*, u.full_name, u.user_id, r.room_name, r.room_id "
                + "FROM Bookings b "
                + "JOIN Users u ON b.user_id = u.user_id "
                + "JOIN Rooms r ON b.room_id = r.room_id "
                + "ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = mapResultSetToBooking(rs);
                    b.setServices(getServicesForBooking(b.getBookingId()));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //9. Lấy danh sách các booking bị trùng lặp trong một khoảng thời gian cho một phòng cụ thể.
    public List<Booking> getConflictingBookings(int roomId, Date checkIn, Date checkOut) {
        List<Booking> conflictingBookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings "
                + "WHERE room_id = ? AND status IN ('pending', 'confirmed') "
                + "AND ? < check_out AND ? > check_in";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, checkIn);
            ps.setDate(3, checkOut);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setCheckIn(rs.getDate("check_in"));
                    b.setCheckOut(rs.getDate("check_out"));
                    conflictingBookings.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conflictingBookings;
    }

    //10. Đếm tổng số đơn đặt phòng trong CSDL.
    public int countBookings() {
        String sql = "SELECT COUNT(*) FROM Bookings";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //11.Helper method để xử lý việc thêm/cập nhật dịch vụ cho một booking. Được dùng trong cả addBooking và updateBooking để tránh lặp code.
    private void updateBookingServices(Connection conn, int bookingId, Map<Integer, Integer> servicesWithQuantities, boolean isUpdate) throws SQLException {
        if (isUpdate) {
            // (cho update) Xóa hết các dịch vụ cũ
            try (PreparedStatement psDelete = conn.prepareStatement("DELETE FROM BookingServices WHERE booking_id = ?")) {
                psDelete.setInt(1, bookingId);
                psDelete.executeUpdate();
            }
        }

        // Thêm lại các dịch vụ mới
        if (servicesWithQuantities != null && !servicesWithQuantities.isEmpty()) {
            String sqlInsert = "INSERT INTO BookingServices (booking_id, service_id, quantity) VALUES (?, ?, ?)";
            try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert)) {
                for (Map.Entry<Integer, Integer> entry : servicesWithQuantities.entrySet()) {
                    psInsert.setInt(1, bookingId);
                    psInsert.setInt(2, entry.getKey());
                    psInsert.setInt(3, entry.getValue());
                    psInsert.addBatch();
                }
                psInsert.executeBatch();
            }
        }
    }

    //12.Lấy danh sách các dịch vụ và số lượng tương ứng cho một đơn đặt phòng.
    private List<Service> getServicesForBooking(int bookingId) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT s.*, bs.quantity FROM Services s "
                + "JOIN BookingServices bs ON s.service_id = bs.service_id "
                + "WHERE bs.booking_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service service = new Service();
                    service.setServiceId(rs.getInt("service_id"));
                    service.setServiceName(rs.getString("service_name"));
                    service.setPrice(rs.getDouble("price"));
                    service.setDescription(rs.getString("description"));
                    service.setQuantity(rs.getInt("quantity"));
                    services.add(service);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return services;
    }

    //13.Hàm helper để chuyển đổi một dòng ResultSet thành một đối tượng Booking.
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId(rs.getInt("booking_id"));
        b.setUserId(rs.getInt("user_id"));
        b.setRoomId(rs.getInt("room_id"));
        b.setCheckIn(rs.getDate("check_in"));
        b.setCheckOut(rs.getDate("check_out"));
        b.setTotalPrice(rs.getDouble("total_price"));
        b.setStatus(rs.getString("status"));
        b.setCreatedAt(rs.getTimestamp("created_at"));

        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        b.setUser(u);

        Room r = new Room();
        r.setRoomId(rs.getInt("room_id"));
        r.setRoomName(rs.getString("room_name"));
        b.setRoom(r);

        return b;
    }

    //14.Helper method để đóng connection và set lại autoCommit.
    private void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    //15. tìm kiếm booking dựa trên tên người dùng hoặc tên phòng và ngày tháng
    public List<Booking> searchBookings(String keyword, String searchDateStr) {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.*, u.full_name, u.user_id, r.room_name, r.room_id "
                + "FROM Bookings b "
                + "JOIN Users u ON b.user_id = u.user_id "
                + "JOIN Rooms r ON b.room_id = r.room_id "
                + "WHERE 1=1" // Mẹo để dễ dàng nối thêm điều kiện AND
        );

        List<Object> params = new ArrayList<>();

        // Thêm điều kiện tìm kiếm theo từ khóa nếu có
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR r.room_name LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        // Thêm điều kiện tìm kiếm theo ngày nếu có
        if (searchDateStr != null && !searchDateStr.trim().isEmpty()) {
            sql.append(" AND ? BETWEEN b.check_in AND b.check_out");
            try {
                Date searchDate = Date.valueOf(searchDateStr);
                params.add(searchDate);
            } catch (IllegalArgumentException e) {
                System.err.println("Định dạng ngày không hợp lệ: " + searchDateStr);
            }
        }

        sql.append(" ORDER BY b.created_at DESC");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Set các tham số cho PreparedStatement
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = mapResultSetToBooking(rs);
                    b.setServices(getServicesForBooking(b.getBookingId()));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //16.Lấy danh sách booking theo từng trang.
    public List<Booking> getBookingsByPage(int pageNumber, int bookingsPerPage) {
        List<Booking> list = new ArrayList<>();
        int offset = (pageNumber - 1) * bookingsPerPage;
        String sql = "SELECT b.*, u.full_name, u.user_id, r.room_name, r.room_id "
                + "FROM Bookings b "
                + "JOIN Users u ON b.user_id = u.user_id "
                + "JOIN Rooms r ON b.room_id = r.room_id "
                + "ORDER BY b.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, bookingsPerPage);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = mapResultSetToBooking(rs);
                    b.setServices(getServicesForBooking(b.getBookingId()));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //Đếm số lượng booking phù hợp với tiêu chí tìm kiếm.
    public int countSearchedBookings(String keyword, String searchDateStr) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(b.booking_id) "
                + "FROM Bookings b JOIN Users u ON b.user_id = u.user_id JOIN Rooms r ON b.room_id = r.room_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR r.room_name LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (searchDateStr != null && !searchDateStr.trim().isEmpty()) {
            sql.append(" AND ? BETWEEN b.check_in AND b.check_out");
            params.add(Date.valueOf(searchDateStr));
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //Lấy danh sách booking theo tiêu chí tìm kiếm và theo trang.
    public List<Booking> searchBookingsByPage(String keyword, String searchDateStr, int pageNumber, int bookingsPerPage) {
        List<Booking> list = new ArrayList<>();
        int offset = (pageNumber - 1) * bookingsPerPage;
        StringBuilder sql = new StringBuilder(
                "SELECT b.*, u.full_name, u.user_id, r.room_name, r.room_id "
                + "FROM Bookings b JOIN Users u ON b.user_id = u.user_id JOIN Rooms r ON b.room_id = r.room_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR r.room_name LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (searchDateStr != null && !searchDateStr.trim().isEmpty()) {
            sql.append(" AND ? BETWEEN b.check_in AND b.check_out");
            params.add(Date.valueOf(searchDateStr));
        }

        sql.append(" ORDER BY b.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(bookingsPerPage);

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = mapResultSetToBooking(rs);
                    b.setServices(getServicesForBooking(b.getBookingId()));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
