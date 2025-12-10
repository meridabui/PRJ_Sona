package controller.admin.services;

import dao.ServiceDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/delete-service")
public class DeleteService extends HttpServlet {
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
    }

    // Chỉ cần xử lý POST request cho hành động xóa
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // 1. Lấy serviceId từ hidden input của form
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));

            // 2. Gọi DAO để thực hiện xóa
            boolean success = serviceDAO.deleteService(serviceId);

            // 3. Đặt thông báo kết quả vào session
            if (success) {
                session.setAttribute("message", "Xóa dịch vụ thành công!");
            } else {
                session.setAttribute("error", "Xóa dịch vụ thất bại. Có thể dịch vụ đang được sử dụng trong một đơn đặt phòng.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID dịch vụ không hợp lệ.");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi hệ thống khi xóa dịch vụ.");
            e.printStackTrace();
        }

        // 4. Chuyển hướng về trang danh sách dịch vụ
        response.sendRedirect(request.getContextPath() + "/admin/list-services");
    }
}