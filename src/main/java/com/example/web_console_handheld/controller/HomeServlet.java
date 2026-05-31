package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.*;
import com.example.web_console_handheld.model.*;
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

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private final BannerDao bannerDao = new BannerDao();
    private final ProductDao productDao = new ProductDao();
    private final CategoryDao categoryDao = new CategoryDao();
    private final BlogDao blogDao = new BlogDao();
    private final WishlistDao wishlistDao = new WishlistDao();
    private final ProductViewHistoryDao historyDao = new ProductViewHistoryDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (session != null) ? (User) session.getAttribute("auth") : null;

        request.setAttribute("auth", user);

        System.out.println(">>> HomeServlet doGet called, user=" + (user != null ? user.getUsername() : "null"));

        // dữ liệu chung cho home
        try {
            request.setAttribute("banners", bannerDao.getActiveBanners());
            request.setAttribute("categories", categoryDao.getCategory());
            request.setAttribute("products", productDao.getProductListForHome());
            request.setAttribute("highest", productDao.getHighestDiscountProduct());
            request.setAttribute("smaller", productDao.getProductSmallerThanList());
            request.setAttribute("smallest", productDao.getSmallestProduct());
            request.setAttribute("bloglist", blogDao.getBlogList());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // sản phẩm xem gần đây
        if (user != null) {
            try {
                List<Product> recentProducts = historyDao.getRecentViews(user.getId());
                request.setAttribute("recentProducts", recentProducts);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("recentProducts", new ArrayList<>());
            }
        } else {
            request.setAttribute("recentProducts", new ArrayList<>());
        }

        // wishlist và gợi ý
        String wishlistIdString = "";
        List<Product> suggestions = new ArrayList<>();

        if (user != null) {
            try {
                List<Product> wishlist = new ArrayList<>();
                Object wlObj = session.getAttribute("wishlist");



                if (wlObj instanceof List<?>) {
                    try {
                        wishlist = (List<Product>) wlObj;
                    } catch (ClassCastException cce) {
                        cce.printStackTrace();
                        wishlist = new ArrayList<>();
                    }
                } else {
                    for (int pid : wishlistDao.getWishlistByUser(user.getId())) {
                        Product p = productDao.getProductDetailByID(pid);
                        if (p != null) wishlist.add(p);
                    }
                    session.setAttribute("wishlist", wishlist);
                }

                if (!wishlist.isEmpty()) {
                    wishlistIdString = wishlist.stream()
                            .map(p -> String.valueOf(p.getID()))
                            .collect(Collectors.joining(","));

                    long minPrice = wishlist.stream().mapToLong(Product::getPrice).min().orElse(0);
                    long maxPrice = wishlist.stream().mapToLong(Product::getPrice).max().orElse(Long.MAX_VALUE);
                    long minRange = (long) (minPrice * 0.5);
                    long maxRange = (long) (maxPrice * 1.5);


                    // sau đoạn lấy suggestions
                    suggestions = productDao.getSuggestions(user.getId(), minRange, maxRange, 5);



                    System.out.println(">>> wishlist size=" + wishlist.size());
                    System.out.println(">>> minRange=" + minRange + ", maxRange=" + maxRange);
                    System.out.println(">>> suggestions size=" + (suggestions != null ? suggestions.size() : 0));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("wishlistIdString", wishlistIdString);
        request.setAttribute("suggestions", suggestions);


        request.getRequestDispatcher("/index.jsp").forward(request, resp);
    }
}
