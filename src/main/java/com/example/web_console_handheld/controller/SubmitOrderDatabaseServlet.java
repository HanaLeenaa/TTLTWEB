package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;
import com.example.web_console_handheld.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/submit-order-database")
public class SubmitOrderDatabaseServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final CartDao cartDao = new CartDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");
        Order order = (Order) session.getAttribute("pendingOrder");
        List<OrderItem> cartItems = (List<OrderItem>) session.getAttribute("pendingOrderItems");
        Boolean buyNowMode = (Boolean) session.getAttribute("buyNowMode");

        if (user == null || order == null || cartItems == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            long now = System.currentTimeMillis();

            Integer fee = (Integer) session.getAttribute("shippingFee");
            Integer leadTime = (Integer) session.getAttribute("leadTime");

            if (leadTime == null || leadTime <= 0) {
                leadTime = 3;
            }

            int orderId = orderDao.createOrderTransactionWithLog(order, cartItems);

            if (orderId <= 0) {
                throw new RuntimeException("Không thể tạo đơn hàng");
            }

            if (Boolean.TRUE.equals(buyNowMode)) {
                session.removeAttribute("buyNowMode");
                session.removeAttribute("pendingOrderItems");
            } else {
                for (OrderItem item : cartItems) {
                    cartDao.removeItem(user.getId(), item.getProduct_id());
                }
            }

            List<CartItem> remainingCart =
                    cartDao.getCartByUser(user.getId());

            int totalQty = 0;

            if (remainingCart != null) {
                for (CartItem c : remainingCart) {
                    totalQty += c.getQuantity();
                }
            }
            session.setAttribute("cartSize", totalQty);

            request.setAttribute("confirmed", true);
            request.setAttribute("order", order);
            request.setAttribute("orderItems", cartItems);
            request.setAttribute("shippingFee", fee);

            request.getRequestDispatcher("/Assets/component/cart_payment/Order.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            session.setAttribute("cartError", "Lỗi hệ thống: " + e.getMessage());

            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}