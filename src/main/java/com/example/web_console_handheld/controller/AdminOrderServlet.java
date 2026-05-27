package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        OrderDao dao = new OrderDao();

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");

        if ((keyword != null && !keyword.isEmpty()) ||
                (status != null && !status.isEmpty()) ||
                (fromDate != null && !fromDate.isEmpty()) ||
                (toDate != null && !toDate.isEmpty()) ||
                (minPrice != null && !minPrice.isEmpty()) ||
                (maxPrice != null && !maxPrice.isEmpty())) {

            request.setAttribute("orders",
                    dao.searchOrders(keyword, status, fromDate, toDate, minPrice, maxPrice));

        } else {
            // danh sách đơn
            request.setAttribute("orders", dao.getAllOrders());
        }
            // nếu có chọn đơn
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                int id = Integer.parseInt(idRaw);
                request.setAttribute("selectedOrder", dao.getOrderById(id));
                request.setAttribute("orderItems", dao.getOrderItemsByOrderId(id));
            }

            request.setAttribute("activePage", "orders");
            request.getRequestDispatcher("/Assets/component/adminPage/ordersManagement.jsp").forward(request, response);

        }
    }

