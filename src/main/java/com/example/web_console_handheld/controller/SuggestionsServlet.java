package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.dao.WishlistDao;
import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/suggestions")
public class SuggestionsServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();
    private WishlistDao wishlistDao = new WishlistDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("auth") : null;

        List<Product> suggestions = new ArrayList<>();
        String wishlistIdString = "";

        if (user != null) {
            List<Integer> wishlistIds = wishlistDao.getWishlistByUser(user.getId());
            List<Product> wishlist = new ArrayList<>();
            for (int pid : wishlistIds) {
                Product p = productDao.getProductDetailByID(pid);
                if (p != null) wishlist.add(p);
            }

            wishlistIdString = wishlist.stream()
                    .map(p -> String.valueOf(p.getID()))
                    .collect(Collectors.joining(","));

            long minPrice = wishlist.stream().mapToLong(Product::getPrice).min().orElse(0);
            long maxPrice = wishlist.stream().mapToLong(Product::getPrice).max().orElse(Long.MAX_VALUE);
            long minRange = (long)(minPrice * 0.8);
            long maxRange = (long)(maxPrice * 1.2);

            // Lấy tất cả gợi ý
            List<Product> allSuggestions = productDao.getSuggestions(user.getId(), minRange, maxRange, 200);

            // Nếu không có gợi ý thì fallback: lấy top sản phẩm
            if (allSuggestions.isEmpty()) {
                allSuggestions = productDao.getTopProducts(50);
            }

            // Phân trang
            int pageSize = 12;
            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                } catch (NumberFormatException ignored) {}
            }

            int totalPage = (int) Math.ceil((double) allSuggestions.size() / pageSize);

            int fromIndex = (currentPage - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, allSuggestions.size());
            if (fromIndex < allSuggestions.size()) {
                suggestions = allSuggestions.subList(fromIndex, toIndex);
            }

            request.setAttribute("totalPage", totalPage);
            request.setAttribute("currentPage", currentPage);
        }

        request.setAttribute("wishlistIdString", wishlistIdString);
        request.setAttribute("suggestions", suggestions);
        request.getRequestDispatcher("/Assets/component/wishlist/suggestions.jsp").forward(request, response);
    }
}
