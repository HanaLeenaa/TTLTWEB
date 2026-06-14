package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    ProductDao productDAO = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword != null) {
            keyword = keyword.trim();
        }

        // 1. Cấu hình phân trang mặc định
        int page = 1;
        int limit = 10; // Giới hạn hiển thị đúng 10 sản phẩm mỗi trang để cứu trình duyệt không bị treo!

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * limit;

        // 2. Gọi 2 hàm mới từ DAO để lấy dữ liệu có giới hạn kiểm soát
        List<Product> list = productDAO.getProductsForAdmin(keyword, offset, limit);
        int totalProducts = productDAO.countProductsForAdmin(keyword);

        // Tính tổng số trang (Ví dụ: 25 sản phẩm / 10 = 3 trang)
        int totalPages = (int) Math.ceil((double) totalProducts / limit);

        // 3. Đẩy toàn bộ thuộc tính cần thiết sang cho trang JSP xử lý giao diện hiển thị
        request.setAttribute("products", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword != null ? keyword : "");

        request.setAttribute("contentPage", "/Assets/component/adminPage/productManagement.jsp");
        request.setAttribute("activePage", "products");
        request.getRequestDispatcher("/Assets/component/adminPage/admin.jsp").forward(request, response);
    }
}
