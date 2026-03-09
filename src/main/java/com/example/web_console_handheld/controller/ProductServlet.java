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
        Integer categoryId = null;
        try {
            categoryId = Integer.parseInt(request.getParameter("categoryId"));
        } catch (Exception ignored) {}

        String priceRange = request.getParameter("priceRange");
        String sort = request.getParameter("sort");
        String keyword = request.getParameter("q");

        List<Integer> brandIds = null;
        String[] brandArr = request.getParameterValues("brandId");
        if (brandArr != null) {
            brandIds = Arrays.stream(brandArr)
                    .map(Integer::parseInt)
                    .toList();
        }

        List<Integer> useTimes = null;
        String[] useArr = request.getParameterValues("useTime");
        if (useArr != null) {
            useTimes = Arrays.stream(useArr)
                    .map(Integer::parseInt)
                    .toList();
        }

        /* ================= DATA ================= */
        List<Product> products;
        int totalProduct;

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        if (hasKeyword) {
            keyword = keyword.trim();

            products = productDao.searchByNameFilterPage(
                    keyword,
                    categoryId,
                    priceRange,
                    brandIds,
                    useTimes,
                    sort,
                    offset,
                    PAGE_SIZE
            );

            totalProduct = productDao.countSearchByNameFilter(
                    keyword,
                    categoryId,
                    priceRange,
                    brandIds,
                    useTimes
            );

            request.setAttribute("keyword", keyword);
        } else {
            products = productDao.filterSortPage(
                    categoryId,
                    priceRange,
                    brandIds,
                    useTimes,
                    sort,
                    offset,
                    PAGE_SIZE
            );

            totalProduct = productDao.countFilter(
                    categoryId,
                    priceRange,
                    brandIds,
                    useTimes
            );
        }

        int totalPage = (int) Math.ceil((double) totalProduct / PAGE_SIZE);
        if (page > totalPage && totalPage > 0) page = totalPage;

        /* ================= ATTRIBUTES ================= */
        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPage", totalPage);

        // giữ trạng thái filter
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("selectedBrandIds", brandIds);
        request.setAttribute("selectedUseTimes", useTimes);
        request.setAttribute("selectedPriceRange", priceRange);
        request.setAttribute("selectedSort", sort);

        /* ================= LOAD FILTER DATA ================= */
        request.setAttribute("categories", new CategoryDao().getCategory());
        request.setAttribute("brands", new BrandDao().getBrands());
        request.setAttribute("energy", productDao.getEnergyProductList());

        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }
}
