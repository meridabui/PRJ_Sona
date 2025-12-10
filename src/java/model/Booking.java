package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

public class Booking {
    private int bookingId;
    private int userId;
    private int roomId;

    private List<Service> services; 

    private Date checkIn;
    private Date checkOut;
    private double totalPrice;
    private String status;
    private Timestamp createdAt;

    private User user;
    private Room room;

    public Booking() {
        this.services = new ArrayList<>();
    }

    public List<Service> getServices() {
        return services;
    }

    public void setServices(List<Service> services) {
        this.services = services;
    }

    public User getUser() {
        return user;
    }

    public Booking(int bookingId, int userId, int roomId, List<Service> services, Date checkIn, Date checkOut, double totalPrice, String status, Timestamp createdAt, User user, Room room) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.roomId = roomId;
        this.services = services;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.totalPrice = totalPrice;
        this.status = status;
        this.createdAt = createdAt;
        this.user = user;
        this.room = room;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public void setCheckIn(Date checkIn) {
        this.checkIn = checkIn;
    }

    public void setCheckOut(Date checkOut) {
        this.checkOut = checkOut;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getBookingId() {
        return bookingId;
    }

    public int getUserId() {
        return userId;
    }

    public int getRoomId() {
        return roomId;
    }

    public Date getCheckIn() {
        return checkIn;
    }

    public Date getCheckOut() {
        return checkOut;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }
}