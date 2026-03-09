package com.example.web_console_handheld.model;

import java.io.Serializable;

public class Logo implements Serializable {
    private int ID;
    private String titleLogo;
    private String linkLogo;
    public Logo(){

    }

    public Logo(int ID, String titleLogo, String linkLogo) {
        this.ID = ID;
        this.titleLogo = titleLogo;
        this.linkLogo = linkLogo;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getTitleLogo() {
        return titleLogo;
    }

    public void setTitleLogo(String titleLogo) {
        this.titleLogo = titleLogo;
    }

    public String getLinkLogo() {
        return linkLogo;
    }

    public void setLinkLogo(String linkLogo) {
        this.linkLogo = linkLogo;
    }
}
