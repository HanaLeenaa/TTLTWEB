package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/restore-user")
public class RestoreUserServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        userDao.restoreUser(userId);

        response.sendRedirect(request.getContextPath() + "/admin/users");

    }
}
