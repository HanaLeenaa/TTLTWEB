package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Cart;
import com.example.web_console_handheld.model.CartItem;
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
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String json = "{ \"message\": \"Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng\" }";
            response.getWriter().write(json);
            return;
        }


        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));


        ProductDao productDao = new ProductDao();

        //lấy product từ DB
        Product product = productDao.getProductDetailByID(productId);

        //check product tồn tại
        if (product == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);


            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            response.getWriter().write("""
                    {
                    "message":"Sản phẩm không tồn tại!"
                    }
                    """);
            return;
        }
        //check hết hàng
        if (product.getStock() <= 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            response.getWriter().write("""
                    {
                    "message":"Sản phẩm đã hết hàng!"
                    }
                    """);
            return;
        }

        //lấy cart
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
        }

        //check số lượng trong giỏ
        CartItem existingItem = cart.getCartItems().get(productId);
        int currentQuantity = 0;

        if (existingItem != null) {
            currentQuantity = existingItem.getQuantity();
        }

        //check vượt tồn kho
        if (currentQuantity + quantity > product.getStock()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            String json = """
                    {
                    "message":"Số lượng vượt quá tồn kho!"
                    }
                    """;
            response.getWriter().write(json);
            return;

        }

        //add to cart
        cart.addProduct(product, quantity);
        session.setAttribute("cart", cart);

        //tính total item
        int total = 0;

        for (CartItem item : cart.getCartItems().values()) {
            total += item.getQuantity();
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String json = """
                    {
                        "message":"Thêm vào giỏ hàng thành công!",
                        "total": %d
                    }
                """.formatted(total);

        response.getWriter().write(json);
    }
}
