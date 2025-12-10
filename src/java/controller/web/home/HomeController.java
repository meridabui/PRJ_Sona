package controller.web.home; // Hoặc package tương ứng

import dao.RoomDAO;
import model.Room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"", "/home"})
public class HomeController extends HttpServlet {
    private RoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            
            List<Room> featuredRooms = roomDAO.getFeaturedRooms(3);
            request.setAttribute("featuredRooms", featuredRooms);
            
            request.getRequestDispatcher("/views/home/home.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}