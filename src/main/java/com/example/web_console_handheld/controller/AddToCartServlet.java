package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Cart;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.model.User;
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

    private CartDao cartDao = new CartDao(); // Khai báo CartDao để dùng

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth"); // Ép kiểu về Class User chuẩn của bạn
        System.out.println("USER = " + user);

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String json = "{ \"message\": \"Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng\" }";
            response.getWriter().write(json);
            return;
        }

        // Lấy thông tin productId, số lượng và tên sản phẩm từ client gửi lên
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String name = request.getParameter("name"); // Nhận tên sản phẩm từ Client phát lên

        // --- ĐOẠN ĐẬP DỮ LIỆU XUỐNG DATABASE ---
        // CẬP NHẬT: Truyền thêm biến 'name' vào hàm để lưu trực tiếp tên sản phẩm vào bảng cart_items
        cartDao.addToCart(user.getId(), productId, name, quantity);

        // --- TÍNH TỔNG SỐ LƯỢNG ĐỂ HIỂN THỊ TRÊN ICON GIỎ HÀNG Ở HEADER ---
        // Lấy lại giỏ hàng thực tế từ DB sau khi đã thêm thành công
        List<CartItem> currentCart = cartDao.getCartByUser(user.getId());
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
        if (currentCart != null) {
            for (CartItem item : currentCart) {
                total += item.getQuantity(); // Cộng dồn tất cả số lượng của mọi sản phẩm lại
            }
        }

        // Trả về JSON cho Fetch API ở phía giao diện cập nhật huy hiệu (Badge) số lượng giỏ hàng
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        session.setAttribute("cartSize", total);

        String json = "{ \"message\": \"Thêm '" + name + "' vào giỏ thành công!\", \"total\": " + total + " }";
        response.getWriter().write(json);
    }
}
