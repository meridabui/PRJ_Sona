package filter.web;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

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

        // Kiểm tra quyền truy cập
        if (currentUser == null) {
            // Chưa đăng nhập, chuyển đến trang login
            resp.sendRedirect(req.getContextPath() + "/views/login/login.jsp");
            return;
        } else if (!"admin".equalsIgnoreCase(currentUser.getRole())) {
            // Không phải admin, chặn lại
            resp.sendRedirect(req.getContextPath() + "/views/home/home.jsp");
            return;
        }

        // Nếu là admin, cho phép truy cập tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Không cần xử lý khi filter bị hủy
    }
}
