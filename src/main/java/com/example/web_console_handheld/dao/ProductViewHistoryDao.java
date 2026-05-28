package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Product;
import org.jdbi.v3.core.Jdbi;
import java.sql.Timestamp;
import java.util.List;

public class ProductViewHistoryDao extends BaseDao {

    // Thêm một lần xem sản phẩm
    public void insertView(int userId, int productId) {
        try {
            get().useHandle(handle -> {
                handle.createUpdate("""
                INSERT INTO product_view_history(user_id, product_id, createdAt)
                VALUES (:userId, :productId, CURRENT_TIMESTAMP)
                ON DUPLICATE KEY UPDATE createdAt = CURRENT_TIMESTAMP
            """)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .execute();
            });
            System.out.println("Upsert view: user=" + userId + ", product=" + productId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách sản phẩm đã xem gần đây của user
    public List<Product> getRecentViews(int userId) {
        return get().withHandle(handle ->
                handle.createQuery("""
            SELECT p.ID AS id, p.name, p.image, p.price, p.priceOld, p.ispremium, h.createdAt
            FROM product_view_history h
            JOIN products p ON h.product_id = p.ID
            WHERE h.user_id = :userId
            ORDER BY h.createdAt DESC
        """) // bỏ LIMIT để lấy toàn bộ
                        .bind("userId", userId)
                        .map((rs, ctx) -> {
                            Product product = new Product();
                            product.setID(rs.getInt("id"));
                            product.setName(rs.getString("name"));
                            product.setImage(rs.getString("image"));
                            product.setPrice(rs.getLong("price"));
                            product.setPriceOld(rs.getLong("priceOld"));
                            product.setIspremium(rs.getBoolean("ispremium"));
                            Timestamp ts = rs.getTimestamp("createdAt");
                            if (ts != null) product.setCreatedAt(ts.toLocalDateTime());
                            return product;
                        })
                        .list()
        );
    }



    // Xóa một bản ghi lịch sử theo ID
    public void deleteById(int id) {
        get().useHandle(handle -> {
            handle.createUpdate("DELETE FROM product_view_history WHERE id = :id")
                    .bind("id", id)
                    .execute();
        });
    }

    // Xóa toàn bộ lịch sử của một user
    public void deleteAllByUser(int userId) {
        get().useHandle(handle -> {
            handle.createUpdate("DELETE FROM product_view_history WHERE user_id = :userId")
                    .bind("userId", userId)
                    .execute();
        });
    }

    // Xóa toàn bộ lịch sử (cho admin)
    public void deleteAll() {
        get().useHandle(handle -> {
            handle.createUpdate("DELETE FROM product_view_history")
                    .execute();
        });
    }

    public void deleteByUserAndProduct(int userId, int productId) {
        get().useHandle(handle ->
                handle.createUpdate("DELETE FROM product_view_history WHERE user_id = :userId AND product_id = :productId")
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .execute()
        );
    }

}
