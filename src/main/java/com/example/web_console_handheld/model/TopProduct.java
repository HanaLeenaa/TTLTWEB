package com.example.web_console_handheld.model;

public class TopProduct {
    private String productName;
    private int totalSold;
    private double revenue;

    public TopProduct(String productName, int totalSold, double revenue) {
        this.productName = productName;
        this.totalSold = totalSold;
        this.revenue = revenue;
    }

    public TopProduct() {
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public void setTotalSold(int totalSold) {
        this.totalSold = totalSold;
    }
    public double getRevenue() {
        return revenue;
    }
    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }
}
