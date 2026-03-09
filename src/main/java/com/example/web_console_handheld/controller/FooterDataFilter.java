package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.IconDao;
import com.example.web_console_handheld.dao.InforDao;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;

import java.io.IOException;

@WebFilter("/*")
public class FooterDataFilter implements Filter {


    private InforDao inforDao;
    private IconDao iconDao;

    @Override
    public void init(FilterConfig filterConfig) {
        inforDao = new InforDao();
        iconDao = new IconDao();
    }



    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        servletRequest.setAttribute("infor", inforDao.getContact(1));
        servletRequest.setAttribute("icon", iconDao.getIcon());

        filterChain.doFilter(servletRequest, servletResponse);
    }
}
