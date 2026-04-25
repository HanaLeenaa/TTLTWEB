package com.example.web_console_handheld.model;

import java.sql.Timestamp;

public class StockMovement {
    private int ID;
    private int product_id;
    private String productName;
    private int quantity;
    private String type;
    private Timestamp createdAt;
    private int user_id;
    private String userName;

    public StockMovement(int ID, int product_id, String productName, int quantity, String type, Timestamp createdAt, int user_id, String userName) {
        this.ID = ID;
        this.product_id = product_id;
        this.productName = productName;
        this.quantity = quantity;
        this.type = type;
        this.createdAt = createdAt;
        this.user_id = user_id;
        this.userName = userName;
    }

    public StockMovement() {

    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    public int getUser_id() {
        return user_id;
    }
    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getUserName() {
        return userName;
    }
    public void setUserName(String userName) {
        this.userName = userName;
    }
}
