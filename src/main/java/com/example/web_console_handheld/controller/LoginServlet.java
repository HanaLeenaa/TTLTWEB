package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/Assets/component/login_logout/login.jsp").forward(request,response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AuthService as = new AuthService();
        User user = as.checkLogin(username,password);
        if(user != null){
            HttpSession session = request.getSession();
            session.setAttribute("auth", user);
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Bạn nhập sai tên hoặc mật khẩu");
            request.getRequestDispatcher("/Assets/component/login_logout/login.jsp").forward(request, response);
        }
    }
}