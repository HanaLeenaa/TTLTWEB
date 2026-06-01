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
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/confirm-order")
public class ConfirmOrderServlet extends HttpServlet {

    private CartDao cartDao = new CartDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 1. KIỂM TRA ĐĂNG NHẬP
        User user = (User) session.getAttribute("auth");
        if (user == null) {
            session.setAttribute("cartError", "Vui lòng đăng nhập để tiến hành đặt hàng!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Boolean buyNowMode = (Boolean) session.getAttribute("buyNowMode");

        // 3. BỘ LỌC MẶT HÀNG ĐƯỢC CHỌN
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
                session.setAttribute("cartError", "Giỏ hàng của bạn đang trống! Không thể đặt hàng.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            String[] selectedItemIds = request.getParameterValues("selectedItems");
            List<String> selectedList = (selectedItemIds != null) ? Arrays.asList(selectedItemIds) : null;

            for (CartItem cItem : dbCart) {
                if (cItem.getProduct() == null) continue;

                String currentProductId = String.valueOf(cItem.getProduct().getID());

                if (selectedList == null || selectedList.contains(currentProductId)) {
                    OrderItem oItem = new OrderItem();
                    oItem.setProduct_id(cItem.getProduct().getID());
                    oItem.setQuantity(cItem.getQuantity());
                    oItem.setProduct_price(cItem.getProduct().getPrice());
                    oItem.setProduct_image(cItem.getProduct().getImage());
                    oItem.setProduct_name(cItem.getProduct().getName()); // Lấy thêm tên để hiển thị ở trang Order.jsp

                    cartItems.add(oItem);
                    totalAmount += (cItem.getProduct().getPrice() * cItem.getQuantity());
                }
            }

            if (cartItems.isEmpty()) {
                session.setAttribute("cartError", "Không tìm thấy sản phẩm hợp lệ nào được chọn để thanh toán!");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }

        // 4. LẤY THÔNG TIN NGƯỜI NHẬN TỪ FORM GIAO DIỆN
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("payment_method");

        // 5. ĐÓNG GÓI ĐỐI TƯỢNG ORDER TẠM THỜI
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
        order.setPayment_method(paymentMethod != null && !paymentMethod.isEmpty() ? paymentMethod : "COD");
        order.setPayment_status("UNPAID"); // Mặc định hiển thị xem trước là chưa thanh toán

        // 6. CẤT TOÀN BỘ VÀO SESSION ĐỂ CÁC BƯỚC SAU SỬ DỤNG
        session.setAttribute("pendingOrder", order);
        session.setAttribute("pendingOrderItems", cartItems);

        // 7. CHUYỂN HƯỚNG SANG TRANG XEM TRƯỚC HÓA ĐƠN VỚI confirmed = false
        request.setAttribute("confirmed", false);
        request.setAttribute("order", order);
        request.setAttribute("orderItems", cartItems);

        request.getRequestDispatcher("/Assets/component/cart_payment/Order.jsp").forward(request, response);
    }
}