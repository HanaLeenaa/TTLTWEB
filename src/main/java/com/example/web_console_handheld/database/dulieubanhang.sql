CREATE DATABASE dulieubanhang
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE dulieubanhang;

-- ==========================================================
-- 1. XÓA BẢNG CŨ (DROP TABLES) - Thứ tự ngược để tránh lỗi khóa ngoại
-- ==========================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS history, bill, payments, order_items, orders, reviews, 
                     gallary, products, otp_tokens, brands, categories, 
                     users, admin, about, discount, video, blog, banner, 
                     contact, icon, logo;
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================================
-- 2. TẠO CÁC BẢNG 
-- ==========================================================

CREATE TABLE admin (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100),
    status TINYINT DEFAULT 1
);

CREATE TABLE users (
    ID INT AUTO_INCREMENT PRIMARY KEY, 
    username VARCHAR(100),
    password VARCHAR(255),
    email VARCHAR(255),
    fullname VARCHAR(255),
    avatar VARCHAR(255),
    date_of_birth DATE,
    phoneNum VARCHAR(50),
    location VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    lastLogin DATETIME,
    active BOOLEAN
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

CREATE TABLE reviews (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    products_id INT,
    users_id INT,
    rating INT,
    review_text VARCHAR(255),
    imgReviews VARCHAR(255),
    reviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    status BOOLEAN,
    FOREIGN KEY (products_id) REFERENCES products(ID),
    FOREIGN KEY (users_id) REFERENCES users(ID)
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

-- ==========================================================
-- 3. DỮ LIỆU MẪU (DML)
-- ==========================================================

INSERT INTO admin(username, password, fullname) 
VALUES ('Admin', '$2a$10$EsoqYldgsgbopnxoOvxf7ujIcrjbb.BX5v86K9JCzC6s4PUtfC3hm', N'Administrator');

INSERT INTO users VALUES
    (1, 'datpham', '123456', 'dat@gmail.com', 'Dat Pham',
     '/avatar/a.png', '2003-01-01', '0909000000',
     'Viet Nam', NOW(), NOW(), NOW(), 1);


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

TRUNCATE TABLE products;

TRUNCATE TABLE products;

INSERT INTO products (id, categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES
-- SONY (Brand 1)
(1, 1, 1, 'PlayStation 5 Slim', 'Phiên bản mỏng nhẹ hơn.', 'PS5 Slim mang đến công nghệ chơi game 4K đỉnh cao.', '1TB SSD, 4K-120Hz', 12490000, 13990000, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/a/tay-cam-choi-game-ps5-dualsense-1.png', NOW(), 350, 0, 3200, 1, 'ps5-slim', 1, 'PS5/PS4 Games', 'HDMI 2.1', 'Bảo hành 12 tháng'),
(2, 2, 1, 'PlayStation Portal Remote Player', 'Thiết bị chơi game từ xa.', 'Chơi các trò chơi PS5 thông qua mạng WiFi.', 'Màn hình 8 inch', 5500000, 5990000, 'https://theonionshop.com/cdn/shop/files/ps-portal-remoteplayer-hero-3.webp?v=1697515705&width=1445', NOW(), 4370, 5, 540, 1, 'ps-portal', 0, 'Kết nối PS5', 'WiFi', 'Bảo hành 12 tháng'),

-- XBOX (Brand 2)
(4, 1, 2, 'Xbox Series X', 'Cỗ máy mạnh mẽ nhất thế giới.', 'Sức mạnh đồ họa 12 Teraflops.', 'CPU Zen 2, 1TB SSD', 13500000, 14500000, 'https://nvs.tn-cdn.net/2021/01/Tay-cam-choi-game-Xbox-Series-X-Controller-den-1-1.jpg', NOW(), 315, 0, 4400, 1, 'xbox-series-x', 1, 'Xbox Games', 'HDMI 2.1', 'Bảo hành 12 tháng'),

-- NINTENDO (Brand 3)
(17, 2, 3, 'Nintendo Switch OLED Model', 'Màn hình OLED 7 inch rực rỡ.', 'Phiên bản nâng cấp màn hình OLED.', '64GB, OLED Screen', 7500000, 8500000, 'https://bizweb.dktcdn.net/100/476/122/products/vh-installer-1-1702023014809.png?v=1702023021590', NOW(), 4310, 9, 420, 1, 'switch-oled', 1, 'Switch Games', 'WiFi', 'Bảo hành 12 tháng'),
(18, 2, 3, 'Nintendo Switch 2', 'Thế hệ máy tiếp theo.', 'Màn hình LCD 7.9 inch 1080p.', 'Thế hệ tiếp theo', 12350000, 13290000, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/123669-nintendo-switch-2-hand-pulling-right-joy-con-off-1200x675', NOW(), 5220, 6, 534, 1, 'switch-2', 0, 'TV', 'WiFi 6', 'Bảo hành 12 tháng'),

-- PC HANDHELD (Brand 4, 5, 6, 7, 8)
(19, 2, 4, 'Steam Deck OLED 512GB', 'Màn hình OLED sống động.', 'Trải nghiệm thư viện game Steam khổng lồ.', '512GB NVMe SSD', 17990000, 20090000, 'https://product.hstatic.net/200000637319/product/78124_may_choi_game_cam_tay_steam_deck_oled_512gb_nvme_ssd_2_bbd3227eba0a48ac93876ba49f230da8_master.jpg', NOW(), 4000, 7, 640, 1, 'steam-deck', 0, 'SteamOS', 'WiFi 6E', 'Bảo hành 12 tháng'),
(20, 2, 5, 'Asus ROG Ally X', 'Quái vật Handheld PC.', 'AMD Ryzen Z2 Extreme, RAM 24GB.', '1TB SSD, 24GB RAM', 24900000, 25900000, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/r/o/rog-xbox-ally-x-2.jpg', NOW(), 3000, 7, 670, 1, 'rog-ally-x', 1, 'Windows 11', 'WiFi 6E', 'Bảo hành 24 tháng'),
(21, 2, 6, 'MSI Claw A1M', 'Handheld đầu tiên của MSI.', 'Chip Intel Core Ultra 7.', 'Intel Core Ultra 7', 13990000, 19990000, 'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-3.jpg', NOW(), 3000, 4, 675, 1, 'msi-claw', 0, 'Windows 11', 'WiFi 7', 'Bảo hành 12 tháng'),
(32, 2, 7, 'Lenovo Legion Go', 'Màn hình 8.8 inch 144Hz.', 'Màn hình lớn, tay cầm tháo rời.', '8.8 inch QHD+', 18500000, 19500000, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-2.jpg', NOW(), 4920, 5, 854, 1, 'legion-go', 1, 'Windows 11', 'WiFi 6E', 'Bảo hành 12 tháng'),
(22, 2, 8, 'AYANEO 3 32Gb - 1Tb', 'Thiết bị handheld mạnh nhất.', 'AMD AI370 và 32GB RAM.', 'AMD AI370, 32GB RAM', 32000000, 33090000, 'https://weirdstore.vn/wp-content/uploads/2025/08/ayaneo-pocket-ds-indiegogo-confirmation-kv-1067x800.jpg', NOW(), 13000, 6, 680, 1, 'ayaneo-3-ai370', 1, 'Windows 11', 'WiFi 7', 'Bảo hành 12 tháng'),

-- FLYDIGI (Brand 14)
(6, 3, 14, 'Flydigi Vader 4 Pro', 'Phiên bản cao cấp nhất.', 'Cảm biến Hall Effect, tùy chỉnh lực nhấn.', 'Hall Effect', 1550000, 1850000, 'https://shoptaycam.com/wp-content/uploads/2024/06/Flydigi-Vader-4-Pro-Wireless-Controller.jpg', NOW(), 1000, 20, 250, 1, 'vader-4-pro', 1, 'PC/Switch/Mobile', '2.4G/BT', 'Bảo hành 12 tháng'),
(7, 3, 14, 'Flydigi Nova 3', 'Thiết kế hiện đại.', 'Joystick độ nhạy cao.', 'Joystick High Precision', 890000, 1100000, 'https://shoptaycam.com/wp-content/uploads/2024/11/tay-c%E1%BA%A7m-flydigi-direwolf-3.jpg', NOW(), 800, 15, 240, 1, 'nova-3', 0, 'PC/Android', 'BT/USB', 'Bảo hành 6 tháng'),

-- ANBERNIC (Brand 10)
(24, 2, 10, 'Anbernic RG35XXSP', 'Thiết kế nắp gập huyền thoại.', 'Tái hiện GBA SP với màn hình IPS 3.5 inch.', 'IPS 3.5 inch', 1800000, 1990000, 'https://herogame.vn/upload/images/img_02_01_2025/may-retro-game-cam-tay-rg35xxsp-nap-gap-nho-gon-hon-10000-games-anbernic-4_801428_67761b70133425.88983002.jpg', NOW(), 3300, 6, 200, 1, 'anbernic-rg35xxsp', 0, 'Retro Systems', 'WiFi', 'Bảo hành 12 tháng'),
(25, 2, 10, 'Anbernic RG406V', 'Máy dọc chuyên game 3D cũ.', 'Sức mạnh vượt trội, màn hình 4 inch sắc nét.', '256GB Storage', 5000000, 6190000, 'https://haloshop.vn/wp-content/uploads/2025/03/anbernic_retro_game_handheld_rg406v_256gb_42-700x700-1.jpg', NOW(), 4500, 8, 260, 1, 'anbernic-rg406', 0, 'Retro systems', 'WiFi', 'Bảo hành 12 tháng'),
(26, 2, 10, 'Anbernic RG477V', 'Máy dọc mạnh nhất hiện nay.', 'Cân tốt PS2 và Wii U với thiết kế cổ điển.', 'Android 13, 8GB RAM', 6789000, 6987000, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-5-600x600.jpg', NOW(), 5500, 8, 334, 1, 'anbernic-rg477v', 1, 'Android', 'WiFi & BT', 'Bảo hành 12 tháng'),

-- MIYOO (Brand 12)
(28, 2, 12, 'Miyoo Mini Flip', 'Thiết kế gập cực gọn.', 'Bỏ túi dễ dàng, bảo vệ màn hình tối ưu.', 'Flip Design', 1490000, 1680000, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-3-600x600.jpg', NOW(), 2500, 5, 200, 1, 'miyoo-mini-flip', 0, 'Retro systems', 'WiFi', 'Bảo hành 12 tháng'),

-- RETROID (Brand 13)
(29, 2, 13, 'Retroid Pocket 5', 'Màn hình OLED 1080p.', 'Chip Snapdragon mạnh mẽ, thiết kế hiện đại.', 'Snapdragon, OLED', 6790000, 6980000, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-2-600x600.jpg', NOW(), 5000, 6, 280, 1, 'retroid-pocket-5', 0, 'Android', 'WiFi & BT', 'Bảo hành 12 tháng'),
(45, 2, 13, 'Retroid Pocket Flip 2', 'Thiết kế Clamshell OLED.', 'Viền siêu mỏng, tối ưu cho game Android.', 'OLED, Android', 4590000, 4890000, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-4-600x600.jpg', NOW(), 5000, 7, 300, 1, 'retroid-pocket-flip-2', 0, 'Android', 'WiFi & BT', 'Bảo hành 12 tháng'),

-- RETRO GIÁ RẺ (Brand 11)
(10, 2, 11, 'Q8 Retro Handheld ', '10.000 trò chơi retro.', 'Màn hình 3.0 inch, nhỏ gọn dễ mang theo.', '10.000+ Games', 550000, 750000, 'https://i.ebayimg.com/images/g/cYwAAOSw-EBmzXja/s-l1200.jpg', NOW(), 1500, 5, 150, 1, 'mini-q8', 0, 'Retro games', 'USB', 'Bảo hành 3 tháng'),
(11, 2, 11, 'GKD Pixel X2', 'Phong cách Pixel hoài cổ.', 'Tích hợp hơn 8.000 trò chơi cổ điển.', '8.000+ Games', 450000, 600000, 'https://i.ytimg.com/vi/X1OAPuLEnAU/maxresdefault.jpg', NOW(), 1200, 4, 130, 1, 'pixel-x2', 0, 'Retro games', 'USB', 'Bảo hành 3 tháng'),

-- PHIÊN BẢN ĐẶC BIỆT & NÂNG CẤP
(36, 2, 13, 'Retroid Pocket G2', 'Mẫu mới từ Retroid.', 'Thiết kế nhỏ gọn, hiệu năng ổn định chạy Android.', 'Handheld', 3500000, 3900000, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-6-600x600.jpg', NOW(), 4000, 6, 250, 1, 'retroid-g2', 0, 'Android', 'WiFi & BT', 'Bảo hành 12 tháng'),
(37, 2, 13, 'Retroid Pocket Mini V2', 'Phiên bản Mini nâng cấp.', 'Màn hình sắc nét, kích thước bỏ túi cực tiện lợi.', 'Mini Handheld', 4200000, 4500000, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-9-600x600.jpg', NOW(), 3500, 5, 180, 1, 'retroid-mini-v2', 0, 'Android', 'WiFi & BT', 'Bảo hành 12 tháng'),
(40, 2, 4, 'Steam Deck OLED White 1TB', 'Phiên bản giới hạn màu trắng.', 'Thiết kế sang trọng với ổ cứng 1TB SSD.', '1TB SSD, OLED', 18800000, 19000000, 'https://product.hstatic.net/200000637319/product/78124_may_choi_game_cam_tay_steam_deck_oled_512gb_nvme_ssd_1_6d8d98db95004879ae016a3dd4c6400e_master.jpg', NOW(), 4000, 7, 640, 1, 'steam-deck-white', 1, 'SteamOS', 'WiFi 6E', 'Bảo hành 12 tháng'),

-- HIỆU NĂNG CAO (GPD & MSI)
(41, 2, 6, 'MSI Claw A8 Z2 Extreme', 'Sức mạnh từ AMD Z2.', 'Màn hình 8 inch 120Hz, RAM 24GB.', 'Z2 Extreme, 24GB RAM', 24590000, 25990000, 'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-3.jpg', NOW(), 3000, 5, 765, 1, 'msi-claw-a8', 0, 'Windows 11', 'WiFi 7', 'Bảo hành 12 tháng'),
(43, 2, 9, 'GPD Win 4 8840U', 'Chip AMD Ryzen 7 8840U.', 'Form dáng nhỏ gọn với bàn phím trượt.', 'AMD 8840U', 20500000, 20900000, 'https://pcngon.vn/wp-content/uploads/2024/04/May-choi-game-cam-tay-GPD-WIN-4-2024-Ram-32GB-SSD-2TB-9.jpg', NOW(), 3000, 6, 598, 1, 'gpd-win-4-8840u', 0, 'Windows 11', 'WiFi & BT', 'Bảo hành 12 tháng'),

-- NHÓM TAY CẦM BỔ SUNG (Khớp Gallery Controller 3, 5, 8, 9, 13...)
(3, 3, 3, 'Nintendo Switch Pro Controller', 'Tay cầm không dây cao cấp.', 'Mang lại trải nghiệm chơi game chuyên nghiệp trên Switch.', 'HD Rumble, NFC Amiibo', 1550000, 1750000, 'https://www.droidshop.vn/wp-content/uploads/2023/04/Tay-cam-Nintendo-Switch-Pro-Controller.jpg', NOW(), 1300, 40, 246, 1, 'switch-pro-controller', 1, 'Switch/PC', 'Bluetooth', 'Bảo hành 12 tháng'),
(5, 3, 15, 'Razer Wolverine V2 Chroma', 'Tay cầm Gaming cơ học RGB.', 'Nút bấm Mecha-Tactile và hệ thống LED Chroma.', '6 Nút đa năng', 3600000, 3990000, 'https://bizweb.dktcdn.net/thumb/grande/100/329/122/products/tay-cam-choi-game-razer-wolverine-v2-chroma-6.jpg?v=1716652873040', NOW(), 0, 0, 270, 1, 'razer-wolverine-v2', 1, 'Xbox/PC', 'Có dây', 'Bảo hành 24 tháng'),
(8, 3, 14, 'Flydigi Apex 4 Elite', 'Tay cầm màn hình LED.', 'Cò nhấn phản hồi lực (Adaptive Trigger) cực đỉnh.', 'Force Feedback', 2550000, 2850000, 'https://shoptaycam.com/wp-content/uploads/2024/07/bandicam-2025-06-21-17-32-42-547.jpg', NOW(), 1500, 30, 300, 1, 'flydigi-apex-4', 1, 'PC/Switch/Android', '2.4G/BT', 'Bảo hành 12 tháng'),
(13, 3, 16, 'Acer Nitro NGR300', 'Tay cầm Nitro chuyên game.', 'Thiết kế bền bỉ, độ trễ cực thấp cho game thủ.', 'Dual Vibration', 750000, 950000, 'https://cohotech.vn/wp-content/uploads/2025/04/Acer-Nitro-NGR300-1.jpg', NOW(), 600, 10, 230, 1, 'acer-nitro-ngr300', 0, 'PC/Android', 'USB/BT', 'Bảo hành 6 tháng'),

-- NHÓM NINTENDO PHIÊN BẢN KHÁC (Khớp Gallery Handheld 7, 8, 9)
(14, 2, 3, 'Nintendo Switch Lite Coral', 'Máy cầm tay thuần túy màu San Hô.', 'Nhẹ nhàng, thời trang, chuyên dụng cho di động.', '32GB Storage', 3900000, 4500000, 'https://shoptrongnghia.com/wp-content/uploads/2020/08/switchhong.jpg', NOW(), 3570, 7, 275, 1, 'switch-lite-coral', 0, 'Switch Games', 'WiFi', 'Bảo hành 12 tháng'),
(15, 2, 3, 'Nintendo Switch V2 Neon Blue/Red', 'Phiên bản pin cải tiến.', 'Chế độ chơi linh hoạt: TV, Tabletop, Handheld.', 'Cải thiện pin', 5600000, 6500000, 'https://www.droidshop.vn/wp-content/uploads/2023/12/May-choi-game-Nintendo-Switch-V2-Mario-Kart-8-Deluxe-Bundle-Nintendo-Switch-Online-Membership-247x300.jpg', NOW(), 4310, 9, 398, 1, 'switch-v2-neon', 0, 'Switch Games', 'WiFi', 'Bảo hành 12 tháng'),

-- NHÓM RETRO & HANDHELD KHÁC (Khớp Gallery Handheld 12, 13, 14, 23, 30...)
(12, 2, 12, 'Miyoo Mini Plus White', 'Máy game Retro màn hình IPS.', 'Hỗ trợ hàng nghìn game cổ điển với cộng đồng cực lớn.', 'Màn hình 3.5 inch', 1350000, 1550000, 'https://izzygame.com/wp-content/uploads/2023/04/photo_2023-04-29_21-30-46-600x600.jpg', NOW(), 3000, 6, 165, 1, 'miyoo-mini-plus', 0, 'Retro Systems', 'WiFi', 'Bảo hành 12 tháng'),
(23, 2, 8, 'Ayaneo Pocket Micro', 'Thân máy siêu nhỏ.', 'Vỏ kim loại sang trọng, màn hình sắc nét.', 'Micro Handheld', 12500000, 13500000, 'https://weirdstore.vn/wp-content/uploads/2024/09/AYANEO-POCKET-MICRO-SOUL-RED-DONE-01.png', NOW(), 2600, 4, 220, 1, 'ayaneo-pocket-micro', 0, 'Android', 'WiFi', 'Bảo hành 12 tháng'),
(30, 2, 10, 'Anbernic RG35XX H', 'Thiết kế ngang hiện đại.', 'Cấu hình mạnh mẽ trong thân hình nhỏ gọn.', 'H-Series Design', 1450000, 1650000, 'https://images-na.ssl-images-amazon.com/images/I/71VoTjyKBUL.jpg', NOW(), 3300, 6, 180, 1, 'anbernic-rg35xxh', 0, 'Retro Systems', 'WiFi/BT', 'Bảo hành 12 tháng'),
(33, 2, 10, 'Anbernic RG353PS', 'Thiết kế lấy cảm hứng SNES.', 'Vỏ trong suốt, phím bấm êm ái, chạy Linux.', 'SNES Retro Style', 2200000, 2450000, 'https://haloshop.vn/wp-content/uploads/2025/02/anbernic-retro-game-rg353p-64gb-sd-card-46.jpg', NOW(), 3500, 6, 210, 1, 'anbernic-rg353ps', 0, 'Linux Retro', 'WiFi', 'Bảo hành 12 tháng'),
(34, 2, 12, 'Miyoo A30', 'Máy game nhỏ nhất dòng Miyoo.', 'Thiết kế ngang, màn hình sắc nét, bỏ vừa túi áo.', 'Siêu nhỏ gọn', 990000, 1200000, 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-2-600x600.jpg', NOW(), 2000, 4, 110, 1, 'miyoo-a30', 0, 'Retro Systems', 'Không WiFi', 'Bảo hành 6 tháng'),

(44, 2, 9, 'GPD Win Mini 2025', 'Handheld PC siêu nhỏ gọn.', 'Thiết kế nắp gập bỏ túi, sức mạnh Ryzen 8000.', 'Ryzen 7 8840U', 18500000, 19900000, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-1.jpg', NOW(), 4500, 5, 520, 1, 'gpd-win-mini', 1, 'Windows 11', 'WiFi 6E', 'Bảo hành 12 tháng');







INSERT INTO gallary (product_id, img) VALUES
-- 1. PlayStation 5 Slim
(1, 'https://www.droidshop.vn/wp-content/uploads/2023/11/May-ps5-slim-standard.jpg'),
(1, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/a/tay-cam-choi-game-ps5-dualsense-1.png'),

-- 2. PlayStation Portal
(2, 'https://theonionshop.com/cdn/shop/files/ps-portal-remoteplayer-hero-3.webp?v=1697515705&width=1445'),
(2, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/m/a/may-choi-game-sony-playstation-portal-1.png'),

-- 3. Nintendo Switch Pro Controller
(3, 'https://www.droidshop.vn/wp-content/uploads/2023/04/Tay-cam-Nintendo-Switch-Pro-Controller.jpg'),
(3, 'https://www.droidshop.vn/wp-content/uploads/2023/04/Tay-cam-Nintendo-Switch-Pro-Controller-1.jpg'),

-- 4. Xbox Series X
(4, 'https://nvs.tn-cdn.net/2021/01/Tay-cam-choi-game-Xbox-Series-X-Controller-den-1-1.jpg'),
(4, 'https://nvs.tn-cdn.net/2021/01/Tay-cam-choi-game-Xbox-Series-X-Controller-den-1-2.jpg'),

-- 5. Razer Wolverine V2
(5, 'https://bizweb.dktcdn.net/thumb/grande/100/329/122/products/tay-cam-choi-game-razer-wolverine-v2-chroma-6.jpg?v=1716652873040'),
(5, 'https://bizweb.dktcdn.net/thumb/medium/100/329/122/products/tay-cam-choi-game-razer-wolverine-v2-chroma-5.jpg?v=1716652873330'),
(5, 'https://bizweb.dktcdn.net/thumb/medium/100/329/122/products/tay-cam-choi-game-razer-wolverine-v2-chroma-1.jpg?v=1716652873330'),

-- 6. Flydigi Vader 4 Pro
(6, 'https://shoptaycam.com/wp-content/uploads/2024/06/Flydigi-Vader-4-Pro-Wireless-Controller.jpg'),
(6, 'https://shoptaycam.com/wp-content/uploads/2024/06/Flydigi-Vader-4-Pro-3.jpg'),

-- 7. Flydigi Nova 3
(7, 'https://shoptaycam.com/wp-content/uploads/2024/11/tay-c%E1%BA%A7m-flydigi-direwolf-3.jpg'),
(7, 'https://shoptaycam.com/wp-content/uploads/2024/11/z6033108912562_90b42ee971285bca9c311879de636d13-1024x768.jpg'),
(7, 'https://shoptaycam.com/wp-content/uploads/2024/11/tay-c%E1%BA%A7m-flydigi-direwolf-3-5.jpg'),

-- 10. Retro Q8
(10, 'https://i.ebayimg.com/images/g/cYwAAOSw-EBmzXja/s-l1200.jpg'),
(10, 'https://i.ebayimg.com/images/g/QVAAAOSwSz1mzXjo/s-l1600.webp'),

-- 11. Pixel X2
(11, 'https://i.ytimg.com/vi/X1OAPuLEnAU/maxresdefault.jpg'),
(11, 'https://gkdpixel.com/wp-content/uploads/2025/04/green.png'),

-- 14. Nintendo Switch Lite Coral
(14, 'https://shoptrongnghia.com/wp-content/uploads/2020/08/switchhong.jpg'),
(14, 'https://shoptrongnghia.com/wp-content/uploads/2020/08/sw.jpg'),
(14, 'https://shoptrongnghia.com/wp-content/uploads/2020/08/switchhong2.jpg'),
(14, 'https://shoptrongnghia.com/wp-content/uploads/2020/08/switchhong3.jpg'),

-- 15. Nintendo Switch V2
(15, 'https://www.droidshop.vn/wp-content/uploads/2023/12/May-choi-game-Nintendo-Switch-V2-Mario-Kart-8-Deluxe-Bundle-Nintendo-Switch-Online-Membership-247x300.jpg'),
(15, 'https://www.droidshop.vn/wp-content/uploads/2023/01/May-choi-game-Nintendo-Switch-Neon-2.jpg'),
(15, 'https://www.droidshop.vn/wp-content/uploads/2023/01/May-choi-game-Nintendo-Switch-Neon-1-247x300.jpg'),

-- 17. Nintendo Switch OLED
(17, 'https://bizweb.dktcdn.net/100/476/122/products/vh-installer-1-1702023014809.png?v=1702023021590'),
(17, 'https://bizweb.dktcdn.net/100/476/122/products/vh-installer-1702023014820.png?v=1702023022600'),

-- 18. Nintendo Switch 2
(18, 'https://assets.nintendo.com/image/upload/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/123669-nintendo-switch-2-hand-pulling-right-joy-con-off-1200x675'),
(18, 'https://cdn.tgdd.vn/News/0/QjyRxUoKLzksmSNjoyGQHL-1200-80-1200x675.jpg'),
(18, 'https://assets.nintendo.com/image/upload/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/123669-nintendo-switch-2-hand-pulling-right-joy-con-off-1200x675'),

-- 19. Steam Deck OLED
(19, 'https://product.hstatic.net/200000637319/product/78124_may_choi_game_cam_tay_steam_deck_oled_512gb_nvme_ssd_2_bbd3227eba0a48ac93876ba49f230da8_master.jpg'),
(19, 'https://product.hstatic.net/200000637319/product/78124_may_choi_game_cam_tay_steam_deck_oled_512gb_nvme_ssd_1_6d8d98db95004879ae016a3dd4c6400e_master.jpg'),

-- 20. Asus ROG Ally X
(20, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/r/o/rog-xbox-ally-x-2.jpg'),
(20, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/r/o/rog-xbox-ally-x-1.jpg'),

-- 21. MSI Claw A1M
(21, 'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-3.jpg'),
(21, 'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-2.jpg'),

-- 22. AYANEO 3
(22, 'https://weirdstore.vn/wp-content/uploads/2025/08/ayaneo-pocket-ds-indiegogo-confirmation-kv-1067x800.jpg'),
(22, 'https://s.yimg.com/ny/api/res/1.2/Bk1uEmle.lTNddhl1yFvcg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD02OTQ-/https://s.yimg.com/os/creatr-uploaded-images/2024-11/6a28f640-9e01-11ef-b6f7-10617312a1aa'),
(22, 'https://pcngon.vn/wp-content/uploads/2025/10/May-tinh-cam-tay-AYANEO-3-R7-8840U-AI-9-HX370-16.png'),
(22, 'https://pcngon.vn/wp-content/uploads/2025/10/May-tinh-cam-tay-AYANEO-3-R7-8840U-AI-9-HX370-15.png'),

-- 23. Ayaneo Pocket Micro
(23, 'https://weirdstore.vn/wp-content/uploads/2024/09/AYANEO-POCKET-MICRO-SOUL-RED-DONE-01.png'),

-- 24. Anbernic RG35XXSP
(24, 'https://herogame.vn/upload/images/img_02_01_2025/may-retro-game-cam-tay-rg35xxsp-nap-gap-nho-gon-hon-10000-games-anbernic-4_801428_67761b70133425.88983002.jpg'),
(24, 'https://herogame.vn/upload/images/img_02_01_2025/may-retro-game-cam-tay-rg35xxsp-nap-gap-nho-gon-hon-10000-games-anbernic-6_373158_67761b70135fb1.86248728.jpg'),

-- 25. Anbernic RG406V
(25, 'https://haloshop.vn/wp-content/uploads/2025/03/anbernic_retro_game_handheld_rg406v_256gb_42-700x700-1.jpg'),
(25, 'https://haloshop.vn/wp-content/uploads/2025/03/anbernic_retro_game_handheld_rg406v_256gb_47-700x700-1.jpg'),

-- 26. Anbernic RG477V
(26, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-5-600x600.jpg'),
(26, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-4-600x600.jpg'),

-- 28. Miyoo Mini Flip
(28, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-3-600x600.jpg'),
(28, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-4-600x600.jpg'),

-- 29. Retroid Pocket 5
(29, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-2-600x600.jpg'),
(29, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-7-600x600.jpg'),

-- 30. Anbernic RG35XX H
(30, 'https://images-na.ssl-images-amazon.com/images/I/71VoTjyKBUL.jpg'),
(30, 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lvo24tuhbnbuef'),
(30, 'https://images-na.ssl-images-amazon.com/images/I/716sKBz0uBL.jpg'),
(30, 'http://images-na.ssl-images-amazon.com/images/I/71WQe1WL7qL.jpg'),
(30, 'https://images-na.ssl-images-amazon.com/images/I/714FdrYh+oL.jpg'),

-- 32. Lenovo Legion Go
(32, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-2.jpg'),
(32, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-1.jpg'),

-- 33. Anbernic RG353PS
(33, 'https://haloshop.vn/wp-content/uploads/2025/02/anbernic-retro-game-rg353p-64gb-sd-card-46.jpg'),
(33, 'https://product.hstatic.net/200000272737/product/rg353ps-chinh-hang_ad13dc39bbe1444a90674da2d400d575_master.jpg'),
(33, 'https://image.made-in-china.com/155f0j00NMnblqRLnfor/Anbernic-Rg353PS-64-Bit-Handheld-Game-Console-Linux-System-3-5-Inch-IPS-Screen-Retro-Game-Player-HD-Compatible-2-4G-5g-WiFi.webp'),

-- 34. Miyoo A30
(34, 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-2-600x600.jpg'),

-- 36. Retroid Pocket G2
(36, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-6-600x600.jpg'),
(36, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-4-600x600.jpg'),

-- 37. Retroid Pocket Mini V2
(37, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-9-600x600.jpg'),
(37, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-2-600x600.jpg'),

-- 40. Retroid Pocket 2S
(40, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-9-600x600.jpg'),
(40, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-5-600x600.jpg'),

-- 41. MSI Claw A8 Z2
(41, 'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-3.jpg'),
(41, 'https://laptopworld.vn/media/product/22995_product_17501423256641567b47c67a56dce17d0121439176.jpg'),
(41, 'https://laptopworld.vn/media/product/22995_product_1750142323763e761a0cb5ba887363d398ba8e5775.jpg'),

-- 43. GPD Win 4
(43, 'https://pcngon.vn/wp-content/uploads/2024/04/May-choi-game-cam-tay-GPD-WIN-4-2024-Ram-32GB-SSD-2TB-9.jpg'),
(43, 'https://pcngon.vn/wp-content/uploads/2024/04/May-choi-game-cam-tay-GPD-WIN-4-2024-Ram-32GB-SSD-2TB-5.jpg'),
(43, 'https://pcngon.vn/wp-content/uploads/2024/04/May-choi-game-cam-tay-GPD-WIN-4-2024-Ram-32GB-SSD-2TB-3.jpg'),

-- 44. GPD Win Mini 2025
(44, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-1.jpg'),
(44, 'https://droix.co.uk/wp-content/uploads/2024/12/GPD-WIN-4-2025-LISTING-32-1-8840U-01.png'),
(44, 'https://nghenhinvietnam.vn/uploads/global/tunglampv/2025/t01/14/gdp/gpd_win_mini_2025_004.jpg'),
(44, 'https://droix.co.uk/wp-content/uploads/2024/12/GPD-WIN-4-2025-LISTING-06-2048x2048.jpg.webp'),
(44, 'https://droix.co.uk/wp-content/uploads/2024/12/GPD-WIN-4-2025-LISTING-08.jpg'),

-- 45. Retroid Pocket Flip 2
(45, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-4-600x600.jpg'),
(45, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-10-600x600.jpg');


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
INSERT INTO about (section, title, description, image, icon, sort_order) VALUES
('INFO_IMAGE', NULL, NULL, 'Assets/image/aboutUs_info.png', NULL, 1),
('INFO','50+ CỬA HÀNG','Hệ thống cửa hàng phân bố khắp cả nước...', NULL, NULL, 1),
('INFO','200+ THƯƠNG HIỆU','Sản phẩm từ nhiều thương hiệu nổi tiếng...', NULL, NULL, 2),
('SERVICE', NULL, 'Cửa hàng luôn sẵn sàng tư vấn và hỗ trợ.', NULL, 'fa-headset', 1),
('SERVICE', NULL, 'Dịch vụ giao hàng tận nơi.', NULL, 'fa-truck-fast', 2),
('WHAT_WE_DO','Sản phẩm của chúng tôi','Đa dạng các loại máy chơi game.','Assets/image/aboutUs_product.png', NULL, 1),
('FINAL','Nhóm 17','Cửa hàng có nhiều loại máy chơi game để lựa chọn.', NULL, NULL, 1);

-- BLOG (ID tự tăng, img, title, metatitle, description, active, playorder)
INSERT INTO blog (img, title, metatitle, description, active, playorder) VALUES
('https://i.ytimg.com/vi/CXMRMA9Hh-o/hq720.jpg', 'Review tay cầm PS5 DualSense', 'review-tay-cam', 'Cảm giác rung thông minh, adaptive trigger...', 1, 1),
('https://file.hstatic.net/1000231532/file/danh_sach_game_hay_nhat_ps5_fe3378786833475cbee83f5c924c59c6.jpg', 'Top game hay nhất 2024 trên PS5', 'top-game-hay', 'Tổng hợp những tựa game đáng chơi nhất...', 1, 2),
('https://bizweb.dktcdn.net/100/503/563/files/24.jpg', 'Hướng dẫn bảo quản tay cầm', 'baoquantaycam', 'Cách vệ sinh joystick, chống drift...', 1, 3);

