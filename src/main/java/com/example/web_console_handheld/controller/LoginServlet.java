package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.dao.WishlistDao;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.dao.AuthDao;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/Assets/component/login_logout/login.jsp").forward(request,response);
    }
        private WishlistDao wishlistDao = new WishlistDao();
        private ProductDao productDao = new ProductDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AuthDao authDao = new AuthDao();
        User rawUser = authDao.getUserByUserName(username);

        if (rawUser != null){
            if (rawUser.isDeleted()) {
                request.setAttribute("error", "Tài khoản của bạn đã bị xóa khỏi hệ thống. Vui lòng liên hệ quản trị viên!");
                request.getRequestDispatcher("/Assets/component/login_logout/login.jsp").forward(request, response);
                return;
            }

            if (!rawUser.isActive()) {
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa.");
                request.getRequestDispatcher("/Assets/component/login_logout/login.jsp").forward(request, response);
                return;
                }
            }

        AuthService as = new AuthService();
        User user = as.checkLogin(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("auth", user);

            // Đoạn xử lý Wishlist giữ nguyên của bạn...
            List<Integer> productIds = wishlistDao.getWishlistByUser(user.getId());
            List<Product> wishlistProducts = new ArrayList<>();
            for (int pid : productIds) {
                Product p = productDao.getProductDetailByID(pid);
                if (p != null) wishlistProducts.add(p);
            }
            session.setAttribute("wishlist", wishlistProducts);

            // === SỬA LẠI ĐOẠN NÀY ĐỂ TÍNH ĐÚNG TỔNG SỐ LƯỢNG ===
            CartDao cartDao = new CartDao();
            List<CartItem> dbCart = cartDao.getCartByUser(user.getId());

            int totalQuantities = 0;
            if (dbCart != null) {
                for (CartItem item : dbCart) {
                    totalQuantities += item.getQuantity(); // Cộng dồn số lượng thực tế của từng món
                }
            }
            // Đổi tên thành cartSize đồng bộ với Header mới
            session.setAttribute("cartSize", totalQuantities);

            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }else {
            request.setAttribute("error", "Bạn nhập sai tên hoặc mật khẩu");
            request.getRequestDispatcher("/Assets/component/login_logout/login.jsp")
                    .forward(request, response);
        }
    }


}
