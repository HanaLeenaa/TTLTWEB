package com.example.web_console_handheld.dao;

import com.example.web_console_handheld.model.Brand;
import com.example.web_console_handheld.model.Category;
import com.example.web_console_handheld.model.Product;
import com.example.web_console_handheld.utils.DBConnection;
import com.sun.jdi.connect.spi.Connection;
import jakarta.servlet.ServletResponse;

import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
                                        p.parent_id,
                                        p.color_name,
                                        p.color_code,
                                        p.name,
                                        p.image,
                                        p.price,
                                        p.priceOld,
                                        p.stock,
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
                                        "GROUP BY COALESCE(parent_id, ID) " + // Gộp nhóm tại đây
                                        "ORDER BY (priceOld - price) DESC " +
                                        "LIMIT 4"
                        )
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> getProductList() {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT p.* FROM products p
                INNER JOIN (
                    SELECT MIN(ID) as target_id
                    FROM products
                    WHERE active = 1
                    GROUP BY COALESCE(parent_id, ID)
                ) temp ON p.ID = temp.target_id
                ORDER BY p.ispremium DESC
            """)
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

    public int countFilter(List<Integer> categoryIds,
                           String priceRange,
                           List<Integer> brandIds,
                           List<Integer> useTimes) {

        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(DISTINCT COALESCE(parent_id, ID))
            FROM products
            WHERE active = 1
        """);

        if (categoryIds != null && !categoryIds.isEmpty()) {
            sql.append(" AND categories_id IN (<categoryIds>)");
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
            sql.append(" AND use_time IN (<useTimes>)");
        }

        return get().withHandle(handle -> {
            var q = handle.createQuery(sql.toString());

            if (categoryIds != null && !categoryIds.isEmpty()) {
                q.bindList("categoryIds", categoryIds);
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
    public List<Product> filterSortPage(List<Integer> categoryIds,
                                        String priceRange,
                                        List<Integer> brandIds,
                                        List<Integer> useTimes,
                                        String sort,
                                        int offset,
                                        int limit) {

        StringBuilder sql = new StringBuilder("""
        SELECT *
        FROM products
        WHERE active = 1
    """);

        // ===== FILTER =====
        if (categoryIds != null && !categoryIds.isEmpty()) {
            sql.append(" AND categories_id IN (<categoryIds>)");
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
            sql.append(" AND use_time IN (<useTimes>)");
        }

        sql.append(" GROUP BY COALESCE(parent_id, ID) ");

        // ===== SORT =====
        if (sort == null || sort.isEmpty()) {
            sql.append(" ORDER BY id ASC, ispremium DESC");
        } else {
            switch (sort) {
                case "price_asc" -> sql.append(" ORDER BY price ASC, ispremium DESC");
                case "price_desc" -> sql.append(" ORDER BY price DESC, ispremium DESC");
                case "newest" -> sql.append(" ORDER BY createdAt DESC, ispremium DESC");
                default -> sql.append(" ORDER BY id ASC, ispremium DESC");
            }
        }

        // ===== PAGINATION =====
        sql.append(" LIMIT :limit OFFSET :offset");

        return get().withHandle(handle -> {
            var q = handle.createQuery(sql.toString());

            if (categoryIds != null && !categoryIds.isEmpty()) {
                q.bindList("categoryIds", categoryIds);
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
                SELECT * FROM products 
                WHERE ID IN (
                    SELECT MIN(ID) 
                    FROM products 
                    WHERE active = 1 AND name LIKE :kw
                    GROUP BY COALESCE(parent_id, ID)
                )
                ORDER BY ispremium DESC, ID ASC
            """)
                        .bind("kw", "%" + keyword + "%")
                        .mapToBean(Product.class)
                        .list()
        );
    }

    //Gợi ý tìm kiếm
    // Gợi ý tìm kiếm - ĐÃ CẬP NHẬT THÊM PRICE VÀ STOCK
    public List<Product> suggestByName(String keyword) {
        return get().withHandle(handle ->
                handle.createQuery("""
                                    SELECT ID, name, image, metatitle, price, stock
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
            SELECT COUNT(DISTINCT COALESCE(parent_id, ID))
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
            List<Integer> categoryIds,
            String priceRange,
            List<Integer> brandIds,
            List<Integer> useTimes,
            String sort,
            int offset,
            int limit
    ) {

        // 1. Xây dựng điều kiện lọc (Filter) dùng bên trong Subquery
        StringBuilder filterSql = new StringBuilder(" WHERE active = 1 AND name LIKE :kw ");

        if (categoryIds != null && !categoryIds.isEmpty()) {
            filterSql.append(" AND categories_id IN (<categoryIds>)");
        }

        if (priceRange != null) {
            switch (priceRange) {
                case "under500" -> filterSql.append(" AND price < 500000");
                case "500-1m" -> filterSql.append(" AND price BETWEEN 500000 AND 1000000");
                case "1-2m" -> filterSql.append(" AND price BETWEEN 1000000 AND 2000000");
                case "2-3m" -> filterSql.append(" AND price BETWEEN 2000000 AND 3000000");
                case "over3m" -> filterSql.append(" AND price > 3000000");
            }
        }

        if (brandIds != null && !brandIds.isEmpty()) {
            filterSql.append(" AND brand_id IN (<brandIds>)");
        }

        if (useTimes != null && !useTimes.isEmpty()) {
            filterSql.append(" AND useTime IN (<useTimes>)");
        }

        StringBuilder mainSql = new StringBuilder("SELECT * FROM products WHERE ID IN (");
        mainSql.append(" SELECT MIN(ID) FROM products ")
                .append(filterSql)
                .append(" GROUP BY COALESCE(parent_id, ID) ")
                .append(") ");

        // ===== SORT =====
        if (sort == null || sort.isEmpty()) {
            mainSql.append(" ORDER BY ispremium DESC, ID ASC");
        } else {
            switch (sort) {
                case "price_asc" -> mainSql.append(" ORDER BY price ASC, ispremium DESC");
                case "price_desc" -> mainSql.append(" ORDER BY price DESC, ispremium DESC");
                case "newest" -> mainSql.append(" ORDER BY createdAt DESC, ispremium DESC");
                default -> mainSql.append(" ORDER BY ispremium DESC, ID ASC");
            }
        }

        mainSql.append(" LIMIT :limit OFFSET :offset");

        return get().withHandle(handle -> {
            var q = handle.createQuery(mainSql.toString())
                    .bind("kw", "%" + keyword + "%")
                    .bind("limit", limit)
                    .bind("offset", offset);

            if (categoryIds != null && !categoryIds.isEmpty()) {
                q.bindList("categoryIds", categoryIds);
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                q.bindList("brandIds", brandIds);
            }
            if (useTimes != null && !useTimes.isEmpty()) {
                q.bindList("useTimes", useTimes);
            }

            return q.mapToBean(Product.class).list();
        });
    }

    // ================= COUNT SEARCH + FILTER =================
    public int countSearchByNameFilter(
            String keyword,
            List<Integer> categoryIds,
            String priceRange,
            List<Integer> brandIds,
            List<Integer> useTimes
    ) {

        StringBuilder sql = new StringBuilder("""
                    SELECT COUNT(DISTINCT COALESCE(parent_id, ID))
                    FROM products
                    WHERE active = 1
                      AND name LIKE :kw
                """);

        if (categoryIds != null && !categoryIds.isEmpty()) {
            sql.append(" AND categories_id IN (<categoryIds>)");
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

            if (categoryIds != null && !categoryIds.isEmpty()) {
                q.bindList("categoryIds", categoryIds);
            }
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

    public int insert(Product p) {
        return get().withHandle(handle ->
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

                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class).one()
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
                        .findOne() // để trả về một Optional
                        .orElse(null)
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
                        .bind("priceOld", p.getPriceOld())
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

    public List<Product> getAllProductsPage(String priceRange,
                                            List<Integer> categoryIds,
                                            List<Integer> brandIds,
                                            List<Integer> useTimes,
                                            String sort,
                                            int offset,
                                            int limit) {
        return get().withHandle(handle -> {
            // Sử dụng Subquery để gom nhóm và chỉ lấy ra 1 ID đại diện nhỏ nhất (MIN) cho mỗi cụm biến thể
            StringBuilder subSql = new StringBuilder("SELECT MIN(ID) FROM products WHERE active = 1 ");

            if (priceRange != null) {
                switch (priceRange) {
                    case "under500" -> subSql.append("AND price < 500000 ");
                    case "500-1m" -> subSql.append("AND price BETWEEN 500000 AND 1000000 ");
                    case "1-2m" -> subSql.append("AND price BETWEEN 1000000 AND 2000000 ");
                    case "2-3m" -> subSql.append("AND price BETWEEN 2000000 AND 3000000 ");
                    case "over3m" -> subSql.append("AND price > 3000000 ");
                }
            }
            if (categoryIds != null && !categoryIds.isEmpty()) {
                subSql.append("AND categories_id IN (<categoryIds>) ");
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                subSql.append("AND brand_id IN (<brandIds>) ");
            }
            if (useTimes != null && !useTimes.isEmpty()) {
                subSql.append("AND useTime IN (<useTimes>) ");
            }

            // Tiến hành gộp nhóm ở Subquery
            subSql.append("GROUP BY COALESCE(parent_id, ID)");

            // Câu lệnh SQL chính: Lấy đầy đủ thông tin từ danh sách ID đại diện đã gộp ở trên
            StringBuilder mainSql = new StringBuilder("SELECT * FROM products WHERE ID IN (")
                    .append(subSql)
                    .append(") ");

            // Xử lý Sort dữ liệu sau khi gộp
            if ("price_asc".equals(sort)) {
                mainSql.append("ORDER BY price ASC ");
            } else if ("price_desc".equals(sort)) {
                mainSql.append("ORDER BY price DESC ");
            } else if ("newest".equals(sort)) {
                mainSql.append("ORDER BY createdAt DESC ");
            } else {
                mainSql.append("ORDER BY ispremium DESC, ID ASC ");
            }

            mainSql.append("LIMIT :limit OFFSET :offset");

            var query = handle.createQuery(mainSql.toString())
                    .bind("limit", limit)
                    .bind("offset", offset);

            if (categoryIds != null && !categoryIds.isEmpty()) {
                query.bindList("categoryIds", categoryIds);
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                query.bindList("brandIds", brandIds);
            }
            if (useTimes != null && !useTimes.isEmpty()) {
                query.bindList("useTimes", useTimes);
            }

            return query.mapToBean(Product.class).list();
        });
    }

    public int countAllProducts(String priceRange,
                                List<Integer> categoryIds,
                                List<Integer> brandIds,
                                List<Integer> useTimes) {
        return get().withHandle(handle -> {
            // Đếm số lượng nhóm duy nhất dựa vào DISTINCT COALESCE
            StringBuilder sql = new StringBuilder("SELECT COUNT(DISTINCT COALESCE(parent_id, ID)) FROM products WHERE active = 1 ");

            if (priceRange != null) {
                switch (priceRange) {
                    case "under500" -> sql.append("AND price < 500000 ");
                    case "500-1m" -> sql.append("AND price BETWEEN 500000 AND 1000000 ");
                    case "1-2m" -> sql.append("AND price BETWEEN 1000000 AND 2000000 ");
                    case "2-3m" -> sql.append("AND price BETWEEN 2000000 AND 3000000 ");
                    case "over3m" -> sql.append("AND price > 3000000 ");
                }
            }
            if (categoryIds != null && !categoryIds.isEmpty()) {
                sql.append("AND categories_id IN (<categoryIds>) ");
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                sql.append("AND brand_id IN (<brandIds>) ");
            }
            if (useTimes != null && !useTimes.isEmpty()) {
                sql.append("AND useTime IN (<useTimes>) ");
            }

            var query = handle.createQuery(sql.toString());

            if (categoryIds != null && !categoryIds.isEmpty()) {
                query.bindList("categoryIds", categoryIds);
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                query.bindList("brandIds", brandIds);
            }
            if (useTimes != null && !useTimes.isEmpty()) {
                query.bindList("useTimes", useTimes);
            }

            return query.mapTo(Integer.class).one();
        });
    }


    public List<Product> filterWishlist(List<Integer> wishlistIds,
                                        List<Integer> categoryIds,
                                        String priceRange,
                                        List<Integer> brandIds,
                                        List<Integer> useTimes,
                                        String sort) {
        // Nếu wishlist rỗng thì trả về rỗng
        if (wishlistIds == null || wishlistIds.isEmpty()) {
            return List.of();
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE active=1 ");
        sql.append("AND id IN (<wishlistIds>) ");

        if (categoryIds != null && !categoryIds.isEmpty()) {
            sql.append("AND categories_id IN (<categoryIds>) ");
        }
        if (priceRange != null) {
            switch (priceRange) {
                case "under500" -> sql.append("AND price < 500000 ");
                case "500-1m" -> sql.append("AND price BETWEEN 500000 AND 1000000 ");
                case "1-2m" -> sql.append("AND price BETWEEN 1000000 AND 2000000 ");
                case "2-3m" -> sql.append("AND price BETWEEN 2000000 AND 3000000 ");
                case "over3m" -> sql.append("AND price > 3000000 ");
            }
        }
        if (brandIds != null && !brandIds.isEmpty()) {
            sql.append("AND brand_id IN (<brandIds>) ");
        }
        if (useTimes != null && !useTimes.isEmpty()) {
            sql.append("AND useTime IN (<useTimes>) ");
        }

        if ("price_asc".equals(sort)) {
            sql.append("ORDER BY price ASC ");
        } else if ("price_desc".equals(sort)) {
            sql.append("ORDER BY price DESC ");
        } else if ("newest".equals(sort)) {
            sql.append("ORDER BY created_at DESC ");
        } else {
            sql.append("ORDER BY id ASC ");
        }

        return get().withHandle(handle -> {
            var q = handle.createQuery(sql.toString());
            q.bindList("wishlistIds", wishlistIds);
            if (categoryIds != null && !categoryIds.isEmpty()) {
                q.bindList("categoryIds", categoryIds);
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                q.bindList("brandIds", brandIds);
            }
            if (useTimes != null && !useTimes.isEmpty()) {
                q.bindList("useTimes", useTimes);
            }
            return q.mapToBean(Product.class).list();
        });
    }

    public List<Integer> getWishlistByUser(int userId) {
        return get().withHandle(handle -> {
            String sql = "SELECT product_id FROM wishlist WHERE user_id = :userId";
            return handle.createQuery(sql)
                    .bind("userId", userId)
                    .mapTo(Integer.class)
                    .list();
        });
    }

    public List<Product> getSuggestions(int userId, long minPrice, long maxPrice, int limit) {
        return get().withHandle(handle -> {
            String sql = "SELECT p.* " +
                    "FROM products p " +
                    "WHERE p.active = 1 " +
                    "AND p.stock > 0 " +
                    "AND p.ID NOT IN (SELECT product_id FROM wishlist WHERE user_id = :uid) " +
                    "AND p.price BETWEEN :minPrice AND :maxPrice " +
                    "ORDER BY p.sales_count DESC, p.createdAt DESC " +
                    "LIMIT :limit";

            return handle.createQuery(sql)
                    .bind("uid", userId)
                    .bind("minPrice", minPrice)
                    .bind("maxPrice", maxPrice)
                    .bind("limit", limit)
                    .mapToBean(Product.class)
                    .list();
        });
    }






    public List<Product> adminSearchByName(String keyword) {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT * FROM products 
                WHERE name LIKE :kw
                ORDER BY ID ASC 
            """).bind("kw", "%" + keyword + "%")
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public List<Product> getTopProducts(int limit) {
        return get().withHandle(handle -> {
            String sql = "SELECT p.* " +
                    "FROM products p " +
                    "WHERE p.active = 1 " +
                    "AND p.stock > 0 " +
                    "ORDER BY p.createdAt DESC " +   // hoặc sales_count DESC
                    "LIMIT :limit";

            return handle.createQuery(sql)
                    .bind("limit", limit)
                    .mapToBean(Product.class)
                    .list();
        });
    }


    public List<Product> getTopSellingProducts(int limit) {
        return get().withHandle(handle -> {
            String sql = "SELECT p.* " +
                    "FROM products p " +
                    "WHERE p.active = 1 " +
                    "AND p.stock > 0 " +
                    "ORDER BY p.sales_count DESC, p.createdAt DESC " +
                    "LIMIT :limit";

            return handle.createQuery(sql)
                    .bind("limit", limit)
                    .mapToBean(Product.class)
                    .list();
        });
    }


    //xóa dữ liệu trong bảng gallery và products dùng Transaction
    public boolean deleteProductWithGallery(int productId) {
        return get().inTransaction(handle -> {
            // xóa gallery trước
            handle.createUpdate("""
                 DELETE FROM gallary
                 WHERE product_id = :id
                 """).bind("id", productId)
                    .execute();

            // xóa products sau
            int rows = handle.createUpdate("""
                DELETE FROM products
                       WHERE ID = :id
                """)
                    .bind("id", productId)
                    .execute();

            return rows > 0;
        });
    }

    // Lấy tất cả danh sách các biến thể màu sắc thuộc cùng một nhóm sản phẩm cha
    public List<Product> getColorVariants(int parentId) {
        return get().withHandle(handle ->
                handle.createQuery("""
                                    SELECT 
                                        ID, 
                                        parent_id, 
                                        color_name, 
                                        color_code, 
                                        name, 
                                        price, 
                                        image, 
                                        stock 
                                    FROM products 
                                    WHERE (ID = :parentId OR parent_id = :parentId) 
                                      AND active = 1
                                    ORDER BY ID ASC
                                """)
                        .bind("parentId", parentId)
                        .mapToBean(Product.class)
                        .list()
        );
    }
}

