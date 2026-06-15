package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Review;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.sql.Timestamp;

public class ReviewDao extends BaseDao {

    // Lấy danh sách review theo product
    public List<Review> getReviewByID(int productID) {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT
                    r.ID,
                    r.products_id,
                    r.users_id,
                    r.rating,
                    r.review_text,
                    r.imgReviews,
                    r.reviewDate,
                    r.status,
                    r.admin_reply,
                    r.reply_date,
                    u.username
                FROM reviews r
                JOIN users u ON r.users_id = u.ID
                WHERE r.products_id = :productID
                  AND r.status = 1
                ORDER BY r.reviewDate DESC
            """)
                        .bind("productID", productID)
                        .map((rs, ctx) -> {

                            Review r = new Review();

                            r.setID(rs.getInt("ID"));
                            r.setProducts_id(rs.getInt("products_id"));
                            r.setUsers_id(rs.getInt("users_id"));
                            r.setRating(rs.getInt("rating"));
                            r.setReview_text(rs.getString("review_text"));
                            r.setImgReviews(rs.getString("imgReviews"));
                            r.setStatus(rs.getBoolean("status"));
                            r.setUsername(rs.getString("username"));

                            Timestamp reviewTs = rs.getTimestamp("reviewDate");
                            if(reviewTs != null){
                                r.setReviewDate(reviewTs.toLocalDateTime());
                            }

                            r.setAdmin_reply(rs.getString("admin_reply"));

                            Timestamp replyTs = rs.getTimestamp("reply_date");
                            if(replyTs != null){
                                r.setReply_date(replyTs.toLocalDateTime());
                            }

                            return r;
                        })
                        .list()
        );
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

    public List<Review> getReviewsByUserId(int userId) {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT
                    r.ID,
                    r.products_id,
                    r.users_id,
                    r.rating,
                    r.review_text,
                    r.imgReviews,
                    r.reviewDate,
                    r.status,
                    p.name AS productName
                FROM reviews r
                JOIN products p
                    ON r.products_id = p.ID
                WHERE r.users_id = :userId
                ORDER BY r.reviewDate DESC
            """)
                        .bind("userId", userId)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    public List<Review> getReviewsByUserIdPaging(int userId, int offset, int limit) {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT
                    r.ID,
                    r.products_id,
                    r.users_id,
                    r.rating,
                    r.review_text,
                    r.imgReviews,
                    r.reviewDate,
                    r.status,
                    p.name AS productName
                FROM reviews r
                JOIN products p ON r.products_id = p.ID
                WHERE r.users_id = :userId
                ORDER BY r.reviewDate DESC
                LIMIT :limit OFFSET :offset
            """)
                        .bind("userId", userId)
                        .bind("limit", limit)
                        .bind("offset", offset)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    public int countReviewsByUserId(int userId) {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT COUNT(*)
                FROM reviews
                WHERE users_id = :userId
            """)
                        .bind("userId", userId)
                        .mapTo(Integer.class)
                        .one()
        );
    }
    // Cập nhật review
    public void updateReview(int reviewId, int userId, int rating, String text) {
        get().withHandle(handle ->
                handle.createUpdate("""
                UPDATE reviews
                SET rating = :rating,
                    review_text = :text
                WHERE ID = :id AND users_id = :userId
            """)
                        .bind("id", reviewId)
                        .bind("userId", userId)
                        .bind("rating", rating)
                        .bind("text", text)
                        .execute()
        );
    }

    public List<Review> getAllReviews() {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT
                    r.ID,
                    r.products_id,
                    r.users_id,
                    r.order_id,
                    r.rating,
                    r.review_text,
                    r.imgReviews,
                    r.reviewDate,
                    r.status,
                    r.admin_reply,
                    r.reply_date,
                    u.username,
                    p.name AS productName
                FROM reviews r
                LEFT JOIN users u ON r.users_id = u.ID
                LEFT JOIN products p ON r.products_id = p.ID
                ORDER BY r.reviewDate DESC
            """)
                        .map((rs, ctx) -> {
                            Review r = new Review();

                            r.setID(rs.getInt("ID"));
                            r.setProducts_id(rs.getInt("products_id"));
                            r.setUsers_id(rs.getInt("users_id"));
                            r.setOrder_id(rs.getInt("order_id"));
                            r.setRating(rs.getInt("rating"));
                            r.setReview_text(rs.getString("review_text"));
                            r.setImgReviews(rs.getString("imgReviews"));

                            // reviewDate (null-safe)
                            Timestamp reviewTs = rs.getTimestamp("reviewDate");
                            if (reviewTs != null) {
                                r.setReviewDate(reviewTs.toLocalDateTime());
                            }

                            // reply_date (null-safe)
                            Timestamp replyTs = rs.getTimestamp("reply_date");
                            if (replyTs != null) {
                                r.setReply_date(replyTs.toLocalDateTime());
                            }

                            r.setStatus(rs.getBoolean("status"));
                            r.setUsername(rs.getString("username"));
                            r.setProductName(rs.getString("productName"));
                            r.setAdmin_reply(rs.getString("admin_reply"));

                            return r;
                        })
                        .list()
        );
    }

    public List<Review> searchReviews(String keyword) {

        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT
                    r.*,
                    u.username,
                    p.name AS productName
                FROM reviews r
                JOIN users u ON r.users_id = u.ID
                JOIN products p ON r.products_id = p.ID
                WHERE
                    u.username LIKE :kw
                    OR p.name LIKE :kw
                ORDER BY r.reviewDate DESC
            """)
                        .bind("kw","%"+keyword+"%")
                        .mapToBean(Review.class)
                        .list()
        );
    }

    public List<Review> getReviewsByRating(int rating){

        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT
                    r.*,
                    u.username,
                    p.name AS productName
                FROM reviews r
                JOIN users u ON r.users_id = u.ID
                JOIN products p ON r.products_id = p.ID
                WHERE r.rating = :rating
                ORDER BY r.reviewDate DESC
            """)
                        .bind("rating", rating)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    public void hideReview(int reviewId){

        get().withHandle(handle ->
                handle.createUpdate("""
                UPDATE reviews
                SET status = 0
                WHERE ID = :id
            """)
                        .bind("id", reviewId)
                        .execute()
        );
    }

    public void showReview(int reviewId){

        get().withHandle(handle ->
                handle.createUpdate("""
                UPDATE reviews
                SET status = 1
                WHERE ID = :id
            """)
                        .bind("id", reviewId)
                        .execute()
        );
    }

    public void deleteReview(int reviewId) {
        get().withHandle(handle ->
                handle.createUpdate("""
            DELETE FROM reviews
            WHERE ID = :id
        """)
                        .bind("id", reviewId)
                        .execute()
        );
    }

    public void replyReview(int reviewId, String reply) {
        get().withHandle(handle ->
                handle.createUpdate("""
            UPDATE reviews
            SET admin_reply = :reply,
                reply_date = NOW()
            WHERE ID = :id
        """)
                        .bind("id", reviewId)
                        .bind("reply", reply)
                        .execute()
        );
    }

    public int countAllReviews() {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT COUNT(*)
                FROM reviews
                WHERE status = 1
            """)
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public Map<String, Integer> getReviewRatingStatistics() {

        Map<String, Integer> result = new HashMap<>();

        for (int i = 1; i <= 5; i++) {
            result.put(String.valueOf(i), 0);
        }

        get().withHandle(handle ->
                handle.createQuery("""
            SELECT rating, COUNT(*) AS total
            FROM reviews
            WHERE status = 1
            GROUP BY rating
        """)
                        .map((rs, ctx) -> {
                            String rating = String.valueOf(rs.getInt("rating"));
                            int total = rs.getInt("total");

                            result.put(rating, total);
                            return null;
                        })
                        .list()
        );

        return result;
    }

    public double getAverageRatingAllProducts() {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT COALESCE(AVG(rating),0)
                FROM reviews
                WHERE status = 1
            """)
                        .mapTo(Double.class)
                        .one()
        );
    }
}