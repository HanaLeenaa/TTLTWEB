package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/order-detail")
public class OrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        Boolean confirmed = (Boolean) session.getAttribute("orderConfirmed");

        Order order = null;
        List<OrderItem> items = null;

        // đã xác nhận
        if (confirmed != null && confirmed) {

            Integer orderId = (Integer) session.getAttribute("confirmedOrderId");
            if (orderId == null) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            try {
                OrderDao dao = new OrderDao();

                // ấy từ db
                order = dao.getOrderById(orderId);
                items = dao.getOrderItemsByOrderId(orderId);

            } catch (Exception e) {
                e.printStackTrace();
            }

            //nếu DB chưa load kịp hoặc lỗi -> lấy session
            if (order == null || items == null || items.isEmpty()) {
                order = (Order) session.getAttribute("pendingOrder");
                items = (List<OrderItem>) session.getAttribute("pendingOrderItems");
            }

            if (order == null || items == null || items.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            request.setAttribute("confirmed", true);
        }
        //chưa xác nhận
        else {
            order = (Order) session.getAttribute("pendingOrder");
            items = (List<OrderItem>) session.getAttribute("pendingOrderItems");

            if (order == null || items == null || items.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            request.setAttribute("confirmed", false);
        }

        //set attribute chung
        request.setAttribute("order", order);
        request.setAttribute("orderItems", items);

        request.getRequestDispatcher("/Assets/component/cart_payment/Order.jsp")
                .forward(request, response);
    }
}
