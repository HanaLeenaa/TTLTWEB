package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.GallaryDao;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Gallary;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;


@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
@WebServlet("/admin/products/edit")
public class AdminProductUpdateServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();
    private GallaryDao gallaryDao = new GallaryDao();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        Product product = productDao.findById(id);
        List<Gallary> gallaryList = gallaryDao.getListGallaryByProductId(id);


        req.setAttribute("product", product);
        req.setAttribute("gallaryList", gallaryList);
        req.getRequestDispatcher("/Assets/component/adminPage/editProduct.jsp")
                .forward(req, resp);
    }


    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        int productId = Integer.parseInt(req.getParameter("id"));
        //lấy sản phẩm cũ để giữ ảnh nếu admin không sửa
        Product oldProduct = productDao.findById(productId);

        Product p = new Product();
        p.setID(productId);
        p.setName(req.getParameter("name"));
        p.setCategories_id(Integer.parseInt(req.getParameter("categories_id")));
        p.setBrand_id(Integer.parseInt(req.getParameter("brand_id")));
        p.setShort_description(req.getParameter("short_description"));
        p.setFull_description(req.getParameter("full_description"));
        p.setInformation(req.getParameter("information"));
        p.setPrice(req.getParameter("price"));
        p.setPriceOld(req.getParameter("priceOld"));
        p.setImage(req.getParameter("image"));
        p.setEnergy(Integer.parseInt(req.getParameter("energy")));
        p.setUseTime(Integer.parseInt(req.getParameter("useTime")));
        p.setWeight(Integer.parseInt(req.getParameter("weight")));
        p.setMetatitle(req.getParameter("metatitle"));
        p.setSuports(req.getParameter("suports"));
        p.setConnect(req.getParameter("connect"));
        p.setEndow(req.getParameter("endow"));
        p.setActive(req.getParameter("active") != null);
        p.setIspremium(req.getParameter("ispremium") != null);

        // xử lý ảnh chính
        Part imageMainFile = req.getPart("imageMainFile");
        String imageMainUrl = req.getParameter("image");

        String finalMainImage = oldProduct.getImage();

        if (imageMainFile != null && imageMainFile.getSize() > 0) {
            finalMainImage = saveFile(imageMainFile, req);
        } else if (imageMainUrl != null && !imageMainUrl.trim().isEmpty()) {
            finalMainImage = imageMainUrl.trim();
        }
        p.setImage(finalMainImage);

        productDao.update(p);

        // xử lý gallery
        String g1 = getGalleryImage(req, "galleryUrl1", "galleryFile1");
        String g2 = getGalleryImage(req, "galleryUrl2", "galleryFile2");
        String g3 = getGalleryImage(req, "galleryUrl3", "galleryFile3");

        if (!isBlank(g1) || !isBlank(g2) || !isBlank(g3)){
            gallaryDao.deleteByProductId(productId);

            saveGallary(productId, g1);
            saveGallary(productId, g2);
            saveGallary(productId, g3);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/products/edit?id=" + productId + "&success=1");
    }
    private String getGalleryImage(HttpServletRequest req, String urlField, String fileField) throws ServletException, IOException {
        String url = req.getParameter(urlField);
        Part filePart = req.getPart(fileField);

        if (filePart != null && filePart.getSize() > 0) {
            return saveFile(filePart, req);
        }
        if (url != null && !url.trim().isEmpty()) {
            return url.trim();
        }
        return null;
    }

    private void saveGallary(int productId, String imageUrl) {
        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            Gallary gallary = new Gallary(productId, imageUrl.trim());
            gallaryDao.insertGallary(gallary);
        }
    }
    private String saveFile(Part part, HttpServletRequest req) throws IOException {
        String uploadPath = req.getServletContext().getRealPath("/Assets/image");

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String originalFileName = extractFileName(part);
        String extension = "";

        int dotIndex = originalFileName.lastIndexOf(".");
        if (dotIndex >= 0) {
            extension = originalFileName.substring(dotIndex);
        }

        String newFileName = UUID.randomUUID() + extension;
        String fullPath = uploadPath + File.separator + newFileName;

        part.write(fullPath);

        return req.getContextPath() + "/Assets/image/" + newFileName;
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");

        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "unknown";
    }
        private boolean isBlank(String value) {
            return value == null || value.trim().isEmpty();
        }

}
