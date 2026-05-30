package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.*;
import com.example.web_console_handheld.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    private final ProductDao productDao = new ProductDao();
    private final CategoryDao categoryDao = new CategoryDao();
    private final BrandDao brandDao = new BrandDao();
    private final GallaryDao gallaryDao = new GallaryDao();
    private final ReviewDao reviewDao = new ReviewDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("product");
            return;
        }

        int productId = Integer.parseInt(idParam);
        Product product = productDao.getProductDetailByID(productId);
        if (product == null) {
            response.sendRedirect("product");
            return;
        }

        Category category = categoryDao.getCategoryByProductId(productId);
        Brand brand = brandDao.getBrandByProductId(productId);

        List<Product> relateProductList = List.of();
        if (brand != null && category != null) {
            relateProductList = productDao.getProductListByBrandAndCategory(
                    brand.getID(), category.getID(), productId);
        }

        List<Gallary> gallaryList = gallaryDao.getListGallaryBy_product_id(productId);

        // reviews
        List<Review> allReviews = reviewDao.getReviewByID(productId);
        int reviewQuantity = allReviews.size();

        double avgRating = reviewDao.getAverageRating(productId);

        // count stars
        int fiveStars = reviewDao.countByStar(productId, 5);
        int fourStars = reviewDao.countByStar(productId, 4);
        int threeStars = reviewDao.countByStar(productId, 3);
        int twoStars = reviewDao.countByStar(productId, 2);
        int oneStar = reviewDao.countByStar(productId, 1);

        double avg5 = reviewQuantity > 0 ? fiveStars * 100.0 / reviewQuantity : 0;
        double avg4 = reviewQuantity > 0 ? fourStars * 100.0 / reviewQuantity : 0;
        double avg3 = reviewQuantity > 0 ? threeStars * 100.0 / reviewQuantity : 0;
        double avg2 = reviewQuantity > 0 ? twoStars * 100.0 / reviewQuantity : 0;
        double avg1 = reviewQuantity > 0 ? oneStar * 100.0 / reviewQuantity : 0;

        // check review
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        int orderIdCanReview = 0;
        boolean canReview = false;

        if (user != null) {
            orderIdCanReview = reviewDao.getOrderIdCanReviewV2(user.getId(), productId);
            canReview = orderIdCanReview != 0;
        }

        // split text
        String[] endowList = product.getEndow() != null
                ? product.getEndow().split("\\r?\\n")
                : new String[0];

        String[] descLines = product.getShort_description() != null
                ? product.getShort_description().split("\\r?\\n")
                : new String[0];

        // set attribute
        request.setAttribute("product", product);
        request.setAttribute("category", category);
        request.setAttribute("brand", brand);
        request.setAttribute("gallary", gallaryList);
        request.setAttribute("relateProductList", relateProductList);

        request.setAttribute("reviews", allReviews);
        request.setAttribute("quantity", reviewQuantity);
        request.setAttribute("avg", avgRating);

        request.setAttribute("fiveStars", fiveStars);
        request.setAttribute("fourStars", fourStars);
        request.setAttribute("threeStars", threeStars);
        request.setAttribute("twoStars", twoStars);
        request.setAttribute("oneStar", oneStar);

        request.setAttribute("avg5", avg5);
        request.setAttribute("avg4", avg4);
        request.setAttribute("avg3", avg3);
        request.setAttribute("avg2", avg2);
        request.setAttribute("avg1", avg1);

        request.setAttribute("endowList", endowList);
        request.setAttribute("descLines", descLines);

        request.setAttribute("canReview", canReview);
        request.setAttribute("orderIdCanReview", orderIdCanReview);

        request.getRequestDispatcher("/Assets/Details/productDetails.jsp")
                .forward(request, response);
    }
}