package controller.web.booking;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/user/request-cancellation")
public class RequestCancellation extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            int bookingId = Integer.parseInt(request.getParameter("booking_id"));

            boolean success = bookingDAO.updateStatus(bookingId, "pending_cancellation");

            if (success) {
                session.setAttribute("message", "Gửi yêu cầu hủy đơn #" + bookingId + " thành công! Vui lòng chờ quản trị viên xác nhận.");
            } else {
                session.setAttribute("error", "Gửi yêu cầu hủy thất bại. Vui lòng thử lại.");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi hệ thống khi gửi yêu cầu.");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/user/viewBookings");
    }
}