package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.model.Cart;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/AddCart")
public class AddToCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Object user = session.getAttribute("auth");
        System.out.println("USER = " + user);

        if (user == null) {
            //Chua login
            session.setAttribute("loginMessage", "Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng");
            response.sendRedirect(request.getContextPath() +"/login");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));



        String name = request.getParameter("name");
        String image = request.getParameter("image");

        String priceStr = request.getParameter("price");
        priceStr = priceStr.replace(".", ""); // "3200000"

        long price = Long.parseLong(priceStr);

        Product p = new Product();
        p.setID(productId);
        p.setName(name);
        p.setPrice(price);
        p.setImage(image);


        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
        }

        cart.addProduct(p, quantity);

        session.setAttribute("cart", cart);

        session.setAttribute("addSuccess", true);
        response.sendRedirect(request.getHeader("Referer"));
    }
}

