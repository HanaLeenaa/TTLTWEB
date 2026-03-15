package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        boolean valid = token != null && userDao.isResetTokenValid(token);

        req.setAttribute("tokenValid", valid);
        req.setAttribute("token", token);
        req.getRequestDispatcher("/Assets/component/login_logout/ResetPassword.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (token == null || !userDao.isResetTokenValid(token)) {
            req.setAttribute("tokenValid", false);
            req.getRequestDispatcher("/Assets/component/login_logout/ResetPassword.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("tokenValid", true);
            req.setAttribute("token", token);
            req.setAttribute("error", "Mật khẩu nhập lại không khớp");
            req.getRequestDispatcher("/Assets/component/login_logout/ResetPassword.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra mật khẩu mạnh
        if (!isStrongPassword(newPassword)) {
            req.setAttribute("tokenValid", true);
            req.setAttribute("token", token);
            req.setAttribute("error", "Mật khẩu yếu. Yêu cầu: >=8 ký tự, chữ hoa, chữ thường, số, ký tự đặc biệt");
            req.getRequestDispatcher("/Assets/component/login_logout/ResetPassword.jsp").forward(req, resp);
            return;
        }

        boolean updated = userDao.updatePasswordByToken(token, newPassword);

        if (updated) {
            req.setAttribute("tokenValid", false); // ẩn form
            req.setAttribute("message", "Đổi mật khẩu thành công, vui lòng đăng nhập lại");
        } else {
            req.setAttribute("tokenValid", true);
            req.setAttribute("token", token);
            req.setAttribute("error", "Đổi mật khẩu thất bại, vui lòng thử lại");
        }

        req.getRequestDispatcher("/Assets/component/login_logout/ResetPassword.jsp").forward(req, resp);
    }

    // Kiểm tra mật khẩu mạnh
    private boolean isStrongPassword(String password) {
        String pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&^#(){}\\[\\]\\-_+=<>|]).{8,}$";
        return password.matches(pattern);
    }
}