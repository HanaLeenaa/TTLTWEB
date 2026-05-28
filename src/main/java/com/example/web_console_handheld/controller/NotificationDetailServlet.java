package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ContactMessageDao;
import com.example.web_console_handheld.model.ContactMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/user/notification/read")
public class NotificationDetailServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ContactMessageDao dao = new ContactMessageDao();
        ContactMessage c = dao.getById(id);
        dao.markAsRead(id);
        request.setAttribute("notify", c);
        request.getRequestDispatcher("/Assets/component/recycleFiles/notificationDetail.jsp").forward(request, response);
    }
}
