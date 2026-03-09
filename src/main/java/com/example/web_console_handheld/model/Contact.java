package com.example.web_console_handheld.model;

public class Contact {
    private int id;
    private String gmail;
    private String phone;
    private String address;

    public Contact(int id, String gmail, String phone, String address) {
        this.id = id;
        this.gmail = gmail;
        this.phone = phone;
        this.address = address;
    }
    public Contact() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getGmail() {
        return gmail;
    }

    public void setGmail(String gmail) {
        this.gmail = gmail;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
