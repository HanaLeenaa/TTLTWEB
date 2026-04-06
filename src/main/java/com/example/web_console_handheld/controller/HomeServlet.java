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
    private BannerDao bannerDao = new BannerDao();
    private ProductDao productDao = new ProductDao();
    private CategoryDao categoryDao = new CategoryDao();
    private BlogDao blogDao = new BlogDao();
    private WishlistDao wishlistDao = new WishlistDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("auth") : null;

        // dữ liệu chung cho home
        request.setAttribute("banners", bannerDao.getActiveBanners());
        request.setAttribute("categories", categoryDao.getCategory());
        request.setAttribute("products", productDao.getProductListForHome());
        request.setAttribute("highest", productDao.getHighestDiscountProduct());
        request.setAttribute("smaller", productDao.getProductSmallerThanList());
        request.setAttribute("smallest", productDao.getSmallestProduct());
        request.setAttribute("bloglist", blogDao.getBlogList());

        if (user != null) {
            try {
                // lấy wishlist từ session (đã được AddWishlistServlet cập nhật)
                List<Product> wishlist = (List<Product>) session.getAttribute("wishlist");
                if (wishlist == null) {
                    // nếu chưa có thì lấy từ DB
                    List<Integer> wishlistIds = wishlistDao.getWishlistByUser(user.getId());
                    wishlist = new ArrayList<>();
                    for (int pid : wishlistIds) {
                        Product p = productDao.getProductDetailByID(pid);
                        if (p != null) wishlist.add(p);
                    }
                    session.setAttribute("wishlist", wishlist);
                }

                // tạo chuỗi wishlistIdString để JSP check tim
                String wishlistIdString = wishlist.stream()
                        .map(p -> String.valueOf(p.getID()))
                        .collect(Collectors.joining(","));
                request.setAttribute("wishlistIdString", wishlistIdString);

                // tạo danh sách gợi ý từ wishlist
                List<Product> suggestions = new ArrayList<>();
                for (Product p : wishlist) {
                    suggestions.addAll(productDao.getRelatedProducts(p.getID(), 5));
                }
                request.setAttribute("suggestions", suggestions);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("suggestions", List.of());
                request.setAttribute("wishlistIdString", "");
            }
        } else {
            request.setAttribute("suggestions", List.of());
            request.setAttribute("wishlistIdString", "");
        }

        // QUAN TRỌNG: forward về JSP
        request.getRequestDispatcher("/index.jsp").forward(request, resp);
    }
}
