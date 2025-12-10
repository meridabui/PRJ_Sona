package controller.admin.bookings;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/update-booking-status")
public class UpdateBookingStatusServlet extends HttpServlet {
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    /**
     * Cập nhật trạng thái của một đơn đặt phòng.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            // Lấy thông tin từ form
            int bookingId = Integer.parseInt(request.getParameter("booking_id"));
            String newStatus = request.getParameter("newStatus");

            // Kiểm tra newStatus có hợp lệ không (confirmed hoặc cancelled)
            if (newStatus != null && (newStatus.equals("confirmed") || newStatus.equals("cancelled"))) {
                
                boolean success = bookingDAO.updateStatus(bookingId, newStatus);

                if (success) {
                    session.setAttribute("message", "Cập nhật trạng thái đơn #" + bookingId + " thành công!");
                } else {
                    session.setAttribute("error", "Cập nhật trạng thái thất bại. Vui lòng thử lại.");
                }
            } else {
                session.setAttribute("error", "Trạng thái mới không hợp lệ.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Mã đặt phòng không hợp lệ.");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi hệ thống.");
            e.printStackTrace();
        }

        // Chuyển hướng trở lại trang quản lý booking
        response.sendRedirect(request.getContextPath() + "/admin/list-bookings");
    }
}