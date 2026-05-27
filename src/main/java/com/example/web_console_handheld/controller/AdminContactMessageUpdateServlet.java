package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ContactMessageDao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/contact/read")
public class AdminContactMessageUpdateServlet extends HttpServlet {
    private ContactMessageDao dao;

    @Override
    public void init() {
        dao = new ContactMessageDao();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        try {
            dao.updateStatus(id, "READ");
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin/contact");
    }
}

