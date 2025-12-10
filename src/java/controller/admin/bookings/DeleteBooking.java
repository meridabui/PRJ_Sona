package controller.admin.bookings;

import dao.BookingDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/delete-booking")
public class DeleteBooking extends HttpServlet {
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int bookingId = Integer.parseInt(request.getParameter("booking_id"));
            boolean success = bookingDAO.deleteBooking(bookingId);

            if (success) {
                request.getSession().setAttribute("message", "Xóa đặt phòng thành công!");
            } else {
                request.getSession().setAttribute("error", "Không thể xóa đặt phòng!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi xóa đặt phòng!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/list-bookings");
    }
}
