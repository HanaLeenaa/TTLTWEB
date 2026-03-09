package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {

    // save order
    public int saveOrder(Order order) {

        int orderId = -1;

        String sql =
                "INSERT INTO orders " +
                        "(user_id, createAt, status, price, receiver_name, receiver_phone, receiver_address, receiver_email, payment_method) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps =
                        conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {

            ps.setInt(1, order.getUser_Id());
            ps.setTimestamp(2, order.getCreateAt());
            ps.setString(3, order.getStatus());
            ps.setLong(4, order.getPrice());

            ps.setString(5, order.getReceiver_name());
            ps.setString(6, order.getReceiver_phone());
            ps.setString(7, order.getReceiver_address());
            ps.setString(8, order.getReceiver_email());

            // false = COD, true = BANK
            ps.setBoolean(9, order.isPayment_method());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderId;
    }


    // save order items
    public void saveOrderItems(int orderId, List<OrderItem> items) {

        String sql =
                "INSERT INTO order_items " +
                        "(order_id, product_id, product_name, product_price, quantity) " +
                        "VALUES (?, ?, ?, ?, ?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            for (OrderItem item : items) {
                ps.setInt(1, orderId);
                ps.setInt(2, item.getProduct_id());
                ps.setString(3, item.getProduct_name());
                ps.setLong(4, item.getProduct_price());
                ps.setInt(5, item.getQuantity());
                ps.addBatch();
            }

            ps.executeBatch();
            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }



    // get order by id
    public Order getOrderById(int orderId) {

        Order order = null;

        String sql = "SELECT * FROM orders WHERE ID = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new Order();

                    order.setID(rs.getInt("ID"));
                    order.setUser_Id(rs.getInt("user_id"));
                    order.setCreateAt(rs.getTimestamp("createAt"));
                    order.setStatus(rs.getString("status"));
                    order.setPrice(rs.getLong("price"));

                    order.setReceiver_name(rs.getString("receiver_name"));
                    order.setReceiver_phone(rs.getString("receiver_phone"));
                    order.setReceiver_address(rs.getString("receiver_address"));
                    order.setReceiver_email(rs.getString("receiver_email"));

                    order.setPayment_method(rs.getBoolean("payment_method"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return order;
    }


    // ================= DANH SÁCH ĐƠN HÀNG =================
    public List<Order> getAllOrders() {

        List<Order> list = new ArrayList<>();

        String sql = "SELECT * FROM orders ORDER BY createAt DESC";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                Order order = new Order();

                order.setID(rs.getInt("ID"));
                order.setUser_Id(rs.getInt("user_id"));
                order.setCreateAt(rs.getTimestamp("createAt"));
                order.setStatus(rs.getString("status"));
                order.setPrice(rs.getLong("price"));

                order.setReceiver_name(rs.getString("receiver_name"));
                order.setReceiver_phone(rs.getString("receiver_phone"));
                order.setReceiver_address(rs.getString("receiver_address"));
                order.setReceiver_email(rs.getString("receiver_email"));
                order.setPayment_method(rs.getBoolean("payment_method"));

                list.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // ================= CHI TIẾT ĐƠN HÀNG =================
    public Order getOrderByIdAdmin(int id) {

        Order order = null;
        String sql = "SELECT * FROM orders WHERE ID = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                order = new Order();

                order.setID(rs.getInt("ID"));
                order.setUser_Id(rs.getInt("user_id"));
                order.setCreateAt(rs.getTimestamp("createAt"));
                order.setStatus(rs.getString("status"));
                order.setPrice(rs.getLong("price"));

                order.setReceiver_name(rs.getString("receiver_name"));
                order.setReceiver_phone(rs.getString("receiver_phone"));
                order.setReceiver_address(rs.getString("receiver_address"));
                order.setReceiver_email(rs.getString("receiver_email"));
                order.setPayment_method(rs.getBoolean("payment_method"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return order;
    }


    // ================= SẢN PHẨM TRONG ĐƠN =================
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {

        List<OrderItem> list = new ArrayList<>();

        String sql = """
        SELECT 
            oi.ID,
            oi.order_id,
            oi.product_id,
            p.name AS product_name,
            oi.product_price,
            oi.quantity
        FROM order_items oi
        JOIN products p ON oi.product_id = p.ID
        WHERE oi.order_id = ?
    """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setProduct_id(rs.getInt("product_id"));
                item.setProduct_name(rs.getString("product_name"));
                item.setProduct_price(rs.getLong("product_price"));
                item.setQuantity(rs.getInt("quantity"));
                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // ================= UPDATE TRẠNG THÁI =================
    public void updateStatus(int orderId, String status) {

        String sql = "UPDATE orders SET status = ? WHERE ID = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public double getTotalRevenue() {
        double total = 0;
        String sql = "SELECT COALESCE(SUM(total_price),0) FROM orders WHERE status = 'COMPLETED'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                total = rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }
    public List<Order> getRecentOrders(int limit) {
        List<Order> list = new ArrayList<>();

        String sql = """
        SELECT o.id, u.fullname, o.status
        FROM orders o
        JOIN users u ON o.user_id = u.id
        ORDER BY o.created_at DESC
        LIMIT ?
    """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();
                o.setID(rs.getInt("id"));
                o.setReceiver_email(rs.getString("fullname"));
                o.setStatus(rs.getString("status"));
                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public List<Order> getOrdersByUserId(int userId) {

        List<Order> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM orders
        WHERE user_id = ?
        ORDER BY createAt DESC
    """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();

                order.setID(rs.getInt("ID"));
                order.setUser_Id(rs.getInt("user_id"));
                order.setCreateAt(rs.getTimestamp("createAt"));
                order.setStatus(rs.getString("status"));
                order.setPrice(rs.getLong("price"));

                order.setReceiver_name(rs.getString("receiver_name"));
                order.setReceiver_phone(rs.getString("receiver_phone"));
                order.setReceiver_address(rs.getString("receiver_address"));
                order.setReceiver_email(rs.getString("receiver_email"));

                order.setPayment_method(rs.getBoolean("payment_method"));

                list.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
