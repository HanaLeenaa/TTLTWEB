package com.example.web_console_handheld.controller;

import jakarta.servlet.ServletException;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddWishlist")
public class AddWishlistServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        Object user = (session != null) ? session.getAttribute("auth") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"message\":\"Bạn cần đăng nhập để thêm wishlist\"}");
            return;
        }

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

        boolean exists = wishlist.stream().anyMatch(p -> p.getID() == productId);

        if (exists) {
            // Nếu đã có thì xóa (toggle off)
            wishlist.removeIf(p -> p.getID() == productId);
            session.setAttribute("wishlist", wishlist);

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(
                    "{\"removed\":true,\"message\":\"Đã xóa khỏi yêu thích\",\"total\":" + wishlist.size() + "}"
            );
        } else if (product != null) {
            // Nếu chưa có thì thêm (toggle on)
            wishlist.add(product);
            session.setAttribute("wishlist", wishlist);

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(
                    "{\"added\":true,\"message\":\"Đã thêm vào yêu thích\",\"total\":" + wishlist.size() + "}"
            );
        }
    }
}
