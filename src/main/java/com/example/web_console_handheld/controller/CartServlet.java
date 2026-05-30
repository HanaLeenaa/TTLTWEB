package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.CartDao;
import com.example.web_console_handheld.dao.ProductDao;
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

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDao cartDao = new CartDao();
    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("auth");

        // 1. Nếu chưa đăng nhập thì chuyển hướng (redirect) về trang login.jsp
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // 2. Lấy danh sách sản phẩm trong giỏ hàng từ DB theo userId
        List<CartItem> cartItems = cartDao.getCartByUser(user.getId());

        // Log kiểm tra dữ liệu dưới Console của Tomcat
        System.out.println("--> [CartServlet] ID của User đăng nhập: " + user.getId());
        System.out.println("--> [CartServlet] Số lượng sản phẩm lấy lên từ DB: " + (cartItems != null ? cartItems.size() : 0));

        boolean hasStockError = false;

        // 3. Vòng lặp kiểm tra tồn kho realtime (Sử dụng getID() viết hoa của bạn)
        if (cartItems != null) {
            for (CartItem item : cartItems) {

                // Lấy thông tin mới nhất của sản phẩm từ bảng products
                Product latestProduct = productDao.getProductDetailByID(item.getProduct().getID());
                item.setError(null); // Reset lỗi cũ trước khi check lại

                // Tình huống 1: Sản phẩm đã bị xóa hoặc không tồn tại trong DB
                if (latestProduct == null) {
                    item.setError("Sản phẩm không tồn tại");
                    hasStockError = true;
                }
                // Tình huống 2: Sản phẩm trong kho đã hết sạch (stock <= 0)
                else if (latestProduct.getStock() <= 0) {
                    item.setError("Sản phẩm đã hết hàng");
                    hasStockError = true;
                }
                // Tình huống 3: Số lượng khách đặt mua vượt quá số lượng hàng thực tế trong kho
                else if (item.getQuantity() > latestProduct.getStock()) {
                    item.setError("Chỉ còn " + latestProduct.getStock() + " sản phẩm trong kho");
                    hasStockError = true;
                }
            }
        }

        // 4. Đẩy toàn bộ dữ liệu sạch sang trang JSP để hiển thị giao diện
        req.setAttribute("hasStockError", hasStockError);
        req.setAttribute("cart", cartItems);

        // Forward duy nhất 1 lần sang giao diện giỏ hàng để hiển thị dữ liệu
        req.getRequestDispatcher("/Assets/component/cart_payment/cart.jsp").forward(req, resp);
    }
}