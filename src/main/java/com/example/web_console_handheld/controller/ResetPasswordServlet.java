package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        Integer userId = (Integer) session.getAttribute("resetUserId");

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (!ValidationUtil.isValidPassword(newPassword)) {

            req.setAttribute("error", "Mật khẩu phải >=8 ký tự gồm hoa, thường, số, ký tự đặc biệt");

            req.getRequestDispatcher("/Assets/component/login_logout/ResetPassword.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {

            req.setAttribute("error", "Mật khẩu xác nhận không khớp");

            req.getRequestDispatcher("/Assets/component/login_logout/ResetPassword.jsp").forward(req, resp);

            return;
        }

        boolean updated = userDao.updatePassword(userId, newPassword);

        if (updated) {

            session.removeAttribute("resetUserId");
            session.removeAttribute("forgotUser");

            session.setAttribute("loginMessage", "Đổi mật khẩu thành công. Vui lòng đăng nhập lại.");

            resp.sendRedirect(req.getContextPath() + "/login");

        } else {

            req.setAttribute("error",
                    "Đổi mật khẩu thất bại");

            req.getRequestDispatcher("/Assets/component/login_logout/ResetPassword.jsp")
                    .forward(req, resp);
        }
    }

}
