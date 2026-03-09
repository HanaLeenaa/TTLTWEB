package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Blog;

import java.util.List;

public class BlogDao extends BaseDao{
    public List<Blog> getBlogList() {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT * FROM blog " +
                                        "where active = 1 " +
                                        "ORDER BY ID DESC " +
                                        "LIMIT 4"
                        )
                        .mapToBean(Blog.class)
                        .list()
        );
    }
}
