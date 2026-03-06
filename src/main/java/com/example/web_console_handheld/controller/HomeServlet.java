package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.BlogDao;
import com.example.web_console_handheld.dao.CategoryDao;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Blog;
import com.example.web_console_handheld.model.Category;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse resp)
            throws ServletException, IOException {

        CategoryDao categoryDao = new CategoryDao();
        List<Category> categories = categoryDao.getCategory();
        ProductDao productDao = new ProductDao();
        List<Product> productList = productDao.getProductListForHome();
        BlogDao blogDao = new BlogDao();



        request.setAttribute("categories", categories);
        request.setAttribute("products", productList);
        request.setAttribute("highest", productDao.getHighestDiscountProduct());
        request.setAttribute("smaller", productDao.getProductSmallerThanList());
        request.setAttribute("smallest", productDao.getSmallestProduct());
        request.setAttribute("bloglist", blogDao.getBlogList());
        request.getRequestDispatcher("/index.jsp").forward(request, resp);
    }
}

