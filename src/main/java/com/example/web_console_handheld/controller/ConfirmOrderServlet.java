package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.dao.VoucherDao;
import com.example.web_console_handheld.model.*;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.service.GHNService;
import com.example.web_console_handheld.service.DeliveryTimeService;

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

    private CartDao cartDao = new CartDao();
    private VoucherDao voucherDao = new VoucherDao();

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
        long discountAmount = 0;
        Voucher selectedVoucher = null;

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

        User auth = (User) session.getAttribute("auth");

        if (fullname == null || fullname.isBlank()) fullname = auth.getUsername();
        if (phone == null || phone.isBlank()) phone = auth.getPhoneNum();
        if (email == null || email.isBlank()) email = auth.getEmail();
        if (address == null || address.isBlank()) address = auth.getLocation();

        Integer voucherId = (Integer) session.getAttribute("selectedVoucherId");

        if (voucherId != null) {

            if (voucherDao.hasUsedVoucher(user.getId(), voucherId)) {
                session.setAttribute("cartError",
                        "Không thể sử dụng lại do bạn đã sử dụng voucher này trước đó!");

                response.sendRedirect(request.getContextPath() + "/payment");
                return;
            }

            selectedVoucher = voucherDao.getVoucherById(voucherId);

            if (selectedVoucher != null) {
                if ("PERCENT".equals(selectedVoucher.getDiscount_type())) {
                    discountAmount = (long) (totalAmount * selectedVoucher.getDiscount_value().doubleValue() / 100);
                }else {
                    discountAmount = selectedVoucher.getDiscount_value().longValue();
                }
                if (selectedVoucher.getMax_discount() != null) {
                    discountAmount = Math.min(discountAmount, selectedVoucher.getMax_discount().longValue());
                }
            }
        }
        // 5. ĐÓNG GÓI ĐỐI TƯỢNG ORDER TẠM THỜI
        Order order = new Order();
        order.setUser_Id(user.getId());
        order.setCreateAt(new Timestamp(System.currentTimeMillis()));
        order.setStatus("Chờ xác nhận");
        order.setVoucher_id(selectedVoucher != null ? selectedVoucher.getID() : null);
        order.setDiscount_amount(discountAmount);
        long finalAmount = Math.max(0, totalAmount - discountAmount);
        order.setFinal_amount(finalAmount);
        order.setPrice(totalAmount);
        order.setReceiver_name(fullname);
        order.setReceiver_phone(phone);
        order.setReceiver_address(address);
        order.setReceiver_email(email);
        order.setReceiver_note(note);

        order.setPayment_method(paymentMethod != null && !paymentMethod.trim().isEmpty()
                ? paymentMethod.trim().toUpperCase() : "COD");

        order.setPayment_status("UNPAID");
        long now = System.currentTimeMillis();

        GHNService ghn = new GHNService();

        int weight = 1000;

        int fromDistrict = 1454;
        int toDistrict = 1452;

        // ===== GHN fee =====
        int shippingFee = ghn.calculateFee(fromDistrict, toDistrict, weight);

        order.setShippingFee(shippingFee);
        session.setAttribute("shippingFee", shippingFee);

        // ===== delivery time =====
        DeliveryTimeService dts = new DeliveryTimeService();
        int days = dts.estimateDays(fromDistrict, toDistrict);

        order.setExpectedDeliveryFrom(
                new Timestamp(now + (days - 1) * 24L * 60 * 60 * 1000));

        order.setExpectedDeliveryTo(
                new Timestamp(now + days * 24L * 60 * 60 * 1000));

        session.setAttribute("pendingOrder", order);
        session.setAttribute("pendingOrderItems", cartItems);

        request.setAttribute("confirmed", false);
        request.setAttribute("order", order);
        request.setAttribute("orderItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("finalAmount", finalAmount);
        request.setAttribute("selectedVoucher", selectedVoucher);
        request.setAttribute("shippingFee", fee);

        request.getRequestDispatcher("/Assets/component/cart_payment/Order.jsp").forward(request, response);
    }
}