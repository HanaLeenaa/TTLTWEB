package com.example.web_console_handheld.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/order-success")
public class OrderSuccessServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy orderId từ URL truyền sang (nếu muốn hiển thị mã đơn hàng)
        String orderId = request.getParameter("id");
        request.setAttribute("orderId", orderId);

        // Chuyển hướng sang file JSP nằm trong thư mục giao diện của bạn
        // Hãy điều chỉnh lại đường dẫn file JSP này cho đúng với cấu trúc thư mục của bạn nhé
        request.getRequestDispatcher("/Assets/component/cart_payment/order-success.jsp").forward(request, response);

    }
}
