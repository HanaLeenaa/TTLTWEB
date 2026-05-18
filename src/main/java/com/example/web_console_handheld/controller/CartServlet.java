package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.model.Cart;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.example.web_console_handheld.dao.ProductDao;

import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
        }

        ProductDao productDao = new ProductDao();
        boolean hasStockError = false;

        // check stock realtime
        for (CartItem item : cart.getCartItems().values()) {

            Product latestProduct = productDao.getProductDetailByID(item.getProduct().getID());
            item.setError(null);

            // sản phẩm không tồn tại
            if (latestProduct == null) {
                item.setError("Sản phẩm không tồn tại");
                hasStockError = true;
            }

            // hết hàng
            else if (latestProduct.getStock() <= 0) {
                item.setError("Sản phẩm đã hết hàng");
                hasStockError = true;
            }

            // vượt tồn kho
            else if (item.getQuantity() > latestProduct.getStock()) {
                item.setError("Chỉ còn " + latestProduct.getStock() + " sản phẩm trong kho");
                hasStockError = true;
            }
        }

        req.setAttribute("hasStockError", hasStockError);
        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/Assets/component/cart_payment/cart.jsp").forward(req,resp);
    }
}
