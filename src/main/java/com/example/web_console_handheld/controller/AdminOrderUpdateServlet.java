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
        String status = request.getParameter("status").trim();
        OrderDao orderDao = new OrderDao();

        boolean success = orderDao.updateStatus(id, status);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?success=updated");
        }else {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=invalid-status");
        }
    }
}
