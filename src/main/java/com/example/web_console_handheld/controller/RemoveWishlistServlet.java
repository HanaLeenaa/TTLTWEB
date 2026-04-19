package com.example.web_console_handheld.controller;

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

        HttpSession session = request.getSession(false);
        Object user = (session != null) ? session.getAttribute("auth") : null;
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"message\":\"Bạn cần đăng nhập để xoá wishlist\"}");
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
        out.flush();
    }
}
