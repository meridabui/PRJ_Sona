

package controller.admin.users;

import dao.UserDAO;
import model.User;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.*;


public class UserSearch extends HttpServlet {
   
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            response.setContentType("text/html;charset=UTF-8");

            String searchKeyword = request.getParameter("search");
            List<User> listUsers;

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                listUsers = userDAO.searchUsersByKeyword(searchKeyword);
            } else {
                listUsers = userDAO.getAllUsers();
            }

            PrintWriter out = response.getWriter();
            StringBuilder optionsHtml = new StringBuilder();

            if (listUsers == null || listUsers.isEmpty()) {
                optionsHtml.append("<option value='' disabled selected>-- Không tìm thấy khách hàng --</option>");
            } else {
                optionsHtml.append("<option value='' disabled selected>-- Chọn một khách hàng --</option>");
                for (User user : listUsers) {
                    optionsHtml.append("<option value='").append(user.getUserId()).append("'>")
                               .append(user.getFullName())
                               .append("</option>");
                }
            }
            out.print(optionsHtml.toString());
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("<option value='' disabled selected>-- Có lỗi xảy ra --</option>");
        }
    }
}
