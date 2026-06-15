package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ReviewDao;
import com.example.web_console_handheld.model.Review;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reviews")
public class AdminReviewServlet extends HttpServlet {

    private final ReviewDao reviewDao = new ReviewDao();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        List<Review> reviews = reviewDao.getAllReviews();

        req.setAttribute("reviews", reviews);

        req.getRequestDispatcher(
                "/Assets/component/adminPage/reviewManagement.jsp"
        ).forward(req, resp);
    }
}