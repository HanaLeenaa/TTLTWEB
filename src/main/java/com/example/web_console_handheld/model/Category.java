package com.example.web_console_handheld.model;

public class Category {
    private int ID;
    private String name;
    private String description;
    private String imgLink;
    private boolean active;

    public Category(int ID, String name, String description, String imgLink, boolean active) {
        this.ID = ID;
        this.name = name;
        this.description = description;
        this.imgLink = imgLink;
        this.active = active;
    }
    public Category() {}

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImgLink() {
        return imgLink;
    }

    public void setImgLink(String imgLink) {
        this.imgLink = imgLink;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
