package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.FeedBackDao;
import com.example.web_console_handheld.model.FeedBack;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User auth = (User) session.getAttribute("auth");
        if (auth == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String content = request.getParameter("content");
        if (content == null || content.isBlank()) {
            response.sendRedirect(request.getHeader("Referer"));
            return;
        }

        FeedBack f = new FeedBack();
        f.setUserId(auth.getId()); // ✅ LUÔN CÓ USER
        f.setContent(content);

        new FeedBackDao().save(f);

        session.setAttribute("feedbackSuccess", "Gửi phản hồi thành công!");

        response.sendRedirect(request.getHeader("Referer"));
    }
}

