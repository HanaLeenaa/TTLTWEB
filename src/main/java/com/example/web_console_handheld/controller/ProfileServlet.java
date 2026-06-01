//package com.example.web_console_handheld.controller;
//
//import com.example.web_console_handheld.dao.OrderDao;
//import com.example.web_console_handheld.dao.UserDao;
//import com.example.web_console_handheld.model.Order;
//import com.example.web_console_handheld.model.User;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import com.example.web_console_handheld.dao.ReviewDao;
//import com.example.web_console_handheld.model.Review;
//
//import java.io.IOException;
//import java.util.Collections;
//import java.util.List;
//import java.util.ArrayList;
//import java.util.regex.Pattern;
//
//@WebServlet("/profile")
//public class ProfileServlet extends HttpServlet {
//    private OrderDao dao = new OrderDao();
//
//    private static final Pattern GMAIL_PATTERN =
//            Pattern.compile("^[a-zA-Z0-9._%+-]+@gmail\\.com$");
//
//    private static final Pattern PHONE_PATTERN =
//            Pattern.compile("^0\\d{9}$");
//
//    private ReviewDao reviewDao = new ReviewDao();
//
//    // get
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        User authUser = (User) request.getSession().getAttribute("auth");
//        if (authUser == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
//
//        UserDao userDao = new UserDao();
//
//        // load user mới từ db
//        User user = userDao.getUserById(authUser.getId());
//        if (user == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
//
//        //đồng bộ lại session auth
//        request.getSession().setAttribute("auth", user);
//
//        String tab = request.getParameter("tab");
//        if (tab == null || tab.isEmpty()) {
//            tab = "orders";
//        }
//        List<Order> orders = Collections.emptyList();
//        List<Review> reviews = new ArrayList<>();
//
//        if ("orders".equals(tab)) {
//            orders = dao.getOrdersByUserId(user.getId());
//        }
//
//        if ("reviews".equals(tab)) {
//            reviews = reviewDao.getReviewsByUserId(user.getId());
//        }
//
//        request.setAttribute("orders", orders);
//        request.setAttribute("reviews", reviews);
//        request.setAttribute("user", user);
//        request.setAttribute("tab", tab);
//
//        request.getRequestDispatcher(
//                "/Assets/component/login_logout/profile.jsp"
//        ).forward(request, response);
//    }
//
//    //post
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        request.setCharacterEncoding("UTF-8");
//
//        User authUser = (User) request.getSession().getAttribute("auth");
//        if (authUser == null) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
//
//        UserDao userDao = new UserDao();
//
//        String email = request.getParameter("email");
//        String phoneNum = request.getParameter("phoneNum");
//        String location = request.getParameter("location");
//
//        if (email == null || !GMAIL_PATTERN.matcher(email).matches()) {
//            forwardEditWithError(request, response, userDao, authUser,
//                    "Email phải là Gmail hợp lệ");
//            return;
//        }
//
//        if (!email.equals(authUser.getEmail()) && userDao.existsEmail(email)) {
//            forwardEditWithError(request, response, userDao, authUser,
//                    "Email đã tồn tại");
//            return;
//        }
//
//        if (phoneNum == null || !PHONE_PATTERN.matcher(phoneNum).matches()) {
//            forwardEditWithError(request, response, userDao, authUser,
//                    "Số điện thoại phải bắt đầu bằng 0 và đủ 10 chữ số");
//            return;
//        }
//
//        if (!phoneNum.equals(authUser.getPhoneNum())
//                && userDao.existsPhoneNum(phoneNum)) {
//            forwardEditWithError(request, response, userDao, authUser,
//                    "Số điện thoại đã tồn tại");
//            return;
//        }
//
//        // cập nhật
//        User updateUser = new User();
//        updateUser.setId(authUser.getId());
//        updateUser.setEmail(email.trim());
//        updateUser.setPhoneNum(phoneNum.trim());
//        updateUser.setLocation(
//                location == null || location.isBlank() ? null : location.trim()
//        );
//
//        if (!userDao.updateProfile(updateUser)) {
//            forwardEditWithError(request, response, userDao, authUser,
//                    "Cập nhật thất bại");
//            return;
//        }
//
//        response.sendRedirect(request.getContextPath() + "/profile?tab=edit&success=1");
//    }
//
//    private void forwardEditWithError(HttpServletRequest request,
//                                      HttpServletResponse response,
//                                      UserDao userDao,
//                                      User authUser,
//                                      String msg)
//            throws ServletException, IOException {
//
//        User freshUser = userDao.getUserById(authUser.getId());
//
//        request.setAttribute("error", msg);
//        request.setAttribute("user", freshUser);
//        request.setAttribute("tab", "edit");
//        request.setAttribute("orders", Collections.emptyList());
//        request.setAttribute("reviews", Collections.emptyList());
//
//        request.getRequestDispatcher(
//                "/Assets/component/login_logout/profile.jsp"
//        ).forward(request, response);
//    }
//}
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
