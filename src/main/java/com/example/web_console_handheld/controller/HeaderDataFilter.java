package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.InforDao;
import com.example.web_console_handheld.dao.LogoDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;

import java.io.IOException;

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
        servletRequest.setAttribute("contactNumber", inforDao.getContact(1));
        servletRequest.setAttribute("logo", logoDao.getLogo(1));

        filterChain.doFilter(servletRequest, servletResponse);
    }
}
