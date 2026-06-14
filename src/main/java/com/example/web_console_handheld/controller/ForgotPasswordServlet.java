package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OtpDao;
import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.service.EmailService;
import com.example.web_console_handheld.utils.OtpUtil;
import com.example.web_console_handheld.utils.PasswordUtil;
import com.example.web_console_handheld.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();
    private final OtpDao otpDao = new OtpDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/Assets/component/login_logout/ForgotPassword.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");

        if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("error", "Email không hợp lệ");
            req.getRequestDispatcher("/Assets/component/login_logout/ForgotPassword.jsp")
                    .forward(req, resp);
            return;
        }

        User user = userDao.findByEmail(email);

        if (user == null) {
            req.setAttribute("error", "Email không tồn tại");
            req.getRequestDispatcher("/Assets/component/login_logout/ForgotPassword.jsp")
                    .forward(req, resp);
            return;
        }

        // kiểm tra khóa
        if (userDao.isForgotPasswordLocked(user.getId())) {
            req.setAttribute("error", "Tài khoản đang bị khóa quên mật khẩu 15 phút");
            req.getRequestDispatcher("/Assets/component/login_logout/ForgotPassword.jsp").forward(req, resp);
            return;
        }

        try {

            userDao.increaseForgotPasswordAttempts(user.getId());

            if (userDao.isForgotPasswordWindowExpired(user.getId())) {
                userDao.resetForgotPasswordWindow(user.getId());
            }

            userDao.setFirstForgotAttempt(user.getId());

            userDao.increaseForgotPasswordAttempts(user.getId());
            int attempts = userDao.getForgotPasswordAttempts(user.getId());

            if (attempts >= 10) {

                userDao.lockForgotPassword(user.getId());

                req.setAttribute("error",
                        "Bạn đã yêu cầu OTP quá 10 lần trong 30 phút. Tài khoản bị khóa 15 phút.");

                req.getRequestDispatcher("/Assets/component/login_logout/ForgotPassword.jsp").forward(req, resp);
                return;
            }

            String rawOtp = OtpUtil.generateUniqueOtp();

            String otpHash = PasswordUtil.hash(rawOtp);

            LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(5);

            otpDao.saveOtp(user.getId(), otpHash, expiredAt);

            EmailService.sendOtp(user.getEmail(), rawOtp);

            HttpSession session = req.getSession();

            session.setAttribute("forgotUser", user);

            resp.sendRedirect(req.getContextPath()
                    + "/verify-forgot-otp");

        } catch (Exception e) {
            e.printStackTrace();

            req.setAttribute("error", "Lỗi gửi OTP");

            req.getRequestDispatcher("/Assets/component/login_logout/ForgotPassword.jsp")
                    .forward(req, resp);
        }
    }
}