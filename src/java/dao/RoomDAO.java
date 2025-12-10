package dao;

import model.Room;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;

public class RoomDAO {

    //1. tìm phòng đang available
    public List<Room> findAvailableRooms(Date checkIn, Date checkOut, int guestCount) {
        List<Room> list = new ArrayList<>();
        // SQL: tìm các phòng có đủ sức chứa và đang available
        StringBuilder sql = new StringBuilder("SELECT * FROM Rooms WHERE capacity >= ? AND status = 'available'");

        // Nếu người dùng có nhập ngày, thêm điều kiện để loại trừ các phòng đã bị đặt
        if (checkIn != null && checkOut != null) {
            sql.append(" AND room_id NOT IN (");
            sql.append("    SELECT DISTINCT room_id FROM Bookings ");
            sql.append("    WHERE status IN ('pending', 'confirmed') ");
            // Logic kiểm tra khoảng thời gian giao nhau: (StartA < EndB) AND (EndA > StartB)
            sql.append("    AND ? < check_out AND ? > check_in");
            sql.append(")");
        }
        sql.append(" ORDER BY price ASC");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            ps.setInt(paramIndex++, guestCount > 0 ? guestCount : 1); // Đảm bảo số khách luôn >= 1

            if (checkIn != null && checkOut != null) {
                ps.setDate(paramIndex++, checkIn);
                ps.setDate(paramIndex++, checkOut);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToRoom(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// 2. Lấy tất cả các phòng
    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE status = 'available' ORDER BY room_id";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToRoom(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

//3. Lấy thông tin chi tiết của một phòng dựa vào ID.
    public Room getRoomById(int roomId) {
        Room room = null;
        String sql = "SELECT * FROM Rooms WHERE room_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    room = mapResultSetToRoom(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return room;
    }

//4. Lấy danh sách các phòng nổi bật để hiển thị trên trang chủ.
    public List<Room> getFeaturedRooms(int limit) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM Rooms WHERE status = 'available' ORDER BY price DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToRoom(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //5.Thêm một phòng mới vào cơ sở dữ liệu.
    public boolean addRoom(Room room) {
        String sql = "INSERT INTO Rooms (room_name, room_type, price, capacity, description, status, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomName());
            ps.setString(2, room.getRoomType());
            ps.setDouble(3, room.getPrice());
            ps.setInt(4, room.getCapacity());
            ps.setString(5, room.getDescription());
            ps.setString(6, room.getStatus());
            ps.setString(7, room.getImageUrl());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //6. Cập nhật thông tin của một phòng đã có.
    public boolean updateRoom(Room room) {
        String sql = "UPDATE Rooms SET room_name = ?, room_type = ?, price = ?, capacity = ?, description = ?, status = ?, image_url = ? WHERE room_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomName());
            ps.setString(2, room.getRoomType());
            ps.setDouble(3, room.getPrice());
            ps.setInt(4, room.getCapacity());
            ps.setString(5, room.getDescription());
            ps.setString(6, room.getStatus());
            ps.setString(7, room.getImageUrl());
            ps.setInt(8, room.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //7. Xóa một phòng khỏi cơ sở dữ liệu.
    public boolean deleteRoom(int roomId) {
        String sql = "DELETE FROM Rooms WHERE room_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// 8. Đếm tổng số phòng có trong hệ thống.
    public int countRooms() {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE status = 'available'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //9. Hàm helper private để chuyển một dòng từ ResultSet thành một đối tượng Room. Giúp tránh lặp code.
    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {

        Room room = new Room();

        room.setRoomId(rs.getInt("room_id"));
        room.setRoomName(rs.getString("room_name"));
        room.setRoomType(rs.getString("room_type"));
        room.setPrice(rs.getDouble("price"));
        room.setCapacity(rs.getInt("capacity"));
        room.setStatus(rs.getString("status"));
        room.setDescription(rs.getString("description"));
        room.setImageUrl(rs.getString("image_url"));

        return room;
    }

    //10. tìm kiếm phòng theo tên phòng
    public List<Room> searchRoomsByKeyword(String keyword) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE status = 'available' AND (room_name LIKE ? OR room_type LIKE ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = mapResultSetToRoom(rs);
                    list.add(room);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //11. Lấy danh sách phòng theo trang.
    public List<Room> getRoomsByPage(int pageNumber, int roomsPerPage) {
        List<Room> list = new ArrayList<>();
        // Công thức tính offset: bỏ qua (số trang - 1) * số phòng mỗi trang
        int offset = (pageNumber - 1) * roomsPerPage;

        // Câu lệnh SQL này dùng cú pháp OFFSET-FETCH.
        String sql = "SELECT * FROM Rooms WHERE status = 'available' ORDER BY room_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, roomsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room();
                    room.setRoomId(rs.getInt("room_id"));
                    room.setRoomName(rs.getString("room_name"));
                    room.setRoomType(rs.getString("room_type"));
                    room.setCapacity(rs.getInt("capacity"));
                    room.setPrice(rs.getDouble("price"));
                    room.setImageUrl(rs.getString("image_url"));
                    list.add(room);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //12. đếm số lượng phòng dựa trên tên phòng hoặc loại phòng
    public int countRoomsByKeyword(String keyword) {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE status = 'available' AND (room_name LIKE ? OR room_type LIKE ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
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

    //13. Tìm kiếm phòng theo từ khóa và trả về kết quả theo trang. Kết hợp logic của searchRoomsByKeyword và getRoomsByPage.
    public List<Room> searchRoomsByPage(String keyword, int pageNumber, int roomsPerPage) {
        List<Room> list = new ArrayList<>();
        int offset = (pageNumber - 1) * roomsPerPage;
        // Kết hợp cả WHERE và OFFSET-FETCH
        String sql = "SELECT * FROM Rooms WHERE status = 'available' AND (room_name LIKE ? OR room_type LIKE ?) "
            + "ORDER BY room_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setInt(3, offset);
            ps.setInt(4, roomsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToRoom(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //14. Đếm số lượng phòng thỏa mãn các tiêu chí tìm kiếm.
    public int countRoomsByCriteria(String keyword, Double minPrice, Double maxPrice) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Rooms WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (room_name LIKE ? OR room_type LIKE ?) ");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (minPrice != null) {
            sql.append("AND price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append("AND price <= ? ");
            params.add(maxPrice);
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

// 15. Tìm kiếm phòng theo nhiều tiêu chí và phân trang.
    public List<Room> findRoomsByCriteria(String keyword, Double minPrice, Double maxPrice, int pageNumber, int roomsPerPage) {
        List<Room> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Rooms WHERE status = 'available' ");
        List<Object> params = new ArrayList<>();

        // Xây dựng câu lệnh WHERE động
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (room_name LIKE ? OR room_type LIKE ?) ");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (minPrice != null) {
            sql.append("AND price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append("AND price <= ? ");
            params.add(maxPrice);
        }

        // Thêm phần sắp xếp và phân trang
        sql.append("ORDER BY room_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        int offset = (pageNumber - 1) * roomsPerPage;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            for (Object param : params) {
                ps.setObject(paramIndex++, param);
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, roomsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToRoom(rs)); // Tận dụng lại hàm map của bạn
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //16. Đếm tổng số phòng TRỐNG thỏa mãn điều kiện tìm kiếm theo ngày và các tiêu chí khác.
    public int countAvailableRooms(Date checkIn, Date checkOut, int guests, String keyword, Double minPrice, Double maxPrice) {
        // Câu lệnh SQL tìm các phòng KHÔNG có booking trùng lặp trong khoảng thời gian đã chọn
        String sql = "SELECT COUNT(*) FROM Rooms r "
                + "WHERE r.capacity >= ? "
                + "AND r.status = 'available' "
                + "AND NOT EXISTS ("
                + "    SELECT 1 FROM Bookings b "
                + "    WHERE b.room_id = r.room_id "
                + "    AND b.status IN ('pending', 'confirmed') "
                + "    AND b.check_in < ? AND b.check_out > ?"
                + ")"
                + (keyword != null && !keyword.isEmpty() ? " AND r.room_name LIKE ? " : "")
                + (minPrice != null ? " AND r.price >= ? " : "")
                + (maxPrice != null ? " AND r.price <= ? " : "");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            ps.setInt(paramIndex++, guests);
            ps.setDate(paramIndex++, checkOut);
            ps.setDate(paramIndex++, checkIn);

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
            }
            if (minPrice != null) {
                ps.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                ps.setDouble(paramIndex++, maxPrice);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //17. Tìm và phân trang các phòng TRỐNG
    public List<Room> findAvailableRooms(Date checkIn, Date checkOut, int guests, String keyword, Double minPrice, Double maxPrice, int page, int pageSize) {
        List<Room> list = new ArrayList<>();
        // Sử dụng WITH và ROW_NUMBER() để phân trang hiệu quả trên SQL Server
        String sql = "WITH FilteredRooms AS ("
                + "    SELECT *, ROW_NUMBER() OVER (ORDER BY price ASC) as row_num FROM Rooms r " // Sắp xếp theo giá tăng dần
                + "    WHERE r.capacity >= ? "
                + "    AND r.status = 'available' "
                + "    AND NOT EXISTS ("
                + "        SELECT 1 FROM Bookings b"
                + "        WHERE b.room_id = r.room_id"
                + "        AND b.status IN ('pending', 'confirmed')"
                + "        AND b.check_in < ? "
                + "        AND b.check_out > ? "
                + "    )"
                + (keyword != null && !keyword.isEmpty() ? " AND r.room_name LIKE ? " : "")
                + (minPrice != null ? " AND r.price >= ? " : "")
                + (maxPrice != null ? " AND r.price <= ? " : "")
                + ") "
                + "SELECT * FROM FilteredRooms WHERE row_num BETWEEN ? AND ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            ps.setInt(paramIndex++, guests);
            ps.setDate(paramIndex++, checkOut);
            ps.setDate(paramIndex++, checkIn);

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
            }
            if (minPrice != null) {
                ps.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                ps.setDouble(paramIndex++, maxPrice);
            }

            int startRow = (page - 1) * pageSize + 1;
            int endRow = page * pageSize;
            ps.setInt(paramIndex++, startRow);
            ps.setInt(paramIndex++, endRow);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Room room = new Room(
                        rs.getInt("room_id"),
                        rs.getString("room_name"),
                        rs.getString("room_type"),
                        rs.getDouble("price"),
                        rs.getInt("capacity"),
                        rs.getString("status"),
                        rs.getString("description"),
                        rs.getString("image_url")
                );
                list.add(room);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //18.Đếm TẤT CẢ các phòng trong CSDL, không lọc theo trạng thái.
    public int countAllRoomsForAdmin() {
        String sql = "SELECT COUNT(*) FROM Rooms";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //19. Lấy TẤT CẢ các phòng theo trang, không lọc theo trạng thái.
    public List<Room> getAllRoomsForAdmin(int pageNumber, int roomsPerPage) {
        List<Room> list = new ArrayList<>();
        int offset = (pageNumber - 1) * roomsPerPage;
        String sql = "SELECT * FROM Rooms ORDER BY room_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, roomsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToRoom(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //20. Đếm kết quả tìm kiếm TẤT CẢ các phòng theo từ khóa.
    public int countAllRoomsByKeywordForAdmin(String keyword) {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE room_name LIKE ? OR room_type LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
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

    //21. Tìm kiếm và phân trang TẤT CẢ các phòng theo từ khóa.
    public List<Room> searchAllRoomsByPageForAdmin(String keyword, int pageNumber, int roomsPerPage) {
        List<Room> list = new ArrayList<>();
        int offset = (pageNumber - 1) * roomsPerPage;
        String sql = "SELECT * FROM Rooms WHERE room_name LIKE ? OR room_type LIKE ? "
                + "ORDER BY room_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setInt(3, offset);
            ps.setInt(4, roomsPerPage);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToRoom(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
}
