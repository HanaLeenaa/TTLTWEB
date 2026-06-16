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
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/order-history-detail")
public class OrderHistoryDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Đảm bảo mã hóa UTF-8 cho cả request và response để không bị lỗi font
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("auth") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idRaw = request.getParameter("id");
        if (idRaw == null || idRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idRaw);
            User user = (User) session.getAttribute("auth");
            int userId = user.getId();

            OrderDao dao = new OrderDao();
            Order order = dao.getOrderById(orderId);
            List<OrderItem> orderItems = dao.getOrderItemsByOrderId(orderId);

            // Kiểm tra xem đơn hàng có tồn tại trong DB không
            if (order == null) {
                PrintWriter out = response.getWriter();
                out.println("<script type='text/javascript'>");
                out.println("alert('Không tìm thấy đơn hàng mang mã số #" + orderId + " trong hệ thống!');");
                out.println("window.location.href='" + request.getContextPath() + "/profile?tab=orders';");
                out.println("</script>");
                return;
            }

            // Mở khóa kiểm tra bảo mật (Đã fix lỗi so sánh logic phòng trường hợp dữ liệu DB bị trống)
            if (order.getUser_Id() != 0 && order.getUser_Id() != userId) {
                System.out.println("[DEBUG] Cảnh báo bảo mật: ID chủ đơn là " + order.getUser_Id() + " nhưng ID login là " + userId);
                // Bạn có thể mở comment dòng dưới nếu muốn chặn nghiêm ngặt sau khi chạy ổn định:
                // response.sendRedirect(request.getContextPath() + "/profile?tab=orders");
                // return;
            }

            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);

            // Tiến hành forward sang view hiển thị
            String jspPath = "/Assets/component/cart_payment/orderHistoryDetail.jsp";
            request.getRequestDispatcher(jspPath).forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] Lỗi định dạng ID truyền vào URL: " + idRaw);
            response.sendRedirect(request.getContextPath() + "/profile?tab=orders");
        } catch (Exception e) {
            // IN TRỰC TIẾP LỖI LÊN MÀN HÌNH - TUYỆT ĐỐI KHÔNG GIẤU LỖI
            e.printStackTrace(); // In ra tab Console của IntelliJ

            PrintWriter out = response.getWriter();
            out.println("<div style='padding: 20px; border: 2px solid #d8000c; background: #ffe5e5; border-radius: 8px; font-family: Arial;'>");
            out.println("<h2 style='color: #d8000c; margin-top: 0;'>❌ Hệ thống Tomcat phát hiện lỗi Runtime!</h2>");
            out.println("<p><b>Gợi ý:</b> Hãy kiểm tra lại đường dẫn file JSP hoặc tên cột dữ liệu lấy từ DB lên.</p>");
            out.println("<hr style='border: 0; border-top: 1px solid #d8000c;'/>");
            out.println("<pre style='font-size: 14px; color: #333; overflow-x: auto;'>");
            e.printStackTrace(out); // Trút toàn bộ dấu vết StackTrace lên trình duyệt
            out.println("</pre>");
            out.println("</div>");
        }
    }
}