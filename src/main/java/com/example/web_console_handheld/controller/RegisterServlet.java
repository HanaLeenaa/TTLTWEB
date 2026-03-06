package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.utils.ValidationUtil;
import com.example.web_console_handheld.utils.PasswordUtil;
import com.example.web_console_handheld.utils.OtpUtil;
import com.example.web_console_handheld.service.EmailService;
import com.example.web_console_handheld.dao.UserDao;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/Assets/component/login_logout/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        HttpSession session = req.getSession();

        try {
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String phoneNum = req.getParameter("phoneNum");
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirm_password");

            // 1. kiểm tra rỗng
            if (isEmpty(username) || isEmpty(email) || isEmpty(password) || isEmpty(confirmPassword)) {
                setMsg(session, "Vui lòng điền đầy đủ thông tin bắt buộc.");
                redirectRegister(req, resp);
                return;
            }

            //2. xác nhận mật khẩu
            if (!password.equals(confirmPassword)) {
                setMsg(session, "Mật khẩu nhập lại không khớp.");
                redirectRegister(req, resp);
                return;
            }

            // 3. validate format
            if (!ValidationUtil.isValidUsername(username)) {
                setMsg(session, "Tên đăng nhập không được chứa ký tự đặc biệt.");
                redirectRegister(req, resp);
                return;
            }

            if (!ValidationUtil.isValidEmail(email)) {
                setMsg(session, "Vui lòng kiểm tra lại email của bạn.");
                redirectRegister(req, resp);
                return;
            }

            if (!ValidationUtil.isValidPassword(password)) {
                setMsg(session,
                        "Mật khẩu phải bao gồm ít nhất 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt.");
                redirectRegister(req, resp);
                return;
            }

            //4. kiểm tra trùng db
            UserDao userDao = new UserDao();

            if (userDao.existsUsername(username)) {
                setMsg(session, "Tên đăng nhập đã tồn tại.");
                redirectRegister(req, resp);
                return;
            }

            if (userDao.existsEmail(email)) {
                setMsg(session, "Email đã được sử dụng.");
                redirectRegister(req, resp);
                return;
            }

            if (!isEmpty(phoneNum) && userDao.existsPhoneNum(phoneNum)) {
                setMsg(session, "Số điện thoại này đã được đăng ký.");
                redirectRegister(req, resp);
                return;
            }

            // 5. tạo user tạm
            User tempUser = new User();
            tempUser.setUsername(username.trim());
            tempUser.setEmail(email.trim());
            tempUser.setPhoneNum(phoneNum);
            tempUser.setPassword(PasswordUtil.hash(password));

            session.setAttribute("tempUser", tempUser);

            //6. mã otp
            String rawOtp = OtpUtil.generateOtp();
            String otpHash = PasswordUtil.hash(rawOtp);
            LocalDateTime expiry = LocalDateTime.now().plusSeconds(60);

            session.setAttribute("otpHash", otpHash);
            session.setAttribute("otpExpiry", expiry);

            // 7. gửi mail
            EmailService.sendOtp(email, rawOtp);

            setMsg(session, "Đăng ký thành công! Vui lòng kiểm tra email để nhập mã OTP.");
            resp.sendRedirect(req.getContextPath() + "/Assets/component/login_logout/verify.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            setMsg(session, "Lỗi hệ thống, vui lòng thử lại sau.");
            redirectRegister(req, resp);
        }
    }

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    private void setMsg(HttpSession session, String msg) {
        session.setAttribute("msg", msg);
    }

    private void redirectRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/Assets/component/login_logout/register.jsp");
    }
}
