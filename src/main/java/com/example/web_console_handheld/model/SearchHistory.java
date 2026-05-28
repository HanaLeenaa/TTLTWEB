package com.example.web_console_handheld.model;

import java.sql.Timestamp;

public class SearchHistory {
    private int id;
    private int userId;
    private String keyword;
    private Timestamp searchedAt;

    // Getter & Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public Timestamp getSearchedAt() { return searchedAt; }
    public void setSearchedAt(Timestamp searchedAt) { this.searchedAt = searchedAt; }
}
