package com.example.web_console_handheld.model;

public class StatisticsItem {
    private String label;
    private int totalOrders;
    private int totalProducts;
    private double revenue;

    public StatisticsItem() {
    }

    public StatisticsItem(String label, int totalOrders, int totalProducts, double revenue) {
        this.label = label;
        this.totalOrders = totalOrders;
        this.totalProducts = totalProducts;
        this.revenue = revenue;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public int getTotalProducts() {
        return totalProducts;
    }

    public void setTotalProducts(int totalProducts) {
        this.totalProducts = totalProducts;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }
}
