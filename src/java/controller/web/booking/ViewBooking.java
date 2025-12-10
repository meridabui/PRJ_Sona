package controller.web.booking;

import dao.BookingDAO;
import model.Booking;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/view-bookings")
public class ViewBooking extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            // Lấy danh sách booking theo user_id
            List<Booking> bookings = bookingDAO.getBookingsByUserId(user.getUserId());
            request.setAttribute("bookings", bookings);

            // Chuyển tới trang hiển thị
            request.getRequestDispatcher("/views/user/viewBookings.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách đặt phòng.");
            request.getRequestDispatcher("/views/user/viewBookings.jsp").forward(request, response);
        }
    }
}
