package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.model.CartItem; // Nhớ import model CartItem của bạn vào
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

        request.setCharacterEncoding("UTF-8"); // Đảm bảo không bị lỗi font tiếng Việt khi nhận tên

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String prodIdParam = request.getParameter("productId");
        String qtyParam = request.getParameter("quantity");

        // CHÚ Ý: Hứng thêm tên sản phẩm từ form của cart.jsp gửi lên
        String productName = request.getParameter("productName");

        int productId = (prodIdParam != null && !prodIdParam.trim().isEmpty()) ? Integer.parseInt(prodIdParam.trim()) : 0;
        int quantity = (qtyParam != null && !qtyParam.trim().isEmpty()) ? Integer.parseInt(qtyParam.trim()) : 0;

        try {
            switch (action) {
                case "add" -> cartDao.addToCart(user.getId(), productId, productName, quantity);
                // SỬA DÒNG NÀY: Truyền thêm productName vào hàm update
                case "update" -> cartDao.updateQuantity(user.getId(), productId, productName, quantity);
                case "remove" -> cartDao.removeItem(user.getId(), productId);
                case "clear" -> cartDao.clearCart(user.getId());
            }

            // Đoạn logic đồng bộ số lượng lên Header cũ giữ nguyên...
            List<CartItem> updatedCart = cartDao.getCartByUser(user.getId());
            int newCartSize = 0;
            if (updatedCart != null) {
                for (CartItem item : updatedCart) {
                    newCartSize += item.getQuantity();
                }
            }
            session.setAttribute("cartSize", newCartSize);

        } catch (Exception e) {
            System.out.println("Lỗi xử lý Database trong CartAction: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}