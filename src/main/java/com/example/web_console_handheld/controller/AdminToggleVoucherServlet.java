package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.VoucherDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/vouchers/toggle")
public class AdminToggleVoucherServlet extends HttpServlet {
    private VoucherDao voucherDao = new VoucherDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {

            int id = Integer.parseInt(request.getParameter("id"));

            boolean success = voucherDao.toggleVoucherStatus(id);

            if(success){
                response.sendRedirect(request.getContextPath() + "/admin/vouchers?success=toggle");
            }else{
                response.sendRedirect(request.getContextPath() + "/admin/vouchers?error=status");
            }

        } catch (Exception e) {

            response.sendRedirect(request.getContextPath() + "/admin/vouchers?error=invalid");
        }
    }
}
