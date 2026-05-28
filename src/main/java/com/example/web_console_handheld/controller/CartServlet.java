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

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDao cartDao = new CartDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("auth");

        // Nếu chưa login thì redirect về trang login
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // Lấy giỏ hàng từ DB theo userId
        List<CartItem> cartItems = cartDao.getCartByUser(user.getId());

        System.out.println("--> [CartServlet] ID của User đăng nhập: " + user.getId());
        System.out.println("--> [CartServlet] Số lượng sản phẩm lấy lên từ DB: " + (cartItems != null ? cartItems.size() : 0));

        // Gắn vào request để JSP hiển thị
        req.setAttribute("cart", cartItems);

        // Forward sang trang giỏ hàng
        req.getRequestDispatcher("/Assets/component/cart_payment/cart.jsp").forward(req, resp);
    }
}
