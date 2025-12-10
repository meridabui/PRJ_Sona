package controller.web.booking;

import dao.BookingDAO;
import dao.RoomDAO;
import dao.ServiceDAO;
import model.Booking;
import model.Room;
import model.Service;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import util.DateUtil;

@WebServlet("/book-room")
public class BookRoom extends HttpServlet {

    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("room_id"));
            Room room = roomDAO.getRoomById(roomId);

            // Kiểm tra xem phòng có tồn tại không
            if (room == null) {
                request.setAttribute("error", "Không tìm thấy thông tin phòng.");
                request.getRequestDispatcher("/views/rooms/listRooms.jsp").forward(request, response);
                return;
            }

            List<Service> allServices = serviceDAO.getAllServices();

            request.setAttribute("room", room);
            request.setAttribute("services", allServices);
            request.getRequestDispatcher("/views/rooms/bookRoom.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Nếu room_id không phải là số, chuyển hướng về trang danh sách phòng
            response.sendRedirect(request.getContextPath() + "/list-rooms");
        } catch (Exception e) {
            e.printStackTrace();
   
            response.sendRedirect(request.getContextPath() + "views/404/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (user == null) {
            String requestUri = request.getRequestURI() + "?" + request.getQueryString();
            session.setAttribute("redirectUrl", requestUri);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int roomId = Integer.parseInt(request.getParameter("room_id"));
            Room room = roomDAO.getRoomById(roomId);
            List<Service> allServices = serviceDAO.getAllServices();

            // 2. Kiểm tra phòng có tồn tại không
            if (room == null) {
                request.setAttribute("error", "Phòng bạn chọn không còn tồn tại.");
                request.getRequestDispatcher("/views/rooms/listRooms.jsp").forward(request, response);
                return;
            }

            Date checkIn = DateUtil.parseHtmlDate(request.getParameter("check_in"));
            Date checkOut = DateUtil.parseHtmlDate(request.getParameter("check_out"));

            // 3. Validate ngày tháng
            if (checkIn == null || checkOut == null || !checkOut.after(checkIn)) {
                request.setAttribute("error", "Ngày trả phòng phải sau ngày nhận phòng.");
                request.setAttribute("room", room);
                request.setAttribute("services", allServices);
                request.getRequestDispatcher("/views/rooms/bookRoom.jsp").forward(request, response);
                return;
            }

            // 4. Kiểm tra phòng có trống trong khoảng thời gian đã chọn không
            List<Booking> conflictingBookings = bookingDAO.getConflictingBookings(roomId, checkIn, checkOut);

            if (!conflictingBookings.isEmpty()) {
                // Nếu có booking bị trùng, tạo thông báo lỗi chi tiết
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                StringBuilder errorMessage = new StringBuilder("Phòng này đã được đặt hoặc đang chờ xử lý trong các khoảng thời gian sau: ");
                for (Booking conflicting : conflictingBookings) {
                    errorMessage.append(String.format("[%s - %s] ",
                            sdf.format(conflicting.getCheckIn()),
                            sdf.format(conflicting.getCheckOut())));
                }
                errorMessage.append("Vui lòng chọn ngày khác.");

                request.setAttribute("error", errorMessage.toString());
                request.setAttribute("room", room);
                request.setAttribute("services", allServices);
                request.getRequestDispatcher("/views/rooms/bookRoom.jsp").forward(request, response);
                return;
            }

            // 5. Xử lý dịch vụ và số lượng
            String[] selectedServiceIds = request.getParameterValues("service_id");
            Map<Integer, Integer> servicesWithQuantities = new HashMap<>();
            double servicesPrice = 0;

            if (selectedServiceIds != null) {
                for (String serviceIdStr : selectedServiceIds) {
                    int serviceId = Integer.parseInt(serviceIdStr);
                    // Lấy quantity từ parameter có tên là "quantity_SERVICE_ID"
                    String quantityParam = "quantity_" + serviceIdStr;
                    int quantity = Integer.parseInt(request.getParameter(quantityParam));

                    Service service = serviceDAO.getServiceById(serviceId);
                    if (service != null && quantity > 0) {
                        servicesWithQuantities.put(serviceId, quantity);
                        servicesPrice += service.getPrice() * quantity; // Tính giá dịch vụ theo số lượng
                    }
                }
            }

            // 6. Tính toán tổng chi phí
            long numberOfNights = DateUtil.calculateNumberOfNights(checkIn, checkOut);
            double roomPrice = room.getPrice() * numberOfNights;
            double totalPrice = roomPrice + servicesPrice;

            // 7. Tạo đối tượng Booking và lưu vào CSDL
            Booking booking = new Booking();
            booking.setUserId(user.getUserId());
            booking.setRoomId(roomId);
            booking.setCheckIn(checkIn);
            booking.setCheckOut(checkOut);
            booking.setTotalPrice(totalPrice);
            booking.setStatus("pending");

            boolean success = bookingDAO.addBooking(booking, servicesWithQuantities);

            // 8. Xử lý kết quả
            if (success) {
                session.setAttribute("message", "Yêu cầu đặt phòng của bạn đã được gửi thành công và đang chờ xác nhận!");
                response.sendRedirect(request.getContextPath() + "/user/viewBookings");
            } else {
                request.setAttribute("error", "Đặt phòng không thành công do lỗi hệ thống, vui lòng thử lại.");
                request.setAttribute("room", room);
                request.setAttribute("services", allServices);
                request.getRequestDispatcher("/views/rooms/bookRoom.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
