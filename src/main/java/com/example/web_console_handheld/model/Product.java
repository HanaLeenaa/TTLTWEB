package com.example.web_console_handheld.model;

import org.jdbi.v3.core.mapper.reflect.ColumnName;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDateTime;

public class Product {
    @ColumnName("ID")
    private int ID;

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
    public Product(long price){
        this.price = price;
    }
    public Product(int ID, int categories_id, int brand_id, String name, String short_description, String full_description, String information, long price, long priceOld, String image, LocalDateTime createdAt, int energy, int useTime, int weight, boolean active, String metatitle, boolean ispremium, String suports, String connect, String endow) {
        this.ID = ID;
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
    }
    public Product() {}

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

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

    public  String getPrice() {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,###", symbols);
        return df.format(this.price);
    }


    public void setPrice(long price) {
        this.price = price;
    }
    public void setPrice(String price) {
        this.price = (long)Double.parseDouble(price);
    }

    public String getPriceOld() {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,###", symbols);
        return df.format(this.priceOld);
    }

    public void setPriceOld(long priceOld) {
        this.priceOld = priceOld;
    }
    public void setPriceOld(String priceOld){
        this.priceOld = (long)Double.parseDouble(priceOld);
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

    public boolean isIspremium() {
        return ispremium;
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
}
