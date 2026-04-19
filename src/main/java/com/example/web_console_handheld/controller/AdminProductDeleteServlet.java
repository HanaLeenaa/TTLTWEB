package com.example.web_console_handheld.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

import com.example.web_console_handheld.dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/products/delete")
public class AdminProductDeleteServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        try {
            int id = Integer.parseInt(idParam);
            ProductDao productDao = new ProductDao();
            boolean deleted = productDao.deleteProductWithGallery(id);
            if (deleted) {
                resp.sendRedirect(req.getContextPath() + "/admin/products?success=deleted");
            }else{
                resp.sendRedirect(req.getContextPath() + "/admin/products?error=deletefail");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/products?error=invalidid");
        }
    }

}
