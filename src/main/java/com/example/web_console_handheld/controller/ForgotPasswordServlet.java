package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.service.EmailService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.UUID;


@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        handleForgotPassword(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        handleForgotPassword(req, resp);
    }

    private void handleForgotPassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        if (email == null || email.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\":\"Vui lòng nhập email\"}");
            return;
        }

        User user = userDao.findByEmail(email.trim());
        if (user == null) {
            out.print("{\"success\": false, \"message\":\"Email không tồn tại\"}");
            return;
        }

        // Tạo token reset + lưu db với thời hạn 15 phút
        String token = UUID.randomUUID().toString();
        LocalDateTime expireAt = LocalDateTime.now().plusMinutes(15);
        userDao.saveResetToken(email.trim(), token, expireAt);

        // Tạo link reset password đầy đủ
        String link = req.getScheme() + "://" + req.getServerName()
                + ":" + req.getServerPort()
                + req.getContextPath() + "/reset-password?token=" + token;

        // Gửi email
        EmailService.sendResetPasswordEmail(email.trim(), link);
        out.print("{\"success\": true, \"message\":\"Email đổi mật khẩu đã được gửi. Vui lòng kiểm tra hộp thư.\"}");
    }
}