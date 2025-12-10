package controller.admin.rooms;

import dao.RoomDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/delete-room")
public class DeleteRoom extends HttpServlet {
    private RoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // 1. Lấy roomId từ hidden input của form
            int roomId = Integer.parseInt(request.getParameter("roomId"));

            // 2. Gọi DAO để thực hiện xóa
            boolean success = roomDAO.deleteRoom(roomId);

            // 3. Đặt thông báo kết quả vào session
            if (success) {
                session.setAttribute("message", "Xóa phòng thành công!");
            } else {
                session.setAttribute("error", "Xóa phòng thất bại. Có thể phòng đang được tham chiếu ở nơi khác (ví dụ: trong một booking).");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID phòng không hợp lệ.");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi hệ thống khi xóa phòng.");
            e.printStackTrace();
        }

        // 4. Chuyển hướng về trang danh sách phòng
        response.sendRedirect(request.getContextPath() + "/admin/list-rooms");
    }
}