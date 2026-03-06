package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Category;

import java.util.List;

public class CategoryDao extends BaseDao{
    public List<Category> getCategory(){
        return get().withHandle(handle -> handle.createQuery("select * from categories where active = 1").mapToBean(Category.class).list());
    }
    public Category getCategoryByProductId(int productId) {
        return get().withHandle(handle ->
                handle.createQuery("""
            SELECT c.*
            FROM categories c
            JOIN products p ON p.categories_id = c.ID
            WHERE p.ID = :id
        """)
                        .bind("id", productId)
                        .mapToBean(Category.class)
                        .first()
        );
    }

}
