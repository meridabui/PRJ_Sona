package controller.admin.rooms;

import dao.RoomDAO;
import model.Room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/list-rooms")
public class ListRooms extends HttpServlet {
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
            // 1. Lấy từ khóa tìm kiếm và số trang hiện tại
            String keyword = request.getParameter("keyword");
            if (keyword == null) {
                keyword = ""; // Khởi tạo keyword rỗng nếu không có để tránh NullPointerException
            }

            String pageStr = request.getParameter("page");
            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) {
                        currentPage = 1; // Đảm bảo số trang không âm
                    }
                } catch (NumberFormatException e) {
                    System.out.println("Tham số 'page' không hợp lệ, đặt về trang 1.");
                    currentPage = 1; 
                }
            }

            // 2. Lấy tổng số phòng và danh sách phòng tùy thuộc vào có keyword hay không
            int totalRooms;
            List<Room> listRooms;

            if (keyword.trim().isEmpty()) {
                // --- Trường hợp không tìm kiếm ---
                totalRooms = roomDAO.countAllRoomsByKeywordForAdmin(keyword); 
                listRooms = roomDAO.searchAllRoomsByPageForAdmin(keyword, currentPage, ROOMS_PER_PAGE);
            } else {
                // --- Trường hợp có tìm kiếm ---
                totalRooms = roomDAO.countAllRoomsForAdmin();
                listRooms = roomDAO.getAllRoomsForAdmin(currentPage, ROOMS_PER_PAGE);
            }

            // 3. Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalRooms / ROOMS_PER_PAGE);
            if (totalPages == 0) {
                 totalPages = 1; // Đảm bảo luôn có ít nhất 1 trang
            }
            
            // 4. Gửi các thuộc tính sang JSP
            request.setAttribute("listRooms", listRooms);   
            request.setAttribute("totalPages", totalPages); 
            request.setAttribute("currentPage", currentPage); 
            request.setAttribute("keyword", keyword); // Gửi cả keyword để hiển thị lại trên thanh tìm kiếm

            // 5. Forward đến trang JSP
            request.getRequestDispatcher("/views/admin/listRooms.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Có thể chuyển hướng đến trang lỗi
            response.sendRedirect(request.getContextPath() + "views/404/error.jsp");
        }
    }
}