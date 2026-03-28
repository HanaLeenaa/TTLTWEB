package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.BrandDao;
import com.example.web_console_handheld.dao.CategoryDao;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import java.util.stream.Stream;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {
    private BrandDao brandDao = new BrandDao();
    private CategoryDao categoryDao = new CategoryDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Product> wishlist = (List<Product>) session.getAttribute("wishlist");
        if (wishlist == null) wishlist = new ArrayList<>();

        // ====== Đọc param từ form ======
        String catParam = request.getParameter("categoryId");
        Integer categoryId = (catParam != null && !catParam.isEmpty()) ? Integer.parseInt(catParam) : null;

        String priceRange = request.getParameter("priceRange");
        String sort = request.getParameter("sort");

        // brandIds luôn là list, không null
        List<Integer> brandIds = Optional.ofNullable(request.getParameterValues("brandId"))
                .map(arr -> Arrays.stream(arr)
                        .filter(s -> s != null && !s.isEmpty())
                        .map(Integer::parseInt)
                        .toList())
                .orElse(List.of());

        // ====== Lọc bằng stream chain ======
        Stream<Product> stream = wishlist.stream();

        if (categoryId != null) {
            stream = stream.filter(p -> p.getCategories_id() == categoryId);
        }

        if (priceRange != null) {
            switch (priceRange) {
                case "under500" -> stream = stream.filter(p -> p.getPriceValue() < 500000);
                case "500-1m" -> stream = stream.filter(p -> p.getPriceValue() >= 500000 && p.getPriceValue() <= 1000000);
                case "1-2m" -> stream = stream.filter(p -> p.getPriceValue() >= 1000000 && p.getPriceValue() <= 2000000);
                case "2-3m" -> stream = stream.filter(p -> p.getPriceValue() >= 2000000 && p.getPriceValue() <= 3000000);
                case "over3m" -> stream = stream.filter(p -> p.getPriceValue() > 3000000);
            }
        }

        if (!brandIds.isEmpty()) {
            stream = stream.filter(p -> brandIds.contains(p.getBrand_id()));
        }

        List<Product> filtered = stream.toList();

        // ====== Sắp xếp ======
        if ("price_asc".equals(sort)) {
            filtered = filtered.stream()
                    .sorted(Comparator.comparing(Product::getPriceValue))
                    .toList();
        } else if ("price_desc".equals(sort)) {
            filtered = filtered.stream()
                    .sorted(Comparator.comparing(Product::getPriceValue).reversed())
                    .toList();
        } else if ("newest".equals(sort)) {
            filtered = filtered.stream()
                    .sorted(Comparator.comparing(Product::getCreatedAt).reversed())
                    .toList();
        }

        // ====== Set attribute cho JSP ======
        request.setAttribute("wishlist", filtered);
        request.setAttribute("categories", categoryDao.getCategory());
        request.setAttribute("brands", brandDao.getBrands());

        // giữ trạng thái filter để hiển thị checked/selected
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("selectedBrandIds", brandIds);
        request.setAttribute("selectedPriceRange", priceRange);
        request.setAttribute("selectedSort", sort);

        request.getRequestDispatcher("/Assets/component/login_logout/wishlist.jsp").forward(request, response);
    }
}
