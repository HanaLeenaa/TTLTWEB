package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/cartAction")
public class CartActionServlet extends HttpServlet {
    private CartDao cartDao = new CartDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đảm bảo không bị lỗi font tiếng Việt khi nhận tên sản phẩm
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String prodIdParam = request.getParameter("productId");
        String qtyParam = request.getParameter("quantity");
        String productName = request.getParameter("productName");

        int productId = (prodIdParam != null && !prodIdParam.trim().isEmpty()) ? Integer.parseInt(prodIdParam.trim()) : 0;
        int quantity = (qtyParam != null && !qtyParam.trim().isEmpty()) ? Integer.parseInt(qtyParam.trim()) : 0;

        try {
            switch (action) {
                case "add" -> {
                    if (quantity > 0) {
                        cartDao.addToCart(user.getId(), productId, productName, quantity);
                    }
                }
                case "update" -> {
                    // 🌟 PHÒNG THỦ LỖI ÂM SỐ LƯỢNG:
                    // Nếu số lượng truyền lên giảm xuống dưới 1, tự động xóa sản phẩm khỏi giỏ hàng
                    if (quantity < 1) {
                        cartDao.removeItem(user.getId(), productId);
                    } else {
                        // Ngược lại, nếu số lượng hợp lệ (>= 1) thì tiến hành cập nhật bình thường
                        cartDao.updateQuantity(user.getId(), productId, productName, quantity);
                    }
                }
                case "remove" -> cartDao.removeItem(user.getId(), productId);
                case "clear" -> cartDao.clearCart(user.getId());
            }

            // Đồng bộ tính toán lại số lượng giỏ hàng hiển thị trên Header Badge
            List<CartItem> updatedCart = cartDao.getCartByUser(user.getId());
            int newCartSize = 0;
            if (updatedCart != null) {
                for (CartItem item : updatedCart) {
                    newCartSize += item.getQuantity();
                }
            }
            session.setAttribute("cartSize", newCartSize);

        } catch (Exception e) {
            System.err.println("❌ Lỗi xử lý Database trong CartAction: " + e.getMessage());
            e.printStackTrace();
        }

        // Redirect sạch sẽ về lại trang giỏ hàng để cập nhật giao diện mới nhất
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}