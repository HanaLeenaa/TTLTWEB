package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        // lấy user đang login
        User authUser = (User) session.getAttribute("auth");
        if (authUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = authUser.getId();
        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // check mật khẩu cũ
        if (!userDao.checkOldPassword(userId, oldPassword)) {

            session.setAttribute("error", "Mật khẩu cũ không đúng");

            resp.sendRedirect(
                    req.getContextPath() + "/profile?tab=password"
            );
            return;
        }

        // validate password mới
        if (!ValidationUtil.isValidPassword(newPassword)) {
            session.setAttribute("error", "Mật khẩu phải >= 8 ký tự gồm chữ hoa, chữ thường, số và ký tự đặc biệt");
            resp.sendRedirect(req.getContextPath() + "/profile?tab=password");
            return;
        }

    // check confirm password
        if (!ValidationUtil.isPasswordMatch(newPassword, confirmPassword)) {
            session.setAttribute("error", "Xác nhận mật khẩu không khớp");

            resp.sendRedirect(req.getContextPath() + "/profile?tab=password");
            return;
        }

    // update password
        boolean updated = userDao.updatePassword(userId, newPassword);
        if (updated) {
            session.setAttribute("successMessage", "Đổi mật khẩu thành công");

        } else {
            session.setAttribute("error", "Đổi mật khẩu thất bại");
        }

        resp.sendRedirect(req.getContextPath() + "/profile?tab=password");
    }
}