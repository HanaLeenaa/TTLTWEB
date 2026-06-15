package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.VoucherDao;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.model.Voucher;
import com.example.web_console_handheld.service.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/voucher-list")
public class VoucherListServlet extends HttpServlet {
    private VoucherDao voucherDao= new VoucherDao();
    private VoucherService voucherService = new VoucherService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("auth");

        Long totalAmount = (Long) session.getAttribute("checkoutTotal");

        if (totalAmount == null) {
            totalAmount = 0L;
        }

        List<Voucher> vouchers =
                voucherDao.getAvailableVouchers(
                        user.getId(),
                        totalAmount
                );

        vouchers = voucherService.sortBestVoucher(vouchers, totalAmount);

        //lấy voucher được chọn từ session
        Integer selectedVoucherId = (Integer) session.getAttribute("selectedVoucherId");
        Voucher selectedVoucher = null;

        if (selectedVoucherId != null) {
            for (Voucher v : vouchers) {
                if (v.getID() == selectedVoucherId) {
                    selectedVoucher = v;
                    break;
                }
            }
        }
        //lấy voucher tốt nhất
        Voucher bestVoucher = null;
        if (!vouchers.isEmpty()) {
            bestVoucher = vouchers.get(0);
        }

        request.setAttribute("vouchers", vouchers);
        request.setAttribute("bestVoucher", bestVoucher);
        request.setAttribute("selectedVoucher", selectedVoucher);

        request.getRequestDispatcher(
                "/Assets/component/cart_payment/voucher.jsp"
        ).forward(request, response);
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();

        String voucherId =
                request.getParameter("voucherId");

        session.setAttribute("selectedVoucherId", Integer.parseInt(request.getParameter("voucherId")));

        response.sendRedirect(
                request.getContextPath() + "/payment"
        );

}
}
