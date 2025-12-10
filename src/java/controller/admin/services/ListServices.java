package controller.admin.services;

import dao.ServiceDAO;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/list-services")
public class ListServices extends HttpServlet {
    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        // Khởi tạo ServiceDAO khi servlet bắt đầu
        serviceDAO = new ServiceDAO();
    }

    //Phương thức chính để hiển thị danh sách
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Gọi DAO để lấy danh sách tất cả các dịch vụ
            List<Service> listServices = serviceDAO.getAllServices();

            // 2. Đặt danh sách này vào request attribute
            // Tên "listServices" sẽ được sử dụng trong file JSP
            request.setAttribute("listServices", listServices);

            // 3. Chuyển tiếp (forward) yêu cầu đến file JSP để hiển thị
            request.getRequestDispatcher("/views/admin/listServices.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Có thể chuyển hướng đến trang lỗi
        }
    }
}