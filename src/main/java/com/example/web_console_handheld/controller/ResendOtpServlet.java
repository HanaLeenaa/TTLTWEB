package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.service.EmailService;
import com.example.web_console_handheld.utils.OtpUtil;
import com.example.web_console_handheld.utils.PasswordUtil;

import jakarta.mail.MessagingException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/resend-otp")
public class ResendOtpServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();

        try {
            User tempUser = (User) session.getAttribute("tempUser");

            if (tempUser == null) {
                session.setAttribute("msg", "Phiên đăng ký đã hết hạn. Vui lòng đăng ký lại.");
                resp.sendRedirect(req.getContextPath() + "/register");
                return;
            }

            // Xóa OTP cũ khỏi danh sách active
            String oldOtpHash = (String) session.getAttribute("otpHash");

            // Tạo OTP mới duy nhất
            String rawOtp = OtpUtil.generateUniqueOtp();
            String otpHash = PasswordUtil.hash(rawOtp);
            LocalDateTime expiry = LocalDateTime.now().plusSeconds(300);

            session.setAttribute("otpHash", otpHash);
            session.setAttribute("otpExpiry", expiry);

            // Gửi email OTP
            EmailService.sendOtp(tempUser.getEmail(), rawOtp);

            session.setAttribute("msg", "Mã OTP mới đã được gửi. Vui lòng kiểm tra email.");
            resp.sendRedirect(req.getContextPath() + "/verify");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Không thể gửi email OTP. Vui lòng thử lại sau.");
            resp.sendRedirect(req.getContextPath() + "/verify");
        }
    }
}
