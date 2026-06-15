package com.example.web_console_handheld.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Voucher {
    private int ID;
    private String code;
    private String name;
    private String discount_type;
    private BigDecimal discount_value;
    private BigDecimal min_order_amount;
    private BigDecimal max_discount;
    private int quantity;
    private Timestamp start_date;
    private Timestamp end_date;
    private boolean active;
    private Timestamp created_at;

    public Voucher(int ID, String code, String name, String discount_type, BigDecimal discount_value, BigDecimal min_order_amount, BigDecimal max_discount, int quantity, Timestamp start_date, Timestamp end_date, boolean active, Timestamp created_at) {
        this.ID = ID;
        this.code = code;
        this.name = name;
        this.discount_type = discount_type;
        this.discount_value = discount_value;
        this.min_order_amount = min_order_amount;
        this.max_discount = max_discount;
        this.quantity = quantity;
        this.start_date = start_date;
        this.end_date = end_date;
        this.active = active;
        this.created_at = created_at;
    }

    public Voucher() {
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDiscount_type() {
        return discount_type;
    }

    public void setDiscount_type(String discount_type) {
        this.discount_type = discount_type;
    }

    public BigDecimal getDiscount_value() {
        return discount_value;
    }

    public void setDiscount_value(BigDecimal discount_value) {
        this.discount_value = discount_value;
    }

    public BigDecimal getMin_order_amount() {
        return min_order_amount;
    }

    public void setMin_order_amount(BigDecimal min_order_amount) {
        this.min_order_amount = min_order_amount;
    }

    public BigDecimal getMax_discount() {
        return max_discount;
    }

    public void setMax_discount(BigDecimal max_discount) {
        this.max_discount = max_discount;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getStart_date() {
        return start_date;
    }

    public void setStart_date(Timestamp start_date) {
        this.start_date = start_date;
    }

    public Timestamp getEnd_date() {
        return end_date;
    }

    public void setEnd_date(Timestamp end_date) {
        this.end_date = end_date;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }
}
