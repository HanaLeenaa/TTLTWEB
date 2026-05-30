package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OtpDao;
import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/verify-forgot-otp")
public class VerifyForgotOtpServlet extends HttpServlet {

    private final OtpDao otpDao = new OtpDao();
    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        User user = (User) session.getAttribute("forgotUser");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String otp = req.getParameter("otp");

        try {

            if (otpDao.isLocked(user.getId())) {

                req.setAttribute("error", "OTP bị khóa 15 phút do nhập sai quá 5 lần");

                req.getRequestDispatcher("/Assets/component/login_logout/VerifyForgotOtp.jsp").forward(req, resp);

                return;
            }

            boolean valid = otpDao.verify(user.getId(), otp);

            if (!valid) {

                otpDao.increaseFailedAttempts(user.getId());

                int attempts = otpDao.getFailedAttempts(user.getId());

                if (attempts >= 5) {

                    otpDao.lockOtp(user.getId());

                    req.setAttribute("error", "Bạn đã nhập sai OTP 5 lần. Hãy thử lại sau 15 phút.");

                } else {
                    req.setAttribute("error", "OTP sai. Còn " + (5 - attempts) + " lần thử.");
                }

                req.getRequestDispatcher("/Assets/component/login_logout/VerifyForgotOtp.jsp").forward(req, resp);
                return;
            }

            otpDao.resetAttempts(user.getId());

            session.setAttribute("resetUserId", user.getId());

            resp.sendRedirect(req.getContextPath() + "/ResetPassword");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}