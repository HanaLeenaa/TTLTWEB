package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ContactMessageDao;
import com.example.web_console_handheld.model.ContactMessage;
import com.example.web_console_handheld.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/contact")
public class AdminContactMessageServlet extends HttpServlet {

   private ContactMessageDao dao;

   @Override
    public void init() throws ServletException {
        dao = new ContactMessageDao();
   }

   @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
       try {
           List<ContactMessage> list = dao.getAll();

           //đếm message NEW
           int newCount = 0;
           for (ContactMessage contactMessage : list) {
               if ("NEW".equals(contactMessage.getStatus())) {
                   newCount++;
               }
           }

           req.setAttribute("activePage", "contact");
           req.setAttribute("contacts", list);
           req.setAttribute("newCount", newCount);

           req.getRequestDispatcher("/Assets/component/adminPage/contactMessage.jsp").forward(req, resp);

       }catch (SQLException e){
           throw new RuntimeException(e);
       }
   }
}
