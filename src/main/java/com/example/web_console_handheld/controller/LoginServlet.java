package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.dao.WishlistDao;
import com.example.web_console_handheld.model.Product;
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

        AuthService as = new AuthService();
        User user = as.checkLogin(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("auth", user);

            List<Integer> productIds = wishlistDao.getWishlistByUser(user.getId());
            List<Product> wishlistProducts = new ArrayList<>();
            for (int pid : productIds) {
                Product p = productDao.getProductDetailByID(pid);
                if (p != null) wishlistProducts.add(p);
            }
            session.setAttribute("wishlist", wishlistProducts);

            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Bạn nhập sai tên hoặc mật khẩu");
            request.getRequestDispatcher("/Assets/component/login_logout/login.jsp")
                    .forward(request, response);
        }
    }


}