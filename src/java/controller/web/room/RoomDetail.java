package controller.web.room;

import dao.RoomDAO;
import model.Room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/room-detail")
public class RoomDetail extends HttpServlet {
    private RoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("id"));

            Room room = roomDAO.getRoomById(roomId);

            if (room != null) {
                request.setAttribute("room", room);
                request.getRequestDispatcher("/views/rooms/roomDetail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy thông tin phòng.");
                response.sendRedirect(request.getContextPath() + "/list-rooms");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/list-rooms");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "views/404/error.jsp");
        }
    }
}