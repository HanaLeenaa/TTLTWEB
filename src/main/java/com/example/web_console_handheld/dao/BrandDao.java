package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Brand;

import java.util.List;

public class BrandDao extends BaseDao{
    public List<Brand> getBrands() {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT * FROM brands " +
                                        "WHERE active = 1 "
                        )
                        .mapToBean(Brand.class)
                        .list()
        );
    }

    public Brand getBrandByProductId(int productId) {
        return get().withHandle(handle ->
                handle.createQuery("""
            SELECT b.*
            FROM brands b
            JOIN products p ON p.brand_id = b.ID
            WHERE p.ID = :id
        """)
                        .bind("id", productId)
                        .mapToBean(Brand.class)
                        .first()
        );
    }
}
