package controller.admin.services;

import dao.ServiceDAO;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/edit-service")
public class EditService extends HttpServlet {
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
    }

    // Lấy dữ liệu cũ và hiển thị ra form edit
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            // 1. Lấy serviceId từ parameter trên URL
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));

            // 2. Gọi DAO để lấy thông tin dịch vụ từ CSDL
            Service service = serviceDAO.getServiceById(serviceId);

            // 3. Kiểm tra xem dịch vụ có tồn tại không
            if (service != null) {
                request.setAttribute("service", service);
                request.getRequestDispatcher("/views/admin/editService.jsp").forward(request, response);
            } else {
                session.setAttribute("error", "Không tìm thấy dịch vụ để sửa.");
                response.sendRedirect(request.getContextPath() + "/admin/list-services");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID dịch vụ không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/list-services");
        }
    }

    // Nhận dữ liệu đã sửa và cập nhật vào CSDL
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            // 1. Lấy toàn bộ dữ liệu từ form
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String serviceName = request.getParameter("serviceName");
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");

            // 2. Tạo đối tượng Service với thông tin đã cập nhật
            Service updatedService = new Service(serviceId, serviceName, price, description);

            // 3. Gọi DAO để cập nhật
            boolean success = serviceDAO.updateService(updatedService);

            // 4. Đặt thông báo và chuyển hướng
            if (success) {
                session.setAttribute("message", "Cập nhật thông tin dịch vụ thành công!");
            } else {
                session.setAttribute("error", "Cập nhật dịch vụ thất bại.");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại.");
            e.printStackTrace();
        }

        // 5. Chuyển hướng về trang danh sách dịch vụ
        response.sendRedirect(request.getContextPath() + "/admin/list-services");
    }
}