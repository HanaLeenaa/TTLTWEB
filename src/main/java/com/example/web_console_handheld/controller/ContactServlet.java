package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ContactDao;
import com.example.web_console_handheld.model.Contact;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    private ContactDao contactDao;

    @Override
    public void init() {
        contactDao = new ContactDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Contact contact = contactDao.getContactInfo();
        req.setAttribute("contact", contact);

        req.getRequestDispatcher("/contact.jsp").forward(req, resp);
    }
}
