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

        // ====== DỮ LIỆU CHUNG CHO HOME (ĐÃ TÁCH BIỆT TRÁNH SẬP DÂY CHUYỀN) ======
        try {
            request.setAttribute("banners", bannerDao.getActiveBanners());
        } catch (Exception e) {
            System.err.println("Lỗi tại bannerDao.getActiveBanners()");
            e.printStackTrace();
        }

        try {
            request.setAttribute("categories", categoryDao.getCategory());
        } catch (Exception e) {
            System.err.println("Lỗi tại categoryDao.getCategory()");
            e.printStackTrace();
        }

        try {
            request.setAttribute("products", productDao.getProductListForHome());
        } catch (Exception e) {
            System.err.println("Lỗi tại productDao.getProductListForHome()");
            e.printStackTrace();
        }

        try {
            request.setAttribute("highest", productDao.getHighestDiscountProduct());
        } catch (Exception e) {
            System.err.println("Lỗi tại productDao.getHighestDiscountProduct()");
            e.printStackTrace();
        }

        try {
            request.setAttribute("smaller", productDao.getProductSmallerThanList());
        } catch (Exception e) {
            System.err.println("Lỗi tại productDao.getProductSmallerThanList()");
            e.printStackTrace();
        }

        try {
            request.setAttribute("smallest", productDao.getSmallestProduct());
        } catch (Exception e) {
            System.err.println("Lỗi tại productDao.getSmallestProduct()");
            e.printStackTrace();
        }

        try {
            request.setAttribute("bloglist", blogDao.getBlogList());
        } catch (Exception e) {
            System.err.println("Lỗi tại blogDao.getBlogList()");
            e.printStackTrace();
        }

        // sản phẩm xem gần đây
        if (user != null) {
            try {
                List<Product> recentProducts = historyDao.getRecentViews(user.getId());
                request.setAttribute("recentProducts", recentProducts != null ? recentProducts : new ArrayList<>());
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("recentProducts", new ArrayList<>());
            }
        } else {
            request.setAttribute("recentProducts", new ArrayList<>());
        }

        // ====== LOGIC 1: WISHLIST VÀ GỢI Ý THEO SẢN PHẨM YÊU THÍCH ======
        String wishlistIdString = "";
        List<Product> suggestions = new ArrayList<>();

        if (user != null) {
            try {
                List<Product> wishlist = new ArrayList<>();
                Object wlObj = session.getAttribute("wishlist");

                // Check an toàn kiểm tra danh sách có thực sự chứa Object Product không
                if (wlObj instanceof List<?> && !((List<?>) wlObj).isEmpty() && ((List<?>) wlObj).get(0) instanceof Product) {
                    wishlist = (List<Product>) wlObj;
                } else {
                    // Nếu session chưa có hoặc bị lưu sai kiểu dữ liệu, chủ động query lại từ DB
                    List<Integer> pids = wishlistDao.getWishlistByUser(user.getId());
                    if (pids != null) {
                        for (int pid : pids) {
                            Product p = productDao.getProductDetailByID(pid);
                            if (p != null) wishlist.add(p);
                        }
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

                    suggestions = productDao.getSuggestions(user.getId(), minRange, maxRange, 5);

                    System.out.println(">>> wishlist size=" + wishlist.size());
                    System.out.println(">>> minRange=" + minRange + ", maxRange=" + maxRange);
                    System.out.println(">>> suggestions size=" + (suggestions != null ? suggestions.size() : 0));
                }
            } catch (Exception e) {
                System.err.println("Lỗi xử lý suggestions theo wishlist");
                e.printStackTrace();
            }
        }

        // Đảm bảo dữ liệu đẩy đi luôn là một chuỗi / list cụ thể không bao giờ null
        request.setAttribute("wishlistIdString", wishlistIdString);
        request.setAttribute("suggestions", suggestions != null ? suggestions : new ArrayList<>());


        // ====== LOGIC 2: GỢI Ý THEO SẢN PHẨM ĐÃ ĐẶT MUA (MỚI THÊM VÀO) ======
        List<Product> orderSuggestions = new ArrayList<>();
        if (user != null) {
            try {
                orderSuggestions = productDao.getSuggestionsByOrders(user.getId(), 5);
                System.out.println(">>> orderSuggestions size=" + (orderSuggestions != null ? orderSuggestions.size() : 0));
            } catch (Exception e) {
                System.err.println("❌ Lỗi tại productDao.getSuggestionsByOrders()");
                e.printStackTrace();
            }
        }

        // Luôn bảo toàn không null để thẻ <c:if test="${not empty orderSuggestions}"> hoạt động chuẩn xác
        request.setAttribute("orderSuggestions", orderSuggestions != null ? orderSuggestions : new ArrayList<>());

        request.getRequestDispatcher("/index.jsp").forward(request, resp);
    }
}