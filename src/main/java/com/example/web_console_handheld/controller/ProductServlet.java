package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.BrandDao;
import com.example.web_console_handheld.dao.CategoryDao;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/product")
public class ProductServlet extends HttpServlet {

    private static final int PAGE_SIZE = 12;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDao productDao = new ProductDao();

        /* ================= PAGE ================= */
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {}
        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;

        /* ================= PARAMS ================= */
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
        String keyword = request.getParameter("q");

        List<Integer> brandIds = null;
        String[] brandArr = request.getParameterValues("brandId");
        if (brandArr != null) {
            brandIds = Arrays.stream(brandArr)
                    .filter(s -> s != null && !s.isEmpty())
                    .map(Integer::parseInt)
                    .toList();
        }

        List<Integer> useTimes = null;
        String[] useArr = request.getParameterValues("useTime");
        if (useArr != null) {
            useTimes = Arrays.stream(useArr)
                    .filter(s -> s != null && !s.isEmpty())
                    .map(Integer::parseInt)
                    .toList();
        }

        /* ================= DATA ================= */
        List<Product> products;
        int totalProduct;
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        if (hasKeyword) {
            products = productDao.searchByNameFilterPage(
                    keyword, categoryIds, priceRange, brandIds, useTimes, sort, offset, PAGE_SIZE
            );
            totalProduct = productDao.countSearchByNameFilter(
                    keyword, categoryIds, priceRange, brandIds, useTimes
            );
            request.setAttribute("keyword", keyword);
        } else {
            // nếu categoryIds null hoặc rỗng thì lấy toàn bộ
            if (categoryIds == null || categoryIds.isEmpty()) {
                products = productDao.getAllProductsPage(priceRange, categoryIds, brandIds, useTimes, sort, offset, PAGE_SIZE);
                totalProduct = productDao.countAllProducts(priceRange, categoryIds, brandIds, useTimes);
            } else {
                products = productDao.filterSortPage(categoryIds, priceRange, brandIds, useTimes, sort, offset, PAGE_SIZE);
                totalProduct = productDao.countFilter(categoryIds, priceRange, brandIds, useTimes);
            }
        }


        int totalPage = (int) Math.ceil((double) totalProduct / PAGE_SIZE);
        if (page > totalPage && totalPage > 0) page = totalPage;

        /* ================= ATTRIBUTES ================= */
        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPage", totalPage);

        // giữ trạng thái filter
        request.setAttribute("selectedCategoryIds", categoryIds);
        request.setAttribute("selectedBrandIds", brandIds);
        request.setAttribute("selectedUseTimes", useTimes);
        request.setAttribute("selectedPriceRange", priceRange);
        request.setAttribute("selectedSort", sort);

        /* ================= LOAD FILTER DATA ================= */
        request.setAttribute("categories", new CategoryDao().getCategory());
        request.setAttribute("brands", new BrandDao().getBrands());
        request.setAttribute("energy", productDao.getEnergyProductList());

        /* ================= WISHLIST IDS ================= */
        HttpSession session = request.getSession(false);
        List<Product> wishlist = (session != null) ? (List<Product>) session.getAttribute("wishlist") : null;
        if (wishlist != null && !wishlist.isEmpty()) {
            // tạo chuỗi ID để JSP dùng fn:contains
            String wishlistIdString = wishlist.stream()
                    .map(p -> String.valueOf(p.getID()))
                    .reduce("", (a, b) -> a.isEmpty() ? b : a + "," + b);
            request.setAttribute("wishlistIdString", wishlistIdString);
        } else {
            request.setAttribute("wishlistIdString", "");
        }

        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }
}
