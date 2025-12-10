package dao;

import model.Service;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    // 1.Lấy tất cả dịch vụ
    public List<Service> getAllServices() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM Services";

        try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Service service = new Service(
                        rs.getInt("service_id"),
                        rs.getString("service_name"),
                        rs.getDouble("price"),
                        rs.getString("description")
                );
                services.add(service);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    // 2.Lấy dịch vụ theo ID
    public Service getServiceById(int id) {
        Service service = null;
        String sql = "SELECT * FROM Services WHERE service_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                service = new Service(
                        rs.getInt("service_id"),
                        rs.getString("service_name"),
                        rs.getDouble("price"),
                        rs.getString("description")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return service;
    }

    // 3.Thêm dịch vụ mới
    public boolean addService(Service service) {
        String sql = "INSERT INTO Services (service_name, price, description) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, service.getServiceName());
            ps.setDouble(2, service.getPrice());
            ps.setString(3, service.getDescription());

            return ps.executeUpdate() > 0;  // trả về true nếu thêm thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4.Cập nhật thông tin dịch vụ
    public boolean updateService(Service service) {
        String sql = "UPDATE Services SET service_name = ?, price = ?, description = ? WHERE service_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, service.getServiceName());
            ps.setDouble(2, service.getPrice());
            ps.setString(3, service.getDescription());
            ps.setInt(4, service.getServiceId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5.Xóa dịch vụ
    public boolean deleteService(int id) {
        String sql = "DELETE FROM Services WHERE service_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //6. đếm số lượng dịch vụ 
    public int countServices() {
        String sql = "SELECT COUNT(*) FROM Services";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
