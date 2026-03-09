package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Admin;
import com.example.web_console_handheld.utils.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDao {
    public Admin login(String username, String password) {
        String sql = "Select * from admin where username=?";

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)){

            ps.setString(1, username);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String pass = rs.getString("password");

                    if (BCrypt.checkpw(password, pass)) {
                        return new Admin(
                                rs.getInt("ID"),
                                rs.getString("username"),
                                pass,
                                rs.getString("fullname")
                        );

                    }
                }
            } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
