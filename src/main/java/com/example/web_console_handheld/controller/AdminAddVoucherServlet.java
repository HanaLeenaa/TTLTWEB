package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.VoucherDao;
import com.example.web_console_handheld.model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;

@WebServlet("/admin/vouchers/add")
public class AdminAddVoucherServlet extends HttpServlet {
    private VoucherDao  voucherDao = new VoucherDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("activePage", "vouchers");

        request.getRequestDispatcher( "/Assets/component/adminPage/addVoucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Voucher voucher = new Voucher();

            voucher.setCode(request.getParameter("code"));
            voucher.setName(request.getParameter("name"));
            voucher.setDiscount_type(request.getParameter("discountType"));
            voucher.setDiscount_value(new BigDecimal(request.getParameter("discountValue")));
            voucher.setMin_order_amount(new BigDecimal(request.getParameter("minOrder")));


            String discountType = request.getParameter("discountType");
            if ("PERCENT".equals(discountType)) {
                String maxDiscount = request.getParameter("maxDiscount");

                if (maxDiscount != null && !maxDiscount.isBlank()) {
                    voucher.setMax_discount(new BigDecimal(maxDiscount));

                }
            } else {
                    voucher.setMax_discount(null);
                }
            voucher.setQuantity(Integer.parseInt(request.getParameter("quantity")));
            voucher.setStart_date(Timestamp.valueOf(request.getParameter("startDate").replace("T", " ") + ":00"));
            voucher.setEnd_date(Timestamp.valueOf(request.getParameter("endDate").replace("T"," ") + ":00"));

            if(voucher.getEnd_date().compareTo(voucher.getStart_date()) <= 0){
                response.sendRedirect(request.getContextPath() + "/admin/vouchers/add?error=date");
                return;
            }

            voucher.setActive(Boolean.parseBoolean(request.getParameter("active")));


            boolean success = voucherDao.insertVoucher(voucher);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/vouchers?success=add");

            } else {
                response.sendRedirect(request.getContextPath() + "/admin/vouchers?error=add");
            }
        }catch (Exception e){
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/vouchers?error=add");
        }

    }
}
