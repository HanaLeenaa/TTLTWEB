package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ImportDao;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/import")
public class AdminImportServlet extends HttpServlet {
    ImportDao dao = new ImportDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        //đánh dấu menu đang hoạt động
        request.setAttribute("activePage", "warehouse");
        try{
            if (action == null) {
                request.setAttribute("subPage", "import-create");
                //load trang
                List<Product> products = dao.getAllProducts();
                request.setAttribute("productList", products);
                request.getRequestDispatcher("/Assets/component/adminPage/importCreate.jsp").forward(request, response);
                return;
            }
            //tạo phiếu mới
            if (action.equals("create")) {
                int id = dao.createReceipt();
                response.sendRedirect(request.getContextPath() + "/admin/import?action=detail&id=" +id);
                return;
            }

            //xem chi tiết phiếu để thêm sản phẩm
            if (action.equals("detail")) {
                request.setAttribute("subPage", "import-create");

                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("productList", dao.getAllProducts());
                request.setAttribute("itemList", dao.getItemsByReceiptId(id));
                request.setAttribute("receiptId", id);

                request.getRequestDispatcher("/Assets/component/adminPage/importCreate.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("addItem".equals(action)) {
                int receiptId = Integer.parseInt(request.getParameter("receiptId"));
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                dao.addItem(receiptId, productId, quantity);
                response.sendRedirect(request.getContextPath() +"/admin/import?action=detail&id=" + receiptId);
            }

            //xác nhận nhập kho
            if ("confirm".equals(action)) {
                int receiptId = Integer.parseInt(request.getParameter("receiptId"));
                dao.confirmReceipt(receiptId);
                request.getSession().setAttribute("message", "Nhập kho thành công phiếu số: "+ receiptId);

                response.sendRedirect(request.getContextPath() + "/admin/import");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();

        }
    }
}
