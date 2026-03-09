package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.model.Cart;
import com.example.web_console_handheld.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cartAction")

public class CartActionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            response.sendRedirect("cart");
            return;
        }

        String action = request.getParameter("action");

        if (action.startsWith("increase_")) {
            int id = Integer.parseInt(action.split("_")[1]);
            CartItem item = cart.getCartItems().get(id);
            if (item != null) {
                item.increaseQuantity(1);
            }
        }
        else if (action.startsWith("decrease_")) {
            int id = Integer.parseInt(action.split("_")[1]);
            CartItem item = cart.getCartItems().get(id);
            if (item != null && item.getQuantity() > 1) {
                item.setQuantity(item.getQuantity() - 1);
            }
        }
        else if (action.startsWith("remove_")) {
            int id = Integer.parseInt(action.split("_")[1]);
            cart.deleteProduct(id);
        }
        else if ("clear".equals(action)) {
            cart.clear();
        }

        session.setAttribute("cart", cart);
        response.sendRedirect("cart");

    }
}
