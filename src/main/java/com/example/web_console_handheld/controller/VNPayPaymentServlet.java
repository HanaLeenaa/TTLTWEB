package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.utils.VNPayUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/vnpay-payment")
public class VNPayPaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Order order = (Order) session.getAttribute("pendingOrder");
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        long amount = order.getFinal_amount() * 100L;
        String txnRef = String.valueOf(System.currentTimeMillis());
        String ipAddr = request.getRemoteAddr();
        String paymentUrl = VNPayUtil.createPaymentUrl(amount, txnRef, ipAddr);

        response.sendRedirect(paymentUrl);
    }
}
