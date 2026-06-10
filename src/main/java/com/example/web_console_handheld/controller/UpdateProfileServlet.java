package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.utils.ValidationUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("auth") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("auth");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNum");
        String location = request.getParameter("location");

        Map<String, String> errors = new HashMap<>();

        UserDao userDao = new UserDao();

        // VALIDATION
        if (!ValidationUtil.isValidName(username)) {
            errors.put("username", "Tên không hợp lệ (chỉ chứa chữ và khoảng trắng)");
        }

        if (!ValidationUtil.isValidEmail(email)) {
            errors.put("email", "Email không đúng định dạng");
        }

        if (!ValidationUtil.isValidPhone(phone)) {
            errors.put("phone", "Số điện thoại không hợp lệ (10 số, bắt đầu bằng 0)");
        }

        if (location == null || location.trim().isEmpty()) {
            errors.put("location", "Địa chỉ không được để trống");
        }

        // Kiểm tra trùng
        if (email != null && !email.equals(user.getEmail()) && userDao.existsEmail(email)) {
            errors.put("email", "Email đã tồn tại");
        }

        if (phone != null && !phone.equals(user.getPhoneNum()) && userDao.existsPhoneNum(phone)) {
            errors.put("phone", "Số điện thoại đã tồn tại");
        }

        if (username != null && !username.equals(user.getUsername()) && userDao.existsUsername(username)) {
            errors.put("username", "Tên người dùng đã tồn tại");
        }

        // lỗi
        if (!errors.isEmpty()) {
            session.setAttribute("profileErrors", errors);
            response.sendRedirect(request.getContextPath() + "/profile?tab=edit&error=1");
            return;
        }

        // Cập nhật
        user.setUsername(username.trim());
        user.setEmail(email.trim());
        user.setPhoneNum(phone.trim());
        user.setLocation(location.trim());

        boolean updated = userDao.updateProfile(user);

        if (updated) {
            session.setAttribute("auth", user);
            response.sendRedirect(request.getContextPath() + "/profile?tab=edit&success=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile?tab=edit&error=1");
        }
    }
}
