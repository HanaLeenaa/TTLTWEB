package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


@WebServlet("/admin/products/edit")
public class AdminProductUpdateServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();


    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        Product product = productDao.findById(id);

        req.setAttribute("product", product);
        req.getRequestDispatcher("/Assets/component/adminPage/editProduct.jsp")
                .forward(req, resp);
    }


    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        Product p = new Product();
        p.setID(Integer.parseInt(req.getParameter("id")));
        p.setName(req.getParameter("name"));
        p.setCategories_id(Integer.parseInt(req.getParameter("categories_id")));
        p.setBrand_id(Integer.parseInt(req.getParameter("brand_id")));
        p.setShort_description(req.getParameter("short_description"));
        p.setFull_description(req.getParameter("full_description"));
        p.setInformation(req.getParameter("information"));
        p.setPrice(req.getParameter("price"));
        p.setPriceOld(req.getParameter("priceOld"));
        p.setImage(req.getParameter("image"));
        p.setEnergy(Integer.parseInt(req.getParameter("energy")));
        p.setUseTime(Integer.parseInt(req.getParameter("useTime")));
        p.setWeight(Integer.parseInt(req.getParameter("weight")));
        p.setMetatitle(req.getParameter("metatitle"));
        p.setSuports(req.getParameter("suports"));
        p.setConnect(req.getParameter("connect"));
        p.setEndow(req.getParameter("endow"));
        p.setActive(req.getParameter("active") != null);
        p.setIspremium(req.getParameter("ispremium") != null);

        productDao.update(p);

        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }
}
