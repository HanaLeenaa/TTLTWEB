package com.example.web_console_handheld.model;

public class Banner {
    private int ID;
    private String title;
    private String link;
    private boolean active;

    public Banner(int ID, String title, String link, boolean active) {
        this.ID = ID;
        this.title = title;
        this.link = link;
        this.active = active;
    }
    public Banner(){

    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
