package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.service.GHNService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/confirm-order")
public class ConfirmOrderServlet extends HttpServlet {
    private final CartDao cartDao = new CartDao();
    private final GHNService ghnService = new GHNService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("auth");
        if (user == null) {
            session.setAttribute("cartError", "Vui lòng đăng nhập!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Boolean buyNowMode = (Boolean) session.getAttribute("buyNowMode");

        List<OrderItem> cartItems = new ArrayList<>();
        long totalAmount = 0;

        if (Boolean.TRUE.equals(buyNowMode)) {
            List<OrderItem> buyNowItems = (List<OrderItem>) session.getAttribute("pendingOrderItems");
            if (buyNowItems == null || buyNowItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/product");
                return;
            }
            cartItems.addAll(buyNowItems);
            for (OrderItem item : cartItems) {
                totalAmount += item.getProduct_price() * item.getQuantity();
            }
        } else {
            List<CartItem> dbCart = cartDao.getCartByUser(user.getId());
            if (dbCart == null || dbCart.isEmpty()) {
                session.setAttribute("cartError", "Giỏ hàng trống!");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            String[] selectedItems = request.getParameterValues("selectedItems");
            List<String> selectedList =
                    (selectedItems != null) ? Arrays.asList(selectedItems) : null;

            for (CartItem c : dbCart) {

                if (c.getProduct() == null) continue;

                String pid = String.valueOf(c.getProduct().getID());

                if (selectedList == null || selectedList.contains(pid)) {

                    OrderItem item = new OrderItem();
                    item.setProduct_id(c.getProduct().getID());
                    item.setProduct_name(c.getProduct().getName());
                    item.setProduct_image(c.getProduct().getImage());
                    item.setProduct_price(c.getProduct().getPrice());
                    item.setQuantity(c.getQuantity());

                    cartItems.add(item);

                    totalAmount += c.getProduct().getPrice() * c.getQuantity();
                }
            }

            if (cartItems.isEmpty()) {
                session.setAttribute("cartError", "Không có sản phẩm hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }

        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("payment_method");

        Order order = new Order();
        order.setUser_Id(user.getId());
        order.setCreateAt(new Timestamp(System.currentTimeMillis()));
        order.setStatus("Chờ xác nhận");
        order.setPrice(totalAmount);
        order.setReceiver_name(fullname);
        order.setReceiver_phone(phone);
        order.setReceiver_address(address);
        order.setReceiver_email(email);
        order.setReceiver_note(note);

        order.setPayment_method(paymentMethod != null && !paymentMethod.trim().isEmpty()
                ? paymentMethod.trim().toUpperCase() : "COD");

        order.setPayment_status("UNPAID");

        int fee = 0;
        long now = System.currentTimeMillis();

        try {
            int fromDistrict = 1454;
            String fromWard = "21005";

            int toDistrict = 1452;
            String toWard = "21810";

            fee = ghnService.calculateFee(fromDistrict, toDistrict, 1000);

            int leadTime = ghnService.calculateLeadTime(fromDistrict, fromWard, toDistrict, toWard);

            order.setShippingFee(fee);

            order.setExpectedDeliveryFrom(new Timestamp(now + 2L * 24 * 60 * 60 * 1000));

            order.setExpectedDeliveryTo(new Timestamp(now + (leadTime > 0
                            ? leadTime * 1000L : 4L * 24 * 60 * 60 * 1000)));

        } catch (Exception e) {
            e.printStackTrace();

            order.setShippingFee(0);
            order.setExpectedDeliveryFrom(null);
            order.setExpectedDeliveryTo(null);
        }

        session.setAttribute("pendingOrder", order);
        session.setAttribute("pendingOrderItems", cartItems);

        request.setAttribute("confirmed", false);
        request.setAttribute("order", order);
        request.setAttribute("orderItems", cartItems);
        request.setAttribute("shippingFee", fee);

        request.getRequestDispatcher("/Assets/component/cart_payment/Order.jsp").forward(request, response);
    }
}