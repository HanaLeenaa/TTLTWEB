package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Product;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/search-suggest")
public class SearchSuggestServlet extends HttpServlet {

    private ProductDao productDao;

    @Override
    public void init() {
        productDao = new ProductDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String keyword = req.getParameter("q");

        if (keyword == null || keyword.trim().length() < 2) {
            resp.getWriter().write("[]");
            return;
        }

        List<Product> list = productDao.suggestByName(keyword.trim());

        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            Product p = list.get(i);
            json.append("{")
                    .append("\"id\":").append(p.getID()).append(",")
                    .append("\"name\":\"").append(escape(p.getName())).append("\",")
                    .append("\"image\":\"").append(escape(p.getImage())).append("\",")
                    .append("\"metatitle\":\"").append(escape(p.getMetatitle())).append("\"")
                    .append("}");
            if (i < list.size() - 1) json.append(",");
        }
        json.append("]");

        resp.getWriter().write(json.toString());
    }

    private String escape(String s) {
        return s == null ? "" : s.replace("\"", "\\\"");
    }
}

