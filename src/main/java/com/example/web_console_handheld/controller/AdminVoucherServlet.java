package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.VoucherDao;
import com.example.web_console_handheld.model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/vouchers")
public class AdminVoucherServlet extends HttpServlet {
    private VoucherDao voucherDao = new VoucherDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Voucher> vouchers = voucherDao.getAllVouchers();

        request.setAttribute("activePage", "vouchers");
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher( "/Assets/component/adminPage/AdminVoucher.jsp").forward(request, response);
    }

}
