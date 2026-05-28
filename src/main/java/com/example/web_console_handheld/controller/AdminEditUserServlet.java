package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/edit-user")
public class AdminEditUserServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            User user = userDao.getUserById(id);
            if (user != null) {
                request.setAttribute("u", user);
                request.getRequestDispatcher("/Assets/component/adminPage/editUser.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(req.getParameter("id"));
        String username = req.getParameter("username");
        String role = req.getParameter("role");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        boolean active = req.getParameter("active") != null;

        if (userDao.updateUserByAdmin(id, username, role, phone, address, active)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?msg=updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/edit-user?id=" + id + "&error=1");
        }
    }
}

