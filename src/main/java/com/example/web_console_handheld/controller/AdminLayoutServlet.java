package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminLayoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String page = req.getParameter("page");

        if (page == null) {
            page = "dashboard";
        }

        switch (page) {
            case "products":
                req.setAttribute("contentPage",
                        "/Assets/component/adminPage/productManagement.jsp");
                break;

            default:
                req.setAttribute("contentPage",
                        "/Assets/component/adminPage/dashboard.jsp");
                break;
        }

        req.getRequestDispatcher("/Assets/component/adminPage/admin.jsp")
                .forward(req, resp);
    }
}

