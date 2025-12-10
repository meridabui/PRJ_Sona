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

import java.text.SimpleDateFormat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/add-booking")
public class AddBooking extends HttpServlet {

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

    //Hiển thị form để thêm booking mới. Lấy danh sách users, rooms, services để hiển thị.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<User> users = userDAO.getAllUsers();
            List<Room> rooms = roomDAO.getAllRooms();
            List<Service> services = serviceDAO.getAllServices();

            request.setAttribute("users", users);
            request.setAttribute("rooms", rooms);
            request.setAttribute("services", services);

            request.getRequestDispatcher("/views/admin/addBooking.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Không thể tải trang thêm booking. Lỗi hệ thống.");
            response.sendRedirect(request.getContextPath() + "/admin/list-bookings");
        }
    }


// Xử lý dữ liệu từ form thêm booking.

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            // 1. Lấy dữ liệu từ form
            int userId = Integer.parseInt(request.getParameter("userId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            Date checkIn = DateUtil.parseHtmlDate(request.getParameter("checkIn"));
            Date checkOut = DateUtil.parseHtmlDate(request.getParameter("checkOut"));

            // 2. Validate dữ liệu
            if (checkIn == null || checkOut == null || !checkOut.after(checkIn)) {
                request.setAttribute("error", "Ngày nhận/trả phòng không hợp lệ.");
                doGet(request, response);
                return;
            }

            // Lấy thông tin phòng sớm hơn để sử dụng trong thông báo lỗi nếu cần
            Room room = roomDAO.getRoomById(roomId);
            if (room == null) {
                request.setAttribute("error", "Không tìm thấy thông tin phòng đã chọn.");
                doGet(request, response);
                return;
            }

            // 3. Kiểm tra phòng có trống không
            List<Booking> conflictingBookings = bookingDAO.getConflictingBookings(roomId, checkIn, checkOut);
            if (!conflictingBookings.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                 // Tạo thông báo lỗi chi tiết
                StringBuilder errorMessage = new StringBuilder("Phòng này đã được đặt hoặc đang chờ xử lý trong các khoảng thời gian sau: ");
                
                for (Booking conflicting : conflictingBookings) {
                    errorMessage.append(String.format("[%s - %s] ",
                            sdf.format(conflicting.getCheckIn()),
                            sdf.format(conflicting.getCheckOut())));
                }
                errorMessage.append("Vui lòng chọn ngày khác.");
               
                request.setAttribute("error", errorMessage);
                doGet(request, response);
                return;
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
            long numberOfNights = DateUtil.calculateNumberOfNights(checkIn, checkOut);
            double roomPrice = room.getPrice() * numberOfNights;
            double totalPrice = roomPrice + servicesPrice;

            // 6. Tạo đối tượng Booking và lưu vào CSDL
            Booking newBooking = new Booking();
            newBooking.setUserId(userId);
            newBooking.setRoomId(roomId);
            newBooking.setCheckIn(checkIn);
            newBooking.setCheckOut(checkOut);
            newBooking.setStatus("confirmed");
            newBooking.setTotalPrice(totalPrice);

            boolean success = bookingDAO.addBooking(newBooking, servicesWithQuantities);

            // 7. Gửi thông báo và chuyển hướng
            if (success) {
                request.getSession().setAttribute("message", "Thêm booking mới thành công!");
            } else {
                request.getSession().setAttribute("error", "Thêm booking thất bại. Đã có lỗi xảy ra.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/list-bookings");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi hệ thống khi thêm booking.");
            response.sendRedirect(request.getContextPath() + "/admin/list-bookings");
        }
    }
}
