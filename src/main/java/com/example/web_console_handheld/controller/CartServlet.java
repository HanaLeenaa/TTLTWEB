package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.model.CartItem;
import com.example.web_console_handheld.model.User;
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
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDao cartDao = new CartDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("auth");

        // Nếu chưa login thì redirect về trang login
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

       // 1. Lấy giỏ hàng từ DB theo userId (Giữ logic database của bạn)
        List<CartItem> cartItems = cartDao.getCartByUser(user.getId());

        System.out.println("--> [CartServlet] ID của User đăng nhập: " + user.getId());
        System.out.println("--> [CartServlet] Số lượng sản phẩm lấy lên từ DB: " + (cartItems != null ? cartItems.size() : 0));

        // 2. Khởi tạo công cụ check kho (Lấy từ develop)
        ProductDao productDao = new ProductDao();
        boolean hasStockError = false;

        // 3. Vòng lặp check kho realtime dựa trên danh sách Database của bạn (Đã đổi sang getID())
        if (cartItems != null) {
            for (CartItem item : cartItems) {
                
                // Sử dụng getID() chuẩn theo class Product của bạn
                Product latestProduct = productDao.getProductDetailByID(item.getProduct().getID());
                item.setError(null); // Reset lỗi cũ

                // Tình huống 1: Sản phẩm không tồn tại trong DB nữa
                if (latestProduct == null) {
                    item.setError("Sản phẩm không tồn tại");
                    hasStockError = true;
                }
                // Tình huống 2: Sản phẩm hết hàng
                else if (latestProduct.getStock() <= 0) {
                    item.setError("Sản phẩm đã hết hàng");
                    hasStockError = true;
                }
                // Tình huống 3: Số lượng mua vượt quá số lượng tồn kho thực tế
                else if (item.getQuantity() > latestProduct.getStock()) {
                    item.setError("Chỉ còn " + latestProduct.getStock() + " sản phẩm trong kho");
                    hasStockError = true;
                }
            }
        }

        // 4. Đẩy toàn bộ dữ liệu sạch sang trang JSP để hiển thị giao diện
        req.setAttribute("hasStockError", hasStockError);
        req.setAttribute("cart", cartItems); // Đưa danh sách từ DB sang thay vì biến 'cart' rác cũ

        // Forward duy nhất 1 lần ở cuối hàm
        req.getRequestDispatcher("/Assets/component/cart_payment/cart.jsp").forward(req, resp);
    }
}
