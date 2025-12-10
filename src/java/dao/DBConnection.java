package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=KS2;encrypt=false";
    private static final String USER = "sa";
    private static final String PASSWORD = "sa"; 

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Kết nối SQL Server thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Kết nối thất bại: " + e.getMessage());
        }
        return conn;
    }
}
