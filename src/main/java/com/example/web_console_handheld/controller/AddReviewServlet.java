package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ReviewDao;
import com.example.web_console_handheld.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/add-review")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 20
)
public class AddReviewServlet extends HttpServlet {

    private final ReviewDao reviewDao = new ReviewDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("auth");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int userId = user.getId();
        int productId;
        int rating;

        try {
            productId = Integer.parseInt(request.getParameter("productId"));
            rating = Integer.parseInt(request.getParameter("rating"));

        } catch (NumberFormatException e) {

            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Dữ liệu không hợp lệ");
            return;
        }

        if (rating < 1 || rating > 5) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Số sao phải từ 1 đến 5");
            return;
        }

        String comment = request.getParameter("comment");
        if (comment != null) {
            comment = comment.trim();
        }

        if (comment != null && comment.length() > 1000) {
            request.getSession().setAttribute("error", "Nội dung đánh giá quá dài");

            response.sendRedirect(
                    request.getHeader("Referer")
            );
            return;
        }

        // Kiểm tra đã mua và chưa review
        int orderId = reviewDao.getOrderIdCanReviewV2(userId, productId);

        if (orderId == 0) {
            request.getSession().setAttribute("error", "Bạn chưa mua sản phẩm này hoặc đã đánh giá rồi");
            response.sendRedirect(request.getHeader("Referer"));
            return;
        }

        String imageName = null;
        Part filePart = request.getPart("review_image");

        if (filePart != null && filePart.getSize() > 0) {

            String contentType = filePart.getContentType();

            if (contentType == null || !contentType.startsWith("image/")) {
                request.getSession().setAttribute("error", "Chỉ được upload file ảnh");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            String lowerFileName = originalFileName.toLowerCase();

            if (!lowerFileName.endsWith(".jpg")
                    && !lowerFileName.endsWith(".jpeg")
                    && !lowerFileName.endsWith(".png")
                    && !lowerFileName.endsWith(".webp")) {

                request.getSession().setAttribute("error", "Chỉ chấp nhận file JPG, JPEG, PNG hoặc WEBP");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            imageName = UUID.randomUUID() + "_" + originalFileName;

            String uploadPath = getServletContext().getRealPath("/images");

            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            filePart.write(uploadPath + File.separator + imageName);
        }

        reviewDao.insertReview(
                userId,
                productId,
                orderId,
                rating,
                comment,
                imageName);

        request.getSession().setAttribute("success", "Đánh giá thành công");
        response.sendRedirect(request.getHeader("Referer"));
    }
}