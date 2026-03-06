package com.example.web_console_handheld.dao;


import com.example.web_console_handheld.model.Review;

import java.util.List;

public class ReviewDao extends BaseDao{
    //dem so tong danh gia cua san pham
    public List<Review> getAllQuantity(int productID) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "select r.products_id, r.users_id, r.rating, r.review_text, r.reviewDate, r.status, u.username from reviews r join users u on u.ID = r.users_id where r.products_id = :productID and r.status = 1"
                        )
                        .bind("productID", productID)
                        .mapToBean(Review.class)
                        .list()
        );
    }
    public List<Review> countReview5Stars(int productID) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "select * from reviews where products_id = :productID and status = 1 and rating = 5"
                        )
                        .bind("productID", productID)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    public List<Review> countReview4Stars(int productID) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "select * from reviews where products_id = :productID and status = 1 and rating = 4"
                        )
                        .bind("productID", productID)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    public List<Review> countReview3Stars(int productID) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "select * from reviews where products_id = :productID and status = 1 and rating = 3"
                        )
                        .bind("productID", productID)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    public List<Review> countReview2Stars(int productID) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "select * from reviews where products_id = :productID and status = 1 and rating = 2"
                        )
                        .bind("productID", productID)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    public List<Review> countReview1Stars(int productID) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "select * from reviews where products_id = :productID and status = 1 and rating = 1"
                        )
                        .bind("productID", productID)
                        .mapToBean(Review.class)
                        .list()
        );
    }
    //tinh tong san pham co id lay tu request
    //Tong so chia la tong san pham * 5
    //trung binh bang tong rating chia tong so can chia * 100 lay double
    public List<Review> getReviewByID(int productID) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "select * from reviews where products_id = :productID and status = 1"
                        )
                        .bind("productID", productID)
                        .mapToBean(Review.class)
                        .list()
        );
    }
    //sum
    public Review sum(int productID) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "select sum(rating) as rating from reviews where products_id = :productID and status = 1"
                        )
                        .bind("productID", productID)
                        .mapToBean(Review.class)
                        .first()
        );
    }

}
