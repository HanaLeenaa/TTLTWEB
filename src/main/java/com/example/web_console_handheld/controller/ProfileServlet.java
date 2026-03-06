package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.OrderDao;
import com.example.web_console_handheld.dao.UserDao;
import com.example.web_console_handheld.model.Order;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.regex.Pattern;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private OrderDao dao = new OrderDao();

    private static final Pattern GMAIL_PATTERN =
            Pattern.compile("^[a-zA-Z0-9._%+-]+@gmail\\.com$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^0\\d{9}$");

    // get
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User authUser = (User) request.getSession().getAttribute("auth");
        if (authUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDao userDao = new UserDao();

        // load user mới từ db
        User user = userDao.getUserById(authUser.getId());
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        //đồng bộ lại session auth
        request.getSession().setAttribute("auth", user);

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "orders";
        }
        if ("orders".equals(tab)) {
            List<Order> orders =
                    dao.getOrdersByUserId(user.getId());
            request.setAttribute("orders", orders);
        }


        request.setAttribute("orders", Collections.emptyList());
        request.setAttribute("reviews", Collections.emptyList());
        request.setAttribute("user", user);
        request.setAttribute("tab", tab);

        request.getRequestDispatcher(
                "/Assets/component/login_logout/profile.jsp"
        ).forward(request, response);
    }

    //post
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        User authUser = (User) request.getSession().getAttribute("auth");
        if (authUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDao userDao = new UserDao();

        String email = request.getParameter("email");
        String phoneNum = request.getParameter("phoneNum");
        String location = request.getParameter("location");

        if (email == null || !GMAIL_PATTERN.matcher(email).matches()) {
            forwardEditWithError(request, response, userDao, authUser,
                    "Email phải là Gmail hợp lệ");
            return;
        }

        if (!email.equals(authUser.getEmail()) && userDao.existsEmail(email)) {
            forwardEditWithError(request, response, userDao, authUser,
                    "Email đã tồn tại");
            return;
        }

        if (phoneNum == null || !PHONE_PATTERN.matcher(phoneNum).matches()) {
            forwardEditWithError(request, response, userDao, authUser,
                    "Số điện thoại phải bắt đầu bằng 0 và đủ 10 chữ số");
            return;
        }

        if (!phoneNum.equals(authUser.getPhoneNum())
                && userDao.existsPhoneNum(phoneNum)) {
            forwardEditWithError(request, response, userDao, authUser,
                    "Số điện thoại đã tồn tại");
            return;
        }

        // cập nhật
        User updateUser = new User();
        updateUser.setId(authUser.getId());
        updateUser.setEmail(email.trim());
        updateUser.setPhoneNum(phoneNum.trim());
        updateUser.setLocation(
                location == null || location.isBlank() ? null : location.trim()
        );

        if (!userDao.updateProfile(updateUser)) {
            forwardEditWithError(request, response, userDao, authUser,
                    "Cập nhật thất bại");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/profile?tab=edit&success=1");
    }

    private void forwardEditWithError(HttpServletRequest request,
                                      HttpServletResponse response,
                                      UserDao userDao,
                                      User authUser,
                                      String msg)
            throws ServletException, IOException {

        User freshUser = userDao.getUserById(authUser.getId());

        request.setAttribute("error", msg);
        request.setAttribute("user", freshUser);
        request.setAttribute("tab", "edit");
        request.setAttribute("orders", Collections.emptyList());
        request.setAttribute("reviews", Collections.emptyList());

        request.getRequestDispatcher(
                "/Assets/component/login_logout/profile.jsp"
        ).forward(request, response);
    }
}
