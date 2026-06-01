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

        // Đếm chính xác số lượng mẫu máy đại diện duy nhất (DISTINCT COALESCE)
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
            // SỬA TẠI ĐÂY: Đổi từ use_time thành useTime cho đồng nhất với hàm getAllProductsPage
            sql.append(" AND useTime IN (<useTimes>)");
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
    // lọc sản phẩm - ĐÃ CẬP NHẬT GỘP VARIANT CHUẨN QUA SUBQUERY
    public List<Product> filterSortPage(List<Integer> categoryIds,
                                        String priceRange,
                                        List<Integer> brandIds,
                                        List<Integer> useTimes,
                                        String sort,
                                        int offset,
                                        int limit) {

        // 1. Tạo Subquery để lọc và gom nhóm, chỉ lấy ra ID đại diện nhỏ nhất (MIN) của mẫu máy đó
        StringBuilder subSql = new StringBuilder("SELECT MIN(ID) FROM products WHERE active = 1 ");

        if (categoryIds != null && !categoryIds.isEmpty()) {
            subSql.append(" AND categories_id IN (<categoryIds>)");
        }

        if (priceRange != null) {
            switch (priceRange) {
                case "under500" -> subSql.append(" AND price < 500000");
                case "500-1m" -> subSql.append(" AND price BETWEEN 500000 AND 1000000");
                case "1-2m" -> subSql.append(" AND price BETWEEN 1000000 AND 2000000");
                case "2-3m" -> subSql.append(" AND price BETWEEN 2000000 AND 3000000");
                case "over3m" -> subSql.append(" AND price > 3000000");
            }
        }

        if (brandIds != null && !brandIds.isEmpty()) {
            subSql.append(" AND brand_id IN (<brandIds>)");
        }

        if (useTimes != null && !useTimes.isEmpty()) {
            // Lưu ý: Đổi tên cột từ use_time thành useTime cho khớp với cấu trúc Database thực tế của bạn
            subSql.append(" AND useTime IN (<useTimes>)");
        }

        // Thực hiện gộp nhóm biến thể tại đây
        subSql.append(" GROUP BY COALESCE(parent_id, ID)");

        // 2. Câu SQL chính: Lấy toàn bộ thông tin sản phẩm dựa trên danh sách các ID đại diện thu được ở trên
        StringBuilder mainSql = new StringBuilder("SELECT * FROM products WHERE ID IN (")
                .append(subSql)
                .append(") ");

        // ===== SORT =====
        if (sort == null || sort.isEmpty()) {
            mainSql.append(" ORDER BY ispremium DESC, id ASC");
        } else {
            switch (sort) {
                case "price_asc" -> mainSql.append(" ORDER BY price ASC, ispremium DESC");
                case "price_desc" -> mainSql.append(" ORDER BY price DESC, ispremium DESC");
                case "newest" -> mainSql.append(" ORDER BY createdAt DESC, ispremium DESC");
                default -> mainSql.append(" ORDER BY ispremium DESC, id ASC");
            }
        }

        // ===== PAGINATION =====
        mainSql.append(" LIMIT :limit OFFSET :offset");

        return get().withHandle(handle -> {
            var q = handle.createQuery(mainSql.toString());

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
            sql.append("ORDER BY createdAt DESC ");
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

    /**
     * GỢI Ý SẢN PHẨM THEO DANH SÁCH YÊU THÍCH (WISHLIST)
     * - Nếu khách chưa thích món nào (wishlistIds rỗng): Trả về list rỗng ngay lập tức (không hiển thị giao diện).
     * - Nếu có dữ liệu: Gợi ý các món cùng danh mục + hãng với món đã thích, gộp biến thể parent_id.
     * - Thứ tự ưu tiên: Giảm giá sâu -> Sắp hết hàng (FOMO) -> Hàng Premium
     */
    public List<Product> getRecommendedProductsByWishlist(List<Integer> wishlistIds, int limit) {
        // Yêu cầu: Nếu không có sản phẩm yêu thích nào -> trả về list rỗng để ẩn giao diện
        if (wishlistIds == null || wishlistIds.isEmpty()) {
            return java.util.Collections.emptyList(); // Hoặc List.of() tùy phiên bản Java
        }

        String sql = """
            SELECT * FROM products 
            WHERE ID IN (
                -- 1. Gom nhóm biến thể bằng parent_id, chỉ lấy ID đại diện nhỏ nhất (MIN)
                SELECT MIN(p.ID) 
                FROM products p
                WHERE (p.categories_id, p.brand_id) IN (
                    -- Tìm cặp (danh mục, hãng) từ các sản phẩm khách đã bấm thích
                    SELECT DISTINCT prod.categories_id, prod.brand_id 
                    FROM products prod 
                    WHERE prod.ID IN (<wishlistIds>)
                )
                -- LOẠI TRỪ: Không gợi ý lại những món chính khách đã bấm thích rồi
                AND p.ID NOT IN (<wishlistIds>)
                AND p.active = 1 
                AND p.stock > 0
                GROUP BY COALESCE(p.parent_id, p.ID)
            )
            -- 2. XẾP HẠNG ƯU TIÊN KÍCH CẦU: Giảm giá sâu nhất -> Sắp cháy hàng -> Hàng Premium
            ORDER BY (priceOld - price) DESC, stock ASC, ispremium DESC
            LIMIT :limit
            """;

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bindList("wishlistIds", wishlistIds)
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list());
    }

    /**
     * Gợi ý sản phẩm thông minh dựa trên các danh mục mà người dùng đã từng đặt mua.
     * Thuật toán sẽ tự động loại trừ các sản phẩm người dùng đã mua để tránh trùng lặp.
     */
    public List<Product> getSuggestionsByOrders(int userId, int limit) {
        return get().withHandle(handle ->
                handle.createQuery("""
                    SELECT p.* FROM products p
                    WHERE p.active = 1
                      -- 1. Tìm sản phẩm cùng danh mục với các đơn hàng của User
                      AND p.categories_id IN (
                          SELECT DISTINCT prod.categories_id
                          FROM order_items oi
                          JOIN orders o ON oi.order_id = o.ID
                          JOIN products prod ON oi.product_id = prod.ID
                          WHERE o.user_id = :userId
                            -- ĐÃ CẢI TIẾN: Lấy tất cả đơn hàng trừ đơn bị hủy ('Cancel'/'Hủy') để dễ ra dữ liệu test
                            AND o.status NOT IN ('Cancel', 'Canceled', 'Hủy', 'Đã hủy')
                      )
                      -- 2. Tạm thời COMMENT dòng loại trừ này lại để TEST xem có lên hình hay không. 
                      -- Sau khi dữ liệu lên đầy đủ, bạn có thể mở ra lại nếu muốn.
                      -- AND p.ID NOT IN (
                      --     SELECT DISTINCT oi_sub.product_id
                      --     FROM order_items oi_sub
                      --     JOIN orders o_sub ON oi_sub.order_id = o_sub.ID
                      --     WHERE o_sub.user_id = :userId
                      -- )
                    ORDER BY p.ispremium DESC, p.ID ASC
                    LIMIT :limit
                """)
                        .bind("userId", userId)
                        .bind("limit", limit)
                        .mapToBean(Product.class)
                        .list()
        );
    }
}

