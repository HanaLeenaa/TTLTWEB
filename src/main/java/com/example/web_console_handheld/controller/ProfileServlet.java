package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.*;
import com.example.web_console_handheld.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import java.util.regex.Pattern;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();
    private ReviewDao reviewDao = new ReviewDao();

    private static final Pattern GMAIL_PATTERN =
            Pattern.compile("^[a-zA-Z0-9._%+-]+@gmail\\.com$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^0\\d{9}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 10;

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }

        int offset = (page - 1) * pageSize;

        User authUser = (User) request.getSession().getAttribute("auth");
        if (authUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDao userDao = new UserDao();
        User user = userDao.getUserById(authUser.getId());

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getSession().setAttribute("auth", user);

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "orders";
        }

        List<Order> orders = Collections.emptyList();
        List<Review> reviews = new ArrayList<>();

        if ("orders".equals(tab)) {
            orders = orderDao.getOrdersByUserId(user.getId());
        }

        if ("reviews".equals(tab)) {

            reviews = reviewDao.getReviewsByUserIdPaging(
                    user.getId(),
                    offset,
                    pageSize
            );

            int totalReviews = reviewDao.countReviewsByUserId(user.getId());
            int totalPages = (int) Math.ceil((double) totalReviews / pageSize);

            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
        }

        request.setAttribute("orders", orders);
        request.setAttribute("reviews", reviews);
        request.setAttribute("user", user);
        request.setAttribute("tab", tab);

        request.getRequestDispatcher(
                "/Assets/component/login_logout/profile.jsp"
        ).forward(request, response);
    }
}
