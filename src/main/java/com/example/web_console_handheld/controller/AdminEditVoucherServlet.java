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

@WebServlet("/admin/vouchers/edit")
public class AdminEditVoucherServlet extends HttpServlet {
    private VoucherDao  voucherDao = new VoucherDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id =  Integer.parseInt(request.getParameter("id"));

        Voucher voucher = voucherDao.getVoucherById(id);

        request.setAttribute("voucher",voucher);

        request.getRequestDispatcher("/Assets/component/adminPage/editVoucher.jsp").forward(request,response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Voucher voucher = new Voucher();

            voucher.setID(Integer.parseInt(request.getParameter("id")));
            voucher.setCode(request.getParameter("code"));
            voucher.setName(request.getParameter("name"));
            voucher.setDiscount_type(request.getParameter("discountType"));

            BigDecimal discountValue = new BigDecimal(request.getParameter("discountValue"));

            BigDecimal minOrder = new BigDecimal(request.getParameter("minOrder"));

            int quantity = (Integer.parseInt(request.getParameter("quantity")));

            Timestamp startDate = Timestamp.valueOf(request.getParameter("startDate").replace("T", " ") + ":00");

            Timestamp endDate = Timestamp.valueOf(request.getParameter("endDate").replace("T", " ") + ":00");

            voucher.setDiscount_value(discountValue);
            voucher.setMin_order_amount(minOrder);
            voucher.setQuantity(quantity);
            voucher.setStart_date(startDate);
            voucher.setEnd_date(endDate);
            voucher.setActive(Boolean.parseBoolean(request.getParameter("active")));

            //số lượng phải lớn hơn 0
            if (quantity <= 0) {
                request.setAttribute("voucher", voucher);
                request.setAttribute("error", "Số lượng phải lớn hơn 0");

                request.getRequestDispatcher("/Assets/component/adminPage/editVoucher.jsp").forward(request, response);
                return;
            }

            // Ngày kết thúc phải sau ngày bắt đầu
            if (!endDate.after(startDate)) {
                request.setAttribute("voucher", voucher);
                request.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu");

                request.getRequestDispatcher("/Assets/component/adminPage/editVoucher.jsp").forward(request, response);
                return;
            }

            // Giá trị giảm > 0
            if (discountValue.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("voucher", voucher);
                request.setAttribute("error", "Giá trị giảm phải lớn hơn 0");

                request.getRequestDispatcher("/Assets/component/adminPage/editVoucher.jsp").forward(request, response);
                return;
            }

            // Đơn tối thiểu >= 0
            if (minOrder.compareTo(BigDecimal.ZERO) < 0) {
                request.setAttribute("voucher", voucher);
                request.setAttribute("error", "Đơn tối thiểu không hợp lệ");

                request.getRequestDispatcher("/Assets/component/adminPage/editVoucher.jsp").forward(request, response);
                return;
            }

            // Nếu giảm %
            if ("PERCENT".equals(voucher.getDiscount_type())) {

                    if (discountValue.compareTo(BigDecimal.valueOf(100)) > 0) {

                        request.setAttribute("voucher", voucher);
                        request.setAttribute("error", "Giảm phần trăm không được vượt quá 100%");

                        request.getRequestDispatcher("/Assets/component/adminPage/editVoucher.jsp").forward(request, response);
                        return;
                    }

                String maxDiscount = request.getParameter("maxDiscount");

                if (maxDiscount != null && !maxDiscount.isBlank()) {

                    BigDecimal max = new BigDecimal(maxDiscount);

                    voucher.setMax_discount(max);

                    if (max.compareTo(BigDecimal.ZERO) <= 0) {

                        request.setAttribute("voucher", voucher);
                        request.setAttribute("error", "Giảm tối đa phải lớn hơn 0");

                        request.getRequestDispatcher("/Assets/component/adminPage/editVoucher.jsp").forward(request, response);
                        return;
                    }
                }
            } else {
                    voucher.setMax_discount(null);
                }


            boolean success = voucherDao.updateVoucher(voucher);
            if (success) {
                response.sendRedirect(request.getContextPath()+"/admin/vouchers?success=updated");
            } else  {
                response.sendRedirect(request.getContextPath()+ "/admin/vouchers?error=updateFail");
            }
        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(request.getContextPath()+"/admin/vouchers?error=updateFail");
        }
    }
}
