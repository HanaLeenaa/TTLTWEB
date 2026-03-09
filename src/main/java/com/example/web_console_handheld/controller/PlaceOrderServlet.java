package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/place-order")
public class PlaceOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User auth = (User) session.getAttribute("auth");
        if (auth == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ✅ LẤY ĐÚNG SẢN PHẨM ĐÃ CHỌN
        List<CartItem> selectedItems =
                (List<CartItem>) session.getAttribute("selectedCartItems");

        if (selectedItems == null || selectedItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // ===== TẠO ORDER =====
        Order order = new Order();
        order.setUser_Id(auth.getId());
        order.setCreateAt(new Timestamp(System.currentTimeMillis()));
        order.setStatus("PENDING");

        // thông tin người nhận
        order.setReceiver_name(auth.getUsername());
        order.setReceiver_phone(auth.getPhoneNum());
        order.setReceiver_email(auth.getEmail());

        String address = request.getParameter("address");
        order.setReceiver_address(
                (address != null && !address.isBlank())
                        ? address
                        : auth.getLocation()
        );

        // payment_method: false = COD, true = BANK
        order.setPayment_method(
                "BANK".equals(request.getParameter("paymentMethod"))
        );

        // ===== ORDER ITEMS =====
        List<OrderItem> orderItems = new ArrayList<>();
        long totalPrice = 0;

        for (CartItem ci : selectedItems) {
            OrderItem item = new OrderItem();
            item.setProduct_id(ci.getProduct().getID());
            item.setProduct_name(ci.getProduct().getName());
            item.setProduct_price(ci.getProduct().getPriceValue());
            item.setQuantity(ci.getQuantity());

            totalPrice += item.getProduct_price() * item.getQuantity();
            orderItems.add(item);
        }

        order.setPrice(totalPrice);

        // ===== LƯU SESSION =====
        session.setAttribute("pendingOrder", order);
        session.setAttribute("pendingOrderItems", orderItems);

        // ===== ĐẨY SANG JSP =====
        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("confirmed", false);

        request.getRequestDispatcher(
                "/Assets/component/cart_payment/Order.jsp"
        ).forward(request, response);
    }
}
