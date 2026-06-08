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
        Voucher voucher = new Voucher();
        voucher.setActive(true);
        request.setAttribute("activePage", "vouchers");
        request.setAttribute("voucher", voucher);
        request.getRequestDispatcher( "/Assets/component/adminPage/addVoucher.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Voucher voucher = new Voucher();
        try {
            voucher.setCode(request.getParameter("code"));
            voucher.setName(request.getParameter("name"));
            voucher.setDiscount_type(request.getParameter("discountType"));

            BigDecimal discountValue = new BigDecimal(request.getParameter("discountValue"));
            BigDecimal minOrder = new BigDecimal(request.getParameter("minOrder"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            Timestamp startDate = Timestamp.valueOf(request.getParameter("startDate").replace("T", " ") + ":00");
            Timestamp endDate = Timestamp.valueOf(request.getParameter("endDate").replace("T", " ") + ":00");

            voucher.setDiscount_value(discountValue);
            voucher.setMin_order_amount(minOrder);
            voucher.setQuantity(quantity);
            voucher.setStart_date(startDate);
            voucher.setEnd_date(endDate);
            voucher.setActive(Boolean.parseBoolean(request.getParameter("active")));
            String maxDiscount = request.getParameter("maxDiscount");
            if (maxDiscount != null && !maxDiscount.isBlank()) {
                voucher.setMax_discount(new BigDecimal(maxDiscount));
            }

            //check trùng mã code
            if (voucherDao.existsByCode(voucher.getCode())) {
                request.setAttribute("voucher", voucher);
                request.setAttribute("error", "Mã voucher đã tồn tại");
                request.getRequestDispatcher("/Assets/component/adminPage/addVoucher.jsp").forward(request, response);
                return;
            }

            //validate số lượng > 0
            if (quantity <= 0) {
                request.setAttribute("voucher", voucher);
                request.setAttribute("error", "Số lượng phải lớn hơn 0");
                request.getRequestDispatcher("/Assets/component/adminPage/addVoucher.jsp").forward(request, response);
                return;
            }

            // ngày bắt đầu phải trước ngày kết thúc
            if (!endDate.after(startDate)) {
                request.setAttribute("voucher", voucher);
                request.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu");
                request.getRequestDispatcher("/Assets/component/adminPage/addVoucher.jsp").forward(request, response);
                return;
            }

            //giá trị giảm phải > 0
            if (discountValue.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("voucher", voucher);
                request.setAttribute("error", "Giá trị giảm phải lớn hơn 0");
                request.getRequestDispatcher("/Assets/component/adminPage/addVoucher.jsp").forward(request, response);
                return;
            }

            //đơn tối thiểu phải >= 0
            if (minOrder.compareTo(BigDecimal.ZERO) < 0) {
                request.setAttribute("voucher", voucher);
                request.setAttribute("error", "Đơn tối thiểu phải lớn hơn hoặc bằng 0");
                request.getRequestDispatcher("/Assets/component/adminPage/addVoucher.jsp").forward(request, response);
                return;
            }

            //giảm theo %
            if ("PERCENT".equals(voucher.getDiscount_type())) {

                if (discountValue.compareTo(BigDecimal.ZERO) <= 0 ||
                        discountValue.compareTo(BigDecimal.valueOf(100)) > 0) {
                    request.setAttribute("voucher", voucher);
                    request.setAttribute("error", "Giảm phần trăm phải từ 1 đến 100%");
                    request.getRequestDispatcher("/Assets/component/adminPage/addVoucher.jsp").forward(request, response);
                    return;
                }

                if (maxDiscount == null || maxDiscount.isBlank()) {
                    request.setAttribute("voucher", voucher);
                    request.setAttribute("error", "Vui lòng nhập giảm tối đa cho voucher phần trăm");
                    request.getRequestDispatcher("/Assets/component/adminPage/addVoucher.jsp").forward(request, response);
                    return;
                }

                if (voucher.getMax_discount() == null || voucher.getMax_discount().compareTo(BigDecimal.ZERO) <= 0) {
                    request.setAttribute("voucher", voucher);
                    request.setAttribute("error", "Giảm tối đa phải lớn hơn 0");
                    request.getRequestDispatcher("/Assets/component/adminPage/addVoucher.jsp").forward(request, response);
                    return;
                }

            } else {
                voucher.setMax_discount(null);
            }

            boolean success = voucherDao.insertVoucher(voucher);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/vouchers?success=add");

            } else {
                response.sendRedirect(request.getContextPath() + "/admin/vouchers?error=add");
            }
        }catch (Exception e){
            e.printStackTrace();
            request.setAttribute("voucher", voucher);
            request.setAttribute("error", "Dữ liệu nhập không hợp lệ");
            request.getRequestDispatcher("/Assets/component/adminPage/addVoucher.jsp").forward(request,response);
        }

    }
}
