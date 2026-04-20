package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.dao.WishlistDao;
import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/wishlist/toggle")
public class WishlistToggleServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();
    private WishlistDao wishlistDao = new WishlistDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("auth") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"message\":\"Bạn cần đăng nhập để thao tác wishlist\"}");
            return;
        }

        String idParam = request.getParameter("productId");
        if (idParam == null || idParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\":\"Thiếu productId\"}");
            return;
        }

        int productId = Integer.parseInt(idParam);
        Product product = productDao.getProductDetailByID(productId);

        List<Product> wishlist = (List<Product>) session.getAttribute("wishlist");
        if (wishlist == null) wishlist = new ArrayList<>();

        boolean existsInSession = wishlist.stream().anyMatch(p -> p.getID() == productId);
        boolean existsInDB = wishlistDao.exists(user.getId(), productId);

        try {
            if (existsInSession || existsInDB) {
                // Xóa khỏi DB và session
                wishlistDao.removeWishlist(user.getId(), productId);
                wishlist.removeIf(p -> p.getID() == productId);
                session.setAttribute("wishlist", wishlist);

                response.getWriter().write(
                        "{\"removed\":true,\"message\":\"Đã xóa khỏi yêu thích\",\"total\":" + wishlist.size() + "}"
                );
            } else if (product != null) {
                // Thêm vào DB và session
                wishlistDao.addWishlist(user.getId(), productId);
                wishlist.add(product);
                session.setAttribute("wishlist", wishlist);

                response.getWriter().write(
                        "{\"added\":true,\"message\":\"Đã thêm vào yêu thích\",\"total\":" + wishlist.size() + "}"
                );
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"message\":\"Không tìm thấy sản phẩm\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"message\":\"Có lỗi xảy ra khi cập nhật wishlist\"}");
        }
    }
}
