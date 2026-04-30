package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ContactMessageDao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/contact/reply")
public class AdminContactReplyServlet extends HttpServlet {
    private ContactMessageDao dao;

    @Override
    public void init() {
        dao = new ContactMessageDao();
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String reply = req.getParameter("reply");

        if (reply == null || reply.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/contact?error=empty");
            return;
        }
        reply = reply.trim();
        try {
            dao.reply(id, reply);
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin/contact?success=reply");
    }

}
