package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    ProductDao productDAO = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> list = productDAO.getAll();
        request.setAttribute("products", list);
        request.setAttribute("contentPage", "/Assets/component/adminPage/productManagement.jsp");

        request.getRequestDispatcher( "/Assets/component/adminPage/admin.jsp").forward(request, response);
    }
}
