package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ReviewDao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/review-delete")
public class AdminReviewDeleteServlet extends HttpServlet {

    private final ReviewDao dao = new ReviewDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        dao.deleteReview(id);

        resp.sendRedirect(req.getContextPath() + "/admin/reviews");
    }
}
