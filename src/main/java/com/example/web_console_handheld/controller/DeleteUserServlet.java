package com.example.web_console_handheld.controller.admin;

import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.Admin;
import com.example.web_console_handheld.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

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

        // Không cho xoá ADMIN
        if (u != null && "ADMIN".equals(u.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        userDao.delete(userId);

        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
