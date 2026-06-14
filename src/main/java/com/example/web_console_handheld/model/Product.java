package com.example.web_console_handheld.model;

import org.jdbi.v3.core.mapper.reflect.ColumnName;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDateTime;

public class Product {
    @ColumnName("ID")
    private int ID;

    @ColumnName("parent_id")
    private Integer parent_id;

    @ColumnName("color_name")
    private String color_name;

    @ColumnName("color_code")
    private String color_code;

    @ColumnName("categories_id")
    private int categories_id;

    @ColumnName("brand_id")
    private int brand_id;

    private String name;

    @ColumnName("short_description")
    private String short_description;

    @ColumnName("full_description")
    private String full_description;

    private String information;

    private long price;

    @ColumnName("priceOld")
    private long priceOld;

    private String image;

    @ColumnName("createdAt")
    private LocalDateTime createdAt;

    private int energy;

    private int useTime;

    private int weight;

    private boolean active;

    private String metatitle;

    @ColumnName("ispremium")
    private boolean ispremium;

    private String suports;

    private String connect;
    @ColumnName("endow")
    private String endow;

    @ColumnName("stock")
    private int stock;
    @ColumnName("sales_count")
    private int sales_count;

    private int stock_quantity;


    public Product(long price){
        this.price = price;
    }


    public Product(int ID, Integer parent_id, String color_name, String color_code, int categories_id, int brand_id, String name, String short_description, String full_description, String information,
                   long price, long priceOld, String image, LocalDateTime createdAt, int energy, int useTime, int weight, boolean active,
                   String metatitle, boolean ispremium, String suports, String connect, String endow, int stock, int sales_count, int  stock_quantity) {
        this.ID = ID;
        this.parent_id = parent_id;
        this.color_name = color_name;
        this.color_code = color_code;
        this.categories_id = categories_id;
        this.brand_id = brand_id;
        this.name = name;
        this.short_description = short_description;
        this.full_description = full_description;
        this.information = information;
        this.price = price;
        this.priceOld = priceOld;
        this.image = image;
        this.createdAt = createdAt;
        this.energy = energy;
        this.useTime = useTime;
        this.weight = weight;
        this.active = active;
        this.metatitle = metatitle;
        this.ispremium = ispremium;
        this.suports = suports;
        this.connect = connect;
        this.endow = endow;
        this.stock = stock;
        this.sales_count = sales_count;
        this.stock_quantity = stock_quantity;
    }
    public Product() {
    }

    public int getID() {
        return ID;
    }

    public int getId() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public void setId(int id) { this.ID = id; }

    public Integer getParent_id() { return parent_id; }
    public void setParent_id(Integer parent_id) { this.parent_id = parent_id; }
    public String getColor_name() { return color_name; }
    public void setColor_name(String color_name) { this.color_name = color_name; }
    public String getColor_code() { return color_code; }
    public void setColor_code(String color_code) { this.color_code = color_code; }

    public int getCategories_id() {
        return categories_id;
    }

    public void setCategories_id(int categories_id) {
        this.categories_id = categories_id;
    }

    public int getBrand_id() {
        return brand_id;
    }

    public void setBrand_id(int brand_id) {
        this.brand_id = brand_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getShort_description() {
        return short_description;
    }

    public void setShort_description(String short_description) {
        this.short_description = short_description;
    }

    public String getFull_description() {
        return full_description;
    }

    public void setFull_description(String full_description) {
        this.full_description = full_description;
    }

    public String getInformation() {
        return information;
    }

    public void setInformation(String information) {
        this.information = information;
    }

    public long getPrice() {
        return price; // dùng cho tính toán, lưu DB
    }

    public void setPrice(long price) {
        this.price = price;
    }

    public String getPriceFormatted() {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,###", symbols);
        return df.format(this.price); // dùng cho hiển thị
    }

    // Giá cũ
    public long getPriceOld() {
        return priceOld; // dùng cho tính toán, lưu DB
    }

    public void setPriceOld(long priceOld) {
        this.priceOld = priceOld;
    }

    public String getPriceOldFormatted() {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,###", symbols);
        return df.format(this.priceOld); // dùng cho hiển thị
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public int getEnergy() {
        return energy;
    }

    public void setEnergy(int energy) {
        this.energy = energy;
    }

    public int getUseTime() {
        return useTime;
    }

    public void setUseTime(int useTime) {
        this.useTime = useTime;
    }

    public int getWeight() {
        return weight;
    }

    public void setWeight(int weight) {
        this.weight = weight;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getMetatitle() {
        return metatitle;
    }

    public void setMetatitle(String metatitle) {
        this.metatitle = metatitle;
    }

    public void setIspremium(boolean ispremium) {
        this.ispremium = ispremium;
    }

    public String getSuports() {
        return suports;
    }

    public void setSuports(String suports) {
        this.suports = suports;
    }

    public String getConnect() {
        return connect;
    }

    public void setConnect(String connect) {
        this.connect = connect;
    }

    public String getEndow() {
        return endow;
    }

    public void setEndow(String endow) {
        this.endow = endow;
    }

    //thêm để tính giá trong cart
    public long getPriceValue() {
        return this.price;
    }

    public long getPriceOldValue() {
        return this.priceOld;
    }
    public void setPriceOldValue(long priceOldValue) {
        this.priceOld = priceOldValue;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getSales_count() {
        return sales_count;
    }

    public void setSales_count(int sales_count) {
        this.sales_count = sales_count;
    }

    public void setStock_quantity(int stock_quantity) {
        this.stock_quantity = stock_quantity;
    }

    public int getStock_quantity() {
        return stock_quantity;
    }

    public int getCategoriesId() { return categories_id; }
    public void setCategoriesId(int categoriesId) { this.categories_id = categoriesId; }

    public boolean getIspremium() {
        return this.ispremium;
    }

    public Integer getParentId() {
        return this.parent_id;
    }

    public int getSalesCount() {
        return this.sales_count;
    }

    public int getStockQuantity() {
        return this.stock_quantity;
    }

    public void setParentId(Integer parentId) {
        this.parent_id = parentId;
    }

    public void setSalesCount(int salesCount) {
        this.sales_count = salesCount;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stock_quantity = stockQuantity;
    }

}
