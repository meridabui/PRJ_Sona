package filter.web;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebFilter(urlPatterns = {"/booking/*", "/rooms/book", "/user/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Lấy session hiện tại
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // Nếu chưa đăng nhập
        if (currentUser == null) {
            // Lưu URL hiện tại để sau khi login có thể quay lại
            String redirectUrl = req.getContextPath() + "/views/login/login.jsp";
            resp.sendRedirect(redirectUrl);
            return;
        }

        // Nếu đã đăng nhập, cho phép đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
