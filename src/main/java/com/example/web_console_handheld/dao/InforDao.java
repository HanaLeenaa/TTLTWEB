package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Contact;


public class InforDao extends BaseDao{
    public Contact getContact(int id){
        return get().withHandle(handle -> handle.createQuery("select * from contact where ID = :id").bind("id", id).mapToBean(Contact.class).stream().findFirst().orElse(null));
    }

}
