package com.example.web_console_handheld.controller;
import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.Admin;
import com.example.web_console_handheld.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/delete-user")
public class DeleteUserServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        if (admin == null) {
            resp.sendRedirect(req.getContextPath() + "/admin-login");
            return;
        }

        int userId = Integer.parseInt(req.getParameter("userId"));

        User u = userDao.getUserById(userId);

        // nếu user không tồn tại thì quay lại
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        // Không cho xoá ADMIN
        if (u != null && "ADMIN".equals(u.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        // Không xóa lại user đã bị xóa mềm
        if (u.isDeleted()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }
        // xóa mềm user
        userDao.softDeleteUser(userId);

        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
