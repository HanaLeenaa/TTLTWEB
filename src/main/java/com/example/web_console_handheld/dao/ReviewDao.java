package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Review;
import java.util.List;

public class ReviewDao extends BaseDao {
    // Lấy tất cả review của sản phẩm
    public List<Review> getReviewByID(int productID) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT r.*, u.username FROM reviews r JOIN users u ON r.users_id = u.ID WHERE r.products_id = :productID AND r.status = 1 ORDER BY r.reviewDate DESC")
                        .bind("productID", productID)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    // Sum rating
    public Review sum(int productID) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT SUM(rating) AS rating FROM reviews WHERE products_id = :productID AND status = 1")
                        .bind("productID", productID)
                        .mapToBean(Review.class)
                        .first()
        );
    }

    // Đếm review theo sao
    public List<Review> countByStar(int productID, int star) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM reviews WHERE products_id = :productID AND status = 1 AND rating = :star")
                        .bind("productID", productID)
                        .bind("star", star)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    public List<Review> countReview5Stars(int productID) { return countByStar(productID, 5); }
    public List<Review> countReview4Stars(int productID) { return countByStar(productID, 4); }
    public List<Review> countReview3Stars(int productID) { return countByStar(productID, 3); }
    public List<Review> countReview2Stars(int productID) { return countByStar(productID, 2); }
    public List<Review> countReview1Stars(int productID) { return countByStar(productID, 1); }

    // Kiểm tra user có thể review không
    public Integer getOrderIdCanReview(int userId, int productId) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT o.ID FROM orders o " +
                                        "WHERE o.user_id = :userId " +
                                        "AND LOWER(TRIM(o.status)) = 'completed' " +
                                        "AND EXISTS ( " +
                                        "   SELECT 1 FROM order_items oi " +
                                        "   WHERE oi.order_id = o.ID " +
                                        "   AND oi.product_id = :productId " +
                                        ") " +
                                        "ORDER BY o.ID DESC LIMIT 1")
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .mapTo(int.class)
                        .findOne()
                        .orElse(0)
        );
    }

    // Thêm review
    public void addReview(int productId, int userId, int orderId, int rating, String text) {
        get().withHandle(handle ->
                handle.createUpdate(
                                "INSERT INTO reviews(products_id, users_id, order_id, rating, review_text, status, reviewDate) " +
                                        "VALUES(:productId, :userId, :orderId, :rating, :text, 1, NOW())")
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .bind("orderId", orderId)
                        .bind("rating", rating)
                        .bind("text", text)
                        .execute()
        );
    }
    public boolean isValidOrder(int userId, int productId, int orderId) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT 1 FROM orders o " +
                                        "JOIN order_items oi ON o.ID = oi.order_id " +
                                        "WHERE o.user_id = :userId " +
                                        "AND oi.product_id = :productId " +
                                        "AND o.ID = :orderId " +
                                        "AND LOWER(TRIM(o.status)) = 'completed'")
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .bind("orderId", orderId)
                        .mapTo(Integer.class)
                        .findOne()
                        .isPresent()
        );
    }

    public boolean hasUserReviewed(int userId, int productId, int orderId) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT 1 FROM reviews " +
                                        "WHERE users_id = :userId " +
                                        "AND products_id = :productId " +
                                        "AND order_id = :orderId")
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .bind("orderId", orderId)
                        .mapTo(Integer.class)
                        .findOne()
                        .isPresent()
        );
    }
}