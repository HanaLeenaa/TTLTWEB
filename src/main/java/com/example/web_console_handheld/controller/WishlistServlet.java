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

        HttpSession session = request.getSession();
        List<Integer> wishlistIds = (List<Integer>) session.getAttribute("wishlistIds");
        if (wishlistIds == null) wishlistIds = new ArrayList<>();

        List<Product> filtered;
        if (wishlistIds.isEmpty()) {
            filtered = new ArrayList<>(); // chưa có sản phẩm yêu thích
        } else {
            // đọc filter param
            List<Integer> categoryIds = null;
            String[] catArr = request.getParameterValues("categoryId");
            if (catArr != null) {
                categoryIds = Arrays.stream(catArr)
                        .filter(s -> s != null && !s.isEmpty())
                        .map(Integer::parseInt)
                        .toList();
            }

            String priceRange = request.getParameter("priceRange");
            String sort = request.getParameter("sort");

            List<Integer> brandIds = Optional.ofNullable(request.getParameterValues("brandId"))
                    .map(arr -> Arrays.stream(arr)
                            .filter(s -> s != null && !s.isEmpty())
                            .map(Integer::parseInt)
                            .toList())
                    .orElse(List.of());

            filtered = productDao.filterWishlist(
                    wishlistIds, categoryIds, priceRange, brandIds, null, sort
            );

            // giữ trạng thái filter
            request.setAttribute("selectedCategoryIds", categoryIds);
            request.setAttribute("selectedBrandIds", brandIds);
            request.setAttribute("selectedPriceRange", priceRange);
            request.setAttribute("selectedSort", sort);
        }

        // set attribute cho JSP
        request.setAttribute("wishlist", filtered);
        request.setAttribute("categories", categoryDao.getCategory());
        request.setAttribute("brands", brandDao.getBrands());

        request.getRequestDispatcher("/Assets/component/login_logout/wishlist.jsp").forward(request, response);
    }
}
