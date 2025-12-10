package controller.admin.dashboard;

import dao.BookingDAO;
import dao.RoomDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class Dashboard extends HttpServlet {
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy các số liệu thống kê
            int totalUsers = userDAO.countUsers();
            int totalRooms = roomDAO.countRooms();
            int totalServices = serviceDAO.countServices();
            int totalBookings = bookingDAO.countBookings();
            
            // 2. Lấy danh sách các booking gần đây
            List<Booking> recentBookings = bookingDAO.getRecentBookings(5);
            
            // 3. Đặt tất cả dữ liệu vào request attributes
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("totalServices", totalServices);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("recentBookings", recentBookings);

            // 4. Forward tới trang JSP
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}