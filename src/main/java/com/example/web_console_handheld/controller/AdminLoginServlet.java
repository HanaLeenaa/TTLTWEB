package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.AdminDao;
import com.example.web_console_handheld.model.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet({"/admin/login", "/admin-login"})
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            // Chưa đăng nhập -> hiện form admin login
            request.getRequestDispatcher("/Assets/component/adminPage/adminLogin.jsp")
                    .forward(request, response);
        } else {
            // Đã đăng nhập -> vào dashboard
            response.sendRedirect("/Assets/component/adminPage/adminDashboard.jsp");
        }
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AdminDao dao = new AdminDao();
        Admin admin = dao.login(username, password);

        if (admin != null) {
            //login thành công
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);

            response.sendRedirect(request.getContextPath() +"/admin/dashboard");

        }else {
            request.setAttribute("ERROR", "Tên đăng nhập hoặc mật khẩu không đúng");
            request.getRequestDispatcher("/Assets/component/adminPage/adminLogin.jsp").forward(request, response);

        }



    }


}
