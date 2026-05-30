package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.StockMovement;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ImportHistoryDao {
    public List<StockMovement> getImportHistory() {
        List<StockMovement> list = new ArrayList<>();

        String sql = """
            
            Select sm.*, p.name AS product_name, a.username AS admin_name
            From stock_movements sm
            Join products p ON sm.product_id = p.ID
            Join admin a ON a.ID = sm.user_id
            Order by sm.ID 
            """;

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery ()

        ){
        while (rs.next()){
            StockMovement m = new StockMovement();
            m.setID(rs.getInt("ID"));
            m.setProduct_id(rs.getInt("product_id"));
            m.setProductName(rs.getString("product_name"));
            m.setQuantity(rs.getInt("quantity"));
            m.setType(rs.getString("type"));
            m.setCreatedAt(rs.getTimestamp("created_at"));
            m.setUser_id(rs.getInt("user_id"));
            m.setUserName(rs.getString("admin_name"));
            list.add(m);
        }
    }catch (Exception e) {
            e.printStackTrace();
        }
        return list;
}
}
