package controller.admin.users;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/delete-user")
public class DeleteUser extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Lấy thông tin admin đang đăng nhập từ session
        User loggedInUser = (User) session.getAttribute("user");

        try {
            // 1. Lấy userId từ form
            int userIdToDelete = Integer.parseInt(request.getParameter("userId"));

            // 2. Kiểm tra an toàn: Admin không thể tự xóa chính mình
            if (loggedInUser.getUserId() == userIdToDelete) {
                session.setAttribute("error", "Bạn không thể tự xóa tài khoản của chính mình!");
                response.sendRedirect(request.getContextPath() + "/admin/list-users");
                return; // Dừng ngay lập tức
            }

            // 3. Gọi DAO để thực hiện xóa
            boolean success = userDAO.deleteUser(userIdToDelete);

            // 4. Đặt thông báo kết quả
            if (success) {
                session.setAttribute("message", "Xóa người dùng thành công!");
            } else {
                session.setAttribute("error", "Xóa người dùng thất bại. Người dùng này có thể có các booking liên quan.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID người dùng không hợp lệ.");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi hệ thống khi xóa người dùng.");
            e.printStackTrace();
        }

        // 5. Chuyển hướng về trang danh sách người dùng
        response.sendRedirect(request.getContextPath() + "/admin/list-users");
    }
}