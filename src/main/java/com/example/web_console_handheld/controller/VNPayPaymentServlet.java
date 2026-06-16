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

    @Override
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

        // 🌟 BẮT ĐẦU TRÍCH XUẤT ĐƯỜNG DẪN GỐC CỦA HỆ THỐNG (ĐỘNG)
        String scheme = request.getScheme();             // Trả về "http" hoặc "https"
        String serverName = request.getServerName();     // Trả về "localhost" hoặc "domain-cua-ban.com"
        int serverPort = request.getServerPort();       // Trả về 8080, 80 hoặc 443
        String contextPath = request.getContextPath();   // Trả về tên project của bạn (ví dụ: /web_console_handheld)

        // Thực hiện dựng cấu trúc URL cơ sở
        StringBuilder baseUrl = new StringBuilder();
        baseUrl.append(scheme).append("://").append(serverName);

        // Nếu là localhost hoặc cổng custom (không phải cổng web chuẩn 80/443) thì gộp thêm số Port
        if (("http".equals(scheme) && serverPort != 80) || ("https".equals(scheme) && serverPort != 443)) {
            baseUrl.append(":").append(serverPort);
        }

        // Chỉ định đường dẫn tới URL Return tiếp nhận kết quả của VNPay
        baseUrl.append(contextPath).append("/vnpay-return");
        String dynamicReturnUrl = baseUrl.toString();

        // In kiểm tra log hệ thống để kiểm soát đường dẫn chính xác
        System.out.println(">>> VNPay Dynamic Return URL: " + dynamicReturnUrl);

        // Gửi tham số dynamicReturnUrl vào hàm tạo liên kết thanh toán của VNPayUtil
        String paymentUrl = VNPayUtil.createPaymentUrl(amount, txnRef, ipAddr, dynamicReturnUrl);

        response.sendRedirect(paymentUrl);
    }
}