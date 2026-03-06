package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Gallary;

import java.util.List;

public class GallaryDao extends BaseDao{
    public List<Gallary> getListGallaryBy_product_id(int product_id){
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM gallary WHERE product_id = :id").bind("id", product_id).mapToBean(Gallary.class).list()
        );
}}
