package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Banner;

import java.util.List;

public class BannerDao extends BaseDao{
    public List<Banner> getActiveBanners(){
        return get().withHandle(handle -> handle.createQuery("select * from banner where active = 1").mapToBean(Banner.class).list());
    }
}
