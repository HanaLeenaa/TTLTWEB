package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private CartDao cartDao = new CartDao(); // Khai báo Dao để lấy dữ liệu chuẩn từ DB

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Kiểm tra đăng nhập bảo mật
        if (session == null || session.getAttribute("auth") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("auth");

        // 1. Lấy danh sách sản phẩm thực tế trong giỏ hàng từ DB của User này
        List<CartItem> dbCartItems = cartDao.getCartByUser(user.getId());
        if (dbCartItems == null || dbCartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // 2. Lấy danh sách ID các sản phẩm được tích chọn từ checkbox giao diện
        String[] selectedIds = request.getParameterValues("selectedItems");
        if (selectedIds == null || selectedIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        Set<Integer> selectedSet = Arrays.stream(selectedIds)
                .map(Integer::parseInt)
                .collect(Collectors.toSet());

        // 3. Lọc danh sách giỏ hàng, chỉ giữ lại những sản phẩm được chọn mua
        List<CartItem> selectedItems = dbCartItems.stream()
                .filter(item -> selectedSet.contains(item.getProduct().getID()))
                .collect(Collectors.toList());

        // 4. Chuyển đổi dữ liệu sang danh sách OrderItem để hiển thị bên trang thanh toán
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem ci : selectedItems) {
            OrderItem oi = new OrderItem();
            oi.setProduct_id(ci.getProduct().getID());
            oi.setProduct_name(ci.getProduct().getName());
            oi.setQuantity(ci.getQuantity());
            oi.setProduct_price(ci.getProduct().getPrice()); // SỬA LẠI: Dùng .getPrice() thuần của bạn
            oi.setProduct_image(ci.getProduct().getImage());

            orderItems.add(oi);
        }

        // Lưu dữ liệu vào request và session để trang payment.jsp xử lý tiếp
        session.setAttribute("selectedCartItems", selectedItems);
        request.setAttribute("orderItems", orderItems);

        // Tiến hành chuyển tiếp sang trang thanh toán
        request.getRequestDispatcher("/Assets/component/cart_payment/payment.jsp")
                .forward(request, response);
    }
}