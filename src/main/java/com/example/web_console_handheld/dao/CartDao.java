package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.Product;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class CartDao extends BaseDao {

    // Thêm sản phẩm vào giỏ (Cập nhật: lưu thêm product_name vào DB)
    public void addToCart(int userId, int productId, String productName, int quantity) {
        get().useHandle(handle ->
                handle.createUpdate("""
                INSERT INTO cart_items (user_id, product_id, product_name, quantity)
                VALUES (:userId, :productId, :productName, :quantity)
                ON DUPLICATE KEY UPDATE 
                    quantity = quantity + :quantity,
                    product_name = :productName
            """)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .bind("productName", productName)
                        .bind("quantity", quantity)
                        .execute()
        );
        System.out.println("Insert/Update DB cart: userId=" + userId + ", productId=" + productId + ", productName=" + productName + ", quantity=" + quantity);
    }

    // Lấy giỏ hàng theo user (Cập nhật: Đọc trực tiếp product_name từ cart_items)
    // Lấy giỏ hàng theo user (Đã sửa lỗi JOIN tên cột id trong DB)
    public List<CartItem> getCartByUser(int userId) {
        return get().withHandle(handle ->
                handle.createQuery("""
        SELECT 
            ci.product_id AS p_id, 
            ci.product_name AS p_name, 
            ci.quantity AS qty, 
            p.price AS p_price, 
            p.image AS p_image
        FROM cart_items ci
        JOIN products p ON ci.product_id = p.id
        WHERE ci.user_id = :userId
    """)
                        .bind("userId", userId)
                        .map(new RowMapper<CartItem>() {
                            @Override
                            public CartItem map(ResultSet rs, StatementContext ctx) throws SQLException {
                                // 1. Khởi tạo đối tượng Product độc lập và hứng dữ liệu
                                Product product = new Product();
                                product.setID(rs.getInt("p_id"));
                                product.setName(rs.getString("p_name")); // Nhận tên sản phẩm từ bảng cart_items
                                product.setPrice(rs.getLong("p_price"));
                                product.setImage(rs.getString("p_image"));

                                // 2. Khởi tạo CartItem và bọc Product vào bên trong
                                CartItem cartItem = new CartItem();
                                cartItem.setProduct(product);
                                cartItem.setQuantity(rs.getInt("qty"));

                                return cartItem;
                            }
                        })
                        .list()
        );
    }

    // Cập nhật số lượng
    // Cập nhật số lượng (Bổ sung thêm cập nhật tên sản phẩm để triệt tiêu lỗi null)
    public void updateQuantity(int userId, int productId, String productName, int quantity) {
        get().useHandle(handle ->
                handle.createUpdate("""
                UPDATE cart_items
                SET quantity = :quantity,
                    product_name = :productName
                WHERE user_id = :userId AND product_id = :productId
            """)
                        .bind("quantity", quantity)
                        .bind("productName", productName)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .execute()
        );
        System.out.println("Update DB cart: userId=" + userId + ", productId=" + productId + ", productName=" + productName + ", quantity=" + quantity);
    }

    // Xóa sản phẩm khỏi giỏ
    public void removeItem(int userId, int productId) {
        get().useHandle(handle ->
                handle.createUpdate("""
                DELETE FROM cart_items
                WHERE user_id = :userId AND product_id = :productId
            """)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .execute()
        );
    }

    // Xóa toàn bộ giỏ hàng
    public void clearCart(int userId) {
        get().useHandle(handle ->
                handle.createUpdate("DELETE FROM cart_items WHERE user_id = :userId")
                        .bind("userId", userId)
                        .execute()
        );
    }


}