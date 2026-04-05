package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.net.*;
import java.util.Map;

@WebServlet("/google-login")
public class GoogleLoginServlet extends HttpServlet {

    // Thông tin OAuth lấy từ Google Cloud Console
    private static final String CLIENT_ID = "apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "your_secret";
    private static final String REDIRECT_URI = "http://localhost:8080/Web_Console_HandHeld_war_exploded/google-login";
    private static final String SCOPE = "email profile openid";

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();

        // Google sẽ trả về sau khi user đăng nhập thành công
        String code = req.getParameter("code");

        // Redirect sang Google để login
        if (code == null) {
            String authUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                    + "?client_id=" + CLIENT_ID
                    + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                    + "&response_type=code"
                    + "&scope=" + URLEncoder.encode(SCOPE, "UTF-8")
                    + "&prompt=login"; // bắt buộc Google yêu cầu nhập lại mật khẩu

            resp.sendRedirect(authUrl);
            return;
        }
        try {
            //lấy access_token
            URL url = new URL("https://oauth2.googleapis.com/token");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            // Gửi dữ liệu để đổi code lấy token
            String params = "code=" + URLEncoder.encode(code, "UTF-8")
                    + "&client_id=" + CLIENT_ID
                    + "&client_secret=" + CLIENT_SECRET
                    + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                    + "&grant_type=authorization_code";

            OutputStream os = conn.getOutputStream();
            os.write(params.getBytes());
            os.flush();

            // Nếu Google trả lỗi -> quay về login
            if (conn.getResponseCode() != 200) {
                session.setAttribute("loginMessage", "Lỗi lấy access token");
                resp.sendRedirect("login.jsp");
                return;
            }

            //Đọc dữ liệu trả về
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder tokenRes = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) tokenRes.append(line);

            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> tokenMap = mapper.readValue(tokenRes.toString(), Map.class);

            // Lấy access_token
            String accessToken = (String) tokenMap.get("access_token");

            //Lấy thông tin user từ Google
            URL userUrl = new URL("https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken);

            BufferedReader userBr = new BufferedReader(new InputStreamReader(userUrl.openStream()));
            StringBuilder userRes = new StringBuilder();
            while ((line = userBr.readLine()) != null) userRes.append(line);

            // Parse thông tin user
            Map<String, Object> userInfo = mapper.readValue(userRes.toString(), Map.class);

            String email = (String) userInfo.get("email");
            String name = (String) userInfo.get("name");

            // Debug log
            System.out.println("GOOGLE EMAIL: " + email);
            System.out.println("GOOGLE NAME: " + name);

            //Kiểm tra user trong DB
            User user = userDao.getUserByEmail(email);

            // Nếu chưa có -> tạo mới user Google
            if (user == null) {
                System.out.println("User chưa tồn tại → tạo mới");
                userDao.insertGoogleUser(email, name);
                user = userDao.getUserByEmail(email);
            }

            // Nếu vẫn null -> kiểm lỗi DB
            if (user == null) {
                session.setAttribute("loginMessage", "Không tạo được user");
                resp.sendRedirect("login.jsp");
                return;
            }

            //Kiểm tra tài khoản có bị khóa không
            if (!user.isActive()){
                req.setAttribute("error",
                        "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên của website!");
                req.getRequestDispatcher("/Assets/component/login_logout/login.jsp").forward(req, resp);
                return;
            }
            //Đăng nhập (lưu session)
            session.setAttribute("auth", user);

            System.out.println("LOGIN SUCCESS: " + user.getEmail());

            // Chuyển về trang chủ
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        } catch (Exception e) {
            e.printStackTrace();

            // Nếu có lỗi -> quay lại login
            session.setAttribute("loginMessage", "Google login error: " + e.getMessage());
            resp.sendRedirect( "/login");
        }
    }
}