package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.dao.SearchHistoryDao;
import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.model.SearchHistory;
import com.example.web_console_handheld.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/search-suggest")
public class SearchSuggestServlet extends HttpServlet {

    private ProductDao productDao;
    private SearchHistoryDao searchHistoryDao;

    @Override
    public void init() {
        productDao = new ProductDao();
        searchHistoryDao = new SearchHistoryDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String keyword = req.getParameter("q");
        User user = (User) req.getSession().getAttribute("auth");
        String contextPath = req.getContextPath();

        StringBuilder json = new StringBuilder("[");

        // 1. Trường hợp KHÔNG nhập gì -> Hiển thị Lịch sử hoặc Top bán chạy (Mặc định khi click)
        if (keyword == null || keyword.trim().isEmpty()) {
            if (user != null) {
                List<SearchHistory> recent = searchHistoryDao.getRecentSearches(user.getId(), 5);
                if (!recent.isEmpty()) {
                    for (int i = 0; i < recent.size(); i++) {
                        SearchHistory h = recent.get(i);
                        json.append("{")
                                .append("\"type\":\"history\",")
                                .append("\"keyword\":\"").append(escape(h.getKeyword())).append("\"")
                                .append("}");
                        if (i < recent.size() - 1) json.append(",");
                    }
                    json.append("]");
                    resp.getWriter().write(json.toString());
                    return;
                }
            }
            // Chưa đăng nhập hoặc chưa có lịch sử -> Fallback hiển thị sản phẩm top bán chạy
            appendProductsJson(json, productDao.getTopSellingProducts(5), "top", contextPath);
            json.append("]");
            resp.getWriter().write(json.toString());
            return;
        }

        // 2. Trường hợp CÓ từ khóa -> Gợi ý nâng cao khớp tên sản phẩm
        List<Product> list = productDao.suggestByName(keyword.trim());
        appendProductsJson(json, list, "suggest", contextPath);
        json.append("]");
        resp.getWriter().write(json.toString());
    }

    // Thêm chức năng xóa lịch sử qua phương thức DELETE
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        User user = (User) req.getSession().getAttribute("auth");
        if (user != null) {
            searchHistoryDao.clearAllHistory(user.getId());
            resp.getWriter().write("{\"status\":\"success\"}");
        } else {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
    }

    private void appendProductsJson(StringBuilder json, List<Product> products, String type, String contextPath) {
        if (products == null) return;
        for (int i = 0; i < products.size(); i++) {
            Product p = products.get(i);
            String imgPath = p.getImage();
            if (imgPath == null || imgPath.isEmpty()) {
                imgPath = contextPath + "/Assets/img/no-image.png";
            } else if (!imgPath.toLowerCase().startsWith("http")) {
                imgPath = contextPath + (imgPath.startsWith("/") ? "" : "/") + imgPath;
            }

            // Kiểm tra tình trạng hàng (giả định thực tế dựa trên thuộc tính số lượng của bạn)
            String status = (p.getStock() > 0) ? "Còn hàng" : "Hết hàng";

            json.append("{")
                    .append("\"type\":\"").append(type).append("\",")
                    .append("\"id\":").append(p.getID()).append(",")
                    .append("\"name\":\"").append(escape(p.getName())).append("\",")
                    .append("\"price\":").append(p.getPrice()).append(",")
                    .append("\"status\":\"").append(status).append("\",")
                    .append("\"image\":\"").append(escape(imgPath)).append("\"")
                    .append("}");
            if (i < products.size() - 1) json.append(",");
        }
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "").replace("\r", "");
    }
}