package com.example.web_console_handheld.service;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

public class EmailService {

    private static final String FROM_EMAIL = "23130029@st.hcmuaf.edu.vn"; // email thật
    private static final String PASSWORD = "iadx drdc cixi waoa";      // mật khẩu ứng dụng Gmail

    public static void sendOtp(String toEmail, String otp) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Web Console HandHeld"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP đăng nhập");
            message.setText("Mã OTP của bạn là: " + otp + "\nMã có hiệu lực trong 1 phút.");

            Transport.send(message);

        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            throw new MessagingException("Email encoding error", e);
        }
    }

    public static void sendResetPasswordEmail(String toEmail, String resetLink) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com"); // tránh lỗi SSL

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(FROM_EMAIL, "Web Console HandHeld"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Yêu cầu đặt lại mật khẩu");

            String content = """
            <div style="font-family: Arial;">
                <h2>Đặt lại mật khẩu</h2>
                <p>Nhấn vào nút bên dưới:</p>
                <a href="%s" 
                   style="padding:10px 20px;
                          background:#ff6600;
                          color:white;
                          text-decoration:none;">
                    Đổi mật khẩu
                </a>
                <p>Link hết hạn sau 15 phút.</p>
            </div>""".formatted(resetLink);
            message.setContent(content, "text/html; charset=UTF-8");
            Transport.send(message);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Gửi email thất bại", e);
        }
    }
}
