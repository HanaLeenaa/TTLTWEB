package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ImportHistoryDao;
import com.example.web_console_handheld.model.StockMovement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/import-history")
public class AdminImportHistoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ImportHistoryDao dao = new ImportHistoryDao();
        List<StockMovement> list = dao.getImportHistory();

        request.setAttribute("activePage", "warehouse");
        request.setAttribute("historyList", list);

        request.setAttribute("subPage", "import-history");

        request.getRequestDispatcher("/Assets/component/adminPage/importHistory.jsp").forward(request, response);

    }
}
