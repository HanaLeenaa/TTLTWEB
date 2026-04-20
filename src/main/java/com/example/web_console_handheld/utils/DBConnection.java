package com.example.web_console_handheld.utils;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {
    private static String url;
    private static String user;
    private static String pass;

    static {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                System.out.println("Xin lỗi, không tìm thấy file db.properties");
            } else {
                prop.load(input);
                // Lấy thông tin từ file db.properties
                String host = prop.getProperty("db.host");
                String port = prop.getProperty("db.port");
                String dbname = prop.getProperty("db.dbname");
                String option = prop.getProperty("db.option");

                url = "jdbc:mysql://" + host + ":" + port + "/" + dbname + "?" + option;
                user = prop.getProperty("db.username");
                pass = prop.getProperty("db.password");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver MySQL không tìm thấy", e);
        }
        return DriverManager.getConnection(url, user, pass);
    }
}
