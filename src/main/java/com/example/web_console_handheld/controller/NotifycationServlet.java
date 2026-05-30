package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ContactMessageDao;
import com.example.web_console_handheld.model.ContactMessage;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/user/notifications")
public class NotifycationServlet extends HttpServlet {
    private ContactMessageDao dao = new ContactMessageDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        try {
            List<ContactMessage> list = dao.getRepliedByUser(user.getId());
            request.setAttribute("notification", list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/Assets/component/recycleFiles/notification.jsp").forward(request, response);
    }
}
