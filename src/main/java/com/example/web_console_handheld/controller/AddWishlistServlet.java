package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddWishlist")
public class AddWishlistServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();

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
