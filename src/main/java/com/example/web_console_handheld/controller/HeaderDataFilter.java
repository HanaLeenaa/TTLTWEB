package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ContactMessageDao;
import com.example.web_console_handheld.dao.InforDao;
import com.example.web_console_handheld.dao.LogoDao;
import com.example.web_console_handheld.model.ContactMessage;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class HeaderDataFilter implements Filter {

    private InforDao inforDao;
    private LogoDao logoDao;

    @Override
    public void init(FilterConfig filterConfig) {
        inforDao = new InforDao();
        logoDao = new LogoDao();
    }



    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpSession session = request.getSession();

        servletRequest.setAttribute("contactNumber", inforDao.getContact(1));
        servletRequest.setAttribute("logo", logoDao.getLogo(1));

        // THÊM PHẦN NOTIFICATION
        if (session != null && session.getAttribute("auth") != null) {

            User user = (User) session.getAttribute("auth");

            try {
                ContactMessageDao dao = new ContactMessageDao(DBConnection.getConnection());

                List<ContactMessage> list = dao.getRepliedByUser(user.getId());

                int unreadCount = dao.countUnread(user.getId());

                request.setAttribute("notifications", list);
                request.setAttribute("notifyCount", unreadCount);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        filterChain.doFilter(servletRequest, servletResponse);
    }
}
