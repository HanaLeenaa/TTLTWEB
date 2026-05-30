package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ContactDao;
import com.example.web_console_handheld.dao.ContactMessageDao;
import com.example.web_console_handheld.model.Contact;
import com.example.web_console_handheld.model.ContactMessage;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    private ContactDao contactDao;
    private ContactMessageDao contactMessageDao;

    @Override
    public void init() {
        contactDao = new ContactDao();
        contactMessageDao = new ContactMessageDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Contact contact = contactDao.getContactInfo();
        req.setAttribute("contact", contact);

        req.getRequestDispatcher("/contact.jsp").forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        User user = (User)session.getAttribute("auth");

        if (user==null){
            resp.sendRedirect(req.getContextPath()+"/login");
            return;
        }
        String message = req.getParameter("message");
        ContactMessage c = new ContactMessage();
        c.setUserId(user.getId());
        c.setName(user.getUsername());
        c.setEmail(user.getEmail());
        c.setPhone(user.getPhoneNum());
        c.setMessage(message);

        try {
            contactMessageDao.insert(c);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        resp.sendRedirect(req.getContextPath()+"/contact?success=1");


    }
}
