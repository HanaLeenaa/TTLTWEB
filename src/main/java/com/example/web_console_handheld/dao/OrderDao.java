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

    // save order items (ĐÃ SỬA: Loại bỏ conn.commit() gây xung đột trạng thái Autocommit)
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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // get order by id
    public Order getOrderById(int orderId) {
        Order order = null;
        String sql = """
            SELECT o.*, p.payment_method AS pay_method, p.payment_status AS pay_status, p.transaction_id  AS pay_transaction
            FROM orders o
            LEFT JOIN payments p ON o.ID = p.orders_id
            WHERE o.ID = ?
        """;

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

                    order.setPayment_method(rs.getString("pay_method"));
                    order.setPayment_status(rs.getString("pay_status"));
                    order.setTransaction_no(rs.getString("pay_transaction"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return order;
    }

    // ================= LẤY LỊCH SỬ ĐƠN HÀNG CỦA USER (ĐÃ KHỬ TRÙNG & THÊM LEFT JOIN CHUẨN) =================
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = """
            SELECT o.*, p.payment_method AS pay_method, p.payment_status AS pay_status, p.transaction_id AS pay_transaction
            FROM orders o
            LEFT JOIN payments p ON o.ID = p.orders_id
            WHERE o.user_id = ?
            ORDER BY o.order_date DESC
        """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
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

                    order.setPayment_method(rs.getString("pay_method"));
                    order.setPayment_status(rs.getString("pay_status"));
                    order.setTransaction_no(rs.getString("pay_transaction"));

                    list.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= DANH SÁCH ĐƠN HÀNG ADMIN =================
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

    // ================= CHI TIẾT ĐƠN HÀNG ADMIN =================
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
                order.setCreateAt(rs.getTimestamp("order_date"));
                order.setStatus(rs.getString("status"));
                order.setPrice(rs.getLong("total_amount"));

                order.setReceiver_name(rs.getString("fullname_order"));
                order.setReceiver_phone(rs.getString("phone_order"));
                order.setReceiver_address(rs.getString("address_order"));
                order.setReceiver_email(rs.getString("email_order"));
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
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return false;
            }

            String currentStatus = rs.getString("status").trim();
            if (!isValidTransition(currentStatus, newStatus)) {
                return false;
            }

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
                return next.equals("Đã xác nhận") || next.equals("Đã huỷ");
            case "Đã xác nhận":
                return next.equals("Đang giao") || next.equals("Đã huỷ");
            case "Đang giao":
                return next.equals("Đã giao") ||next.equals("Yêu cầu hủy");
            case "Yêu cầu hủy":
                return next.equals("Đã hủy");

            case "Đã giao":
            case "Đã huỷ":
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

    // ================= TÌM KIẾM ĐƠN HÀNG =================
    public List<Order> searchOrders(String keyword, String status, String fromDate, String toDate, String minPrice, String maxPrice) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM orders WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            keyword = keyword.replace("#", "").trim();
            if (keyword.matches("\\d{1,6}")) {
                sql.append(" AND ID = ?");
            } else if (keyword.matches("\\d{8,11}")) {
                sql.append(" AND phone_order LIKE ?");
            } else {
                sql.append(" AND fullname_order LIKE ?");
            }
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND DATE(order_date) >= ?");
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND DATE(order_date) <= ?");
        }

        if (minPrice != null && !minPrice.isEmpty()) {
            sql.append(" AND total_amount >= ?");
        }
        if (maxPrice != null && !maxPrice.isEmpty()) {
            sql.append(" AND total_amount <= ?");
        }

        sql.append(" ORDER BY order_date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            if (keyword != null && !keyword.isEmpty()) {
                keyword = keyword.replace("#", "").trim();
                if (keyword.matches("\\d{1,6}")) {
                    ps.setInt(i++, Integer.parseInt(keyword));
                } else {
                    ps.setString(i++, "%" + keyword + "%");
                }
            }

            if (status != null && !status.isEmpty()) ps.setString(i++, status);
            if (fromDate != null && !fromDate.isEmpty()) ps.setString(i++, fromDate);
            if (toDate != null && !toDate.isEmpty()) ps.setString(i++, toDate);
            if (minPrice != null && !minPrice.isEmpty()) ps.setLong(i++, Long.parseLong(minPrice));
            if (maxPrice != null && !maxPrice.isEmpty()) ps.setLong(i++, Long.parseLong(maxPrice));

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

    // ================= TRANSACTION ĐẶT HÀNG CHUẨN AN TOÀN =================
    public int createOrderTransactionWithLog(Order order, List<OrderItem> items) throws Exception {
        String insertOrderSql = """
        INSERT INTO orders(
            user_id, order_date, status, total_amount, fullname_order,
            phone_order, address_order, email_order, note
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """;

        String insertPaymentSql = """
        INSERT INTO payments(orders_id, payment_method, payment_status, transaction_id)
        VALUES (?, ?, ?, ?)
    """;

        String insertItemSql = """
        INSERT INTO order_items(order_id, product_id, quantity, price_at_purchase, product_image)
        VALUES (?, ?, ?, ?, ?)
    """;

        String updateStockSql = """
        UPDATE products
        SET stock = stock - ?, sales_count = sales_count + ?
        WHERE ID = ? AND stock >= ?
    """;

        String insertShipmentSql = """
        INSERT INTO shipment(order_id, ghn_order_code, shipping_fee, shipping_status)
        VALUES (?, ?, ?, ?)
    """;

        Connection conn = null;
        int orderId = -1;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
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

                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(insertPaymentSql)) {
                ps.setInt(1, orderId);
                ps.setString(2, order.getPayment_method());
                ps.setString(3, order.getPayment_status());
                ps.setString(4, order.getTransaction_no());
                ps.executeUpdate();
            }

            for (OrderItem item : items) {

                try (PreparedStatement ps = conn.prepareStatement(updateStockSql)) {
                    ps.setInt(1, item.getQuantity());
                    ps.setInt(2, item.getQuantity());
                    ps.setInt(3, item.getProduct_id());
                    ps.setInt(4, item.getQuantity());

                    if (ps.executeUpdate() <= 0) {
                        throw new Exception("Out of stock product ID: " + item.getProduct_id());
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(insertItemSql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, item.getProduct_id());
                    ps.setInt(3, item.getQuantity());
                    ps.setLong(4, item.getProduct_price());
                    ps.setString(5, item.getProduct_image());
                    ps.executeUpdate();
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(insertShipmentSql)) {
                ps.setInt(1, orderId);
                ps.setString(2, "GHN-" + System.currentTimeMillis());
                ps.setDouble(3, 0);
                ps.setString(4, "WAITING_PICKUP");

                ps.executeUpdate();
            }

            conn.commit();
            return orderId;

        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;

        } finally {
            if (conn != null) conn.close();
        }
    }

    //Hoàn kho khi HỦY ĐƠN
    public void restoreStock(Connection conn, int orderId) throws Exception {
        String sql = """
                SELECT product_id, quantity
                FROM order_items
                WHERE order_id = ?
                """;
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int productId = rs.getInt("product_id");
            int quantity = rs.getInt("quantity");
            String updateSql = """
                    UPDATE products
                    SET stock = stock + ?,
                    sales_count = sales_count - ?
                    WHERE ID = ?
                    """;
            PreparedStatement updatePs = conn.prepareStatement(updateSql);
            updatePs.setInt(1, quantity);
            updatePs.setInt(2, quantity);
            updatePs.setInt(3, productId);

            updatePs.executeUpdate();
        }
    }

    //Cập nhật payment_status khi HUỶ ĐƠN
    public void updatePaymentWhenCancel(Connection conn, int orderId) throws Exception {
        String sql = """
                UPDATE payments
                SET payment_status = 'CANCELLED'
                WHERE orders_id = ?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
        }
    }

    // HỦY trực tiếp (trạng thái chờ xác nhận và đã xác nhận)
    public boolean cancelOrder(int orderId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            Order order = getOrderById(orderId);
            if (order == null) {
                return false;
            }
            restoreStock(conn, orderId);

            updatePaymentWhenCancel(conn, orderId);

            String sql = "UPDATE orders SET status = 'Đã hủy' WHERE ID = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            ps.executeUpdate();
            conn.commit();
            return true;

        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            }catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return false;
    }

    //Gửi yêu cầu HỦY (đối với đơn ĐANG GIAO)
    public boolean requestCancelOrder(int orderId) {
        String sql = """
                UPDATE orders
                SET status = "Yêu cầu hủy"
                WHERE ID = ?
                """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)){
                ps.setInt(1, orderId);
                return ps.executeUpdate() > 0;

        }catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Order> getOrdersByUserIdPaging(int userId, int offset, int limit) {
        List<Order> list = new ArrayList<>();
        String sql = """
        SELECT *
        FROM orders
        WHERE user_id = ?
        ORDER BY order_date DESC
        LIMIT ? OFFSET ?
    """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, limit);
            ps.setInt(3, offset);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setID(rs.getInt("ID"));
                order.setUser_Id(rs.getInt("user_id"));
                order.setCreateAt(rs.getTimestamp("order_date"));
                order.setStatus(rs.getString("status"));
                order.setPrice(rs.getLong("total_amount"));
                order.setReceiver_address(rs.getString("address_order"));

                order.setPayment_method(rs.getString("payment_method"));

                list.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countOrdersByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}