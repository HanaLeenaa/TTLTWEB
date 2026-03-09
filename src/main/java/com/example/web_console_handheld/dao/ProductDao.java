package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Brand;
import com.example.web_console_handheld.model.Category;
import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.utils.DBConnection;
import com.sun.jdi.connect.spi.Connection;

import java.sql.PreparedStatement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ProductDao extends BaseDao {
    //lay ra tat ca san pham lien quan cung danh muc va thuong hieu cua san pham duoc click vao
    public List<Product> getProductListByBrandAndCategory(int brandId, int categoryId, int productID) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "select * from products where brand_id = :brandId and categories_id = :categoryId and ID != :productID"
                        )
                        .bind("brandId", brandId)
                        .bind("categoryId", categoryId)
                        .bind("productID", productID)
                        .mapToBean(Product.class)
                        .list()
        );
    }

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
                                "select * from products where active = 1 ORDER BY ispremium DESC"
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

    public int countFilter(
            Integer categoryId,
            String priceRange,
            List<Integer> brandIds,
            List<Integer> useTimes
    ) {

        StringBuilder sql = new StringBuilder("""
                    SELECT COUNT(*)
                    FROM products
                    WHERE active = 1
                """);

        if (categoryId != null) {
            sql.append(" AND categories_id = :categoryId");
        }

        if (priceRange != null) {
            switch (priceRange) {
                case "under500" -> sql.append(" AND price < 500000");
                case "500-1m" -> sql.append(" AND price BETWEEN 500000 AND 1000000");
                case "1-2m" -> sql.append(" AND price BETWEEN 1000000 AND 2000000");
                case "2-3m" -> sql.append(" AND price BETWEEN 2000000 AND 3000000");
                case "over3m" -> sql.append(" AND price > 3000000");
            }
        }

        if (brandIds != null && !brandIds.isEmpty()) {
            sql.append(" AND brand_id IN (<brandIds>)");
        }

        if (useTimes != null && !useTimes.isEmpty()) {
            sql.append(" AND useTime IN (<useTimes>)");
        }

        return get().withHandle(handle -> {
            var q = handle.createQuery(sql.toString());

            if (categoryId != null) {
                q.bind("categoryId", categoryId);
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                q.bindList("brandIds", brandIds);
            }
            if (useTimes != null && !useTimes.isEmpty()) {
                q.bindList("useTimes", useTimes);
            }

            return q.mapTo(Integer.class).one();
        });
    }



    // lọc sản phẩm
    public List<Product> filterSortPage(
            Integer categoryId,
            String priceRange,
            List<Integer> brandIds,
            List<Integer> useTimes,
            String sort,
            int offset,
            int limit
    ) {

        StringBuilder sql = new StringBuilder("""
                    SELECT *
                    FROM products
                    WHERE active = 1
                """);

        // ===== FILTER =====
        if (categoryId != null) {
            sql.append(" AND categories_id = :categoryId");
        }

        if (priceRange != null) {
            switch (priceRange) {
                case "under500" -> sql.append(" AND price < 500000");
                case "500-1m" -> sql.append(" AND price BETWEEN 500000 AND 1000000");
                case "1-2m" -> sql.append(" AND price BETWEEN 1000000 AND 2000000");
                case "2-3m" -> sql.append(" AND price BETWEEN 2000000 AND 3000000");
                case "over3m" -> sql.append(" AND price > 3000000");
            }
        }

        if (brandIds != null && !brandIds.isEmpty()) {
            sql.append(" AND brand_id IN (<brandIds>)");
        }

        if (useTimes != null && !useTimes.isEmpty()) {
            sql.append(" AND useTime IN (<useTimes>)");
        }

        // ===== SORT =====
        if (sort == null || sort.isEmpty()) {
            sql.append(" ORDER BY ispremium DESC, ID ASC");
        } else {
            switch (sort) {
                case "price_asc" -> sql.append(" ORDER BY ispremium DESC, price ASC");
                case "price_desc" -> sql.append(" ORDER BY ispremium DESC, price DESC");
                case "newest" -> sql.append(" ORDER BY ispremium DESC, createdAt DESC");
                default -> sql.append(" ORDER BY ispremium DESC, ID ASC");
            }
        }

        // ===== PAGINATION =====
        sql.append(" LIMIT :limit OFFSET :offset");

        return get().withHandle(handle -> {
            var q = handle.createQuery(sql.toString());

            if (categoryId != null) {
                q.bind("categoryId", categoryId);
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                q.bindList("brandIds", brandIds);
            }
            if (useTimes != null && !useTimes.isEmpty()) {
                q.bindList("useTimes", useTimes);
            }

            q.bind("limit", limit);
            q.bind("offset", offset);

            return q.mapToBean(Product.class).list();
        });
    }

    // Tìm kiếm sản phẩm
    public List<Product> searchByName(String keyword) {
        return get().withHandle(h ->
                h.createQuery("""
                SELECT *
                FROM products
                WHERE active = 1
                  AND name LIKE :kw
                ORDER BY ispremium DESC, id ASC
            """)
                        .bind("kw", "%" + keyword + "%")
                        .mapToBean(Product.class)
                        .list()
        );
    }

    //Gợi ý tìm kiếm
    public List<Product> suggestByName(String keyword) {
        return get().withHandle(handle ->
                handle.createQuery("""
                                    SELECT ID, name, image, metatitle
                                    FROM products
                                    WHERE active = 1
                                      AND name LIKE :kw
                                    LIMIT 5
                                """)
                        .bind("kw", "%" + keyword + "%")
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> searchByNamePage(String keyword, int offset, int limit) {
        return get().withHandle(h ->
                h.createQuery("""
            SELECT *
            FROM products
            WHERE active = 1
              AND name LIKE :kw
            ORDER BY ispremium DESC, ID ASC
            LIMIT :limit OFFSET :offset
        """)
                        .bind("kw", "%" + keyword + "%")
                        .bind("limit", limit)
                        .bind("offset", offset)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public int countSearchByName(String keyword) {
        return get().withHandle(h ->
                h.createQuery("""
            SELECT COUNT(*)
            FROM products
            WHERE active = 1
              AND name LIKE :kw
        """)
                        .bind("kw", "%" + keyword + "%")
                        .mapTo(Integer.class)
                        .one()
        );
    }
    // ================= SEARCH + FILTER + SORT + PAGINATION =================



    // ================= SEARCH + FILTER + SORT + PAGINATION =================
    public List<Product> searchByNameFilterPage(
            String keyword,
            Integer categoryId,
            String priceRange,
            List<Integer> brandIds,
            List<Integer> useTimes,
            String sort,
            int offset,
            int limit
    ) {

        StringBuilder sql = new StringBuilder("""
                    SELECT *
                    FROM products
                    WHERE active = 1
                      AND name LIKE :kw
                """);

        // ===== FILTER =====
        if (categoryId != null) {
            sql.append(" AND categories_id = :categoryId");
        }

        if (priceRange != null) {
            switch (priceRange) {
                case "under500" -> sql.append(" AND price < 500000");
                case "500-1m" -> sql.append(" AND price BETWEEN 500000 AND 1000000");
                case "1-2m" -> sql.append(" AND price BETWEEN 1000000 AND 2000000");
                case "2-3m" -> sql.append(" AND price BETWEEN 2000000 AND 3000000");
                case "over3m" -> sql.append(" AND price > 3000000");
            }
        }

        if (brandIds != null && !brandIds.isEmpty()) {
            sql.append(" AND brand_id IN (<brandIds>)");
        }

        if (useTimes != null && !useTimes.isEmpty()) {
            sql.append(" AND useTime IN (<useTimes>)");
        }

        // ===== SORT =====
        if (sort == null || sort.isEmpty()) {
            sql.append(" ORDER BY ispremium DESC, ID ASC");
        } else {
            switch (sort) {
                case "price_asc" -> sql.append(" ORDER BY ispremium DESC, price ASC");
                case "price_desc" -> sql.append(" ORDER BY ispremium DESC, price DESC");
                case "newest" -> sql.append(" ORDER BY ispremium DESC, createdAt DESC");
                default -> sql.append(" ORDER BY ispremium DESC, ID ASC");
            }
        }

        sql.append(" LIMIT :limit OFFSET :offset");

        return get().withHandle(handle -> {
            var q = handle.createQuery(sql.toString())
                    .bind("kw", "%" + keyword + "%")
                    .bind("limit", limit)
                    .bind("offset", offset);

            if (categoryId != null) q.bind("categoryId", categoryId);
            if (brandIds != null && !brandIds.isEmpty()) q.bindList("brandIds", brandIds);
            if (useTimes != null && !useTimes.isEmpty()) q.bindList("useTimes", useTimes);

            return q.mapToBean(Product.class).list();
        });
    }

    // ================= COUNT SEARCH + FILTER =================
    public int countSearchByNameFilter(
            String keyword,
            Integer categoryId,
            String priceRange,
            List<Integer> brandIds,
            List<Integer> useTimes
    ) {

        StringBuilder sql = new StringBuilder("""
                    SELECT COUNT(*)
                    FROM products
                    WHERE active = 1
                      AND name LIKE :kw
                """);

        if (categoryId != null) {
            sql.append(" AND categories_id = :categoryId");
        }

        if (priceRange != null) {
            switch (priceRange) {
                case "under500" -> sql.append(" AND price < 500000");
                case "500-1m" -> sql.append(" AND price BETWEEN 500000 AND 1000000");
                case "1-2m" -> sql.append(" AND price BETWEEN 1000000 AND 2000000");
                case "2-3m" -> sql.append(" AND price BETWEEN 2000000 AND 3000000");
                case "over3m" -> sql.append(" AND price > 3000000");
            }
        }

        if (brandIds != null && !brandIds.isEmpty()) {
            sql.append(" AND brand_id IN (<brandIds>)");
        }

        if (useTimes != null && !useTimes.isEmpty()) {
            sql.append(" AND useTime IN (<useTimes>)");
        }

        return get().withHandle(handle -> {
            var q = handle.createQuery(sql.toString())
                    .bind("kw", "%" + keyword + "%");

            if (categoryId != null) q.bind("categoryId", categoryId);
            if (brandIds != null && !brandIds.isEmpty()) q.bindList("brandIds", brandIds);
            if (useTimes != null && !useTimes.isEmpty()) q.bindList("useTimes", useTimes);

            return q.mapTo(Integer.class).one();
        });
    }

    public List<Product> getAll() {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT *
                FROM products
                ORDER BY ID 
            """)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public void insert(Product p) {
        get().useHandle(handle ->
                handle.createUpdate("""
            INSERT INTO products (
                categories_id,
                brand_id,
                name,
                short_description,
                full_description,
                information,
                price,
                priceOld,
                image,
                createdAt,
                energy,
                useTime,
                weight,
                active,
                metatitle,
                ispremium,
                suports,
                connect,
                endow
            )
            VALUES (
                :categories_id,
                :brand_id,
                :name,
                :short_description,
                :full_description,
                :information,
                :price,
                :priceOld,
                :image,
                :createdAt,
                :energy,
                :useTime,
                :weight,
                :active,
                :metatitle,
                :ispremium,
                :suports,
                :connect,
                :endow
            )
        """)
                        .bind("categories_id", p.getCategories_id())
                        .bind("brand_id", p.getBrand_id())
                        .bind("name", p.getName())
                        .bind("short_description", p.getShort_description())
                        .bind("full_description", p.getFull_description())
                        .bind("information", p.getInformation())
                        .bind("price", p.getPriceValue())
                        .bind("priceOld", p.getPriceOldValue())
                        .bind("image", p.getImage())
                        .bind("createdAt", p.getCreatedAt() == null ? LocalDateTime.now() : p.getCreatedAt())
                        .bind("energy", p.getEnergy())
                        .bind("useTime", p.getUseTime())
                        .bind("weight", p.getWeight())
                        .bind("active", p.isActive())
                        .bind("metatitle", p.getMetatitle())
                        .bind("ispremium", p.isIspremium())
                        .bind("suports", p.getSuports())
                        .bind("connect", p.getConnect())
                        .bind("endow", p.getEndow())

                        .execute()
        );
}

    public void deleteById(int id) {
        get().useHandle(handle ->
                handle.createUpdate("""
            DELETE FROM products
            WHERE ID = :id
        """)
                        .bind("id", id)
                        .execute()
        );
    }
    /*Edit products*/
    public Product findById(int id) {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT * FROM products WHERE ID = :id
            """)
                        .bind("id", id)
                        .mapToBean(Product.class)
                        .one()
        );
    }
    public void update(Product p) {
        get().useHandle(handle ->
                handle.createUpdate("""
                UPDATE products SET
                    categories_id = :categories_id,
                    brand_id = :brand_id,
                    name = :name,
                    short_description = :short_description,
                    full_description = :full_description,
                    information = :information,
                    price = :price,
                    priceOld = :priceOld,
                    image = :image,
                    energy = :energy,
                    useTime = :useTime,
                    weight = :weight,
                    active = :active,
                    metatitle = :metatitle,
                    ispremium = :ispremium,
                    suports = :suports,
                    connect = :connect,
                    endow = :endow
                WHERE ID = :id
            """)
                        .bind("id", p.getID())
                        .bind("categories_id", p.getCategories_id())
                        .bind("brand_id", p.getBrand_id())
                        .bind("name", p.getName())
                        .bind("short_description", p.getShort_description())
                        .bind("full_description", p.getFull_description())
                        .bind("information", p.getInformation())
                        .bind("price", p.getPriceValue())
                        .bind("priceOld", p.getPriceOld() == null ? 0 : Long.parseLong(p.getPriceOld().replace(".", "")))
                        .bind("image", p.getImage())
                        .bind("energy", p.getEnergy())
                        .bind("useTime", p.getUseTime())
                        .bind("weight", p.getWeight())
                        .bind("active", p.isActive())
                        .bind("metatitle", p.getMetatitle())
                        .bind("ispremium", p.isIspremium())
                        .bind("suports", p.getSuports())
                        .bind("connect", p.getConnect())
                        .bind("endow", p.getEndow())
                        .execute()
        );
    }


}

