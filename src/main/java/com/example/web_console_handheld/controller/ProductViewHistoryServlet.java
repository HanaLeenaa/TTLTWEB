package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductViewHistoryDao;
import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/recent-views")
public class ProductViewHistoryServlet extends HttpServlet {
    private ProductViewHistoryDao historyDao = new ProductViewHistoryDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession().getAttribute("auth");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        int userId = user.getId();

        String action = req.getParameter("action");
        if ("deleteOne".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            // dùng hàm deleteByUserAndProduct để xóa đúng theo user + product
            historyDao.deleteByUserAndProduct(userId, productId);
        } else if ("clearAll".equals(action)) {
            historyDao.deleteAllByUser(userId);
        }

        resp.sendRedirect("home"); // quay lại trang chủ
    }
}
