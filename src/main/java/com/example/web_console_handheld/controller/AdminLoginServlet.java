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
            request.getRequestDispatcher("/Assets/component/adminPage/adminLogin.jsp")
                    .forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AdminDao dao = new AdminDao();
        Admin admin = dao.login(username, password);

        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            // 🌟 ĐÃ CHỈNH SỬA TẠI ĐÂY: Tự sinh chuỗi băm "chính chủ" của chữ staff trên máy bạn
            String chuoiBamCuaStaff = org.mindrot.jbcrypt.BCrypt.hashpw("staff", org.mindrot.jbcrypt.BCrypt.gensalt());

            // Ép sinh đoạn mã JavaScript để khi trang load lại, nó tự in thẳng vào DevTools (F12)
            String scriptInDevTools = "<script>"
                    + "console.error('--- LOG TỰ SINH CHUỖI BĂM CHÍNH CHỦ ---');"
                    + "console.log('Chuoi bam XIN cua chu [staff] tren may ban la:');"
                    + "console.warn('" + chuoiBamCuaStaff + "');"
                    + "</script>";

            // Đẩy cả thông báo lỗi và đoạn script in DevTools về file JSP
            request.setAttribute("ERROR", "Tên đăng nhập hoặc mật khẩu không đúng");
            request.setAttribute("DEVTOOLS_LOG", scriptInDevTools);

            request.getRequestDispatcher("/Assets/component/adminPage/adminLogin.jsp")
                    .forward(request, response);
        }
    }
}