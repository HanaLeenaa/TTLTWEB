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

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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
        DELETE FROM
        user_vouchers
        WHERE user_id = ? AND
                voucher_id = ?
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

    //lấy danh sách vouchers hiển thị lên trang quản lý voucher của admin
    public List<Voucher> getAllVouchers() {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT *  FROM vouchers ORDER BY created_at DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
                v.setCreated_at(rs.getTimestamp("created_at"));
                vouchers.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    //chức năng sửa (Khóa/Hoạt động) trạng thái voucher
    public boolean toggleVoucherStatus(int voucherId) {
        String sql = """
            UPDATE vouchers
            SET active = CASE
                WHEN active = 1 THEN 0
                ELSE 1
            END
            WHERE ID = ?
            """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
           e.printStackTrace();
        }
        return  false;
    }

    //thêm voucher
    public boolean insertVoucher(Voucher v) {
        String sql = """
                INSERT INTO vouchers
                (
                            code,
                            name,
                            discount_type,
                            discount_value,
                            min_order_amount,
                            max_discount,
                            quantity,
                            start_date,
                            end_date,
                            active
                        )
                VALUES (?,?,?,?,?,?,?,?,?,?)
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getName());
            ps.setString(3, v.getDiscount_type());
            ps.setBigDecimal(4, v.getDiscount_value());
            ps.setBigDecimal(5, v.getMin_order_amount());

            if(v.getMax_discount() == null){
                ps.setNull(6, java.sql.Types.DECIMAL);
            }else{
                ps.setBigDecimal(6, v.getMax_discount());
            }

            ps.setInt(7, v.getQuantity());
            ps.setTimestamp(8, v.getStart_date());
            ps.setTimestamp(9, v.getEnd_date());
            ps.setBoolean(10, v.isActive());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //Sửa voucher
    public boolean updateVoucher(Voucher v) {
        String sql = """
                UPDATE vouchers
                SET code = ?,
                    name = ?,
                    discount_type = ?,
                    discount_value = ?,
                    min_order_amount = ?,
                    max_discount = ?,
                    quantity = ?,
                    start_date = ?,
                    end_date = ?,
                    active = ?
                WHERE ID = ?
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getName());
            ps.setString(3, v.getDiscount_type());
            ps.setBigDecimal(4, v.getDiscount_value());
            ps.setBigDecimal(5, v.getMin_order_amount());

            if (v.getMax_discount() == null){
                ps.setNull(6, java.sql.Types.DECIMAL);
            } else{
                ps.setBigDecimal(6, v.getMax_discount());
            }

            ps.setInt(7, v.getQuantity());
            ps.setTimestamp(8, v.getStart_date());
            ps.setTimestamp(9, v.getEnd_date());
            ps.setBoolean(10, v.isActive());
            ps.setInt(11, v.getID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // tìm kiếm, lọc hoặc kết hợp cả 2
    public List<Voucher> searchAndFilterVoucher(String keyword, String status, String type, String fromDate, String toDate) {
        List<Voucher> vouchers = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM vouchers WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        //tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (code LIKE ? OR name LIKE ?) ");

            String search = "%" + keyword + "%";
            params.add(search);
            params.add(search);
        }

        //trạng thái
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND active = ? ");
            params.add(Boolean.parseBoolean(status));
        }

        //loại voucher (PERCENT / FIXED)
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND discount_type = ? ");
            params.add(type);
        }

        // từ ngày
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND start_date >= ? ");
            params.add(fromDate);
        }

        //đến ngày
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND start_date <= ? ");
            params.add(toDate);
        }
        sql.append(" ORDER BY created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Voucher voucher = new Voucher();

                voucher.setID(rs.getInt("ID"));
                voucher.setCode(rs.getString("code"));
                voucher.setName(rs.getString("name"));
                voucher.setDiscount_type(rs.getString("discount_type"));
                voucher.setDiscount_value(rs.getBigDecimal("discount_value"));
                voucher.setMin_order_amount(rs.getBigDecimal("min_order_amount"));
                voucher.setMax_discount(rs.getBigDecimal("max_discount"));
                voucher.setQuantity(rs.getInt("quantity"));
                voucher.setStart_date(rs.getTimestamp("start_date"));
                voucher.setEnd_date(rs.getTimestamp("end_date"));
                voucher.setActive(rs.getBoolean("active"));
                voucher.setCreated_at(rs.getTimestamp("created_at"));
                vouchers.add(voucher);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    public boolean existsByCode(String code) {
        String sql = "SELECT COUNT(*) FROM vouchers WHERE code = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
