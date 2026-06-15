package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.dao.VoucherDao;
import com.example.web_console_handheld.model.*;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.service.GHNService;
import com.example.web_console_handheld.service.DeliveryTimeService;

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
    private VoucherDao voucherDao = new VoucherDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 1. Khởi tạo toàn bộ các biến chứa dữ liệu dự phòng (Fallback) ra ngoài rìa để tránh lỗi Scope
        List<OrderItem> cartItems = new ArrayList<>();
        long totalAmount = 0;
        long discountAmount = 0;
        Voucher selectedVoucher = null;
        Order order = new Order();

        int shippingFee = 30000;
        int days = 3;
        long now = System.currentTimeMillis();

        try {
            System.out.println("===> BẮT ĐẦU XỬ LÝ ĐẶT HÀNG TRONG SERVLET...");

            User user = (User) session.getAttribute("auth");
            if (user == null) {
                System.out.println("===> LỖI: Chưa đăng nhập hệ thống.");
                session.setAttribute("cartError", "Vui lòng đăng nhập!");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Boolean buyNowMode = (Boolean) session.getAttribute("buyNowMode");

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
                    session.setAttribute("cartError", "Giỏ hàng trống!");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                String[] selectedItems = request.getParameterValues("selectedItems");
                List<String> selectedList = (selectedItems != null) ? Arrays.asList(selectedItems) : null;

                for (CartItem c : dbCart) {
                    if (c.getProduct() == null) continue;
                    String pid = String.valueOf(c.getProduct().getID());
                    if (selectedList == null || selectedList.contains(pid)) {
                        OrderItem item = new OrderItem();
                        item.setProduct_id(c.getProduct().getID());
                        item.setProduct_name(c.getProduct().getName());
                        item.setProduct_image(c.getProduct().getImage());
                        item.setProduct_price(c.getProduct().getPrice());
                        item.setQuantity(c.getQuantity());

                        cartItems.add(item);
                        totalAmount += c.getProduct().getPrice() * c.getQuantity();
                    }
                }

                if (cartItems.isEmpty()) {
                    session.setAttribute("cartError", "Không có sản phẩm hợp lệ!");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
            }

            String fullname = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String email = request.getParameter("email");
            String note = request.getParameter("note");
            String paymentMethod = request.getParameter("payment_method");

            User auth = (User) session.getAttribute("auth");
            if (auth != null) {
                if (fullname == null || fullname.isBlank()) fullname = auth.getUsername();
                if (phone == null || phone.isBlank()) phone = auth.getPhoneNum();
                if (email == null || email.isBlank()) email = auth.getEmail();
                if (address == null || address.isBlank()) address = auth.getLocation();
            }

            Integer voucherId = (Integer) session.getAttribute("selectedVoucherId");

            if (voucherId != null) {
                if (voucherDao.hasUsedVoucher(user.getId(), voucherId)) {
                    session.setAttribute("cartError", "Không thể sử dụng lại do bạn đã sử dụng voucher này trước đó!");
                    response.sendRedirect(request.getContextPath() + "/payment");
                    return;
                }

                selectedVoucher = voucherDao.getVoucherById(voucherId);
                // BẢO VỆ CHỐNG NULL VOUCHER: Đảm bảo kiểm tra thực thể voucher tránh sập
                if (selectedVoucher != null && selectedVoucher.getDiscount_value() != null) {
                    if ("PERCENT".equals(selectedVoucher.getDiscount_type())) {
                        discountAmount = (long) (totalAmount * selectedVoucher.getDiscount_value().doubleValue() / 100);
                    } else {
                        discountAmount = selectedVoucher.getDiscount_value().longValue();
                    }
                    if (selectedVoucher.getMax_discount() != null) {
                        discountAmount = Math.min(discountAmount, selectedVoucher.getMax_discount().longValue());
                    }
                }
            }

            // Đóng gói đối tượng Order
            order.setUser_Id(user.getId());
            order.setCreateAt(new Timestamp(System.currentTimeMillis()));
            order.setStatus("Chờ xác nhận");
            order.setVoucher_id(selectedVoucher != null ? selectedVoucher.getID() : null);
            order.setDiscount_amount(discountAmount);
            long finalAmount = Math.max(0, totalAmount - discountAmount);
            order.setFinal_amount(finalAmount);
            order.setPrice(totalAmount);
            order.setReceiver_name(fullname);
            order.setReceiver_phone(phone);
            order.setReceiver_address(address);
            order.setReceiver_email(email);
            order.setReceiver_note(note);
            order.setPayment_method(paymentMethod != null && !paymentMethod.trim().isEmpty() ? paymentMethod.trim().toUpperCase() : "COD");
            order.setPayment_status("UNPAID");

            // Gọi các dịch vụ API thứ 3
            try {
                System.out.println("===> ĐANG GỌI API GHN...");
                GHNService ghn = new GHNService();
                int weight = 1000;
                int fromDistrict = 1454;
                int toDistrict = 1452;

                shippingFee = ghn.calculateFee(fromDistrict, toDistrict, weight);

                DeliveryTimeService dts = new DeliveryTimeService();
                days = dts.estimateDays(fromDistrict, toDistrict);
                if (days <= 0) days = 3;
                System.out.println("===> KẾT QUẢ API VẬN CHUYỂN THÀNH CÔNG: Fee=" + shippingFee + ", Days=" + days);
            } catch (Exception apiEx) {
                System.out.println("===> CẢNH BÁO: API Vận chuyển bị lỗi, tự động chuyển sang dữ liệu dự phòng!");
                apiEx.printStackTrace();
            }

        } catch (Exception masterEx) {
            // KHỐI LỆNH TOÀN NĂNG: Nếu tầng Java dính bất kỳ lỗi logic nào, bắt tại đây và ghi nhận log ngay
            System.err.println("❌❌❌ PHÁT HIỆN LỖI LOGIC NGHIÊM TRỌNG TRONG ĐOẠN JAVA SERVLET:");
            masterEx.printStackTrace();
            System.err.println("-----------------------------------------------------------------");
        }

        // 2. PHẦN ĐẨY DỮ LIỆU ĐỒNG BỘ SANG FILE JSP (Luôn chạy bất kể code trên có lỗi hay không)
        long calculatedFinal = Math.max(0, totalAmount - discountAmount);
        order.setFinal_amount(calculatedFinal);
        order.setPrice(totalAmount);
        order.setShippingFee(shippingFee);

        order.setExpectedDeliveryFrom(new Timestamp(now + (days - 1) * 24L * 60 * 60 * 1000));
        order.setExpectedDeliveryTo(new Timestamp(now + days * 24L * 60 * 60 * 1000));

        session.setAttribute("pendingOrder", order);
        session.setAttribute("pendingOrderItems", cartItems);
        session.setAttribute("shippingFee", shippingFee);

        request.setAttribute("confirmed", false);
        request.setAttribute("order", order);
        request.setAttribute("orderItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("finalAmount", calculatedFinal);
        request.setAttribute("selectedVoucher", selectedVoucher);
        request.setAttribute("shippingFee", shippingFee);

        System.out.println("===> TIẾN HÀNH FORWARD SANG FILE ORDER.JSP...");
        request.getRequestDispatcher("/Assets/component/cart_payment/Order.jsp").forward(request, response);
    }
}