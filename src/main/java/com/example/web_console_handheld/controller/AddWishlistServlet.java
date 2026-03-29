package com.example.web_console_handheld.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddWishlist")
public class AddWishlistServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        Object user = session.getAttribute("auth");
        if (user == null) {
            // chưa login
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String json = "{ \"notLoggedIn\": true, \"redirect\": \"" + request.getContextPath() + "/login\" }";
            response.getWriter().write(json);
            return;
        }

        // lấy productId từ request
        int productId = Integer.parseInt(request.getParameter("productId"));

        // lấy danh sách wishlistIds từ session
        List<Integer> wishlistIds = (List<Integer>) session.getAttribute("wishlistIds");
        if (wishlistIds == null) wishlistIds = new ArrayList<>();

        // thêm sản phẩm vào danh sách nếu chưa có
        if (!wishlistIds.contains(productId)) {
            wishlistIds.add(productId);
        }
        session.setAttribute("wishlistIds", wishlistIds);

        // trả về JSON cho JS
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String json = "{ \"added\": true, \"message\": \"Đã thêm vào yêu thích\", \"total\": " + wishlistIds.size() + " }";
        response.getWriter().write(json);
    }
}
