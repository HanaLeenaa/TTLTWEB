package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.model.*;
import com.example.web_console_handheld.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getCartItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String[] selectedIds = request.getParameterValues("selectedItems");
        if (selectedIds == null || selectedIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        Set<Integer> selectedSet = Arrays.stream(selectedIds)
                .map(Integer::parseInt)
                .collect(Collectors.toSet());

        // Lọc cart chỉ lấy item được chọn
        List<CartItem> selectedItems = cart.getCartItems().values().stream()
                .filter(item -> selectedSet.contains(item.getProduct().getID()))
                .collect(Collectors.toList());


        List<OrderItem> orderItems = new ArrayList<>();

            for (CartItem ci : selectedItems) {

                OrderItem oi = new OrderItem();
                oi.setProduct_id(ci.getProduct().getID());
                oi.setProduct_name(ci.getProduct().getName());
                oi.setQuantity(ci.getQuantity());
                oi.setProduct_price(ci.getProduct().getPriceValue());
                oi.setProduct_image(ci.getProduct().getImage());

                orderItems.add(oi);

            }

            session.setAttribute("selectedCartItems", selectedItems);
            request.setAttribute("orderItems", orderItems);
            request.getRequestDispatcher("/Assets/component/cart_payment/payment.jsp")
                .forward(request, response);
    }
}
