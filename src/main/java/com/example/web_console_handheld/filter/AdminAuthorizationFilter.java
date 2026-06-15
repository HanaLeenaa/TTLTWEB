package com.example.web_console_handheld.filter;

import com.example.web_console_handheld.model.Admin;
import com.example.web_console_handheld.utils.RoleConstant;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/Assets/component/adminPage/*"})
public class AdminAuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        String requestURI = httpRequest.getRequestURI();

        // 1. NGOẠI LỆ: Cho qua các URL liên quan đến Login để tránh vòng lặp chuyển hướng vô hạn
        if (requestURI.contains("adminLogin.jsp")
                || requestURI.contains("/admin-login")
                || requestURI.contains("/admin/login")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. KIỂM TRA ĐĂNG NHẬP: Nếu chưa có session -> đá thẳng về trang login công cộng
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;
        if (admin == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin-login");
            return;
        }

        // 3. PHÂN QUYỀN CHO NHÂN VIÊN KHO (STAFF_WAREHOUSE)
//        if (admin.getRole() == RoleConstant.STAFF_WAREHOUSE) {
//            // Nếu nhân viên kho vào trang Dashboard tổng hoặc các trang sản phẩm/nhập kho -> Cho phép ĐI TIẾP
//            if (requestURI.contains("/admin/dashboard")
//                    || requestURI.contains("/admin/products")
//                    || requestURI.contains("/admin/import")
//                    || requestURI.contains("/admin/import-history")) {
//                chain.doFilter(request, response);
//                return;
//            }
//
//            // 🛠️ ĐÃ CHỈNH SỬA: Chấm dứt tình trạng lọt lưới bằng cách chặn chính xác URL thực tế trên Sidebar
//            if (requestURI.contains("/admin/users")
//                    || requestURI.contains("/admin/orders")
//                    || requestURI.contains("/admin/contact")) {
//                httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/dashboard?error=NoPermission");
//                return;
//            }
//        }

        // Hợp lệ (Ví dụ như Admin tối cao) -> Cho đi tiếp thoải mái
        chain.doFilter(request, response);
    }
}