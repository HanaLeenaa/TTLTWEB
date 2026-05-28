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

//            Dùng TRANSACTION để trừ stock sau khi lưu orderitem
            boolean success = dao.createOrderTransaction(order, items);

            if (!success) {
                session.setAttribute("cartError",
                        "Đặt hàng thất bại hoặc sản phẩm không đủ tồn kho!");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if (cart != null) {
                for (OrderItem item : items) {
                    cart.remove(item.getProduct_id());
                }
                session.setAttribute("cart", cart);
            }

            session.removeAttribute("pendingOrder");
            session.removeAttribute("pendingOrderItems");
            session.removeAttribute("selectedCartItems");

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

