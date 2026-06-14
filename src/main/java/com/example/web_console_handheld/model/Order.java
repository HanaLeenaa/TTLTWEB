package com.example.web_console_handheld.model;

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
    private String payment_method;
    private String receiver_note;
    private String payment_status;
    private String transaction_no;
    private Integer voucher_id;
    private long discount_amount;
    private long final_amount;

    // BỔ SUNG THÊM CÁC THUỘC TÍNH PHỤC VỤ VẬN CHUYỂN GHN
    private int shippingFee;
    private Timestamp expectedDeliveryFrom;
    private Timestamp expectedDeliveryTo;

    public Order() {}

    // Getters và Setters cho các thuộc tính cũ
    public int getID() { return ID; }
    public void setID(int ID) { this.ID = ID; }

    public int getUser_Id() { return user_Id; }
    public void setUser_Id(int user_Id) { this.user_Id = user_Id; }

    public Timestamp getCreateAt() { return createAt; }
    public void setCreateAt(Timestamp createAt) { this.createAt = createAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public long getPrice() { return price; }
    public void setPrice(long price) { this.price = price; }

    public String getReceiver_name() { return receiver_name; }
    public void setReceiver_name(String receiver_name) { this.receiver_name = receiver_name; }

    public String getReceiver_phone() { return receiver_phone; }
    public void setReceiver_phone(String receiver_phone) { this.receiver_phone = receiver_phone; }

    public String getReceiver_address() { return receiver_address; }
    public void setReceiver_address(String receiver_address) { this.receiver_address = receiver_address; }

    public String getReceiver_email() { return receiver_email; }
    public void setReceiver_email(String receiver_email) { this.receiver_email = receiver_email; }

    public String getPayment_method() { return payment_method; }
    public void setPayment_method(String payment_method) { this.payment_method = payment_method; }

    public String getReceiver_note() { return receiver_note; }
    public void setReceiver_note(String receiver_note) { this.receiver_note = receiver_note; }

    public String getPayment_status() { return payment_status; }
    public void setPayment_status(String payment_status) { this.payment_status = payment_status; }

    public String getTransaction_no() { return transaction_no; }
    public void setTransaction_no(String transaction_no) { this.transaction_no = transaction_no; }

    public Integer getVoucher_id() { return voucher_id; }
    public void setVoucher_id(Integer voucher_id) { this.voucher_id = voucher_id; }

    public long getDiscount_amount() { return discount_amount; }
    public void setDiscount_amount(long discount_amount) { this.discount_amount = discount_amount; }

    public long getFinal_amount() { return final_amount; }
    public void setFinal_amount(long final_amount) { this.final_amount = final_amount; }

    // GETTER & SETTER CHO CÁC THUỘC TÍNH VẬN CHUYỂN MỚI THÊM
    public int getShippingFee() { return shippingFee; }
    public void setShippingFee(int shippingFee) { this.shippingFee = shippingFee; }

    public Timestamp getExpectedDeliveryFrom() { return expectedDeliveryFrom; }
    public void setExpectedDeliveryFrom(Timestamp expectedDeliveryFrom) { this.expectedDeliveryFrom = expectedDeliveryFrom; }

    public Timestamp getExpectedDeliveryTo() { return expectedDeliveryTo; }
    public void setExpectedDeliveryTo(Timestamp expectedDeliveryTo) { this.expectedDeliveryTo = expectedDeliveryTo; }
}