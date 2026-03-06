package com.example.web_console_handheld.model;

import java.sql.Timestamp;

public class FeedBack {
    private int ID;
    private Integer userId;
    private String content;
    private String status;
    private Timestamp createdAt;
    public FeedBack() {}

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public FeedBack(int ID, Integer userId, String content, String status, Timestamp createdAt) {
        this.ID = ID;
        this.userId = userId;
        this.content = content;
        this.status = status;
        this.createdAt = createdAt;
    }
}
