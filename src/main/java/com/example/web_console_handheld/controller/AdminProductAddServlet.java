package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.GallaryDao;
import com.example.web_console_handheld.dao.ProductDao;
import com.example.web_console_handheld.model.Gallary;
import com.example.web_console_handheld.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;


@WebServlet("/admin/products/add")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AdminProductAddServlet extends HttpServlet {
    private ProductDao productDao = new ProductDao();
    private GallaryDao gallaryDao = new GallaryDao();


    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/Assets/component/adminPage/addProduct.jsp")
                .forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        try {
            // Tao thu muc chua anh Upload
            String uploadPath = getServletContext().getRealPath("/Assets/image");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists())
                uploadDir.mkdirs();

            //XU LY ANH CHINH
            String mainImage = req.getParameter("image");
            Part imageMainFile = req.getPart("imageMainFile");
            if (imageMainFile != null && imageMainFile.getSize() > 0) {
                mainImage = saveFile(imageMainFile, uploadPath);


            }
            Product p = new Product();

            p.setName(req.getParameter("name"));
            p.setPrice(Long.parseLong(req.getParameter("price")));
            p.setPriceOld(Long.parseLong(req.getParameter("priceOld")));
            p.setImage(mainImage);

            p.setCategories_id(parseInt(req.getParameter("categories_id")));
            p.setBrand_id(parseInt(req.getParameter("brand_id")));

            p.setShort_description(req.getParameter("short_description"));
            p.setFull_description(req.getParameter("full_description"));
            p.setInformation(req.getParameter("information"));

            p.setEnergy(parseInt(req.getParameter("energy")));
            p.setUseTime(parseInt(req.getParameter("useTime")));
            p.setWeight(parseInt(req.getParameter("weight")));

            p.setMetatitle(req.getParameter("metatitle"));
            p.setSuports(req.getParameter("suports"));
            p.setConnect(req.getParameter("connect"));
            p.setEndow(req.getParameter("endow"));

            p.setActive(req.getParameter("active") != null);
            p.setIspremium(req.getParameter("ispremium") != null);

            p.setCreatedAt(java.time.LocalDateTime.now());

            int productId = productDao.insert(p);

            //insert anh phu Gallary
            if (productId > 0) {
                saveGallaryImage(req, productId, "galleryUrl1", "galleryFile1", uploadPath);
                saveGallaryImage(req, productId, "galleryUrl2", "galleryFile2", uploadPath);
                saveGallaryImage(req, productId, "galleryUrl3", "galleryFile3", uploadPath);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products/add?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi thêm sản phẩm: " + e.getMessage());
            req.getRequestDispatcher("/Assets/component/adminPage/addProduct.jsp")
                    .forward(req, resp);
        }
    }

    private int parseInt(String v) {
        return (v == null || v.trim().isEmpty()) ? 0 : Integer.parseInt(v.trim());
    }

    private String saveFile(Part part, String uploadPath) throws IOException {
        String originalFileName = part.getSubmittedFileName();

        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            return null;
        }

        String fileName = System.currentTimeMillis() + "_" + originalFileName;
        String fullPath = uploadPath + File.separator + fileName;

        part.write(fullPath);

        // link lưu trong DB
        return "Assets/image/" + fileName;
    }

    private void saveGallaryImage(HttpServletRequest req, int productId,
                                  String urlField, String fileField, String uploadPath)
            throws IOException, ServletException {

        String imagePath = req.getParameter(urlField);
        Part filePart = req.getPart(fileField);

        if (imagePath != null) {
            imagePath = imagePath.trim();
        }

        // Nếu có file thì ưu tiên file
        if (filePart != null && filePart.getSize() > 0) {
            imagePath = saveFile(filePart, uploadPath);
        }

        if (productId > 0 && imagePath != null && !imagePath.isEmpty()) {
            Gallary g = new Gallary(productId, imagePath);
            gallaryDao.insertGallary(g);
        }
    }

}

