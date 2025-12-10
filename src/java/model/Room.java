package model;

public class Room {

    private int roomId;
    private String roomName;
    private String roomType;
    private double price;
    private int capacity;
    private String status;
    private String description;
    private String imageUrl;

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public Room() {
    }

    public Room(int roomId, String roomName, String roomType, double price, int capacity, String status, String description, String imageUrl) {
        this.roomId = roomId;
        this.roomName = roomName;
        this.roomType = roomType;
        this.price = price;
        this.capacity = capacity;
        this.status = status;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    public Room(String roomName, String roomType, double price, int capacity, String status, String description, String imageUrl) {
        this.roomName = roomName;
        this.roomType = roomType;
        this.price = price;
        this.capacity = capacity;
        this.status = status;
        this.description = description;
        this.imageUrl = imageUrl;
    }
    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "Room{"
                + "roomId=" + roomId
                + ", roomName='" + roomName + '\''
                + ", roomType='" + roomType + '\''
                + ", price=" + price
                + ", capacity=" + capacity
                + ", status='" + status + '\''
                + ", description='" + description + '\''
                + ", imageUrl='" + imageUrl + '\''
                + '}';
    }
}
