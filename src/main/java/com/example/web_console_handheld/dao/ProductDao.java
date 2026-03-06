package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Logo;
import com.example.web_console_handheld.model.Product;

import java.util.List;

public class ProductDao extends BaseDao{
    //lay san pham theo id trang productDetails
    public Product getProductDetailByID(int id) {
        return get().withHandle(handle ->
                handle.createQuery("""
            SELECT
                p.ID,
                p.name,
                p.image,
                p.price,
                p.priceOld,
                p.short_description,
                p.full_description,
                p.information,
                p.energy,
                p.useTime,
                p.weight,
                p.active,
                p.metatitle,
                p.ispremium AS isPremium,
                p.suports,
                p.connect,
                p.endow,
                p.createdAt,

                p.categories_id AS categoriesId,
                c.name AS categoryName,

                p.brand_id AS brandId,
                b.brand_name AS brandName

            FROM products p
            JOIN categories c ON p.categories_id = c.ID
            JOIN brands b ON p.brand_id = b.ID
            WHERE p.ID = :id
        """)
                        .bind("id", id)
                        .mapToBean(Product.class)
                        .findOne()
                        .orElse(null)
        );
    }


    public List<Product> getEnergyProductList() {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT DISTINCT useTime FROM products ORDER BY useTime ASC"
                        )
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> getPremiumProductList() {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT * from products where ispremium = 1 and active = 1"
                        )
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> getProductListForHome() {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT * FROM products " +
                                        "WHERE priceOld IS NOT NULL " +
                                        "AND price IS NOT NULL " +
                                        "AND priceOld > price " +
                                        "AND active = 1 " +
                                        "ORDER BY (priceOld - price) DESC " +
                                        "LIMIT 4"
                        )
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> getProductList() {
        return get().withHandle(handle ->
                handle.createQuery(
                                "select * from products where active = 1 and ispremium = 0"
                        )
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public Product getHighestDiscountProduct() {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT * FROM products " +
                                        "WHERE priceOld IS NOT NULL " +
                                        "AND price IS NOT NULL " +
                                        "AND priceOld > price " +
                                        "AND active = 1 " +
                                        "ORDER BY (priceOld - price) DESC " +
                                        "LIMIT 1"
                        )
                        .mapToBean(Product.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public List<Product> getProductSmallerThanList() {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT * FROM products " +
                                        "WHERE price IS NOT NULL " +
                                        "AND active = 1 " +
                                        "and price < 1300000 " +
                                        "LIMIT 2"
                        )
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public Product getSmallestProduct() {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT * FROM products " +
                                        "where price IS NOT NULL " +
                                        "AND active = 1 " +
                                        "ORDER BY price ASC " +
                                        "LIMIT 1"
                        )
                        .mapToBean(Product.class)
                        .findOne()
                        .orElse(null)
        );
    }

    //chức năng sắp xếp sản phẩm theo giá tăng, giảm dần và mới nhất
    public List<Product> getProductListForSort(String sort){
        String sql = "select * from products where active = 1 AND ispremium = 0 ";


        if (sort != null){
            switch (sort){
                case "price_asc":
                    sql += " ORDER BY price ASC";
                    break;
                case "price_desc":
                    sql += " ORDER BY price DESC";
                    break;
                case "newest":
                    sql += " ORDER BY createdAt DESC";
                    break;
                default:
                     sql += " ORDER BY ID ASC";

            }
        }else{
            sql += " ORDER BY ID ASC";
        }
        String finalSql = sql;
        return get().withHandle(handle ->
                handle.createQuery(finalSql).mapToBean(Product.class).list()
        );
    }
}
