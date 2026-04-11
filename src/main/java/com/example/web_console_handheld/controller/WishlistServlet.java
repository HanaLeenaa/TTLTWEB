package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.BrandDao;
import com.example.web_console_handheld.dao.CategoryDao;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {
    private BrandDao brandDao = new BrandDao();
    private CategoryDao categoryDao = new CategoryDao();
    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object user = (session != null) ? session.getAttribute("auth") : null;
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Product> wishlist = (List<Product>) session.getAttribute("wishlist");
        if (wishlist == null) wishlist = new ArrayList<>();

        List<Integer> wishlistIds = wishlist.stream()
                .map(Product::getID)
                .toList();

        // ====== Đọc param từ form ======
        List<Integer> categoryIds = Optional.ofNullable(request.getParameterValues("categoryId"))
                .map(arr -> Arrays.stream(arr)
                        .filter(s -> s != null && !s.isEmpty())
                        .map(Integer::parseInt)
                        .toList())
                .orElse(List.of());

        String priceRange = request.getParameter("priceRange");
        String sort = request.getParameter("sort");

        List<Integer> brandIds = Optional.ofNullable(request.getParameterValues("brandId"))
                .map(arr -> Arrays.stream(arr)
                        .filter(s -> s != null && !s.isEmpty())
                        .map(Integer::parseInt)
                        .toList())
                .orElse(List.of());

        List<Integer> useTimes = Optional.ofNullable(request.getParameterValues("useTime"))
                .map(arr -> Arrays.stream(arr)
                        .filter(s -> s != null && !s.isEmpty())
                        .map(Integer::parseInt)
                        .toList())
                .orElse(List.of());

        // ====== Gọi DAO duy nhất để lọc wishlist và gợi ý ======
        List<Product> suggestions = productDao.filterWishlist(
                wishlistIds,
                categoryIds,
                priceRange,
                brandIds,
                useTimes,
                sort
        );

        // ====== Set attribute cho JSP ======
        request.setAttribute("wishlist", suggestions);
        request.setAttribute("suggestions", suggestions);
        request.setAttribute("categories", categoryDao.getCategory());
        request.setAttribute("brands", brandDao.getBrands());

        request.setAttribute("selectedCategoryIds", categoryIds);
        request.setAttribute("selectedBrandIds", brandIds);
        request.setAttribute("selectedPriceRange", priceRange);
        request.setAttribute("selectedSort", sort);
        request.setAttribute("selectedUseTimes", useTimes);

        request.getRequestDispatcher("/Assets/component/login_logout/wishlist.jsp").forward(request, response);
    }
}
