package com.example.web_console_handheld.model;

public class Blog {
    private int ID;
    private String img;
    private String title;
    private String metatitle;
    private String description;
    private boolean active;
    private int playorder;

    public Blog(String title, int ID, String img, String metatitle, String description, boolean active, int playorder) {
        this.title = title;
        this.ID = ID;
        this.img = img;
        this.metatitle = metatitle;
        this.description = description;
        this.active = active;
        this.playorder = playorder;
    }
    public Blog() {
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMetatitle() {
        return metatitle;
    }

    public void setMetatitle(String metatitle) {
        this.metatitle = metatitle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public int getPlayorder() {
        return playorder;
    }

    public void setPlayorder(int playorder) {
        this.playorder = playorder;
    }
}
