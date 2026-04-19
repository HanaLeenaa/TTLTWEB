package com.example.web_console_handheld.controller;

import jakarta.servlet.ServletException;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.dao.WishlistDao;
import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddWishlist")
public class AddWishlistServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();
    private WishlistDao wishlistDao = new WishlistDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("auth") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"message\":\"Bạn cần đăng nhập để thêm wishlist\"}");
            return;
        }

        String idParam = request.getParameter("productId");
        if (idParam == null || idParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"message\":\"Thiếu productId\"}");
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

        // Lấy wishlist từ session để cập nhật giao diện ngay
        List<Product> wishlist = (List<Product>) session.getAttribute("wishlist");
        if (wishlist == null) wishlist = new ArrayList<>();
        // lấy danh sách wishlistIds từ session
        List<Integer> wishlistIds = (List<Integer>) session.getAttribute("wishlistIds");
        if (wishlistIds == null) wishlistIds = new ArrayList<>();

        boolean existsInSession = wishlist.stream().anyMatch(p -> p.getID() == productId);
        boolean existsInDB = wishlistDao.exists(user.getId(), productId);

        try {
            if (existsInSession || existsInDB) {
                // Xóa khỏi DB và session
                wishlistDao.removeWishlist(user.getId(), productId);
                wishlist.removeIf(p -> p.getID() == productId);
                session.setAttribute("wishlist", wishlist);

                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(
                        "{\"removed\":true,\"message\":\"Đã xóa khỏi yêu thích\",\"total\":" + wishlist.size() + "}"
                );
            } else if (product != null) {
                // Thêm vào DB và session
                wishlistDao.addWishlist(user.getId(), productId);
                wishlist.add(product);
                session.setAttribute("wishlist", wishlist);

                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(
                        "{\"added\":true,\"message\":\"Đã thêm vào yêu thích\",\"total\":" + wishlist.size() + "}"
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"message\":\"Có lỗi xảy ra khi cập nhật wishlist\"}");
        }
    }
}
