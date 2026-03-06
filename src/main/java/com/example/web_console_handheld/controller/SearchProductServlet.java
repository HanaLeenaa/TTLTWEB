package com.example.web_console_handheld.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/search")
public class SearchProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String keyword = req.getParameter("q");
        if (keyword == null) keyword = "";

        resp.sendRedirect(
                req.getContextPath()
                        + "/product?q="
                        + URLEncoder.encode(keyword, "UTF-8")
        );
    }
}

