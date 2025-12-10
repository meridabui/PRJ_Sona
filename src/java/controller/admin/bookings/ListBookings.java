package controller.admin.bookings;

import dao.BookingDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Booking;

@WebServlet("/admin/list-bookings")
public class ListBookings extends HttpServlet {
    private BookingDAO bookingDAO;
    // Đặt số lượng booking trên mỗi trang
    private static final int BOOKINGS_PER_PAGE = 10;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Lấy các tham số tìm kiếm và trang hiện tại
            String keyword = request.getParameter("keyword");
            String searchDate = request.getParameter("searchDate");
            String pageStr = request.getParameter("page");

            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            List<Booking> bookings;
            int totalBookings;

            // 2. Kiểm tra xem người dùng có thực hiện tìm kiếm không
            boolean isSearching = (keyword != null && !keyword.trim().isEmpty()) || 
                                  (searchDate != null && !searchDate.trim().isEmpty());

            if (isSearching) {
                // Nếu có, gọi các phương thức tìm kiếm và phân trang
                totalBookings = bookingDAO.countSearchedBookings(keyword, searchDate);
                bookings = bookingDAO.searchBookingsByPage(keyword, searchDate, currentPage, BOOKINGS_PER_PAGE);
            } else {
                // Nếu không, lấy tất cả bookings và phân trang
                totalBookings = bookingDAO.countBookings();
                bookings = bookingDAO.getBookingsByPage(currentPage, BOOKINGS_PER_PAGE);
            }

            // 3. Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalBookings / BOOKINGS_PER_PAGE);
            if (totalPages == 0) totalPages = 1;

            // 4. Gửi dữ liệu sang JSP
            request.setAttribute("bookings", bookings);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            
            // Gửi lại các tham số tìm kiếm để giữ giá trị trên form và trong link phân trang
            request.setAttribute("keyword", keyword);
            request.setAttribute("searchDate", searchDate);

            request.getRequestDispatcher("/views/admin/listBookings.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Có lỗi xảy ra, vui lòng thử lại.");
        }
    }
}