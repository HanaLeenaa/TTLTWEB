package com.example.web_console_handheld.controller;


import com.example.web_console_handheld.dao.ContactMessageDao;
import com.example.web_console_handheld.model.ContactMessage;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.util.List;

@WebFilter("/admin/*")
public class AdminSidebarFilter implements Filter {

        private ContactMessageDao dao;

        @Override
        public void init(FilterConfig filterConfig) {
            dao = new ContactMessageDao();
        }

        @Override
        public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
                throws IOException, ServletException {

            HttpServletRequest req = (HttpServletRequest) request;
            jakarta.servlet.http.HttpSession session = req.getSession(false);

            // Lấy thông tin admin từ session ra để check quyền
            com.example.web_console_handheld.model.Admin admin =
                    (session != null) ? (com.example.web_console_handheld.model.Admin) session.getAttribute("admin") : null;

            int newCount = 0;

            if (admin != null && (admin.getRole() == 1 || "1".equals(String.valueOf(admin.getRole())))) {
                try {
                    List<ContactMessage> list = dao.getAll();
                    for (ContactMessage c : list) {
                        if ("NEW".equals(c.getStatus())) {
                            newCount++;
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            req.setAttribute("newCount", newCount);

            chain.doFilter(request, response);
        }
    }

