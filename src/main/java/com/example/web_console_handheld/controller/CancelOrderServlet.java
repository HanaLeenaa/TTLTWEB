package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cancel-order")
public class CancelOrderServlet extends HttpServlet {
    private OrderDao orderDao = new OrderDao();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("auth");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = orderDao.getOrderById(orderId);

        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/order-history-detail" );
            return;
        }

        boolean result = false;

        switch (order.getStatus()) {
            case "Chờ xác nhận":
            case "Đã xác nhận":
                result = orderDao.cancelOrder(orderId);

                if (result) {
                    if ("VNPAY".equalsIgnoreCase(order.getPayment_method())) {
                        session.setAttribute("success", "Đơn hàng đã được hủy. Tiền của bạn đã được hoàn lại.");

                    }else {
                        session.setAttribute("success", "Đơn hàng đã được hủy thành công!");
                    }
                }
                break;

            case "Đang giao":
                result = orderDao.requestCancelOrder(orderId);
                if (result) {
                    session.setAttribute("success", "Yêu cầu hủy đã được gửi. Vui lòng chờ admin duyệt.");

                }
                break;
        }
        response.sendRedirect(request.getContextPath() + "/order-history-detail?id=" + orderId);
    }
}
