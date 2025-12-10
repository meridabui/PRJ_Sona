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

@WebServlet("/admin/add-user")
public class AddUser extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    // Hiển thị trang form để thêm người dùng
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/addUser.jsp").forward(request, response);
    }

    // Xử lý dữ liệu được gửi lên từ form
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            // 1. Lấy dữ liệu từ form
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");

            // 2. Kiểm tra xem username hoặc email đã tồn tại chưa
            if (userDAO.existsByUsernameOrEmail(username, email)) {
                session.setAttribute("error", "Tên đăng nhập hoặc email đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/admin/list-users");
                return; // Dừng xử lý ngay lập tức
            }
            
            // 3. Tạo đối tượng User mới
            User newUser = new User(username, password, fullName, email, phone, role);

            // 4. Gọi DAO để thêm người dùng
            boolean success = userDAO.registerUser(newUser);

            // 5. Đặt thông báo và chuyển hướng
            if (success) {
                session.setAttribute("message", "Thêm người dùng mới thành công!");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra, không thể thêm người dùng.");
            }

        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại.");
            e.printStackTrace();
        }

        // 6. Chuyển hướng về trang danh sách người dùng
        response.sendRedirect(request.getContextPath() + "/admin/list-users");
    }
}