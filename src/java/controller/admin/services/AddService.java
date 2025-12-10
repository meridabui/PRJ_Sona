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

@WebServlet("/admin/add-service")
public class AddService extends HttpServlet {
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        // Khởi tạo ServiceDAO khi servlet bắt đầu
        serviceDAO = new ServiceDAO();
    }

    // Hiển thị trang form để thêm dịch vụ
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến trang JSP để hiển thị form
        request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
    }

    // Xử lý dữ liệu được gửi lên từ form
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            // 1. Lấy dữ liệu từ form
            String serviceName = request.getParameter("serviceName");
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");

            // 2. Tạo đối tượng Service từ dữ liệu
            // Dùng constructor không cần serviceId
            Service newService = new Service(serviceName, price, description);

            // 3. Gọi DAO để thêm dịch vụ vào CSDL
            boolean success = serviceDAO.addService(newService);

            // 4. Đặt thông báo và chuyển hướng
            if (success) {
                session.setAttribute("message", "Thêm dịch vụ mới thành công!");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra, không thể thêm dịch vụ.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Giá dịch vụ phải là một con số!");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại.");
            e.printStackTrace();
        }

        // 5. Chuyển hướng về trang danh sách dịch vụ
        response.sendRedirect(request.getContextPath() + "/admin/list-services");
    }
}