CREATE DATABASE dulieubanhang
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE dulieubanhang;


-- 1. XÓA BẢNG CŨ

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS history, bill, payments, order_items, orders, reviews,
    gallary, products, otp_tokens, brands, categories, users, admin, about,
    discount, video, blog, banner, contact, icon, logo, wishlist, import_receipts,
    import_receipt_items, stock_movements, product_view_history, search_history,
    cart_items;

-- 2. TẠO CÁC BẢNG

CREATE TABLE admin (
                       ID INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       fullname VARCHAR(100),
                       status TINYINT DEFAULT 1
);

CREATE TABLE users (
                       ID INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(100) UNIQUE,
                       password VARCHAR(255),
                       email VARCHAR(255) UNIQUE,
                       fullname VARCHAR(255),
                       avatar VARCHAR(255),
                       date_of_birth DATE,
                       phoneNum VARCHAR(50),
                       location VARCHAR(255),
                       created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                       updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       lastLogin DATETIME,
                       active BOOLEAN DEFAULT TRUE
);


CREATE TABLE categories (
                            ID INT AUTO_INCREMENT PRIMARY KEY,
                            name VARCHAR(255),
                            description VARCHAR(255),
                            imgLink VARCHAR(255),
                            active BOOLEAN
);

CREATE TABLE brands (
                        ID INT AUTO_INCREMENT PRIMARY KEY,
                        brand_name VARCHAR(255),
                        active BOOLEAN,
                        CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Nhóm bảng thông tin giao diện
CREATE TABLE logo ( ID INT AUTO_INCREMENT PRIMARY KEY, titleLogo VARCHAR(255), linkLogo VARCHAR(255) );
CREATE TABLE icon ( ID INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(255), link_icon VARCHAR(255), active BOOLEAN );
CREATE TABLE contact ( ID INT AUTO_INCREMENT PRIMARY KEY, gmail VARCHAR(255), phone VARCHAR(50), address VARCHAR(255) );
CREATE TABLE banner ( ID INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(255), link VARCHAR(255), active BOOLEAN );
CREATE TABLE blog ( ID INT AUTO_INCREMENT PRIMARY KEY, img VARCHAR(255), title VARCHAR(255), metatitle VARCHAR(255), description VARCHAR(255), active BOOLEAN, playorder INT );
CREATE TABLE video ( ID INT AUTO_INCREMENT PRIMARY KEY, active BOOLEAN, title VARCHAR(255) );
CREATE TABLE about ( id INT AUTO_INCREMENT PRIMARY KEY, section VARCHAR(50), title VARCHAR(255), description TEXT, image VARCHAR(255), icon VARCHAR(100), sort_order INT );
CREATE TABLE discount ( ID INT AUTO_INCREMENT PRIMARY KEY, discountcode VARCHAR(50), discointname VARCHAR(255), discountvalue FLOAT, startdate DATETIME DEFAULT CURRENT_TIMESTAMP, enddate DATETIME, status BOOLEAN, createat DATETIME, updateat DATETIME, minordervalue FLOAT, maxdiscount FLOAT, quantity INT );


CREATE TABLE products (
                          ID INT AUTO_INCREMENT PRIMARY KEY,
                          parent_id INT DEFAULT NULL,
                          color_name VARCHAR(50) DEFAULT NULL,
                          color_code VARCHAR(10) DEFAULT NULL,
                          categories_id INT,
                          brand_id INT,
                          name VARCHAR(255),
                          short_description VARCHAR(255),
                          full_description TEXT,
                          information TEXT,
                          price DECIMAL(18,2),
                          priceOld DECIMAL(18,2),
                          image VARCHAR(255),
                          createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
                          energy INT,
                          useTime INT,
                          weight INT,
                          active BOOLEAN,
                          metatitle VARCHAR(255),
                          ispremium BOOLEAN,
                          suports VARCHAR(255),
                          connect VARCHAR(255),
                          endow TEXT,
                          FOREIGN KEY (parent_id) REFERENCES products(ID) ON DELETE SET NULL,
                          FOREIGN KEY (categories_id) REFERENCES categories(ID),
                          FOREIGN KEY (brand_id) REFERENCES brands(ID)
);

CREATE TABLE otp_tokens (
                            id INT AUTO_INCREMENT PRIMARY KEY,
                            user_id INT NOT NULL,
                            otp_hash VARCHAR(255) NOT NULL,
                            expired_at DATETIME NOT NULL,
                            used BOOLEAN NOT NULL DEFAULT FALSE,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            FOREIGN KEY (user_id) REFERENCES users(ID)
);

CREATE TABLE gallary (
                         ID INT PRIMARY KEY AUTO_INCREMENT,
                         product_id INT,
                         metatitle VARCHAR(255),
                         img VARCHAR(255) NOT NULL,
                         FOREIGN KEY (product_id) REFERENCES products(ID)
);

-- ===================== CHÂU (30/05) =====================
CREATE TABLE  (
                         ID INT PRIMARY KEY AUTO_INCREMENT,
                         products_id INT NOT NULL,
                         users_id INT NOT NULL,
                         order_id INT NOT NULL,
                         rating INT NOT NULL,
                         review_text TEXT,
                         imgReviews VARCHAR(255),
                         reviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                         status BOOLEAN DEFAULT TRUE,
                         CONSTRAINT fk_review_product FOREIGN KEY (products_id) REFERENCES products(ID),
                         CONSTRAINT fk_review_user FOREIGN KEY (users_id) REFERENCES users(ID),
                         CONSTRAINT fk_review_order FOREIGN KEY (order_id) REFERENCES orders(ID),
                         CONSTRAINT uq_review_once UNIQUE (order_id, products_id, users_id)
);

CREATE TABLE orders (
                        ID INT AUTO_INCREMENT PRIMARY KEY,
                        user_id INT,
                        order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                        status VARCHAR(50) DEFAULT 'Pending', -- Chờ duyệt, Đã thanh toán, Đang giao...
                        total_amount DECIMAL(18,2),-- Tổng tiền cuối cùng của cả đơn hàng

    -- Thông tin người nhận (Nên có vì đôi khi khách mua tặng người khác)
                        fullname_order VARCHAR(255),
                        phone_order VARCHAR(50),
                        address_order VARCHAR(255),
                        email_order VARCHAR(255),
                        note TEXT,                -- Ghi chú của khách

                        FOREIGN KEY (user_id) REFERENCES users(ID)
);

CREATE TABLE order_items (
                             id INT AUTO_INCREMENT PRIMARY KEY,
                             order_id INT NOT NULL,               -- Liên kết với orders(ID)
                             product_id INT NOT NULL,             -- Liên kết với products(ID)
                             quantity INT NOT NULL,               -- Số lượng của món này
                             price_at_purchase DECIMAL(18,2),     -- Giá tại thời điểm mua (để sau này sản phẩm tăng giá thì đơn cũ không bị sai)

                             FOREIGN KEY (order_id) REFERENCES orders(ID) ON DELETE CASCADE,
                             FOREIGN KEY (product_id) REFERENCES products(ID)
);

CREATE TABLE payments (
                          ID INT AUTO_INCREMENT PRIMARY KEY,
                          orders_id INT,
--HUỲNH NHƯ (18/05 - 30/05)
                          payment_method VARCHAR(100),
                          payment_status VARCHAR(100) DEFAULT 'Unpaid',
                          payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                          transaction_id VARCHAR(255),
                          FOREIGN KEY (orders_id) REFERENCES orders(ID)
);

CREATE TABLE bill (
                      ID INT AUTO_INCREMENT PRIMARY KEY,
                      payments_id INT,
                      bill_create DATETIME DEFAULT CURRENT_TIMESTAMP,
                      FOREIGN KEY (payments_id) REFERENCES payments(ID) ON DELETE CASCADE
);

CREATE TABLE history (
                         ID INT AUTO_INCREMENT PRIMARY KEY,
                         user_id INT,
                         bill_id INT,
                         order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                         status VARCHAR(100),
                         total_amount DECIMAL(18,2),
                         FOREIGN KEY (user_id) REFERENCES users(ID),
                         FOREIGN KEY (bill_id) REFERENCES bill(ID)
);

CREATE TABLE wishlist (
                          ID INT AUTO_INCREMENT PRIMARY KEY,
                          user_id INT NOT NULL,
                          product_id INT NOT NULL,
                          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                          CONSTRAINT fk_wishlist_user FOREIGN KEY (user_id) REFERENCES users(ID) ON DELETE CASCADE,
                          CONSTRAINT fk_wishlist_product FOREIGN KEY (product_id) REFERENCES products(ID) ON DELETE CASCADE,
                          UNIQUE KEY uq_user_product (user_id, product_id)
);

CREATE TABLE search_history (
                                id INT AUTO_INCREMENT PRIMARY KEY,
                                user_id INT NOT NULL,
                                keyword VARCHAR(255) NOT NULL,
                                searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                                UNIQUE KEY unique_user_keyword (user_id, keyword)
);

CREATE TABLE cart_items (
                            id INT AUTO_INCREMENT PRIMARY KEY,
                            user_id INT NOT NULL,
                            product_id INT NOT NULL,
                            product_name VARCHAR(255),
                            quantity INT NOT NULL,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            FOREIGN KEY (user_id) REFERENCES users(ID) ON DELETE CASCADE,
                            FOREIGN KEY (product_id) REFERENCES products(ID) ON DELETE CASCADE,
                            UNIQUE KEY uq_user_product (user_id, product_id) -- mỗi user chỉ có 1 dòng cho 1 sản phẩm
);

-- 3. THÊM DỮ LIỆU

INSERT INTO admin(username, password, fullname)
VALUES ('Admin', '$2a$10$EsoqYldgsgbopnxoOvxf7ujIcrjbb.BX5v86K9JCzC6s4PUtfC3hm', N'Administrator');


INSERT INTO video VALUES
    (1, 1, 'Video giới thiệu');


-- CATEGORIES
INSERT INTO categories (name, description, imgLink, active)
VALUES
-- Nhóm 1: Các máy thuần cắm TV hoặc cấu hình khủng
('Home Console',
 'Các dòng máy chơi game gia đình công suất lớn: PlayStation 5, Xbox Series X...',
 'https://m.media-amazon.com/images/I/51YXZgm0DbL._AC_SL1000_.jpg',
 1),

-- Nhóm 2: Các máy có màn hình, chơi mọi lúc mọi nơi
('Handheld Gaming',
 'Máy chơi game cầm tay: Nintendo Switch, Steam Deck, ROG Ally, MSI Claw, máy Retro...',
 'https://weirdstore.vn/wp-content/uploads/2024/03/n-2.jpg',
 1),

-- Nhóm 3: Các thiết bị điều khiển và bổ trợ
('Phụ kiện & Tay cầm',
 'Gamepad, kính VR, Dock sạc và các thiết bị hỗ trợ chơi game khác',
 'https://rptech.qa/cdn/shop/files/optimize_2_2048x.png?v=1734450756',
 1);

-- BRANDS
INSERT INTO brands (id, brand_name, active, createdAt) VALUES
                                                           (1, 'Sony', 1, NOW()),      -- Chuyên PlayStation
                                                           (2, 'Xbox', 1, NOW()),      -- Chuyên máy Microsoft
                                                           (3, 'Nintendo', 1, NOW()),  -- Chuyên Switch
                                                           (4, 'Valve', 1, NOW()),     -- Steam Deck
                                                           (5, 'Asus', 1, NOW()),      -- ROG Ally
                                                           (6, 'MSI', 1, NOW()),       -- MSI Claw
                                                           (7, 'Lenovo', 1, NOW()),    -- Legion Go
                                                           (8, 'Ayaneo', 1, NOW()),    -- Các dòng máy Ayaneo
                                                           (9, 'GPD', 1, NOW()),       -- GPD Win, Win Max
                                                           (10, 'Anbernic', 1, NOW()), -- Máy Retro (RG35XX...)
                                                           (12, 'Miyoo', 1, NOW()),
                                                           (13, 'Retroid', 1, NOW()),
                                                           (14, 'Flydigi', 1, NOW()),
                                                           (15, 'Aokzoe', 1, NOW()),
                                                           (11, 'Khác', 1, NOW());     -- Chỉ dành cho những món cực kỳ nhỏ lẻ

-- SONY (Brand 1)
-- 1. Bản PS5 Slim Standard (Có ổ đĩa) - SẢN PHẨM GỐC NHÓM PS5
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'White (Standard)', '#FFFFFF', 1, 1, 'PlayStation 5 Slim Standard Edition',
        'Máy chơi game thế hệ mới có ổ đĩa Blu-ray 4K.',
        'Thiết kế mới mỏng hơn 30%, ổ cứng 1TB và tích hợp ổ đĩa để chơi game vật lý.',
        'CPU: AMD Zen 2 8-core, GPU: 10.3 TFLOPS, RAM: 16GB GDDR6, SSD: 1TB Custom.',
        13500000, 14990000, 'https://www.droidshop.vn/wp-content/uploads/2024/01/s5-saps5-slim-standard.jpg',
        NOW(), 340, 24, 3200, 1, 'ps5-slim-standard', 1, '4K 120Hz, Ray Tracing', 'HDMI 2.1, WiFi 6', 'Tặng 1 tay cầm DualSense'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (1, 'https://www.droidshop.vn/wp-content/uploads/2023/11/may-ps5-standard-slim-247x300.jpg'),
                                          (1, 'https://www.droidshop.vn/wp-content/uploads/2024/01/s5-saps5-slim-standard-247x300.jpg'),
                                          (1, 'https://www.droidshop.vn/wp-content/uploads/2024/01/may-choi-game-PS5-Slim-Standard-kem-game-Fortnite-Cobalt-Star-Bundle-247x300.jpg'),
                                          (1, 'https://www.droidshop.vn/wp-content/uploads/2024/01/may-choi-game-PS5-Slim-Standard-kem-game-Astro-Bot-Bundle-247x300.jpg');


-- 2. Bản PS5 Slim Digital (Không ổ đĩa) - BIẾN THỂ CỦA ID 1
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        1, 'White (Digital)', '#F5F5F5', 1, 1, 'PlayStation 5 Slim Digital Edition',
        'Phiên bản kỹ thuật số mỏng nhẹ, không ổ đĩa.',
        'Trải nghiệm sức mạnh tương đương bản Standard trong một thiết kế đối xứng và gọn gàng hơn.',
        'CPU: AMD Zen 2 8-core, GPU: 10.3 TFLOPS, RAM: 16GB GDDR6, SSD: 1TB Custom.',
        11500000, 12990000, 'https://www.droidshop.vn/wp-content/uploads/2024/01/may-choi-game-PS5-Slim-Digital-247x300.jpg',
        NOW(), 340, 24, 2600, 1, 'ps5-slim-digital', 1, '4K 120Hz, Ray Tracing', 'HDMI 2.1, WiFi 6', 'Voucher giảm giá game Digital'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (2, 'https://www.droidshop.vn/wp-content/uploads/2024/10/May-PS5-slim-digital-Call-of-Duty-Black-Ops-6--247x300.jpg'),
                                          (2, 'https://www.droidshop.vn/wp-content/uploads/2024/01/s5-saps5-slim-standard-247x300.jpg'),
                                          (2, 'https://www.droidshop.vn/wp-content/uploads/2024/01/may-choi-game-PS5-Digital-Slim-Fortnite-247x300.jpg'),
                                          (2, 'https://droidshop.vn/wp-content/uploads/2024/01/may-choi-game-PS5-Digital-Slim-Fortnite-247x300.jpg');


-- 3. PlayStation Portal Remote Player - ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Standard White', '#FFFFFF', 2, 1, 'PlayStation Portal Remote Player',
        'Thiết bị chơi game từ xa.',
        'Chơi các trò chơi PS5 thông qua mạng WiFi.',
        'Màn hình 8 inch',
        5500000, 5990000, 'https://www.droidshop.vn/wp-content/uploads/2023/11/May-choi-game-cam-tay-Sony-PlayStation-Portal.jpg',
        NOW(), 4370, 5, 540, 1, 'ps-portal', 0, 'Kết nối PS5', 'WiFi', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (3, 'https://www.droidshop.vn/wp-content/uploads/2025/03/may-ps-portal-den-midnight.jpg'),
                                          (3, 'https://www.droidshop.vn/wp-content/uploads/2025/03/may-ps-portal-den-midnight-black-247x300.jpg'),
                                          (3, 'https://www.droidshop.vn/wp-content/uploads/2023/11/May-choi-game-cam-tay-Sony-PlayStation-Portal-6-247x300.jpg'),
                                          (3, 'https://www.droidshop.vn/wp-content/uploads/2023/11/May-choi-game-cam-tay-Sony-PlayStation-Portal-5-247x300.jpg'),
                                          (3, 'https://www.droidshop.vn/wp-content/uploads/2023/11/May-choi-game-cam-tay-Sony-PlayStation-Portal-4-247x300.jpg');

-- 4. PSP 3000 Series (Red/Black) - SẢN PHẨM GỐC NHÓM PSP 3000
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Red/Black', '#8B0000', 2, 1, 'Playstation Portable PSP 3000 Series Handheld Gaming Console System (Red/Black)',
        'Máy chơi game cầm tay huyền thoại của Sony với màn hình chống chói sắc nét.',
        'PSP 3000 là phiên bản hoàn thiện nhất của dòng PSP với màn hình LCD cải tiến, dải màu rộng và tích hợp microphone. Máy sở hữu kho game đồ sộ với các siêu phẩm như God of War, Tekken và Naruto. Thiết kế mỏng nhẹ, hỗ trợ đa phương tiện từ nghe nhạc đến xem phim, là biểu tượng không thể thay thế của giới game thủ.',
        'CPU: MIPS R4000 (333 MHz), RAM: 64MB, Màn hình: 4.3 inch LCD (16:9), Hỗ trợ thẻ nhớ Memory Stick Pro Duo.',
        2490000, 2990000, 'https://images-na.ssl-images-amazon.com/images/I/61zK8l4mebL.jpg',
        NOW(), 1200, 4, 189, 1, 'psp-3000-legend', 0, 'PSP Games, PS1 Classics, Movie/Music Player', 'Wi-Fi, Mini USB, 3.5mm Jack', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ hack full game và bao chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (4, 'https://images-na.ssl-images-amazon.com/images/I/61iqRFinOsL.jpg'),
                                          (4, 'https://images-na.ssl-images-amazon.com/images/I/61zK8l4mebL.jpg');


-- 5. PSP 3000 Series (Black) - BIẾN THỂ CỦA ID 4
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        4, 'Piano Black', '#000000', 2, 1, 'Playstation Portable PSP 3000 Series Handheld Gaming Console System (Black)',
        'Máy chơi game cầm tay huyền thoại của Sony với màn hình chống chói sắc nét.',
        'PSP 3000 là phiên bản hoàn thiện nhất của dòng PSP với màn hình LCD cải tiến, dải màu rộng và tích hợp microphone. Máy sở hữu kho game đồ sộ với các siêu phẩm như God of War, Tekken và Naruto. Thiết kế mỏng nhẹ, hỗ trợ đa phương tiện từ nghe nhạc đến xem phim, là biểu tượng không thể thay thế của giới game thủ.',
        'CPU: MIPS R4000 (333 MHz), RAM: 64MB, Màn hình: 4.3 inch LCD (16:9), Hỗ trợ thẻ nhớ Memory Stick Pro Duo.',
        2490000, 2990000, 'https://images-na.ssl-images-amazon.com/images/I/615gWr9r13L.jpg',
        NOW(), 1200, 4, 189, 1, 'psp-3000-legend', 0, 'PSP Games, PS1 Classics, Movie/Music Player', 'Wi-Fi, Mini USB, 3.5mm Jack', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ hack full game và bao chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (5, 'https://images-na.ssl-images-amazon.com/images/I/7162mjIToLL.jpg'),
                                          (5, 'https://images-na.ssl-images-amazon.com/images/I/61LhZBL-pfL.jpg'),
                                          (5, 'https://images-na.ssl-images-amazon.com/images/I/615gWr9r13L.jpg');


-- 6. PSP 3000 Series (Blue) - BIẾN THỂ CỦA ID 4
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        4, 'Vibrant Blue', '#1E90FF', 2, 1, 'Playstation Portable PSP 3000 Series Handheld Gaming Console System (Blue)',
        'Máy chơi game cầm tay huyền thoại của Sony với màn hình chống chói sắc nét.',
        'PSP 3000 là phiên bản hoàn thiện nhất của dòng PSP với màn hình LCD cải tiến, dải màu rộng và tích hợp microphone. Máy sở hữu kho game đồ sộ với các siêu phẩm như God of War, Tekken và Naruto. Thiết kế mỏng nhẹ, hỗ trợ đa phương tiện từ nghe nhạc đến xem phim, là biểu tượng không thể thay thế của giới game thủ.',
        'CPU: MIPS R4000 (333 MHz), RAM: 64MB, Màn hình: 4.3 inch LCD (16:9), Hỗ trợ thẻ nhớ Memory Stick Pro Duo.',
        2490000, 2990000, 'https://images-na.ssl-images-amazon.com/images/I/61Zhq8U5wSL.jpg',
        NOW(), 1200, 4, 189, 1, 'psp-3000-legend', 0, 'PSP Games, PS1 Classics, Movie/Music Player', 'Wi-Fi, Mini USB, 3.5mm Jack', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ hack full game và bao chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (6, 'https://images-na.ssl-images-amazon.com/images/I/61G02teTbZL.jpg'),
                                          (6, 'https://images-na.ssl-images-amazon.com/images/I/61Zhq8U5wSL.jpg');


-- 7. PSP 3000 Series (Lavender) - BIẾN THỂ CỦA ID 4
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        4, 'Lavender Purple', '#E6E6FA', 2, 1, 'Playstation Portable PSP 3000 Series Handheld Gaming Console System (Lavender)',
        'Máy chơi game cầm tay huyền thoại của Sony với màn hình chống chói sắc nét.',
        'PSP 3000 là phiên bản hoàn thiện nhất của dòng PSP với màn hình LCD cải tiến, dải màu rộng và tích hợp microphone. Máy sở hữu kho game đồ sộ với các siêu phẩm như God of War, Tekken và Naruto. Thiết kế mỏng nhẹ, hỗ trợ đa phương tiện từ nghe nhạc đến xem phim, là biểu tượng không thể thay thế của giới game thủ.',
        'CPU: MIPS R4000 (333 MHz), RAM: 64MB, Màn hình: 4.3 inch LCD (16:9), Hỗ trợ thẻ nhớ Memory Stick Pro Duo.',
        2490000, 2990000, 'https://images-na.ssl-images-amazon.com/images/I/61f5+8xNILL.jpg',
        NOW(), 1200, 4, 189, 1, 'psp-3000-legend', 0, 'PSP Games, PS1 Classics, Movie/Music Player', 'Wi-Fi, Mini USB, 3.5mm Jack', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ hack full game và bao chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (7, 'https://images-na.ssl-images-amazon.com/images/I/611cOGas8wL.jpg'),
                                          (7, 'https://images-na.ssl-images-amazon.com/images/I/61f5+8xNILL.jpg');


-- 8. PSP 3000 Series (Mystic Silver) - BIẾN THỂ CỦA ID 4
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        4, 'Mystic Silver', '#C0C0C0', 2, 1, 'Playstation Portable PSP 3000 Series Handheld Gaming Console System (Mystic Silver)',
        'Máy chơi game cầm tay huyền thoại của Sony với màn hình chống chói sắc nét.',
        'PSP 3000 là phiên bản hoàn thiện nhất của dòng PSP với màn hình LCD cải tiến, dải màu rộng và tích hợp microphone. Máy sở hữu kho game đồ sộ với các siêu phẩm như God of War, Tekken và Naruto. Thiết kế mỏng nhẹ, hỗ trợ đa phương tiện từ nghe nhạc đến xem phim, là biểu tượng không thể thay thế của giới game thủ.',
        'CPU: MIPS R4000 (333 MHz), RAM: 64MB, Màn hình: 4.3 inch LCD (16:9), Hỗ trợ thẻ nhớ Memory Stick Pro Duo.',
        2490000, 2990000, 'https://images-na.ssl-images-amazon.com/images/I/71G8OBFzzdL.jpg',
        NOW(), 1200, 4, 189, 1, 'psp-3000-legend', 0, 'PSP Games, PS1 Classics, Movie/Music Player', 'Wi-Fi, Mini USB, 3.5mm Jack', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ hack full game và bao chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
    (8, 'https://images-na.ssl-images-amazon.com/images/I/71G8OBFzzdL.jpg');


-- 9. PSP 3000 Series (Pink) - BIẾN THỂ CỦA ID 4
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        4, 'Blossom Pink', '#FFC0CB', 2, 1, 'Playstation Portable PSP 3000 Series Handheld Gaming Console System (Pink)',
        'Máy chơi game cầm tay huyền thoại của Sony với màn hình chống chói sắc nét.',
        'PSP 3000 là phiên bản hoàn thiện nhất của dòng PSP với màn hình LCD cải tiến, dải màu rộng và tích hợp microphone. Máy sở hữu kho game đồ sộ với các siêu phẩm như God of War, Tekken và Naruto. Thiết kế mỏng nhẹ, hỗ trợ đa phương tiện từ nghe nhạc đến xem phim, là biểu tượng không thể thay thế của giới game thủ.',
        'CPU: MIPS R4000 (333 MHz), RAM: 64MB, Màn hình: 4.3 inch LCD (16:9), Hỗ trợ thẻ nhớ Memory Stick Pro Duo.',
        2490000, 2990000, 'https://images-na.ssl-images-amazon.com/images/I/6162YbFGdGL.jpg',
        NOW(), 1200, 4, 189, 1, 'psp-3000-legend', 0, 'PSP Games, PS1 Classics, Movie/Music Player', 'Wi-Fi, Mini USB, 3.5mm Jack', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ hack full game và bao chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (9, 'https://images-na.ssl-images-amazon.com/images/I/61yD0wuRNuL.jpg'),
                                          (9, 'https://images-na.ssl-images-amazon.com/images/I/6162YbFGdGL.jpg');


-- 10. PSP 3000 Series (Red) - BIẾN THỂ CỦA ID 4
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        4, 'Radiant Red', '#FF0000', 2, 1, 'Playstation Portable PSP 3000 Series Handheld Gaming Console System (Red)',
        'Máy chơi game cầm tay huyền thoại của Sony với màn hình chống chói sắc nét.',
        'PSP 3000 là phiên bản hoàn thiện nhất của dòng PSP với màn hình LCD cải tiến, dải màu rộng và tích hợp microphone. Máy sở hữu kho game đồ sộ với các siêu phẩm như God of War, Tekken và Naruto. Thiết kế mỏng nhẹ, hỗ trợ đa phương tiện từ nghe nhạc đến xem phim, là biểu tượng không thể thay thế của giới game thủ.',
        'CPU: MIPS R4000 (333 MHz), RAM: 64MB, Màn hình: 4.3 inch LCD (16:9), Hỗ trợ thẻ nhớ Memory Stick Pro Duo.',
        2490000, 2990000, 'https://images-na.ssl-images-amazon.com/images/I/61cdLoZ-i3L.jpg',
        NOW(), 1200, 4, 189, 1, 'psp-3000-legend', 0, 'PSP Games, PS1 Classics, Movie/Music Player', 'Wi-Fi, Mini USB, 3.5mm Jack', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ hack full game và bao chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (10, 'https://images-na.ssl-images-amazon.com/images/I/61ObUq-32hL.jpg'),
                                          (10, 'https://images-na.ssl-images-amazon.com/images/I/61cdLoZ-i3L.jpg');


-- 11. PSP 3000 Series (Spirited Green) - BIẾN THỂ CỦA ID 4
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        4, 'Spirited Green', '#00FF00', 2, 1, 'Playstation Portable PSP 3000 Series Handheld Gaming Console System (Spirited Green)',
        'Máy chơi game cầm tay huyền thoại của Sony với màn hình chống chói sắc nét.',
        'PSP 3000 là phiên bản hoàn thiện nhất của dòng PSP với màn hình LCD cải tiến, dải màu rộng và tích hợp microphone. Máy sở hữu kho game đồ sộ với các siêu phẩm như God of War, Tekken và Naruto. Thiết kế mỏng nhẹ, hỗ trợ đa phương tiện từ nghe nhạc đến xem phim, là biểu tượng không thể thay thế của giới game thủ.',
        'CPU: MIPS R4000 (333 MHz), RAM: 64MB, Màn hình: 4.3 inch LCD (16:9), Hỗ trợ thẻ nhớ Memory Stick Pro Duo.',
        2490000, 2990000, 'https://images-na.ssl-images-amazon.com/images/I/51vu-JOgIEL.jpg',
        NOW(), 1200, 4, 189, 1, 'psp-3000-legend', 0, 'PSP Games, PS1 Classics, Movie/Music Player', 'Wi-Fi, Mini USB, 3.5mm Jack', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ hack full game và bao chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (11, 'https://images-na.ssl-images-amazon.com/images/I/51cBxzFtlkL.jpg'),
                                          (11, 'https://images-na.ssl-images-amazon.com/images/I/51vu-JOgIEL.jpg');


-- 12. PSP 3000 Series (White) - BIẾN THỂ CỦA ID 4
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        4, 'Pearl White', '#FFFFFF', 2, 1, 'Playstation Portable PSP 3000 Series Handheld Gaming Console System (White)',
        'Máy chơi game cầm tay huyền thoại của Sony với màn hình chống chói sắc nét.',
        'PSP 3000 là phiên bản hoàn thiện nhất của dòng PSP với màn hình LCD cải tiến, dải màu rộng và tích hợp microphone. Máy sở hữu kho game đồ sộ với các siêu phẩm như God of War, Tekken và Naruto. Thiết kế mỏng nhẹ, hỗ trợ đa phương tiện từ nghe nhạc đến xem phim, là biểu tượng không thể thay thế của giới game thủ.',
        'CPU: MIPS R4000 (333 MHz), RAM: 64MB, Màn hình: 4.3 inch LCD (16:9), Hỗ trợ thẻ nhớ Memory Stick Pro Duo.',
        2490000, 2990000, 'https://images-na.ssl-images-amazon.com/images/I/61nUrv0K3cL.jpg',
        NOW(), 1200, 4, 189, 1, 'psp-3000-legend', 0, 'PSP Games, PS1 Classics, Movie/Music Player', 'Wi-Fi, Mini USB, 3.5mm Jack', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ hack full game và bao chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
    (12, 'https://images-na.ssl-images-amazon.com/images/I/61nUrv0K3cL.jpg');

-- 13. PlayStation Vita Slim (PCH-2000) - SẢN PHẨM GỐC NHÓM PS VITA
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Charcoal Black', '#212121', 2, 1, 'PlayStation Vita Slim (PCH-2000)',
        'Thế hệ kế thừa hoàn hảo với thiết kế mỏng nhẹ, pin bền và màn hình cảm ứng đa điểm.',
        'PS Vita Slim mang đến trải nghiệm chơi game hiện đại với 2 cần Analog thật thụ, mặt lưng cảm ứng và màn hình LCD tối ưu thời lượng pin. Máy hỗ trợ Remote Play với PS4 và sở hữu những tựa game đỉnh cao như Persona 4 Golden, Uncharted. Đây là thiết bị giải trí cầm tay mạnh mẽ nhất mà Sony từng sản xuất.',
        'CPU: 4-core ARM Cortex-A9, GPU: SGX543MP4+, RAM: 512MB, Màn hình: 5 inch LCD Touch, Bộ nhớ trong 1GB.',
        3590000, 4090000, 'https://i.pcmag.com/imagery/reviews/04msrlko2zn7stjp5qx4b3w-3-hero-image-gallery.fit_scale.size_1028x578.v1569471216.jpg',
        NOW(), 2210, 5, 219, 1, 'ps-vita-slim-2000', 1, 'PS Vita Games, PSP/PS1 Support, Remote Play PS4', 'Micro USB, Wi-Fi, Bluetooth 2.1', 'Bảo hành 6 tháng, Tặng kèm áo thẻ SD2Vita và thẻ nhớ 64GB full game'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (13, 'https://i.pcmag.com/imagery/reviews/04msrlko2zn7stjp5qx4b3w-5-hero-image-gallery.fit_scale.size_900x507.v1569471216.jpg'),
                                          (13, 'https://i.pcmag.com/imagery/reviews/04msrlko2zn7stjp5qx4b3w-6-hero-image-gallery.fit_scale.size_900x507.v1569471216.jpg'),
                                          (13, 'https://i.pcmag.com/imagery/reviews/04msrlko2zn7stjp5qx4b3w-7-hero-image-gallery.fit_scale.size_900x507.v1569471216.jpg'),
                                          (13, 'https://i.pcmag.com/imagery/reviews/04msrlko2zn7stjp5qx4b3w-8-hero-image-gallery.fit_scale.size_900x507.v1569471216.jpg');


-- 14. PS Vita Slim - Glacial White - Wi-fi (PCH-2000ZA22) - BIẾN THỂ CỦA ID 13
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        13, 'Glacial White', '#FAFAFA', 2, 1, 'PS Vita Slim - Glacial White - Wi-fi (PCH-2000ZA22)',
        'Thế hệ kế thừa hoàn hảo với thiết kế mỏng nhẹ, pin bền và màn hình cảm ứng đa điểm.',
        'PS Vita Slim mang đến trải nghiệm chơi game hiện đại với 2 cần Analog thật thụ, mặt lưng cảm ứng và màn hình LCD tối ưu thời lượng pin. Máy hỗ trợ Remote Play với PS4 và sở hữu những tựa game đỉnh cao như Persona 4 Golden, Uncharted. Đây là thiết bị giải trí cầm tay mạnh mẽ nhất mà Sony từng sản xuất.',
        'CPU: 4-core ARM Cortex-A9, GPU: SGX543MP4+, RAM: 512MB, Màn hình: 5 inch LCD Touch, Bộ nhớ trong 1GB.',
        3590000, 4090000, 'https://images-na.ssl-images-amazon.com/images/I/61KiYl9A3pL.jpg',
        NOW(), 2210, 5, 219, 1, 'ps-vita-slim-2000', 1, 'PS Vita Games, PSP/PS1 Support, Remote Play PS4', 'Micro USB, Wi-Fi, Bluetooth 2.1', 'Bảo hành 6 tháng, Tặng kèm áo thẻ SD2Vita và thẻ nhớ 64GB full game'
    );

INSERT INTO gallary (product_id, img) VALUES
    (14, 'https://images-na.ssl-images-amazon.com/images/I/61KiYl9A3pL.jpg');


-- 15. PlayStation Classic Mini - ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Classic Gray', '#A9A9A9', 1, 1, 'PlayStation Classic Mini',
        'Phiên bản mini của máy PS1 huyền thoại, cài sẵn 20 tựa game kinh điển.',
        'Sống lại những ký ức tuổi thơ với PlayStation Classic. Thiết kế mô phỏng chính xác chiếc máy PS1 nguyên bản nhưng với kích thước nhỏ hơn 45%. Máy đi kèm 2 tay cầm điều khiển cổ điển và cổng HDMI để kết nối dễ dàng với TV hiện đại.',
        'CPU: MediaTek MT8167A, RAM: 1GB, Flash: 16GB, Output: 720p/480p.',
        1990000, 2490000, 'https://product.hstatic.net/200000722513/product/untitled-1_6249db790c6548be9e10ea90aaf42298_6426ee9fa67f4884909e51ebea61e338_master.jpg',
        NOW(), 0, 24, 170, 1, 'playstation-classic-mini', 0, '20 Pre-loaded Games (Final Fantasy VII, Tekken 3...)', 'HDMI, Micro USB (Power)', 'Bảo hành 6 tháng, Tặng kèm bộ nguồn 5V và cáp HDMI'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (15, 'https://product.hstatic.net/200000722513/product/upload_b59bc630f9924aedac9ca92034993390_abf494876d564e14904eda0f6c6c2128_master.jpg'),
                                          (15, 'https://product.hstatic.net/200000722513/product/upload_d361928e26ff4a2a81dd30836dca051b_e241ffe8d3dc4b388ea61627684c23e9_master.jpg'),
                                          (15, 'https://product.hstatic.net/200000722513/product/upload_68d9aaaa50f4477fb776cff85347513c_7be09a93467742f78a2fcfa8953c46b4_master.jpg'),
                                          (15, 'https://product.hstatic.net/200000722513/product/upload_45583a53bcff45378704d0dab4bb4f61_489a8683b0e848f6945439c8f94c6fbb_master.jpg');
-- XBOX
-- 16. Xbox Wireless Gaming Controller – Carbon Black - SẢN PHẨM GỐC NHÓM TAY CẦM
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Carbon Black', '#1A1A1A', 3, 2, 'Xbox Wireless Gaming Controller (2025) - Carbon Black',
        'Tay cầm chơi game thế hệ mới từ Microsoft với màu đen Carbon sang trọng.',
        'Trải nghiệm thiết kế hiện đại của Xbox Wireless Controller với các bề mặt được điêu khắc tinh tế và hình học được tinh chỉnh để nâng cao sự thoải mái trong quá trình chơi game. Phím điều hướng D-pad lai mới giúp bạn bấm chính xác hơn.',
        'Kết nối: Xbox Wireless, Bluetooth. Tương thích: Xbox Series X|S, Xbox One, Windows 10/11, Android, iOS. Nguồn: 2 viên pin AA.',
        1590000, 1890000, 'https://images-na.ssl-images-amazon.com/images/I/615KnbjRmTL.jpg',
        NOW(), 0, 40, 287, 1, 'xbox-wireless-controller-2025-carbon-black', 1, 'Xbox, PC, Android, iOS', 'Bluetooth, Xbox Wireless, USB-C', 'Bảo hành 12 tháng, Tặng kèm 1 cặp pin AA'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (16, 'https://images-na.ssl-images-amazon.com/images/I/71+qeUWcMIL.jpg'),
                                          (16, 'https://images-na.ssl-images-amazon.com/images/I/61BvPsTQslL.jpg'),
                                          (16, 'https://images-na.ssl-images-amazon.com/images/I/7119HvQIilL.jpg'),
                                          (16, 'https://images-na.ssl-images-amazon.com/images/I/71WKmv53ICL.jpg'),
                                          (16, 'https://images-na.ssl-images-amazon.com/images/I/71CiGdm0bYL.jpg');


-- 17. Xbox Wireless Gaming Controller – Pulse Red - BIẾN THỂ CỦA ID 16
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        16, 'Pulse Red', '#FF0000', 3, 2, 'Xbox Wireless Gaming Controller (2025) - Pulse Red',
        'Tay cầm chơi game thế hệ mới từ Microsoft với phối màu đỏ Pulse rực rỡ.',
        'Trải nghiệm thiết kế hiện đại của Xbox Wireless Controller với các bề mặt được điêu khắc tinh tế và hình học được tinh chỉnh để nâng cao sự thoải mái trong quá trình chơi game.',
        'Kết nối: Xbox Wireless, Bluetooth. Tương thích: Xbox Series X|S, Xbox One, Windows 10/11, Android, iOS. Nguồn: 2 viên pin AA.',
        1690000, 1990000, 'https://images-na.ssl-images-amazon.com/images/I/61vpO3n1-tL.jpg',
        NOW(), 0, 40, 287, 1, 'xbox-wireless-controller-2025-pulse-red', 1, 'Xbox, PC, Android, iOS', 'Bluetooth, Xbox Wireless, USB-C', 'Bảo hành 12 tháng, Tặng kèm 1 cặp pin AA'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (17, 'https://images-na.ssl-images-amazon.com/images/I/61c3l9MmEIL.jpg'),
                                          (17, 'https://images-na.ssl-images-amazon.com/images/I/61lmvOfVQpL.jpg'),
                                          (17, 'https://images-na.ssl-images-amazon.com/images/I/71et2LljNSL.jpg'),
                                          (17, 'https://images-na.ssl-images-amazon.com/images/I/71vOSm3QELL.jpg'),
                                          (17, 'https://images-na.ssl-images-amazon.com/images/I/71rkQDIHi7L.jpg');


-- 18. Xbox Wireless Gaming Controller – Robot White - BIẾN THỂ CỦA ID 16
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        16, 'Robot White', '#FFFFFF', 3, 2, 'Xbox Wireless Gaming Controller (2025) - Robot White',
        'Tay cầm chơi game thế hệ mới từ Microsoft với gam màu trắng Robot thanh lịch.',
        'Trải nghiệm thiết kế hiện đại của Xbox Wireless Controller với các bề mặt được điêu khắc tinh tế và hình học được tinh chỉnh để nâng cao sự thoải mái trong quá trình chơi game.',
        'Kết nối: Xbox Wireless, Bluetooth. Tương thích: Xbox Series X|S, Xbox One, Windows 10/11, Android, iOS. Nguồn: 2 viên pin AA.',
        1590000, 1890000, 'https://images-na.ssl-images-amazon.com/images/I/61bh+T2v7SL.jpg',
        NOW(), 0, 40, 287, 1, 'xbox-wireless-controller-2025-robot-white', 1, 'Xbox, PC, Android, iOS', 'Bluetooth, Xbox Wireless, USB-C', 'Bảo hành 12 tháng, Tặng kèm 1 cặp pin AA'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (18, 'https://images-na.ssl-images-amazon.com/images/I/61H1SU8t1OL.jpg'),
                                          (18, 'https://images-na.ssl-images-amazon.com/images/I/61qjDq2Eg9L.jpg'),
                                          (18, 'https://images-na.ssl-images-amazon.com/images/I/715IVCgH7qL.jpg'),
                                          (18, 'https://images-na.ssl-images-amazon.com/images/I/61znnrMbvjL.jpg'),
                                          (18, 'https://images-na.ssl-images-amazon.com/images/I/71k16Xt4LVL.jpg');


-- 19. Xbox Wireless Gaming Controller – Shock Blue - BIẾN THỂ CỦA ID 16
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        16, 'Shock Blue', '#0000FF', 3, 2, 'Xbox Wireless Gaming Controller (2025) - Shock Blue',
        'Tay cầm chơi game thế mới từ Microsoft với màu xanh Shock lôi cuốn.',
        'Trải nghiệm thiết kế hiện đại của Xbox Wireless Controller với các bề mặt được điêu khắc tinh tế và hình học được tinh chỉnh để nâng cao sự thoải mái trong quá trình chơi game.',
        'Kết nối: Xbox Wireless, Bluetooth. Tương thích: Xbox Series X|S, Xbox One, Windows 10/11, Android, iOS. Nguồn: 2 viên pin AA.',
        1690000, 1990000, 'https://images-na.ssl-images-amazon.com/images/I/61NlIRlKo5L.jpg',
        NOW(), 0, 40, 287, 1, 'xbox-wireless-controller-2025-shock-blue', 1, 'Xbox, PC, Android, iOS', 'Bluetooth, Xbox Wireless, USB-C', 'Bảo hành 12 tháng, Tặng kèm 1 cặp pin AA'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (19, 'https://images-na.ssl-images-amazon.com/images/I/616Gecual1L.jpg'),
                                          (19, 'https://images-na.ssl-images-amazon.com/images/I/610N7XQw7gL.jpg'),
                                          (19, 'https://images-na.ssl-images-amazon.com/images/I/71ghkWUjqEL.jpg');


-- 20. Xbox Wireless Controller Storm Breaker Special Edition - BIẾN THỂ CỦA ID 16
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        16, 'Storm Breaker', '#4A4A4A', 3, 2, 'Microsoft Xbox Wireless Controller Storm Breaker Special Edition',
        'Phiên bản đặc biệt Storm Breaker độc đáo đầy mạnh mẽ cá tính.',
        'Sở hữu họa tiết nứt sấm sét độc quyền, lớp hoàn thiện nhám mờ cao cấp giúp chống trượt tay trong những trận đấu căng thẳng. Nút Share chuyên dụng tích hợp giúp ghi lại khoảnh khắc nhanh chóng.',
        'Kết nối: Xbox Wireless, Bluetooth. Tương thích: Xbox Series X|S, Xbox One, Windows, Android, iOS. Tính năng: Grip sần nhám tinh xảo.',
        1950000, 2250000, 'https://images-na.ssl-images-amazon.com/images/I/71jxD5B0u8L.jpg',
        NOW(), 0, 40, 290, 1, 'xbox-controller-storm-breaker-edition', 1, 'Xbox, PC, Android, iOS', 'Bluetooth, Xbox Wireless, USB-C', 'Bảo hành 12 tháng, Tặng kèm bao chống trầy'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (20, 'https://images-na.ssl-images-amazon.com/images/I/71rLbRVyP+L.jpg'),
                                          (20, 'https://images-na.ssl-images-amazon.com/images/I/61dccuoC+VL.jpg'),
                                          (20, 'https://images-na.ssl-images-amazon.com/images/I/71XpCVDQ5GL.jpg'),
                                          (20, 'https://images-na.ssl-images-amazon.com/images/I/817FvdS2tjL.jpg'),
                                          (20, 'https://images-na.ssl-images-amazon.com/images/I/71ak-9F-IML.jpg');


-- 21. Xbox Wireless Gaming Controller – Velocity Green - BIẾN THỂ CỦA ID 16
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        16, 'Velocity Green', '#00FF7F', 3, 2, 'Xbox Wireless Gaming Controller (2025) - Velocity Green',
        'Bừng sáng không gian chơi game của bạn với tông màu xanh lục bảo cá tính.',
        'Mang màu sắc xanh gaming đặc trưng nguyên bản của Xbox kết hợp với mặt sau màu trắng tinh tế. Các phím cò Trigger mang kết cấu vân nhám chống trượt hiệu quả.',
        'Kết nối: Xbox Wireless, Bluetooth. Tương thích: Xbox Series X|S, Xbox One, Windows 10/11, Android, iOS. Nguồn: 2 viên pin AA.',
        1690000, 1990000, 'https://images-na.ssl-images-amazon.com/images/I/61gwuRFORbL.jpg',
        NOW(), 0, 40, 287, 1, 'xbox-wireless-controller-velocity-green', 1, 'Xbox, PC, Android, iOS', 'Bluetooth, Xbox Wireless, USB-C', 'Bảo hành 12 tháng, Tặng kèm 1 cặp pin AA'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (21, 'https://images-na.ssl-images-amazon.com/images/I/61-euzvlraL.jpg'),
                                          (21, 'https://images-na.ssl-images-amazon.com/images/I/61yFXRq1BGL.jpg'),
                                          (21, 'https://images-na.ssl-images-amazon.com/images/I/715m3u4s4ZL.jpg'),
                                          (21, 'https://images-na.ssl-images-amazon.com/images/I/71V13xRKY3L.jpg'),
                                          (21, 'https://images-na.ssl-images-amazon.com/images/I/71JAtpKa4hL.jpg');


-- 23. Xbox Core Wireless Gaming Controller – Electric Volt - BIẾN THỂ CỦA ID 16
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        16, 'Electric Volt', '#CCFF00', 3, 2, 'Xbox Core Wireless Gaming Controller - Electric Volt Series X',
        'Nổi bật bứt phá cùng sắc vàng chanh Electric Volt rực rỡ sáng tạo.',
        'Mẫu tay cầm mang phối màu phá cách thời thượng với mặt trước màu vàng chanh chói lóa và cụm nút D-pad màu đen nhám lịch lãm, đem lại trải nghiệm cầm nắm cực đầm tay.',
        'Kết nối: Xbox Wireless, Bluetooth. Tương thích: Xbox Series X|S, Xbox One, Windows 10/11, Android, iOS. Nguồn: pin AA.',
        1690000, 1990000, 'https://images-na.ssl-images-amazon.com/images/I/511p8oS7pPL.jpg',
        NOW(), 0, 40, 287, 1, 'xbox-controller-electric-volt-series-x', 1, 'Xbox, PC, Android, iOS', 'Bluetooth, Xbox Wireless, USB-C', 'Bảo hành 12 tháng, Tặng kèm pin sạc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (23, 'https://images-na.ssl-images-amazon.com/images/I/513xljThwZL.jpg'),
                                          (23, 'https://images-na.ssl-images-amazon.com/images/I/510A6UM3RDL.jpg'),
                                          (23, 'https://images-na.ssl-images-amazon.com/images/I/41AqfP8utdL.jpg'),
                                          (23, 'https://images-na.ssl-images-amazon.com/images/I/51hFzk7eKTL.jpg'),
                                          (23, 'https://images-na.ssl-images-amazon.com/images/I/619+XDyZ-ML.jpg');


-- 24. Xbox Wireless Gaming Controller – Fallout Pip-Boy Edition - BIẾN THỂ CỦA ID 16
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        16, 'Fallout Pip-Boy', '#6E8B3D', 3, 2, 'Xbox Wireless Gaming Controller - Fallout Pip-Boy Edition',
        'Phiên bản giới hạn siêu hiếm dành cho các tín đồ ruột của dòng game Fallout.',
        'Thiết kế được lấy cảm hứng từ cỗ máy đeo tay Pip-Boy trong thế giới hậu tận thế Fallout bụi bặm, đậm chất sinh tồn.',
        'Kết nối: Xbox Wireless, Bluetooth. Tương thích: Xbox Series X|S, PC, Mobile. Phiên bản giới hạn sưu tầm.',
        2100000, 2500000, 'https://images-na.ssl-images-amazon.com/images/I/71NuYPkE0zL.jpg',
        NOW(), 0, 40, 295, 1, 'xbox-controller-fallout-pipboy-edition', 1, 'Xbox Games, PC Games', 'Bluetooth, Xbox Wireless, USB-C', 'Bảo hành 12 tháng, Tặng kèm móc khóa Fallout'
    );

INSERT INTO gallary (product_id, img) VALUES
    (24, 'https://images-na.ssl-images-amazon.com/images/I/71NuYPkE0zL.jpg');


-- 25. Xbox Wireless Controller Heart Breaker Special Edition - BIẾN THỂ CỦA ID 16
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        16, 'Heart Breaker Pink', '#FF69B4', 3, 2, 'Xbox Wireless Controller Heart Breaker Special Edition',
        'Gam màu hồng ngọt ngào quyến rũ nhưng ẩn chứa sức mạnh đột phá.',
        'Thiết kế bề mặt nhám mịn phối hồng bắt mắt, thích hợp cho các streamer và game thủ yêu thích sự độc đáo mới mẻ, nút Hybrid D-pad tăng tốc phản xạ.',
        'Kết nối: Xbox Wireless, Bluetooth. Tương thích: Xbox Series X|S, Windows 10/11, iOS, Android. Kết cấu tay cầm cải tiến chống trượt.',
        1850000, 2150000, 'https://images-na.ssl-images-amazon.com/images/I/71M7CxIFX6L.jpg',
        NOW(), 0, 40, 287, 1, 'xbox-controller-heart-breaker-special', 1, 'Xbox, PC, Android, iOS', 'Bluetooth, Xbox Wireless, USB-C', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (25, 'https://images-na.ssl-images-amazon.com/images/I/7196FGtO-vL.jpg'),
                                          (25, 'https://images-na.ssl-images-amazon.com/images/I/61VLXGjPq6L.jpg'),
                                          (25, 'https://images-na.ssl-images-amazon.com/images/I/71bbhz-4lXL.jpg'),
                                          (25, 'https://images-na.ssl-images-amazon.com/images/I/71veA78UijL.jpg'),
                                          (25, 'https://images-na.ssl-images-amazon.com/images/I/71ByGIOJ+hL.jpg');


-- 26. Xbox Wireless Controller Ice Breaker Special Edition - BIẾN THỂ CỦA ID 16
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        16, 'Ice Breaker Blue', '#AFEEEE', 3, 2, 'Xbox Wireless Controller Ice Breaker Special Edition',
        'Sắc xanh băng tuyết tươi mát làm dịu đi những giây phút leo rank căng thẳng.',
        'Phiên bản phối màu Ice Breaker dịu mát mang kết cấu nhám nhẹ phân bổ đều phần cò bấm. Hỗ trợ jack cắm tai nghe âm thanh nổi 3.5mm tiện dụng.',
        'Kết nối: Xbox Wireless, Bluetooth. Tương thích: Xbox Series X|S, Windows 10/11, iOS, Android.',
        1850000, 2150000, 'https://images-na.ssl-images-amazon.com/images/I/71Js3hjffrL.jpg',
        NOW(), 0, 40, 287, 1, 'xbox-controller-ice-breaker-special', 1, 'Xbox, PC, Android, iOS', 'Bluetooth, Xbox Wireless, USB-C', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (26, 'https://images-na.ssl-images-amazon.com/images/I/71TmT75-0JL.jpg'),
                                          (26, 'https://images-na.ssl-images-amazon.com/images/I/6193qjhq++L.jpg'),
                                          (26, 'https://images-na.ssl-images-amazon.com/images/I/71DWxbfCUWL.jpg'),
                                          (26, 'https://images-na.ssl-images-amazon.com/images/I/71NiThMNLxL.jpg'),
                                          (26, 'https://images-na.ssl-images-amazon.com/images/I/71I07+6nbKL.jpg');


-- 27. Xbox Wireless Controller – Pulse Cipher - BIẾN THỂ CỦA ID 16
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        16, 'Pulse Cipher (Translucent)', '#800080', 3, 2, 'Xbox Wireless Controller - Pulse Cipher Special Edition Series X',
        'Thiết kế vỏ bán trong suốt thời thượng xuyên thấu các linh kiện cơ khí.',
        'Thuộc bộ sưu tập Cipher đình đám, sở hữu lớp vỏ nhựa cao cấp bán trong suốt màu đỏ tía rực rỡ, nhìn thấu được các chuyển động motor rung bên trong cực kỳ kích thích thị giác.',
        'Kết nối: Xbox Wireless, Bluetooth. Tương thích: Xbox Series X|S, PC, Mobile. Thiết kế Translucent độc đáo.',
        1950000, 2250000, 'https://images-na.ssl-images-amazon.com/images/I/713dRmmJrwL.jpg',
        NOW(), 0, 40, 290, 1, 'xbox-controller-pulse-cipher-edition', 1, 'Xbox, PC, Android, iOS', 'Bluetooth, Xbox Wireless, USB-C', 'Bảo hành 12 tháng, Tặng cáp bọc dù cao cấp'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (27, 'https://images-na.ssl-images-amazon.com/images/I/71M0fyUJ93L.jpg'),
                                          (27, 'https://images-na.ssl-images-amazon.com/images/I/714fuPd+PAL.jpg'),
                                          (27, 'https://images-na.ssl-images-amazon.com/images/I/81EqQUvXXpL.jpg'),
                                          (27, 'https://images-na.ssl-images-amazon.com/images/I/71iNaF67arL.jpg'),
                                          (27, 'https://images-na.ssl-images-amazon.com/images/I/7129vpjXFiL.jpg');

-- 28. Xbox Series S 1TB - Black - SẢN PHẨM GỐC NHÓM SERIES S
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Carbon Black', '#1A1A1A', 1, 2, 'Xbox Series S 1TB - Black',
        'Phiên bản nhỏ gọn với dung lượng lưu trữ gấp đôi, màu đen sang trọng.',
        'Xbox Series S bản 1TB mang đến không gian lưu trữ rộng lớn cho các tựa game Next-gen. Thiết kế không ổ đĩa cực kỳ nhỏ gọn, hỗ trợ tốc độ khung hình lên đến 120FPS và tính năng Quick Resume giúp chuyển đổi game tức thì.',
        'CPU: 8-Core AMD Zen 2, GPU: 4 TFLOPS RDNA 2, RAM: 10GB GDDR6, SSD: 1TB NVMe.',
        8990000, 9990000, 'https://haloshop.vn/wp-content/uploads/2025/04/Xbox-Series-S-black.webp',
        NOW(), 165, 24, 1950, 1, 'xbox-series-s-1tb-black', 0, 'Xbox Games, Xbox Game Pass, Quick Resume', 'HDMI 2.1, Wi-Fi 5, USB-A, LAN', 'Bảo hành 12 tháng, Tặng kèm tay cầm Wireless Controller'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (28, 'https://haloshop.vn/wp-content/uploads/2025/02/xbox-series-s-black-41-700x700-1.jpg'),
                                          (28, 'https://haloshop.vn/wp-content/uploads/2025/02/xbox-series-s-black-42-700x700-1.jpg'),
                                          (28, 'https://haloshop.vn/wp-content/uploads/2025/02/xbox-series-s-black-43-700x700-1.jpg'),
                                          (28, 'https://haloshop.vn/wp-content/uploads/2025/02/xbox-series-s-42-700x700-1-300x300.jpg');


-- 29. Xbox Series S SSD 1TB – White - BIẾN THỂ CỦA ID 28
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        28, 'Robot White', '#FFFFFF', 1, 2, 'Xbox Series S SSD 1TB - White',
        'Phiên bản nhỏ gọn với dung lượng lưu trữ lớn, màu trắng tuyết thanh lịch.',
        'Xbox Series S bản 1TB mang đến không gian lưu trữ rộng lớn cho các tựa game Next-gen. Thiết kế không ổ đĩa cực kỳ nhỏ gọn, hỗ trợ tốc độ khung hình lên đến 120FPS và tính năng Quick Resume giúp chuyển đổi game tức thì.',
        'CPU: 8-Core AMD Zen 2, GPU: 4 TFLOPS RDNA 2, RAM: 10GB GDDR6, SSD: 1TB NVMe.',
        8990000, 9990000, 'https://haloshop.vn/wp-content/uploads/2025/04/Xbox-Series-S-white.webp',
        NOW(), 165, 24, 1950, 1, 'xbox-series-s-1tb-white', 0, 'Xbox Games, Xbox Game Pass, Quick Resume', 'HDMI 2.1, Wi-Fi 5, USB-A, LAN', 'Bảo hành 12 tháng, Tặng kèm tay cầm Wireless Controller'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (29, 'https://haloshop.vn/wp-content/uploads/2025/02/may_xbox_series_s_ssd_1tb_42-700x700-1.jpg'),
                                          (29, 'https://haloshop.vn/wp-content/uploads/2025/02/may_xbox_series_s_ssd_1tb_43-700x700-1.jpg'),
                                          (29, 'https://haloshop.vn/wp-content/uploads/2025/02/may_xbox_series_s_ssd_1tb_41-700x700-1.jpg');


-- 30. Xbox One S 1TB All-Digital Edition Console - ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'White', '#F5F5F5', 1, 2, 'Xbox One S 1TB All-Digital Edition Console with Xbox One Wireless Controller',
        'Phiên bản loại bỏ ổ đĩa vật lý, tối ưu cho thư viện game kỹ thuật số và Xbox Game Pass.',
        'Xbox One S 1TB All-Digital Edition mang đến trải nghiệm chơi game 4K streaming và lưu trữ đám mây tiện lợi. Với thiết kế trắng thanh lịch và nhỏ gọn, máy là lựa chọn hoàn hảo cho những game thủ yêu thích sự tối giản, không cần sử dụng đĩa vật lý mà vẫn tận hưởng được kho game khổng lồ.',
        'CPU: 1.75GHz 8-core AMD, GPU: 1.23 TFLOPS, RAM: 8GB DDR3, HDD: 1TB.',
        5490000, 6490000, 'https://images-na.ssl-images-amazon.com/images/I/61yMhsRTT-L.jpg',
        NOW(), 0, 24, 2900, 1, 'xbox-one-s-digital', 0, 'Xbox Game Pass, 4K Ultra HD Video Streaming, HDR10', 'HDMI 2.0, USB 3.0, Wi-Fi, Ethernet', 'Bảo hành 6 tháng, Tặng kèm mã code 3 tháng Xbox Game Pass Ultimate'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (30, 'https://images-na.ssl-images-amazon.com/images/I/51VYsn3wL6L.jpg'),
                                          (30, 'https://images-na.ssl-images-amazon.com/images/I/51k1a2O4KYL.jpg'),
                                          (30, 'https://images-na.ssl-images-amazon.com/images/I/41UTXSdnnoL.jpg');

-- NINTENDO
-- 31. Nintendo Switch - OLED Model: Mario Red Edition - SẢN PHẨM GỐC NHÓM OLED
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Mario Red', '#E60012', 2, 3, 'Nintendo Switch - OLED Model: Mario Red Edition',
        'Màn hình OLED 7 inch rực rỡ mang sắc đỏ huyền thoại của Mario.',
        'Phiên bản đặc biệt nâng cấp màn hình OLED với toàn bộ thân máy, dock sạc và tay cầm Joy-Con mang tông màu đỏ Mario đặc trưng.',
        '64GB, OLED Screen 7.0 inch', 7500000, 8500000, 'https://images-na.ssl-images-amazon.com/images/I/71vwxEAbq7L.jpg',
        NOW(), 4310, 9, 420, 1, 'switch-oled-mario-red', 1, 'Switch Games', 'WiFi', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (31, 'https://images-na.ssl-images-amazon.com/images/I/81c+7-0qsdL.jpg'),
                                          (31, 'https://images-na.ssl-images-amazon.com/images/I/81w-1wZ1bEL.jpg'),
                                          (31, 'https://images-na.ssl-images-amazon.com/images/I/71W0i14jHyL.jpg'),
                                          (31, 'https://images-na.ssl-images-amazon.com/images/I/41Q9Td3-niL.jpg'),
                                          (31, 'https://images-na.ssl-images-amazon.com/images/I/71qfEJRdgNL.jpg');


-- 32. Nintendo Switch – OLED Model w/Neon Red & Neon Blue Joy-Con - BIẾN THỂ CỦA ID 31
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        31, 'Neon Red & Neon Blue', '#00E5FF', 2, 3, 'Nintendo Switch - OLED Model w/Neon Red & Neon Blue Joy-Con',
        'Màn hình OLED 7 inch rực rỡ phối cùng cặp Joy-Con màu Neon truyền thống.',
        'Phiên bản nâng cấp màn hình OLED mang lại màu sắc sống động, độ tương phản cao cùng chân đế rộng có thể điều chỉnh linh hoạt.',
        '64GB, OLED Screen 7.0 inch', 7500000, 8500000, 'https://images-na.ssl-images-amazon.com/images/I/41ttIuh5SlL.jpg',
        NOW(), 4310, 9, 420, 1, 'switch-oled-neon', 1, 'Switch Games', 'WiFi', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (32, 'https://images-na.ssl-images-amazon.com/images/I/31y22S6+VjL.jpg'),
                                          (32, 'https://images-na.ssl-images-amazon.com/images/I/412v5cSlP1L.jpg'),
                                          (32, 'https://images-na.ssl-images-amazon.com/images/I/31JzoPxNVOL.jpg'),
                                          (32, 'https://images-na.ssl-images-amazon.com/images/I/31H83k97DQL.jpg'),
                                          (32, 'https://images-na.ssl-images-amazon.com/images/I/31tkggsYgZL.jpg');


-- 33. Nintendo Switch – OLED Model w/White Joy-Con - BIẾN THỂ CỦA ID 31
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        31, 'White', '#FFFFFF', 2, 3, 'Nintendo Switch - OLED Model w/White Joy-Con',
        'Màn hình OLED 7 inch rực rỡ đi kèm cặp Joy-Con màu trắng tuyết thanh lịch.',
        'Sở hữu dock sạc màu trắng và cặp Joy-Con trắng tinh tế, tạo nên vẻ ngoài thời thượng công nghệ cao cực kỳ hút mắt.',
        '64GB, OLED Screen 7.0 inch', 7500000, 8500000, 'https://images-na.ssl-images-amazon.com/images/I/61nqNujSF2L.jpg',
        NOW(), 4310, 9, 420, 1, 'switch-oled-white', 1, 'Switch Games', 'WiFi', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (33, 'https://images-na.ssl-images-amazon.com/images/I/61E4b5drxzS.jpg'),
                                          (33, 'https://images-na.ssl-images-amazon.com/images/I/6106vjwmtIS.jpg'),
                                          (33, 'https://images-na.ssl-images-amazon.com/images/I/719EZAc9WHS.jpg'),
                                          (33, 'https://images-na.ssl-images-amazon.com/images/I/71Sgq7L+AuS.jpg'),
                                          (33, 'https://images-na.ssl-images-amazon.com/images/I/61z-iuVjhdS.jpg');

-- 34. Nintendo Switch 2 System - ĐỘC LẬP THẾ HỆ MỚI
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Standard Gray', '#708090', 2, 3, 'Nintendo Switch 2 System',
        'Thế hệ máy tiếp theo bùng nổ hiệu năng.',
        'Màn hình LCD lớn lên tới 7.9 inch độ phân giải 1080p, nâng cấp phần cứng vượt trội chơi mượt các tựa game đồ họa nặng.',
        'Thế hệ máy console lai tiếp theo', 12350000, 13290000, 'https://images-na.ssl-images-amazon.com/images/I/714-Fh3ngmL.jpg',
        NOW(), 5220, 6, 534, 1, 'switch-2', 0, 'TV, Handheld', 'WiFi 6, Bluetooth 5.2', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (34, 'https://images-na.ssl-images-amazon.com/images/I/61+fkixBSfL.jpg'),
                                          (34, 'https://images-na.ssl-images-amazon.com/images/I/615ir3fm25L.jpg'),
                                          (34, 'https://images-na.ssl-images-amazon.com/images/I/71E-Pk8l8oL.jpg'),
                                          (34, 'https://images-na.ssl-images-amazon.com/images/I/71cXwQTj8tL.jpg'),
                                          (34, 'https://images-na.ssl-images-amazon.com/images/I/71BS3e5jgdL.jpg');

-- 35. Nintendo Switch V2 Neon Blue and Neon Red - SẢN PHẨM GỐC NHÓM SWITCH V2
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Classic Neon', '#FF3F80', 2, 3, 'Nintendo Switch with Neon Blue and Neon Red Joy - Con V2 (Red & Blue Switch)',
        'Phiên bản nâng cấp thời lượng pin, chơi game linh hoạt mọi lúc mọi nơi.',
        'Nintendo Switch V2 mang đến sự linh hoạt tuyệt vời khi có thể vừa chơi trên TV, vừa có thể cầm tay mang đi. Phiên bản này sử dụng chip mới tiết kiệm điện năng hơn, giúp kéo dài thời gian trải nghiệm các tựa game đình đám của Nintendo.',
        'Màn hình: 6.2 inch LCD, Chip: NVIDIA Tegra X1 Mariko, Bộ nhớ: 32GB (Hỗ trợ thẻ nhớ tối đa 2TB).',
        6890000, 7890000, 'https://images-na.ssl-images-amazon.com/images/I/71ZV093mf+L.jpg',
        NOW(), 4310, 5, 420, 1, 'nintendo-switch-v2-neon', 0, 'Nintendo Switch Online, Motion Control, Amiibo', 'USB-C, HDMI 2.0 (Dock), WiFi, Bluetooth 4.1', 'Bảo hành 12 tháng, Tặng cường lực và túi chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (35, 'https://images-na.ssl-images-amazon.com/images/I/71ulWn40eoL.jpg'),
                                          (35, 'https://images-na.ssl-images-amazon.com/images/I/71AAhKVX1XL.jpg'),
                                          (35, 'https://images-na.ssl-images-amazon.com/images/I/71Hwaj0mm4L.jpg'),
                                          (35, 'https://images-na.ssl-images-amazon.com/images/I/81XViKqXADL.jpg'),
                                          (35, 'https://images-na.ssl-images-amazon.com/images/I/71Fd-ZApwqL.jpg');


-- 36. Nintendo Switch Animal Crossing Edition - BIẾN THỂ CỦA ID 35
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        35, 'Animal Crossing Pastel', '#A0E6D2', 2, 3, 'Nintendo Switch Animal Crossing: New Horizons Edition',
        'Phiên bản giới hạn với thiết kế màu sắc Pastel độc đáo lấy cảm hứng từ tựa game Animal Crossing.',
        'Một trong những phiên bản đẹp nhất của dòng Switch với mặt lưng in họa tiết chìm, cặp Joy-Con màu xanh và lục nhạt cùng Dock sạc màu trắng in hình các nhân vật Nook Inc. Đây là món đồ không thể thiếu cho các tín đồ sưu tầm.',
        'Màn hình: 6.2 inch LCD, Bộ nhớ: 32GB, Pin: 4310 (Bản nâng cấp V2).',
        12239791, 12979056, 'https://images-na.ssl-images-amazon.com/images/I/61mp8du3B3L.jpg',
        NOW(), 4310, 5, 420, 1, 'nintendo-switch-animal-crossing', 1, 'Nintendo Switch Online, Motion Control, Amiibo', 'USB-C, HDMI 2.0 (Dock), WiFi, Bluetooth 4.1', 'Bảo hành 12 tháng, Tặng kèm dán cường lực và thẻ giảm giá mua game'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (36, 'https://images-na.ssl-images-amazon.com/images/I/51Pwi8IuerL.jpg'),
                                          (36, 'https://images-na.ssl-images-amazon.com/images/I/51YCX9d03pL.jpg'),
                                          (36, 'https://images-na.ssl-images-amazon.com/images/I/51+8WcQbg0L.jpg'),
                                          (36, 'https://images-na.ssl-images-amazon.com/images/I/51ON5O2XIVL.jpg'),
                                          (36, 'https://images-na.ssl-images-amazon.com/images/I/513ceArNGAL.jpg');

-- 37. Nintendo Super NES Classic Edition - ĐỘC LẬP RETRO
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Retro Gray', '#D3D3D3', 1, 3, 'Nintendo Super NES Classic Edition',
        'Cỗ máy 16-bit huyền thoại trở lại dưới dạng mini với 21 trò chơi cài sẵn.',
        'Nintendo Entertainment System Super NES Classic Edition mang phong cách hoài cổ đặc trưng của những năm 90. Chỉ cần cắm và chạy để thưởng thức các siêu phẩm như Super Mario World, Super Mario Kart và Zelda trên màn hình HD.',
        'CPU: Allwinner R16, RAM: 256MB, Màn hình hỗ trợ: 720p qua HDMI.',
        7517658, 7717658, 'https://images-na.ssl-images-amazon.com/images/I/41s70Zpc+vL.jpg',
        NOW(), 0, 24, 160, 1, 'snes-classic-mini', 0, '21 Pre-loaded Games, Save States support', 'HDMI, Classic Controller Port', 'Bảo hành 6 tháng, Tặng kèm tay cầm SNES thứ hai cho chơi đối kháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (37, 'https://images-na.ssl-images-amazon.com/images/I/41s70Zpc+vL.jpg'),
                                          (37, 'https://images-na.ssl-images-amazon.com/images/I/61iUHN17CLL.jpg'),
                                          (37, 'https://images-na.ssl-images-amazon.com/images/I/61mui-TEpcL.jpg'),
                                          (37, 'https://images-na.ssl-images-amazon.com/images/I/61oBmW-eseL.jpg'),
                                          (37, 'https://images-na.ssl-images-amazon.com/images/I/61tEsZmZxjL.jpg');

-- 38. Nintendo Switch Lite Coral - SẢN PHẨM GỐC NHÓM SWITCH LITE
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Coral', '#FF7F50', 2, 3, 'Nintendo Switch Lite Coral',
        'Máy cầm tay thuần túy màu San Hô.',
        'Nhẹ nhàng, thời trang, chuyên dụng cho di động.',
        '32GB Storage, 5.5 inch LCD', 3900000, 4500000, 'https://images-na.ssl-images-amazon.com/images/I/51a34cWPBhL.jpg',
        NOW(), 3570, 7, 275, 1, 'switch-lite-coral', 0, 'Switch Games', 'WiFi', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (38, 'https://images-na.ssl-images-amazon.com/images/I/61YPmmt0oFL.jpg'),
                                          (38, 'https://images-na.ssl-images-amazon.com/images/I/61x19lioQDL.jpg'),
                                          (38, 'https://images-na.ssl-images-amazon.com/images/I/61F+OXdBupL.jpg'),
                                          (38, 'https://images-na.ssl-images-amazon.com/images/I/51a34cWPBhL.jpg');


-- 39. Nintendo Switch Lite - Turquoise - BIẾN THỂ CỦA ID 38
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        38, 'Turquoise', '#40E0D0', 2, 3, 'Nintendo Switch Lite - Turquoise',
        'Máy cầm tay thuần túy màu Xanh ngọc.',
        'Nhẹ nhàng, thời trang, chuyên dụng cho di động.',
        '32GB Storage, 5.5 inch LCD', 3900000, 4500000, 'https://images-na.ssl-images-amazon.com/images/I/61owpat34dL.jpg',
        NOW(), 3570, 7, 275, 1, 'switch-lite-turquoise', 0, 'Switch Games', 'WiFi', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (39, 'https://images-na.ssl-images-amazon.com/images/I/71OzO+jdVnL.jpg'),
                                          (39, 'https://images-na.ssl-images-amazon.com/images/I/61tDKuK38zL.jpg'),
                                          (39, 'https://images-na.ssl-images-amazon.com/images/I/61noAVmvRjL.jpg'),
                                          (39, 'https://images-na.ssl-images-amazon.com/images/I/61JKcgKM0RL.jpg'),
                                          (39, 'https://images-na.ssl-images-amazon.com/images/I/81cH0W6NHdL.jpg');

-- 40. Nintendo Switch Pro Controller - PHỤ KIỆN ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Translucent Black', '#2F4F4F', 3, 3, 'Nintendo Switch Pro Controller',
        'Tay cầm không dây cao cấp dành cho hệ máy Switch.',
        'Mang lại trải nghiệm cầm nắm chắc chắn, chơi game chuyên nghiệp vượt trội trên Switch và PC.',
        'HD Rumble, NFC Amiibo, Gyro Sensor', 1550000, 1750000, 'https://images-na.ssl-images-amazon.com/images/I/71F5nnoo8gL.jpg',
        NOW(), 1300, 40, 246, 1, 'switch-pro-controller', 1, 'Switch, PC', 'Bluetooth, USB-C', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (40, 'https://images-na.ssl-images-amazon.com/images/I/71INYpPDGzL.jpg'),
                                          (40, 'https://images-na.ssl-images-amazon.com/images/I/71UcSIWT50L.jpg'),
                                          (40, 'https://images-na.ssl-images-amazon.com/images/I/61x8GQzWt8L.jpg'),
                                          (40, 'https://images-na.ssl-images-amazon.com/images/I/51++xMbbUIL.jpg');

-- VALVE
-- 41. Valve Steam Deck 64GB (Certified Refurbished) - ĐỘC LẬP (HỆ LCD)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Matte Black', '#1C1A1A', 2, 4, 'Valve Steam Deck 64GB',
        'Hàng tân trang chính hãng từ Valve với mức giá tối ưu nhất để trải nghiệm game PC cầm tay.',
        'Steam Deck Refurbished được chính Valve kiểm định và đảm bảo tiêu chuẩn chất lượng như máy mới. Đây là cơ hội tuyệt vời để sở hữu thiết bị chơi game cầm tay mạnh mẽ chạy SteamOS, hỗ trợ chơi mượt mà hàng ngàn tựa game trên thư viện Steam với mức giá cực kỳ tiết kiệm.',
        'CPU: AMD Zen 2, GPU: 8 RDNA 2 CUs, RAM: 16GB LPDDR5, Bộ nhớ: 64GB eMMC (Có thể nâng cấp SSD).',
        9990000, 10990000, 'https://www.droidshop.vn/wp-content/uploads/2021/07/Valve-Steam-Deck.jpg',
        NOW(), 40, 4, 669, 1, 'steam-deck-lcd-64gb-refurbished', 0, 'SteamOS 3.0, Proton Support, Desktop Mode', 'USB-C (DP support), Wi-Fi 5, Bluetooth 5.0', 'Bảo hành 6 tháng, Tặng kèm bao chống sốc và bộ sạc 45W'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (41, 'https://www.droidshop.vn/wp-content/uploads/2021/07/Valve-Steam-Deck-1.jpg'),
                                          (41, 'https://npcshop.vn/media/product/5947-m--y-ch--i-game-c---m-tay-steam-deck-64gb---valve--5-.jpg'),
                                          (41, 'https://npcshop.vn/media/product/5947-m--y-ch--i-game-c---m-tay-steam-deck-64gb---valve--3-.jpg');

-- 43. Steam Deck OLED 512GB (NVME SSD) - SẢN PHẨM GỐC NHÓM OLED
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'OLED Standard Black', '#111111', 2, 4, 'Steam Deck OLED 512GB (NVME SSD)',
        'Phiên bản nâng cấp màn hình OLED 90Hz sống động và thời lượng pin vượt trội.',
        'Steam Deck OLED mang đến trải nghiệm hình ảnh tuyệt đỉnh với màu đen sâu tuyệt đối và hỗ trợ HDR. Với viên pin lớn hơn và tiến trình chip mới, máy hoạt động mát mẻ hơn, cho thời gian chơi game dài hơn so với bản LCD truyền thống.',
        'Màn hình: 7.4 inch OLED 90Hz HDR, SSD: 512GB NVMe, Wi-Fi 6E nhanh hơn.',
        17990000, 20090000, 'https://www.tncstore.vn/media/product/9983-9982-tnc-store-may-choi-game-steam-deck-oled-1tb--1-.jpg',
        NOW(), 50, 6, 640, 1, 'steam-deck-oled-512gb', 1, 'SteamOS (Arch-based Linux), Steam Library', 'Wi-Fi 6E, Bluetooth 5.3', 'Bảo hành 12 tháng, Tặng bao chống sốc chính hãng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (43, 'https://www.tncstore.vn/media/product/9983-9982-tnc-store-may-choi-game-steam-deck-oled-1tb--3-.jpg'),
                                          (43, 'https://www.tncstore.vn/media/product/9983-78125_may_choi_game_cam_tay_stea.jpg'),
                                          (43, 'https://www.tncstore.vn/media/product/9983-tnc-store-may-choi-game-steam-deck-oled-512gb--2-.jpg'),
                                          (43, 'https://www.tncstore.vn/media/product/9983-78124_may_choi_game_cam_tay_stea.jpg'),
                                          (43, 'https://www.tncstore.vn/media/product/9983-z5255803007923_4e49386f76356e720c9002faf9ad3249.jpg');


-- 42. Steam Deck OLED White Limited Edition - BIẾN THỂ CỦA ID 43
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        43, 'Limited White', '#FAFAFA', 2, 4, 'Steam Deck OLED White Limited Edition',
        'Phiên bản giới hạn màu trắng nâng cấp màn hình OLED 90Hz sống động.',
        'Steam Deck OLED mang đến trải nghiệm hình ảnh tuyệt đỉnh với màu đen sâu tuyệt đối và hỗ trợ HDR. Phiên bản White Limited sở hữu lớp vỏ màu trắng mờ độc đáo cùng các nút bấm màu xám, đi kèm hộp đựng độc quyền.',
        'Màn hình: 7.4 inch OLED 90Hz HDR, SSD: 1TB NVMe, Wi-Fi 6E nhanh hơn.',
        17990000, 20090000, 'https://nghenhinvietnam.vn/uploads/global/quanghuy/2024/11/12/valve/nghenhin_steam-deck-oled-limited-edition-white_1.jpg',
        NOW(), 50, 6, 640, 1, 'steam-deck-oled-white-limited', 1, 'SteamOS (Arch-based Linux), Steam Library', 'Wi-Fi 6E, Bluetooth 5.3', 'Bảo hành 12 tháng, Tặng bao chống sốc chính hãng bản giới hạn màu trắng'
    );

INSERT INTO gallary (product_id, img) VALUES
    (42, 'https://nghenhinvietnam.vn/uploads/global/quanghuy/2024/11/12/valve/nghenhin_steam-deck-oled-limited-edition-white_2.jpg');


-- 44. Steam Deck OLED 1TB (NVME SSD) - BIẾN THỂ CỦA ID 43
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        43, 'Premium Anti-glare Black', '#242424', 2, 4, 'Steam Deck OLED 1TB (NVME SSD)',
        'Dung lượng lưu trữ tối đa cho kho game Steam đồ sộ của bạn.',
        'Với dung lượng 1TB NVMe SSD tốc độ cao, bạn có thể cài đặt hàng loạt tựa game AAA mà không lo về bộ nhớ. Màn hình OLED trên bản 1TB được trang bị lớp phủ chống lóa cao cấp (Premium Anti-glare Etched Glass) giúp chơi tốt trong mọi điều kiện ánh sáng.',
        'Màn hình: OLED HDR chống lóa, SSD: 1TB NVMe, Pin: 50Wh.',
        19490000, 20790000, 'https://www.tncstore.vn/media/product/250-9982-z5255802999735_c63b82ff9f6a652a8d0f1bce1154ac36.jpg',
        NOW(), 50, 6, 640, 1, 'steam-deck-oled-1tb', 1, 'SteamOS, Desktop Mode (Linux), Proton Support', 'WiFi 6E, Bluetooth 5.3', 'Bảo hành 12 tháng, Tặng bao chống sốc bản đặc biệt 1TB'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (44, 'https://www.tncstore.vn/media/product/9982-tnc-store-may-choi-game-steam-deck-oled-1tb--4-.jpg'),
                                          (44, 'https://www.tncstore.vn/media/product/9982-78125_may_choi_game_cam_tay_stea--2-.jpg'),
                                          (44, 'https://www.tncstore.vn/media/product/9982-tnc-store-may-choi-game-steam-deck-oled-1tb--2-.jpg'),
                                          (44, 'https://www.tncstore.vn/media/product/9982-tnc-store-may-choi-game-steam-deck-oled-1tb--1-.jpg'),
                                          (44, 'https://www.tncstore.vn/media/product/9982-tnc-store-may-choi-game-steam-deck-oled-1tb--3-.jpg');

-- ASUS
-- 47. ROG Ally AMD Ryzen Z1 Extreme - SẢN PHẨM GỐC NHOM ROG ALLY WHITE
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Pure White (Z1 Extreme)', '#FFFFFF', 2, 5, 'ROG Ally AMD Ryzen Z1 Extreme',
        'Máy chơi game cầm tay mạnh mẽ nhất từ Asus với chip Z1 Extreme và màn hình 120Hz.',
        'Asus ROG Ally mang đến sức mạnh đồ họa vượt trội nhờ kiến trúc RDNA 3. Với màn hình Full HD 120Hz hỗ trợ FreeSync Premium, mọi chuyển động trong game đều trở nên mượt mà, không giật xé hình. Hệ thống tản nhiệt Zero Gravity giúp máy hoạt động mát mẻ và yên tĩnh ở mọi tư thế cầm.',
        'CPU: AMD Ryzen Z1 Extreme (8 nhân/16 luồng), GPU: 12 RDNA 3 CUs, RAM: 16GB LPDDR5, SSD: 512GB NVMe.',
        12990000, 17990000, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_ally_thumbnaill_estore.png',
        NOW(), 40, 5, 608, 1, 'asus-rog-ally-z1-extreme', 1,
        'Windows 11 Home, Armoury Crate SE, Dolby Atmos', 'Wi-Fi 6E, Bluetooth 5.2, ROG XG Mobile Interface, USB-C (3.2 Gen 2)', 'Bảo hành 24 tháng chính hãng Asus, Tặng bao chống sốc ROG Ally'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (47, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_ally_ex_feature_1.jpg'),
                                          (47, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_ally_ex_feature_2.jpg'),
                                          (47, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/b/o/box.jpg'),
                                          (47, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_nr2301_02_copy.png'),
                                          (47, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_ally_ex_feature_7.jpg');


-- 44. Asus ROG Ally RC71L-NH019W (Ryzen Z1 Standard) - BIẾN THỂ CỦA ID 47
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        47, 'Pure White (Z1 Standard)', '#FFFFFF', 2, 5, 'Asus ROG Ally RC71L-NH019W (AMD Ryzen Z1/ 16GB/ 512GB/ 7.0 inch FHD IPS | Win 11/ Trắng)',
        'Máy chơi game cầm tay chạy Windows 11 Home với màn hình 7 inch FHD 120Hz sắc nét.',
        'ROG Ally (2023) mang đến sự linh hoạt tuyệt đối khi chạy hệ điều hành Windows 11, cho phép bạn chơi game từ mọi nền tảng phổ biến như Steam, Epic, Xbox Game Pass và GOG. Thiết kế gamepad tích hợp giúp trải nghiệm điều khiển tự nhiên và chính xác.',
        'CPU: AMD Ryzen™ Z1, Màn hình: 7 inch FHD 120Hz, Hệ điều hành: Windows 11 Home.',
        15490000, 16290000, 'https://www.tncstore.vn/media/product/250-10060-may-choi-game-asus-rog-ally-rc71l-nh019w--2-.jpg',
        NOW(), 40, 5, 608, 1, 'rog-ally-2023-z1-white', 0,
        'Steam, Epic, Xbox Game Pass, GOG', 'Wi-Fi 6E, Bluetooth 5.2', 'Bảo hành chính hãng 24 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (44, 'https://www.tncstore.vn/media/product/10060-may-choi-game-asus-rog-ally-rc71l-nh019w--6-.jpg'),
                                          (44, 'https://www.tncstore.vn/media/product/10060-may-choi-game-asus-rog-ally-rc71l-nh019w--5-.jpg'),
                                          (44, 'https://www.tncstore.vn/media/product/10060-may-choi-game-asus-rog-ally-rc71l-nh019w--4-.jpg'),
                                          (44, 'https://www.tncstore.vn/media/product/10060-may-choi-game-asus-rog-ally-rc71l-nh019w--3-.jpg'),
                                          (44, 'https://www.tncstore.vn/media/product/10060-may-choi-game-asus-rog-ally-rc71l-nh019w--1-.jpg');

-- 45. ROG Xbox Ally X (RC73XA) - SẢN PHẨM GỐC NHÓM XBOX ALLY BLACK
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Premium Black (Ally X)', '#151515', 2, 5, 'ROG Xbox Ally X (RC73XA)',
        'Sự kết hợp hoàn hảo giữa ASUS và Xbox cho hiệu năng chơi game 1080p cực mạnh.',
        'ROG Xbox Ally X là phiên bản đặc biệt nâng cấp hiệu năng, sở hữu kiến trúc mới giúp xử lý mượt mà các tựa game AAA ở độ phân giải Full HD. Hệ thống tản nhiệt và cần analog được tối ưu cho cường độ chơi game cao.',
        'CPU: AMD Ryzen™ AI Z2 Extreme (8 nhân 16 luồng), GPU: Radeon Graphics tích hợp.',
        24990000, 25790000, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_xbox_ally_x.jpg',
        NOW(), 80, 4, 715, 1, 'rog-xbox-ally-x', 1,
        'Steam, Epic, GOG, Xbox Game Pass, Cloud gaming', 'Wi-Fi, Bluetooth', 'Tặng kèm 3 tháng Xbox Game Pass Ultimate'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (45, 'https://vn.store.asus.com/media/wysiwyg/4.Design_1.png'),
                                          (45, 'https://vn.store.asus.com/media/wysiwyg/5.impulse_trigger_1.png'),
                                          (45, 'https://vn.store.asus.com/media/wysiwyg/Scenario_photo_01_1.jpg'),
                                          (45, 'https://vn.store.asus.com/media/wysiwyg/Scenario_photo_04_1.jpg');


-- 46. ROG Xbox Ally (RC73YA) - BIẾN THỂ CỦA ID 45
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        45, 'Standard Black (RC73YA)', '#1F1F1F', 2, 5, 'ROG Xbox Ally (RC73YA)',
        'Handheld Gaming PC tối ưu giữa hiệu năng và thời lượng pin trong dòng Xbox Ally.',
        'Phiên bản RC73YA tập trung vào sự cân bằng, giúp game thủ tận hưởng những giờ chơi game kéo dài hơn nhờ quản lý điện năng hiệu quả mà vẫn đảm bảo tốc độ khung hình ổn định trên hệ điều hành Windows 11.',
        'CPU: AMD Ryzen™ Z1 Series, OS: Windows 11 Home, Thiết kế công thái học tối ưu.',
        12990000, 14990000, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_xbox_ally.jpg',
        NOW(), 40, 3, 670, 1, 'rog-xbox-ally-rc73ya', 0,
        'Steam, Epic, GOG, Xbox Game Pass, Cloud gaming', 'Wi-Fi, Bluetooth', 'Bảo hành 24 tháng chính hãng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (46, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_rc73_01.png'),
                                          (46, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_rc73_02.jpg'),
                                          (46, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_rc73_03.png'),
                                          (46, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_rc73_05.jpg'),
                                          (46, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_rc73_07.jpg');

-- 6. MSI (Brand 6)
-- 50. MSI Claw 8 AI+ A2VM-007NL - SẢN PHẨM GỐC NHÓM INTEL LUNAR LAKE
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Sleek Black (Claw 8 AI+)', '#1A1A1A', 2, 6, 'MSI Claw 8 AI+ A2VM-007NL',
        'Handheld AI thế hệ mới với chip Intel Core Ultra 258V và đồ họa Intel Arc.',
        'MSI Claw 8 AI+ là thiết bị cầm tay tiên phong tích hợp xử lý AI chuyên sâu. Với vi xử lý Intel Core Ultra 7 258V (Lunar Lake), máy không chỉ mạnh mẽ trong việc chơi game mà còn tối ưu hóa tài nguyên thông minh, mang lại thời lượng pin ấn tượng và hiệu suất đồ họa đột phá.',
        'CPU: Intel Core Ultra 7 258V, GPU: Intel Arc Graphics (Lunar Lake), RAM: 32GB, SSD: 1TB.',
        26900000, 27290000, 'https://aio.lv/img/cache/product/11467634/66107367_large.webp',
        NOW(), 82, 8, 780, 1, 'msi-claw-8-ai-plus', 1,
        'Game PC AAA, AI Applications, Windows 11', 'Wi-Fi 7, Bluetooth 5.4, Dual Thunderbolt 4', 'Bảo hành 24 tháng chính hãng MSI, Tặng kèm túi đựng cao cấp'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (50, 'https://aio.lv/img/cache/product/11467634/66107368_large.webp'),
                                          (50, 'https://aio.lv/img/cache/product/11467634/66107372_large.webp'),
                                          (50, 'https://aio.lv/img/cache/product/11467634/66107370_large.webp');


-- 48. MSI Claw A1M - BIẾN THỂ CỦA ID 50 (HỆ INTEL THẾ HỆ 1)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        50, 'Classic Black (Claw A1M)', '#212121', 2, 6, 'MSI Claw A1M',
        'Chiếc PC Gaming Handheld đầu tiên từ MSI với sức mạnh chip Intel Core Ultra.',
        'MSI Claw A1M đánh dấu sự gia nhập của MSI vào thị trường máy cầm tay. Máy sở hữu thiết kế công thái học vượt trội, tản nhiệt Cooler Boost HyperFlow độc quyền và chip Intel Core Ultra mang lại khả năng xử lý đồ họa mượt mà cùng công nghệ Intel XeSS hiện đại.',
        'CPU: Intel Core Ultra 7 155H, GPU: Intel Arc Graphics, RAM: 16GB, Màn hình: 7 inch FHD 120Hz.',
        13990000, 19990000, 'https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/12918/329815/msi-claw-a1m-049vn-core-ultra-7-den-2-638687323732429218-750x500.jpg',
        NOW(), 53, 2, 675, 1, 'msi-claw-a1m', 0,
        'Game PC (Steam, Epic, Xbox Game Pass) trên Windows 11', 'Wi-Fi 7, Bluetooth 5.4, Thunderbolt 4', 'Bảo hành 24 tháng chính hãng MSI'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (48, 'https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/12918/329815/msi-claw-a1m-049vn-core-ultra-7-den-3-638687323739507556-750x500.jpg'),
                                          (48, 'https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/12918/329815/msi-claw-a1m-049vn-core-ultra-7-den-4-638687323745910902-750x500.jpg'),
                                          (48, 'https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/12918/329815/msi-claw-a1m-049vn-core-ultra-7-den-5-638687323752857349-750x500.jpg'),
                                          (48, 'https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/12918/329815/msi-claw-a1m-049vn-core-ultra-7-den-6-638687323761478441-750x500.jpg'),
                                          (48, 'https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/12918/329815/msi-claw-a1m-049vn-core-ultra-7-den-2-638687323732429218-750x500.jpg');

-- 49. MSI Claw A8 BZ2EM-025PL White - ĐỘC LẬP (HỆ AMD RYZEN Z2)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Ice White', '#F8F9FA', 2, 6, 'MSI Claw A8 BZ2EM-025PL White',
        'Sức mạnh từ AMD Ryzen Z2 Extreme cùng màn hình 8 inch Full HD+ sắc nét.',
        'Phiên bản MSI Claw A8 mang đến bước nhảy vọt về hiệu năng với chip Z2 Extreme và RAM 24GB. Màn hình được nâng cấp lên 8 inch cho không gian trải nghiệm rộng lớn hơn, phù hợp cho các game thủ muốn chiến game AAA ở mức thiết lập cao.',
        'CPU: AMD Ryzen™ Z2 Extreme, RAM: 24GB LPDDR5X, SSD: 1TB, Màn hình: 8 inch 120Hz.',
        24590000, 25990000, 'https://aio.lv/img/cache/product/11558180/66715234_large.webp',
        NOW(), 80, 7, 765, 1, 'msi-claw-a8-z2-extreme', 1,
        'Steam, Epic, Xbox Game Pass, GOG', 'Wi-Fi 7, Bluetooth 5.4', 'Bảo hành 24 tháng chính hãng MSI'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (49, 'https://aio.lv/img/cache/product/11558180/66715235_large.webp'),
                                          (49, 'https://aio.lv/img/cache/product/11558180/66715237_large.webp'),
                                          (49, 'https://aio.lv/img/cache/product/11558180/66715238_large.webp'),
                                          (49, 'https://aio.lv/img/cache/product/11558180/66715239_large.webp');

-- 7. LENOVO (Brand 7)
-- 51. Lenovo Legion Go (8.8 inch) - ĐỘC LẬP (HỆ WINDOWS / AMD Z1E)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Shadow Black', '#1C1D1F', 2, 7, 'Lenovo Legion Go (8.8 inch)',
        'Siêu phẩm cầm tay với màn hình QHD 144Hz khổng lồ và tay cầm tháo rời độc đáo.',
        'Lenovo Legion Go mang đến trải nghiệm thị giác đỉnh cao với màn hình 8.8 inch sắc nét. Điểm nhấn lớn nhất là tay cầm Legion TrueStrike có thể tháo rời, tích hợp cảm biến Hall Effect và chế độ FPS Mode giúp bạn biến tay cầm phải thành một con chuột chuyên nghiệp để chơi game bắn súng.',
        'CPU: AMD Ryzen Z1 Extreme, RAM: 16GB LPDDR5X, SSD: 512GB NVMe, Màn hình: 8.8 inch QHD+ (2560 x 1600) 144Hz.',
        17990000, 18990000, 'https://aio.lv/img/cache/product/10758171/65612332_large.webp',
        NOW(), 49, 6, 854, 1, 'lenovo-legion-go-standard', 1,
        'Legion Space, FPS Mode, Detachable Controllers', '2x USB-C (USB4), Wi-Fi 6E, Bluetooth 5.2, MicroSD Slot', 'Bảo hành 12 tháng, Tặng kèm túi đựng máy cao cấp và đế dựng FPS Mode'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (51, 'https://aio.lv/img/cache/product/10758171/65612334_large.webp'),
                                          (51, 'https://aio.lv/img/cache/product/10758171/65612335_large.webp'),
                                          (51, 'https://aio.lv/img/cache/product/10758171/65612337_large.webp'),
                                          (51, 'https://aio.lv/img/cache/product/10758171/65612338_large.webp'),
                                          (51, 'https://aio.lv/img/cache/product/10758171/65612342_large.webp');

-- 52. Lenovo Legion Play - ĐỘC LẬP (HỆ ANDROID / SNAPDRAGON)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Iron Gray', '#4E5052', 2, 7, 'Lenovo Legion Play',
        'Máy chơi game chuyên dụng chạy Android, tối ưu cho Cloud Gaming và giả lập.',
        'Thiết kế Legion đặc trưng với tay cầm công thái học, Legion Play là thiết bị hoàn hảo để trải nghiệm Xbox Cloud, GeForce Now hoặc các trình giả lập Android với thời lượng pin cực dài.',
        'CPU: Snapdragon 720G, RAM: 4GB, Màn hình: 7 inch FHD HDR10.',
        8990000, 9990000, 'https://i.ytimg.com/vi/djOWeEFRJ6w/maxresdefault.jpg',
        NOW(), 7000, 5, 430, 1, 'lenovo-legion-play', 0,
        'Android 11, Cloud Gaming Ready, Google Play', 'USB-C, WiFi, Bluetooth 5.0', 'Bảo hành 6 tháng, Miễn phí giao hàng toàn quốc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (52, 'https://liliputing.com/wp-content/uploads/2023/01/lgeion-play_01.jpg'),
                                          (52, 'https://liliputing.com/wp-content/uploads/2021/10/lenovo-legion-play_02-400x166.jpg'),
                                          (52, 'https://liliputing.com/wp-content/uploads/2021/10/lenovo-legion-play_03-400x165.jpg'),
                                          (52, 'https://liliputing.com/wp-content/uploads/2021/10/lenovo-legion-play_01-400x231.jpg');

-- 8. AYANEO (Brand 8)
-- 54. AYANEO 2S - SẢN PHẨM GỐC NHÓM AYANEO 2 SERIES
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Starry Black (7840U)', '#1A1C1E', 2, 8, 'AYANEO 2S',
        'Bản nâng cấp phần cứng mạnh mẽ với chip Ryzen 7000 series.',
        'Kế thừa thiết kế cao cấp từ AYANEO 2, phiên bản 2S được nâng cấp sức mạnh CPU đáng kể và tối ưu hệ thống tản nhiệt mới. Máy đáp ứng tốt các tựa game AAA nặng nhất hiện nay trên nền tảng Windows 11.',
        'CPU: AMD Ryzen 7 7840U, GPU: Radeon 780M, RAM: 16GB, Màn hình: 7 inch 1200P.',
        19900000, 20100000, 'https://weirdstore.vn/wp-content/uploads/2024/03/csm_Untitled_1_f1e5aafca1.jpg',
        NOW(), 50, 3, 680, 1, 'ayaneo-2s-7840u', 1,
        'Steam, Epic Games, Xbox Game Pass, GOG', 'WiFi 6E, Bluetooth 5.2', 'Hàng Order - Bảo hành 12 tháng chính hãng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (54, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20220821_080911947-Copy-1067x800.jpg'),
                                          (54, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20220821_080918479-Copy-1067x800.jpg'),
                                          (54, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20220821_082628202-Copy-1067x800.jpg'),
                                          (54, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20220821_082647212-Copy-1067x800.jpg'),
                                          (54, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20220821_080820852-Copy-1067x800.jpg');


-- 53. AYANEO 2 - BIẾN THỂ CỦA ID 54 (HỆ CHIP 6800U)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        54, 'Sky White (6800U)', '#F5F6F8', 2, 8, 'AYANEO 2',
        'Máy chơi game cầm tay Windows với thiết kế màn hình vô cực viền siêu mỏng.',
        'AYANEO 2 là chiếc Handheld PC đầu tiên của hãng trang bị chip AMD Ryzen 7 6800U. Điểm nhấn lớn nhất là mặt trước phủ kính hoàn toàn với thiết kế không viền, mang lại trải nghiệm thị giác đỉnh cao cùng cần Analog Hall Effect chống trôi.',
        'CPU: AMD Ryzen 7 6800U, GPU: Radeon 680M, RAM: 16GB, Màn hình: 7 inch 1200P.',
        12000000, 13290000, 'https://weirdstore.vn/wp-content/uploads/2024/03/AYANEOAIR_20_cfc73e29-919e-4371-9dbe-9f5696e8e9af-1536x1536.webp',
        NOW(), 50, 2, 680, 1, 'ayaneo-2-6800u', 1,
        'Steam, Epic Games, Xbox Game Pass PC, GOG', 'WiFi 6, Bluetooth 5.2', 'Bảo hành 12 tháng, Tặng kèm bao chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (53, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230110_090710-Copy-1-1400x631.jpg'),
                                          (53, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230110_091002-Copy-1-1400x631.jpg'),
                                          (53, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230110_091006-Copy-1-1400x631.jpg'),
                                          (53, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230110_085931-Copy-1-1400x631.jpg');


-- 56. AYANEO Geek - BIẾN THỂ CỦA ID 54 (BẢN TINH GIẢN CHI PHÍ)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        54, 'Fantasy Black (Geek)', '#111215', 2, 8, 'AYANEO Geek',
        'Hiệu năng gaming PC mạnh mẽ với mức giá tối ưu hơn.',
        'AYANEO Geek là phiên bản tinh giản từ AYANEO 2, tập trung tối đa vào hiệu năng chơi game thực tế. Đây là lựa chọn lý tưởng cho game thủ muốn sở hữu một chiếc máy Windows cầm tay cấu hình cao với chi phí hợp lý.',
        'CPU: AMD Ryzen 7 6800U, RAM: 16GB, Màn hình: 7 inch 800P/1200P.',
        11000000, 12190000, 'https://weirdstore.vn/wp-content/uploads/2024/03/image-61-935x800.png',
        NOW(), 50, 3, 680, 1, 'ayaneo-geek', 0,
        'Steam, Epic Games, Xbox Game Pass PC, GOG', 'WiFi 6, Bluetooth 5.2', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (56, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230404_163449-Copy-1-1067x800.jpg'),
                                          (56, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230404_163501-Copy-1-1067x800.jpg'),
                                          (56, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230404_163549-Copy-1-1067x800.jpg'),
                                          (56, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230404_163620-Copy-1-1067x800.jpg'),
                                          (56, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230404_164517-Copy-1-1067x800.jpg'),
                                          (56, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230404_163436-Copy-1-1067x800.jpg');

-- 55. AYANEO 3 32GB - ĐỘC LẬP (THẾ HỆ CHIP AI 9 HX 370 MỚI)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Cosmic Shadow', '#0E0F11', 2, 8, 'AYANEO 3 32GB',
        'Siêu phẩm Handheld thế hệ mới với chip AI370 cực khủng.',
        'AYANEO 3 được đánh giá là một trong những thiết bị cầm tay mạnh nhất thế giới hiện nay. Với chip xử lý tích hợp AI thế hệ mới, máy không chỉ chiến game AAA mượt mà còn hỗ trợ các tác vụ xử lý thông minh, màn hình OLED rực rỡ.',
        'CPU: AMD Ryzen AI 9 HX 370, RAM: 32GB, SSD: 1TB, Màn hình OLED.',
        32000000, 33090000, 'https://images-na.ssl-images-amazon.com/images/I/61L01B8iRzL.jpg',
        NOW(), 71, 4, 680, 1, 'ayaneo-3-ai370', 1,
        'Steam, Epic Games, Xbox Game Pass PC, GOG', 'WiFi 7, Bluetooth 5.4', 'Bảo hành 12 tháng, Tặng bộ quà tặng cao cấp'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (55, 'https://images-na.ssl-images-amazon.com/images/I/515G-HvHBwL.jpg'),
                                          (55, 'https://images-na.ssl-images-amazon.com/images/I/515G-HvHBwL.jpg'),
                                          (55, 'https://images-na.ssl-images-amazon.com/images/I/71i2BEyfQML.jpg'),
                                          (55, 'https://images-na.ssl-images-amazon.com/images/I/714r+jrKO-L.jpg'),
                                          (55, 'https://images-na.ssl-images-amazon.com/images/I/61bqBofi+ZL.jpg');


-- 57. Ayaneo Pocket Micro - ĐỘC LẬP (MÁY RETRO VỎ KIM LOẠI CNC)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Retro Silver', '#C0C0C0', 2, 8, 'Ayaneo Pocket Micro',
        'Handheld Android siêu nhỏ gọn với thiết kế sang trọng vỏ kim loại.',
        'Pocket Micro là mẫu máy nhỏ nhất của nhà Ayaneo chạy Android 13. Máy được hoàn thiện bằng vỏ kim loại cao cấp, thiết kế lấy cảm hứng từ Game Boy Micro, chuyên dụng để giả lập các hệ máy retro và chơi game Android nhẹ.',
        'Hệ điều hành: Android 13, Thiết kế vỏ kim loại CNC, Kích thước bỏ túi.',
        7690000, 7800000, 'https://images-na.ssl-images-amazon.com/images/I/41dr4pNnthL.jpg',
        NOW(), 2600, 8, 233, 1, 'ayaneo-pocket-micro', 0,
        'Android/Retro Emulation (GBA, NES, SNES...)', 'WiFi & Bluetooth', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (57, 'https://images-na.ssl-images-amazon.com/images/I/51Z2E54dgUL.jpg'),
                                          (57, 'https://images-na.ssl-images-amazon.com/images/I/515H+l7AxvL.jpg'),
                                          (57, 'https://images-na.ssl-images-amazon.com/images/I/716j4KdJgEL.jpg'),
                                          (57, 'https://images-na.ssl-images-amazon.com/images/I/515taJPwZzL.jpg');


-- 58. Ayaneo Pocket DS - ĐỘC LẬP (MÁY HAI MÀN HÌNH NẮP GẬP)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Classic White', '#FBFBFB', 2, 8, 'Ayaneo Pocket DS',
        'Máy chơi game Android màn hình đôi, tái hiện huyền thoại Nintendo DS.',
        'AYANEO Pocket DS mang thiết kế nắp gập Clamshell với hai màn hình độc đáo. Đây là thiết bị tối ưu nhất để giả lập các hệ máy màn hình kép (NDS, 3DS) trên nền tảng Android, kết hợp cấu hình mạnh mẽ để chơi các game hiện đại.',
        'Thiết kế 2 màn hình, OS: Android, Giả lập đa hệ máy chuyên sâu.',
        12800000, 13190000, 'https://weirdstore.vn/wp-content/uploads/2025/08/ayaneo-pocket-ds-indiegogo-confirmation-kv-1067x800.jpg',
        NOW(), 8000, 5, 450, 1, 'ayaneo-pocket-ds', 1,
        'Retro Emulation (DS/3DS, PSP, PS2...)', 'WiFi & Bluetooth', 'Bảo hành 12 tháng, Tặng thẻ nhớ full game'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (58, 'https://weirdstore.vn/wp-content/uploads/2025/08/IMG_20250927_091024482-Copy.jpg'),
                                          (58, 'https://weirdstore.vn/wp-content/uploads/2025/08/IMG_20250927_091029325-Copy.jpg'),
                                          (58, 'https://weirdstore.vn/wp-content/uploads/2025/08/IMG_20250927_091035400-Copy.jpg'),
                                          (58, 'https://weirdstore.vn/wp-content/uploads/2025/08/IMG_20250927_091104159-Copy-1067x800.jpg'),
                                          (58, 'https://weirdstore.vn/wp-content/uploads/2025/08/IMG_20250927_0912204502-Copy-1067x800.jpg');


-- 59. AYANEO Slide - ĐỘC LẬP (MÀN HÌNH TRƯỢT & BÀN PHÍM VẬT LÝ)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Metallic Gray', '#4A4D50', 2, 8, 'AYANEO Slide',
        'Máy chơi game cầm tay màn hình trượt độc đáo với bàn phím QWERTY tích hợp.',
        'AYANEO Slide tái định nghĩa trải nghiệm handheld với thiết kế màn hình trượt linh hoạt, tiết lộ bàn phím QWERTY bên dưới giúp nhập liệu dễ dàng. Máy trang bị cảm biến Hall Effect cho độ chính xác tuyệt đối và con chip 7840U mạnh mẽ cho mọi tựa game AAA.',
        'CPU: AMD Ryzen 7 7840U, RAM: 16GB LPDDR5X, Màn hình: 6 inch FHD IPS (Trượt & Nghiêng), Bàn phím: RGB QWERTY.',
        19990000, 20990000, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-3.jpg',
        NOW(), 46, 3, 650, 1, 'ayaneo-slide-7840u', 1,
        'AYASpace 2, Hall Effect Sensor, Sliding Keyboard', '2x USB4 (Full speed), Wi-Fi 6E, Bluetooth 5.2', 'Bảo hành 12 tháng, Tặng kèm túi chống sốc và bộ sạc nhanh PD'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (59, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20231222_160836354-Copy-1067x800.jpg'),
                                          (59, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20231222_161132961-Copy-1067x800.jpg'),
                                          (59, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20231222_160912808-Copy-1067x800.jpg'),
                                          (59, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20231222_160845650-Copy-1067x800.jpg'),
                                          (59, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20231222_160954650-Copy.jpg');

-- 9. GPD (Brand 9)
-- 60. GPD Win 5 32Gb – 2Tb - ĐỘC LẬP (HỆ CHIP AMD RYZEN AI MAX CHUYÊN DỤNG)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Matte Black (Win 5)', '#1C1C1E', 2, 9, 'GPD Win 5 32Gb - 2Tb',
        'Siêu phẩm Handheld PC cao cấp nhất với sức mạnh từ chip AMD Ryzen AI Max.',
        'GPD WIN 5 thiết lập tiêu chuẩn mới cho máy chơi game cầm tay với vi xử lý Ryzen AI Max thế hệ mới nhất. Máy không chỉ tối ưu cho các tựa game AAA nặng nhất mà còn tích hợp nhân xử lý AI chuyên dụng, giúp tăng cường hiệu suất đồ họa và thời lượng pin thông minh.',
        'CPU: AMD Ryzen AI Max 385 / AI Max Plus 395, RAM: LPDDR5x, SSD: NVMe Gen4.',
        45980000, 50900000, 'https://weirdstore.vn/wp-content/uploads/2025/08/1_l-2.jpg',
        NOW(), 60, 9, 590, 1, 'gpd-win-5-ai-max', 1,
        'Steam, Epic, Xbox Game Pass, AI Tools', 'WiFi 7, Bluetooth 5.4, Oculink', 'Bảo hành 12 tháng, Tặng kèm Dock sạc chuyên dụng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (60, 'https://weirdstore.vn/wp-content/uploads/2025/08/IMG_20251005_1709138782-Copy-1067x800.jpg'),
                                          (60, 'https://weirdstore.vn/wp-content/uploads/2025/08/IMG_20251005_1709241392-Copy-1067x800.jpg'),
                                          (60, 'https://weirdstore.vn/wp-content/uploads/2025/08/IMG_20251005_1709268492-Copy-1067x800.jpg'),
                                          (60, 'https://weirdstore.vn/wp-content/uploads/2025/08/IMG_20251005_1709553182-Copy-1067x800.jpg');

-- 62. GPD Win 4 8840U - SẢN PHẨM GỐC NHÓM GPD WIN 4
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Premium Black (32GB/1TB)', '#121212', 2, 9, 'GPD Win 4 8840U',
        'Bản nâng cấp chip Ryzen 7 8840U cho hiệu năng đồ họa và xử lý AI vượt trội.',
        'Giữ nguyên thiết kế bàn phím trượt nhỏ gọn đặc trưng, phiên bản nâng cấp này mang trong mình chip Ryzen 7 8840U mạnh mẽ. Máy đáp ứng mượt mà các tựa game PC mới nhất và tối ưu hóa điện năng tốt hơn, mang lại trải nghiệm gaming di động đỉnh cao.',
        'CPU: AMD Ryzen 7 8840U, GPU: Radeon 780M, RAM: 32GB, SSD: 1TB.',
        20500000, 20900000, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-2.jpg',
        NOW(), 46, 6, 598, 1, 'gpd-win-4-8840u', 1,
        'Game PC AAA, Steam, Epic, Windows 11', 'WiFi 6E, Bluetooth 5.2, Oculink Port', 'Bảo hành 12 tháng chính hãng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (62, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230226_101554-Copy.jpg'),
                                          (62, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230226_101543-Copy.jpg'),
                                          (62, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230226_101920-Copy-1-1067x800.jpg'),
                                          (62, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230226_101840-Copy-1-1067x800.jpg'),
                                          (62, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230226_101814-Copy-1-1067x800.jpg');


-- 61. GPD Win 4 2025 - BIẾN THỂ CỦA ID 62 (BẢN TINH GIẢM 16GB RAM)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        62, 'Standard White (16GB/512GB)', '#F3F4F6', 2, 9, 'GPD Win 4 2025',
        'Thiết kế bàn phím trượt độc đáo, hiệu năng PC mạnh mẽ trong lòng bàn tay.',
        'GPD Win 4 2025 nổi bật với thiết kế trượt màn hình để lộ bàn phím vật lý bên dưới, lấy cảm hứng từ dòng Sony VAIO P huyền thoại. Đây là thiết bị hoàn hảo cho những ai cần sự kết hợp giữa máy chơi game cầm tay và khả năng nhập liệu nhanh của một chiếc mini laptop.',
        'CPU: AMD Ryzen 7 8840U, RAM: 16GB, Thiết kế bàn phím trượt vật lý.',
        11000000, 12290000, 'https://images-na.ssl-images-amazon.com/images/I/71Km1NhXr4L.jpg',
        NOW(), 46, 8, 598, 1, 'gpd-win-4-standard', 0,
        'Game PC AAA, Steam, Epic, Emulation', 'WiFi 6, Bluetooth 5.2, USB4', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (61, 'https://images-na.ssl-images-amazon.com/images/I/61PX0vqKzPL.jpg'),
                                          (61, 'https://images-na.ssl-images-amazon.com/images/I/61QtmqAf-tL.jpg'),
                                          (61, 'https://images-na.ssl-images-amazon.com/images/I/51-Vzaj2UDL.jpg'),
                                          (61, 'https://images-na.ssl-images-amazon.com/images/I/61Ykkg6QymL.jpg'),
                                          (61, 'https://images-na.ssl-images-amazon.com/images/I/61Lj3tGWtBL.jpg');

-- 64. GPD Win Max 2 8840U - SẢN PHẨM GỐC NHÓM GPD WIN MAX 2
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Space Gray (8840U/2TB)', '#3A3B3E', 2, 9, 'GPD Win Max 2 8840U',
        'Chiếc Mini Laptop lai Handheld PC cấu hình cao với sức mạnh vi xử lý 8840U.',
        'GPD Win Max 2 phiên bản chip Ryzen 7 8840U mang lại hiệu suất đồ họa di động ấn tượng trên form factor vỏ sò độc đáo. Màn hình lớn tích hợp các phím chức năng joystick thông minh ẩn giấu khéo léo sau các thanh trượt nam châm.',
        'CPU: AMD Ryzen 7 8840U, RAM: 32GB LPDDR5x, SSD: 2TB M.2 NVMe, Màn hình: 10.1 inch IPS Cảm ứng.',
        27000000, 27900000, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-1.jpg',
        NOW(), 76, 5, 1005, 1, 'gpd-win-max-2-8840u', 1,
        'Full QWERTY Keyboard, Magnetic Cover, Windows 11', 'Oculink Port, USB4, USB-A, HDMI, Card Reader', 'Bảo hành 12 tháng, Tặng sạc nhanh PD đa năng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (64, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20240503_161116208-1067x800.jpg'),
                                          (64, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20240503_161058679-1067x800.jpg'),
                                          (64, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20240503_160738392-1067x800.jpg'),
                                          (64, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20240503_160524719-1067x800.jpg');


-- 63. GPD Win Max 2 2025 - BIẾN THỂ CỦA ID 64 (HỆ CHIP 7840U/1TB)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        64, 'Carbon Black (7840U/1TB)', '#232426', 2, 9, 'GPD Win Max 2 2025',
        'Sự kết hợp hoàn hảo giữa Laptop làm việc và máy chơi game cầm tay màn hình 10.1 inch.',
        'GPD Win Max 2 2025 là thiết bị gaming cầm tay mạnh mẽ nhất với thiết kế dạng vỏ sò (Clamshell). Máy sở hữu bàn phím QWERTY đầy đủ, Touchpad và cụm phím chơi game có nắp che tinh tế. Trang bị cảm biến Hall Effect cho cả cần Analog và Trigger, đảm bảo độ bền và chính xác tuyệt đối.',
        'CPU: AMD Ryzen 7 7840U, RAM: 32GB LPDDR5X, SSD: 1TB NVMe, Màn hình: 10.1 inch 2.5K Touch.',
        22990000, 23990000, 'https://images-na.ssl-images-amazon.com/images/I/51prI6qAGAL.jpg',
        NOW(), 67, 8, 1005, 1, 'gpd-win-max-2-2025', 1,
        'Built-in Keyboard, Oculink Port (eGPU), Fingerprint Unlock', 'Oculink (SFF-8612), USB4, HDMI 2.1, SD Slot', 'Bảo hành 12 tháng, Tặng kèm túi chống sốc và bộ sạc nhanh 100W PD'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (63, 'https://images-na.ssl-images-amazon.com/images/I/51prI6qAGAL.jpg'),
                                          (63, 'https://images-na.ssl-images-amazon.com/images/I/51iQn7xVfuL.jpg'),
                                          (63, 'https://images-na.ssl-images-amazon.com/images/I/41McEj0E5JL.jpg'),
                                          (63, 'https://images-na.ssl-images-amazon.com/images/I/51EiahnUQQL.jpg');

-- 65. GPD Win Mini 2025 32Gb-2Tb - ĐỘC LẬP (DÁNG NẮP GẬP BỎ TÚI 7 INCH)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Obsidian Black', '#1B1B1D', 2, 9, 'GPD Win Mini 2025 32Gb-2Tb',
        'Handheld PC siêu nhỏ gọn dáng gập độc đáo.',
        'Thiết kế nắp gập bỏ túi thực thụ với sức mạnh phần cứng vô cùng ấn tượng của vi xử lý AMD Ryzen thế hệ mới.',
        'Ryzen 7 8840U, RAM: 32GB, SSD: 2TB NVMe.',
        18500000, 19900000, 'https://weirdstore.vn/wp-content/uploads/2024/03/n.png',
        NOW(), 44, 5, 520, 1, 'gpd-win-mini', 1,
        'Windows 11', 'WiFi 6E', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (65, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20231130_090531716-Copy-1067x800.jpg'),
                                          (65, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20231130_090523663-Copy-1067x800.jpg'),
                                          (65, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20231130_090709832-Copy-1067x800.jpg'),
                                          (65, 'https://weirdstore.vn/wp-content/uploads/2024/03/IMG_20231130_090619459-Copy-1067x800.jpg');


-- 66. GPD XP Plus - ĐỘC LẬP (HỆ ANDROID / TAY CẦM MÔ-ĐUN)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Iron Gray Module', '#4A4C4E', 2, 9, 'GPD XP Plus',
        'Máy chơi game Android dạng Module độc đáo, thay đổi tay cầm linh hoạt.',
        'GPD XP Plus sở hữu cấu trúc mô-đun cho phép bạn hoán đổi các cụm phím điều khiển phù hợp cho game MOBA, FPS hoặc Giả lập. Tích hợp kết nối 4G cho trải nghiệm gaming mọi lúc mọi nơi.',
        'CPU: MediaTek Dimensity 1200, RAM: 6GB, Màn hình: 6.81 inch, Hỗ trợ SIM 4G.',
        9990000, 10990000, 'https://droix.co.uk/wp-content/uploads/2021/10/GPD-XP_PLUS-DONE-LISTING-IMAGE-1.png',
        NOW(), 7000, 4, 331, 1, 'gpd-xp-plus-modular', 0,
        'Modular Controller, 4G LTE, Android 11', 'USB-C, WiFi, 4G LTE, Bluetooth', 'Bảo hành 12 tháng, Tặng thẻ nhớ 64GB'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (66, 'https://droix.co.uk/wp-content/uploads/2021/10/GPD-XP_PLUS-DONE-LISTING-IMAGE-2.jpg'),
                                          (66, 'https://droix.co.uk/wp-content/uploads/2021/10/GPD-XP_PLUS-DONE-LISTING-IMAGE-4.jpg'),
                                          (66, 'https://droix.co.uk/wp-content/uploads/2021/10/GPD-XP_PLUS-DONE-LISTING-IMAGE-6.jpg');

-- 10. Anbernic (Brand 10)
-- 67. Anbernic RG35XX H - Jet (Sản phẩm gốc)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (NULL, 'Jet Black', '#1A1A1A', 2, 10, 'Anbernic RG35XX H - 64G', 'Thiết kế ngang hiện đại.', 'Cấu hình mạnh mẽ trong thân hình nhỏ gọn.', 'H-Series Design', 1450000, 1650000,
     'https://images-na.ssl-images-amazon.com/images/I/61dpIqib4+L.jpg', NOW(), 3300, 6, 180, 1, 'anbernic-rg35xxh', 0, 'Retro Systems', 'WiFi/BT', 'Bảo hành 12 tháng');

INSERT INTO gallary (product_id, img) VALUES
                                          (67, 'https://images-na.ssl-images-amazon.com/images/I/71nFblSamGL.jpg'),
                                          (67, 'https://images-na.ssl-images-amazon.com/images/I/71f+C5kPeaL.jpg'),
                                          (67, 'https://images-na.ssl-images-amazon.com/images/I/71zGYlSYcpL.jpg'),
                                          (67, 'https://images-na.ssl-images-amazon.com/images/I/61p2OvtJ7mL.jpg');

-- 68. Anbernic RG35XX H - Purple (Con của 67)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (67, 'Transparent Purple', '#6A0DAD', 2, 10, 'Anbernic RG35XX H - 64G', 'Thiết kế ngang hiện đại.', 'Cấu hình mạnh mẽ trong thân hình nhỏ gọn.', 'H-Series Design', 1450000, 1650000,
     'https://images-na.ssl-images-amazon.com/images/I/71mb2vcdyPL.jpg', NOW(), 3300, 6, 180, 1, 'anbernic-rg35xxh', 0, 'Retro Systems', 'WiFi/BT', 'Bảo hành 12 tháng');

INSERT INTO gallary (product_id, img) VALUES
                                          (68, 'https://images-na.ssl-images-amazon.com/images/I/71nFblSamGL.jpg'),
                                          (68, 'http://images-na.ssl-images-amazon.com/images/I/71VkmB2dEjL.jpg'),
                                          (68, 'https://images-na.ssl-images-amazon.com/images/I/71f+C5kPeaL.jpg'),
                                          (68, 'https://images-na.ssl-images-amazon.com/images/I/61WeidpQaUL.jpg'),
                                          (68, 'https://images-na.ssl-images-amazon.com/images/I/61mbDahGkPL.jpg');

-- 69. Anbernic RG35XX H - White (Con của 67)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (67, 'Transparent White', '#F5F5F5', 2, 10, 'Anbernic RG35XX H - 64G', 'Thiết kế ngang hiện đại.', 'Cấu hình mạnh mẽ trong thân hình nhỏ gọn.', 'H-Series Design', 1450000, 1650000,
     'https://images-na.ssl-images-amazon.com/images/I/614TSfsJX7L.jpg', NOW(), 3300, 6, 180, 1, 'anbernic-rg35xxh', 0, 'Retro Systems', 'WiFi/BT', 'Bảo hành 12 tháng');

INSERT INTO gallary (product_id, img) VALUES
                                          (69, 'https://images-na.ssl-images-amazon.com/images/I/71nFblSamGL.jpg'),
                                          (69, 'http://images-na.ssl-images-amazon.com/images/I/71VkmB2dEjL.jpg'),
                                          (69, 'https://images-na.ssl-images-amazon.com/images/I/71f+C5kPeaL.jpg'),
                                          (69, 'https://images-na.ssl-images-amazon.com/images/I/61WeidpQaUL.jpg');


-- 70. Anbernic RG35XX Pro Retro - Black (Sản phẩm gốc)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Black', '#2B2B2B', 2, 10, 'Anbernic RG35XX Pro Retro',
        'Máy chơi game Retro cầm dọc huyền thoại, hỗ trợ giả lập hơn 30 hệ máy cổ điển.',
        'Anbernic RG35XX Pro Retro - Black là phiên bản nâng cấp mạnh mẽ về hiệu năng so với bản tiền nhiệm. Với thiết kế cầm dọc cổ điển mang lại cảm giác hoài niệm, máy cho phép bạn chơi mượt mà các tựa game từ PS1, PSP, NDS đến các hệ máy thùng. Màn hình IPS 3.5 inch sắc nét cùng hệ điều hành Linux tối ưu giúp trải nghiệm chơi game trở nên đơn giản và thú vị hơn bao giờ hết.',
        'CPU: Allwinner H700, RAM: 1GB LPDDR4, Màn hình: 3.5 inch IPS (640x480), Hệ điều hành: Linux.',
        1690000, 1990000, 'https://images-na.ssl-images-amazon.com/images/I/71Wdl7AtdsL.jpg', NOW(), 3300, 7, 186, 1, 'anbernic-rg35xx-plus', 0, 'PSP, PS1, DC, NDS, Arcade, GBA giả lập', 'Wi-Fi 5G, Bluetooth 4.2, Mini HDMI output, USB-C', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ 64GB chứa sẵn 5000+ game'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (70, 'https://images-na.ssl-images-amazon.com/images/I/71F78aRiXhL.jpg'),
                                          (70, 'https://images-na.ssl-images-amazon.com/images/I/613F0+fxtlL.jpg'),
                                          (70, 'https://images-na.ssl-images-amazon.com/images/I/61ZkVVrR8pL.jpg'),
                                          (70, 'https://images-na.ssl-images-amazon.com/images/I/71IZHWGunpL.jpg'),
                                          (70, 'https://images-na.ssl-images-amazon.com/images/I/71sRjSWcKyL.jpg');

-- 71. Anbernic RG35XX Pro Retro - Transparent Teal (Con của 70)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        70, 'Transparent Teal', '#008080', 2, 10, 'Anbernic RG35XX Pro Retro',
        'Máy chơi game Retro cầm dọc huyền thoại, hỗ trợ giả lập hơn 30 hệ máy cổ điển.',
        'Anbernic RG35XX Pro Retro - Transparent Teal là phiên bản nâng cấp mạnh mẽ về hiệu năng so với bản tiền nhiệm. Với thiết kế cầm dọc cổ điển mang lại cảm giác hoài niệm, máy cho phép bạn chơi mượt mà các tựa game từ PS1, PSP, NDS đến các hệ máy thùng. Màn hình IPS 3.5 inch sắc nét cùng hệ điều hành Linux tối ưu giúp trải nghiệm chơi game trở nên đơn giản và thú vị hơn bao giờ hết.',
        'CPU: Allwinner H700, RAM: 1GB LPDDR4, Màn hình: 3.5 inch IPS (640x480), Hệ điều hành: Linux.',
        1690000, 1990000, 'https://images-na.ssl-images-amazon.com/images/I/71uvQNyqJRL.jpg', NOW(), 3300, 8, 186, 1, 'anbernic-rg35xx-plus', 0, 'PSP, PS1, DC, NDS, Arcade, GBA giả lập', 'Wi-Fi 5G, Bluetooth 4.2, Mini HDMI output, USB-C', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ 64GB chứa sẵn 5000+ game'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (71, 'https://images-na.ssl-images-amazon.com/images/I/71vK0QhiEbL.jpg'),
                                          (71, 'https://images-na.ssl-images-amazon.com/images/I/71RVZ6cwFvL.jpg'),
                                          (71, 'https://images-na.ssl-images-amazon.com/images/I/71ItB1ZwOcL.jpg'),
                                          (71, 'https://images-na.ssl-images-amazon.com/images/I/71paiJXVO2L.jpg');


-- 72. Anbernic RG Arc-D Gray (Sản phẩm gốc - Độc bản)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Gray', '#808080', 2, 10, 'Anbernic RG Arc-D',
        'Máy chơi game Retro thiết kế tay cầm SEGA Saturn với hệ điều hành kép (Android & Linux).',
        'Anbernic RG Arc mang đến sự hoài niệm tuyệt đối với bố cục 6 nút bấm mặt trước, cực kỳ tối ưu cho các tựa game đối kháng và hệ máy SEGA. Máy sử dụng màn hình IPS 4.0 inch sắc nét, hỗ trợ cảm ứng (trên bản D) và khả năng giả lập mượt mà đến các hệ máy PSP, Dreamcast và Nintendo 64.',
        'CPU: RK3566 Quad-core, RAM: 2GB LPDDR4, Màn hình: 4.0 inch IPS (640x480), Hệ điều hành: Android 11 & Linux.',
        2890000, 3290000, 'https://images-na.ssl-images-amazon.com/images/I/61E8m4Vx8zL.jpg', NOW(), 3500, 6, 310, 1, 'anbernic-rg-arc-d', 0, 'SEGA Saturn, Dreamcast, PSP, PS1, NDS giả lập', 'Wi-Fi 5G, Bluetooth 4.2, Mini HDMI, USB-C (OTG)', 'Bảo hành 6 tháng, Tặng thẻ nhớ 128GB full game và cường lực'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (72, 'https://images-na.ssl-images-amazon.com/images/I/71ZPO-j67yL.jpg'),
                                          (72, 'https://images-na.ssl-images-amazon.com/images/I/714MVs8MCvL.jpg'),
                                          (72, 'https://images-na.ssl-images-amazon.com/images/I/718rvTzX8tL.jpg'),
                                          (72, 'https://images-na.ssl-images-amazon.com/images/I/71t4Vs21soL.jpg'),
                                          (72, 'https://images-na.ssl-images-amazon.com/images/I/71zaj8p1PrL.jpg');


-- 73. Anbernic RG477V - Black (Sản phẩm gốc)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (NULL, 'Black', '#1C1C1C', 2, 10, 'Anbernic RG477V', 'Máy dọc mạnh nhất hiện nay.', 'Cân tốt PS2 và Wii U với thiết kế cổ điển.', 'Android 13, 8GB RAM', 6789000, 6987000,
     'https://images-na.ssl-images-amazon.com/images/I/61vu3UMymsL.jpg', NOW(), 5500, 8, 334, 1, 'anbernic-rg477v', 1, 'Android', 'WiFi & BT', 'Bảo hành 12 tháng');

INSERT INTO gallary (product_id, img) VALUES
                                          (73, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-2-300x300.jpg'),
                                          (73, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-4-300x300.jpg'),
                                          (73, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-6.jpg');

-- 74. Anbernic RG477V - Gray (Con của 73)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (73, 'Gray', '#708090', 2, 10, 'Anbernic RG477V', 'Máy dọc mạnh nhất hiện nay.', 'Cân tốt PS2 và Wii U với thiết kế cổ điển.', 'Android 13, 8GB RAM', 6789000, 6987000,
     'https://images-na.ssl-images-amazon.com/images/I/61sCdVsT0SL.jpg', NOW(), 5500, 8, 334, 1, 'anbernic-rg477v', 1, 'Android', 'WiFi & BT', 'Bảo hành 12 tháng');

INSERT INTO gallary (product_id, img) VALUES
                                          (74, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-3.jpg'),
                                          (74, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-5.jpg'),
                                          (74, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-1-300x300.jpg');


-- 75. Anbernic RG35XXSP (Sản phẩm gốc - Độc bản)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (NULL, 'Silver', '#C0C0C0', 2, 10, 'Anbernic RG35XXSP', 'Thiết kế nắp gập huyền thoại.', 'Tái hiện GBA SP với màn hình IPS 3.5 inch.', 'IPS 3.5 inch', 1800000, 1990000,
     'https://file.hstatic.net/200000272737/file/rg35xx-sp-gia-re_grande.jpg', NOW(), 3300, 6, 200, 1, 'anbernic-rg35xxsp', 0, 'Retro Systems', 'WiFi', 'Bảo hành 12 tháng');

INSERT INTO gallary (product_id, img) VALUES
                                          (75, 'https://file.hstatic.net/200000272737/file/240612_edit-_review_rg35xxsp_3.00_06_04_16.still004_grande.jpg'),
                                          (75, 'https://file.hstatic.net/200000272737/file/gameboy-sp_grande.jpg'),
                                          (75, 'https://file.hstatic.net/200000272737/file/rg35xx-sp-topo_grande.jpg'),
                                          (75, 'https://file.hstatic.net/200000272737/file/240612_edit-_review_rg35xxsp_3.00_01_52_23.still003_grande.jpg');



-- 76. Anbernic RG406V - Beige White (Sản phẩm gốc)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (NULL, 'Beige White', '#F5F5DC', 2, 10, 'Anbernic RG406V', 'Máy dọc chuyên game 3D cũ.', 'Sức mạnh vượt trội, màn hình 4 inch sắc nét.', '256GB Storage', 5000000, 6190000,
     'https://images-na.ssl-images-amazon.com/images/I/71L85D6EtjL.jpg', NOW(), 4500, 8, 260, 1, 'anbernic-rg406', 0, 'Retro systems', 'WiFi', 'Bảo hành 12 tháng');

INSERT INTO gallary (product_id, img) VALUES
                                          (76, 'https://images-na.ssl-images-amazon.com/images/I/71RJA40wgSL.jpg'),
                                          (76, 'https://images-na.ssl-images-amazon.com/images/I/617O2KuOFaL.jpg'),
                                          (76, 'https://images-na.ssl-images-amazon.com/images/I/81o+z6s1TgL.jpg'),
                                          (76, 'https://images-na.ssl-images-amazon.com/images/I/81qH5MSFZVL.jpg'),
                                          (76, 'https://images-na.ssl-images-amazon.com/images/I/71lCw5HLVBL.jpg');

-- 77. Anbernic RG406V - Black (Con của 76)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (76, 'Black', '#1F1F1F', 2, 10, 'Anbernic RG406V', 'Máy dọc chuyên game 3D cũ.', 'Sức mạnh vượt trội, màn hình 4 inch sắc nét.', '256GB Storage', 5000000, 6190000,
     'https://images-na.ssl-images-amazon.com/images/I/71387aDX4kL.jpg', NOW(), 4500, 8, 260, 1, 'anbernic-rg406', 0, 'Retro systems', 'WiFi', 'Bảo hành 12 tháng');

INSERT INTO gallary (product_id, img) VALUES
                                          (77, 'https://images-na.ssl-images-amazon.com/images/I/71lCw5HLVBL.jpg'),
                                          (77, 'https://images-na.ssl-images-amazon.com/images/I/71SzCda+V2L.jpg'),
                                          (77, 'https://images-na.ssl-images-amazon.com/images/I/61xJ6bPYrnL.jpg'),
                                          (77, 'https://images-na.ssl-images-amazon.com/images/I/81Y2y8hZiCL.jpg'),
                                          (77, 'https://images-na.ssl-images-amazon.com/images/I/81ntSojVRRL.jpg');



-- 78. Anbernic RG353PS (Sản phẩm gốc - Độc bản)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (NULL, 'Transparent Gray', '#4F4F4F', 2, 10, 'Anbernic RG353PS', 'Thiết kế lấy cảm hứng SNES.', 'Vỏ trong suốt, phím bấm êm ái, chạy Linux.', 'SNES Retro Style', 2200000, 2450000,
     'https://images-na.ssl-images-amazon.com/images/I/61p3e9J5PpL.jpg', NOW(), 3500, 6, 210, 1, 'anbernic-rg353ps', 0, 'Linux Retro', 'WiFi', 'Bảo hành 12 tháng');

INSERT INTO gallary (product_id, img) VALUES
                                          (78, 'https://izzygame.com/wp-content/uploads/2023/05/may-choi-game-cam-tay-anbernic-rg353ps-8.jpg'),
                                          (78, 'https://izzygame.com/wp-content/uploads/2023/05/may-choi-game-cam-tay-anbernic-rg353ps-6.jpg'),
                                          (78, 'https://izzygame.com/wp-content/uploads/2023/05/may-choi-game-cam-tay-anbernic-rg353ps-2.jpg'),
                                          (78, 'https://izzygame.com/wp-content/uploads/2023/05/may-choi-game-cam-tay-anbernic-rg353ps-4.jpg'),
                                          (78, 'https://izzygame.com/wp-content/uploads/2023/05/may-choi-game-cam-tay-anbernic-rg353ps-5.jpg');


-- 79. Anbernic RG DS (Sản phẩm gốc - Độc bản)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'White', '#FFFFFF', 2, 10, 'Anbernic RG DS',
        'Thiết kế hai màn hình độc đáo, tối ưu cho các dòng game giả lập Dual-Screen.',
        'Anbernic RG DS mang đến trải nghiệm chơi game màn hình đôi hoàn hảo trên nền tảng Android. Bạn có thể dùng màn hình thứ hai để hiển thị menu, bản đồ hoặc điều khiển cảm ứng, giúp việc giả lập các hệ máy hai màn hình trở nên chân thực hơn bao giờ hết.',
        'Thiết kế Dual-Screen, Chạy Android, Hỗ trợ màn hình cảm ứng dưới.',
        2990000, 3299000, 'https://izzygame.com/wp-content/uploads/2025/12/anbernic-rgds-3.jpg', NOW(), 4000, 5, 321, 1, 'anbernic-rg-ds', 0, 'Game Android & Giả lập Retro (NDS, 3DS...)', 'WiFi & Bluetooth', 'Bảo hành 6 tháng, Tặng kèm thẻ nhớ'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (79, 'https://izzygame.com/wp-content/uploads/2025/12/anbernic-rgds.jpg'),
                                          (79, 'https://izzygame.com/wp-content/uploads/2025/12/anbernic-rgds-4.jpg'),
                                          (79, 'https://izzygame.com/wp-content/uploads/2025/12/anbernic-rgds-2.jpg');



-- 80. Anbernic RG 476H (Sản phẩm gốc - Độc bản)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Black', '#242424', 2, 10, 'Anbernic RG 476H',
        'Máy chơi game Android cấu hình mạnh với màn hình 120Hz siêu mượt.',
        'Anbernic 476H sở hữu màn hình tỉ lệ 4:3 lý tưởng cho game retro nhưng lại được trang bị tần số quét 120Hz hiện đại. Điều này giúp các tựa game Android và hiệu ứng chuyển cảnh trở nên cực kỳ mượt mà, kết hợp với cấu hình mạnh mẽ để cân tốt các hệ máy 3D.',
        'Màn hình: 120Hz, Tỉ lệ: 4:3, Chip xử lý hiệu năng cao.',
        3790000, 3990000, 'https://izzygame.com/wp-content/uploads/2025/09/anbernic-rg476h-120hz-9-1.jpg', NOW(), 5000, 6, 290, 1, 'anbernic-rg-476h', 0, 'Game Android & Giả lập các hệ máy 3D', 'WiFi & Bluetooth', 'Bảo hành 12 tháng, Tặng dán cường lực'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (80, 'https://izzygame.com/wp-content/uploads/2025/09/anbernic-rg476h-120hz-2-1.jpg'),
                                          (80, 'https://izzygame.com/wp-content/uploads/2025/09/anbernic-rg476h-120hz-3-1.jpg'),
                                          (80, 'https://izzygame.com/wp-content/uploads/2025/09/anbernic-rg476h-120hz-6-1.jpg'),
                                          (80, 'https://izzygame.com/wp-content/uploads/2025/09/anbernic-rg476h-120hz-7-1.jpg'),
                                          (80, 'https://izzygame.com/wp-content/uploads/2025/09/anbernic-rg476h-120hz-8-1.jpg');



-- 81. Anbernic RG353M (Sản phẩm gốc - Độc bản)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Matte Gray', '#5C5C5C', 2, 10, 'Anbernic RG353M',
        'Phiên bản vỏ kim loại sang trọng với hệ điều hành kép Android & Linux.',
        'RG353M mang lại trải nghiệm cầm nắm cao cấp với vỏ nhôm CNC. Hỗ trợ cảm ứng trên Android và tối ưu giả lập trên Linux, đi kèm cần Analog Hall Effect chống trôi.',
        'CPU: RK3566, RAM: 2GB LPDDR4, Màn hình: 3.5 inch IPS Touch, Dual OS.',
        3990000, 4490000, 'https://anbernic.com/cdn/shop/products/RG353M.jpg?v=1746003726&width=800', NOW(), 3500, 9, 232, 1, 'anbernic-rg353m-metal', 1, 'Hall Joystick, Dual OS, HDMI Out', 'USB-C, WiFi 5G, Bluetooth 4.2', 'Bảo hành 6 tháng, Tặng thẻ nhớ 64GB full game'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (81, 'https://anbernic.com/cdn/shop/products/bddd794f717f28ede0d9fccf7ad135d.jpg?v=1746003726&width=800'),
                                          (81, 'https://anbernic.com/cdn/shop/products/23cd5a036af3b02d097308cdd908e19.jpg?v=1746003726&width=800'),
                                          (81, 'https://anbernic.com/cdn/shop/products/5b61327dc9850c05631a7be60d7558e.jpg?v=1746003726&width=800'),
                                          (81, 'https://anbernic.com/cdn/shop/products/fee3b4a7fdf674187e502b12c066799.jpg?v=1746003726&width=800');

-- 12. Miyoo (Brand 12)
-- 82. Miyoo Mini Flip - ĐỘC LẬP (FORM NẮP GẬP CLAMSHELL)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Gray', '#808080', 2, 12, 'Miyoo Mini Flip',
        'Thiết kế nắp gập (Clamshell) cổ điển, siêu nhỏ gọn và thời trang.',
        'Miyoo Mini Flip là một trong những sản phẩm được mong đợi nhất, kết hợp giữa sự nhỏ gọn huyền thoại của dòng Mini và thiết kế nắp gập bảo vệ màn hình. Máy cực kỳ phù hợp để bỏ túi và chơi game retro mọi lúc mọi nơi.',
        'Thiết kế gập, Màn hình IPS sắc nét, Hỗ trợ giả lập đa hệ máy.',
        1490000, 1680000, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-11.jpg',
        NOW(), 2500, 6, 200, 1, 'miyoo-mini-flip', 0, 'Emulation nhiều hệ Retro (GBA, NES, SNES, PS1...)', 'Wi-Fi', 'Bảo hành 6 tháng, Tặng thẻ nhớ 64GB'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (82, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-1.jpg'),
                                          (82, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-2.jpg'),
                                          (82, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-3.jpg'),
                                          (82, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-4.jpg'),
                                          (82, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-7.jpg'),
                                          (82, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-10.jpg');


-- 83. Miyoo A30 - ĐỘC LẬP (FORM NẰM NGANG CÓ JOYSTICK)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Retro Gray/Red', '#A6A6A6', 2, 12, 'Miyoo A30',
        'Thiết kế ngang nhỏ gọn tích hợp Joystick, nâng cấp cấu hình mạnh mẽ.',
        'Miyoo A30 là thiết bị cầm tay dáng ngang cực kỳ nhỏ gọn nhưng vẫn được bổ sung Joystick để hỗ trợ tốt hơn cho các tựa game 3D nhẹ như PS1 hay N64. Đây là lựa chọn giá rẻ tuyệt vời cho người mới bắt đầu chơi máy Retro.',
        'Dáng ngang (Horizontal), Tích hợp Joystick, Vỏ nhôm/nhựa cao cấp.',
        1150000, 1780000, 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-5.jpg',
        NOW(), 2600, 5, 270, 1, 'miyoo-a30', 0, 'Nhiều hệ máy Retro (FC, SFC, MD, PS1...)', 'Wi-Fi', 'Bảo hành 6 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (83, 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-2.jpg'),
                                          (83, 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-3.jpg'),
                                          (83, 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-4.jpg'),
                                          (83, 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-6.jpg'),
                                          (83, 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30.jpg');


-- 84. Miyoo Mini Plus (Miyoo Handheld) - ĐỘC LẬP (FORM DỌC CỔ ĐIỂN)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Transparent Black', '#262626', 2, 12, 'Miyoo Mini Plus (Miyoo Handheld)',
        'Máy chơi game Retro quốc dân, hỗ trợ cộng đồng OnionOS cực lớn.',
        'Miyoo Mini Plus là biểu tượng của dòng máy giả lập nhỏ gọn. Với khả năng cài đặt OnionOS, máy mang lại trải nghiệm sử dụng cực kỳ thông minh, tính năng Game Switcher độc đáo giúp bạn chuyển đổi game chỉ trong tích tắc.',
        'OS: Linux (Hỗ trợ OnionOS/DotUI), Màn hình: 3.5 inch IPS, Pin: 3000.',
        1390000, 1480000, 'https://izzygame.com/wp-content/uploads/2023/04/Miyoo-mini-plus-den.jpg',
        NOW(), 3000, 5, 170, 1, 'miyoo-mini-plus', 0, 'Hệ Retro (NES → PS1), Hỗ trợ RetroArch', 'Wi-Fi', 'Bảo hành 6 tháng, Tặng bao chống sốc'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (84, 'https://izzygame.com/wp-content/uploads/2023/04/photo_2023-04-29_21-30-49.jpg'),
                                          (84, 'https://izzygame.com/wp-content/uploads/2023/04/photo_2023-04-29_21-30-48.jpg'),
                                          (84, 'https://izzygame.com/wp-content/uploads/2023/04/photo_2023-04-29_21-30-47.jpg'),
                                          (84, 'https://izzygame.com/wp-content/uploads/2023/04/photo_2023-04-29_21-30-46.jpg'),
                                          (84, 'https://izzygame.com/wp-content/uploads/2023/04/May-choi-game-miyoo-mini-plus.jpg'),
                                          (84, 'https://izzygame.com/wp-content/uploads/2023/04/20230527_152635.jpg');

-- 13. Retroid (Brand 13)
-- 85. Retroid Pocket G2 - ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Black', '#1C1C1C', 2, 13, 'Retroid Pocket G2',
        'Phiên bản nâng cấp mạnh mẽ với khả năng giả lập Android 3D mượt mà.',
        'Retroid Pocket G2 là mẫu máy cầm tay thuộc dòng Android handheld, được tối ưu để chơi tốt các tựa game Android hiện đại và giả lập các hệ máy cũ với hiệu suất cao.',
        'Hệ điều hành Android, Màn hình sắc nét, Hỗ trợ Google Play.',
        6790000, 6980000, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-5.jpg',
        NOW(), 5000, 6, 280, 1, 'retroid-pocket-g2', 0, 'Android games + Emulation', 'WiFi & Bluetooth', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (85, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2.jpg'),
                                          (85, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-6.jpg'),
                                          (85, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-3.jpg'),
                                          (85, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-2.jpg');


-- 86. Retroid Pocket Mini V2 - ĐỘC LẬP (FORM TRÀN VIỀN)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'White', '#FFFFFF', 2, 13, 'Retroid Pocket Mini V2',
        'Thiết kế tràn viền siêu mỏng, mang lại trải nghiệm thị giác hiện đại.',
        'Nâng cấp viền màn hình siêu mỏng giúp tổng thể máy thanh thoát hơn bản V1. Đây là lựa chọn tuyệt vời cho người dùng yêu thích sự nhỏ gọn nhưng vẫn muốn màn hình đẹp.',
        'Màn hình tràn viền, Thiết kế công thái học.',
        4750000, 4980000, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-1.jpg',
        NOW(), 4000, 6, 215, 1, 'retroid-pocket-mini-v2', 0, 'Android & Emulator (PS1, N64, PSP/GC...)', 'WiFi & Bluetooth', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (86, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-9.jpg'),
                                          (86, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-2.jpg'),
                                          (86, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-3.jpg'),
                                          (86, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-6.jpg'),
                                          (86, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-4.jpg'),
                                          (86, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-8.jpg');

-- 87. Retroid Pocket Mini - ĐỘC LẬP (FORM TIÊU CHUẨN)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Gray', '#808080', 2, 13, 'Retroid Pocket Mini',
        'Cấu hình mạnh mẽ trong thân hình nhỏ gọn với chip Snapdragon.',
        'Pocket Mini sở hữu cấu hình Snapdragon mạnh mẽ nhất trong phân khúc máy nhỏ gọn, phù hợp để mang theo mọi lúc mọi nơi mà không lo về hiệu năng.',
        'Chip Snapdragon, Thiết kế nhỏ gọn.',
        3990000, 4199000, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-1.jpg',
        NOW(), 4000, 6, 215, 1, 'retroid-pocket-mini', 0, 'Android & Emulator', 'WiFi & Bluetooth', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (87, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-2.jpg'),
                                          (87, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-3.jpg'),
                                          (87, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865.jpg'),
                                          (87, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-5.jpg');


-- 88. Retroid Pocket Flip 2 - ĐỘC LẬP (FORM NẮP GẬP CLAMSHELL)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Indigo', '#4B0082', 2, 13, 'Retroid Pocket Flip 2',
        'Máy handheld Android nắp gập độc đáo với màn hình OLED.',
        'Trang bị màn hình OLED cực đẹp với thiết kế Clamshell (nắp gập) bảo vệ màn hình. Viền màn hình mỏng hơn giúp tối ưu không gian hiển thị.',
        'Thiết kế nắp gập, Màn hình OLED.',
        4590000, 4890000, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-1.jpg',
        NOW(), 5000, 7, 300, 1, 'retroid-pocket-flip-2', 1, 'Android & Retro systems', 'WiFi & Bluetooth', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (88, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-4.jpg'),
                                          (88, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-10.jpg'),
                                          (88, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-8.jpg'),
                                          (88, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-6.jpg'),
                                          (88, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-5.jpg');


-- 89. Retroid Pocket 2S - ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Retro 16-Bit', '#D3D3D3', 2, 13, 'Retroid Pocket 2S',
        'Bản nâng cấp phím bấm và cần Analog Hall Effect đáng giá.',
        'Retroid Pocket 2S cải thiện đáng kể về cảm giác bấm và độ bền nhờ cần Analog chống trôi (Hall Effect), phù hợp cho các tựa game yêu cầu độ chính xác cao.',
        'Analog Hall Effect, Cấu hình khỏe tầm trung.',
        2450000, 2890000, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-4.jpg',
        NOW(), 4000, 6, 200, 1, 'retroid-pocket-2s', 0, 'Android 11, Retroid Launcher', 'Wi-Fi, Bluetooth, HDMI Out', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (89, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-2.jpg'),
                                          (89, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-3.jpg'),
                                          (89, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-5.jpg'),
                                          (89, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s.jpg'),
                                          (89, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-8.jpg');

-- 14. Flydigi (Brand 14)
-- 90. Flydigi Apex 4 Elite - ĐỘC LẬP (DÒNG PREMIUM MÀN HÌNH LED)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Standard White/Gray', '#ECECEC', 3, 14, 'Flydigi Apex 4 Elite',
        'Tay cầm màn hình LED.',
        'Cò nhấn phản hồi lực (Adaptive Trigger) cực đỉnh.',
        'Force Feedback',
        2550000, 2850000, 'https://thegioigames.vn/wp-content/uploads/2025/05/61rCViwRGL._SL1500_-768x768.jpg',
        NOW(), 1500, 30, 300, 1, 'flydigi-apex-4', 1, 'PC/Switch/Android', '2.4G/BT', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (90, 'https://thegioigames.vn/wp-content/uploads/2025/05/71BTQ43xseL._SL1500_-768x768.jpg'),
                                          (90, 'https://thegioigames.vn/wp-content/uploads/2025/05/71qNeC5zHRL._SL1500_-768x768.jpg'),
                                          (90, 'https://thegioigames.vn/wp-content/uploads/2025/05/71QzVgDm9dL._SL1500_.jpg'),
                                          (90, 'https://thegioigames.vn/wp-content/uploads/2025/05/71Vp06k8nML._SL1500_.jpg'),
                                          (90, 'https://thegioigames.vn/wp-content/uploads/2025/05/716ixDM4SRL._SL1500_.jpg');


-- 91. Flydigi Vader 4 Pro - ĐỘC LẬP (DÒNG PREMIUM CƠ HỌC)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Black', '#1A1A1A', 3, 14, 'Flydigi Vader 4 Pro',
        'Phiên bản cao cấp nhất.',
        'Cảm biến Hall Effect, tùy chỉnh lực nhấn.',
        'Hall Effect',
        1550000, 1850000, 'https://thegioigames.vn/wp-content/uploads/2025/05/61MAuaVwXL._SL1500_-768x768.jpg',
        NOW(), 1000, 20, 250, 1, 'vader-4-pro', 1, 'PC/Switch/Mobile', '2.4G/BT', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (91, 'https://thegioigames.vn/wp-content/uploads/2025/05/61N4TDejSjL._SL1500_-768x768.jpg'),
                                          (91, 'https://thegioigames.vn/wp-content/uploads/2025/05/71ldHa8FzL._SL1500_-768x768.jpg'),
                                          (91, 'https://thegioigames.vn/wp-content/uploads/2025/05/71MHrF3u3EL._SL1500_.jpg'),
                                          (91, 'https://thegioigames.vn/wp-content/uploads/2025/05/71r48mcq9YL._SL1500_.jpg'),
                                          (91, 'https://thegioigames.vn/wp-content/uploads/2025/05/81OBvfZyXeL._SL1500_.jpg');


-- 92. Flydigi Dune Fox - ĐỘC LẬP (DÒNG ENTRY-LEVEL)
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Cyber Gray', '#5A5A5A', 3, 14, 'Flydigi Dune Fox',
        'Thiết kế hiện đại.',
        'Joystick độ nhạy cao.',
        'Joystick High Precision',
        419000, 550000, 'https://thegioigames.vn/wp-content/uploads/2025/05/61MjZgrzoXL._SL1500_-768x768.jpg',
        NOW(), 800, 15, 240, 1, 'dune-fox', 0, 'PC/Android', 'BT/USB', 'Bảo hành 6 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (92, 'https://thegioigames.vn/wp-content/uploads/2025/05/Dune-Fox-768x768.png'),
                                          (92, 'https://thegioigames.vn/wp-content/uploads/2025/05/61n7UCFTjlL._SL1500_-768x768.jpg'),
                                          (92, 'https://thegioigames.vn/wp-content/uploads/2025/05/61wAFbTE-oL._SL1500_.jpg'),
                                          (92, 'https://thegioigames.vn/wp-content/uploads/2025/05/61tsU9R8hbL._SL1500_.jpg'),
                                          (92, 'https://thegioigames.vn/wp-content/uploads/2025/05/71bCFBFTGL._SL1500_.jpg');

-- 15. Aokzoe (Brand 15)
-- 93. Aokzoe A1 - ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Classic Blue/Black', '#1B1B22', 3, 15, 'Aokzoe A1',
        'Tay cầm chơi game đa nền tảng.',
        'Thiết kế công thái học, hỗ trợ nhiều hệ máy.',
        'Multi-platform', 1200000, 1500000, 'https://images-na.ssl-images-amazon.com/images/I/61qQkXkKx1L.jpg',
        NOW(), 1200, 25, 220, 1, 'aokzoe-a1', 0, 'PC/Switch/Android', '2.4G/BT', 'Bảo hành 12 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (93, 'https://images-na.ssl-images-amazon.com/images/I/51PAW-qCi+L.jpg'),
                                          (93, 'https://images-na.ssl-images-amazon.com/images/I/518C5G8+z6L.jpg'),
                                          (93, 'https://images-na.ssl-images-amazon.com/images/I/71YtIeg-jhL.jpg'),
                                          (93, 'https://images-na.ssl-images-amazon.com/images/I/71MIudpYilL.jpg');

-- 16. Khác (Brand 16)
-- 94. Atari Flashback X - ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Woodgrain Classic', '#8B5A2B', 1, 11, 'Atari Flashback X',
        'Phiên bản thu nhỏ của máy Atari 2600 huyền thoại với 110 trò chơi cài sẵn.',
        'Atari Flashback X mang thiết kế đặc trưng của thập niên 70 với lớp vỏ giả vân gỗ sang trọng. Máy hỗ trợ xuất hình HDMI 720p sắc nét, cho phép bạn trải nghiệm lại những tựa game kinh đích như Asteroids, Centipede và Missile Command với độ phân giải cao.',
        'CPU: ARM Cortex, Game: 110 trò cài sẵn, Cổng xuất: HDMI 720p.',
        1790000, 2190000, 'https://i.ebayimg.com/images/g/x7UAAOSwTI1jmDPa/s-l1600.webp',
        NOW(), 543, 5, 170, 1, 'atari-flashback-x', 0, '110 Classic Games, Save/Rewind Function', 'HDMI, 2x Wired Joystick Ports', 'Bảo hành 6 tháng, Tặng kèm 2 tay cầm Joystick nguyên bản'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (94, 'https://i.ebayimg.com/images/g/GdEAAOSwSTpjmWyK/s-l960.webp'),
                                          (94, 'https://m.media-amazon.com/images/I/51WJQCLznlL._SL1000_.jpg'),
                                          (94, 'https://m.media-amazon.com/images/I/61mGGlb8SHL._SL1000_.jpg');


-- 95. Neo Geo Mini International Edition - ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'International Edition Blue/White', '#104E8B', 1, 11, 'Neo Geo Mini International',
        'Máy Arcade mini tích hợp màn hình và 40 tựa game đối kháng huyền thoại từ SNK.',
        'Neo Geo Mini International là một "tủ game thùng" thu nhỏ ngay trên bàn làm việc của bạn. Máy sở hữu màn hình 3.5 inch tích hợp, cần gạt Joystick chất lượng cao và cài sẵn những siêu phẩm đối kháng như King of Fighters, Metal Slug và Samurai Shodown.',
        'Màn hình: 3.5 inch LCD, Game: 40 trò tích hợp, Cổng: HDMI (xuất TV), Jack 3.5mm.',
        2490000, 2990000, 'https://images-na.ssl-images-amazon.com/images/I/61bNh7r-r9L.jpg',
        NOW(), 5, 7, 540, 1, 'neo-geo-mini-international', 1, '40 SNK Classic Games, Stereo Speakers', 'HDMI (Mini), USB-C (Power), 2x Controller Ports', 'Bảo hành 6 tháng, Tặng kèm cáp sạc và hỗ trợ cài đặt'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (95, 'https://m.media-amazon.com/images/I/41H7Uq4AorL.jpg'),
                                          (95, 'https://m.media-amazon.com/images/I/61Iv3j3MY5L._SL1500_.jpg'),
                                          (95, 'https://m.media-amazon.com/images/I/51hQ4f1xFJL._SL1500_.jpg'),
                                          (95, 'https://m.media-amazon.com/images/I/81JXvSKx89L._SL1500_.jpg'),
                                          (95, 'https://m.media-amazon.com/images/I/81sQ9E1Zr3L._SL1500_.jpg');


-- 96. Q8 Retro Handheld - ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Red/Blue', '#FF0000', 2, 11, 'Q8 Retro Handheld',
        '10.000 trò chơi retro.',
        'Màn hình 3.0 inch, nhỏ gọn dễ mang theo.',
        '10.000+ Games',
        550000, 750000, 'https://i.ebayimg.com/images/g/30EAAOSw4B5mzXjQ/s-l1600.webp',
        NOW(), 1500, 5, 150, 1, 'mini-q8', 0, 'Retro games', 'USB', 'Bảo hành 3 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (96, 'https://i.ebayimg.com/images/g/6ZoAAOSwLpZmzXjY/s-l960.webp'),
                                          (96, 'https://i.ebayimg.com/images/g/cYwAAOSw-EBmzXja/s-l960.webp'),
                                          (96, 'https://i.ebayimg.com/images/g/clwAAOSwJtVmzXjm/s-l960.webp'),
                                          (96, 'https://i.ebayimg.com/images/g/QVAAAOSwSz1mzXjo/s-l960.webp'),
                                          (96, 'https://i.ebayimg.com/images/g/SrMAAOSwredmzXjr/s-l960.webp'),
                                          (96, 'https://i.ebayimg.com/images/g/OFMAAOSwjeJmzXjV/s-l960.webp');


-- 97. GKD Pixel X2 - ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Matte Black', '#222222', 2, 11, 'GKD Pixel X2',
        'Phong cách Pixel hoài cổ.',
        'Tích hợp hơn 8.000 trò chơi cổ điển.',
        '8.000+ Games',
        450000, 600000, 'https://i.ebayimg.com/images/g/n8kAAeSwQy5o5jWl/s-l1600.webp',
        NOW(), 1200, 4, 130, 1, 'pixel-x2', 0, 'Retro games', 'USB', 'Bảo hành 3 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (97, 'https://i.ebayimg.com/images/g/oB4AAeSwhjdo5jWt/s-l960.webp'),
                                          (97, 'https://i.ebayimg.com/images/g/rzsAAeSwfT9o5jWv/s-l960.webp'),
                                          (97, 'https://i.ebayimg.com/images/g/oAsAAeSwQy5o5jWx/s-l960.webp'),
                                          (97, 'https://i.ebayimg.com/images/g/oAsAAeSwQy5o5jWx/s-l960.webp');


-- 98. Razer Wolverine V2 Chroma - ĐỘC LẬP
INSERT INTO products (parent_id, color_name, color_code, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
    (
        NULL, 'Black RGB', '#000000', 3, 15, 'Razer Wolverine V2 Chroma',
        'Tay cầm Gaming cơ học RGB.',
        'Nút bấm Mecha-Tactile và hệ thống LED Chroma.',
        '6 Nút đa năng',
        3600000, 3990000, 'https://i.ebayimg.com/images/g/klEAAeSwQA1pvXJp/s-l1600.webp',
        NOW(), 0, 0, 270, 1, 'razer-wolverine-v2', 1, 'Xbox/PC', 'Có dây', 'Bảo hành 24 tháng'
    );

INSERT INTO gallary (product_id, img) VALUES
                                          (98, 'https://i.ebayimg.com/images/g/z6YAAeSwpAtpvXIv/s-l960.webp'),
                                          (98, 'https://i.ebayimg.com/images/g/0gIAAeSw1gJpvXI1/s-l960.webp'),
                                          (98, 'https://i.ebayimg.com/images/g/0DEAAeSwpAtpvXI6/s-l960.webp'),
                                          (98, 'https://i.ebayimg.com/images/g/lJsAAeSw6QBpvXJG/s-l960.webp'),
                                          (98, 'https://i.ebayimg.com/images/g/BvAAAeSw5JppvXJL/s-l960.webp');


update products
set full_description = 'Tay cầm chơi game Flydigi Vader 4 Pro Controller là phiên bản cao cấp với hiệu năng vượt trội, đáp ứng nhu cầu chơi game chuyên nghiệp.
Trang bị cảm biến Hall Effect giúp chống drift hiệu quả, tăng độ bền và độ chính xác trong quá trình sử dụng lâu dài.
Hỗ trợ kết nối đa chế độ gồm Bluetooth, 2.4G Wireless và cổng có dây, tương thích linh hoạt với PC, Android và iOS.
Hệ thống trigger và joystick có thể tùy chỉnh, mang lại khả năng điều khiển mượt mà và phản hồi nhanh trong từng thao tác.
Thiết kế công thái học hiện đại kết hợp pin dung lượng cao, giúp game thủ thoải mái chơi game liên tục trong nhiều giờ.
'
WHERE ID = 6;

update products
set full_description = 'Tay Cầm Chơi Game Flydigi Nova 3 Controller sở hữu thiết kế hiện đại, mang lại cảm giác cầm nắm chắc tay và thoải mái khi chơi lâu.
Trang bị joystick và nút bấm có độ nhạy cao, giúp thao tác chính xác và phản hồi nhanh trong mọi tựa game.
Hỗ trợ kết nối Bluetooth và USB, tương thích tốt với PC, Android và iOS, dễ dàng sử dụng trên nhiều nền tảng.
Pin dung lượng lớn cho thời gian chơi liên tục dài, hạn chế gián đoạn trong quá trình giải trí.
Flydigi Nova 3 là lựa chọn phù hợp cho game thủ phổ thông cần một tay cầm ổn định, bền bỉ và dễ sử dụng.

'
WHERE ID = 7;

UPDATE products
SET full_description = 'Flydigi Apex 4 Elite là đỉnh cao công nghệ tay cầm với tính năng Force Feedback Trigger (cò phản hồi lực) có thể thay đổi độ nặng nhẹ.
Trang bị màn hình LED tích hợp cho phép tùy chỉnh ảnh GIF và thông số trực tiếp.
Sử dụng công nghệ Joystick hợp kim chống mài mòn và cảm biến Hall Effect cho độ chính xác tuyệt đối.
Đây là lựa chọn số 1 cho game thủ muốn trải nghiệm công nghệ tương lai trên PC và Switch.'
WHERE ID = 8;

update products
set full_description = 'Flydigi Galaxy 4 Pro Controller là dòng tay cầm cao cấp với hiệu năng vượt trội cho game thủ chuyên nghiệp.
Trang bị joystick chính xác và trigger phản hồi nhanh, hỗ trợ tốt các tựa game hành động và bắn súng.
Kết nối đa chế độ giúp tương thích linh hoạt với PC, Android và iOS.
Thiết kế chắc chắn, vật liệu cao cấp mang lại độ bền cao trong quá trình sử dụng.
Galaxy 4 Pro mang đến trải nghiệm điều khiển mượt mà và ổn định.
'
WHERE ID = 9;

update products
set full_description = 'Máy Game Retro Mini Q8 sở hữu màn hình 3.5 inch rõ nét, tái hiện trọn vẹn các tựa game cổ điển.
Tích hợp sẵn hơn 10.000 trò chơi retro từ nhiều hệ máy huyền thoại.
Thiết kế nhỏ gọn, dễ dàng mang theo để giải trí mọi lúc mọi nơi.
Hỗ trợ pin sạc tiện lợi, cho thời gian chơi ổn định.
Mini Q8 là lựa chọn lý tưởng cho người yêu thích game retro hoài niệm.
'
WHERE ID = 10;

update products
set full_description = 'Máy Game Retro Pixel X2 được trang bị màn hình 3.0 inch nhỏ gọn, phù hợp chơi game di động.
Kho game hơn 8.000 tựa game cổ điển giúp người chơi thoải mái lựa chọn.
Giao diện đơn giản, dễ sử dụng cho mọi đối tượng.
Thiết kế nhẹ, tiện lợi mang theo khi di chuyển.
Pixel X2 mang lại trải nghiệm giải trí retro đơn giản và hiệu quả.
'
WHERE ID = 11;

UPDATE products
SET full_description = 'Miyoo Mini Plus là phiên bản nâng cấp hoàn hảo với màn hình 3.5 inch IPS sắc nét và tích hợp WiFi để chơi cùng bạn bè.
Máy hỗ trợ cộng đồng cực lớn với hệ điều hành OnionOS, giúp tối ưu hóa hiệu năng chơi các hệ máy từ NES, SNES đến PS1.
Thiết kế cổ điển, kích thước vừa vặn và nút bấm êm ái khiến đây là mẫu máy retro bán chạy nhất hiện nay.'
WHERE ID = 12;

UPDATE products
SET full_description = 'Tay cầm Acer Nitro NGR300 sở hữu thiết kế công thái học chắc chắn với tông màu đen đỏ đặc trưng của dòng Nitro.
Hỗ trợ rung kép (Dual Vibration) mang lại cảm giác chân thực khi va chạm trong game.
Kết nối linh hoạt qua USB hoặc Bluetooth với độ trễ cực thấp, là phụ kiện bền bỉ cho game thủ PC và Android.'
WHERE ID = 13;

UPDATE products
SET full_description = 'Nintendo Switch Lite Coral là phiên bản máy chơi game cầm tay thuần túy với thiết kế nhỏ gọn, nhẹ nhàng và màu sắc San Hô thời trang.
Máy được tích hợp sẵn tay cầm, không thể tháo rời, tối ưu hoàn toàn cho trải nghiệm di động.
Bạn có thể thưởng thức toàn bộ thư viện game khổng lồ của Nintendo như Zelda, Mario, Pokemon ở bất cứ đâu.'
WHERE ID = 14;

UPDATE products
SET full_description = 'Nintendo Switch V2 Neon Blue/Red là phiên bản cải tiến thời lượng pin vượt trội so với thế hệ đầu.
Sở hữu khả năng chuyển đổi linh hoạt 3 chế độ: Chơi trên TV qua Dock, chế độ để bàn và chế độ cầm tay.
Tay cầm Joy-Con có thể tháo rời để chơi các tựa game vận động như Ring Fit Adventure hoặc Just Dance, mang lại trải nghiệm giải trí gia đình tuyệt vời.'
WHERE ID = 15;

update products
set full_description = 'Máy Game Retro Mini Z3 được trang bị màn hình 3.0 inch nhỏ gọn, hiển thị rõ nét.
Kho game hơn 12.000 trò chơi retro mang lại trải nghiệm giải trí đa dạng.
Thiết kế tiện lợi, dễ dàng mang theo khi di chuyển.
Pin sạc dung lượng ổn định cho thời gian chơi liên tục.
Mini Z3 là lựa chọn phù hợp cho người yêu thích game cổ điển.
'
WHERE ID = 16;

UPDATE products
SET full_description = 'Ayaneo Pocket Micro là tuyệt tác handheld Android với khung viền kim loại CNC cao cấp, kích thước chỉ bằng một chiếc điện thoại mini.
Màn hình không viền cực kỳ sắc nét, tỷ lệ 4:3 lý tưởng cho các dòng game retro đỉnh cao.
Dù nhỏ gọn nhưng máy vẫn sở hữu sức mạnh đáng nể để vận hành mượt mà các ứng dụng giả lập và game Android hiện đại.'
WHERE ID = 23;

-- ID 1: PlayStation 5 Slim
UPDATE products SET full_description = 'PlayStation 5 Slim là cuộc cách mạng về thiết kế của Sony, mỏng nhẹ hơn 30% và giảm trọng lượng đáng kể nhưng vẫn duy trì sức mạnh đồ họa 4K mạnh mẽ. Với ổ cứng SSD 1TB tốc độ siêu cao, người chơi sẽ được trải nghiệm công nghệ Ray Tracing chân thực và thời gian tải game gần như bằng không. Đi kèm là tay cầm DualSense với phản hồi rung (Haptic Feedback) và cò thích ứng (Adaptive Triggers), mang lại cảm giác nhập vai sâu sắc trong các siêu phẩm như God of War Ragnarök hay Marvel’s Spider-Man 2.' WHERE ID = 1;

-- ID 4: Xbox Series X
UPDATE products SET full_description = 'Xbox Series X là cỗ máy chơi game mạnh mẽ nhất thế giới với sức mạnh tính toán lên đến 12 Teraflops. Được thiết kế cho hiệu suất tối ưu, máy hỗ trợ độ phân giải 4K tại tốc độ khung hình lên đến 120 FPS, mang lại hình ảnh mượt mà tuyệt đối. Tính năng Quick Resume độc quyền cho phép bạn chuyển đổi qua lại giữa nhiều trò chơi khác nhau trong tích tắc. Đây là thiết bị hoàn hảo để tận hưởng dịch vụ Xbox Game Pass với hàng trăm tựa game đỉnh cao từ Microsoft Studios và các đối tác lớn.' WHERE ID = 4;

-- ID 17: Nintendo Switch OLED Model
UPDATE products SET full_description = 'Nintendo Switch OLED Model nâng tầm trải nghiệm chơi game cầm tay với màn hình OLED 7 inch rực rỡ, màu sắc sâu và độ tương phản hoàn hảo. Ngoài màn hình, phiên bản này còn được nâng cấp chân đế bản rộng linh hoạt hơn, bộ nhớ trong gấp đôi (64GB) và hệ thống loa cải tiến rõ rệt. Dock đi kèm giờ đây đã tích hợp sẵn cổng LAN có dây, giúp đảm bảo kết nối ổn định khi chơi các tựa game trực tuyến như Splatoon 3 hay Super Smash Bros. Ultimate.' WHERE ID = 17;

-- ID 19: Steam Deck OLED 512GB
UPDATE products SET full_description = 'Steam Deck OLED không chỉ đơn thuần là một bản nâng cấp màn hình, mà là sự hoàn thiện của dòng Handheld PC. Màn hình HDR OLED 7.4 inch mang lại màu đen sâu thẳm và độ sáng rực rỡ, khiến mọi tựa game từ Steam đều trở nên sống động hơn. Pin đã được cải thiện đáng kể, cung cấp thời gian chơi lâu hơn từ 30-50%. Với hệ điều hành SteamOS tối ưu và hệ thống tản nhiệt mới yên tĩnh hơn, đây là thiết bị cầm tay đáng tin cậy nhất để bạn phá đảo thư viện game PC khổng lồ của mình.' WHERE ID = 19;

-- ID 20: Asus ROG Ally X
UPDATE products SET full_description = 'Asus ROG Ally X là "quái vật" hiệu năng trong phân khúc máy chơi game chạy Windows 11. Được trang bị chip Ryzen Z1 Extreme và nâng cấp lên 24GB RAM LPDDR5X tốc độ cao, máy có thể xử lý mượt mà các tựa game AAA nặng nhất hiện nay. Điểm nhấn lớn nhất là viên pin 80Wh - gấp đôi so với phiên bản cũ, giúp giải quyết hoàn toàn nỗi lo về pin. Hệ thống phím điều khiển, joystick và tản nhiệt cũng được thiết kế lại hoàn toàn để mang lại sự thoải mái tối đa cho những game thủ chuyên nghiệp.' WHERE ID = 20;

-- ID 32: Lenovo Legion Go
UPDATE products SET full_description = 'Lenovo Legion Go sở hữu màn hình lớn nhất trong giới handheld với kích thước 8.8 inch độ phân giải QHD+ (2500x1600) và tần số quét 144Hz. Điểm độc đáo nhất là cặp tay cầm Legion TrueStrike có thể tháo rời, trong đó tay cầm bên phải có thể gắn vào đế chuyên dụng để biến thành một con chuột chơi game FPS cực kỳ chính xác. Máy tích hợp chân đế lớn phía sau, giúp bạn dễ dàng đặt lên bàn để chơi game hoặc xem phim như một chiếc máy tính bảng gaming mạnh mẽ.' WHERE ID = 32;

-- ID 24: Anbernic RG35XXSP
UPDATE products SET full_description = 'Anbernic RG35XXSP là món quà dành cho những ai yêu thích huyền thoại GBA SP. Với thiết kế nắp gập Clamshell cổ điển nhưng mang trong mình phần cứng hiện đại, máy có thể chơi mượt mà từ NES, SNES đến các game PS1 và PSP nhẹ. Màn hình IPS 3.5 inch được bảo vệ an toàn khi gập lại, tích hợp cổng HDMI để xuất hình ảnh ra TV. Tính năng đóng nắp tự động vào chế độ Sleep giúp bạn có thể dừng game và chơi tiếp bất cứ lúc nào một cách nhanh chóng.' WHERE ID = 24;

-- ID 29: Retroid Pocket 5
UPDATE products SET full_description = 'Retroid Pocket 5 là sự kết hợp hoàn hảo giữa thẩm mỹ hiện đại và hiệu năng giả lập mạnh mẽ. Máy sở hữu màn hình OLED 5.5 inch độ phân giải 1080p, mang lại hình ảnh cực kỳ sắc nét cho các tựa game Android và giả lập cao cấp. Được cung cấp sức mạnh bởi chip Snapdragon 865, máy cân tốt các hệ máy khó nhằn như PS2, GameCube và 3DS. Thiết kế mỏng nhẹ, dải đèn LED RGB tùy chỉnh dưới analog và hệ điều hành Android mở khiến đây là chiếc máy đa năng nhất trong tầm giá.' WHERE ID = 29;

-- ID 45: Retroid Pocket Flip 2
UPDATE products SET full_description = 'Retroid Pocket Flip 2 tiếp nối thành công của dòng máy nắp gập với việc nâng cấp lên màn hình OLED rực rỡ và cấu hình mạnh mẽ vượt trội. Thiết kế bản lề chắc chắn giúp bạn tùy chỉnh góc nhìn thoải mái nhất, đồng thời bảo vệ màn hình khỏi trầy xước khi bỏ vào túi xách. Các phím bấm được tinh chỉnh cho độ nảy tốt, cùng với hệ thống tản nhiệt tích cực (quạt tản nhiệt), đảm bảo máy luôn mát mẻ khi chơi các tựa game 3D nặng trong thời gian dài.' WHERE ID = 45;

-- ID 18: Nintendo Switch 2 (Dành cho dự báo/tin đồn sản phẩm mới)
UPDATE products SET full_description = 'Nintendo Switch 2 là thế hệ tiếp theo được kỳ vọng sẽ thay đổi hoàn toàn cục diện máy chơi game cầm tay. Với nâng cấp mạnh mẽ về chip xử lý thế hệ mới, máy hỗ trợ công nghệ DLSS của NVIDIA để mang lại hình ảnh sắc nét như trên các dòng console lớn. Màn hình 8 inch rộng lớn cùng khả năng tương thích ngược với các tựa game của thế hệ cũ, đây chắc chắn là thiết bị không thể thiếu cho bất kỳ fan trung thành nào của Nintendo.' WHERE ID = 18;

-- ID 22: AYANEO 3
UPDATE products SET full_description = 'AYANEO 3 là biểu tượng của sự sang trọng và sức mạnh đỉnh cao với chip AMD Ryzen AI 370 mới nhất. Máy mang đến trải nghiệm Windows 11 mượt mà hơn bao giờ hết nhờ sự hỗ trợ của trí tuệ nhân tạo để tối ưu hóa hiệu năng và pin. Màn hình OLED tràn viền, hệ thống âm thanh vòm và các phím bấm đạt chuẩn e-sports biến AYANEO 3 thành một trạm chơi game di động thực thụ dành cho những người dùng không chấp nhận sự thỏa hiệp về cấu hình.' WHERE ID = 22;

SELECT
    products.ID as ProductID,
    products.name as ProductName,
    categories.name as CategoryName,
    products.endow
FROM products
         JOIN categories ON products.categories_id = categories.ID
WHERE products.ID = 1;

SELECT * FROM products
WHERE priceOld IS NOT NULL
  AND price IS NOT NULL
  AND priceOld > price
  AND active = 1
ORDER BY (priceOld - price) DESC
    LIMIT 1;

SELECT DISTINCT useTime FROM products ORDER BY useTime ASC;

-- LOGO (ID tự tăng, titleLogo, linkLogo)
INSERT INTO logo (titleLogo, linkLogo) VALUES
                                           ('Logo Shop', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaVtA9aH8iRQnDsQmBTt9yyB5mCIaYp8T0Qg&s'),
                                           ('Logo2 Shop', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNhDsdA_PWXkUZ3ijwSU_9rpenL-Dsu_wuFQ&s');

-- ICON (ID tự tăng, title, link_icon, active)
INSERT INTO icon (title, link_icon, active) VALUES
                                                ('fb', '<i class="fab fa-facebook-f"></i>', 1),
                                                ('ytb', '<i class="fab fa-youtube"></i>', 1),
                                                ('tiktok', '<i class="fab fa-tiktok"></i>', 1),
                                                ('ins', '<i class="fab fa-instagram"></i>', 1),
                                                ('x', '<i class="fab fa-twitter"></i>', 1);

-- CONTACT (ID tự tăng, gmail, phone, address)
INSERT INTO contact (gmail, phone, address) VALUES
                                                ('shop@gmail.com', '0123456789', 'Ho Chi Minh City'),
                                                ('shop@gmail.com', '0987654321', 'Đại Học Nông Lâm');

-- BANNER (ID tự tăng, title, link, active)
INSERT INTO banner (title, link, active) VALUES
                                             ('ps5', 'Assets/image/newps5_2.png', 1),
                                             ('ps4', 'Assets/image/newps4_3.png', 1),
                                             ('flydigi apex 5', 'Assets/image/NewFlidigi.png', 1),
                                             ('elite series 2', 'Assets/image/elite2.png', 1),
                                             ('three new version', 'Assets/image/threeversion.png', 1);

-- ABOUT (id tự tăng, section, title, description, image, icon, sort_order)
-- 1. Thêm ảnh bìa giới thiệu (Cần thiết để Servlet không bị lỗi Index 0)
INSERT INTO about (section, title, description, image, sort_order)
VALUES ('INFO_IMAGE', 'Về chúng tôi', 'Đơn vị cung cấp máy chơi game hàng đầu', 'Assets/image/aboutUs_info.png', 1);

-- 2. Thêm thông tin con số (INFO)
INSERT INTO about (section, title, description, sort_order) VALUES
                                                                ('INFO','50+ CỬA HÀNG','Hệ thống cửa hàng phân bố khắp cả nước tại các thành phố lớn.', 1),
                                                                ('INFO','200+ THƯƠNG HIỆU','Sản phẩm đến từ nhiều thương hiệu nổi tiếng, uy tín.', 2),
                                                                ('INFO','3+ TRUNG TÂM TƯ VẤN','Trung tâm hỗ trợ luôn sẵn sàng giải đáp thắc mắc.', 3),
                                                                ('INFO','5000+ KHÁCH HÀNG','Đã làm hài lòng hơn 5.000 khách hàng trong và ngoài nước.', 4);

-- 3. Thêm dịch vụ (SERVICE)
INSERT INTO about (section, description, icon, sort_order) VALUES
                                                               ('SERVICE','Cửa hàng luôn sẵn sàng tư vấn và hỗ trợ mọi thắc mắc của bạn.','fa-headset', 1),
                                                               ('SERVICE','Chúng tôi có dịch vụ giao hàng tận nơi nhanh chóng.','fa-truck-fast', 2),
                                                               ('SERVICE','Thường xuyên có nhiều chương trình khuyến mãi đặc biệt.','fa-gift', 3),
                                                               ('SERVICE','Thông báo cho bạn khi có sản phẩm mới về.','fa-bell', 4);

-- 4. Thêm hoạt động (WHAT_WE_DO)
INSERT INTO about (section, title, description, image, sort_order) VALUES
                                                                       ('WHAT_WE_DO','Sản phẩm của chúng tôi','Đa dạng các loại máy chơi game thoải mái lựa chọn.','Assets/image/aboutUs_product.png', 1),
                                                                       ('WHAT_WE_DO','Đội ngũ của chúng tôi','Nhân viên chuyên nghiệp, nhiệt tình hỗ trợ.','Assets/image/aboutUs_team.png', 2),
                                                                       ('WHAT_WE_DO','Cửa hàng của chúng tôi','Không gian trải nghiệm hiện đại, thân thiện.','Assets/image/aboutUs_store.png', 3);

-- 5. Thêm phần kết (FINAL)
INSERT INTO about (section, description, title, sort_order) VALUES
                                                                ('FINAL','Cửa hàng máy chơi game uy tín nhất khu vực.','Nhóm 17', 1),
                                                                ('FINAL','Chất lượng phục vụ là ưu tiên hàng đầu.','Nhóm 17', 2),
                                                                ('FINAL','Hân hạnh được phục vụ quý khách.','Nhóm 17', 3);

-- BLOG (ID tự tăng, img, title, metatitle, description, active, playorder)
INSERT INTO blog VALUES
                     (null, 'https://i.ytimg.com/vi/CXMRMA9Hh-o/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAE-nfKyVbOygwsMqvVSETSmpn-Eg', 'Review tay cầm PS5 DualSense', 'review-tay-cam', 'Cảm giác rung thông minh, adaptive trigger và khả năng tương thích
                    cực tốt...', 1, 1),
                     (null, 'https://haloshop.vn/wp-content/uploads/2024/11/nhung_tua_game_ps5_hay_nhat_2024-1.jpg', 'Top game hay nhất 2024 trên PS5', 'top-game-hay', 'Tổng hợp những tựa game có đồ họa đẹp, gameplay cuốn và đáng chơi
                    nhất...', 1, 2),
                     (null, 'https://www.droidshop.vn/wp-content/uploads/2023/05/so-sanh-ps5-vs-xbox.jpg', 'So sánh PS5 và Xbox Series X', 'so-sanh', 'Đâu là chiếc máy console phù hợp cho bạn? Cùng xem phân tích chi
                    tiết...', 1, 3),
                     (null, 'https://bizweb.dktcdn.net/100/503/563/files/24.jpg?v=1740329584220', 'Hướng dẫn bảo quản tay cầm', 'baoquantaycam', 'Cách vệ sinh joystick, chống drift và kéo dài tuổi thọ tay cầm...', 1, 4),
                     (null, 'https://hocviengaming.vn/wp-content/uploads/2024/02/nintendo-switch-2-se-co-man-hinh-lcd-8-inch-0.jpg', 'Tin nóng: Nintendo Switch 2 sắp ra mắt?', 'hot new', 'Tổng hợp thông tin rò rỉ mới nhất từ các nguồn uy tín...', 1, 5);


-- Huỳnh Như -21/03
-- THEM FIELD "product_image" vao order_items
ALTER TABLE order_items ADD COLUMN product_image VARCHAR(500);

ALTER TABLE users ADD COLUMN role VARCHAR(50) NOT NULL DEFAULT 'user';

ALTER TABLE products ADD COLUMN stock INT DEFAULT 0,
                     ADD COLUMN sales_count INT DEFAULT 0;

ALTER TABLE products ADD COLUMN stock_quantity INT NOT NULL DEFAULT 0;

-- HUỳnh Như 05/04/2026
ALTER TABLE users ADD COLUMN deleted boolean DEFAULT FALSE;

-- Huỳnh Như 17/04/2026 - Thêm bảng nhập kho và lưu log
CREATE TABLE import_receipts(
                                ID INT AUTO_INCREMENT PRIMARY KEY,
                                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                status VARCHAR(50)
);

CREATE TABLE import_receipt_items (
                                      ID INT AUTO_INCREMENT PRIMARY KEY,
                                      receipt_id INT,
                                      product_id INT,
                                      quantity INT,

                                      FOREIGN KEY (receipt_id) REFERENCES import_receipts(ID),
                                      FOREIGN KEY (product_id) REFERENCES products(ID)

);

CREATE TABLE stock_movements (
                                 ID INT AUTO_INCREMENT PRIMARY KEY,
                                 product_id INT,
                                 quantity INT,
                                 type VARCHAR(50),
                                 created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

                                 FOREIGN KEY (product_id) REFERENCES products(ID)
);

CREATE TABLE product_view_history(
                                     ID INT AUTO_INCREMENT PRIMARY KEY,
                                     user_id INT,
                                     product_id INT,
                                     createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,

                                     CONSTRAINT unique_user_product UNIQUE (user_id, product_id),

                                     FOREIGN KEY (product_id) REFERENCES products(ID),
                                     FOREIGN KEY (user_id) REFERENCES users(ID)
);

UPDATE products
SET stock = 10
WHERE stock = 0;

INSERT IGNORE INTO users (ID, username, password, email)
VALUES (1, 'testuser', '123456', 'test@example.com');


-- ===================== HUỲNH NHƯ (25/04 - 28/04) =====================
-- Chức năng lịch sử nhập kho
ALTER TABLE stock_movements ADD COLUMN user_id INT;
ALTER TABLE stock_movements ADD FOREIGN KEY (user_id) REFERENCES admin(id);

-- Chức năng quản lý contact từ user
CREATE TABLE IF NOT EXISTS contact_message (
                                               ID INT AUTO_INCREMENT PRIMARY KEY,
                                               user_id INT,
                                               name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'NEW'
    );

ALTER TABLE contact_message ADD COLUMN reply TEXT;
ALTER TABLE contact_message ADD COLUMN is_read TINYINT DEFAULT 0;


-- ===================== CHÂU (16/05) =====================
-- Cập nhật thông tin OTP cho bảng users
ALTER TABLE users
    ADD COLUMN otp_code VARCHAR(255),
    ADD COLUMN otp_expiry DATETIME,
    ADD COLUMN otp_attempts INT DEFAULT 0,
    ADD COLUMN forgot_attempts INT DEFAULT 0,
    ADD COLUMN lock_until DATETIME;

ALTER TABLE users
    ADD COLUMN forgot_password_attempts INT DEFAULT 0,
    ADD COLUMN forgot_lock_until DATETIME NULL;

DROP TABLE IF EXISTS otp_tokens;

CREATE TABLE otp_tokens (
                            id INT AUTO_INCREMENT PRIMARY KEY,
                            user_id INT NOT NULL,
                            otp_hash VARCHAR(255) NOT NULL,
                            expired_at DATETIME NOT NULL,
                            failed_attempts INT DEFAULT 0,
                            resend_count INT DEFAULT 0,
                            used BOOLEAN DEFAULT FALSE,
                            lock_until DATETIME NULL,
                            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                            FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ===================== HÂN (30/05) =====================
ALTER TABLE products ADD COLUMN parent_id INT DEFAULT NULL;
ALTER TABLE products ADD COLUMN color_name VARCHAR(50) DEFAULT NULL;
ALTER TABLE products ADD COLUMN color_code VARCHAR(10) DEFAULT NULL;

SET FOREIGN_KEY_CHECKS = 1;