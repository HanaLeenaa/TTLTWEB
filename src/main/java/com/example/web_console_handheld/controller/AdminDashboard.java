package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.DashboardStatisticsDao;
import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.model.StatisticsItem;
import com.example.web_console_handheld.model.TopProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboard extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductDao productDao = new ProductDao();
        OrderDao orderDao = new OrderDao();
        UserDao userDao = new UserDao();
        DashboardStatisticsDao statisticsDao = new DashboardStatisticsDao();

        List<Product> productList = productDao.getAll();
        int totalProducts = productList.size();
        List<Order> orderList = orderDao.getAllOrders();
        int totalOrders = orderList.size();
        int totalUsers = userDao.countAll();
        double totalRevenue = orderDao.getTotalRevenue();

        List<Order> recentOrders = orderDao.getRecentOrders(5);

        LocalDate now = LocalDate.now();

        int currentMonth = now.getMonthValue();
        int currentYear = now.getYear();
        //tính quý
        int currentQuarter = (currentMonth - 1) / 3 + 1;


        String type = request.getParameter("type");

        if (type == null) {
            type = "month";
        }

        List<StatisticsItem> statistics;
        List<TopProduct> topProducts;
        Map<String, Integer> orderStatusStats = statisticsDao.getOrderStatusStatistics();

        //doanh thu, top sản phẩm bán chạy theo tháng, quý, năm
        switch (type) {
            case "quarter":
                statistics = statisticsDao.getRevenueByQuarter(currentYear);

                topProducts = statisticsDao.getTopProductsByQuarter(currentQuarter, currentYear);

                break;

            case "year":
                statistics = statisticsDao.getRevenueByYear();

                topProducts = statisticsDao.getTopProductsByYear(currentYear);

                break;

            default:
                statistics = statisticsDao.getRevenueByMonth(currentYear);

                topProducts = statisticsDao.getTopProductsByMonth(currentMonth, currentYear);
        }

        request.setAttribute("statistics", statistics);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("orderStatusStats", orderStatusStats);

        request.setAttribute("type", type);

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("activePage", "dashboard");
        request.getRequestDispatcher("/Assets/component/adminPage/adminDashboard.jsp").forward(request, response);
    }
}
