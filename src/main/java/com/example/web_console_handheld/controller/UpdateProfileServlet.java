package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");

        // Lấy session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("auth") == null) {
            System.err.println("Session null hoặc user chưa đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("auth");
        System.out.println("[DEBUG] User trước update: ID=" + user.getId() + ", email=" + user.getEmail()
                + ", phone=" + user.getPhoneNum() + ", location=" + user.getLocation());

        // Lấy dữ liệu từ form
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNum");
        String location = request.getParameter("location");
        String username = request.getParameter("username");

        System.out.println("Dữ liệu form nhận được: email=" + email + ", phone=" + phone + ", location=" + location);

        if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                location == null || location.trim().isEmpty()) {

            response.sendRedirect(request.getContextPath() + "/profile?tab=edit&error=1");
            return;
        }

        // Cập nhật thông tin user
        user.setUsername(username.trim());
        user.setEmail(email.trim());
        user.setPhoneNum(phone.trim());
        user.setLocation(location.trim());

        // Gọi DAO để update DB
        UserDao userDao = new UserDao();
        boolean updated = userDao.updateProfile(user);

        if (updated) {
            // Update session
            session.setAttribute("auth", user);
            System.out.println("Cập nhật user ID=" + user.getId() + " thành công và session đã cập nhật.");
            response.sendRedirect(request.getContextPath() + "/profile?tab=edit&success=1");
        } else {
            System.err.println("Lỗi update user ID=" + user.getId());
            response.sendRedirect(request.getContextPath() + "/profile?tab=edit&error=1");
        }
    }
}
