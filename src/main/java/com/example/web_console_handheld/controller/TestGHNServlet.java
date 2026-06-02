package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.service.GHNService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/test-ghn")
public class TestGHNServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {

        res.setContentType("text/plain;charset=UTF-8");

        try {
            GHNService ghn = new GHNService();
            int fee = ghn.calculateFee(1454, 1452, 1000);
            res.getWriter().println("GHN FEE = " + fee);

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}