package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.model.Cart;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;
import com.example.web_console_handheld.utils.VNPayConfig;
import com.example.web_console_handheld.utils.VNPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/vnpay-return")
public class VNPayReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {

            Order order =
                    (Order) session.getAttribute("pendingOrder");

            List<OrderItem> items =
                    (List<OrderItem>) session.getAttribute("pendingOrderItems");

            if (order == null || items == null) {
                response.sendRedirect(
                        request.getContextPath() + "/cart"
                );
                return;
            }
            Map<String, String> fields = new HashMap<>();
            Enumeration<String> parameterNames = request.getParameterNames();

            while (parameterNames.hasMoreElements()) {
                String fieldName = parameterNames.nextElement();
                String fieldValue = request.getParameter(fieldName);

                if (fieldValue != null && !fieldValue.isEmpty()) {
                    fields.put(fieldName, fieldValue);
                }
            }
            String vnpSecureHash = fields.remove("vnp_SecureHash");
            fields.remove("vnp_SecureHashType");
            String signValue = VNPayUtil.hashAllFields(fields, VNPayConfig.secretKey);

            if (vnpSecureHash == null || !signValue.equalsIgnoreCase(vnpSecureHash)) {
                response.sendRedirect(request.getContextPath() + "/payment?error=invalid-sign");
                return;
            }

            String responseCode = request.getParameter("vnp_ResponseCode");

            if (!"00".equals(responseCode)) {
                response.sendRedirect(request.getContextPath() + "/payment?error=vnpay");
                return;
            }
            //CHECK AMOUNT

            long vnpAmount =
                    Long.parseLong(
                            request.getParameter("vnp_Amount")
                    ) / 100;

            if (vnpAmount != order.getPrice()) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/payment?error=amount"
                );
                return;
            }
            //Payment success
            order.setPayment_status("PAID");
            order.setTransaction_no(request.getParameter("vnp_TransactionNo"));


                OrderDao dao = new OrderDao();
                boolean success = dao.createOrderTransaction(order, items);
                if (!success) {
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
                Cart cart = (Cart) session.getAttribute("cart");
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

                request.getRequestDispatcher("/Assets/component/cart_payment/Order.jsp").forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }


