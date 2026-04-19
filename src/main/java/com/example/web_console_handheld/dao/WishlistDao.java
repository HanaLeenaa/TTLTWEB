package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDao extends BaseDao{

    // Thêm sản phẩm vào wishlist
    public boolean addWishlist(int userId, int productId) {
        String sql = "INSERT INTO wishlist(user_id, product_id, created_at) VALUES (?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa sản phẩm khỏi wishlist
    public boolean removeWishlist(int userId, int productId) {
        String sql = "DELETE FROM wishlist WHERE user_id=? AND product_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy danh sách productId trong wishlist của user
    public List<Integer> getWishlistByUser(int userId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT product_id FROM wishlist WHERE user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("product_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Kiểm tra sản phẩm đã có trong wishlist chưa
    public boolean exists(int userId, int productId) {
        String sql = "SELECT 1 FROM wishlist WHERE user_id=? AND product_id=? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
