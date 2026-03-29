package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/RemoveWishlist")
public class RemoveWishlistServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        // Kiểm tra đăng nhập
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

        if (wishlist != null) {
            wishlist.removeIf(p -> p.getID() == productId);
            session.setAttribute("wishlist", wishlist);
        }

        out.print("{\"message\":\"Đã xóa khỏi yêu thích\",\"total\":" + (wishlist != null ? wishlist.size() : 0) + "}");
        out.flush();
    }
}
