package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ReviewDao;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/add-review")
public class AddReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        // Lấy user
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        //Lấy dữ liệu
        int productId, orderId, rating;
        try {
            productId = Integer.parseInt(request.getParameter("productId"));
            orderId = Integer.parseInt(request.getParameter("orderId"));
            rating = Integer.parseInt(request.getParameter("rating"));
        } catch (Exception e) {
            response.sendRedirect("product-detail?id=" + request.getParameter("productId"));
            return;
        }

        String text = request.getParameter("review_text");
        if (text == null) text = "";

        //Validate rating
        if (rating < 1 || rating > 5) {
            response.sendRedirect("product-detail?id=" + productId);
            return;
        }

        ReviewDao dao = new ReviewDao();
        //Check user có quyền đánh giá đúng order
        boolean isValid = dao.isValidOrder(user.getId(), productId, orderId);
        if (!isValid) {
            response.sendRedirect("product-detail?id=" + productId);
            return;
        }

        // Check đã đánh giá chưa
        boolean alreadyReviewed = dao.hasUserReviewed(user.getId(), productId, orderId);
        if (alreadyReviewed) {
            response.sendRedirect("product-detail?id=" + productId);
            return;
        }

        // Lưu review
        dao.addReview(productId, user.getId(), orderId, rating, text);

        response.sendRedirect("product-detail?id=" + productId);
    }
}