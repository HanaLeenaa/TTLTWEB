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

        int productId = Integer.parseInt(request.getParameter("productId"));

        HttpSession session = request.getSession();
        List<Product> wishlist = (List<Product>) session.getAttribute("wishlist");

        if (wishlist != null) {
            wishlist.removeIf(p -> p.getID() == productId);
            session.setAttribute("wishlist", wishlist);
        }

        out.print("{\"message\":\"Đã xóa khỏi yêu thích\",\"total\":" + (wishlist != null ? wishlist.size() : 0) + "}");
        out.flush();
    }
}

