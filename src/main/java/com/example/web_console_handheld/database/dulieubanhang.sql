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

INSERT INTO products (categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES

-- SONY (Brand 1)
-- 1. Bản PS5 Slim Standard (Có ổ đĩa)
(1, 1, 'PlayStation 5 Slim Standard Edition', 
 'Máy chơi game thế hệ mới có ổ đĩa Blu-ray 4K.', 
 'Thiết kế mới mỏng hơn 30%, ổ cứng 1TB và tích hợp ổ đĩa để chơi game vật lý.', 
 'CPU: AMD Zen 2 8-core, GPU: 10.3 TFLOPS, RAM: 16GB GDDR6, SSD: 1TB Custom.', 
 13500000, 14990000, 
 'link_anh_ps5_standard.jpg', 
 NOW(), '340W', 'N/A', '3.2kg', 1, 'ps5-slim-standard', 1, '4K 120Hz, Ray Tracing', 'HDMI 2.1, WiFi 6', 'Tặng 1 tay cầm DualSense'),
==========================================================

-- 2. Bản PS5 Slim Digital (Không ổ đĩa)
(1, 1, 'PlayStation 5 Slim Digital Edition', 
 'Phiên bản kỹ thuật số mỏng nhẹ, không ổ đĩa.', 
 'Trải nghiệm sức mạnh tương đương bản Standard trong một thiết kế đối xứng và gọn gàng hơn.', 
 'CPU: AMD Zen 2 8-core, GPU: 10.3 TFLOPS, RAM: 16GB GDDR6, SSD: 1TB Custom.', 
 11500000, 12990000, 
 'link_anh_ps5_digital.jpg', 
 NOW(), '340W', 'N/A', '2.6kg', 1, 'ps5-slim-digital', 1, '4K 120Hz, Ray Tracing', 'HDMI 2.1, WiFi 6', 'Voucher giảm giá game Digital');(2, 2, 1, 'PlayStation Portal Remote Player', 'Thiết bị chơi game từ xa.', 'Chơi các trò chơi PS5 thông qua mạng WiFi.', 'Màn hình 8 inch', 5500000, 5990000, 'https://theonionshop.com/cdn/shop/files/ps-portal-remoteplayer-hero-3.webp?v=1697515705&width=1445', NOW(), 4370, 5, 540, 1, 'ps-portal', 0, 'Kết nối PS5', 'WiFi', 'Bảo hành 12 tháng'),
==========================================================
-- PlayStation Portal Remote Player
(2, 1, 'PlayStation Portal Remote Player', 'Thiết bị chơi game từ xa.', 'Chơi các trò chơi PS5 thông qua mạng WiFi.', 'Màn hình 8 inch', 5500000, 5990000, 'https://theonionshop.com/cdn/shop/files/ps-portal-remoteplayer-hero-3.webp?v=1697515705&width=1445', NOW(), 4370, 5, 540, 1, 'ps-portal', 0, 'Kết nối PS5', 'WiFi', 'Bảo hành 12 tháng'),


-- 29. PlayStation Portable PSP 3000
(
    2, -- categories_id: Handheld Gaming
    11, -- brand_id: Sony Handheld
    'PlayStation Portable PSP 3000', 
    'Máy chơi game cầm tay huyền thoại của Sony với màn hình chống chói sắc nét.', 
    'PSP 3000 là phiên bản hoàn thiện nhất của dòng PSP với màn hình LCD cải tiến, dải màu rộng và tích hợp microphone. Máy sở hữu kho game đồ sộ với các siêu phẩm như God of War, Tekken và Naruto. Thiết kế mỏng nhẹ, hỗ trợ đa phương tiện từ nghe nhạc đến xem phim, là biểu tượng không thể thay thế của giới game thủ.', 
    'CPU: MIPS R4000 (333 MHz), RAM: 64MB, Màn hình: 4.3 inch LCD (16:9), Hỗ trợ thẻ nhớ Memory Stick Pro Duo.', 
    2490000, 
    2990000, 
    'https://product.hstatic.net/1000289578/product/may_psp_3000_mau_den-xgame_9481630d7ae44ec7aaf9437fe4556caf.jpg', 
    NOW(), 
    '1200 mAh', -- energy: Dung lượng pin tiêu chuẩn
    '4 - 6 Hours', -- useTime: Thời lượng chơi game thực tế
    '189g', -- weight
    1, 
    'psp-3000-legend', 
    0, 
    'PSP Games, PS1 Classics, Movie/Music Player', 
    'Wi-Fi, Mini USB, 3.5mm Jack', 
    'Bảo hành 6 tháng, Tặng kèm thẻ nhớ hack full game và bao chống sốc'
),

-- 30. PlayStation Vita Slim (PCH-2000) 
(
    2, -- categories_id: Handheld Gaming
    11, -- brand_id: Sony Handheld
    'PlayStation Vita Slim (PCH-2000)', 
    'Thế hệ kế thừa hoàn hảo với thiết kế mỏng nhẹ, pin bền và màn hình cảm ứng đa điểm.', 
    'PS Vita Slim mang đến trải nghiệm chơi game hiện đại với 2 cần Analog thật thụ, mặt lưng cảm ứng và màn hình LCD tối ưu thời lượng pin. Máy hỗ trợ Remote Play với PS4 và sở hữu những tựa game đỉnh cao như Persona 4 Golden, Uncharted. Đây là thiết bị giải trí cầm tay mạnh mẽ nhất mà Sony từng sản xuất.', 
    'CPU: 4-core ARM Cortex-A9, GPU: SGX543MP4+, RAM: 512MB, Màn hình: 5 inch LCD Touch, Bộ nhớ trong 1GB.', 
    3590000, 
    4090000, 
    'https://i5.walmartimages.com/seo/Authentic-PlayStation-Ps-Vita-2000-Slim-Console-WiFi-Silver_d54a0ca5-138a-49ae-a5e0-19a04075f897.d5ff0e15b41d4231ac99debca7e622ab.jpeg', 
    NOW(), 
    '2210 mAh', -- energy: Pin của dòng Slim
    '5 - 7 Hours', -- useTime: Cải thiện rõ rệt so với đời OLED (1000)
    '219g', -- weight
    1, 
    'ps-vita-slim-2000', 
    1, -- Để là 1 vì giá trị sưu tầm rất cao hiện nay
    'PS Vita Games, PSP/PS1 Support, Remote Play PS4', 
    'Micro USB, Wi-Fi, Bluetooth 2.1', 
    'Bảo hành 6 tháng, Tặng kèm áo thẻ SD2Vita và thẻ nhớ 64GB full game'
),

-- 32. PlayStation Classic Mini
(
    1, -- categories_id: Home Console
    1, -- brand_id: Sony (PlayStation)
    'PlayStation Classic Mini', 
    'Phiên bản mini của máy PS1 huyền thoại, cài sẵn 20 tựa game kinh điển.', 
    'Sống lại những ký ức tuổi thơ với PlayStation Classic. Thiết kế mô phỏng chính xác chiếc máy PS1 nguyên bản nhưng với kích thước nhỏ hơn 45%. Máy đi kèm 2 tay cầm điều khiển cổ điển và cổng HDMI để kết nối dễ dàng với TV hiện đại.', 
    'CPU: MediaTek MT8167A, RAM: 1GB, Flash: 16GB, Output: 720p/480p.', 
    1990000, 
    2490000, 
    'https://m.media-amazon.com/images/I/61bvBCSda0L._SL400_.jpg', 
    NOW(), 
    'USB Powered', -- energy
    'Instant Play', -- useTime
    '170g', -- weight: Siêu nhẹ
    1, 
    'playstation-classic-mini', 
    0, 
    '20 Pre-loaded Games (Final Fantasy VII, Tekken 3...)', 
    'HDMI, Micro USB (Power)', 
    'Bảo hành 6 tháng, Tặng kèm bộ nguồn 5V và cáp HDMI'
);

-- XBOX (Brand 2)
-- 3. Xbox Series X Carbon Black (Phiên bản đặc biệt màu đen Carbon)
(1, 2, 'Xbox Series X Carbon Black', 
 'Cỗ máy chơi game mạnh mẽ nhất của Microsoft với màu đen Carbon sang trọng.', 
 'Xbox Series X sở hữu sức mạnh xử lý đồ họa cực khủng, hỗ trợ độ phân giải 4K tại 120FPS. Công nghệ Velocity Architecture giúp loại bỏ thời gian chờ tải game, mang lại trải nghiệm mượt mà tuyệt đối.', 
 'CPU: 8-core AMD Zen 2, GPU: 12 TFLOPS RDNA 2, RAM: 16GB GDDR6, SSD: 1TB NVMe.', 
 13500000, 14500000, 
 'https://nvs.tn-cdn.net/2021/01/Tay-cam-choi-game-Xbox-Series-X-Controller-den-1-1.jpg', 
 NOW(), '315W', 'N/A', '4400g', 1, 'xbox-series-x-carbon', 1, 'Xbox Games, Xbox Game Pass', 'HDMI 2.1, Wi-Fi 5, Ethernet', 'Bảo hành 12 tháng, Tặng kèm tay cầm Wireless Controller'),

-- 4. Xbox Series S 1TB Black (Phiên bản nhỏ gọn với dung lượng lưu trữ gấp đôi, màu đen sang trọng)
(
    1,
    2,
    'Xbox Series S 1TB Black', 
    'Phiên bản nhỏ gọn với dung lượng lưu trữ gấp đôi, màu đen sang trọng.', 
    'Xbox Series S bản 1TB mang đến không gian lưu trữ rộng lớn cho các tựa game Next-gen. Thiết kế không ổ đĩa cực kỳ nhỏ gọn, hỗ trợ tốc độ khung hình lên đến 120FPS và tính năng Quick Resume giúp chuyển đổi game tức thì.', 
    'CPU: 8-Core AMD Zen 2, GPU: 4 TFLOPS RDNA 2, RAM: 10GB GDDR6, SSD: 1TB NVMe.', 
    8990000, 
    9990000, 
    'https://product.hstatic.net/1000154920/product/xbox_one_series_s_1tb_box_bf42677b4ed84b35a4b0865486da6287_master.png', 
    NOW(), 
    '165W', -- energy: Công suất tiêu thụ trung bình của Series S
    'N/A', -- useTime: Cắm điện trực tiếp
    '1950g', -- weight: Trọng lượng máy (xấp xỉ 1.93kg)
    1, 
    'xbox-series-s-1tb-black', 
    0, 
    'Xbox Games, Xbox Game Pass, Quick Resume', 
    'HDMI 2.1, Wi-Fi 5, USB-A, LAN', 
    'Bảo hành 12 tháng, Tặng kèm tay cầm Wireless Controller'
),
========================================================

-- 31. Xbox One S All-Digital Edition
(
    1, -- categories_id: Home Console
    2, -- brand_id: Microsoft (Xbox)
    'Xbox One S All-Digital Edition', 
    'Phiên bản loại bỏ ổ đĩa vật lý, tối ưu cho thư viện game kỹ thuật số và Xbox Game Pass.', 
    'Xbox One S All-Digital mang đến trải nghiệm chơi game 4K streaming và lưu trữ đám mây tiện lợi. Với thiết kế trắng thanh lịch và nhỏ gọn, máy là lựa chọn hoàn hảo cho những game thủ yêu thích sự tối giản, không cần sử dụng đĩa vật lý mà vẫn tận hưởng được kho game khổng lồ.', 
    'CPU: 1.75GHz 8-core AMD, GPU: 1.23 TFLOPS, RAM: 8GB DDR3, HDD: 1TB.', 
    5490000, 
    6490000, 
    'https://m.media-amazon.com/images/I/813lBsn0qkL._AC_UF894,1000_QL80_.jpg', 
    NOW(), 
    'Internal PSU', -- energy
    'Continuous Power', -- useTime
    '2900g', -- weight
    1, 
    'xbox-one-s-digital', 
    0, 
    'Xbox Game Pass, 4K Ultra HD Video Streaming, HDR10', 
    'HDMI 2.0, USB 3.0, Wi-Fi, Ethernet', 
    'Bảo hành 6 tháng, Tặng kèm mã code 3 tháng Xbox Game Pass Ultimate'
);

-- NINTENDO (Brand 3)
-- 5. Nintendo Switch OLED Model 
(2, 3, 'Nintendo Switch OLED Model', 'Màn hình OLED 7 inch rực rỡ.', 'Phiên bản nâng cấp màn hình OLED.', '64GB, OLED Screen', 7500000, 8500000, 'https://bizweb.dktcdn.net/100/476/122/products/vh-installer-1-1702023014809.png?v=1702023021590', NOW(), 4310, 9, 420, 1, 'switch-oled', 1, 'Switch Games', 'WiFi', 'Bảo hành 12 tháng'),

-- 6. Nintendo Switch 2 
(2, 3, 'Nintendo Switch 2', 'Thế hệ máy tiếp theo.', 'Màn hình LCD 7.9 inch 1080p.', 'Thế hệ tiếp theo', 12350000, 13290000, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/123669-nintendo-switch-2-hand-pulling-right-joy-con-off-1200x675', NOW(), 5220, 6, 534, 1, 'switch-2', 0, 'TV', 'WiFi 6', 'Bảo hành 12 tháng'),

-- 7. Nintendo Switch V2 Neon Blue & Red
(
    2,
    3, 
    'Nintendo Switch V2 Neon Blue & Red', 
    'Phiên bản nâng cấp thời lượng pin, chơi game linh hoạt mọi lúc mọi nơi.', 
    'Nintendo Switch V2 mang đến sự linh hoạt tuyệt vời khi có thể vừa chơi trên TV, vừa có thể cầm tay mang đi. Phiên bản này sử dụng chip mới tiết kiệm điện năng hơn, giúp kéo dài thời gian trải nghiệm các tựa game đình đám của Nintendo.', 
    'Màn hình: 6.2 inch LCD, Chip: NVIDIA Tegra X1 Mariko, Bộ nhớ: 32GB (Hỗ trợ thẻ nhớ tối đa 2TB).', 
    6890000, 
    7890000, 
    'https://www.droidshop.vn/wp-content/uploads/2023/01/May-choi-game-Nintendo-Switch-Neon.jpg', 
    NOW(), 
    '4310 mAh', -- energy: Dung lượng pin của máy
    '4.5 - 9 Hours', -- useTime: Thời gian sử dụng thực tế
    '420g', -- weight: Trọng lượng khi lắp đủ 2 Joy-Con
    1, 
    'nintendo-switch-v2-neon', 
    0, 
    'Nintendo Switch Online, Motion Control, Amiibo', 
    'USB-C, HDMI 2.0 (Dock), WiFi, Bluetooth 4.1', 
    'Bảo hành 12 tháng, Tặng cường lực và túi chống sốc'
),
==================================================

-- 8. Nintendo Switch Animal Crossing: New Horizons Edition
(
    2, 
    3, 
    'Nintendo Switch Animal Crossing: New Horizons Edition', 
    'Phiên bản giới hạn với thiết kế màu sắc Pastel độc đáo lấy cảm hứng từ tựa game Animal Crossing.', 
    'Một trong những phiên bản đẹp nhất của dòng Switch với mặt lưng in họa tiết chìm, cặp Joy-Con màu xanh và lục nhạt cùng Dock sạc màu trắng in hình các nhân vật Nook Inc. Đây là món đồ không thể thiếu cho các tín đồ sưu tầm.', 
    'Màn hình: 6.2 inch LCD, Bộ nhớ: 32GB, Pin: 4310 mAh (Bản nâng cấp V2).', 
    7590000, 
    8590000, 
    'https://bizweb.dktcdn.net/100/088/342/products/3a4ccf1ab2321de3d47ad8e1fe1921ad.jpg?v=1584256452237', 
    NOW(), 
    '4310 mAh', -- energy
    '4.5 - 9 Hours', -- useTime
    '420g', -- weight
    1, 
    'nintendo-switch-animal-crossing', 
    1, -- Để là 1 vì đây là bản giới hạn (Premium/Special)
    'Nintendo Switch Online, Motion Control, Amiibo', 
    'USB-C, HDMI 2.0 (Dock), WiFi, Bluetooth 4.1', 
    'Bảo hành 12 tháng, Tặng kèm dán cường lực và thẻ giảm giá mua game'
), 
=========================================================

-- 33. Nintendo NES Classic Edition
(
    1, -- categories_id: Home Console
    3, -- brand_id: Nintendo
    'Nintendo NES Classic Edition', 
    'Cỗ máy 8-bit huyền thoại trở lại dưới dạng mini với 30 trò chơi cài sẵn.', 
    'Nintendo Entertainment System (NES) Classic Edition mang phong cách hoài cổ đặc trưng của những năm 80. Chỉ cần cắm và chạy để thưởng thức các siêu phẩm như Super Mario Bros, The Legend of Zelda và Donkey Kong trên màn hình HD sắc nét.', 
    'CPU: Allwinner R16, RAM: 256MB, Màn hình hỗ trợ: 720p qua HDMI.', 
    1790000, 
    2190000, 
    'https://m.media-amazon.com/images/I/61zSsTAtFfL._SL1000_.jpg', 
    NOW(), 
    'USB Powered', -- energy
    'Instant Play', -- useTime
    '160g', -- weight
    1, 
    'nes-classic-mini', 
    0, 
    '30 Pre-loaded Games, Save States support', 
    'HDMI, Wii Controller Port', 
    'Bảo hành 6 tháng, Tặng kèm tay cầm NES thứ hai cho chơi đối kháng'
);

(2, 3, 'Nintendo Switch Lite Coral', 'Máy cầm tay thuần túy màu San Hô.', 'Nhẹ nhàng, thời trang, chuyên dụng cho di động.', '32GB Storage', 3900000, 4500000, 'https://shoptrongnghia.com/wp-content/uploads/2020/08/switchhong.jpg', NOW(), 3570, 7, 275, 1, 'switch-lite-coral', 0, 'Switch Games', 'WiFi', 'Bảo hành 12 tháng'),

(3, 3, 'Nintendo Switch Pro Controller', 'Tay cầm không dây cao cấp.', 'Mang lại trải nghiệm chơi game chuyên nghiệp trên Switch.', 'HD Rumble, NFC Amiibo', 1550000, 1750000, 'https://www.droidshop.vn/wp-content/uploads/2023/04/Tay-cam-Nintendo-Switch-Pro-Controller.jpg', NOW(), 1300, 40, 246, 1, 'switch-pro-controller', 1, 'Switch/PC', 'Bluetooth', 'Bảo hành 12 tháng');

-- 4. VALVE (Brand 4)
-- 34. Valve Steam Deck 64GB (Certified Refurbished)
(
    2, -- categories_id: Handheld Gaming
    4, -- brand_id: Valve
    'Steam Deck 64GB (Certified Refurbished)', 
    'Hàng tân trang chính hãng từ Valve với mức giá tối ưu nhất để trải nghiệm game PC cầm tay.', 
    'Steam Deck Refurbished được chính Valve kiểm định và đảm bảo tiêu chuẩn chất lượng như máy mới. Đây là cơ hội tuyệt vời để sở hữu thiết bị chơi game cầm tay mạnh mẽ chạy SteamOS, hỗ trợ chơi mượt mà hàng ngàn tựa game trên thư viện Steam với mức giá cực kỳ tiết kiệm.', 
    'CPU: AMD Zen 2, GPU: 8 RDNA 2 CUs, RAM: 16GB LPDDR5, Bộ nhớ: 64GB eMMC (Có thể nâng cấp SSD).', 
    9990000, 
    10990000, 
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQac29NMQX4uP7h0t8tEtUpM7b2nC0JZ8uIng&s', 
    NOW(), 
    '40 Wh', -- energy
    '2 - 8 Hours', -- useTime
    '669g', -- weight
    1, 
    'steam-deck-refurbished', 
    0, 
    'SteamOS 3.0, Proton Support, Desktop Mode', 
    'USB-C (DP support), Wi-Fi 5, Bluetooth 5.0', 
    'Bảo hành 6 tháng, Tặng kèm bao chống sốc và bộ sạc 45W'
);

-- 1. Steam Deck OLED - 512GB (NVMe SSD)
(
    2, -- categories_id: Handheld Gaming
    4, -- brand_id: Valve
    'Steam Deck OLED - 512GB', 
    'Phiên bản nâng cấp màn hình OLED 90Hz sống động và thời lượng pin vượt trội.', 
    'Steam Deck OLED mang đến trải nghiệm hình ảnh tuyệt đỉnh với màu đen sâu tuyệt đối và hỗ trợ HDR. Với viên pin lớn hơn và tiến trình chip mới, máy hoạt động mát mẻ hơn, cho thời gian chơi game dài hơn so với bản LCD truyền thống.', 
    'Màn hình: 7.4 inch OLED 90Hz HDR, SSD: 512GB NVMe, Wi-Fi 6E nhanh hơn.', 
    17990000, 
    20090000, 
    'https://haloshop.vn/wp-content/uploads/2025/02/steam-deck-64gb-emmc-00-700x700-1.jpg', 
    NOW(), 
    '50 Wh', -- energy: Dung lượng pin nâng cấp của bản OLED
    '3 - 12 Hours', -- useTime: Tùy theo độ nặng của game
    '640g', 
    1, 
    'steam-deck-oled-512gb', 
    1, 
    'SteamOS (Arch-based Linux), Steam Library', 
    'Wi-Fi 6E, Bluetooth 5.3', 
    'Bảo hành 12 tháng, Tặng bao chống sốc chính hãng'
);

-- 2. Steam Deck OLED White Edition - 1TB (Limited Edition)
(
    2, 4, 
    'Steam Deck OLED White Edition - 1TB', 
    'Phiên bản giới hạn Limited Edition màu trắng cực kỳ sang trọng và hiếm có.', 
    'Steam Deck OLED White Edition không chỉ là một cỗ máy chơi game mạnh mẽ mà còn là một món đồ sưu tầm giá trị. Toàn bộ vỏ máy và phụ kiện đi kèm đều mang tông màu trắng tinh tế, đi kèm với cấu hình cao nhất 1TB SSD và màn hình OLED chống lóa.', 
    'Phiên bản giới hạn, SSD: 1TB NVMe, Màn hình OLED chống lóa cao cấp.', 
    18800000, 
    19000000, 
    'https://haloshop.vn/wp-content/uploads/2025/02/steam_deck_oled_1tb_white_edition_00-700x700-1.jpg', 
    NOW(), 
    '50 Wh', 
    '3 - 12 Hours', 
    '640g', 
    1, 
    'steam-deck-oled-white-edition', 
    1, 
    'Steam Library, SteamOS', 
    'Wi-Fi 6E, Bluetooth 5.3', 
    'Bảo hành 12 tháng, Fullbox phiên bản giới hạn màu trắng'
);

-- 3. Valve Steam Deck OLED - 1TB (Standard Black)
(
    2, 4, 
    'Valve Steam Deck OLED - 1TB', 
    'Dung lượng lưu trữ tối đa cho kho game Steam đồ sộ của bạn.', 
    'Với dung lượng 1TB NVMe SSD tốc độ cao, bạn có thể cài đặt hàng loạt tựa game AAA mà không lo về bộ nhớ. Màn hình OLED trên bản 1TB được trang bị lớp phủ chống lóa cao cấp (Premium Anti-glare Etched Glass) giúp chơi tốt trong mọi điều kiện ánh sáng.', 
    'Màn hình: OLED HDR chống lóa, SSD: 1TB NVMe, Pin: 50Wh.', 
    19490000, 
    20790000, 
    'https://bizweb.dktcdn.net/100/476/122/products/316282002-5677069459005263-5496119171875278767-n-1675087036737-1702023014787.jpg?v=1702023019493', 
    NOW(), 
    '50 Wh', 
    '3 - 12 Hours', 
    '640g', 
    1, 
    'steam-deck-oled-1tb', 
    1, 
    'SteamOS, Desktop Mode (Linux), Proton Support', 
    'WiFi 6E, Bluetooth 5.3', 
    'Bảo hành 12 tháng, Tặng bao chống sốc bản đặc biệt 1TB'
),

-- 5. ASUS (Brand 5)

-- 1. ROG Ally (2023) RC71L
(
    2, -- categories_id: Handheld Gaming
    5,
    'ROG Ally (2023) RC71L', 
    'Máy chơi game cầm tay chạy Windows 11 Home với màn hình 7 inch FHD 120Hz sắc nét.', 
    'ROG Ally (2023) mang đến sự linh hoạt tuyệt đối khi chạy hệ điều hành Windows 11, cho phép bạn chơi game từ mọi nền tảng phổ biến như Steam, Epic, Xbox Game Pass và GOG. Thiết kế gamepad tích hợp giúp trải nghiệm điều khiển tự nhiên và chính xác.', 
    'CPU: AMD Ryzen™ Z1 Extreme / Z1, Màn hình: 7 inch FHD 120Hz, Hệ điều hành: Windows 11 Home.', 
    15490000, 
    16290000, 
    'https://laptopworld.vn/media/product/18489_13724_m__y_ch__i_game_asus_rog_ally_2023_1.jpg', 
    NOW(), 
    '40 Wh', -- energy: Dung lượng thực tế chuẩn của dòng 2023
    '2 - 5 Hours', -- useTime
    '608g', -- weight
    1, 
    'rog-ally-2023', 
    0, 
    'Steam, Epic, Xbox Game Pass, GOG', 
    'Wi-Fi 6E, Bluetooth 5.2', 
    'Bảo hành chính hãng 24 tháng'
);

-- 2. ROG Xbox Ally X (RC73XA)
(
    2, 
    5,
    'ROG Xbox Ally X (RC73XA)', 
    'Sự kết hợp hoàn hảo giữa ASUS và Xbox cho hiệu năng chơi game 1080p cực mạnh.', 
    'ROG Xbox Ally X là phiên bản đặc biệt nâng cấp hiệu năng, sở hữu kiến trúc mới giúp xử lý mượt mà các tựa game AAA ở độ phân giải Full HD. Hệ thống tản nhiệt và cần analog được tối ưu cho cường độ chơi game cao.', 
    'CPU: AMD Ryzen™ AI Z2 Extreme (8 nhân 16 luồng), GPU: Radeon Graphics tích hợp.', 
    24990000, 
    25790000, 
    'https://cdn2.cellphones.com.vn/x/media/catalog/product/r/o/rog-xbox-ally-x.jpg', 
    NOW(), 
    '80 Wh', -- energy: Nâng cấp pin lớn cho bản X
    '4 - 8 Hours', -- useTime
    '715g', -- weight
    1, 
    'rog-xbox-ally-x', 
    1, 
    'Steam, Epic, GOG, Xbox Game Pass, Cloud gaming', 
    'Wi-Fi, Bluetooth' ,
    'Tặng kèm 3 tháng Xbox Game Pass Ultimate'
);

-- 3. ROG Xbox Ally (RC73YA)
(
    2, 
    5, 
    'ROG Xbox Ally (RC73YA)', 
    'Handheld Gaming PC tối ưu giữa hiệu năng và thời lượng pin trong dòng Xbox Ally.', 
    'Phiên bản RC73YA tập trung vào sự cân bằng, giúp game thủ tận hưởng những giờ chơi game kéo dài hơn nhờ quản lý điện năng hiệu quả mà vẫn đảm bảo tốc độ khung hình ổn định trên hệ điều hành Windows 11.', 
    'CPU: AMD Ryzen™ Z1 Series, OS: Windows 11 Home, Thiết kế công thái học tối ưu.', 
    12990000, 
    14990000, 
    'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/asus_rog_xbox_ally_01_6fe17a60c8.png', 
    NOW(), 
    '40 Wh', -- energy
    '3 - 6 Hours', -- useTime
    '670g', -- weight
    1, 
    'rog-xbox-ally-rc73ya', 
    0, 
    'Steam, Epic, GOG, Xbox Game Pass, Cloud gaming', 
    'Wi-Fi, Bluetooth', 
    'Bảo hành 24 tháng chính hãng'
);

-- 4. Asus ROG Xbox Ally X – 1 TB (AMD RYZEN Z2 EXTREME)
(
    2, 
    5, 
    'Asus ROG Xbox Ally X – 1 TB', 
    'Quái vật Handheld Gaming với bộ nhớ 1TB và chip Ryzen Z2 Extreme đỉnh cao.', 
    'Sở hữu dung lượng lưu trữ 1TB cực lớn, bản Ally X này cho phép bạn mang theo toàn bộ thư viện game AAA bên mình. Sức mạnh từ chip Z2 Extreme giúp máy vận hành mọi tựa game PC nặng nhất hiện nay một cách trơn tru.', 
    'CPU: AMD Ryzen™ AI Z2 Extreme, RAM: LPDDR5X, SSD: 1TB NVMe, OS: Windows 11.', 
    24900000, 
    25900000, 
    'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_rc73_01_1.png', 
    NOW(), 
    '80 Wh', -- energy
    '4 - 7 Hours', -- useTime
    '670g', -- weight
    1, 
    'rog-xbox-ally-x-1tb', 
    1, 
    'Steam, Epic Games, Windows App Store', 
    'Wi-Fi & Bluetooth', 
    'Bảo hành chính hãng 2 năm, Tặng túi đựng ROG'
);

-- 9. Asus ROG Ally Z1 Extreme 
(
    2, -- categories_id: Handheld Gaming
    5, -- brand_id: Asus
    'Asus ROG Ally – 512GB (AMD Ryzen Z1 Extreme)', 
    'Máy chơi game cầm tay mạnh mẽ nhất từ Asus với chip Z1 Extreme và màn hình 120Hz.', 
    'Asus ROG Ally mang đến sức mạnh đồ họa vượt trội nhờ kiến trúc RDNA 3. Với màn hình Full HD 120Hz hỗ trợ FreeSync Premium, mọi chuyển động trong game đều trở nên mượt mà, không giật xé hình. Hệ thống tản nhiệt Zero Gravity giúp máy hoạt động mát mẻ và yên tĩnh ở mọi tư thế cầm.', 
    'CPU: AMD Ryzen Z1 Extreme (8 nhân/16 luồng), GPU: 12 RDNA 3 CUs, RAM: 16GB LPDDR5, SSD: 512GB NVMe.', 
    12990000, 
    17990000, 
    'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/a/s/asus_rog_ally_-11.png', 
    NOW(), 
    '40 Wh', -- energy: Dung lượng pin thực tế của máy
    '2 - 5 Hours', -- useTime: Thời gian sử dụng thực tế tùy tác vụ
    '608g', -- weight: Trọng lượng thực tế
    1, 
    'asus-rog-ally-z1-extreme', 
    1, -- ROG Ally Z1E vẫn là dòng máy cao cấp (Premium)
    'Windows 11 Home, Armoury Crate SE, Dolby Atmos', 
    'Wi-Fi 6E, Bluetooth 5.2, ROG XG Mobile Interface, USB-C (3.2 Gen 2)', 
    'Bảo hành 24 tháng chính hãng Asus, Tặng bao chống sốc ROG Ally'
);

-- 10. Asus ROG Ally X 2024 (Phiên bản cao cấp nhất của dòng ROG Ally với cấu hình mạnh mẽ, thiết kế tối ưu cho game thủ và nhiều tính năng độc quyền.)
(
    2,
    5, 
    'ASUS ROG Ally X (2024)', 
    'Phiên bản nâng cấp toàn diện với dung lượng Pin gấp đôi và RAM 24GB cực khủng.', 
    'ROG Ally X là máy chơi game cầm tay chạy Windows mạnh mẽ nhất hiện nay. Máy được trang bị <b>Cảm biến Hall Effect</b> chống drift, hệ thống tản nhiệt cải tiến và thiết kế công thái học mới giúp cầm nắm chắc chắn hơn trong những trận game kéo dài.', 
    'CPU: AMD Ryzen Z1 Extreme, RAM: 24GB LPDDR5X, SSD: 1TB NVMe M.2 2280, Màn hình: 7 inch FHD 120Hz.', 
    19990000, 
    20990000, 
    'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/g/r/group_551_8_.png', 
    NOW(), 
    '80 Wh', -- energy: Điểm nâng cấp lớn nhất (gấp đôi bản cũ)
    '3 - 8 Hours', -- useTime: Thời lượng pin thực tế đã cải thiện rất nhiều
    '678g', -- weight: Nặng hơn bản cũ một chút do pin lớn hơn
    1, 
    'asus-rog-ally-x-2024', 
    1, -- Sản phẩm thuộc phân khúc cao cấp nhất (Premium)
    'Windows 11, Armoury Crate SE, Dolby Atmos', 
    '2x USB-C (Thunderbolt 4 support), Wi-Fi 6E, Bluetooth 5.2', 
    'Bảo hành chính hãng 24 tháng, Tặng kèm túi chống sốc ROG cao cấp'
),

-- 11. ASUS ROG Ally White (Phiên bản màu trắng tinh tế, thiết kế tối ưu cho game thủ và nhiều tính năng độc quyền.)
(
    2, -- categories_id: Handheld Gaming
    5, -- brand_id: Asus
    'ASUS ROG Ally White', 
    'Máy chơi game cầm tay chạy Windows 11 mạnh mẽ với màn hình 120Hz sắc nét.', 
    'ASUS ROG Ally mang cả thư viện game PC khổng lồ vào lòng bàn tay bạn. Với hệ điều hành Windows 11 bản quyền, bạn có thể chơi mọi tựa game từ Steam, Epic, Game Pass... Màn hình 120Hz cùng công nghệ FreeSync Premium giúp trải nghiệm mượt mà, không xé hình.', 
    'CPU: AMD Ryzen Z1 Series, RAM: 16GB LPDDR5, SSD: 512GB NVMe, Màn hình: 7 inch FHD 120Hz 500 nits.', 
    13990000, 
    14990000, 
    'https://product.hstatic.net/1000288298/product/may-choi-game-asus-rog-ally-1_125baf73b5504f00b47cf6c7c6b5a9ba.png', 
    NOW(), 
    '40 Wh', -- energy: Dung lượng pin tiêu chuẩn của bản đời đầu
    '1.5 - 5 Hours', -- useTime: Thời lượng pin thực tế tùy tác vụ
    '608g', -- weight: Trọng lượng rất nhẹ, thoải mái khi cầm lâu
    1, 
    'asus-rog-ally-white', 
    0, 
    'Windows 11, Armoury Crate SE, Xbox Game Pass 3 tháng', 
    'USB-C (ROG XG Mobile), Wi-Fi 6E, Bluetooth 5.2', 
    'Bảo hành 12 tháng chính hãng, Tặng kèm đế dựng máy'
),

-- 35. ASUS TUF Gaming Handheld (Concept Edition) 
(
    2, -- categories_id: Handheld Gaming
    5, -- brand_id: Asus
    'ASUS TUF Gaming Handheld', 
    'Dòng máy cầm tay chuyên game với thiết kế siêu bền chuẩn quân đội và tản nhiệt tối ưu.', 
    'Kế thừa tinh thần của dòng TUF, mẫu Handheld này tập trung vào độ bền bỉ và khả năng hoạt động ổn định ở cường độ cao. Với lớp vỏ gia cố chắc chắn và hệ thống quạt tản nhiệt kép lớn, máy đảm bảo hiệu năng tối đa cho chip Ryzen Z1 khi chiến các tựa game AAA trong thời gian dài.', 
    'CPU: AMD Ryzen Z1, GPU: RDNA 3 Graphics, RAM: 16GB LPDDR5, Màn hình: 7 inch FHD 120Hz.', 
    15990000, 
    16990000, 
    'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog-ally-x.jpg', 
    NOW(), 
    '50 Wh', -- energy: Cấu hình pin cao hơn bản Ally White
    '3 - 7 Hours', -- useTime
    '700g', -- weight: Hơi nặng hơn một chút do thiết kế vỏ bền bỉ
    1, 
    'asus-tuf-gaming-handheld', 
    0, 
    'Windows 11, Military-grade Durability, Armoury Crate', 
    'USB-C, Wi-Fi 6E, Bluetooth 5.2', 
    'Bảo hành 12 tháng, Tặng bộ phụ kiện bảo vệ TUF chuyên dụng'
);

-- 6. MSI (Brand 6)

-- 1. Máy chơi game MSI Claw A1M
(
    2, -- categories_id: Handheld Gaming
    6, -- brand_id: MSI
    'Máy chơi game MSI Claw A1M', 
    'Chiếc PC Gaming Handheld đầu tiên từ MSI với sức mạnh chip Intel Core Ultra.', 
    'MSI Claw A1M đánh dấu sự gia nhập của MSI vào thị trường máy cầm tay. Máy sở hữu thiết kế công thái học vượt trội, tản nhiệt Cooler Boost HyperFlow độc quyền và chip Intel Core Ultra mang lại khả năng xử lý đồ họa mượt mà cùng công nghệ xeSS hiện đại.', 
    'CPU: Intel Core Ultra 5/7, GPU: Intel Arc Graphics, Màn hình: 7 inch FHD 120Hz.', 
    13990000, 
    19990000, 
    'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-1.jpg', 
    NOW(), 
    '53 Wh', -- energy: Dung lượng pin thực tế
    '2 - 5 Hours', 
    '675g', 
    1, 
    'msi-claw-a1m', 
    0, 
    'Game PC (Steam, Epic, Xbox Game Pass) trên Windows 11', 
    'Wi-Fi 7, Bluetooth 5.4, Thunderbolt 4', 
    'Bảo hành 24 tháng chính hãng MSI'
),

-- 2. MSI Claw A8 BZ2EM-025PL (Bản AMD Z2 Extreme)
(
    2, 6, 
    'MSI Claw A8 BZ2EM-025PL', 
    'Sức mạnh từ AMD Ryzen Z2 Extreme cùng màn hình 8 inch Full HD+ sắc nét.', 
    'Phiên bản MSI Claw A8 mang đến bước nhảy vọt về hiệu năng với chip Z2 Extreme và RAM 24GB. Màn hình được nâng cấp lên 8 inch cho không gian trải nghiệm rộng lớn hơn, phù hợp cho các game thủ muốn chiến game AAA ở mức thiết lập cao.', 
    'CPU: AMD Ryzen™ Z2 Extreme, RAM: 24GB LPDDR5X, SSD: 1TB, Màn hình: 8 inch 120Hz.', 
    24590000, 
    25990000, 
    'https://techbox.com.gr/images/ab__webp/thumbnails/570/570/detailed/11627/msi-claw-a8-bz2em-025pl-portable-game-console-20-3-cm-8-1-tb-touchscreen-wi-fi-white-11746257_jpg.webp', 
    NOW(), 
    '80 Wh', -- energy: Nâng cấp pin lớn
    '4 - 7 Hours', 
    '765g', 
    1, 
    'msi-claw-a8-z2-extreme', 
    1, 
    'Steam, Epic, Xbox Game Pass, GOG', 
    'Wi-Fi 7, Bluetooth 5.4', 
    'Bảo hành 24 tháng chính hãng MSI'
),

-- 3. MSI Claw 8 AI+ A2VM-037PL
(
    2, 6, 
    'MSI Claw 8 AI+ A2VM-037PL', 
    'Handheld AI thế hệ mới với chip Intel Core Ultra 258V và đồ họa Intel Arc.', 
    'MSI Claw 8 AI+ là thiết bị cầm tay tiên phong tích hợp xử lý AI chuyên sâu. Với vi xử lý Intel Core Ultra 7 258V (Lunar Lake), máy không chỉ mạnh mẽ trong việc chơi game mà còn tối ưu hóa tài nguyên thông minh, mang lại thời lượng pin ấn tượng và hiệu suất đồ họa đột phá.', 
    'CPU: Intel Core Ultra 7 258V, GPU: Intel Arc thế hệ mới, RAM: 32GB, SSD: 1TB.', 
    26900000, 
    27290000, 
    'https://techbox.com.gr/images/ab__webp/thumbnails/570/570/detailed/11431/msi-claw-8-ai-a2vm-037pl-portable-game-console-20-3-cm-8-1-tb-touchscreen-wi-fi-beige-11550743_jpg.webp', 
    NOW(), 
    '82 Wh', -- energy: Dung lượng pin cao nhất dòng Claw
    '5 - 8 Hours', 
    '780g', -- Cập nhật trọng lượng thực tế cho bản pin lớn
    1, 
    'msi-claw-8-ai-plus', 
    1, 
    'Game PC AAA, AI Applications, Windows 11', 
    'Wi-Fi 7, Bluetooth 5.4, Dual Thunderbolt 4', 
    'Bảo hành 24 tháng chính hãng MSI, Tặng kèm túi đựng cao cấp'
),

-- 12. MSI Claw A1M Ultra 7 (Máy chơi game cầm tay đầu tiên trang bị chip Intel Core Ultra 7 mạnh mẽ, thiết kế tối ưu cho game thủ và nhiều tính năng độc quyền.)
(
    2, -- categories_id: Handheld Gaming
    6, -- brand_id: MSI
    'MSI Claw A1M Ultra 7', 
    'Máy chơi game cầm tay đầu tiên trang bị chip Intel Core Ultra 7 mạnh mẽ.', 
    'MSI Claw mang đến làn gió mới với vi xử lý Intel Core Ultra tích hợp công nghệ AI. Máy sở hữu hệ thống tản nhiệt Cooler Boost HyperFlow độc quyền và cần Analog/Trigger trang bị <b>Cảm biến Hall Effect</b> giúp loại bỏ hoàn toàn hiện tượng trôi cần, mang lại độ chính xác tuyệt đối.', 
    'CPU: Intel Core Ultra 7 155H, GPU: Intel Arc Graphics, RAM: 16GB LPDDR5, SSD: 512GB NVMe, Màn hình: 7 inch FHD 120Hz.', 
    18990000, 
    19990000, 
    'https://cdn.tgdd.vn/Products/Images/12918/329815/may-choi-game-cam-tay-msi-claw-a1m-049vn-core-ultra-7-155h-16gb-512gb-120hz-win11-12-600x600.jpg', 
    NOW(), 
    '53 Wh', -- energy: Dung lượng pin thực tế
    '2 - 7 Hours', -- useTime: Thời lượng pin tùy tác vụ
    '675g', -- weight: Trọng lượng thực tế của máy
    1, 
    'msi-claw-ultra-7', 
    0, 
    'Intel XeSS, MSI Center M, Windows 11', 
    'Thunderbolt 4, Wi-Fi 7, Bluetooth 5.4, MicroSD Card Reader', 
    'Bảo hành chính hãng 24 tháng, Tặng kèm túi đựng máy chính hãng MSI'
),

-- 13. MSI Claw A1M Ultra 5 (Phiên bản cân bằng giữa hiệu suất và giá thành với vi xử lý Intel Core Ultra 5, thiết kế tối ưu cho game thủ và nhiều tính năng độc quyền.)
(
    2, -- categories_id: Handheld Gaming
    6, -- brand_id: MSI
    'MSI Claw A1M Ultra 5', 
    'Phiên bản cân bằng giữa hiệu suất và giá thành với vi xử lý Intel Core Ultra 5.', 
    'MSI Claw Ultra 5 sở hữu thiết kế công thái học vượt trội, mang lại sự thoải mái tối đa cho game thủ. Dù là phiên bản rút gọn, máy vẫn được trang bị đầy đủ <b>Cảm biến Hall Effect</b> cho cả cần Analog và Trigger, cùng hệ thống tản nhiệt HyperFlow giúp duy trì hiệu năng ổn định.', 
    'CPU: Intel Core Ultra 5 135H, GPU: Intel Arc Graphics, RAM: 16GB LPDDR5, SSD: 512GB NVMe, Màn hình: 7 inch FHD 120Hz.', 
    15990000, 
    16990000, 
    'https://m.media-amazon.com/images/I/71788CmL7GL.jpg', 
    NOW(), 
    '53 Wh', -- energy: Dung lượng pin giống bản Ultra 7
    '2 - 7 Hours', -- useTime
    '675g', -- weight
    1, 
    'msi-claw-ultra-5', 
    0, 
    'Intel XeSS, MSI Center M, Windows 11', 
    'Thunderbolt 4, Wi-Fi 7, Bluetooth 5.4, MicroSD Card Reader', 
    'Bảo hành chính hãng 24 tháng, Miễn phí vận chuyển toàn quốc'
),

-- 14. MSI Claw A1M (Phiên bản tiêu chuẩn với vi xử lý Intel Core Ultra 7, thiết kế tối ưu cho game thủ và nhiều tính năng độc quyền.)
(2, 6, 'MSI Claw A1M', 'Handheld đầu tiên của MSI.', 'Chip Intel Core Ultra 7.', 'Intel Core Ultra 7', 13990000, 19990000, 'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-3.jpg', NOW(), 3000, 4, 675, 1, 'msi-claw', 0, 'Windows 11', 'WiFi 7', 'Bảo hành 12 tháng'),
-- MSI Claw A8 Z2 Extreme
(41, 2, 6, 'MSI Claw A8 Z2 Extreme', 'Sức mạnh từ AMD Z2.', 'Màn hình 8 inch 120Hz, RAM 24GB.', 'Z2 Extreme, 24GB RAM', 24590000, 25990000, 'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-3.jpg', NOW(), 3000, 5, 765, 1, 'msi-claw-a8', 0, 'Windows 11', 'WiFi 7', 'Bảo hành 12 tháng'),
-- 36. MSI Claw Lite
(
    2, -- categories_id: Handheld Gaming
    6, -- brand_id: MSI
    'MSI Claw Lite', 
    'Phiên bản tối ưu trọng lượng, giá dễ tiếp cận với hiệu năng chip Intel Core Ultra 5.', 
    'MSI Claw Lite mang đến sự cân bằng hoàn hảo cho nhu cầu chơi game phổ thông trên Windows. Thiết kế nhẹ hơn giúp cầm nắm thoải mái trong thời gian dài, đi kèm hệ thống tản nhiệt HyperFlow tiên tiến.', 
    'CPU: Intel Core Ultra 5, GPU: Intel Arc Graphics, RAM: 16GB, Màn hình: 7 inch 120Hz.', 
    13990000, 
    14990000, 
    'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-1-678x800.jpg', 
    NOW(), 
    '53 Wh', -- energy: Dung lượng pin ổn định
    '3 - 6 Hours', -- useTime
    '650g', -- weight: Nhẹ hơn bản tiêu chuẩn
    1, 
    'msi-claw-lite', 
    0, 
    'Windows 11, MSI Center M, AI Engine', 
    'USB-C, WiFi 7, Bluetooth 5.4', 
    'Bảo hành 12 tháng chính hãng MSI'
);



-- 7. LENOVO (Brand 7)
-- 15. Lenovo Legion Go 
(
    2, -- categories_id: Handheld Gaming
    7, -- brand_id: Lenovo
    'Lenovo Legion Go (8.8 inch)', 
    'Siêu phẩm cầm tay với màn hình QHD 144Hz khổng lồ và tay cầm tháo rời độc đáo.', 
    'Lenovo Legion Go mang đến trải nghiệm thị giác đỉnh cao với màn hình 8.8 inch sắc nét. Điểm nhấn lớn nhất là tay cầm Legion TrueStrike có thể tháo rời, tích hợp <b>Cảm biến Hall Effect</b> và chế độ FPS Mode giúp bạn biến tay cầm phải thành một con chuột chuyên nghiệp để chơi game bắn súng.', 
    'CPU: AMD Ryzen Z1 Extreme, RAM: 16GB LPDDR5X, SSD: 512GB NVMe, Màn hình: 8.8 inch QHD+ (2560 x 1600) 144Hz.', 
    17990000, 
    18990000, 
    'https://www.droidshop.vn/wp-content/uploads/2023/11/May-choi-game-Lenovo-Legion-Go-8.8-AMD-Ryzen-Z1-Extreme-16GB-512GB-2.jpg', 
    NOW(), 
    '49.2 Wh', -- energy: Dung lượng pin thực tế
    '2 - 6 Hours', -- useTime: Tùy theo độ phân giải màn hình bạn thiết lập
    '854g', -- weight: Khá nặng do màn hình lớn (640g máy + 214g tay cầm)
    1, 
    'lenovo-legion-go-standard', 
    1, -- Để là 1 vì đây là sản phẩm rất ấn tượng
    'Legion Space, FPS Mode, Detachable Controllers', 
    '2x USB-C (USB4), Wi-Fi 6E, Bluetooth 5.2, MicroSD Slot', 
    'Bảo hành 12 tháng, Tặng kèm túi đựng máy cao cấp và đế dựng FPS Mode'
),

-- 37. Lenovo Legion Play
(
    2, -- categories_id: Handheld Gaming
    7, -- brand_id: Lenovo
    'Lenovo Legion Play', 
    'Máy chơi game chuyên dụng chạy Android, tối ưu cho Cloud Gaming và giả lập.', 
    'Thiết kế Legion đặc trưng với tay cầm công thái học, Legion Play là thiết bị hoàn hảo để trải nghiệm Xbox Cloud, GeForce Now hoặc các trình giả lập Android với thời lượng pin cực dài.', 
    'CPU: Snapdragon 720G, RAM: 4GB, Màn hình: 7 inch FHD HDR10.', 
    8990000, 
    9990000, 
    'https://i.ytimg.com/vi/Gx3mROmcYNk/maxresdefault.jpg', 
    NOW(), 
    '7000 mAh', -- energy: Pin dung lượng lớn cho Android
    '7 - 10 Hours', -- useTime
    '430g', -- weight: Trọng lượng lý tưởng cho handheld
    1, 
    'lenovo-legion-play', 
    0, 
    'Android 11, Cloud Gaming Ready, Google Play', 
    'USB-C, WiFi, Bluetooth 5.0', 
    'Bảo hành 6 tháng, Miễn phí giao hàng toàn quốc'
);

-- 8. AYANEO (Brand 8)

-- 1. AYANEO 2
(
    2, -- categories_id: Handheld Gaming
    8, -- brand_id: Ayaneo
    'AYANEO 2', 
    'Máy chơi game cầm tay Windows với thiết kế màn hình vô cực viền siêu mỏng.', 
    'AYANEO 2 là chiếc Handheld PC đầu tiên của hãng trang bị chip AMD Ryzen 7 6800U. Điểm nhấn lớn nhất là mặt trước phủ kính hoàn toàn với thiết kế không viền, mang lại trải nghiệm thị giác đỉnh cao cùng cần Analog Hall Effect chống trôi.', 
    'CPU: AMD Ryzen 7 6800U, GPU: Radeon 680M, RAM: 16GB, Màn hình: 7 inch 1200P.', 
    12000000, 
    13290000, 
    'https://weirdstore.vn/wp-content/uploads/2024/03/AYANEOAIR_20_cfc73e29-919e-4371-9dbe-9f5696e8e9af-1536x1536.webp', 
    NOW(), 
    '13000 mAh', -- energy
    '3 - 5 Hours', -- useTime
    '680g', -- weight
    1, 
    'ayaneo-2-6800u', 
    1, 
    'Steam, Epic Games, Xbox Game Pass PC, GOG', 
    'WiFi 6, Bluetooth 5.2', 
    'Bảo hành 12 tháng, Tặng kèm bao chống sốc'
);

-- 2. AYANEO 2S – Order
(
    2, 8, 
    'AYANEO 2S – Order', 
    'Bản nâng cấp phần cứng mạnh mẽ với chip Ryzen 7000 series.', 
    'Kế thừa thiết kế cao cấp từ AYANEO 2, phiên bản 2S được nâng cấp sức mạnh CPU đáng kể và tối ưu hệ thống tản nhiệt mới. Máy đáp ứng tốt các tựa game AAA nặng nhất hiện nay trên nền tảng Windows 11.', 
    'CPU: AMD Ryzen 7 7840U, GPU: Radeon 780M, RAM: 16GB/32GB.', 
    19900000, 
    20100000, 
    'https://weirdstore.vn/wp-content/uploads/2024/03/n-3.png', 
    NOW(), 
    '13000 mAh', 
    '4 - 6 Hours', 
    '680g', 
    1, 
    'ayaneo-2s-7840u', 
    1, 
    'Steam, Epic Games, Xbox Game Pass, GOG', 
    'WiFi 6E, Bluetooth 5.2', 
    'Hàng Order - Bảo hành 12 tháng chính hãng'
);

-- 3. AYANEO 3 (AI370)
(
    2, 8, 
    'AYANEO 3 32Gb – 1Tb chip AI370', 
    'Siêu phẩm Handheld thế hệ mới với chip AI370 cực khủng.', 
    'AYANEO 3 được đánh giá là một trong những thiết bị cầm tay mạnh nhất thế giới hiện nay. Với chip xử lý tích hợp AI thế hệ mới, máy không chỉ chiến game AAA mượt mà còn hỗ trợ các tác vụ xử lý thông minh, màn hình OLED rực rỡ.', 
    'CPU: AMD Ryzen AI 9 HX 370, RAM: 32GB, SSD: 1TB, Màn hình OLED.', 
    32000000, 
    33090000, 
    'https://weirdstore.vn/wp-content/uploads/2024/11/Untitled-1.jpg', 
    NOW(), 
    '13000 mAh', 
    '4 - 6 Hours', 
    '680g', 
    1, 
    'ayaneo-3-ai370', 
    1, 
    'Steam, Epic Games, Xbox Game Pass PC, GOG', 
    'WiFi 7, Bluetooth 5.4', 
    'Bảo hành 12 tháng, Tặng bộ quà tặng cao cấp'
);

-- 4. AYANEO Geek
(
    2, 8, 
    'AYANEO Geek', 
    'Hiệu năng gaming PC mạnh mẽ với mức giá tối ưu hơn.', 
    'AYANEO Geek là phiên bản tinh giản từ AYANEO 2, tập trung tối đa vào hiệu năng chơi game thực tế. Đây là lựa chọn lý tưởng cho game thủ muốn sở hữu một chiếc máy Windows cầm tay cấu hình cao với chi phí hợp lý.', 
    'CPU: AMD Ryzen 7 6800U, RAM: 16GB, Màn hình: 7 inch 800P/1200P.', 
    11000000, 
    12190000, 
    'https://weirdstore.vn/wp-content/uploads/2024/03/image-61-935x800.png', 
    NOW(), 
    '13000 mAh', 
    '3 - 5 Hours', 
    '680g', 
    1, 
    'ayaneo-geek', 
    0, 
    'Steam, Epic Games, Xbox Game Pass PC, GOG', 
    'WiFi 6, Bluetooth 5.2', 
    'Bảo hành 12 tháng'
);

-- 5. Ayaneo Pocket Micro
(
    2, 8, 
    'Ayaneo Pocket Micro', 
    'Handheld Android siêu nhỏ gọn với thiết kế sang trọng vỏ kim loại.', 
    'Pocket Micro là mẫu máy nhỏ nhất của nhà Ayaneo chạy Android 13. Máy được hoàn thiện bằng vỏ kim loại cao cấp, thiết kế lấy cảm hứng từ Game Boy Micro, chuyên dụng để giả lập các hệ máy retro và chơi game Android nhẹ.', 
    'Hệ điều hành: Android 13, Thiết kế vỏ kim loại CNC, Kích thước bỏ túi.', 
    7690000, 
    7800000, 
    'https://weirdstore.vn/wp-content/uploads/2024/09/AYANEO-POCKET-MICRO-SOUL-RED-DONE-01.png', 
    NOW(), 
    '2600 mAh', 
    '4 - 6 Hours', 
    '233g', 
    1, 
    'ayaneo-pocket-micro', 
    0, 
    'Android/Retro Emulation (GBA, NES, SNES...)', 
    'WiFi & Bluetooth', 
    'Bảo hành 12 tháng'
);

-- 6. Ayaneo Pocket DS
(
    2, 8, 
    'Ayaneo Pocket DS', 
    'Máy chơi game Android màn hình đôi, tái hiện huyền thoại Nintendo DS.', 
    'AYANEO Pocket DS mang thiết kế nắp gập Clamshell với hai màn hình độc đáo. Đây là thiết bị tối ưu nhất để giả lập các hệ máy màn hình kép (NDS, 3DS) trên nền tảng Android, kết hợp cấu hình mạnh mẽ để chơi các game hiện đại.', 
    'Thiết kế 2 màn hình, OS: Android, Giả lập đa hệ máy chuyên sâu.', 
    12800000, 
    13190000, 
    'https://weirdstore.vn/wp-content/uploads/2025/08/ayaneo-pocket-ds-indiegogo-confirmation-kv-1067x800.jpg', 
    NOW(), 
    '8000 mAh', 
    '6 - 10 Hours', 
    '450g', -- Đã điều chỉnh trọng lượng thực tế (khoảng 450g thay vì 1kg)
    1, 
    'ayaneo-pocket-ds', 
    1, 
    'Retro Emulation (DS/3DS, PSP, PS2...)', 
    'WiFi & Bluetooth', 
    'Bảo hành 12 tháng, Tặng thẻ nhớ full game'
),

-- 16. AYANEO Geek 1S (Máy chơi game cầm tay mạnh nhất hiện nay với chip AMD AI370 và RAM 32GB, thiết kế tối ưu cho game thủ và nhiều tính năng độc quyền.)
(
    2, -- categories_id: Handheld Gaming
    8, -- brand_id: Ayaneo
    'AYANEO Geek 1S', 
    'Máy chơi game cầm tay cao cấp với chip Ryzen 7 7840U và thiết kế không viền màn hình.', 
    'AYANEO Geek 1S mang đến trải nghiệm chơi game PC mượt mà với con chip 7840U mạnh mẽ. Máy được trang bị hệ thống điều khiển <b>Cảm biến Hall Effect</b> toàn diện (cả cần Analog và Trigger) giúp chống trôi cần tuyệt đối và cho độ phản hồi cực kỳ chính xác.', 
    'CPU: AMD Ryzen 7 7840U, RAM: 16GB/32GB LPDDR5X, SSD: 512GB/2TB NVMe, Màn hình: 7 inch Slim Bezel.', 
    18990000, 
    19990000, 
    'https://weirdstore.vn/wp-content/uploads/2024/03/n-2.png', 
    NOW(), 
    '50.25 Wh', -- energy: Dung lượng pin thực tế
    '2 - 6 Hours', -- useTime
    '640g', -- weight
    1, 
    'ayaneo-geek-1s', 
    0, 
    'AYASpace 2, Hall Effect Sensor, Fingerprint Unlock', 
    '3x USB-C (USB4 support), Wi-Fi 6E, Bluetooth 5.2', 
    'Bảo hành 12 tháng, Tặng kèm bộ phụ kiện sạc nhanh và cáp USB-C'
),

-- 17. AYANEO Slide
(
    2, -- categories_id: Handheld Gaming
    8, -- brand_id: Ayaneo
    'AYANEO Slide', 
    'Máy chơi game cầm tay màn hình trượt độc đáo với bàn phím QWERTY tích hợp.', 
    'AYANEO Slide tái định nghĩa trải nghiệm handheld với thiết kế màn hình trượt linh hoạt, tiết lộ bàn phím QWERTY bên dưới giúp nhập liệu dễ dàng. Máy trang bị <b>Cảm biến Hall Effect</b> cho độ chính xác tuyệt đối và con chip 7840U mạnh mẽ cho mọi tựa game AAA.', 
    'CPU: AMD Ryzen 7 7840U, RAM: 16GB/32GB LPDDR5X, Màn hình: 6 inch FHD IPS (Trượt & Nghiêng), Bàn phím: RGB QWERTY.', 
    19990000, 
    20990000, 
    'https://weirdstore.vn/wp-content/uploads/2024/03/n-3.jpg', 
    NOW(), 
    '46.2 Wh', -- energy: Dung lượng pin thực tế
    '2 - 5 Hours', -- useTime: Thời lượng pin thực tế
    '650g', -- weight: Trọng lượng thực tế (khoảng 650g)
    1, 
    'ayaneo-slide-7840u', 
    1, -- Để là 1 vì đây là thiết kế độc lạ, cao cấp
    'AYASpace 2, Hall Effect Sensor, Sliding Keyboard', 
    '2x USB4 (Full speed), Wi-Fi 6E, Bluetooth 5.2', 
    'Bảo hành 12 tháng, Tặng kèm túi chống sốc và bộ sạc nhanh PD'
),

-- 38. AYANEO Air
(
    2, -- categories_id: Handheld Gaming
    8, -- brand_id: Ayaneo
    'AYANEO Air', 
    'Thiết kế siêu mỏng nhẹ với màn hình OLED rực rỡ và chip Ryzen 5 mạnh mẽ.', 
    'AYANEO Air tái định nghĩa máy chơi game cầm tay với trọng lượng chưa tới 400g. Màn hình OLED mang lại màu sắc tuyệt đẹp, đi kèm cần Analog Hall Effect chống trôi cần tuyệt đối.', 
    'CPU: AMD Ryzen 5 5560U, Màn hình: 5.5 inch OLED FHD, RAM: 16GB, SSD: 512GB.', 
    15990000, 
    16990000, 
    'https://weirdstore.vn/wp-content/uploads/2024/03/csm_Untitled_1_f1e5aafca1.jpg', 
    NOW(), 
    '7350 mAh', -- energy
    '2 - 5 Hours', -- useTime
    '398g', -- weight: Siêu nhẹ
    1, 
    'ayaneo-air-oled', 
    1, 
    'OLED Screen, Hall Effect Sensor, Fingerprint Unlock', 
    'USB-C, WiFi 6, Bluetooth 5.2', 
    'Bảo hành 12 tháng, Tặng kèm túi đựng máy chính hãng'
);

-- 9. GPD (Brand 9)

-- 1. GPD WIN 5 (AI Max 385/AI Max Plus 395)
(
    2, -- categories_id: Handheld Gaming
    9, -- brand_id: GPD
    'GPD WIN 5 (AI Max 385/AI Max Plus 395)', 
    'Siêu phẩm Handheld PC cao cấp nhất 2025 với sức mạnh từ chip AMD Ryzen AI Max.', 
    'GPD WIN 5 thiết lập tiêu chuẩn mới cho máy chơi game cầm tay với vi xử lý Ryzen AI Max thế hệ mới nhất. Máy không chỉ tối ưu cho các tựa game AAA nặng nhất mà còn tích hợp nhân xử lý AI chuyên dụng, giúp tăng cường hiệu suất đồ họa và thời lượng pin thông minh.', 
    'CPU: AMD Ryzen AI Max 385 / AI Max Plus 395, RAM: LPDDR5x, SSD: NVMe Gen4.', 
    45980000, 
    50900000, 
    'https://pcngon.vn/wp-content/uploads/2025/11/May-tinh-cam-tay-GPD-WIN-5-Al-Max-385-AI-Max-Plus-395.jpg', 
    NOW(), 
    '60 Wh', -- energy: Đã cập nhật dung lượng pin thực tế cho dòng PC cao cấp
    '3 - 6 Hours', -- useTime
    '590g', -- weight
    1, 
    'gpd-win-5-ai-max', 
    1, -- Dòng Flagship cao cấp
    'Steam, Epic, Xbox Game Pass, AI Tools', 
    'WiFi 7, Bluetooth 5.4, Oculink', 
    'Bảo hành 12 tháng, Tặng kèm Dock sạc chuyên dụng'
),

-- 2. GPD Win 4 (Phiên bản tiêu chuẩn)
 (
    2, 9, 
    'GPD Win 4', 
    'Thiết kế bàn phím trượt độc đáo, hiệu năng PC mạnh mẽ trong lòng bàn tay.', 
    'GPD Win 4 nổi bật với thiết kế trượt màn hình để lộ bàn phím vật lý bên dưới, lấy cảm hứng từ dòng Sony VAIO P huyền thoại. Đây là thiết bị hoàn hảo cho những ai cần sự kết hợp giữa máy chơi game cầm tay và khả năng nhập liệu nhanh của một chiếc mini laptop.', 
    'CPU: AMD Ryzen 6800U, RAM: 16GB, Thiết kế bàn phím trượt vật lý.', 
    11000000, 
    12290000, 
    'https://weirdstore.vn/wp-content/uploads/2024/03/n-2.jpg', 
    NOW(), 
    '45.62 Wh', 
    '3 - 6 Hours', 
    '598g', 
    1, 
    'gpd-win-4-standard', 
    0, 
    'Game PC AAA, Steam, Epic, Emulation', 
    'WiFi 6, Bluetooth 5.2, USB4', 
    'Bảo hành 12 tháng'
),

-- 3. GPD Win 4 8840U (Bản nâng cấp hiệu năng)
(
    2, 9, 
    'GPD Win 4 8840U', 
    'Bản nâng cấp chip Ryzen 7 8840U cho hiệu năng đồ họa và xử lý AI vượt trội.', 
    'Giữ nguyên thiết kế bàn phím trượt nhỏ gọn đặc trưng, phiên bản nâng cấp này mang trong mình chip Ryzen 7 8840U mạnh mẽ. Máy đáp ứng mượt mà các tựa game PC mới nhất và tối ưu hóa điện năng tốt hơn, mang lại trải nghiệm gaming di động đỉnh cao.', 
    'CPU: AMD Ryzen 7 8840U, GPU: Radeon 780M, RAM: 32GB, SSD: 1TB.', 
    20500000, 
    20900000, 
    'https://weirdstore.vn/wp-content/uploads/2024/03/n-2.jpg', 
    NOW(), 
    '45.62 Wh', 
    '3 - 6 Hours', 
    '598g', 
    1, 
    'gpd-win-4-8840u', 
    1, 
    'Game PC AAA, Steam, Epic, Windows 11', 
    'WiFi 6E, Bluetooth 5.2, Oculink Port', 
    'Bảo hành 12 tháng chính hãng'
),

-- 18. GPD Win Max 2 2023 (Phiên bản nâng cấp mạnh mẽ với chip Ryzen 7 7840U, thiết kế dạng vỏ sò và nhiều tính năng độc quyền.)
(
    2, -- categories_id: Handheld Gaming
    9, -- brand_id: GPD
    'GPD Win Max 2 2023 (Ryzen 7 7840U)', 
    'Sự kết hợp hoàn hảo giữa Laptop làm việc và máy chơi game cầm tay màn hình 10.1 inch.', 
    'GPD Win Max 2 2023 là thiết bị gaming cầm tay mạnh mẽ nhất với thiết kế dạng vỏ sò (Clamshell). Máy sở hữu bàn phím QWERTY đầy đủ, Touchpad và cụm phím chơi game có nắp che tinh tế. Trang bị <b>Cảm biến Hall Effect</b> cho cả cần Analog và Trigger, đảm bảo độ bền và chính xác tuyệt đối.', 
    'CPU: AMD Ryzen 7 7840U, RAM: 32GB LPDDR5X, SSD: 1TB NVMe, Màn hình: 10.1 inch 2.5K Touch, hỗ trợ Bút Stylus.', 
    22990000, 
    23990000, 
    'https://product.hstatic.net/1000203080/product/gpd-win-max-2-1_e92487e58b4d485580a445bab6cf85e6_master.jpg', 
    NOW(), 
    '67 Wh', -- energy: Viên pin cực lớn cho một thiết bị handheld
    '3 - 8 Hours', -- useTime: Thời lượng sử dụng ấn tượng nhờ pin lớn
    '1005g', -- weight: Trọng lượng thực tế khoảng hơn 1kg
    1, 
    'gpd-win-max-2-2023', 
    1, -- Để là 1 vì đây là thiết kế độc bản và giá trị cao
    'Built-in Keyboard, Oculink Port (eGPU), Fingerprint Unlock', 
    'Oculink (SFF-8612), USB4, HDMI 2.1, SD & MicroSD Slot', 
    'Bảo hành 12 tháng, Tặng kèm túi chống sốc và bộ sạc nhanh 100W PD'
),

-- 19. GPD Win 2 (Phiên bản huyền thoại với thiết kế vỏ sò siêu nhỏ gọn, hiệu năng đủ chơi game PC nhẹ và giả lập các hệ máy cổ điển.)
(
    2, -- categories_id: Handheld Gaming
    9, -- brand_id: GPD
    'GPD Win 2 (Intel Core m3-8100Y)', 
    'Máy chơi game PC bỏ túi huyền thoại với thiết kế vỏ sò siêu nhỏ gọn.', 
    'GPD Win 2 là biểu tượng của dòng máy tính chơi game cầm tay có thể bỏ gọn vào túi quần. Thiết kế nắp gập bảo vệ màn hình tuyệt đối, tích hợp bàn phím QWERTY và các phím điều khiển chơi game chuyên dụng. Phù hợp để trải nghiệm các tựa game Indie, Esport nhẹ và giả lập các hệ máy cổ điển.', 
    'CPU: Intel Core m3-8100Y, RAM: 8GB LPDDR3, SSD: 256GB M.2, Màn hình: 6 inch HD Touch.', 
    8990000, 
    9990000, 
    'https://product.hstatic.net/1000203080/product/mua-may-choi-game-cam-tay-gpd-win-2-gia-re.jpg', 
    NOW(), 
    '9800 mAh', -- energy: Tổng dung lượng 2 viên pin 4900mAh
    '3 - 6 Hours', -- useTime: Thời lượng sử dụng thực tế
    '460g', -- weight: Rất nhẹ và cân bằng
    1, 
    'gpd-win-2-8100y', 
    0, 
    'Full QWERTY Keyboard, Pocket Size, Windows Support', 
    '1x USB-C, 1x USB-A 3.0, Micro HDMI, Wi-Fi 5, Bluetooth 4.2', 
    'Bảo hành 6 tháng, Tặng bao chống sốc và thẻ giảm giá phụ kiện'
),

-- 20. GPD Win 4 8840U (Phiên bản mới nhất với chip AMD Ryzen 7 8840U mạnh mẽ, thiết kế nhỏ gọn và nhiều tính năng độc quyền.)
(2, 9, 'GPD Win 4 8840U', 'Chip AMD Ryzen 7 8840U.', 'Form dáng nhỏ gọn với bàn phím trượt.', 'AMD 8840U', 20500000, 20900000, 'https://pcngon.vn/wp-content/uploads/2024/04/May-choi-game-cam-tay-GPD-WIN-4-2024-Ram-32GB-SSD-2TB-9.jpg', NOW(), 3000, 6, 598, 1, 'gpd-win-4-8840u', 0, 'Windows 11', 'WiFi & BT', 'Bảo hành 12 tháng'),

-- 21. GPD Win Mini 2025 (Phiên bản siêu nhỏ gọn với thiết kế nắp gập bỏ túi, sức mạnh Ryzen 8000 và nhiều tính năng độc quyền.)
(2, 9, 'GPD Win Mini 2025', 'Handheld PC siêu nhỏ gọn.', 'Thiết kế nắp gập bỏ túi, sức mạnh Ryzen 8000.', 'Ryzen 7 8840U', 18500000, 19900000, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-1.jpg', NOW(), 4500, 5, 520, 1, 'gpd-win-mini', 1, 'Windows 11', 'WiFi 6E', 'Bảo hành 12 tháng');

(2, 9, 'GPD Win Mini 2025', 'Handheld PC siêu nhỏ gọn.', 'Thiết kế nắp gập bỏ túi, sức mạnh Ryzen 8000.', 'Ryzen 7 8840U', 18500000, 19900000, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-1.jpg', NOW(), 4500, 5, 520, 1, 'gpd-win-mini', 1, 'Windows 11', 'WiFi 6E', 'Bảo hành 12 tháng');
 
-- 39. GPD XP Plus
(
    2, -- categories_id: Handheld Gaming
    9, -- brand_id: GPD
    'GPD XP Plus', 
    'Máy chơi game Android dạng Module độc đáo, thay đổi tay cầm linh hoạt.', 
    'GPD XP Plus sở hữu cấu trúc mô-đun cho phép bạn hoán đổi các cụm phím điều khiển phù hợp cho game MOBA, FPS hoặc Giả lập. Tích hợp kết nối 4G cho trải nghiệm gaming mọi lúc mọi nơi.', 
    'CPU: MediaTek Dimensity 1200, RAM: 6GB, Màn hình: 6.81 inch, Hỗ trợ SIM 4G.', 
    9990000, 
    10990000, 
    'https://minhhightech.com/admin/sanpham/GPD-XP-Plus-_28_6107.jpg', 
    NOW(), 
    '7000 mAh', -- energy
    '8 - 12 Hours', -- useTime: Thời lượng pin cực trâu
    '331g', -- weight
    1, 
    'gpd-xp-plus-modular', 
    0, 
    'Modular Controller, 4G LTE, Android 11', 
    'USB-C, WiFi, 4G LTE, Bluetooth', 
    'Bảo hành 12 tháng, Tặng thẻ nhớ 64GB'
);

 -- 10. Anbernic (Brand 10)
-- 22. Anbernic RG35XX H (Phiên bản nâng cấp với thiết kế ngang hiện đại, cấu hình mạnh mẽ trong thân hình nhỏ gọn, và nhiều tính năng độc quyền.)
(2, 10, 'Anbernic RG35XX H', 'Thiết kế ngang hiện đại.', 'Cấu hình mạnh mẽ trong thân hình nhỏ gọn.', 'H-Series Design', 1450000, 1650000, 'https://images-na.ssl-images-amazon.com/images/I/71VoTjyKBUL.jpg', NOW(), 3300, 6, 180, 1, 'anbernic-rg35xxh', 0, 'Retro Systems', 'WiFi/BT', 'Bảo hành 12 tháng'),

-- 23. Anbernic RG35XX Plus
(
    2, -- categories_id: Handheld Gaming
    10, -- brand_id: Anbernic
    'Anbernic RG35XX Plus', 
    'Máy chơi game Retro cầm dọc huyền thoại, hỗ trợ giả lập hơn 30 hệ máy cổ điển.', 
    'Anbernic RG35XX Plus là phiên bản nâng cấp mạnh mẽ về hiệu năng so với bản tiền nhiệm. Với thiết kế cầm dọc cổ điển mang lại cảm giác hoài niệm, máy cho phép bạn chơi mượt mà các tựa game từ PS1, PSP, NDS đến các hệ máy thùng. Màn hình IPS 3.5 inch sắc nét cùng hệ điều hành Linux tối ưu giúp trải nghiệm chơi game trở nên đơn giản và thú vị hơn bao giờ hết.', 
    'CPU: Allwinner H700, RAM: 1GB LPDDR4, Màn hình: 3.5 inch IPS (640x480), Hệ điều hành: Linux.', 
    1690000, 
    1990000, 
    'https://vhost53003.vhostcdn.com/wp-content/uploads/2025/04/RG35XX-Plus-4.jpg', 
    NOW(), 
    '3300 mAh', -- energy: Dung lượng pin thực tế
    '6 - 8 Hours', -- useTime: Thời lượng pin cực tốt cho dòng máy Retro
    '186g', -- weight: Rất nhẹ, dễ dàng mang đi khắp nơi
    1, 
    'anbernic-rg35xx-plus', 
    0, 
    'PSP, PS1, DC, NDS, Arcade, GBA giả lập', 
    'Wi-Fi 5G, Bluetooth 4.2, Mini HDMI output, USB-C', 
    'Bảo hành 6 tháng, Tặng kèm thẻ nhớ 64GB chứa sẵn 5000+ game'
),

-- 24. Anbernic RG Arc-D
(
    2, -- categories_id: Handheld Gaming
    10, -- brand_id: Anbernic
    'Anbernic RG Arc-D', 
    'Máy chơi game Retro thiết kế tay cầm SEGA Saturn với hệ điều hành kép (Android & Linux).', 
    'Anbernic RG Arc mang đến sự hoài niệm tuyệt đối với bố cục 6 nút bấm mặt trước, cực kỳ tối ưu cho các tựa game đối kháng và hệ máy SEGA. Máy sử dụng màn hình IPS 4.0 inch sắc nét, hỗ trợ cảm ứng (trên bản D) và khả năng giả lập mượt mà đến các hệ máy PSP, Dreamcast và Nintendo 64.', 
    'CPU: RK3566 Quad-core, RAM: 2GB LPDDR4, Màn hình: 4.0 inch IPS (640x480), Hệ điều hành: Android 11 & Linux.', 
    2890000, 
    3290000, 
    'https://anbernic.com/cdn/shop/files/dde48a7a609347cbd042dbfee136f2a.jpg?v=1766487240&width=800', 
    NOW(), 
    '3500 mAh', -- energy: Dung lượng pin thực tế
    '5 - 6 Hours', -- useTime
    '310g', -- weight
    1, 
    'anbernic-rg-arc-d', 
    0, 
    'SEGA Saturn, Dreamcast, PSP, PS1, NDS giả lập', 
    'Wi-Fi 5G, Bluetooth 4.2, Mini HDMI, USB-C (OTG)', 
    'Bảo hành 6 tháng, Tặng thẻ nhớ 128GB full game và cường lực'
),

-- 25. Anbernic RG477V
(2, 10, 'Anbernic RG477V', 'Máy dọc mạnh nhất hiện nay.', 'Cân tốt PS2 và Wii U với thiết kế cổ điển.', 'Android 13, 8GB RAM', 6789000, 6987000, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-5-600x600.jpg', NOW(), 5500, 8, 334, 1, 'anbernic-rg477v', 1, 'Android', 'WiFi & BT', 'Bảo hành 12 tháng'),

-- 26. Anbernic RG35XXSP
(2, 10, 'Anbernic RG35XXSP', 'Thiết kế nắp gập huyền thoại.', 'Tái hiện GBA SP với màn hình IPS 3.5 inch.', 'IPS 3.5 inch', 1800000, 1990000, 'https://herogame.vn/upload/images/img_02_01_2025/may-retro-game-cam-tay-rg35xxsp-nap-gap-nho-gon-hon-10000-games-anbernic-4_801428_67761b70133425.88983002.jpg', NOW(), 3300, 6, 200, 1, 'anbernic-rg35xxsp', 0, 'Retro Systems', 'WiFi', 'Bảo hành 12 tháng'),

-- 27. Anbernic RG406V
(2, 10, 'Anbernic RG406V', 'Máy dọc chuyên game 3D cũ.', 'Sức mạnh vượt trội, màn hình 4 inch sắc nét.', '256GB Storage', 5000000, 6190000, 'https://haloshop.vn/wp-content/uploads/2025/03/anbernic_retro_game_handheld_rg406v_256gb_42-700x700-1.jpg', NOW(), 4500, 8, 260, 1, 'anbernic-rg406', 0, 'Retro systems', 'WiFi', 'Bảo hành 12 tháng'),

-- 28. Anbernic RG353PS
(2, 10, 'Anbernic RG353PS', 'Thiết kế lấy cảm hứng SNES.', 'Vỏ trong suốt, phím bấm êm ái, chạy Linux.', 'SNES Retro Style', 2200000, 2450000, 'https://haloshop.vn/wp-content/uploads/2025/02/anbernic-retro-game-rg353p-64gb-sd-card-46.jpg', NOW(), 3500, 6, 210, 1, 'anbernic-rg353ps', 0, 'Linux Retro', 'WiFi', 'Bảo hành 12 tháng'),

-- 1. Anbernic RG353P + 64GB Card
(
    2, -- categories_id: Handheld Gaming
    10, -- brand_id: Anbernic
    'Anbernic RG353P + 64GB Micro SD Card', 
    'Thiết kế cổ điển lấy cảm hứng từ tay cầm SNES, hỗ trợ hệ điều hành kép Linux và Android.', 
    'Anbernic RG353P nổi bật với ngoại hình hoài cổ nhưng mang trong mình cấu hình hiện đại. Máy cho phép chuyển đổi linh hoạt giữa Linux (để chơi game ổn định) và Android (để dùng các ứng dụng giải trí), hỗ trợ mượt mà các hệ máy từ NES cho đến PSP, PS1 và N64.', 
    'Màn hình: 3.5 inch IPS Touch, CPU: RK3566, RAM: 2GB LPDDR4, Dual OS (Android 11 + Linux).', 
    3850000, 
    3990000, 
    'https://haloshop.vn/wp-content/uploads/2025/02/Anbernic-Retro-Game-RG353P-_-64GB-Micro-SD-C.jpg', 
    NOW(), 
    '3500 mAh', -- energy
    '5 - 6 Hours', -- useTime
    '422g', -- weight
    1, 
    'anbernic-rg353p', 
    0, 
    'Giả lập NES, SNES, GBA, SEGA, PS1, PSP, N64...', 
    'WiFi 5G, Bluetooth 4.2, HDMI Output', 
    'Tặng kèm thẻ nhớ 64GB full game, Cáp sạc, Dán màn hình'
),

-- 1. Anbernic RG DS
(
    2, -- categories_id: Handheld Gaming
    10, -- brand_id: Anbernic
    'Anbernic RG DS', 
    'Thiết kế hai màn hình độc đáo, tối ưu cho các dòng game giả lập Dual-Screen.', 
    'Anbernic RG DS mang đến trải nghiệm chơi game màn hình đôi hoàn hảo trên nền tảng Android. Bạn có thể dùng màn hình thứ hai để hiển thị menu, bản đồ hoặc điều khiển cảm ứng, giúp việc giả lập các hệ máy hai màn hình trở nên chân thực hơn bao giờ hết.', 
    'Thiết kế Dual-Screen, Chạy Android, Hỗ trợ màn hình cảm ứng dưới.', 
    2990000, 
    3299000, 
    'https://izzygame.com/wp-content/uploads/2025/12/anbernic-rgds-4.jpg', 
    NOW(), 
    '4000 mAh', 
    '5 Hours', 
    '321g', 
    1, 
    'anbernic-rg-ds', 
    0, 
    'Game Android & Giả lập Retro (NDS, 3DS...)', 
    'WiFi & Bluetooth', 
    'Bảo hành 6 tháng, Tặng kèm thẻ nhớ'
);

-- 2. Anbernic RG 476H
(
    2, 
    10, 
    'Anbernic RG 476H', 
    'Máy chơi game Android cấu hình mạnh với màn hình 120Hz siêu mượt.', 
    'Anbernic 476H sở hữu màn hình tỉ lệ 4:3 lý tưởng cho game retro nhưng lại được trang bị tần số quét 120Hz hiện đại. Điều này giúp các tựa game Android và hiệu ứng chuyển cảnh trở nên cực kỳ mượt mà, kết hợp với cấu hình mạnh mẽ để cân tốt các hệ máy 3D.', 
    'Màn hình: 120Hz, Tỉ lệ: 4:3, Chip xử lý hiệu năng cao.', 
    3790000, 
    3990000, 
    'https://izzygame.com/wp-content/uploads/2025/09/anbernic-rg476h-120hz-9-1.jpg', 
    NOW(), 
    '5000 mAh', 
    '6 Hours', 
    '290g', 
    1, 
    'anbernic-rg-476h', 
    0, 
    'Game Android & Giả lập các hệ máy 3D', 
    'WiFi & Bluetooth', 
    'Bảo hành 12 tháng, Tặng dán cường lực'
);




-- 40. Anbernic RG Nano
(
    2, -- categories_id: Handheld Gaming
    10, -- brand_id: Anbernic
    'Anbernic RG Nano', 
    'Máy chơi game Retro nhỏ nhất thế giới với vỏ nhôm CNC cao cấp.', 
    'Kích thước siêu tí hon có thể dùng làm móc khóa nhưng RG Nano vẫn sở hữu vỏ hợp kim bền bỉ và khả năng giả lập mượt mà các hệ máy NES, GBA, PS1. Một món đồ chơi công nghệ đầy cá tính.', 
    'Màn hình: 1.54 inch IPS, Vỏ: Hợp kim nhôm, Pin: 1050mAh.', 
    1290000, 
    1590000, 
    'https://product.hstatic.net/200000272737/product/rgnano_e499535be7784ae7a9d76aa2d01a3d68_master.png', 
    NOW(), 
    '1050 mAh', -- energy
    '2 - 3 Hours', -- useTime
    '75g', -- weight: Siêu nhẹ
    1, 
    'anbernic-rg-nano', 
    0, 
    'Aluminum Shell, Clock function, Music Player', 
    'USB-C (Sạc và dữ liệu)', 
    'Tặng kèm dây đeo móc khóa và cáp sạc USB-C'
);

-- 41. Anbernic RG353M
(
    2, -- categories_id: Handheld Gaming
    10, -- brand_id: Anbernic
    'Anbernic RG353M', 
    'Phiên bản vỏ kim loại sang trọng với hệ điều hành kép Android & Linux.', 
    'RG353M mang lại trải nghiệm cầm nắm cao cấp với vỏ nhôm CNC. Hỗ trợ cảm ứng trên Android và tối ưu giả lập trên Linux, đi kèm cần Analog Hall Effect chống trôi.', 
    'CPU: RK3566, RAM: 2GB LPDDR4, Màn hình: 3.5 inch IPS Touch, Dual OS.', 
    3990000, 
    4490000, 
    'https://anbernic.com/cdn/shop/products/RG353M.jpg?v=1746003726&width=2048', 
    NOW(), 
    '3500 mAh', -- energy
    '5 - 7 Hours', -- useTime
    '232g', -- weight
    1, 
    'anbernic-rg353m-metal', 
    1, 
    'Hall Joystick, Dual OS, HDMI Out', 
    'USB-C, WiFi 5G, Bluetooth 4.2', 
    'Bảo hành 6 tháng, Tặng thẻ nhớ 64GB full game'
);

-- 12. Miyoo (Brand 12)
-- 1. Miyoo Mini Flip
(
    2, -- categories_id: Handheld Gaming
    12, -- brand_id: Miyoo
    'Miyoo Mini Flip', 
    'Thiết kế nắp gập (Clamshell) cổ điển, siêu nhỏ gọn và thời trang.', 
    'Miyoo Mini Flip là một trong những sản phẩm được mong đợi nhất, kết hợp giữa sự nhỏ gọn huyền thoại của dòng Mini và thiết kế nắp gập bảo vệ màn hình. Máy cực kỳ phù hợp để bỏ túi và chơi game retro mọi lúc mọi nơi.', 
    'Thiết kế gập, Màn hình IPS sắc nét, Hỗ trợ giả lập đa hệ máy.', 
    1490000, 
    1680000, 
    'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-1-600x600.jpg', 
    NOW(), 
    '2500 mAh', 
    '4 - 5 Hours', 
    '200g', 
    1, 
    'miyoo-mini-flip', 
    0, 
    'Emulation nhiều hệ Retro (GBA, NES, SNES, PS1...)', 
    'Wi-Fi', 
    'Bảo hành 6 tháng, Tặng thẻ nhớ 64GB'
),

-- 2. Miyoo A30
(
    2, 12, 
    'Miyoo A30', 
    'Thiết kế ngang nhỏ gọn tích hợp Joystick, nâng cấp cấu hình mạnh mẽ.', 
    'Miyoo A30 là thiết bị cầm tay dáng ngang cực kỳ nhỏ gọn nhưng vẫn được bổ sung Joystick để hỗ trợ tốt hơn cho các tựa game 3D nhẹ như PS1 hay N64. Đây là lựa chọn giá rẻ tuyệt vời cho người mới bắt đầu chơi máy Retro.', 
    'Dáng ngang (Horizontal), Tích hợp Joystick, Vỏ nhôm/nhựa cao cấp.', 
    1150000, 
    1780000, 
    'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-5.jpg', 
    NOW(), 
    '2600 mAh', 
    '5 Hours', 
    '270g', 
    1, 
    'miyoo-a30', 
    0, 
    'Nhiều hệ máy Retro (FC, SFC, MD, PS1...)', 
    'Wi-Fi', 
    'Bảo hành 6 tháng'
);

-- 3. Miyoo Mini Plus (Miyoo Handheld)
(
    2, 12, 
    'Miyoo Mini Plus (Miyoo Handheld)', 
    'Máy chơi game Retro quốc dân, hỗ trợ cộng đồng OnionOS cực lớn.', 
    'Miyoo Mini Plus là biểu tượng của dòng máy giả lập nhỏ gọn. Với khả năng cài đặt OnionOS, máy mang lại trải nghiệm sử dụng cực kỳ thông minh, tính năng Game Switcher độc đáo giúp bạn chuyển đổi game chỉ trong tích tắc.', 
    'OS: Linux (Hỗ trợ OnionOS/DotUI), Màn hình: 3.5 inch IPS, Pin: 3000mAh.', 
    1390000, 
    1480000, 
    'https://izzygame.com/wp-content/uploads/2023/04/photo_2023-04-29_21-30-49-600x600.jpg', 
    NOW(), 
    '3000 mAh', 
    '5 - 6 Hours', 
    '170g', 
    1, 
    'miyoo-mini-plus', 
    0, 
    'Hệ Retro (NES → PS1), Hỗ trợ RetroArch', 
    'Wi-Fi', 
    'Bảo hành 6 tháng, Tặng bao chống sốc'
),


-- 13. Retroid (Brand 13)
-- Retroid Pocket G2
(2, 13, 'Retroid Pocket G2', 'Phiên bản nâng cấp mạnh mẽ với khả năng giả lập Android 3D mượt mà.', 'Retroid Pocket G2 là mẫu máy cầm tay thuộc dòng Android handheld, được tối ưu để chơi tốt các tựa game Android hiện đại và giả lập các hệ máy cũ với hiệu suất cao.', 'Hệ điều hành Android, Màn hình sắc nét, Hỗ trợ Google Play.', 6790000, 6980000, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-5.jpg', NOW(), '5000 mAh', '6 Hours', '280g', 1, 'retroid-pocket-g2', 0, 'Android games + Emulation', 'WiFi & Bluetooth', 'Bảo hành 12 tháng');

-- Retroid Pocket Mini V2
(2, 13, 'Retroid Pocket Mini V2', 'Thiết kế tràn viền siêu mỏng, mang lại trải nghiệm thị giác hiện đại.', 'Nâng cấp viền màn hình siêu mỏng giúp tổng thể máy thanh thoát hơn bản V1. Đây là lựa chọn tuyệt vời cho người dùng yêu thích sự nhỏ gọn nhưng vẫn muốn màn hình đẹp.', 'Màn hình tràn viền, Thiết kế công thái học.', 4750000, 4980000, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-1.jpg', NOW(), '4000 mAh', '6 Hours', '215g', 1, 'retroid-pocket-mini-v2', 0, 'Android & Emulator (PS1, N64, PSP/GC...)', 'WiFi & Bluetooth', 'Bảo hành 12 tháng');

-- Retroid Pocket Mini
(2, 13, 'Retroid Pocket Mini', 'Cấu hình mạnh mẽ trong thân hình nhỏ gọn với chip Snapdragon.', 'Pocket Mini sở hữu cấu hình Snapdragon mạnh mẽ nhất trong phân khúc máy nhỏ gọn, phù hợp để mang theo mọi lúc mọi nơi mà không lo về hiệu năng.', 'Chip Snapdragon, Thiết kế nhỏ gọn.', 3990000, 4199000, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-1.jpg', NOW(), '4000 mAh', '6 Hours', '215g', 1, 'retroid-pocket-mini', 0, 'Android & Emulator', 'WiFi & Bluetooth', 'Bảo hành 12 tháng');

-- Retroid Pocket Flip 2
(2, 13, 'Retroid Pocket Flip 2', 'Máy handheld Android nắp gập độc đáo với màn hình OLED.', 'Trang bị màn hình OLED cực đẹp với thiết kế Clamshell (nắp gập) bảo vệ màn hình. Viền màn hình mỏng hơn giúp tối ưu không gian hiển thị.', 'Thiết kế nắp gập, Màn hình OLED.', 4590000, 4890000, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-1.jpg', NOW(), '5000 mAh', '7 Hours', '300g', 1, 'retroid-pocket-flip-2', 1, 'Android & Retro systems', 'WiFi & Bluetooth', 'Bảo hành 12 tháng');

-- Retroid Pocket 2S
(2, 13, 'Retroid Pocket 2S', 'Bản nâng cấp phím bấm và cần Analog Hall Effect đáng giá.', 'Retroid Pocket 2S cải thiện đáng kể về cảm giác bấm và độ bền nhờ cần Analog chống trôi (Hall Effect), phù hợp cho các tựa game yêu cầu độ chính xác cao.', 'Analog Hall Effect, Cấu hình khỏe tầm trung.', 2450000, 2890000, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-4.jpg', NOW(), '4000 mAh', '6 Hours', '200g', 1, 'retroid-pocket-2s', 0, 'Android & Retro games', 'WiFi & Bluetooth', 'Bảo hành 6 tháng');

-- 14. Flydigi (Brand 14)
(3, 14, 'Flydigi Apex 4 Elite', 'Tay cầm màn hình LED.', 'Cò nhấn phản hồi lực (Adaptive Trigger) cực đỉnh.', 'Force Feedback', 2550000, 2850000, 'https://shoptaycam.com/wp-content/uploads/2024/07/bandicam-2025-06-21-17-32-42-547.jpg', NOW(), 1500, 30, 300, 1, 'flydigi-apex-4', 1, 'PC/Switch/Android', '2.4G/BT', 'Bảo hành 12 tháng'),
(3, 14, 'Flydigi Vader 4 Pro', 'Phiên bản cao cấp nhất.', 'Cảm biến Hall Effect, tùy chỉnh lực nhấn.', 'Hall Effect', 1550000, 1850000, 'https://shoptaycam.com/wp-content/uploads/2024/06/Flydigi-Vader-4-Pro-Wireless-Controller.jpg', NOW(), 1000, 20, 250, 1, 'vader-4-pro', 1, 'PC/Switch/Mobile', '2.4G/BT', 'Bảo hành 12 tháng'),
(3, 14, 'Flydigi Nova 3', 'Thiết kế hiện đại.', 'Joystick độ nhạy cao.', 'Joystick High Precision', 890000, 1100000, 'https://shoptaycam.com/wp-content/uploads/2024/11/tay-c%E1%BA%A7m-flydigi-direwolf-3.jpg', NOW(), 800, 15, 240, 1, 'nova-3', 0, 'PC/Android', 'BT/USB', 'Bảo hành 6 tháng'),
 

-- 15. Aokzoe (Brand 15)
(3, 15, 'Aokzoe A1', 'Tay cầm chơi game đa nền tảng.', 'Thiết kế công thái học, hỗ trợ nhiều hệ máy.', 'Multi-platform', 1200000, 1500000, 'https://shoptaycam.com/wp-content/uploads/2024/08/Aokzoe-A1-Wireless-Controller.jpg', NOW(), 1200, 25, 220, 1, 'aokzoe-a1', 0, 'PC/Switch/Android', '2.4G/BT', 'Bảo hành 12 tháng'),



-- 16. Khác (Brand 16)
-- Steam 
-- 1. Steam Deck OLED - 512GB (NVMe SSD)
INSERT INTO products (categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES (
    2, -- categories_id: Handheld Gaming
    4, -- brand_id: Valve
    'Steam Deck OLED - 512GB', 
    'Phiên bản nâng cấp màn hình OLED 90Hz sống động và thời lượng pin vượt trội.', 
    'Steam Deck OLED mang đến trải nghiệm hình ảnh tuyệt đỉnh với màu đen sâu tuyệt đối và hỗ trợ HDR. Với viên pin lớn hơn và tiến trình chip mới, máy hoạt động mát mẻ hơn, cho thời gian chơi game dài hơn so với bản LCD truyền thống.', 
    'Màn hình: 7.4 inch OLED 90Hz HDR, SSD: 512GB NVMe, Wi-Fi 6E nhanh hơn.', 
    17990000, 
    20090000, 
    'https://haloshop.vn/wp-content/uploads/2025/02/steam-deck-64gb-emmc-00-700x700-1.jpg', 
    NOW(), 
    '50 Wh', -- energy: Dung lượng pin nâng cấp của bản OLED
    '3 - 12 Hours', -- useTime: Tùy theo độ nặng của game
    '640g', 
    1, 
    'steam-deck-oled-512gb', 
    1, 
    'SteamOS (Arch-based Linux), Steam Library', 
    'Wi-Fi 6E, Bluetooth 5.3', 
    'Bảo hành 12 tháng, Tặng bao chống sốc chính hãng'
);

-- 2. Steam Deck OLED White Edition - 1TB (Limited Edition)
INSERT INTO products (categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES (
    2, 4, 
    'Steam Deck OLED White Edition - 1TB', 
    'Phiên bản giới hạn Limited Edition màu trắng cực kỳ sang trọng và hiếm có.', 
    'Steam Deck OLED White Edition không chỉ là một cỗ máy chơi game mạnh mẽ mà còn là một món đồ sưu tầm giá trị. Toàn bộ vỏ máy và phụ kiện đi kèm đều mang tông màu trắng tinh tế, đi kèm với cấu hình cao nhất 1TB SSD và màn hình OLED chống lóa.', 
    'Phiên bản giới hạn, SSD: 1TB NVMe, Màn hình OLED chống lóa cao cấp.', 
    18800000, 
    19000000, 
    'https://haloshop.vn/wp-content/uploads/2025/02/steam_deck_oled_1tb_white_edition_00-700x700-1.jpg', 
    NOW(), 
    '50 Wh', 
    '3 - 12 Hours', 
    '640g', 
    1, 
    'steam-deck-oled-white-edition', 
    1, 
    'Steam Library, SteamOS', 
    'Wi-Fi 6E, Bluetooth 5.3', 
    'Bảo hành 12 tháng, Fullbox phiên bản giới hạn màu trắng'
);

-- 3. Valve Steam Deck OLED - 1TB (Standard Black)
INSERT INTO products (categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect, endow)
VALUES (
    2, 4, 
    'Valve Steam Deck OLED - 1TB', 
    'Dung lượng lưu trữ tối đa cho kho game Steam đồ sộ của bạn.', 
    'Với dung lượng 1TB NVMe SSD tốc độ cao, bạn có thể cài đặt hàng loạt tựa game AAA mà không lo về bộ nhớ. Màn hình OLED trên bản 1TB được trang bị lớp phủ chống lóa cao cấp (Premium Anti-glare Etched Glass) giúp chơi tốt trong mọi điều kiện ánh sáng.', 
    'Màn hình: OLED HDR chống lóa, SSD: 1TB NVMe, Pin: 50Wh.', 
    19490000, 
    20790000, 
    'https://bizweb.dktcdn.net/100/476/122/products/316282002-5677069459005263-5496119171875278767-n-1675087036737-1702023014787.jpg?v=1702023019493', 
    NOW(), 
    '50 Wh', 
    '3 - 12 Hours', 
    '640g', 
    1, 
    'steam-deck-oled-1tb', 
    1, 
    'SteamOS, Desktop Mode (Linux), Proton Support', 
    'WiFi 6E, Bluetooth 5.3', 
    'Bảo hành 12 tháng, Tặng bao chống sốc bản đặc biệt 1TB'
);





-- 42. Sega Mega Drive Mini
(
    1, -- categories_id: Home Console
    11, -- brand_id: SEGA
    'Sega Mega Drive Mini', 
    'Phiên bản thu nhỏ của hệ máy 16-bit huyền thoại, cài sẵn 42 tựa game.', 
    'Sống lại kỷ niệm tuổi thơ với Sonic và Contra trên màn hình HD hiện đại. Thiết kế mô phỏng hoàn hảo bản gốc, đi kèm 2 tay cầm cổ điển, cắm là chạy không cần cài đặt.', 
    'Cổng xuất: HDMI 720p, Game: 42 trò cài sẵn, Nguồn: USB 5V.', 
    2190000, 
    2590000, 
    'https://m.media-amazon.com/images/I/71jz2UF7LsS._AC_UF894,1000_QL80_.jpg', 
    NOW(), 
    'USB Power', -- energy
    'Instant Play', -- useTime
    '180g', -- weight: Nhỏ gọn
    1, 
    'sega-mega-drive-mini', 
    0, 
    '42 Pre-loaded Games, Save/Load State', 
    'HDMI, USB (Power/Controller)', 
    'Bảo hành 6 tháng, Tặng bộ nguồn 5V chuyên dụng'
);

-- 43. Atari Flashback X
(
    1, -- categories_id: Home Console
    11, -- brand_id: Atari (Sử dụng ID 11 cho nhóm máy Classic)
    'Atari Flashback X', 
    'Phiên bản thu nhỏ của máy Atari 2600 huyền thoại với 110 trò chơi cài sẵn.', 
    'Atari Flashback X mang thiết kế đặc trưng của thập niên 70 với lớp vỏ giả vân gỗ sang trọng. Máy hỗ trợ xuất hình HDMI 720p sắc nét, cho phép bạn trải nghiệm lại những tựa game kinh điển như Asteroids, Centipede và Missile Command với độ phân giải cao.', 
    'CPU: ARM Cortex, Game: 110 trò cài sẵn, Cổng xuất: HDMI 720p.', 
    1790000, 
    2190000, 
    'https://i.ebayimg.com/images/g/x7UAAOSwTI1jmDPa/s-l400.png', 
    NOW(), 
    'USB Power', -- energy
    'Instant Play', -- useTime
    '170g', -- weight: Cực kỳ nhẹ
    1, 
    'atari-flashback-x', 
    0, 
    '110 Classic Games, Save/Rewind Function', 
    'HDMI, 2x Wired Joystick Ports', 
    'Bảo hành 6 tháng, Tặng kèm 2 tay cầm Joystick nguyên bản'
);

-- 44. Neo Geo Mini International Edition
(
    1, -- categories_id: Home Console
    11, -- brand_id: SNK (Neo Geo)
    'Neo Geo Mini International', 
    'Máy Arcade mini tích hợp màn hình và 40 tựa game đối kháng huyền thoại từ SNK.', 
    'Neo Geo Mini International là một "tủ game thùng" thu nhỏ ngay trên bàn làm việc của bạn. Máy sở hữu màn hình 3.5 inch tích hợp, cần gạt Joystick chất lượng cao và cài sẵn những siêu phẩm đối kháng như King of Fighters, Metal Slug và Samurai Shodown.', 
    'Màn hình: 3.5 inch LCD, Game: 40 trò tích hợp, Cổng: HDMI (xuất TV), Jack 3.5mm.', 
    2490000, 
    2990000, 
    'https://images-na.ssl-images-amazon.com/images/I/71LnMXwSSmL.jpg', 
    NOW(), 
    'USB Power', -- energy
    'Instant Play', -- useTime
    '540g', -- weight: Cầm rất chắc chắn
    1, 
    'neo-geo-mini-international', 
    1, -- Để là 1 vì thiết kế Arcade độc đáo, tính sưu tầm cao
    '40 SNK Classic Games, Stereo Speakers', 
    'HDMI (Mini), USB-C (Power), 2x Controller Ports', 
    'Bảo hành 6 tháng, Tặng kèm cáp sạc và hỗ trợ cài đặt'
);



(2, 11, 'Q8 Retro Handheld ', '10.000 trò chơi retro.', 'Màn hình 3.0 inch, nhỏ gọn dễ mang theo.', '10.000+ Games', 550000, 750000, 'https://i.ebayimg.com/images/g/cYwAAOSw-EBmzXja/s-l1200.jpg', NOW(), 1500, 5, 150, 1, 'mini-q8', 0, 'Retro games', 'USB', 'Bảo hành 3 tháng'),
(2, 11, 'GKD Pixel X2', 'Phong cách Pixel hoài cổ.', 'Tích hợp hơn 8.000 trò chơi cổ điển.', '8.000+ Games', 450000, 600000, 'https://i.ytimg.com/vi/X1OAPuLEnAU/maxresdefault.jpg', NOW(), 1200, 4, 130, 1, 'pixel-x2', 0, 'Retro games', 'USB', 'Bảo hành 3 tháng'),

(3, 15, 'Razer Wolverine V2 Chroma', 'Tay cầm Gaming cơ học RGB.', 'Nút bấm Mecha-Tactile và hệ thống LED Chroma.', '6 Nút đa năng', 3600000, 3990000, 'https://bizweb.dktcdn.net/thumb/grande/100/329/122/products/tay-cam-choi-game-razer-wolverine-v2-chroma-6.jpg?v=1716652873040', NOW(), 0, 0, 270, 1, 'razer-wolverine-v2', 1, 'Xbox/PC', 'Có dây', 'Bảo hành 24 tháng'),
(3, 16, 'Acer Nitro NGR300', 'Tay cầm Nitro chuyên game.', 'Thiết kế bền bỉ, độ trễ cực thấp cho game thủ.', 'Dual Vibration', 750000, 950000, 'https://cohotech.vn/wp-content/uploads/2025/04/Acer-Nitro-NGR300-1.jpg', NOW(), 600, 10, 230, 1, 'acer-nitro-ngr300', 0, 'PC/Android', 'USB/BT', 'Bảo hành 6 tháng'),
(2, 8, 'Ayaneo Pocket Micro', 'Thân máy siêu nhỏ.', 'Vỏ kim loại sang trọng, màn hình sắc nét.', 'Micro Handheld', 12500000, 13500000, 'https://weirdstore.vn/wp-content/uploads/2024/09/AYANEO-POCKET-MICRO-SOUL-RED-DONE-01.png', NOW(), 2600, 4, 220, 1, 'ayaneo-pocket-micro', 0, 'Android', 'WiFi', 'Bảo hành 12 tháng'),





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
(19, 'https://weirdstore.vn/wp-content/uploads/2024/11/Untitled-2-1.jpg'),
(19, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlgO0nX3kJp-WGOGyfNFXD0B9zeV6ouDpE6g&s'),
(19, 'https://gameline.ph/cdn/shop/files/Layer26_500x_487bb3e0-c112-4723-a358-a600cfe99f72_500x500.png?v=1746670095'),
==================================================

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

