package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.ImportReceiptItem;
import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ImportDao {
    // 1. Lấy danh sách sản phẩm
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();

        String sql = "SELECT * FROM products";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                Product p = new Product();
                p.setID(rs.getInt("ID"));
                p.setName(rs.getString("name"));
                p.setStock_quantity(rs.getInt("stock"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // 2. Tạo phiếu nhập
    public int createReceipt() {
        int receiptId = -1;

        String sql = "INSERT INTO import_receipts(status) VALUES('DRAFT')";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    receiptId = rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return receiptId;
    }

    // 3. Thêm sản phẩm vào phiếu
    public void addItem(int receiptId, int productId, int quantity) {

        String sql = "INSERT INTO import_receipt_items(receipt_id, product_id, quantity) VALUES(?,?,?)";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, receiptId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 4. Lấy danh sách item theo receipt
    public List<ImportReceiptItem> getItemsByReceiptId(int receiptId) {

        List<ImportReceiptItem> list = new ArrayList<>();

        String sql = """
                SELECT i.product_id, p.name, i.quantity
                FROM import_receipt_items i
                JOIN products p ON i.product_id = p.id
                WHERE i.receipt_id = ?
                """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, receiptId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ImportReceiptItem item = new ImportReceiptItem();

                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("name"));
                    item.setQuantity(rs.getInt("quantity"));

                    list.add(item);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 5. Confirm nhập kho (TRANSACTION)
    public void confirmReceipt(int receiptId) {

        String getItemsSql = "SELECT * FROM import_receipt_items WHERE receipt_id = ?";
        String updateStockSql = "UPDATE products SET stock = stock + ? WHERE ID = ?";
        String insertLogSql = "INSERT INTO stock_movements(product_id, quantity, type) VALUES(?, ?, 'IMPORT')";
        String updateReceiptSql = "UPDATE import_receipts SET status = 'COMPLETED' WHERE ID = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);//bat dau transaction

            try (
                PreparedStatement psItems = conn.prepareStatement(getItemsSql);
                PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSql);
                PreparedStatement psInsertLog = conn.prepareStatement(insertLogSql);
                PreparedStatement psUpdateReceipt = conn.prepareStatement(updateReceiptSql)
        ) {

                // lấy danh sach item trong phieu
                psItems.setInt(1, receiptId);
                try (ResultSet rs = psItems.executeQuery()) {

                    while (rs.next()) {
                        int productId = rs.getInt("product_id");
                        int quantity = rs.getInt("quantity");

                        // update stock cua products
                        psUpdateStock.setInt(1, quantity);
                        psUpdateStock.setInt(2, productId);
                        psUpdateStock.executeUpdate();

                        //luu lich su bien dong (log)
                        psInsertLog.setInt(1, productId);
                        psInsertLog.setInt(2, quantity);
                        psInsertLog.executeUpdate();
                    }
                }

                // update trạng thái phiếu nhập
                psUpdateReceipt.setInt(1, receiptId);
                int rows = psUpdateReceipt.executeUpdate();

                if (rows > 0) {
                    conn.commit();
                } else {
                    conn.rollback();
                }
            }
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                }catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
    } finally {
            if (conn != null) {
                try {
                    conn.close();
                }catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        }

    }