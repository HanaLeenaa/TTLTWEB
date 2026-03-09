package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.AboutDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/about")
public class AboutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        AboutDao dao = new AboutDao();

        request.setAttribute("infos", dao.getBySection("INFO"));
        request.setAttribute("services", dao.getBySection("SERVICE"));
        request.setAttribute("works", dao.getBySection("WHAT_WE_DO"));
        request.setAttribute("finalItems", dao.getBySection("FINAL"));
        request.setAttribute("infoImage", dao.getBySection("INFO_IMAGE").get(0));

        request.getRequestDispatcher("/about.jsp").forward(request, response);
    }
}
