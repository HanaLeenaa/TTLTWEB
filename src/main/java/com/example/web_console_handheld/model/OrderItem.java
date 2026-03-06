package com.example.web_console_handheld.model;

import java.math.BigDecimal;

public class OrderItem {
    private int ID;
    private int order_id;
    private int product_id;
    private String product_name;
    private long product_price;
    private int quantity;

    public OrderItem() {}

    public OrderItem(int ID, int order_id, int product_id, String product_name, long product_price, int quantity) {
        this.ID = ID;
        this.order_id = order_id;
        this.product_id = product_id;
        this.product_name = product_name;
        this.product_price = product_price;
        this.quantity = quantity;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public String getProduct_name() {
        return product_name;
    }

    public void setProduct_name(String product_name) {
        this.product_name = product_name;
    }

    public long getProduct_price() {
        return product_price;
    }

    public void setProduct_price(long product_price) {
        this.product_price = product_price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
