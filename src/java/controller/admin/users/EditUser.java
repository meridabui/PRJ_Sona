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

@WebServlet("/admin/edit-user")
public class EditUser extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    // Lấy dữ liệu cũ và hiển thị ra form edit
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            User userToEdit = userDAO.getUserById(userId);

            if (userToEdit != null) {
                request.setAttribute("userToEdit", userToEdit);
                request.getRequestDispatcher("/views/admin/editUser.jsp").forward(request, response);
            } else {
                session.setAttribute("error", "Không tìm thấy người dùng để sửa.");
                response.sendRedirect(request.getContextPath() + "/admin/list-users");
            }
        } catch (Exception e) {
            session.setAttribute("error", "ID người dùng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/list-users");
        }
    }

    // Nhận dữ liệu đã sửa và cập nhật vào CSDL
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");

        try {
            // 1. Lấy dữ liệu từ form
            int userId = Integer.parseInt(request.getParameter("userId"));
            String username = request.getParameter("username");
            String password = request.getParameter("password"); // Mật khẩu mới, có thể rỗng
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");

            // 2. Kiểm tra an toàn: Admin không được đổi vai trò của chính mình
            if (loggedInUser.getUserId() == userId && !loggedInUser.getRole().equals(role)) {
                session.setAttribute("error", "Bạn không thể thay đổi vai trò của chính mình.");
                response.sendRedirect(request.getContextPath() + "/admin/list-users");
                return;
            }

            // 3. Xử lý mật khẩu
            User currentUserData = userDAO.getUserById(userId);
            if (password == null || password.trim().isEmpty()) {
                // Nếu admin không nhập mật khẩu mới -> giữ nguyên mật khẩu cũ
                password = currentUserData.getPassword();
            } else {
                // Nếu admin nhập mật khẩu mới -> sử dụng mật khẩu mới
            }
            
            // 4. Tạo đối tượng User với thông tin đã cập nhật
            User updatedUser = new User(userId, username, password, fullName, email, phone, role, currentUserData.getCreatedAt());

            // 5. Gọi DAO để cập nhật
            boolean success = userDAO.updateUser(updatedUser);

            if (success) {
                session.setAttribute("message", "Cập nhật thông tin người dùng thành công!");
            } else {
                session.setAttribute("error", "Cập nhật thất bại. Tên đăng nhập hoặc email có thể đã bị trùng.");
            }

        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi hệ thống.");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/list-users");
    }
}