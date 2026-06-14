package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.dao.VoucherDao;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.service.GHNService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/submit-order-database")
public class SubmitOrderDatabaseServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();
    private CartDao cartDao = new CartDao();
    private VoucherDao voucherDao = new VoucherDao();

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
            int fromDistrict = 1454;
            String fromWard = "21005";

            int toDistrict = 1452;
            String toWard = "21810";

            int fee = 0;
            int leadTime = 0;

            try {
                fee = ghnService.calculateFee(fromDistrict, toDistrict, 1000);
                leadTime = ghnService.calculateLeadTime(fromDistrict, fromWard, toDistrict, toWard);

            } catch (Exception ghnEx) {
                ghnEx.printStackTrace();
                fee = 0;
                leadTime = 0;
            }

            long now = System.currentTimeMillis();
            order.setShippingFee(fee);
            order.setExpectedDeliveryFrom(new java.sql.Timestamp(now + 2L * 24 * 60 * 60 * 1000));

            order.setExpectedDeliveryTo(new java.sql.Timestamp(now + (leadTime > 0
                            ? leadTime * 1000L : 4L * 24 * 60 * 60 * 1000)));

            int orderId = orderDao.createOrderTransactionWithLog(order, cartItems);

            if (orderId > 0) {
                //Voucher
                if (order.getVoucher_id() != null) {
                    voucherDao.decreaseQuantity(order.getVoucher_id());

                    voucherDao.insertUserVoucher(user.getId(), order.getVoucher_id());

                }
                session.removeAttribute("selectedVoucherId");
                session.removeAttribute("selectedItems");
                session.removeAttribute("pendingOrderItems");
                session.removeAttribute("pendingOrder");
                session.removeAttribute("checkoutTotal");

                // Xử lý dọn dẹp biến chế độ mua ngay
                if (Boolean.TRUE.equals(buyNowMode)) {
                    session.removeAttribute("buyNowMode");
                    session.removeAttribute("pendingOrderItems");
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