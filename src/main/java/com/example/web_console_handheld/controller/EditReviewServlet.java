package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ReviewDao;
import com.example.web_console_handheld.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

    @WebServlet("/edit-review")
    public class EditReviewServlet extends HttpServlet {

        private ReviewDao reviewDao = new ReviewDao();

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws IOException {

            User user = (User) request.getSession().getAttribute("auth");
            if (user == null) {
                response.sendRedirect("login");
                return;
            }

            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String text = request.getParameter("review_text");

            reviewDao.updateReview(reviewId, user.getId(), rating, text);

            response.sendRedirect(request.getContextPath() + "/profile?tab=reviews");
        }
    }
