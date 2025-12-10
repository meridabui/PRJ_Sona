package controller.admin.users;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/list-users")
public class ListUser extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        // Khởi tạo UserDAO khi servlet bắt đầu
        userDAO = new UserDAO();
    }

@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy từ khóa tìm kiếm từ request
            String searchKeyword = request.getParameter("search");
            List<User> listUsers;

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                // Nếu có từ khóa, gọi phương thức tìm kiếm
                listUsers = userDAO.searchUsersByKeyword(searchKeyword);
            } else {
                listUsers = userDAO.getAllUsers();
            }

            // Đặt danh sách vào request attribute để JSP có thể sử dụng
            request.setAttribute("listUsers", listUsers);

            // Chuyển tiếp đến trang JSP
            request.getRequestDispatcher("/views/admin/listUsers.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}