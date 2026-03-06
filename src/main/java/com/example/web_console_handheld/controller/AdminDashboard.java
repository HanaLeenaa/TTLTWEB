package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboard extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductDao productDao = new ProductDao();
        OrderDao orderDao = new OrderDao();
        UserDao userDao = new UserDao();

        List<Product> productList = productDao.getAll();
        int totalProducts = productList.size();
        List<Order> orderList = orderDao.getAllOrders();
        int totalOrders = orderList.size();
        int totalUsers = userDao.countAll();
        double totalRevenue = orderDao.getTotalRevenue();

        List<Order> recentOrders = orderDao.getRecentOrders(5);

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentOrders", recentOrders);
        request.getRequestDispatcher("/Assets/component/adminPage/adminDashboard.jsp").forward(request, response);
    }
}
