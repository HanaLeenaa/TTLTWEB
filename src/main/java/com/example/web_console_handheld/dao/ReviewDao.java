package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Review;
import java.util.List;

public class ReviewDao extends BaseDao {

    // Lấy danh sách review theo product
    public List<Review> getReviewByID(int productID) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT r.*, u.username FROM reviews r " +
                                        "JOIN users u ON r.users_id = u.ID " +
                                        "WHERE r.products_id = :productID AND r.status = 1 " +
                                        "ORDER BY r.reviewDate DESC")
                        .bind("productID", productID)
                        .mapToBean(Review.class)
                        .list());
    }

    // Tính tổng rating (trả về double)
    public double sumRating(int productID) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COALESCE(SUM(rating),0) FROM reviews " +
                                        "WHERE products_id = :productID AND status = 1")
                        .bind("productID", productID)
                        .mapTo(Double.class)
                        .one());
    }

    // Đếm số review theo số sao
    public int countByStar(int productID, int star) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM reviews " +
                                        "WHERE products_id = :productID AND status = 1 AND rating = :star")
                        .bind("productID", productID)
                        .bind("star", star)
                        .mapTo(Integer.class)
                        .one());
    }

    // Lấy ID đơn hàng có thể review (chưa review trước đó)
    public int getOrderIdCanReviewV2(int userId, int productId) {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT o.ID
                FROM orders o
                JOIN order_items oi ON oi.order_id = o.ID
                WHERE o.user_id = :userId
                  AND oi.product_id = :productId
                  AND LOWER(TRIM(o.status)) LIKE 'đã giao%'
                  AND NOT EXISTS (
                      SELECT 1
                      FROM reviews r
                      WHERE r.order_id = o.ID
                        AND r.products_id = :productId
                        AND r.users_id = :userId)
                ORDER BY o.ID DESC
                LIMIT 1""")
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(0));
    }

    // Chèn review mới
    public void insertReview(int userId, int productId, int orderId,
                             int rating, String text, String image) {
        get().withHandle(handle ->
                handle.createUpdate(
                                "INSERT INTO reviews(products_id, users_id, order_id, rating, review_text, imgReviews, reviewDate, status) " +
                                        "VALUES(:productId, :userId, :orderId, :rating, :text, :image, NOW(), 1)")
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .bind("orderId", orderId)
                        .bind("rating", rating)
                        .bind("text", text)
                        .bind("image", image)
                        .execute());
    }

    public double getAverageRating(int productId){
        return get().withHandle(handle ->
                handle.createQuery("""
                    SELECT COALESCE(AVG(rating),0)
                    FROM reviews
                    WHERE products_id=:productId
                    AND status=1
                    """)
                        .bind("productId", productId)
                        .mapTo(Double.class)
                        .one()
        );
    }
}