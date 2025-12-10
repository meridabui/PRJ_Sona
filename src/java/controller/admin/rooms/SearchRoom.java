/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin.rooms;

import dao.RoomDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.*;
import model.Room;

/**
 *
 * @author Phong
 */
public class SearchRoom extends HttpServlet {
    private RoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("q");
        response.setContentType("text/html;charset=UTF-8");

        List<Room> rooms;
        if (keyword == null || keyword.isEmpty()) {
            rooms = roomDAO.getAllRooms();
        } else {
            rooms = roomDAO.searchRoomsByKeyword(keyword);
        }

        for (Room room : rooms) {
            response.getWriter().println("<option value='" + room.getRoomId() + "'>" +
                                         room.getRoomName() + "</option>");
        }
    }
}
