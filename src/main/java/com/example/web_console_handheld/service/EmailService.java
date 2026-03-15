package com.example.web_console_handheld.service;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailService {

    private static final String SMTP_HOST = "sandbox.smtp.mailtrap.io";
    private static final int SMTP_PORT = 2525;
    private static final String SMTP_USER = "c66c7eda2b47ed";
    private static final String SMTP_PASS = "7718002bc97683";

    private static Session getMailSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });
    }

    // Gửi mã OTP (dùng cho đăng ký và gửi lại OTP)
    public static void sendOtp(String toEmail, String otp) throws MessagingException {

        Message message = new MimeMessage(getMailSession());
        message.setFrom(new InternetAddress("no-reply@webconsole.com"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Mã xác thực OTP");

        message.setText(buildOtpContent(otp));

        Transport.send(message);
    }

   //Nội dung email OTP
    private static String buildOtpContent(String otp) {
        return "Xin chào,\n\n"
                + "Mã OTP của bạn là: " + otp + "\n"
                + "Mã có hiệu lực trong 60 giây.\n\n"
                + "Vui lòng không chia sẻ mã này cho bất kỳ ai.\n\n"
                + "Trân trọng!";
    }

    // Gửi email đổi mật khẩu
    public static void sendResetPasswordEmail(String toEmail, String link) {
        try {
            Message message = new MimeMessage(getMailSession());
            message.setFrom(new InternetAddress("no-reply@webconsole.com"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Đổi mật khẩu");

            String htmlContent = "<p>Xin chào,</p>"
                    + "<p>Click vào link dưới đây để đổi mật khẩu:</p>"
                    + "<a href='" + link + "'>" + link + "</a>"
                    + "<p>Link có hiệu lực trong 15 phút.</p>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            Transport.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
