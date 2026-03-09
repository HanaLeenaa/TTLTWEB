package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Logo;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.PreparedBatch;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class LogoDao extends BaseDao{
    static Map<Integer, Logo> data = new HashMap<>();
    static{
        data.put(1, new Logo(1, "Logo 1", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaVtA9aH8iRQnDsQmBTt9yyB5mCIaYp8T0Qg&s"));
        data.put(2, new Logo(2, "Logo 2", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHfOfjKydC4TYKQFJnDAGxMFgc-lijcYKk-g&s"));
        data.put(3, new Logo(3, "Logo 3", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNhDsdA_PWXkUZ3ijwSU_9rpenL-Dsu_wuFQ&s"));
    }
    public void insert(List<Logo> logos){
        Jdbi jdbi = get();
        jdbi.useHandle(handle -> {
            PreparedBatch batch = handle.prepareBatch("insert into logo values (:ID, :titleLogo, :linkLogo)");
            logos.forEach(logo -> {
                batch.bindBean(logo).add();
            });
            batch.execute();
        });
    }
    public List<Logo> getListLogos(){
        return new ArrayList<>(data.values());
    }
    public Logo getLogo(int id){
        return get().withHandle(handle -> handle.createQuery("select * from logo where ID = :id").bind("id", id).mapToBean(Logo.class).stream().findFirst().orElse(null));
    }
    public static void main(String[] args) {
        LogoDao logoDao = new LogoDao();
        List<Logo> logos = logoDao.getListLogos();
        logoDao.insert(logos);
    }
}
