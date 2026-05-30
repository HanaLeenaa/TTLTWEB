package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {

    // save order
    public int saveOrder(Order order) {

        int orderId = -1;

        String sql =
                "INSERT INTO orders " +
                        "(user_id, order_date, status, total_amount, fullname_order, phone_order, address_order, email_order, note) " +
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
            ps.setString(9, order.getReceiver_note());


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
                        "(order_id, product_id, quantity, price_at_purchase, product_image) " +
                        "VALUES (?, ?, ?, ?, ?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            for (OrderItem item : items) {
                ps.setInt(1, orderId);
                ps.setInt(2, item.getProduct_id());
                ps.setInt(3, item.getQuantity());
                ps.setLong(4, item.getProduct_price());
                ps.setString(5, item.getProduct_image());
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
                    order.setCreateAt(rs.getTimestamp("order_date"));
                    order.setStatus(rs.getString("status"));
                    order.setPrice(rs.getLong("total_amount"));

                    order.setReceiver_name(rs.getString("fullname_order"));
                    order.setReceiver_phone(rs.getString("phone_order"));
                    order.setReceiver_address(rs.getString("address_order"));
                    order.setReceiver_email(rs.getString("email_order"));
                    order.setReceiver_note(rs.getString("note"));
                    order.setPayment_method(rs.getString("payment_method"));
                    order.setPayment_status(rs.getString("payment_status"));
                    order.setTransaction_no(rs.getString("transaction_no"));
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

        String sql = "SELECT * FROM orders ORDER BY order_date DESC";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                Order order = new Order();

                order.setID(rs.getInt("ID"));
                order.setUser_Id(rs.getInt("user_id"));
                order.setCreateAt(rs.getTimestamp("order_date"));
                order.setStatus(rs.getString("status"));
                order.setPrice(rs.getLong("total_amount"));

                order.setReceiver_name(rs.getString("fullname_order"));
                order.setReceiver_phone(rs.getString("phone_order"));
                order.setReceiver_address(rs.getString("address_order"));
                order.setReceiver_email(rs.getString("email_order"));
                order.setPayment_method(rs.getString("payment_method"));
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
                order.setPayment_method(rs.getString("payment_method"));
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
            oi.price_at_purchase,
            oi.quantity,
            oi.product_image
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
                item.setProduct_price(rs.getLong("price_at_purchase"));
                item.setQuantity(rs.getInt("quantity"));
                item.setProduct_image(rs.getString("product_image"));
                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // ================= UPDATE TRẠNG THÁI =================
    public boolean updateStatus(int orderId, String newStatus) {

        String getSql = "SELECT status FROM orders WHERE ID = ?";
        String sql = "UPDATE orders SET status = ? WHERE ID = ?";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(getSql)
        ) {

            //lấy status hiện tại của đơn hàng
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return false;//Không tìm thấy đơn hàng
            }

            String currentStatus = rs.getString("status").trim();
            if (!isValidTransition(currentStatus, newStatus)) {
                return false;
            }

            // update
            try (PreparedStatement updatePs = conn.prepareStatement(sql)) {

                updatePs.setString(1, newStatus);
                updatePs.setInt(2, orderId);
                return updatePs.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean isValidTransition(String current, String next) {

        switch (current) {
            case "Chờ xác nhận":
                return next.equals("Đã xác nhận")
                        || next.equals("Đã huỷ");

            case "Đã xác nhận":
                return next.equals("Đang giao")
                        || next.equals("Đã huỷ");

            case "Đang giao":
                return next.equals("Đã giao");

            case "Đã giao":
                return false;

            case "Đã huỷ":
                return false;

                default:
                return false;

        }
    }

    public double getTotalRevenue() {
        double total = 0;
        String sql = "SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE status = 'Đã giao'";

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
        SELECT o.ID, o.fullname_order, o.status
        FROM orders o
        JOIN users u ON o.user_id = u.id
        ORDER BY o.order_date DESC
        LIMIT ?
    """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();
                o.setID(rs.getInt("ID"));
                o.setReceiver_name(rs.getString("fullname_order"));
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
                order.setCreateAt(rs.getTimestamp("order_date"));
                order.setStatus(rs.getString("status"));
                order.setPrice(rs.getLong("total_amount"));
                order.setReceiver_name(rs.getString("fullname_order"));
                order.setReceiver_phone(rs.getString("phone_order"));
                order.setReceiver_address(rs.getString("address_order"));
                order.setReceiver_email(rs.getString("email_order"));
                order.setPayment_method(rs.getString("payment_method"));

                list.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //lọc đơn hàng ở trang admin
    public List<Order> searchOrders(String keyword, String status, String fromDate, String toDate, String minPrice, String maxPrice) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM orders WHERE 1=1 ");

        //search theo tên, ID, sđt
        if (keyword != null && !keyword.isEmpty()) {
            keyword = keyword.replace("#", "").trim();

            if (keyword.matches("\\d{1,6}")) {
                // ID
                sql.append(" AND ID = ?");
            }
            else if (keyword.matches("\\d{8,11}")) {
                // SĐT
                sql.append(" AND phone_order LIKE ?");
            }
            else {
                // Tên
                sql.append(" AND fullname_order LIKE ?");
            }
        }

        //STATUS
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }

        //date
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND DATE(order_date) >= ?");
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND DATE(order_date) <= ?");
        }

        //price
        if (minPrice != null && !minPrice.isEmpty()) {
            sql.append(" AND total_amount >= ?");
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
            sql.append(" AND total_amount <= ?");
        }

        //sort
        sql.append(" ORDER BY order_date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            if (keyword != null && !keyword.isEmpty()) {
                keyword = keyword.replace("#", "").trim();

                if (keyword.matches("\\d{1,6}")) {
                    ps.setInt(i++, Integer.parseInt(keyword));
                }
                else if (keyword.matches("\\d{8,11}")) {
                    ps.setString(i++, "%" + keyword + "%");
                }
                else {
                    ps.setString(i++, "%" + keyword + "%");
                }
            }

            if (status != null && !status.isEmpty()) {
                ps.setString(i++, status);
            }

            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(i++, fromDate);
            }

            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(i++, toDate);
            }

            if (minPrice != null && !minPrice.isEmpty()) {
                ps.setLong(i++, Long.parseLong(minPrice));
            }

            if (maxPrice != null && !maxPrice.isEmpty()) {
                ps.setLong(i++, Long.parseLong(maxPrice));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setID(rs.getInt("ID"));
                o.setReceiver_name(rs.getString("fullname_order"));
                o.setReceiver_phone(rs.getString("phone_order"));
                o.setPrice(rs.getLong("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setCreateAt(rs.getTimestamp("order_date"));
                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //transaction check stock khi đặt hàng
    public boolean createOrderTransaction(Order order, List<OrderItem> items) {

        String insertOrderSql = """
        INSERT INTO orders(
            user_id,
            order_date,
            status,
            total_amount,
            fullname_order,
            phone_order,
            address_order,
            email_order,
            note,
            payment_method,
            payment_status,
            transaction_no
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        String insertItemSql = """
        INSERT INTO order_items(
            order_id,
            product_id,
            quantity,
            price_at_purchase,
            product_image
        )
        VALUES (?, ?, ?, ?, ?)
        """;

        String updateStockSql = """
        UPDATE products
        SET stock = stock - ?
        WHERE ID = ?
        AND stock >= ?
        """;

        Connection conn = null;

        try {

            conn = DBConnection.getConnection();

            // START TRANSACTION
            conn.setAutoCommit(false);

            int orderId;

            // INSERT ORDER
            try (
                    PreparedStatement ps =
                            conn.prepareStatement(
                                    insertOrderSql,
                                    Statement.RETURN_GENERATED_KEYS
                            )
            ) {

                ps.setInt(1, order.getUser_Id());
                ps.setTimestamp(2, order.getCreateAt());
                ps.setString(3, order.getStatus());
                ps.setLong(4, order.getPrice());

                ps.setString(5, order.getReceiver_name());
                ps.setString(6, order.getReceiver_phone());
                ps.setString(7, order.getReceiver_address());
                ps.setString(8, order.getReceiver_email());
                ps.setString(9, order.getReceiver_note());
                ps.setString(10, order.getPayment_method());
                ps.setString(11, order.getPayment_status());
                ps.setString(12, order.getTransaction_no());

                int affectedRows = ps.executeUpdate();

                if (affectedRows <= 0) {
                    conn.rollback();
                    return false;
                }

                ResultSet rs = ps.getGeneratedKeys();

                if (rs.next()) {
                    orderId = rs.getInt(1);
                } else {
                    conn.rollback();
                    return false;
                }
            }

            // UPDATE STOCK + INSERT ORDER ITEM
            for (OrderItem item : items) {

                // update stock
                try (
                        PreparedStatement stockPs =
                                conn.prepareStatement(updateStockSql)
                ) {

                    stockPs.setInt(1, item.getQuantity());
                    stockPs.setInt(2, item.getProduct_id());
                    stockPs.setInt(3, item.getQuantity());

                    int updated = stockPs.executeUpdate();

                    if (updated <= 0) {
                        conn.rollback();
                        return false;
                    }
                }

                // insert order item
                try (
                        PreparedStatement itemPs =
                                conn.prepareStatement(insertItemSql)
                ) {

                    itemPs.setInt(1, orderId);
                    itemPs.setInt(2, item.getProduct_id());
                    itemPs.setInt(3, item.getQuantity());
                    itemPs.setLong(4, item.getProduct_price());
                    itemPs.setString(5, item.getProduct_image());

                    itemPs.executeUpdate();
                }
            }

            // COMMIT
            conn.commit();
            return true;

        } catch (Exception e) {

            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
        }

        return false;
    }
}
