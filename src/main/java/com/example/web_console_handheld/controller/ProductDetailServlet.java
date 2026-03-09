package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.*;
import com.example.web_console_handheld.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();
    private CategoryDao categoryDao = new CategoryDao();
    private BrandDao brandDao = new BrandDao();
    private GallaryDao gallaryDao = new GallaryDao();
    private ReviewDao reviewDao = new ReviewDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.sendRedirect("product");
            return;
        }

        int id = Integer.parseInt(idParam);
        Category category = categoryDao.getCategoryByProductId(id);
        Brand brand = brandDao.getBrandByProductId(id);
        List<Product> relateProductList = productDao.getProductListByBrandAndCategory(brand.getID(), category.getID(), id);
        List<Gallary> gallaryList = gallaryDao.getListGallaryBy_product_id(id);
        List<Review> reviewList = reviewDao.getAllQuantity(id);
        double avg;
        List<Review> allReviewByID = reviewDao.getReviewByID(id);
        double all = allReviewByID.size();
        Review Devision = reviewDao.sum(id);
        double DevisionNum = Devision.getRating();
        if(DevisionNum == 0 && all == 0){
            avg = 0.0;
        }else{
            avg = DevisionNum / all;
        }
        int reviewQuantity = reviewList.size();
        double avg5 = 0, avg4 = 0, avg3 = 0, avg2 = 0, avg1 = 0;
        List<Review> five = reviewDao.countReview5Stars(id);
        int fiveStars = five.size();
        List<Review> four = reviewDao.countReview4Stars(id);
        int fourStars = four.size();
        List<Review> three = reviewDao.countReview3Stars(id);
        int threeStars = three.size();
        List<Review> two = reviewDao.countReview2Stars(id);
        int twoStars = two.size();
        List<Review> one = reviewDao.countReview1Stars(id);
        int oneStar = one.size();
        if (reviewQuantity > 0) {
            avg5 = fiveStars * 100.0 / reviewQuantity;
            avg4 = fourStars * 100.0 / reviewQuantity;
            avg3 = threeStars * 100.0 / reviewQuantity;
            avg2 = twoStars * 100.0 / reviewQuantity;
            avg1 = oneStar * 100.0 / reviewQuantity;
        }

        request.setAttribute("avg5", avg5);
        request.setAttribute("avg4", avg4);
        request.setAttribute("avg3", avg3);
        request.setAttribute("avg2", avg2);
        request.setAttribute("avg1", avg1);
        request.setAttribute("fiveStars", fiveStars);
        request.setAttribute("fourStars", fourStars);
        request.setAttribute("threeStars", threeStars);
        request.setAttribute("twoStars", twoStars);
        request.setAttribute("oneStar", oneStar);
        request.setAttribute("avg", avg);

        request.setAttribute("quantity", reviewQuantity);
        request.setAttribute("reviews", reviewList);
        request.setAttribute("gallary", gallaryList);
        request.setAttribute("brand", brand);
        request.setAttribute("category", category);
        request.setAttribute("relateProductList", relateProductList);

        Product product = productDao.getProductDetailByID(id);
        if (product == null) {
            response.sendRedirect("product");
            return;
        }

        String[] endowList = new String[0];
        if (product.getEndow() != null && !product.getEndow().isBlank()) {
            endowList = product.getEndow().split("\\r?\\n");
        }

        String desc = product.getShort_description();
        String[] descLines = new String[0];
        if (desc != null && !desc.isBlank()) {
            descLines = desc.split("\\r?\\n");
        }

        request.setAttribute("descLines", descLines);
        request.setAttribute("endowList", endowList);
        request.setAttribute("product", product);

        request.getRequestDispatcher("/Assets/Details/productDetails.jsp").forward(request, response);
    }
}
