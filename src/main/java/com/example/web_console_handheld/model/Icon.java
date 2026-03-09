package com.example.web_console_handheld.model;

public class Icon{
    private int ID;
    private String title;
    private String link_icon;
    private boolean active;

    public Icon(int ID, String title, String link_icon, boolean active) {
        this.ID = ID;
        this.title = title;
        this.link_icon = link_icon;
        this.active = active;
    }
    public Icon(){}
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

    public String getLink_icon() {
        return link_icon;
    }

    public void setLink_icon(String link_icon) {
        this.link_icon = link_icon;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
