package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.model.Cart;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/confirm-order")
public class ConfirmOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        Order order = (Order) session.getAttribute("pendingOrder");
        List<OrderItem> items =
                (List<OrderItem>) session.getAttribute("pendingOrderItems");
        Cart cart = (Cart) session.getAttribute("cart");

        if (order == null || items == null || items.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            OrderDao dao = new OrderDao();

            // 1️⃣ LƯU ORDER
            int orderId = dao.saveOrder(order);
            if (orderId <= 0) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // 2️⃣ LƯU ORDER ITEMS
            dao.saveOrderItems(orderId, items);

            // 3️⃣ TRỪ ĐÚNG SẢN PHẨM ĐÃ MUA KHỎI CART
            if (cart != null) {
                for (OrderItem item : items) {
                    cart.remove(item.getProduct_id());
                }
                session.setAttribute("cart", cart);
            }

            // 4️⃣ CLEAR SESSION TẠM
            session.removeAttribute("pendingOrder");
            session.removeAttribute("pendingOrderItems");
            session.removeAttribute("selectedCartItems");

            // 5️⃣ FLAG CHO JSP
            request.setAttribute("confirmed", true);
            request.setAttribute("order", order);
            request.setAttribute("orderItems", items);

            request.getRequestDispatcher(
                    "/Assets/component/cart_payment/Order.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}

