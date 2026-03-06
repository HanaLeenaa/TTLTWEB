package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.utils.PasswordUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        HttpSession session = req.getSession();

        try {
            String otpInput = req.getParameter("otp");

            // 1️. Kiểm tra dữ liệu OTP
            if (otpInput == null || otpInput.trim().isEmpty()) {
                session.setAttribute("msg", "Vui lòng nhập mã OTP.");
                resp.sendRedirect(req.getContextPath() + "/Assets/component/login_logout/verify.jsp");
                return;
            }

            // 2. Lấy user tạm, otpHash và thời hạn OTP từ session
            User tempUser = (User) session.getAttribute("tempUser");
            String otpHash = (String) session.getAttribute("otpHash");
            LocalDateTime otpExpiry = (LocalDateTime) session.getAttribute("otpExpiry");

            if (tempUser == null || otpHash == null || otpExpiry == null) {
                session.setAttribute("msg", "Thông tin đăng ký không tồn tại hoặc đã hết hạn. Vui lòng đăng ký lại.");
                resp.sendRedirect(req.getContextPath() + "/Assets/component/login_logout/register.jsp");
                return;
            }

            // 3️. Kiểm tra OTP hết hạn
            if (otpExpiry.isBefore(LocalDateTime.now())) {
                session.removeAttribute("tempUser");
                session.removeAttribute("otpHash");
                session.removeAttribute("otpExpiry");
                session.setAttribute("msg", "OTP đã hết hạn. Vui lòng đăng ký lại.");
                resp.sendRedirect(req.getContextPath() + "/Assets/component/login_logout/register.jsp");
                return;
            }

            // 4️. Kiểm tra OTP đúng
            boolean match = PasswordUtil.verify(otpInput.trim(), otpHash);

            if (!match) {
                session.setAttribute("msg", "OTP không đúng. Vui lòng thử lại.");
                resp.sendRedirect(req.getContextPath() + "/Assets/component/login_logout/verify.jsp");
                return;
            }

            // 5. OTP đúng ->lưu user vào DB
            int userId = userDao.insert(tempUser); // User chưa được lưu trước đó
            userDao.activate(userId); // Kích hoạt ngay

            // 6️. Xóa dữ liệu tạm khỏi session
            session.removeAttribute("tempUser");
            session.removeAttribute("otpHash");
            session.removeAttribute("otpExpiry");

            // 7️. Thông báo thành công
            session.setAttribute("msg", "Xác thực thành công! Mời bạn đăng nhập.");
            resp.sendRedirect(req.getContextPath() + "/Assets/component/login_logout/login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Lỗi hệ thống: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/Assets/component/login_logout/register.jsp");

        }
    }
}
