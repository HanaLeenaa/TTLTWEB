package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Gallary;
import com.example.web_console_handheld.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GallaryDao extends BaseDao{
    public GallaryDao()  {
    }
    public List<Gallary> getListGallaryBy_product_id(int product_id){
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM gallary WHERE product_id = :id").bind("id", product_id).mapToBean(Gallary.class).list()
        );
}

    // lưu ảnh được thêm từ thêm sản phẩm ở trang admin vào bảng gallary
    public void insertGallary(Gallary gallary) {
        String sql = "INSERT INTO gallary(product_id, img) VALUES (:product_id, :img)";

        get().useHandle(handle -> {
            int rows = handle.createUpdate(sql)
                    .bind("product_id", gallary.getProduct_id())
                    .bind("img", gallary.getImg())
                    .execute();
        });
    }

    public List<Gallary> getListGallaryByProductId(int product_id){
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM  gallary WHERE  product_id = :id")
                        .bind("id", product_id)
                        .mapToBean(Gallary.class)
                        .list());
    }
}
