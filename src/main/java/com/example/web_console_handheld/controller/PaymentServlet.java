package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.VoucherDao;
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
    private VoucherDao voucherDao = new VoucherDao();

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

        if (selectedIds != null) {
            session.setAttribute("selectedItems", selectedIds);
        } else {
            selectedIds = (String[]) session.getAttribute("selectedItems");
        }
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
        long totalAmount = 0;
        for (CartItem ci : selectedItems) {
            OrderItem oi = new OrderItem();
            oi.setProduct_id(ci.getProduct().getID());
            oi.setProduct_name(ci.getProduct().getName());
            oi.setQuantity(ci.getQuantity());
            oi.setProduct_price(ci.getProduct().getPrice()); // SỬA LẠI: Dùng .getPrice() thuần của bạn
            oi.setProduct_image(ci.getProduct().getImage());

            orderItems.add(oi);

            totalAmount += ci.getProduct().getPrice() * ci.getQuantity();
        }

        // Lưu dữ liệu vào request và session để trang payment.jsp xử lý tiếp
        session.setAttribute("selectedCartItems", selectedItems);
        request.setAttribute("orderItems", orderItems);

        // LẤY VOUCHER
        List<Voucher> vouchers = voucherDao.getAvailableVouchers(user.getId(), totalAmount);

        Voucher selectedVoucher = null;
        Object voucherObj = session.getAttribute("selectedVoucherId");

        if (voucherObj != null) {
            int voucherId = Integer.parseInt(voucherObj.toString());

            selectedVoucher = voucherDao.getVoucherById(voucherId);
        }

        long discountAmount = 0;

        if (selectedVoucher != null) {

            if ("PERCENT".equals(selectedVoucher.getDiscount_type())) {

                discountAmount = (long)(totalAmount * selectedVoucher.getDiscount_value().doubleValue() / 100);

                if (selectedVoucher.getMax_discount() != null) {
                    discountAmount = Math.min(
                            discountAmount,
                            selectedVoucher.getMax_discount().longValue()
                    );
                }

            } else {

                discountAmount =
                        selectedVoucher.getDiscount_value().longValue();
            }
        }

        long finalAmount = Math.max(0, totalAmount - discountAmount);

        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("finalAmount", finalAmount);

        request.setAttribute("vouchers", vouchers);
        request.setAttribute("selectedVoucher", selectedVoucher);
        request.setAttribute("totalAmount", totalAmount);

        session.setAttribute("checkoutTotal", totalAmount);

        // Tiến hành chuyển tiếp sang trang thanh toán
        request.getRequestDispatcher("/Assets/component/cart_payment/payment.jsp")
                .forward(request, response);
    }
}