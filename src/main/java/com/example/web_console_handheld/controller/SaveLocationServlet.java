package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/save-location")
public class SaveLocationServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession();
        User auth = (User) session.getAttribute("auth");

        String address = req.getParameter("address");

        if (auth != null && address != null && !address.trim().isEmpty()) {
            userDao.updateLocation(auth.getId(), address);
            auth.setLocation(address);
            session.setAttribute("auth", auth);
        }
    }
}
