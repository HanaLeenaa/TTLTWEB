package com.example.web_console_handheld.model;

public class Admin {
   private int ID;
    private String username;
    private String password;
    private String fullname;
    private int role;

    public Admin(int ID, String username, String password, String fullname, int role) {
        this.ID = ID;
        this.password = password;
        this.username = username;
        this.fullname = fullname;
        this.role = role;
    }

    public int getID() { return ID; }
    public void setID(int ID) { this.ID = ID; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public int getRole() { return role; }
    public void setRole(int role) { this.role = role; }
}
