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

@WebServlet("/admin/add-room")
public class AddRoom extends HttpServlet {

    private RoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
    }

    // Hiển thị trang form để thêm phòng
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/addRoom.jsp").forward(request, response);
    }

    //  Xử lý dữ liệu được gửi lên từ form
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        request.setCharacterEncoding("UTF-8");
//        HttpSession session = request.getSession();
//
//        try {
//            // 1. Lấy dữ liệu từ form
//            String roomName = request.getParameter("roomName");
//            String roomType = request.getParameter("roomType");
//            double price = Double.parseDouble(request.getParameter("price"));
//            int capacity = Integer.parseInt(request.getParameter("capacity"));
//            String addRoomType = request.getParameter("addRoomType");
//
//            String status = request.getParameter("status");
//            String description = request.getParameter("description");
//            String imageUrl = request.getParameter("imageUrl");
//
//            // Nếu người dùng có nhập loại phòng mới → dùng nó thay cho roomType
//            if (addRoomType != null && !addRoomType.trim().isEmpty()) {
//                roomType = addRoomType.trim();
//            }
//
//            // 2. Tạo đối tượng Room từ dữ liệu
//            // Dùng constructor không cần roomId vì ID sẽ tự động tăng trong CSDL
//            Room newRoom = new Room(roomName, roomType, price, capacity, status, description, imageUrl);
//
//            // 3. Gọi DAO để thêm phòng vào CSDL
//            boolean success = roomDAO.addRoom(newRoom);
//
//            // 4. Đặt thông báo và chuyển hướng
//            if (success) {
//                session.setAttribute("message", "Thêm phòng mới thành công!");
//            } else {
//                session.setAttribute("error", "Có lỗi xảy ra, không thể thêm phòng.");
//            }
//
//        } catch (NumberFormatException e) {
//            // Bắt lỗi nếu người dùng nhập giá không phải là số
//            session.setAttribute("error", "Giá phòng phải là một con số!");
//            e.printStackTrace();
//        } catch (Exception e) {
//            session.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại.");
//            e.printStackTrace();
//        }
//        // 5. Chuyển hướng về trang danh sách phòng sau khi xử lý xong
//        // Sử dụng pattern Post-Redirect-Get để tránh lỗi double-submission
//        response.sendRedirect(request.getContextPath() + "/admin/list-rooms");
//    }
    request.setCharacterEncoding("UTF-8");
    HttpSession session = request.getSession();

    try {
        String roomName = request.getParameter("roomName");
        String roomType = request.getParameter("roomType");
        String addRoomType = request.getParameter("addRoomType");

        // Ưu tiên loại phòng mới
        if (addRoomType != null && !addRoomType.trim().isEmpty()) {
            roomType = addRoomType.trim();
        }

        double price = Double.parseDouble(request.getParameter("price"));
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        String status = request.getParameter("status");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");

        Room newRoom = new Room(roomName, roomType, price, capacity, status, description, imageUrl);

        boolean success = roomDAO.addRoom(newRoom);

        if (success) {
            session.setAttribute("message", "Thêm phòng mới thành công!");
        } else {
            session.setAttribute("error", "Có lỗi xảy ra, không thể thêm phòng.");
        }

    } catch (NumberFormatException e) {
        session.setAttribute("error", "Giá phòng hoặc số lượng phải là số hợp lệ!");
        e.printStackTrace();
    } catch (Exception e) {
        session.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại.");
        e.printStackTrace();
    }

    response.sendRedirect(request.getContextPath() + "/admin/list-rooms");
    }
}
