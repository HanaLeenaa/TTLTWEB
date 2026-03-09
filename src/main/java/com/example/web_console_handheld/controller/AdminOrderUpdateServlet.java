package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/order-update")
public class AdminOrderUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        new OrderDao().updateStatus(id, status);

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
