package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ReviewDao;
import com.example.web_console_handheld.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/add-review")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024)

public class AddReviewServlet extends HttpServlet {

    private ReviewDao reviewDao = new ReviewDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // check login
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // lấy dữ liệu
        int productId = Integer.parseInt(request.getParameter("productId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        // kiểm tra quyền review
        int orderId = reviewDao.getOrderIdCanReviewV2(user.getId(), productId);

        if (orderId == 0) {
            // không đủ điều kiện
            response.sendRedirect("product-detail?id=" + productId);
            return;
        }

        // upload ảnh (nếu có)
        Part filePart = request.getPart("image");
        String fileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

            String uploadPath = getServletContext().getRealPath("/uploads");
            java.io.File uploadDir = new java.io.File(uploadPath);

            if (!uploadDir.exists()) uploadDir.mkdir();

            filePart.write(uploadPath + "/" + fileName);
        }

        // lưu review
        reviewDao.insertReview(user.getId(), productId, orderId, rating, comment, fileName);

        response.sendRedirect("product-detail?id=" + productId);
    }
}