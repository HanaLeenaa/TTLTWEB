package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        OrderDao dao = new OrderDao();

        // danh sách đơn
        request.setAttribute("orders", dao.getAllOrders());

        // nếu có chọn đơn
        String idRaw = request.getParameter("id");
        if (idRaw != null) {
            int id = Integer.parseInt(idRaw);
            request.setAttribute("selectedOrder", dao.getOrderById(id));
            request.setAttribute("orderItems", dao.getOrderItemsByOrderId(id));
        }

        request.getRequestDispatcher("/Assets/component/adminPage/ordersManagement.jsp").forward(request, response);

    }
}
