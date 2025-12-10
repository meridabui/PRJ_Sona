package controller.web.login;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/register")
public class Register extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/login/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form đăng ký
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        UserDAO userDAO = new UserDAO();

        // Kiểm tra trùng username hoặc email
        if (userDAO.existsByUsernameOrEmail(username, email)) {
            request.setAttribute("error", "Tên đăng nhập hoặc email đã tồn tại!");
            request.getRequestDispatcher("/views/login/register.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng User mới
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole("user"); // mặc định là user

        // Lưu vào DB
        boolean success = userDAO.registerUser(user);

        if (success) {
            request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("/views/login/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại!");
            request.getRequestDispatcher("/views/login/register.jsp").forward(request, response);
        }
    }
}
