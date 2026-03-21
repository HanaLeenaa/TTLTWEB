package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.OrderItem;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/order-history-detail")
public class OrderHistoryDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("auth") == null){
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String idRaw = request.getParameter("id");
        if (idRaw == null || idRaw.trim().isEmpty()){
            response.sendRedirect(request.getContextPath() + "/profile?tab=orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idRaw);
            User user = (User)session.getAttribute("auth");
            int userId = user.getId();

            OrderDao dao = new OrderDao();
            Order order = dao.getOrderById(orderId);
            List<OrderItem> orderItems = dao.getOrderItemsByOrderId(orderId);

            if (order == null){
                response.sendRedirect(request.getContextPath() + "/profile?tab=orders");
                return;
            }

            // kiem tra don hang co thuoc user dang login khong
            if (order.getUser_Id() != userId){
                response.sendRedirect(request.getContextPath() + "/profile?tab=orders");
                return;
            }
            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);

            request.getRequestDispatcher("/Assets/component/cart_payment/orderHistoryDetail.jsp").forward(request, response);
        }catch (NumberFormatException e){
            response.sendRedirect(request.getContextPath() + "/profile?tab=orders");
        }catch (Exception e){
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/profile?tab=orders");
        }
    }
}
