package controller.web.room;

import dao.RoomDAO;
import model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/list-rooms")
public class ListRoomUser extends HttpServlet {

    private RoomDAO roomDAO;
    private static final int ROOMS_PER_PAGE = 9;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy số trang hiện tại
            String pageStr = request.getParameter("page");
            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            // 2. Lấy các tham số tìm kiếm từ request
            String checkinDateStr = request.getParameter("checkin_date");
            String checkoutDateStr = request.getParameter("checkout_date");
            String guestsStr = request.getParameter("guests");
            String keyword = request.getParameter("keyword");
            String minPriceStr = request.getParameter("minPrice");
            String maxPriceStr = request.getParameter("maxPrice");

            // 3. Chuyển đổi và xử lý dữ liệu đầu vào
            java.sql.Date checkinDate = null;
            if (checkinDateStr != null && !checkinDateStr.isEmpty()) {
                checkinDate = java.sql.Date.valueOf(LocalDate.parse(checkinDateStr));
            }

            java.sql.Date checkoutDate = null;
            if (checkoutDateStr != null && !checkoutDateStr.isEmpty()) {
                checkoutDate = java.sql.Date.valueOf(LocalDate.parse(checkoutDateStr));
            }

            int guests = 1; // Mặc định là 1 khách
            if (guestsStr != null && !guestsStr.isEmpty()) {
                guests = guestsStr.contains("+") ? 4 : Integer.parseInt(guestsStr);
            }

            Double minPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? Double.parseDouble(minPriceStr) : null;
            Double maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Double.parseDouble(maxPriceStr) : null;

            // 4. Logic nghiệp vụ: Gọi DAO dựa trên tham số
            int totalRooms;
            List<Room> listRooms;

            // Câu lệnh này sẽ kiểm tra ngày checkout phải sau ngày checkin
            boolean isSearchingByDate = (checkinDate != null && checkoutDate != null && checkoutDate.after(checkinDate));

            if (isSearchingByDate) {
                System.out.println("   - Trạng thái: TÌM KIẾM PHÒNG TRỐNG THEO NGÀY");
                totalRooms = roomDAO.countAvailableRooms(checkinDate, checkoutDate, guests, keyword, minPrice, maxPrice);
                listRooms = roomDAO.findAvailableRooms(checkinDate, checkoutDate, guests, keyword, minPrice, maxPrice, currentPage, ROOMS_PER_PAGE);
            } else {
                boolean isSearchingNormally = (keyword != null && !keyword.trim().isEmpty()) || (minPrice != null) || (maxPrice != null);
                if (isSearchingNormally) {
                    System.out.println("   - Trạng thái: TÌM KIẾM THÔNG THƯỜNG (không theo ngày)");
                    totalRooms = roomDAO.countRoomsByCriteria(keyword, minPrice, maxPrice);
                    listRooms = roomDAO.findRoomsByCriteria(keyword, minPrice, maxPrice, currentPage, ROOMS_PER_PAGE);
                } else {
                    System.out.println("   - Trạng thái: XEM TẤT CẢ PHÒNG");
                    totalRooms = roomDAO.countRooms();
                    listRooms = roomDAO.getRoomsByPage(currentPage, ROOMS_PER_PAGE);
                }
            }

            // 5. Tính toán tổng số trang
            int totalPages = (int) Math.ceil((double) totalRooms / ROOMS_PER_PAGE);

            // 6. Gửi dữ liệu sang JSP
            request.setAttribute("listRooms", listRooms);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("checkin_date", checkinDateStr);
            request.setAttribute("checkout_date", checkoutDateStr);
            request.setAttribute("guests", guestsStr);
            request.setAttribute("keyword", keyword);
            request.setAttribute("minPrice", minPrice);
            request.setAttribute("maxPrice", maxPrice);

            // 7. Chuyển hướng đến file JSP
            request.getRequestDispatcher("/views/rooms/listRooms.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.getRequestDispatcher("/views/404/error.jsp").forward(request, response);
        }
    }
}
