package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/approve-cancel-order")
public class AdminApproveCancelOrderServlet extends HttpServlet {
    private OrderDao orderDao = new OrderDao();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        boolean result = orderDao.cancelOrder(orderId);
        if (result) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?id=" + orderId + "&success=cancel-approved");

        }else {
            response.sendRedirect(request.getContextPath() + "/admin/orders?id=" + orderId + "&error=cancel-failed");
        }
    }
}
