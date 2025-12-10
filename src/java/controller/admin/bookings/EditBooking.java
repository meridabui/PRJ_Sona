package controller.admin.bookings;

import dao.BookingDAO;
import dao.RoomDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import model.Booking;
import model.Room;
import model.Service;
import model.User;
import util.DateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/admin/edit-booking")
public class EditBooking extends HttpServlet {

    private UserDAO userDAO;
    private RoomDAO roomDAO;
    private ServiceDAO serviceDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        roomDAO = new RoomDAO();
        serviceDAO = new ServiceDAO();
        bookingDAO = new BookingDAO();
    }

//Hiển thị form để chỉnh sửa một booking đã có.
//Tải thông tin của booking cần sửa, cùng với danh sách tất cả users, rooms, services.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("booking_id"));
            Booking bookingToEdit = bookingDAO.getBookingById(bookingId);

            if (bookingToEdit == null) {
                request.getSession().setAttribute("error", "Không tìm thấy booking để sửa.");
                response.sendRedirect(request.getContextPath() + "/admin/list-bookings");
                return;
            }

            // Lấy danh sách để hiển thị trong các dropdown
            List<User> users = userDAO.getAllUsers();
            List<Room> rooms = roomDAO.getAllRooms();
            List<Service> allServices = serviceDAO.getAllServices();

            // Lấy ID các dịch vụ mà booking này đã chọn để check sẵn checkbox
            List<Integer> selectedServiceIds = bookingToEdit.getServices().stream()
                    .map(Service::getServiceId)
                    .collect(Collectors.toList());

            request.setAttribute("booking", bookingToEdit);
            request.setAttribute("users", users);
            request.setAttribute("rooms", rooms);
            request.setAttribute("allServices", allServices);
            request.setAttribute("selectedServiceIds", selectedServiceIds);

            request.getRequestDispatcher("/views/admin/editBooking.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID booking không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/list-bookings");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi hệ thống khi tải trang sửa booking.");
            response.sendRedirect(request.getContextPath() + "/admin/list-bookings");
        }
    }

    /**
     * Xử lý dữ liệu cập nhật từ form sửa booking.
     */
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");

    try {
        // 1. Lấy dữ liệu từ form
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        Date checkIn = DateUtil.parseHtmlDate(request.getParameter("checkIn"));
        Date checkOut = DateUtil.parseHtmlDate(request.getParameter("checkOut"));
        String status = request.getParameter("status");

        // 2. Validate dữ liệu
        if (checkIn == null || checkOut == null || !checkOut.after(checkIn)) {
            request.getSession().setAttribute("error", "Ngày nhận/trả phòng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/edit-booking?booking_id=" + bookingId);
            return;
        }
        
        // 3. Kiểm tra xung đột khi trạng thái không phải cancalled
        if (!"cancelled".equalsIgnoreCase(status)) {
            List<Booking> conflictingBookings = bookingDAO.getConflictingBookings(roomId, checkIn, checkOut);

            boolean hasRealConflict = false;
            StringBuilder errorMessage = new StringBuilder("Phòng này đã được đặt hoặc đang chờ xử lý trong các khoảng thời gian sau: ");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

            for (Booking conflicting : conflictingBookings) {
                if (conflicting.getBookingId() != bookingId) {
                    hasRealConflict = true;
                    errorMessage.append(String.format("[%s - %s] ",
                            sdf.format(conflicting.getCheckIn()),
                            sdf.format(conflicting.getCheckOut())));
                }
            }
            
            // Chỉ báo lỗi nếu thực sự có xung đột với booking khác
            if (hasRealConflict) {
                errorMessage.append("Vui lòng chọn ngày khác.");
                request.getSession().setAttribute("error", errorMessage.toString());
                response.sendRedirect(request.getContextPath() + "/admin/edit-booking?booking_id=" + bookingId);
                return;
            }
        }

            // 4. Xử lý dịch vụ và tính tổng tiền
            String[] serviceIds = request.getParameterValues("serviceIds");
            Map<Integer, Integer> servicesWithQuantities = new HashMap<>();
            double servicesPrice = 0;

            if (serviceIds != null) {
                for (String serviceIdStr : serviceIds) {
                    int serviceId = Integer.parseInt(serviceIdStr);
                    int quantity = Integer.parseInt(request.getParameter("quantity_" + serviceId));
                    if (quantity > 0) {
                        Service service = serviceDAO.getServiceById(serviceId);
                        if (service != null) {
                            servicesWithQuantities.put(serviceId, quantity);
                            servicesPrice += service.getPrice() * quantity;
                        }
                    }
                }
            }

            // 5. Tính tiền phòng và tổng tiền
            Room room = roomDAO.getRoomById(roomId);
            long numberOfNights = DateUtil.calculateNumberOfNights(checkIn, checkOut);
            double roomPrice = room.getPrice() * numberOfNights;
            double totalPrice = roomPrice + servicesPrice;

            // 6. Tạo đối tượng Booking và cập nhật CSDL
            Booking updatedBooking = new Booking();
            updatedBooking.setBookingId(bookingId);
            updatedBooking.setUserId(userId);
            updatedBooking.setRoomId(roomId);
            updatedBooking.setCheckIn(checkIn);
            updatedBooking.setCheckOut(checkOut);
            updatedBooking.setStatus(status);
            updatedBooking.setTotalPrice(totalPrice);

            boolean success = bookingDAO.updateBooking(updatedBooking, servicesWithQuantities);

            // 7. Gửi thông báo và chuyển hướng
            if (success) {
                request.getSession().setAttribute("message", "Cập nhật booking #" + bookingId + " thành công!");
            } else {
                request.getSession().setAttribute("error", "Cập nhật booking thất bại.");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi hệ thống khi cập nhật booking.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/list-bookings");
    }
}
