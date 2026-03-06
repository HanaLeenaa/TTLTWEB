package com.example.web_console_handheld.model;

public class Gallary {
    private int ID;
    private int product_id;
    private String metatitle;
    private String img;

    public Gallary(int ID, int product_id, String metatitle, String img) {
        this.ID = ID;
        this.product_id = product_id;
        this.metatitle = metatitle;
        this.img = img;
    }
public Gallary() {}
    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public String getMetatitle() {
        return metatitle;
    }

    public void setMetatitle(String metatitle) {
        this.metatitle = metatitle;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }
}
