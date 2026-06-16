package com.example.web_console_handheld.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Review {
    private int ID;
    private int products_id;
    private int users_id;
    private int rating;
    private String review_text;
    private String imgReviews;
    private LocalDateTime reviewDate;
    private boolean status;
    private String username;
    private int order_id;
    private String productName;
    private String admin_reply;
    private LocalDateTime reply_date;

    public Review(int ID, int products_id, int users_id, int rating, String review_text,
                  String imgReviews, LocalDateTime reviewDate, boolean status,
                  String username, int order_id, String productName,
                  String admin_reply, LocalDateTime reply_date) {
        this.ID = ID;
        this.products_id = products_id;
        this.users_id = users_id;
        this.rating = rating;
        this.review_text = review_text;
        this.imgReviews = imgReviews;
        this.reviewDate = reviewDate;
        this.status = status;
        this.username = username;
        this.order_id = order_id;
        this.productName = productName;
        this.admin_reply= admin_reply;
        this.reply_date = reply_date;
    }
    public Review() {}

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getProducts_id() {
        return products_id;
    }

    public void setProducts_id(int products_id) {
        this.products_id = products_id;
    }

    public int getUsers_id() {
        return users_id;
    }

    public void setUsers_id(int users_id) {
        this.users_id = users_id;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getReview_text() {
        return review_text;
    }

    public void setReview_text(String review_text) {
        this.review_text = review_text;
    }

    public String getImgReviews() {
        return imgReviews;
    }

    public void setImgReviews(String imgReviews) {
        this.imgReviews = imgReviews;
    }

    public LocalDateTime getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(LocalDateTime reviewDate) {
        this.reviewDate = reviewDate;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }


    public String getReviewDateOnly() {
        return reviewDate != null
                ? reviewDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                : "";
    }

    public String getReviewTimeOnly() {
        return reviewDate != null
                ? reviewDate.format(DateTimeFormatter.ofPattern("HH:mm:ss"))
                : "";
    }

    public String getAdmin_reply() {
        return admin_reply;
    }

    public void setAdmin_reply(String admin_reply) {
        this.admin_reply = admin_reply;
    }

    public LocalDateTime getReply_date() {
        return reply_date;
    }

    public void setReply_date(LocalDateTime reply_date) {
        this.reply_date = reply_date;
    }
}
