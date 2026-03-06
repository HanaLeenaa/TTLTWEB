package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.BrandDao;
import com.example.web_console_handheld.dao.CategoryDao;
import com.example.web_console_handheld.dao.GallaryDao;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Brand;
import com.example.web_console_handheld.model.Category;
import com.example.web_console_handheld.model.Gallary;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();
    private CategoryDao categoryDao = new CategoryDao();
    private BrandDao brandDao = new BrandDao();
    private GallaryDao gallaryDao = new GallaryDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.sendRedirect("product");
            return;
        }

        int id = Integer.parseInt(idParam);
        Category category = categoryDao.getCategoryByProductId(id);
        Brand brand = brandDao.getBrandByProductId(id);
        List<Gallary> gallaryList = gallaryDao.getListGallaryBy_product_id(id);
        request.setAttribute("gallary", gallaryList);
        request.setAttribute("brand", brand);
        request.setAttribute("category", category);

        Product product = productDao.getProductDetailByID(id);
        if (product == null) {
            response.sendRedirect("product");
            return;
        }

        String[] endowList = new String[0];
        if (product.getEndow() != null && !product.getEndow().isBlank()) {
            endowList = product.getEndow().split("\\r?\\n");
        }

        String desc = product.getShort_description();
        String[] descLines = new String[0];
        if (desc != null && !desc.isBlank()) {
            descLines = desc.split("\\r?\\n");
        }

        request.setAttribute("descLines", descLines);
        request.setAttribute("endowList", endowList);
        request.setAttribute("product", product);

        request.getRequestDispatcher("/Assets/Details/productDetails.jsp").forward(request, response);
    }
}
