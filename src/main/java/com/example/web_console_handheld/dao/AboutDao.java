package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.About;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AboutDao {

    public List<About> getBySection(String section) {

        List<About> list = new ArrayList<>();

        String sql = "SELECT id, section, title, description, image, icon " +
                "FROM about " +
                "WHERE section = ? " +
                "ORDER BY sort_order";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, section);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    About a = new About();
                    a.setId(rs.getInt("id"));
                    a.setSection(rs.getString("section"));
                    a.setTitle(rs.getString("title"));
                    a.setDescription(rs.getString("description"));
                    a.setImage(rs.getString("image"));
                    a.setIcon(rs.getString("icon"));
                    list.add(a);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
