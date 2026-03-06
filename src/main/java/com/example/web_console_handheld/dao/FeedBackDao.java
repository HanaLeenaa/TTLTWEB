package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.FeedBack;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class FeedBackDao extends BaseDao {

    public void save(FeedBack f) {

        String sql =
                "INSERT INTO feedback (user_id, content) VALUES (?, ?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, f.getUserId());
            ps.setString(2, f.getContent());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

