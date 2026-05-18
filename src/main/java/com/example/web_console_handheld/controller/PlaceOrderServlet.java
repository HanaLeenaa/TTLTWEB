package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.dao.ProductDao;
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

        // CHECK STOCK
        ProductDao productDao = new ProductDao();

        for (OrderItem oi : orderItems) {
            Product product = productDao.getProductDetailByID(oi.getProduct_id());

            //sản phẩm không tồn tại
            if (product == null) {
                request.setAttribute("cartError", "Sản phẩm không tồn tại!");

                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            //hết hàng
            if (product.getStock() <= 0) {
                request.setAttribute("cartError", product.getName() + "đã hết hàng!");

                response.sendRedirect(request.getContextPath() + "/cart");
                return;

            }

            //vượt tồn kho
            if (oi.getQuantity() > product.getStock()) {
                session.setAttribute(
                        "cartError",
                        "Sản phẩm " + product.getName()
                                + " chỉ còn "
                                + product.getStock()
                                + " sản phẩm!"
                );
                response.sendRedirect(
                        request.getContextPath() + "/cart"
                );
                return;
            }
        }


        // ===== TẠO ORDER =====
        Order order = new Order();
        order.setUser_Id(auth.getId());
        order.setCreateAt(new Timestamp(System.currentTimeMillis()));
        order.setStatus("Chờ xác nhận");

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

        String note = request.getParameter("note");
        order.setReceiver_note(note);
        order.setPayment_method(request.getParameter("paymentMethod"));

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
