package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
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

        List<CartItem> selectedItems =
                (List<CartItem>) session.getAttribute("selectedCartItems");

        List<OrderItem> orderItems = new ArrayList<>();
        long totalPrice = 0;

        Cart cart = (Cart) session.getAttribute("cart");

        //CHECKOUT TỪ CART
        if (selectedItems != null && !selectedItems.isEmpty()) {

            for (CartItem ci : selectedItems) {

                OrderItem oi = new OrderItem();
                oi.setProduct_id(ci.getProduct().getID());
                oi.setProduct_name(ci.getProduct().getName());
                oi.setQuantity(ci.getQuantity());
                oi.setProduct_price(ci.getProduct().getPriceValue());
                oi.setProduct_image(ci.getProduct().getImage());

                totalPrice += oi.getProduct_price() * oi.getQuantity();
                orderItems.add(oi);


            }
            session.removeAttribute("selectedCartItems");
        }

        // BUY NOW
        else {
            List<OrderItem> pendingItems = (List<OrderItem>) session.getAttribute("pendingOrderItems");

            if (pendingItems == null || pendingItems.isEmpty()) {
                return;
            }
            orderItems = pendingItems;

            for (OrderItem oi : orderItems) {
                totalPrice += oi.getProduct_price() * oi.getQuantity();
            }
            session.removeAttribute("pendingOrderItems");
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
