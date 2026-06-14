package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Voucher;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VoucherDao {
    private Connection conn;

    public VoucherDao() {
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
//lấy tất cả voucher hợp lệ
    public List<Voucher> getAvailableVouchers(int userId, double orderTotal) {
        List<Voucher> list = new ArrayList<>();
        String sql = """
                SELECT *
                FROM vouchers v
                WHERE active = 1
                AND quantity > 0
                AND NOW() BETWEEN start_date AND end_date
                AND min_order_amount <= ?
                AND NOT EXISTS (
                    SELECT 1
                    FROM user_vouchers uv
                    WHERE uv.user_id = ?
                    AND uv.voucher_id = v.ID
                )
                """;

        try (
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, orderTotal);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Voucher v = new Voucher();

                v.setID(rs.getInt("ID"));
                v.setCode(rs.getString("code"));
                v.setName(rs.getString("name"));
                v.setDiscount_type(rs.getString("discount_type"));
                v.setDiscount_value(rs.getBigDecimal("discount_value"));
                v.setMin_order_amount(rs.getBigDecimal("min_order_amount"));
                v.setMax_discount(rs.getBigDecimal("max_discount"));
                v.setQuantity(rs.getInt("quantity"));
                v.setStart_date(rs.getTimestamp("start_date"));
                v.setEnd_date(rs.getTimestamp("end_date"));
                list.add(v);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Voucher getVoucherById(int voucherId) {
        String sql = "SELECT *  FROM vouchers WHERE ID = ?";

        try  (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Voucher v = new Voucher();
                v.setID(rs.getInt("ID"));
                v.setCode(rs.getString("code"));
                v.setName(rs.getString("name"));
                v.setDiscount_type(rs.getString("discount_type"));
                v.setDiscount_value(rs.getBigDecimal("discount_value"));
                v.setMin_order_amount(rs.getBigDecimal("min_order_amount"));
                v.setMax_discount(rs.getBigDecimal("max_discount"));
                v.setQuantity(rs.getInt("quantity"));
                v.setStart_date(rs.getTimestamp("start_date"));
                v.setEnd_date(rs.getTimestamp("end_date"));
                v.setActive(rs.getBoolean("active"));
                return v;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //giảm số lượng voucher khi Order thành công
    public boolean decreaseQuantity(int voucherId) {
        String sql = "UPDATE vouchers SET quantity = quantity - 1 WHERE ID = ? AND quantity > 0";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lưu voucher user đã dùng
    public boolean insertUserVoucher(int userId, int voucherId) {
        String sql = """
        INSERT INTO user_vouchers(user_id, voucher_id)
        VALUES (?, ?)
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, voucherId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // rollback voucher khi hủy đơn
    public boolean increaseQuantity(int voucherId) {
        String sql = """
        UPDATE vouchers
        SET quantity = quantity + 1
        WHERE ID = ?
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, voucherId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    //kiểm tra voucher đã dùng => 1 user chỉ được dùng 1 voucher/ 1 lần
    public boolean hasUsedVoucher(int userId, int voucherId) {
        String sql = """
        SELECT 1
        FROM user_vouchers
        WHERE user_id = ? AND voucher_id = ?
        LIMIT 1;
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, voucherId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // xóa lịch sử dùng voucher khi hủy đơn => hủy đơn có thể hoàn voucher dùng lại lần nữa
    public boolean removeUserVoucher(int userId, int voucherId) {
        String sql = """
        DELETE FROM user_vouchers
        WHERE user_id = ? AND voucher_id = ?
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, voucherId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
