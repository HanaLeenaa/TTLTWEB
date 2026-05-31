package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.OrderDao;
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
            // Thực hiện ghi dữ liệu xuống database và trừ kho trong Transaction ngầm
            int orderId = orderDao.createOrderTransactionWithLog(order, cartItems);

            if (orderId > 0) {
                // Xử lý dọn dẹp biến chế độ mua ngay
                if (Boolean.TRUE.equals(buyNowMode)) {
                    session.removeAttribute("buyNowMode");
                    session.removeAttribute("pendingOrderItems");
                }

                // Xóa các món đã mua thành công ra khỏi giỏ hàng database
                if (!Boolean.TRUE.equals(buyNowMode)) {
                    for (OrderItem item : cartItems) {
                        cartDao.removeItem(user.getId(), item.getProduct_id());
                    }
                }

                // Cập nhật lại số lượng badge giỏ hàng trên Header công khai
                List<CartItem> remainingCart = cartDao.getCartByUser(user.getId());
                int remainingQuantities = 0;
                if (remainingCart != null) {
                    for (CartItem cItem : remainingCart) {
                        remainingQuantities += cItem.getQuantity();
                    }
                }
                session.setAttribute("cartSize", remainingQuantities);

                // HIỂN THỊ TRANG THÀNH CÔNG CHÍNH THỨC (confirmed = true)
                request.setAttribute("confirmed", true);
                request.setAttribute("order", order);
                request.setAttribute("orderItems", cartItems);

                request.getRequestDispatcher("/Assets/component/cart_payment/Order.jsp").forward(request, response);
            } else {
                session.setAttribute("cartError", "Đặt hàng thất bại! Sản phẩm trong kho không đủ hoặc gặp sự cố.");
                response.sendRedirect(request.getContextPath() + "/cart");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("cartError", "Lỗi hệ thống lưu trữ: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}