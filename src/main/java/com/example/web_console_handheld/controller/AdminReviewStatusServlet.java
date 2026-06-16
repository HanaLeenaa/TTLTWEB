package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ReviewDao;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/review-status")
public class AdminReviewStatusServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        boolean status = Boolean.parseBoolean(req.getParameter("status"));

        ReviewDao dao = new ReviewDao();

        if (status) {
            dao.hideReview(id);

        } else {
            dao.showReview(id);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/reviews");
    }
}