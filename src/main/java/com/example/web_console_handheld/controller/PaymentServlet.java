package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.VoucherDao;
import com.example.web_console_handheld.model.*;
import com.example.web_console_handheld.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

// Cho phép gộp luồng chạy thẳng về đây
@WebServlet(urlPatterns = {"/payment", "/buy-now"})
public class PaymentServlet extends HttpServlet {
    private CartDao cartDao = new CartDao();
    private VoucherDao voucherDao = new VoucherDao();
    private VoucherService voucherService = new VoucherService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("auth") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("auth");
        List<OrderItem> orderItems = new ArrayList<>();
        long totalAmount = 0;
        int totalQuantity = 0;

        // KIỂM TRA LUỒNG XỬ LÝ
        Boolean buyNowMode = (Boolean) session.getAttribute("buyNowMode");

        if (Boolean.TRUE.equals(buyNowMode)) {
            // LUỒNG MUA NGAY: Lấy thẳng từ session, bỏ qua hoàn toàn việc check giỏ hàng DB
            List<OrderItem> buyNowItems = (List<OrderItem>) session.getAttribute("pendingOrderItems");
            if (buyNowItems != null && !buyNowItems.isEmpty()) {
                for (OrderItem item : buyNowItems) {
                    orderItems.add(item);
                    totalAmount += item.getProduct_price() * item.getQuantity();
                    totalQuantity += item.getQuantity();
                }
            }
        } else {
            // LUỒNG GIỎ HÀNG THƯỜNG
            List<CartItem> dbCartItems = cartDao.getCartByUser(user.getId());
            String[] selectedIds = request.getParameterValues("selectedItems");

            if (selectedIds != null) {
                session.setAttribute("selectedItems", selectedIds);
            } else {
                selectedIds = (String[]) session.getAttribute("selectedItems");
            }

            if (dbCartItems != null && selectedIds != null && selectedIds.length > 0) {
                Set<Integer> selectedSet = Arrays.stream(selectedIds)
                        .map(Integer::parseInt)
                        .collect(Collectors.toSet());

                List<CartItem> selectedItems = dbCartItems.stream()
                        .filter(item -> selectedSet.contains(item.getProduct().getID()))
                        .collect(Collectors.toList());

                for (CartItem ci : selectedItems) {
                    OrderItem oi = new OrderItem();
                    oi.setProduct_id(ci.getProduct().getID());
                    oi.setProduct_name(ci.getProduct().getName());
                    oi.setQuantity(ci.getQuantity());
                    oi.setProduct_price(ci.getProduct().getPrice());
                    oi.setProduct_image(ci.getProduct().getImage());

                    orderItems.add(oi);
                    totalAmount += ci.getProduct().getPrice() * ci.getQuantity();
                    totalQuantity += ci.getQuantity();
                }
                session.setAttribute("selectedCartItems", selectedItems);
            }
        }

        // Nếu cả hai luồng đều không có sản phẩm, đá về giỏ hàng đề phòng lỗi
        if (orderItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // ĐẨY DỮ LIỆU SANG REQUEST
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("quantity", totalQuantity);

        // TÍNH TOÁN VOUCHER
        List<Voucher> vouchers = voucherDao.getAvailableVouchers(user.getId(), totalAmount);
        Voucher selectedVoucher = null;
        Object voucherObj = session.getAttribute("selectedVoucherId");

        if (voucherObj != null) {
            int voucherId = Integer.parseInt(voucherObj.toString());
            selectedVoucher = voucherDao.getVoucherById(voucherId);
        }

        long discountAmount = 0;
        if (selectedVoucher != null) {
            discountAmount = voucherService.calculateDiscount(selectedVoucher, totalAmount);
        }

        long finalAmount = Math.max(0, totalAmount - discountAmount);

        request.setAttribute("discountAmount", discountAmount);
        request.setAttribute("finalAmount", finalAmount);
        request.setAttribute("vouchers", vouchers);
        request.setAttribute("selectedVoucher", selectedVoucher);
        request.setAttribute("totalAmount", totalAmount);

        session.setAttribute("checkoutTotal", totalAmount);

        request.getRequestDispatcher("/Assets/component/cart_payment/payment.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String productIdParam = request.getParameter("id");
        String quantityParam = request.getParameter("quantity");

        // Nếu request có gửi kèm id sản phẩm -> Đây chắc chắn là luồng "MUA NGAY" từ chi tiết sản phẩm
        if (productIdParam != null && !productIdParam.trim().isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdParam);
                int quantity = (quantityParam != null) ? Integer.parseInt(quantityParam) : 1;

                // 1. Dùng ProductDao để lấy nhanh thông tin sản phẩm (Tên, Giá, Ảnh)
                // (Đảm bảo bạn đã import hoặc khai báo ProductDao productDao = new ProductDao() ở trên đầu class nhé)
                com.example.web_console_handheld.dao.ProductDao productDao = new com.example.web_console_handheld.dao.ProductDao();
                Product product = productDao.getProductDetailByID(productId);

                if (product != null) {
                    // 2. ÉP BẬT LUỒNG MUA NGAY (Bỏ qua giỏ hàng)
                    session.setAttribute("buyNowMode", true);

                    // 3. Đóng gói sản phẩm mua ngay thành đối tượng OrderItem đưa vào session
                    List<OrderItem> pendingOrderItems = new ArrayList<>();
                    OrderItem oi = new OrderItem();
                    oi.setProduct_id(product.getID());
                    oi.setProduct_name(product.getName());
                    oi.setQuantity(quantity);
                    oi.setProduct_price(product.getPrice());
                    oi.setProduct_image(product.getImage());
                    pendingOrderItems.add(oi);

                    session.setAttribute("pendingOrderItems", pendingOrderItems);
                    System.out.println("===> ĐÃ KÍCH HOẠT LUỒNG MUA NGAY CHO SẢN PHẨM ID: " + productId);
                }
            } catch (Exception e) {
                System.err.println("❌ LỖI XỬ LÝ DỮ LIỆU MUA NGAY TRONG SERVLET:");
                e.printStackTrace();
            }
        } else {
            // Nếu không có id gửi lên từ POST -> Đây là luồng "ĐẶT HÀNG" thông thường từ Giỏ Hàng submit sang
            // Chúng ta tắt cờ buyNowMode đi để hệ thống bốc dữ liệu từ database giỏ hàng
            session.setAttribute("buyNowMode", false);
            session.removeAttribute("pendingOrderItems");
            System.out.println("===> ĐÃ KÍCH HOẠT LUỒNG GIỎ HÀNG THƯỜNG");
        }

        // Sau khi đã thiết lập xong xuôi cờ ẩn trong Session, chạy tiếp hàm doGet để tính tiền và forward sang payment.jsp
        this.doGet(request, response);
    }
}