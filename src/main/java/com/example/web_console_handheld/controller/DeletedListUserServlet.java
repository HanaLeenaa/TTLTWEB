package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.Admin;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/deleted-users")
public class DeletedListUserServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        if (admin == null) {
            resp.sendRedirect(req.getContextPath() + "/admin-login");
            return;
        }

        List<User> userList = userDao.getDeletedUsers();
        req.setAttribute("userList", userList);
        req.getRequestDispatcher("/Assets/component/adminPage/deletedUsers.jsp").forward(req, resp);
    }
}

