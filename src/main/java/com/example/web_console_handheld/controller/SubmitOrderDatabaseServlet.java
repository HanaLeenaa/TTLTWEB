package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.dao.VoucherDao;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;
import com.example.web_console_handheld.model.User;

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
            long now = System.currentTimeMillis();

            Integer fee = (Integer) session.getAttribute("shippingFee");
            Integer leadTime = (Integer) session.getAttribute("leadTime");

            if (leadTime == null || leadTime <= 0) {
                leadTime = 3;
            }

            int orderId = orderDao.createOrderTransactionWithLog(order, cartItems);

            if (orderId > 0) {
                // Xử lý Voucher nếu có áp dụng
                if (order.getVoucher_id() != null) {
                    voucherDao.decreaseQuantity(order.getVoucher_id());
                    voucherDao.insertUserVoucher(user.getId(), order.getVoucher_id());
                }

                // Dọn dẹp dữ liệu Session cũ
                session.removeAttribute("selectedVoucherId");
                session.removeAttribute("selectedItems");
                session.removeAttribute("checkoutTotal");
                session.removeAttribute("pendingOrder");
                session.removeAttribute("pendingOrderItems");

                // Phân loại: Nếu mua ngay thì xóa biến mua ngay, nếu mua từ Giỏ hàng thì xóa sản phẩm trong Giỏ hàng
                if (Boolean.TRUE.equals(buyNowMode)) {
                    session.removeAttribute("buyNowMode");
                } else {
                    for (OrderItem item : cartItems) {
                        cartDao.removeItem(user.getId(), item.getProduct_id());
                    }
                }

                // Cập nhật lại số lượng (cartSize) hiển thị trên Header
                List<CartItem> remainingCart = cartDao.getCartByUser(user.getId());
                int totalQty = 0;
                if (remainingCart != null) {
                    for (CartItem c : remainingCart) {
                        totalQty += c.getQuantity();
                    }
                }
                session.setAttribute("cartSize", totalQty);

                // Gửi dữ liệu sang trang hiển thị hóa đơn thành công
                request.setAttribute("confirmed", true);
                request.setAttribute("order", order);
                request.setAttribute("orderItems", cartItems);
                request.setAttribute("shippingFee", fee);

                request.getRequestDispatcher("/Assets/component/cart_payment/Order.jsp").forward(request, response);
            } else {
                // Trường hợp createOrderTransactionWithLog thất bại trả về <= 0
                session.setAttribute("cartError", "Không thể tạo đơn hàng. Vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/cart");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("cartError", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}