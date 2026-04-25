package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.model.Product; // Bạn nhớ import class Product vào nhé
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/RemoveWishlist")
public class RemoveWishlistServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter(); // Khai báo biến out để dùng bên dưới
        HttpSession session = request.getSession();

        Object user = session.getAttribute("auth");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            String json = "{ \"notLoggedIn\": true, \"redirect\": \"" + request.getContextPath() + "/login\", \"message\":\"Bạn cần đăng nhập để xoá wishlist\" }";
            out.write(json);
            out.flush();
            return;
        }

        String idParam = request.getParameter("productId");
        if (idParam == null || idParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"message\":\"Thiếu productId\"}");
            out.flush();
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);
            List<Product> wishlist = (List<Product>) session.getAttribute("wishlist");
            if (wishlist == null) wishlist = new ArrayList<>();

            boolean removed = wishlist.removeIf(p -> p.getID() == productId);
            session.setAttribute("wishlist", wishlist);

            out.print(
                    "{\"removed\":" + removed +
                            ",\"message\":\"" + (removed ? "Đã xóa khỏi yêu thích" : "Sản phẩm không có trong wishlist") + "\"" +
                            ",\"total\":" + wishlist.size() + "}"
            );
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"message\":\"ID sản phẩm không hợp lệ\"}");
        }
        out.flush();
    }
}
