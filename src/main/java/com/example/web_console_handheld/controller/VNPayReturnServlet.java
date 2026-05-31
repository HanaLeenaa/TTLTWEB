package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;
import com.example.web_console_handheld.model.User;
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

    private OrderDao orderDao = new OrderDao();
    private CartDao cartDao = new CartDao(); // Khai báo thêm CartDao để xóa giỏ hàng DB

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            User user = (User) session.getAttribute("auth");
            Order order = (Order) session.getAttribute("pendingOrder");
            List<OrderItem> items = (List<OrderItem>) session.getAttribute("pendingOrderItems");
            Boolean buyNowMode = (Boolean) session.getAttribute("buyNowMode");

            if (order == null || items == null || user == null) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Đọc các tham số bảo mật trả về từ VNPay
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

            // Kiểm tra chữ ký bảo mật chữ chéo dữ liệu đầu cuối
            if (vnpSecureHash == null || !signValue.equalsIgnoreCase(vnpSecureHash)) {
                response.sendRedirect(request.getContextPath() + "/cart?error=invalid-sign");
                return;
            }

            String responseCode = request.getParameter("vnp_ResponseCode");

            // Nếu giao dịch thất bại (mã trả về khác "00")
            if (!"00".equals(responseCode)) {
                response.sendRedirect(request.getContextPath() + "/cart?error=vnpay-cancel");
                return;
            }

            // Kiểm tra số tiền thanh toán khớp cấu trúc dữ liệu đơn hàng
            long vnpAmount = Long.parseLong(request.getParameter("vnp_Amount")) / 100;

            if (vnpAmount != order.getPrice()) {
                response.sendRedirect(request.getContextPath() + "/cart?error=amount-mismatch");
                return;
            }

            // Gán thông tin thanh toán thành công hoàn chỉnh
            order.setPayment_method("VNPAY");
            order.setPayment_status("PAID");
            order.setTransaction_no(request.getParameter("vnp_TransactionNo"));

            // Thực thi ghi dữ liệu lưu đơn xuống DB & trừ kho
            int orderId = orderDao.createOrderTransactionWithLog(order, items);

            if (orderId <= 0) {
                response.sendRedirect(request.getContextPath() + "/cart?error=stock");
                return;
            }

            // DỌN DẸP GIỎ HÀNG SAU KHI THANH TOÁN THÀNH CÔNG
            if (Boolean.TRUE.equals(buyNowMode)) {
                session.removeAttribute("buyNowMode");
            } else {
                // Xóa chuẩn xác các mặt hàng đã mua khỏi Database
                for (OrderItem item : items) {
                    cartDao.removeItem(user.getId(), item.getProduct_id());
                }
            }

            // Tính toán lại số Badge giỏ hàng trên thanh header tiện ích
            List<CartItem> remainingCart = cartDao.getCartByUser(user.getId());
            int remainingQuantities = 0;
            if (remainingCart != null) {
                for (CartItem cItem : remainingCart) {
                    remainingQuantities += cItem.getQuantity();
                }
            }
            session.setAttribute("cartSize", remainingQuantities);

            // Giải phóng các biến tạm thời trong phiên làm việc
            session.removeAttribute("pendingOrder");
            session.removeAttribute("pendingOrderItems");

            // Trả ngược kết quả hoàn tất hiển thị ra trang xem hóa đơn thành công
            request.setAttribute("confirmed", true);
            request.setAttribute("order", order);
            request.setAttribute("orderItems", items);

            request.getRequestDispatcher("/Assets/component/cart_payment/Order.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cart?error=system");
        }
    }
}