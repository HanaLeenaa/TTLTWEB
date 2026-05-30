package com.example.web_console_handheld.model;


import java.sql.Timestamp;

public class ContactMessage {
    private int ID;
    private int userId;
    private String name;
    private String email;
    private String phone;
    private String message;
    private String status;
    private Timestamp createdAt;
    private String reply;
    private boolean isRead;

    public ContactMessage(int ID, int userId, String name, String email, String phone, String message, String status, Timestamp createdAt, String reply, boolean isRead) {
        this.ID = ID;
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.message = message;
        this.status = status;
        this.createdAt = createdAt;
        this.reply = reply;
        this.isRead = isRead;
    }

    public ContactMessage() {

    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
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

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }
}
