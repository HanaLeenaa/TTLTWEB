package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Icon;

import java.util.List;

public class IconDao extends BaseDao{
    public List<Icon> getIcon(){
        return get().withHandle(handle -> handle.createQuery("select * from icon where active = 1").mapToBean(Icon.class).list());
    }

}
