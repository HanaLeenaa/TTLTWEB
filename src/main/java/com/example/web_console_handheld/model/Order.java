package com.example.web_console_handheld.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Order {

    private int ID;
    private int user_Id;
    private Timestamp createAt;
    private String status;
private long price;
    private String receiver_name;
    private String receiver_phone;
    private String receiver_address;
    private String receiver_email;
    private boolean payment_method;
    public Order() {}

    public Order(int ID, int user_Id, Timestamp createAt, String status, long price, String receiver_name, String receiver_phone, String receiver_address, String receiver_email, boolean payment_method) {
        this.ID = ID;
        this.user_Id = user_Id;
        this.createAt = createAt;
        this.status = status;
        this.price = price;
        this.receiver_name = receiver_name;
        this.receiver_phone = receiver_phone;
        this.receiver_address = receiver_address;
        this.receiver_email = receiver_email;
        this.payment_method = payment_method;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getUser_Id() {
        return user_Id;
    }

    public void setUser_Id(int user_Id) {
        this.user_Id = user_Id;
    }

    public Timestamp getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Timestamp createAt) {
        this.createAt = createAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getPrice() {
        return price;
    }

    public void setPrice(long price) {
        this.price = price;
    }

    public String getReceiver_name() {
        return receiver_name;
    }

    public void setReceiver_name(String receiver_name) {
        this.receiver_name = receiver_name;
    }

    public String getReceiver_phone() {
        return receiver_phone;
    }

    public void setReceiver_phone(String receiver_phone) {
        this.receiver_phone = receiver_phone;
    }

    public String getReceiver_address() {
        return receiver_address;
    }

    public void setReceiver_address(String receiver_address) {
        this.receiver_address = receiver_address;
    }

    public String getReceiver_email() {
        return receiver_email;
    }

    public void setReceiver_email(String receiver_email) {
        this.receiver_email = receiver_email;
    }

    public boolean isPayment_method() {
        return payment_method;
    }

    public void setPayment_method(boolean payment_method) {
        this.payment_method = payment_method;
    }
}
