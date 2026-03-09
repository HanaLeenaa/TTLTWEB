package com.example.web_console_handheld.model;

import java.time.LocalDateTime;

public class Brand {
    private int ID;
    private String brand_name;
    private boolean active;
    private LocalDateTime CreatedAt;

    public Brand(int ID, String brand_name, boolean active, LocalDateTime createdAt) {
        this.ID = ID;
        this.brand_name = brand_name;
        this.active = active;
        CreatedAt = createdAt;
    }
    public Brand() {}

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getBrand_name() {
        return brand_name;
    }

    public void setBrand_name(String brand_name) {
        this.brand_name = brand_name;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getCreatedAt() {
        return CreatedAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        CreatedAt = createdAt;
    }
}
