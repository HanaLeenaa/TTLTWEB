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

    private OrderDao orderDao = new OrderDao();
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

        // ĐỒNG BỘ 4: Tiếp nhận danh sách ID sản phẩm được tích chọn mua thực tế
        String[] selectedItemIds = request.getParameterValues("selectedItems");
        List<String> selectedList = (selectedItemIds != null) ? Arrays.asList(selectedItemIds) : null;

        // 2. TRUY VẤN GIỎ HÀNG THỰC TẾ TỪ DATABASE THEO USER ID
        List<CartItem> dbCart = cartDao.getCartByUser(user.getId());
        if (dbCart == null || dbCart.isEmpty()) {
            session.setAttribute("cartError", "Giỏ hàng của bạn đang trống! Không thể đặt hàng.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // 3. BỘ LỌC THÔNG MINH: Chỉ chuyển đổi những mặt hàng được tích chọn sang hóa đơn
        List<OrderItem> cartItems = new ArrayList<>();
        long totalAmount = 0;

        for (CartItem cItem : dbCart) {
            if (cItem.getProduct() == null) {
                continue;
            }

            String currentProductId = String.valueOf(cItem.getProduct().getID());

            // Cơ chế: Nếu không truyền mảng chọn (Mặc định mua hết) HOẶC ID nằm trong danh sách chọn thì bốc vào đơn
            if (selectedList == null || selectedList.contains(currentProductId)) {
                OrderItem oItem = new OrderItem();
                oItem.setProduct_id(cItem.getProduct().getID());
                oItem.setQuantity(cItem.getQuantity());
                oItem.setProduct_price(cItem.getProduct().getPrice());
                oItem.setProduct_image(cItem.getProduct().getImage());

                cartItems.add(oItem);
                totalAmount += (cItem.getProduct().getPrice() * cItem.getQuantity());
            }
        }

        // Phòng hờ bộ lọc rỗng
        if (cartItems.isEmpty()) {
            session.setAttribute("cartError", "Không tìm thấy sản phẩm hợp lệ nào được chọn để thanh toán!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // 4. LẤY THÔNG TIN NGƯỜI NHẬN TỪ FORM GIAO DIỆN
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("payment_method");

        // 5. ĐÓNG GÓI ĐỐI TƯỢNG ORDER
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

        // 6. CHẠY TRANSACTION LƯU ĐƠN & TRỪ KHO TỰ ĐỘNG
        try {
            int orderId = orderDao.createOrderTransactionWithLog(order, cartItems);

            if (orderId > 0) {
                // 🚨 ĐIỂM SỬA CHỐT HẠ: Chỉ xóa các món nằm trong hóa đơn vừa thanh toán khỏi DB
                for (OrderItem item : cartItems) {
                    cartDao.removeItem(user.getId(), item.getProduct_id());
                }

                // Tính toán chính xác số lượng icon giỏ hàng Header dựa trên các món còn sót lại
                List<CartItem> remainingCart = cartDao.getCartByUser(user.getId());
                int remainingQuantities = 0;

                if (remainingCart != null) {
                    for (CartItem cItem : remainingCart) {
                        remainingQuantities += cItem.getQuantity();
                    }
                }

                // Cập nhật số lượng chuẩn lên thanh tiêu đề Header
                session.setAttribute("cartSize", remainingQuantities);

                // Chuyển hướng sang trang đặt hàng thành công hoàn chỉnh
                response.sendRedirect(request.getContextPath() + "/order-success?id=" + orderId);
            } else {
                session.setAttribute("cartError", "Đặt hàng thất bại! Hệ thống không thể khởi tạo hóa đơn.");
                response.sendRedirect(request.getContextPath() + "/cart");
            }

        } catch (Exception e) {
            e.printStackTrace();
            String dbError = (e.getCause() != null) ? e.getCause().getMessage() : e.getMessage();
            session.setAttribute("cartError", "LỖI HỆ THỐNG LIVE: " + dbError);
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}