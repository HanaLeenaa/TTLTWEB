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
        resp.setContentType("text/html;charset=UTF-8");

        HttpSession session = req.getSession();

        try {
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String phoneNum = req.getParameter("phoneNum");
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirm_password");

            // trim dữ liệu
            if (username != null) username = username.trim();
            if (email != null) email = email.trim();
            if (phoneNum != null) phoneNum = phoneNum.trim();

            // kiểm tra rỗng
            if (isEmpty(username) || isEmpty(email) || isEmpty(password) || isEmpty(confirmPassword)) {
                setMsg(session, "Vui lòng điền đầy đủ thông tin bắt buộc.");
                redirectRegister(req, resp);
                return;
            }

            // xác nhận mật khẩu
            if (!ValidationUtil.isPasswordMatch(password, confirmPassword)) {
                setMsg(session, "Mật khẩu nhập lại không khớp.");
                redirectRegister(req, resp);
                return;
            }

            // validate tên
            if (!ValidationUtil.isValidName(username)) {
                setMsg(session, "Tên chỉ được chứa chữ cái và khoảng trắng.");
                redirectRegister(req, resp);
                return;
            }

            // validate email
            if (!ValidationUtil.isValidEmail(email)) {
                setMsg(session, "Email không hợp lệ.");
                redirectRegister(req, resp);
                return;
            }

            // validate phone
            if (!isEmpty(phoneNum) && !ValidationUtil.isValidPhone(phoneNum)) {
                setMsg(session, "Số điện thoại phải bắt đầu bằng 0, có 10 số và không được lặp số.");
                redirectRegister(req, resp);
                return;
            }

            //validate password
            if (!ValidationUtil.isValidPassword(password)) {
                setMsg(session, "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.");
                redirectRegister(req, resp);
                return;
            }

            // kiểm tra trùng database
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
                setMsg(session, "Số điện thoại đã được đăng ký.");
                redirectRegister(req, resp);
                return;
            }

            //tạo user tạm
            User tempUser = new User();

            tempUser.setUsername(username);
            tempUser.setEmail(email);
            tempUser.setPhoneNum(phoneNum);
            tempUser.setPassword(PasswordUtil.hash(password));

            session.setAttribute("tempUser", tempUser);

            // tạo OTP
            String rawOtp = OtpUtil.generateOtp();
            String otpHash = PasswordUtil.hash(rawOtp);
            LocalDateTime expiry = LocalDateTime.now().plusSeconds(60);

            session.setAttribute("otpHash", otpHash);
            session.setAttribute("otpExpiry", expiry);

            // gửi email OTP
            EmailService.sendOtp(email, rawOtp);

            setMsg(session, "Đăng ký thành công! Vui lòng kiểm tra email để nhập mã OTP.");
            resp.sendRedirect(req.getContextPath() + "/Assets/component/login_logout/verify.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            setMsg(session, "Lỗi hệ thống, vui lòng thử lại sau.");
            redirectRegister(req, resp);
        }
    }

    // hàm kiểm tra rỗng
    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    // set message
    private void setMsg(HttpSession session, String msg) {
        session.setAttribute("msg", msg);
    }

    // redirect register
    private void redirectRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/Assets/component/login_logout/register.jsp");
    }
}