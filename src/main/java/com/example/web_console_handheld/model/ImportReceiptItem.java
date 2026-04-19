package com.example.web_console_handheld.model;

public class ImportReceiptItem {
    private int productId;
    private String productName;
    private int quantity;

    public ImportReceiptItem(int productId, int quantity, String productName) {
        this.productId = productId;
        this.quantity = quantity;
        this.productName = productName;
    }

    public ImportReceiptItem() {

    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }
}
