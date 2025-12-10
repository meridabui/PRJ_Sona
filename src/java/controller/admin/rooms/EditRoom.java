package controller.admin.rooms;

import dao.RoomDAO;
import model.Room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/edit-room")
public class EditRoom extends HttpServlet {

    private RoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
    }

    // Lấy dữ liệu cũ và hiển thị ra form edit
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            // 1. Lấy roomId từ parameter trên URL
            int roomId = Integer.parseInt(request.getParameter("roomId"));

            // 2. Gọi DAO để lấy thông tin phòng từ CSDL
            Room room = roomDAO.getRoomById(roomId);

            // 3. Kiểm tra xem phòng có tồn tại không
            if (room != null) {
                // Nếu có, đặt room vào request attribute để JSP có thể truy cập
                request.setAttribute("room", room);
                // Forward đến trang JSP để hiển thị form
                request.getRequestDispatcher("/views/admin/editRoom.jsp").forward(request, response);
            } else {
                // Nếu không tìm thấy phòng, báo lỗi và redirect về trang danh sách
                session.setAttribute("error", "Không tìm thấy phòng để sửa.");
                response.sendRedirect(request.getContextPath() + "/admin/list-rooms");
            }
        } catch (NumberFormatException e) {
            // Bắt lỗi nếu roomId không phải là số
            session.setAttribute("error", "ID phòng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/list-rooms");
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
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String roomName = request.getParameter("roomName");
            String roomType = request.getParameter("roomType");
            double price = Double.parseDouble(request.getParameter("price"));
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            String status = request.getParameter("status");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");

            // 2. Tạo đối tượng Room với thông tin đã cập nhật
            Room updatedRoom = new Room(roomId, roomName, roomType, price,capacity, status, description, imageUrl);

            // 3. Gọi DAO để cập nhật
            boolean success = roomDAO.updateRoom(updatedRoom);

            // 4. Đặt thông báo và chuyển hướng
            if (success) {
                session.setAttribute("message", "Cập nhật thông tin phòng thành công!");
            } else {
                session.setAttribute("error", "Cập nhật phòng thất bại.");
            }

        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại.");
            e.printStackTrace();
        }

        // 5. Chuyển hướng về trang danh sách phòng
        response.sendRedirect(request.getContextPath() + "/admin/list-rooms");
    }
}
