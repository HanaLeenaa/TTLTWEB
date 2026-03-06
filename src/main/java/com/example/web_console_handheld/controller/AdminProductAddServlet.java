package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/products/add")
public class AdminProductAddServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();


    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/Assets/component/adminPage/addProduct.jsp")
                .forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        Product p = new Product();

        p.setName(req.getParameter("name"));
        p.setPrice(req.getParameter("price"));
        p.setPriceOld(req.getParameter("priceOld"));
        p.setImage(req.getParameter("image"));

        p.setCategories_id(parseInt(req.getParameter("categories_id")));
        p.setBrand_id(parseInt(req.getParameter("brand_id")));

        p.setShort_description(req.getParameter("short_description"));
        p.setFull_description(req.getParameter("full_description"));
        p.setInformation(req.getParameter("information"));

        p.setEnergy(parseInt(req.getParameter("energy")));
        p.setUseTime(parseInt(req.getParameter("useTime")));
        p.setWeight(parseInt(req.getParameter("weight")));

        p.setMetatitle(req.getParameter("metatitle"));
        p.setSuports(req.getParameter("suports"));
        p.setConnect(req.getParameter("connect"));
        p.setEndow(req.getParameter("endow"));

        p.setActive(req.getParameter("active") != null);
        p.setIspremium(req.getParameter("ispremium") != null);

        p.setCreatedAt(java.time.LocalDateTime.now());

        productDao.insert(p);

        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private int parseInt(String v) {
        return (v == null || v.isEmpty()) ? 0 : Integer.parseInt(v);
    }
}

