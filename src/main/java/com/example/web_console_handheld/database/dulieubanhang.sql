CREATE DATABASE dulieubanhang
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE dulieubanhang;

CREATE TABLE logo (
                      ID INT PRIMARY KEY,
                      titleLogo VARCHAR(255),
                      linkLogo VARCHAR(255)
);

CREATE TABLE icon (
                      ID INT PRIMARY KEY,
                      title VARCHAR(255),
                      link_icon VARCHAR(255),
                      active BOOLEAN
);

CREATE TABLE contact (
                         ID INT PRIMARY KEY,
                         gmail VARCHAR(255),
                         phone VARCHAR(50),
                         address VARCHAR(255)
);

CREATE TABLE banner (
                        ID INT AUTO_INCREMENT PRIMARY KEY,
                        title VARCHAR(255),
                        link VARCHAR(255),
                        active BOOLEAN
);

CREATE TABLE blog (
                      ID INT PRIMARY KEY,
                      img VARCHAR(255),
                      title VARCHAR(255),
                      metatitle VARCHAR(255),
                      description VARCHAR(255),
                      active BOOLEAN,
                      playorder INT
);

CREATE TABLE users (
                       ID INT PRIMARY KEY,
                       username VARCHAR(100),
                       password VARCHAR(255),
                       email VARCHAR(255),
                       fullname VARCHAR(255),
                       avatar VARCHAR(255),
                       date_of_birth DATE,
                       phoneNum VARCHAR(50),
                       location VARCHAR(255),
                       created_at DATETIME,
                       updated_at DATETIME,
                       lastLogin DATETIME,
                       active BOOLEAN
);

CREATE TABLE categories (
                            ID INT PRIMARY KEY,
                            name VARCHAR(255),
                            description VARCHAR(255),
                            imgLink varchar(255),
                            active BOOLEAN
);



CREATE TABLE brands (
                        ID INT PRIMARY KEY,
                        brand_name VARCHAR(255),
                        active BOOLEAN,
                        CreatedAt DATETIME
);

CREATE TABLE products (
                          ID INT PRIMARY KEY,
                          categories_id INT,
                          brand_id INT,
                          name VARCHAR(255),
                          short_description VARCHAR(255),
                          full_description TEXT,
                          information TEXT,
                          price DECIMAL(18,2),
                          priceOld DECIMAL(18,2),
                          image VARCHAR(255),
                          createdAt DATETIME,
                          energy INT,
                          useTime INT,
                          weight INT,
                          active BOOLEAN,
                          metatitle VARCHAR(255),
                          ispremium BOOLEAN,
                          suports VARCHAR(255),
                          connect VARCHAR(255),
                          FOREIGN KEY (categories_id) REFERENCES categories(ID),
                          FOREIGN KEY (brand_id) REFERENCES brands(ID)
);


CREATE TABLE endow (
                       ID INT PRIMARY KEY,
                       content VARCHAR(255),
                       status BOOLEAN,
                       productID INT,
                       FOREIGN KEY (productID) REFERENCES products(ID)
);

CREATE TABLE video (
                       ID INT PRIMARY KEY,
                       active BOOLEAN,
                       title VARCHAR(255)
);

CREATE TABLE discount (
                          ID INT PRIMARY KEY,
                          discountcode VARCHAR(50),
                          discointname VARCHAR(255),
                          discountvalue FLOAT,
                          startdate DATETIME,
                          enddate DATETIME,
                          status BOOLEAN,
                          createat DATETIME,
                          updateat DATETIME,
                          minordervalue FLOAT,
                          maxdiscount FLOAT,
                          quantity INT
);

CREATE TABLE orders (
                        ID INT PRIMARY KEY,
                        user_id INT,
                        order_date DATETIME,
                        ghichu VARCHAR(255),
                        product_id INT,
                        quantity INT,
                        price DECIMAL(18,2),
                        thanhtien DECIMAL(18,2),
                        FOREIGN KEY (user_id) REFERENCES users(ID),
                        FOREIGN KEY (product_id) REFERENCES products(ID)
);

CREATE TABLE payments (
                          ID INT PRIMARY KEY,
                          orders_id INT,
                          payment_method VARCHAR(100),
                          payment_status VARCHAR(100),
                          FOREIGN KEY (orders_id) REFERENCES orders(ID)
);

CREATE TABLE reviews (
                         ID int PRIMARY KEY AUTO_INCREMENT,
                         products_id INT,
                         users_id INT,
                         rating INT,
                         review_text VARCHAR(255),
                         imgReviews VARCHAR(255),
                         reviewDate DATETIME,
                         status boolean,
                         FOREIGN KEY (products_id) REFERENCES products(ID),
                         FOREIGN KEY (users_id) REFERENCES users(ID)
);

CREATE TABLE bill (
                      ID INT PRIMARY KEY,
                      payments_id INT,
                      bill_create DATETIME,
                      FOREIGN KEY (payments_id) REFERENCES payments(ID)
);

CREATE TABLE history (
                         ID INT PRIMARY KEY,
                         user_id INT,
                         bill_id INT,
                         order_date DATETIME,
                         status VARCHAR(100),
                         total_amount DECIMAL(18,2),
                         FOREIGN KEY (user_id) REFERENCES users(ID),
                         FOREIGN KEY (bill_id) REFERENCES bill(ID)
);
-- thêm bảng cho trang giới thiệu (about) 27/12/2025
CREATE TABLE about (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       section VARCHAR(50),
                       title VARCHAR(255),
                       description TEXT,
                       image VARCHAR(255),
                       icon VARCHAR(100),
                       sort_order INT
);
-- them bang gallary cho product
create table gallary(
                        ID int PRIMARY KEY AUTO_INCREMENT,
                        product_id int,
                        metatitle varchar(255),
                        img varchar(255)
);
-- insert test 23/1
insert into orders () values
    (null, 14, NOW(), 'PENDING', 9300000, 'kiemcuongtim', '0938938474', 'Đại Học Nông Lâm TPHCM', 'kiemcuongtim@gmail.com', 1);

-- them bang 23/1
CREATE TABLE order_items (
                             id INT AUTO_INCREMENT PRIMARY KEY,

                             order_id INT NOT NULL,
                             product_id INT NOT NULL,

                             product_name VARCHAR(255) NOT NULL,
                             product_price BIGINT NOT NULL,
                             quantity INT NOT NULL,

                             FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 19/1 (emdatdepzai)
INSERT INTO products VALUES (NULL,1,1,'PlayStation 5 Slim Digital','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','PlayStation 5 Slim Digital mang thiết kế gọn nhẹ.Hiệu năng thế hệ mới.Chạy game mượt mà.Hỗ trợ 4K HDR.Trải nghiệm ổn định lâu dài.','CPU AMD Ryzen Zen 2, GPU RDNA 2',12490000,13490000,'https://bizweb.dktcdn.net/thumb/1024x1024/100/202/418/products/ps5-slim-digital-01-257c29ed-c2d1-4f84-863b-b1b2af8d87c9.jpg',NOW(),450,3,4200,1,'playstation-5-slim-digital',0,'Tay cầm DualSense,Cáp HDMI,Củ nguồn','HDMI,USB-C,USB-A,LAN','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,1,'PlayStation 5 Slim Disc','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','PS5 Slim Disc hỗ trợ ổ đĩa vật lý.Thiết kế mới gọn gàng.Hiệu năng mạnh mẽ.Tương thích game PS4.Trải nghiệm mượt.','CPU AMD Ryzen Zen 2, GPU RDNA 2',13990000,14990000,'https://images-na.ssl-images-amazon.com/images/I/51nHxiiZo+L.jpg',NOW(),450,5,4300,1,'playstation-5-slim-disc',0,'Tay cầm DualSense,Cáp HDMI,Củ nguồn','HDMI,USB-C,USB-A,LAN','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,2,'Xbox Series X Carbon Black','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Xbox Series X hiệu năng cao nhất dòng Xbox.Hỗ trợ 4K 120FPS.Tối ưu Game Pass.Load game nhanh.Thiết kế tối giản.','CPU AMD Zen 2, GPU RDNA 2',13990000,14990000,'https://product.hstatic.net/1000289578/product/tay_xbox_series_x_s__carbon_black_ban_tai_xgame_1ca466657ab244bc8c600edbae09ef7b_master.jpg',NOW(),500,4,4450,1,'xbox-series-x-carbon',0,'Tay cầm Xbox,Cáp HDMI,Củ nguồn','HDMI,USB-A,LAN','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,2,'Xbox Series S 1TB Black','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Xbox Series S bản 1TB dung lượng lớn.Thiết kế nhỏ gọn.Chạy game next-gen mượt.Giá hợp lý.Phù hợp không gian nhỏ.','CPU AMD Zen 2, GPU RDNA 2',8990000,9990000,'https://product.hstatic.net/1000154920/product/xbox_one_series_s_1tb_box_bf42677b4ed84b35a4b0865486da6287_master.png',NOW(),420,5,1950,1,'xbox-series-s-1tb',0,'Tay cầm Xbox,Cáp HDMI','HDMI,USB-A,LAN','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,3,'Nintendo Switch V2 Neon','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Nintendo Switch V2 cải thiện pin.Chơi linh hoạt TV và handheld.Game độc quyền Nintendo.Thiết kế Joy-Con Neon.Bền bỉ.','CPU NVIDIA Tegra, GPU Maxwell',6890000,7890000,'https://www.droidshop.vn/wp-content/uploads/2023/01/May-choi-game-Nintendo-Switch-Neon.jpg',NOW(),431,7,420,1,'nintendo-switch-v2',0,'Joy-Con,Dock,Cáp HDMI','USB-C,HDMI,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,3,'Nintendo Switch Animal Crossing Edition','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Nintendo Switch bản giới hạn Animal Crossing.Thiết kế màu pastel đẹp mắt.Pin tốt.Game gia đình vui nhộn.Phù hợp sưu tầm.','CPU NVIDIA Tegra, GPU Maxwell',7590000,8590000,'https://bizweb.dktcdn.net/100/088/342/products/3a4ccf1ab2321de3d47ad8e1fe1921ad.jpg?v=1584256452237',NOW(),431,7,420,1,'nintendo-switch-animal-crossing',0,'Joy-Con,Dock,Cáp HDMI','USB-C,HDMI,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,4,'Steam Deck OLED 512GB','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Steam Deck OLED 512GB cho màu sắc sống động.Chơi game PC mượt.Hỗ trợ SteamOS.Pin cải thiện.Dễ mang theo.','CPU AMD Zen 2, GPU RDNA 2',16990000,17990000,'https://www.droidshop.vn/wp-content/uploads/2021/07/Valve-Steam-Deck.jpg',NOW(),500,7,640,1,'steam-deck-oled-512',0,'Cáp USB-C,Củ sạc','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,5,'ASUS ROG Ally X','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','ROG Ally X nâng cấp pin và RAM.Chạy Windows.Màn hình 120Hz.Hiệu năng cao.Thiết kế gaming mạnh mẽ.','CPU AMD Ryzen Z1 Extreme, GPU RDNA 3',19990000,20990000,'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/g/r/group_551_8_.png',NOW(),500,7,678,1,'asus-rog-ally-x',0,'Cáp USB-C,Củ sạc 65W','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,5,'ASUS ROG Ally White','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','ROG Ally màu trắng.Chạy Windows.Chơi game AAA tốt.Màn hình mượt.Thiết kế hiện đại.','CPU AMD Ryzen Z1, GPU RDNA 3',13990000,14990000,'https://product.hstatic.net/1000288298/product/may-choi-game-asus-rog-ally-1_125baf73b5504f00b47cf6c7c6b5a9ba.png',NOW(),400,6,608,1,'asus-rog-ally-white',0,'Cáp USB-C,Củ sạc','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,6,'MSI Claw Ultra 7','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','MSI Claw Ultra 7 dùng chip Intel mới.Màn hình lớn.Hiệu năng cao.Tản nhiệt tốt.Thiết kế chắc tay.','CPU Intel Core Ultra 7, GPU Intel Arc',18990000,19990000,'https://cdn.tgdd.vn/Products/Images/12918/329815/may-choi-game-cam-tay-msi-claw-a1m-049vn-core-ultra-7-155h-16gb-512gb-120hz-win11-12-600x600.jpg',NOW(),550,6,680,1,'msi-claw-ultra-7',0,'Cáp USB-C,Củ sạc','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,6,'MSI Claw Ultra 5','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','MSI Claw Ultra 5 giá dễ tiếp cận.Hiệu năng ổn định.Chạy Windows mượt.Pin tốt.Thiết kế cứng cáp.','CPU Intel Core Ultra 5, GPU Intel Arc',15990000,16990000,'https://m.media-amazon.com/images/I/71788CmL7GL.jpg',NOW(),520,6,670,1,'msi-claw-ultra-5',0,'Cáp USB-C,Củ sạc','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,7,'Lenovo Legion Go Standard','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Lenovo Legion Go màn hình QHD lớn.Joy-Con tháo rời.Chạy Windows.Hiệu năng mạnh.Trải nghiệm mới.','CPU AMD Ryzen Z1 Extreme, GPU RDNA 3',17990000,18990000,'https://www.droidshop.vn/wp-content/uploads/2023/11/May-choi-game-Lenovo-Legion-Go-8.8-AMD-Ryzen-Z1-Extreme-16GB-512GB-2.jpg',NOW(),600,7,854,1,'lenovo-legion-go-standard',0,'Dock,Cáp USB-C','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,8,'AYANEO Geek 1S','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','AYANEO Geek 1S nhỏ gọn.Hiệu năng cao.Chạy Windows.Màn hình đẹp.Pin ổn định.','CPU AMD Ryzen 7 7840U, GPU RDNA 3',18990000,19990000,'https://weirdstore.vn/wp-content/uploads/2024/03/n-2.png',NOW(),480,6,640,1,'ayaneo-geek-1s',0,'Cáp USB-C,Củ sạc','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,8,'AYANEO Slide','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','AYANEO Slide thiết kế trượt độc đáo.Bàn phím ẩn.Hiệu năng mạnh.Chạy Windows.Gọn nhẹ.','CPU AMD Ryzen 7, GPU RDNA 2',19990000,20990000,'https://weirdstore.vn/wp-content/uploads/2024/03/n-3.jpg',NOW(),470,6,690,1,'ayaneo-slide',0,'Cáp USB-C,Củ sạc','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,9,'GPD Win Max 2023','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','GPD Win Max 2023 dạng laptop mini.Bàn phím vật lý.Hiệu năng cao.Đa nhiệm tốt.Màn hình lớn.','CPU AMD Ryzen 7, GPU RDNA 3',22990000,23990000,'https://product.hstatic.net/1000203080/product/gpd-win-max-2-1_e92487e58b4d485580a445bab6cf85e6_master.jpg',NOW(),650,7,1000,1,'gpd-win-max-2023',0,'Cáp USB-C,Củ sạc','USB-C,HDMI,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,9,'GPD Win 2 8100Y','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','GPD Win 2 thiết kế vỏ sò cổ điển.Gọn nhẹ.Chạy Windows.Đủ dùng game nhẹ.Phù hợp sưu tầm.','CPU Intel Core m3, GPU UHD',8990000,9990000,'https://product.hstatic.net/1000203080/product/mua-may-choi-game-cam-tay-gpd-win-2-gia-re.jpg',NOW(),410,5,460,1,'gpd-win-2',0,'Cáp sạc','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,10,'Anbernic RG35XX Plus','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Anbernic RG35XX Plus giả lập retro tốt.Pin bền.Thiết kế cổ điển.Giá rẻ.Dễ sử dụng.','CPU ARM Cortex-A53, GPU Mali',1690000,1990000,'https://vhost53003.vhostcdn.com/wp-content/uploads/2025/04/RG35XX-Plus-4.jpg',NOW(),260,5,165,1,'anbernic-rg35xx-plus',0,'Cáp sạc,Thẻ nhớ','USB-C','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,10,'Anbernic RG Arc','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Anbernic RG Arc thiết kế tay cầm Sega.Giả lập mượt.Màn hình đẹp.Pin ổn định.Trải nghiệm retro.','CPU RK3566, GPU Mali',2890000,3290000,'https://anbernic.com/cdn/shop/files/dde48a7a609347cbd042dbfee136f2a.jpg?v=1766487240&width=800',NOW(),350,5,310,1,'anbernic-rg-arc',0,'Cáp sạc,Thẻ nhớ','USB-C,WiFi','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,11,'PlayStation Portable PSP 3000','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','PSP 3000 là máy chơi game cầm tay huyền thoại.Màn hình sáng.Pin ổn định.Kho game phong phú.Dễ hack cài game.','CPU MIPS R4000, GPU PSP',2490000,2990000,'https://product.hstatic.net/1000289578/product/may_psp_3000_mau_den-xgame_9481630d7ae44ec7aaf9437fe4556caf.jpg',NOW(),180,4,189,1,'psp-3000',0,'Cáp sạc,Tai nghe','USB,WiFi','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,11,'PlayStation Vita Slim','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','PS Vita Slim nhẹ hơn.Pin tốt hơn.OLED sắc nét.Game độc quyền hấp dẫn.Phù hợp sưu tầm.','CPU ARM Cortex-A9, GPU PowerVR',3590000,4090000,'https://i5.walmartimages.com/seo/Authentic-PlayStation-Ps-Vita-2000-Slim-Console-WiFi-Silver_d54a0ca5-138a-49ae-a5e0-19a04075f897.d5ff0e15b41d4231ac99debca7e622ab.jpeg',NOW(),220,5,219,1,'ps-vita-slim',0,'Cáp sạc,Tai nghe','USB,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,2,'Xbox One S All Digital','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Xbox One S All Digital không ổ đĩa.Tối ưu game digital.Thiết kế gọn.Chạy ổn định.Phù hợp giải trí.','CPU AMD Jaguar, GPU Polaris',5490000,6490000,'https://m.media-amazon.com/images/I/813lBsn0qkL._AC_UF894,1000_QL80_.jpg',NOW(),420,3,2900,1,'xbox-one-s-digital',0,'Tay cầm Xbox,Cáp HDMI','HDMI,USB-A,LAN','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,1,'PlayStation Classic Mini','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','PlayStation Classic Mini giả lập PS1.Thiết kế hoài cổ.Cài sẵn game kinh điển.Dễ mod.Nhỏ gọn.','CPU ARM Cortex-A35, GPU Mali',1990000,2490000,'https://m.media-amazon.com/images/I/61bvBCSda0L._SL400_.jpg',NOW(),200,2,170,1,'playstation-classic-mini',0,'2 tay cầm,Cáp HDMI','HDMI,USB','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,3,'Nintendo NES Classic','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','NES Classic mang game 8-bit huyền thoại.Thiết kế mini.Hoài cổ.Dễ chơi.Phù hợp sưu tầm.','CPU ARM Cortex-A7, GPU Mali',1790000,2190000,'https://m.media-amazon.com/images/I/61zSsTAtFfL._SL1000_.jpg',NOW(),180,4,160,1,'nes-classic',0,'Tay cầm NES,Cáp HDMI','HDMI,USB','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,3,'Nintendo SNES Classic','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','SNES Classic giả lập game 16-bit.Hình ảnh đẹp hơn NES.Thiết kế mini.Cài sẵn game hay.','CPU ARM Cortex-A7, GPU Mali',1990000,2390000,'https://i5.walmartimages.com/seo/Nintendo-Universal-Super-NES-Classic-Edition_3ce7cb3c-fb58-42f0-beb6-0f17b2d7c050_1.2df765ec5df4cf5cf3031b24e2e1d8c5.jpeg',NOW(),190,3,170,1,'snes-classic',0,'2 tay cầm,Cáp HDMI','HDMI,USB','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,4,'Steam Deck Refurbished','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Steam Deck Refurb giá tốt.Chơi game PC ổn.Hệ SteamOS.Màn hình lớn.Phù hợp tiết kiệm.','CPU AMD Zen 2, GPU RDNA 2',9990000,10990000,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQac29NMQX4uP7h0t8tEtUpM7b2nC0JZ8uIng&s',NOW(),400,6,669,1,'steam-deck-refurb',0,'Cáp sạc','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,5,'ASUS TUF Gaming Handheld','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','ASUS TUF handheld thiết kế bền bỉ.Chạy Windows.Hiệu năng ổn.Pin khá.Trải nghiệm gaming tốt.','CPU AMD Ryzen Z1, GPU RDNA 3',15990000,16990000,'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog-ally-x.jpg',NOW(),480,6,700,1,'asus-tuf-handheld',0,'Cáp USB-C,Củ sạc','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,6,'MSI Claw Lite','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','MSI Claw Lite nhẹ hơn.Giá dễ tiếp cận.Chạy Windows.Màn hình mượt.Phù hợp phổ thông.','CPU Intel Core Ultra 5, GPU Intel Arc',13990000,14990000,'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-1-678x800.jpg',NOW(),500,6,650,1,'msi-claw-lite',0,'Cáp USB-C,Củ sạc','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,7,'Lenovo Legion Play','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Lenovo Legion Play chạy Android.Thiết kế gaming.Chơi cloud gaming tốt.Pin ổn.Màn hình lớn.','CPU Snapdragon 720G, GPU Adreno',8990000,9990000,'https://i.ytimg.com/vi/Gx3mROmcYNk/maxresdefault.jpg',NOW(),500,7,730,1,'lenovo-legion-play',0,'Cáp sạc,Tai nghe','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,8,'AYANEO Air','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','AYANEO Air siêu mỏng nhẹ.Màn OLED đẹp.Chạy Windows.Pin ổn.Thiết kế cao cấp.','CPU AMD Ryzen 5, GPU RDNA 2',15990000,16990000,'https://weirdstore.vn/wp-content/uploads/2024/03/csm_Untitled_1_f1e5aafca1.jpg',NOW(),400,6,560,1,'ayaneo-air',0,'Cáp USB-C,Củ sạc','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,9,'GPD XP Plus','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','GPD XP Plus chạy Android.Module tay cầm rời.Cloud gaming tốt.Giả lập ổn.Pin bền.','CPU Dimensity 1200, GPU Mali',9990000,10990000,'https://minhhightech.com/admin/sanpham/GPD-XP-Plus-_28_6107.jpg',NOW(),500,7,331,1,'gpd-xp-plus',0,'Cáp sạc,Tay cầm module','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,10,'Anbernic RG Nano','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Anbernic RG Nano siêu nhỏ gọn.Giả lập cơ bản.Móc khoá tiện lợi.Pin đủ dùng.Phù hợp sưu tầm.','CPU ARM Cortex-A7, GPU Mali',1290000,1590000,'https://product.hstatic.net/200000272737/product/rgnano_e499535be7784ae7a9d76aa2d01a3d68_master.png',NOW(),200,3,75,1,'anbernic-rg-nano',0,'Cáp sạc','USB-C','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,10,'Anbernic RG353M','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Anbernic RG353M vỏ kim loại.Android + Linux.Giả lập mượt.Pin bền.Thiết kế cao cấp.','CPU RK3566, GPU Mali',3990000,4490000,'https://anbernic.com/cdn/shop/products/RG353M.jpg?v=1746003726&width=2048',NOW(),420,6,320,1,'anbernic-rg353m',0,'Cáp sạc,Thẻ nhớ','USB-C,WiFi,Bluetooth','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,11,'Sega Mega Drive Mini','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Sega Mega Drive Mini giả lập game Sega cổ.Thiết kế hoài niệm.Cài sẵn game kinh điển.Dễ sử dụng.','CPU ARM Cortex-A7, GPU Mali',2190000,2590000,'https://m.media-amazon.com/images/I/71jz2UF7LsS._AC_UF894,1000_QL80_.jpg',NOW(),190,4,180,1,'sega-mega-drive-mini',0,'2 tay cầm,Cáp HDMI','HDMI,USB','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (NULL,1,11,'Atari Flashback X','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Atari Flashback X giả lập game Atari cổ.Cắm là chơi.Thiết kế retro.Phù hợp sưu tầm.','CPU ARM Cortex, GPU Mali',1790000,2190000,'https://i.ebayimg.com/images/g/x7UAAOSwTI1jmDPa/s-l400.png',NOW(),180,5,170,1,'atari-flashback-x',0,'2 tay cầm,Cáp HDMI','HDMI,USB','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');
INSERT INTO products VALUES (17,1,11,'Neo Geo Mini International','là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.<b>Cảm biến Hall Effect chống drift</b><b>Khoá Trigger đa chế độ</b><b>Kết nối 3 chế độ</b><b>Tương thích PC / Android / iOS</b>','Neo Geo Mini International là console mini hoài cổ.Thiết kế dạng tủ arcade nhỏ gọn.Màn hình tích hợp.Cài sẵn nhiều game kinh điển.Dễ chơi và sưu tầm.','CPU ARM Cortex, GPU Mali, Game Neo Geo tích hợp',2490000,2990000,'https://images-na.ssl-images-amazon.com/images/I/71LnMXwSSmL.jpg',NOW(),250,3,540,1,'neo-geo-mini-international',0,'Tay cầm Neo Geo,Cáp HDMI,Cáp nguồn','HDMI,USB','Bảo hành 6 tháng Tặng dây cáp USB-C Miễn phí giao hàng toàn quốc');



-- 18/1 (emdatdepzai)
INSERT INTO reviews VALUES
                        (null, 1, 1, 5, 'Rất tốt', '/review/r1.png', NOW(), 1),
                        (null, 1, 1, 5, 'Rất tốt', '/review/r1.png', NOW(), 1),
                        (null, 1, 1, 5, 'Rất tốt', '/review/r1.png', NOW(), 1),
                        (null, 1, 1, 4, 'Rất ok', '/review/r1.png', NOW(), 1),
                        (null, 1, 1, 1, 'Rat te', '/review/r1.png', NOW(), 1);


insert into gallary VALUES(null, 1, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/a/tay-cam-choi-game-ps5-dualsense-1.png'),
                          (null, 1, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/a/tay-cam-choi-game-ps5-dualsense-1.png'),
                          (null, 1, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/a/tay-cam-choi-game-ps5-dualsense-1.png'),

                          (null, 2, 'https://nvs.tn-cdn.net/2021/01/Tay-cam-choi-game-Xbox-Series-X-Controller-den-1-1.jpg'),
                          (null, 2, 'https://nvs.tn-cdn.net/2021/01/Tay-cam-choi-game-Xbox-Series-X-Controller-den-1-1.jpg'),
                          (null, 2, 'https://nvs.tn-cdn.net/2021/01/Tay-cam-choi-game-Xbox-Series-X-Controller-den-1-1.jpg'),

                          (null, 3,  'https://www.droidshop.vn/wp-content/uploads/2025/09/tay-cam-Nintendo-Switch-Pro-Controller-Super-Smash-Bros.jpg'),
                          (null, 3,  'https://www.droidshop.vn/wp-content/uploads/2025/09/tay-cam-Nintendo-Switch-Pro-Controller-Super-Smash-Bros.jpg'),
                          (null, 3,  'https://www.droidshop.vn/wp-content/uploads/2025/09/tay-cam-Nintendo-Switch-Pro-Controller-Super-Smash-Bros.jpg'),

                          (null, 4,  'https://bizweb.dktcdn.net/thumb/large/100/445/365/products/sg-11134201-22120-27d835cgiykvaf-1672731786694.jpg?v=1672731803223'),
                          (null, 4,  'https://bizweb.dktcdn.net/thumb/large/100/445/365/products/sg-11134201-22120-27d835cgiykvaf-1672731786694.jpg?v=1672731803223'),
                          (null, 4,  'https://bizweb.dktcdn.net/thumb/large/100/445/365/products/sg-11134201-22120-27d835cgiykvaf-1672731786694.jpg?v=1672731803223'),

                          (null, 5,  'https://bizweb.dktcdn.net/thumb/grande/100/329/122/products/tay-cam-choi-game-razer-wolverine-v2-chroma-6.jpg?v=1716652873040'),
                          (null, 5,  'https://bizweb.dktcdn.net/thumb/grande/100/329/122/products/tay-cam-choi-game-razer-wolverine-v2-chroma-6.jpg?v=1716652873040'),
                          (null, 5,  'https://bizweb.dktcdn.net/thumb/grande/100/329/122/products/tay-cam-choi-game-razer-wolverine-v2-chroma-6.jpg?v=1716652873040'),

                          (null, 6,  'https://shoptaycam.com/wp-content/uploads/2024/06/Flydigi-Vader-4-Pro-Wireless-Controller.jpg'),
                          (null, 6,  'https://shoptaycam.com/wp-content/uploads/2024/06/Flydigi-Vader-4-Pro-Wireless-Controller.jpg'),
                          (null, 6,  'https://shoptaycam.com/wp-content/uploads/2024/06/Flydigi-Vader-4-Pro-Wireless-Controller.jpg'),

                          (null, 7, 'https://shoptaycam.com/wp-content/uploads/2024/11/tay-c%E1%BA%A7m-flydigi-direwolf-3.jpg'),
                          (null, 7, 'https://shoptaycam.com/wp-content/uploads/2024/11/tay-c%E1%BA%A7m-flydigi-direwolf-3.jpg'),
                          (null, 7, 'https://shoptaycam.com/wp-content/uploads/2024/11/tay-c%E1%BA%A7m-flydigi-direwolf-3.jpg'),

                          (null, 8,  'https://shoptaycam.com/wp-content/uploads/2024/07/bandicam-2025-06-21-17-32-42-547.jpg'),
                          (null, 8,  'https://shoptaycam.com/wp-content/uploads/2024/07/bandicam-2025-06-21-17-32-42-547.jpg'),
                          (null, 8,  'https://shoptaycam.com/wp-content/uploads/2024/07/bandicam-2025-06-21-17-32-42-547.jpg'),

                          (null, 9,  'https://masta.vn/wp-content/uploads/2024/12/tay-cam-flydigi-apex-4-elite-controller-masta-5.jpg'),
                          (null, 9,  'https://masta.vn/wp-content/uploads/2024/12/tay-cam-flydigi-apex-4-elite-controller-masta-5.jpg'),
                          (null, 9,  'https://masta.vn/wp-content/uploads/2024/12/tay-cam-flydigi-apex-4-elite-controller-masta-5.jpg'),

                          (null, 10,'https://product.hstatic.net/200000272737/product/retro_mini_ver2_fbadace7882574321a62e148776d01c38_master.jpg'),
                          (null, 10,'https://product.hstatic.net/200000272737/product/retro_mini_ver2_fbadace7882574321a62e148776d01c38_master.jpg'),
                          (null, 10,'https://product.hstatic.net/200000272737/product/retro_mini_ver2_fbadace7882574321a62e148776d01c38_master.jpg'),

                          (null, 11, 'https://izzystore.com/wp-content/uploads/2025/03/gkd-pixel-2-kim-loai-cao-cap-2-300x300.jpg'),
                          (null, 11, 'https://izzystore.com/wp-content/uploads/2025/03/gkd-pixel-2-kim-loai-cao-cap-2-300x300.jpg'),
                          (null, 11, 'https://izzystore.com/wp-content/uploads/2025/03/gkd-pixel-2-kim-loai-cao-cap-2-300x300.jpg'),

                          (null, 12, 'https://vhost53003.vhostcdn.com/wp-content/uploads/2025/05/g5_retro_1.jpg'),
                          (null, 12, 'https://vhost53003.vhostcdn.com/wp-content/uploads/2025/05/g5_retro_1.jpg'),
                          (null, 12, 'https://vhost53003.vhostcdn.com/wp-content/uploads/2025/05/g5_retro_1.jpg'),

                          (null, 13, 'https://cohotech.vn/wp-content/uploads/2025/04/Acer-Nitro-NGR300-1.jpg'),
                          (null, 13, 'https://cohotech.vn/wp-content/uploads/2025/04/Acer-Nitro-NGR300-1.jpg'),
                          (null, 13, 'https://cohotech.vn/wp-content/uploads/2025/04/Acer-Nitro-NGR300-1.jpg'),

                          (null, 14, 'https://shoptaycam.com/wp-content/uploads/2025/06/bandicam-2025-06-27-19-46-47-772.jpg'),
                          (null, 14, 'https://shoptaycam.com/wp-content/uploads/2025/06/bandicam-2025-06-27-19-46-47-772.jpg'),
                          (null, 14, 'https://shoptaycam.com/wp-content/uploads/2025/06/bandicam-2025-06-27-19-46-47-772.jpg'),

                          (null, 15, 'https://shoptaycam.com/wp-content/uploads/2025/09/bandicam-2025-12-11-17-26-18-713.jpg'),
                          (null, 15, 'https://shoptaycam.com/wp-content/uploads/2025/09/bandicam-2025-12-11-17-26-18-713.jpg'),
                          (null, 15, 'https://shoptaycam.com/wp-content/uploads/2025/09/bandicam-2025-12-11-17-26-18-713.jpg'),

                          (null, 16, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_4QGsT7Y5BNbYrhu4ioMWa4SQgsGe6dGfEQ&s'),
                          (null, 16, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_4QGsT7Y5BNbYrhu4ioMWa4SQgsGe6dGfEQ&s'),
                          (null, 16, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_4QGsT7Y5BNbYrhu4ioMWa4SQgsGe6dGfEQ&s');




select * from categories join products on products.categories_id = categories.ID where products.ID = 1;
-- them cot endow vao bang products

ALTER TABLE products
    ADD COLUMN endow VARCHAR(255);
-- insert du lieu vao bang products
UPDATE products
SET endow = 'Bảo hành 12 tháng\nTặng dây cáp USB-C\nMiễn phí giao hàng toàn quốc'
WHERE categories_id = 1;

UPDATE products
SET endow = 'Bảo hành 6 tháng\nTặng dây cáp USB-C\nMiễn phí giao hàng toàn quốc'
WHERE categories_id = 2;

-- update shortdescription
update products
set short_description = 'là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.\n<b>Cảm biến Hall Effect chống drift</b>\n<b>Khoá Trigger đa chế độ</b>\n<b>Kết nối 3 chế độ</b>\n<b>Tương thích PC / Android / iOS</b>'
WHERE categories_id = 1;

update products
set short_description = 'là phiên bản nâng cấp với độ trễ cực thấp và độ bền vượt trội.\n<b>Cảm biến Hall Effect chống drift</b>\n<b>Khoá Trigger đa chế độ</b>\n<b>Kết nối 3 chế độ</b>\n<b>Tương thích PC / Android / iOS</b>'
WHERE categories_id = 2;


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

update products
set full_description = 'Tay cầm chơi game Flydigi Orion 2 Controller mang thiết kế hiện đại, tối ưu cho trải nghiệm chơi game mượt mà.
Joystick và nút bấm có độ nhạy cao, cho phản hồi nhanh và chính xác trong từng thao tác.
Hỗ trợ kết nối linh hoạt với PC và thiết bị di động, dễ dàng sử dụng trên nhiều nền tảng.
Thiết kế công thái học giúp cầm nắm thoải mái khi chơi game trong thời gian dài.
Flydigi Orion 2 là lựa chọn phù hợp cho game thủ cần một tay cầm ổn định và bền bỉ.
'
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

update products
set full_description = 'Máy Game Retro Turbo G5 sở hữu màn hình 3.2 inch sắc nét cho trải nghiệm chơi game sống động.
Tích hợp hơn 15.000 tựa game retro kinh điển, không cần cài đặt thêm.
Thiết kế nhỏ gọn, tiện lợi mang theo bên mình.
Pin dung lượng tốt, đáp ứng nhu cầu chơi game liên tục.
Turbo G5 là lựa chọn hoàn hảo cho fan game retro lâu năm.
'
WHERE ID = 12;

update products
set full_description = 'Tay cầm chơi game Nitro V3 Controller có thiết kế chắc chắn, mang lại cảm giác cầm nắm thoải mái.
Joystick và nút bấm phản hồi nhanh, hỗ trợ tốt các tựa game phổ biến.
Kết nối ổn định với PC và các thiết bị chơi game thông dụng.
Độ bền cao, phù hợp sử dụng lâu dài.
Nitro V3 là lựa chọn hợp lý cho game thủ phổ thông.
'
WHERE ID = 13;

update products
set full_description = 'Apex Nova 5 Controller mang phong cách thiết kế hiện đại, đậm chất gaming.
Hệ thống nút bấm nhạy bén, giúp thao tác chính xác trong từng pha xử lý.
Hỗ trợ kết nối linh hoạt với nhiều nền tảng khác nhau.
Thiết kế công thái học giúp giảm mỏi tay khi chơi lâu.
Nova 5 phù hợp cho cả giải trí và luyện tập game hàng ngày.
'
WHERE ID = 14;

update products
set full_description = 'Direwolf 4 Controller sở hữu thiết kế mạnh mẽ, phù hợp với game thủ yêu thích phong cách hầm hố.
Joystick chính xác, hỗ trợ tốt các tựa game hành động và thể thao.
Kết nối ổn định, dễ dàng sử dụng trên nhiều thiết bị.
Chất liệu bền bỉ, đáp ứng nhu cầu sử dụng lâu dài.
Direwolf 4 mang đến trải nghiệm chơi game mượt mà và đáng tin cậy.
'
WHERE ID = 15;
update products
set full_description = 'Máy Game Retro Mini Z3 được trang bị màn hình 3.0 inch nhỏ gọn, hiển thị rõ nét.
Kho game hơn 12.000 trò chơi retro mang lại trải nghiệm giải trí đa dạng.
Thiết kế tiện lợi, dễ dàng mang theo khi di chuyển.
Pin sạc dung lượng ổn định cho thời gian chơi liên tục.
Mini Z3 là lựa chọn phù hợp cho người yêu thích game cổ điển.
'
WHERE ID = 16;

-- update cho category
UPDATE products
SET categories_id = 1
WHERE name IN (
               'PlayStation 5',
               'Xbox Series X',
               'Nintendo Switch',
               'Sony PlayStation VR2',
               'Máy Game Retro Mini Q8 – 3.5 Inch – 10.000+ Games',
               'Máy Game Retro Pixel X2 – 3.0 Inch – 8.000+ Games',
               'Máy Game Retro Turbo G5 – 3.2 Inch – 15.000+ Games',
               'Máy Game Retro Mini Z3 – 3.0 Inch – 12.000+ Games'
    );



UPDATE products
SET categories_id = 2
WHERE name IN (
               'Xbox Wireless Controller',
               'Tay Cầm Chơi Game Flydigi Vader 4 Pro Controller',
               'Tay Cầm Chơi Game Flydigi Nova 3 Controller',
               'Tay Cầm Chơi Game Flydigi Orion 2 Controller',
               'Tay Cầm Chơi Game Flydigi Galaxy 4 Pro Controller',
               'Tay Cầm Chơi Game Nitro V3 Controller',
               'Tay Cầm Chơi Game Apex Nova 5 Controller',
               'Tay Cầm Chơi Game Direwolf 4 Controller'
    );

-- update cho brand
UPDATE products
SET brand_id = CASE
    -- SONY
                   WHEN name IN (
                                 'PlayStation 5',
                                 'Sony PlayStation VR2'
                       ) THEN 1

    -- XBOX
                   WHEN name IN (
                                 'Xbox Series X',
                                 'Xbox Wireless Controller'
                       ) THEN 2

    -- NINTENDO
                   WHEN name = 'Nintendo Switch' THEN 3

    -- FLYDIGI (GDP)
                   WHEN name IN (
                                 'Tay Cầm Chơi Game Flydigi Vader 4 Pro Controller',
                                 'Tay Cầm Chơi Game Flydigi Nova 3 Controller',
                                 'Tay Cầm Chơi Game Flydigi Orion 2 Controller',
                                 'Tay Cầm Chơi Game Flydigi Galaxy 4 Pro Controller'
                       ) THEN 8

    -- MIYOO (máy retro)
                   WHEN name IN (
                                 'Máy Game Retro Mini Q8 – 3.5 Inch – 10.000+ Games',
                                 'Máy Game Retro Pixel X2 – 3.0 Inch – 8.000+ Games',
                                 'Máy Game Retro Turbo G5 – 3.2 Inch – 15.000+ Games',
                                 'Máy Game Retro Mini Z3 – 3.0 Inch – 12.000+ Games'
                       ) THEN 5

    -- NITRO / APEX / DIREWOLF (MSI)
                   WHEN name IN (
                                 'Tay Cầm Chơi Game Nitro V3 Controller',
                                 'Tay Cầm Chơi Game Apex Nova 5 Controller',
                                 'Tay Cầm Chơi Game Direwolf 4 Controller'
                       ) THEN 7

                   ELSE brand_id
    END;



-- them du lieu cho bang brand emdatdepzai (3/1)
INSERT INTO brands VALUES
                       (null, 'Nintendo', 1, NOW()),
                       (null, 'Asus', 1, NOW()),
                       (null, 'Miyoo', 1, NOW()),
                       (null, 'Steam', 1, NOW()),
                       (null, 'MSI', 1, NOW()),
                       (null, 'GDP', 1, NOW()),
                       (null, 'Ayaneo', 1, NOW()),
                       (null, 'Anbernic', 1, NOW()),
                       (null, 'Retroid', 1, NOW());




-- them du lieu de test hien san pham uu dai cho products emdatdepzai
INSERT INTO brands VALUES
                       (1, 'Sony', 1, NOW()),
                       (null, 'Xbox', 1, NOW());



select * from products
WHERE priceOld is not NULL
  and price is not NULL
  and priceOld > price
  and active = 1
order by (priceOld - price) DESC
    limit 1;


select DISTINCT useTime from products ORDER BY useTime ASC;

INSERT INTO blog VALUES
                     (null, 'https://i.ytimg.com/vi/CXMRMA9Hh-o/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAE-nfKyVbOygwsMqvVSETSmpn-Eg', 'Review tay cầm PS5 DualSense', 'review-tay-cam', 'Cảm giác rung thông minh, adaptive trigger và khả năng tương thích
                    cực tốt...', 1, 1),
                     (null, 'https://haloshop.vn/wp-content/uploads/2024/11/nhung_tua_game_ps5_hay_nhat_2024-1.jpg', 'Top game hay nhất 2024 trên PS5', 'top-game-hay', 'Tổng hợp những tựa game có đồ họa đẹp, gameplay cuốn và đáng chơi
                    nhất...', 1, 2),
                     (null, 'https://www.droidshop.vn/wp-content/uploads/2023/05/so-sanh-ps5-vs-xbox.jpg', 'So sánh PS5 và Xbox Series X', 'so-sanh', 'Đâu là chiếc máy console phù hợp cho bạn? Cùng xem phân tích chi
                    tiết...', 1, 3),
                     (null, 'https://bizweb.dktcdn.net/100/503/563/files/24.jpg?v=1740329584220', 'Hướng dẫn bảo quản tay cầm', 'baoquantaycam', 'Cách vệ sinh joystick, chống drift và kéo dài tuổi thọ tay cầm...', 1, 4),
                     (null, 'https://hocviengaming.vn/wp-content/uploads/2024/02/nintendo-switch-2-se-co-man-hinh-lcd-8-inch-0.jpg', 'Tin nóng: Nintendo Switch 2 sắp ra mắt?', 'hot new', 'Tổng hợp thông tin rò rỉ mới nhất từ các nguồn uy tín...', 1, 5);


INSERT INTO products (categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect)
VALUES
    (1,1,'PlayStation 5','Máy chơi game thế hệ mới của Sony','PlayStation 5 mang đến trải nghiệm chơi game 4K mượt mà.','CPU AMD Ryzen, GPU RDNA 2',3000000.00,3300000.00,'https://cdn2.cellphones.com.vn/x/media/catalog/product/t/a/tay-cam-choi-game-ps5-dualsense-1.png',NOW(),350,6,4500,1,'playstation-5',1,'HDR, Ray Tracing','HDMI, USB, WiFi'),
    (1,2,'https://nvs.tn-cdn.net/2021/01/Tay-cam-choi-game-Xbox-Series-X-Controller-den-1-1.jpg','Máy chơi game mạnh nhất của Microsoft','Xbox Series X hỗ trợ game 4K 120fps.','CPU AMD Zen 2, SSD NVMe',3100000.00,3300000.00,'xbox-series-x.jpg',NOW(),340,7,4800,1,'xbox-series-x',1,'Game Pass, HDR','HDMI, USB, Ethernet'),
    (2,2,'Nintendo Switch','Máy chơi game lai cầm tay','Nintendo Switch có thể chơi ở TV hoặc cầm tay.','Joy-Con, Dock',7500000,8000000.00,'https://www.droidshop.vn/wp-content/uploads/2025/09/tay-cam-Nintendo-Switch-Pro-Controller-Super-Smash-Bros.jpg',NOW(),150,4,3000,1,'nintendo-switch',0,'Multiplayer','USB-C, Bluetooth');

INSERT INTO products (categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect)
VALUES
    (1,1,'Sony PlayStation VR2','Kính thực tế ảo cho PS5','PlayStation VR2 mang đến trải nghiệm VR thế hệ mới cho PS5.','OLED HDR Display, Eye Tracking',3200000.00,3300000.00,'https://bizweb.dktcdn.net/thumb/large/100/445/365/products/sg-11134201-22120-27d835cgiykvaf-1672731786694.jpg?v=1672731803223',NOW(),90,4,560,1,'playstation-vr2',1,'VR, HDR','USB-C'),
    (2,2,'Xbox Wireless Controller','Tay cầm không dây Xbox chính hãng','Tay cầm Xbox Wireless Controller tương thích nhiều nền tảng.','Bluetooth, Ergonomic Design',5000000.00,5500000.00,'https://bizweb.dktcdn.net/thumb/grande/100/329/122/products/tay-cam-choi-game-razer-wolverine-v2-chroma-6.jpg?v=1716652873040',NOW(),15,20,280,1,'xbox-wireless-controller',0,'Windows, Console','Bluetooth, USB');

insert into products VALUES
                         (null, 1, 1, 'Tay Cầm Chơi Game Flydigi Vader 4 Pro Controller', 'short', 'full', 'infor', 2599000, 3300000, 'https://shoptaycam.com/wp-content/uploads/2024/06/Flydigi-Vader-4-Pro-Wireless-Controller.jpg', NOW(), 330, 3, 2800, 1, 'flydigi-vaper4', 0, 'HDR, Ray Tracing', 'HDMI, USB, WiFi'),
                         (null, 2, 1, 'Tay Cầm Chơi Game Flydigi Nova 3 Controller', 'short', 'full', 'infor', 890000, 1200000, 'https://shoptaycam.com/wp-content/uploads/2024/11/tay-c%E1%BA%A7m-flydigi-direwolf-3.jpg', NOW(), 300, 2, 1500, 1, 'flydigi-nova3', 0, 'HDR, Ray Tracing', 'HDMI, USB, WiFi'),
                         (null, 2, 1, 'Tay Cầm Chơi Game Flydigi Orion 2 Controller', 'short', 'full', 'infor', 1290000, 1550000, 'https://shoptaycam.com/wp-content/uploads/2024/07/bandicam-2025-06-21-17-32-42-547.jpg', NOW(), 320, 2, 1800, 1, 'flydigi-orion2', 0, 'HDR, Ray Tracing', 'HDMI, USB, WiFi'),
                         (null, 1, 1, 'Tay Cầm Chơi Game Flydigi Galaxy 4 Pro Controller', 'short', 'full', 'infor', 1550000, 1750000, 'https://masta.vn/wp-content/uploads/2024/12/tay-cam-flydigi-apex-4-elite-controller-masta-5.jpg', NOW(), 340, 2, 2000, 1, 'flydigi-galaxy4', 0, 'HDR, Ray Tracing', 'HDMI, USB, WiFi'),
                         (null, 1, 1, 'Máy Game Retro Mini Q8 – 3.5 Inch – 10.000+ Games', 'short', 'full', 'infor', 720000, 950000, 'https://product.hstatic.net/200000272737/product/retro_mini_ver.2_fbadae7882574321a62e148776d01c38_master.jpg', NOW(), 280, 2, 1400, 1, 'retro-mini-q8', 0, 'HDR, Ray Tracing', 'HDMI, USB, WiFi'),
                         (null, 2, 1, 'Máy Game Retro Pixel X2 – 3.0 Inch – 8.000+ Games', 'short', 'full', 'infor', 980000, 1200000, 'https://izzygame.com/wp-content/uploads/2025/03/gkd-pixel-2-kim-loai-cao-cap-2-300x300.jpg', NOW(), 290, 2, 1600, 1, 'retro-pixel-x2', 0, 'HDR, Ray Tracing', 'HDMI, USB, WiFi'),
                         (null, 1, 1, 'Máy Game Retro Turbo G5 – 3.2 Inch – 15.000+ Games', 'short', 'full', 'infor', 1450000, 1700000, 'https://vhost53003.vhostcdn.com/wp-content/uploads/2025/05/g5_retro_1.jpg', NOW(), 310, 2, 1900, 1, 'retro-turbo-g5', 0, 'HDR, Ray Tracing', 'HDMI, USB, WiFi'),
                         (null, 1, 1, 'Tay Cầm Chơi Game Nitro V3 Controller', 'short', 'full', 'infor', 1640000, 1900000, 'https://cohotech.vn/wp-content/uploads/2025/04/Acer-Nitro-NGR300-1.jpg', NOW(), 330, 2, 2100, 1, 'nitro-v3', 0, 'HDR, Ray Tracing', 'HDMI, USB, WiFi'),
                         (null, 2, 1, 'Tay Cầm Chơi Game Apex Nova 5 Controller', 'short', 'full', 'infor', 1750000, 2000000, 'https://shoptaycam.com/wp-content/uploads/2025/06/bandicam-2025-06-27-19-46-47-772.jpg', NOW(), 340, 2, 2200, 1, 'apex-nova5', 0, 'HDR, Ray Tracing', 'HDMI, USB, WiFi'),
                         (null, 1, 1, 'Tay Cầm Chơi Game Direwolf 4 Controller', 'short', 'full', 'infor', 1340000, 1600000, 'https://shoptaycam.com/wp-content/uploads/2025/09/bandicam-2025-12-11-17-26-18-713.jpg', NOW(), 320, 2, 2000, 1, 'direwolf4', 0, 'HDR, Ray Tracing', 'HDMI, USB, WiFi'),
                         (null, 2, 1, 'Máy Game Retro Mini Z3 – 3.0 Inch – 12.000+ Games', 'short', 'full', 'infor', 920000, 1200000, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_4GQsT7Y5BNbYrhu4ioMWa4SQgsGe6dGfEQ&s', NOW(), 300, 2, 1500, 1, 'retro-mini-z3', 0, 'HDR, Ray Tracing', 'HDMI, USB, WiFi');


-- them du lieu cho bang category 27/12/2025 (emdatdepzai)
insert into categories ( name, description, imgLink, active)
values ('console', 'PlayStation, Xbox, Nintendo Switch', 'https://m.media-amazon.com/images/I/51YXZgm0DbL._AC_SL1000_.jpg', 1),
       ('hanheld', 'Gamepad chất lượng cao cho mọi console', 'https://rptech.qa/cdn/shop/files/optimize_2_2048x.png?v=1734450756', 1),
       ('hanheld', 'Gamepad chất lượng cao cho mọi console', 'https://rptech.qa/cdn/shop/files/optimize_2_2048x.png?v=1734450756', 0);

-- thêm dữ liệu cho trang giới thiệu (about) 27/12/2025
INSERT INTO about (section, image, sort_order)
VALUES ('INFO_IMAGE', 'Assets/image/aboutUs_info.png', 1);

INSERT INTO about (section, title, description, sort_order) VALUES
                                                                ('INFO','50+ CỬA HÀNG','Hệ thống cửa hàng của chúng tôi được phân bố khắp cả nước tại các thành phố như Hà Nội, TP. Hồ Chí Minh, Đà Nẵng, Huế...',1),
                                                                ('INFO','200+ THƯƠNG HIỆU','Chúng tôi cung cấp sản phẩm đến từ nhiều thương hiệu nổi tiếng, uy tín và chất lượng được người dùng yêu thích.',2),
                                                                ('INFO','3+ TRUNG TÂM TƯ VẤN','Chúng tôi có hơn 3 trung tâm hỗ trợ luôn sẵn sàng giải đáp mọi thắc mắc của khách hàng về sản phẩm.',3),
                                                                ('INFO','5000+ KHÁCH HÀNG','Tính đến nay, cửa hàng của chúng tôi đã làm hài lòng hơn 5.000 khách hàng trong nước cũng như quốc tế.',4);

INSERT INTO about(section, description, icon, sort_order) VALUES
                                                              ('SERVICE','Cửa hàng luôn sẵn sàng tư vấn và hỗ trợ mọi thắc mắc của bạn bất cứ lúc nào.','fa-headset',1),
                                                              ('SERVICE','Chúng tôi có dịch vụ giao hàng tận nơi dành cho khách hàng không thể đến trực tiếp.','fa-truck-fast',2),
                                                              ('SERVICE','Cửa hàng thường xuyên có nhiều chương trình khuyến mãi vào các dịp đặc biệt khi bạn mua sản phẩm.','fa-gift',3),
                                                              ('SERVICE','Chúng tôi sẽ thông báo cho bạn khi có sản phẩm mới nếu bạn có nhu cầu.','fa-bell',4);

INSERT INTO about(section, title, description, image, sort_order) VALUES
                                                                      ('WHAT_WE_DO','Sản phẩm của chúng tôi','Cửa hàng có đa dạng các loại máy chơi game bạn có thể thoải mái lựa chọn theo sở thích.','Assets/image/aboutUs_product.png',1),
                                                                      ('WHAT_WE_DO','Đội ngũ của chúng tôi','Đội ngũ nhân viên luôn sẵn sàng hỗ trợ bạn bất cứ khi nào bạn cần.','Assets/image/aboutUs_team.png',2),
                                                                      ('WHAT_WE_DO','Cửa hàng của chúng tôi','Chúng tôi luôn sẵn lòng phục vụ bạn, hãy đến với cửa hàng khi bạn có nhu cầu.','Assets/image/aboutUs_store.png',3);

INSERT INTO about(section, description, title, sort_order) VALUES
                                                               ('FINAL','Cửa hàng có nhiều loại máy chơi game để bạn dễ dàng chọn theo sở thích của mình.','Nhóm 17',1),
                                                               ('FINAL','Đội ngũ luôn sẵn sàng hỗ trợ bạn bất cứ khi nào.','Nhóm 17',2),
                                                               ('FINAL','Cửa hàng luôn vui vẻ phục vụ bạn, đừng ngần ngại ghé thăm khi có nhu cầu.','Nhóm 17',3);


-- bảng cho mã OTP (7/1 Châu)
CREATE TABLE otp_tokens (
                            id INT AUTO_INCREMENT PRIMARY KEY,
                            user_id INT NOT NULL,
                            otp_hash VARCHAR(255) NOT NULL,
                            expired_at DATETIME NOT NULL,
                            used BOOLEAN DEFAULT FALSE,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
ALTER TABLE otp_tokens
    MODIFY used BOOLEAN NOT NULL DEFAULT FALSE;
UPDATE otp_tokens SET used = FALSE WHERE used IS NULL;
-- Đã insert
INSERT INTO logo VALUES ('Logo Shop', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaVtA9aH8iRQnDsQmBTt9yyB5mCIaYp8T0Qg&s');
INSERT INTO logo VALUES (null, 'Logo2 Shop', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNhDsdA_PWXkUZ3ijwSU_9rpenL-Dsu_wuFQ&s');
INSERT INTO contact VALUES ('shop@gmail.com', '0123456789', 'Ho Chi Minh City');
INSERT INTO contact VALUES (null,'shop@gmail.com', '0987654321', 'Đại Học Nông Lâm');

INSERT INTO icon VALUES (1, 'fb', '<i class="fab fa-facebook-f"></i>', 1);
INSERT INTO icon VALUES (null, 'ytb', '<i class="fab fa-youtube"></i>', 1);
INSERT INTO icon VALUES (null, 'tiktok', '<i class="fab fa-tiktok"></i>', 1);
INSERT INTO icon VALUES (null, 'ins', '<i class="fab fa-instagram"></i>', 1);
INSERT INTO icon VALUES (null, 'zalo', '<a href="#"--%>
<%--                ><img--%>
<%--                        src="https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_of_Zalo.svg"--%>
<%--                        alt="Zalo"--%>
<%--                        style="width: 22px; height: 22px"--%>
<%--                /></a>', 0);
INSERT INTO icon VALUES (null, 'x', '<i class="fab fa-twitter"></i>', 1);









INSERT INTO banner VALUES (null, 'ps5', 'Assets/image/newps5_2.png', 1),
                          (null, 'ps4', 'Assets/image/newps4_3.png', 1),
                          (null, 'flydigi apex 5 elite', 'Assets/image/NewFlidigi.png', 1),
                          (null, 'elite series 2', 'Assets/image/elite2.png', 1),
                          (null, 'three new version', 'Assets/image/threeversion.png', 1);



INSERT INTO users VALUES
    (1, 'datpham', '123456', 'dat@gmail.com', 'Dat Pham',
     '/avatar/a.png', '2003-01-01', '0909000000',
     'Viet Nam', NOW(), NOW(), NOW(), 1);

INSERT INTO categories VALUES
    (1, 'Điện tử', 'Sản phẩm điện tử', 1, 1);

drop table endow;

INSERT INTO video VALUES
    (1, 1, 'Video giới thiệu');

INSERT INTO discount VALUES
    (1, 'SALE10', 'Giảm 10%', 10,
     NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY),
     1, NOW(), NOW(), 300000, 100000, 50);

INSERT INTO orders VALUES
    (1, 1, NOW(), 'Giao giờ hành chính', 1, 1, 500000, 500000);

INSERT INTO payments VALUES
    (1, 1, 'COD', 'Chua thanh toan');



INSERT INTO bill VALUES
    (1, 1, NOW());

INSERT INTO history VALUES
    (1, 1, 1, NOW(), 'Hoàn thành', 500000);

-- username kiemcuongtim
-- pass test R8@kQ!9Z^mP2#A$L




-- Thêm 40 sản phẩm loại handheld  22/1/2026  Như --
-- Sản phẩm --
INSERT INTO products(categories_id, brand_id, name, short_description, full_description, information, price, priceOld, image, createdAt, energy, useTime, weight, active, metatitle, ispremium, suports, connect)
VALUES
-- BRAND:  ASUS
-- 1--
(2, 2, 'Asus ROG Ally – 512GB AMD Ryzen Z1 Extreme',
 'Asus đã cho trình làng chiếc máy chơi game cầm tay đầu tiên của hãng tại Việt Nam – Asus ROG Ally.',
 'Asus ROG Ally sẽ ra mắt với hai tùy chọn con chip CPU từ AMD. Tùy chọn cao cấp nhất là AMD Ryzen Z1 Extreme với 4 nhân và 16 luồng, có khả năng ép xung lên đến 5.1GHz, mang lại sức mạnh tối đa cho máy chơi game cầm tay Asus này.', 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi',
 12990000, 17990000, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/a/s/asus_rog_ally_-11.png',
 NOW(), 3000, 5, 608, 1, 'Asus ROG', 0, 'Windows 11 Home', 'Wi-Fi, Bluetooth'),

-- 2--
(2, 2, 'ROG Ally (2023) RC71L',
 'ROG Ally (2023) RC71L là máy chơi game cầm tay chạy Windows 11 Home với cấu hình mạnh nhờ AMD Ryzen™ Z1 Extreme / Z1, màn hình 7″ FHD 120 Hz, và thiết kế gamepad tích hợp',
 'ROG Ally mang trong mình Windows 11 Home nên bạn có thể chơi game từ Steam, Epic, Xbox Game Pass, GOG, …',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 15490000, 16290000,
 'https://laptopworld.vn/media/product/18489_13724_m__y_ch__i_game_asus_rog_ally_2023_1.jpg',
 NOW(), 4310, 5, 608, 1, 'ROG Ally', 0, 'Steam/Steam Deck', 'Bluetooth, Wi-Fi'),

-- 3--
(2, 2, 'ROG Xbox Ally X (RC73XA)',
 'ROG Xbox Ally X (RC73XA) là máy chơi game cầm tay chạy Windows 11 Home, thuộc dòng ROG Xbox Ally X hợp tác giữa ASUS và Xbox',
 'Máy sở hữu CPU AMD Ryzen™ AI Z2 Extreme (lên đến 5.0 GHz, 8 nhân 16 luồng) và GPU Radeon tích hợp cho hiệu năng chơi game 1080p rất mạnh mẽ trong phân khúc handheld.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 24990000, 25790000,
 'https://cdn2.cellphones.com.vn/x/media/catalog/product/r/o/rog-xbox-ally-x.jpg',
 NOW(), 4310, 5, 715, 1, 'ROG Xbox', 0, ' Steam / Epic / GOG / Xbox Game Pass / Cloud gaming',
 'Bluetooth, Wi-Fi'),

-- 4--
(2, 2, 'ROG Xbox Ally (RC73YA)',
 'ROG Xbox Ally (RC73YA) là một handheld gaming PC dạng console cầm tay chạy Windows 11 Home, hướng đến game thủ muốn trải nghiệm game',
 'ROG Xbox Ally RC73YA là phiên bản tối ưu giữa hiệu năng & pin trong dòng Xbox Ally',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 12990000, 14990000,
 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/asus_rog_xbox_ally_01_6fe17a60c8.png',
 NOW(), 3600, 6, 670, 1, 'ROG Xbox', 0, ' Steam/Epic/GOG/Xbox Game Pass/Cloud gaming',
 'Bluetooth, Wi-Fi'),

-- 5--
(2, 2, 'Asus ROG Xbox Ally X – 1 TB (AMD RYZEN Z2 EXTREME)',
 'Được mệnh danh là “quái vật” trong phân khúc máy chơi game cầm tay (Handheld Gaming Console)',
 'ROG Ally mang sức mạnh PC vào lòng bàn tay bạn, cho phép bạn chơi mọi tựa game AAA từ các nền tảng Steam, Epic Games hay Xbox Game Pass (nhờ chạy Windows 11 bản quyền).',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 24900000, 25900000,
 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_rc73_01_1.png',
 NOW(), 3000, 7, 670, 1, 'ROG Xbox', 0, 'Steam, Epic Games', 'Wi-Fi & Bluetooth'),

-- NINTENDO
-- 6--
(2, 1, 'Nintendo Switch 2',
 'Nintendo Switch 2 mang đến hàng loạt tính năng phần cứng và trải nghiệm mới, bắt đầu với chính chiếc máy console sở hữu màn hình LCD 7.9 inch hiển thị game ở độ phân giải 1080p.',
 'Nintendo Switch 2 thông qua cơ chế “snap” từ tính, trông khá giống với các mẫu trước đây nhưng được bổ sung nhiều tính năng mới, bao gồm cả chế độ điều khiển chuột.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 12350000, 13290000,
 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/123669-nintendo-switch-2-dock-joy-con-grip-2000x2000',
 NOW(), 5220, 6, 534, 1, 'Nintendo Switch', 0, 'TV',  'WiFi & Bluetooth'),

-- 7--
(2, 1, 'Nintendo Switch - Gray + Gray Joy-Con',
 'Nintendo Switch là tên gọi chính thức cho thế hệ máy chơi game tiếp theo của Nintendo. ',
 'Một chiếc máy chơi game có thể gắn vào TV để dùng như một máy console và khi ra ngoài có thể mang theo để chơi trên một cái tablet cảm ứng cùng với bộ tay cầm không dây dạng module tháo ráp rất độc đáo.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 6890000, 6990000,
 'https://assets.nintendo.com/image/upload/ar_16:9,c_lpad,w_1065/b_white/f_auto/q_auto/ncom/en_US/products/hardware/nintendo-switch-gray/110477-nintendo-switch-gray-gray-front-screen-on-1200x675',
 NOW(), 5220, 6, 534, 1, 'Nintendo Switch', 0, 'TV',  'WiFi & Bluetooth'),

-- 8--
(2, 1, 'Nintendo Switch Lite – Turquoise',
 'Nintendo Switch Lite bất ngờ được Nintendo tung ra làm giới game thủ thích thú. ',
 'Mức giá công bố rẻ hơn so với phiên bản tiêu chuẩn, Nintendo Switch Lite tất nhiên sẽ bị lược bỏ một số tính năng như: không thể gắn vào dock với chơi trên TV, Joy-Con sẽ dính liền vào thân máy',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 4990000, 5190000,
 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/en_US/products/hardware/nintendo-switch-lite-turquoise/110663-nintendo-switch-lite-turquoise-front-screen-on-1200x675',
 NOW(), 3570, 7, 275, 1, 'Nintendo Switch', 0, 'Game của Nintendo Switch',  'WiFi & Bluetooth'),

-- 9--
(2, 1, 'Nintendo Switch OLED model with Pastel Purple And Pastel Green Joy-Con',
 'Phiên bản Nintendo Switch với màn hình OLED cũng đã trình làng và làm dậy sóng cả cộng đồng game thủ sau nhiều ngày chờ đợi.',
 'Máy Switch mới năm nay cũng có sự thay đổi về màu sắc bên ngoài. Phần thân máy và dock sạc đã không còn mang màu đen truyền thống mà nay đã khoác lên chiếc áo trắng mới mang phong cách tương lai hơn.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 6500000, 6900000,
 'https://haloshop.vn/wp-content/uploads/2025/08/MAY-NINTENDO-SWITCH-OLED-PASTEL-PURPLE-AND-PASTEL-GREEN-JOY-CON_00.webp',
 NOW(), 4310, 9, 420, 1, 'Nintendo Switch', 0, 'TV', 'WiFi & Bluetooth'),

-- 10--
(2, 1, 'Nintendo Switch - Neon Blue + Neon Red Joy-Con',
 'Máy Nintendo Switch Mod đã gắn Mod cho phép Máy chơi được hầu hết các game Switch hiện tại chỉ cần tải game về và chơi, giúp bạn tiết kiệm chi phí chơi game.',
 'Máy Mod ở Custom Firmware mới nhất nên sẽ hỗ trợ hầu hết tất cả các game mới ở thời điểm hiện tại.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 6890000, 7090000,
 'https://assets.nintendo.com/image/upload/ar_16:9,c_lpad,w_1065/b_white/f_auto/q_auto/ncom/en_US/products/hardware/nintendo-switch-red-blue/110478-nintendo-switch-neon-blue-neon-red-front-screen-on-1200x675',
 NOW(), 4310, 9, 420, 1, 'Nintendo Switch', 0, 'TV', 'WiFi & Bluetooth'),

-- 11--
(2, 1, 'Nintendo Switch™ 2 + Mario Kart™ World Bundle',
 'Nintendo Switch™ 2 + Mario Kart™ World Bundle là gói máy chơi game Nintendo Switch 2 đi kèm game Mario Kart World bản đầy đủ',
 'Máy Nintendo Switch 2 là thế hệ tiếp theo của dòng Switch với nhiều nâng cấp vượt trội bao gồm mã tải Mario Kart World — một tựa game đua kart mới nhất, tối ưu cho Switch 2.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 13200000, 13890000,
 'https://assets.nintendo.com/image/upload/ar_16:9,c_lpad,w_1065/b_white/f_auto/q_auto/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/122179-nintendo-switch-2-hardware-with-mario-kart-world-full-game-download-package-front-angle-2000x2000',
 NOW(), 5220, 6, 534, 1,'Nintendo Switch 2', 0, 'TV', 'WiFi & Bluetooth'),


-- MIYOO --
-- 12--
(2, 3, 'Miyoo mini flip',
 'Máy chơi game gập nhỏ gọn',
 'Một sản phẩm đáng mong chờ của cộng đồng yêu thích game retro với mẫu máy gập cực kỳ nhỏ gọn mới từ loMiyoo mang tên miyoo mini flip.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 1490000, 1680000,
 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-1-600x600.jpg',
 NOW(), 2500, 5, 200, 1, 'Miyoo mini', 0, 'Emulation nhiều hệ retro', 'Wi-Fi'      ),

-- 13--
(2, 3, 'Miyoo A30',
 'Miyoo A30 nhỏ gọn nâng cấp cấu hình, bổ sung joystick.',
 'Miyoo A30 được miyoo giới thiệu là một thiết bị chơi game cầm tay nhỏ gọn, giá rẻ với thiết kê ngang kèm joystick được nhiều người quan tâm.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 1150000, 1780000,
 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-5.jpg',
 NOW(), 2600, 5, 270, 1, 'Miyoo', 0, 'Nhiều hệ máy retro khác nhau', 'Wi-Fi'),

-- 14
(2, 3, 'Máy chơi game Miyoo Mini Plus Miyoo Handheld',
 'Máy chơi game retro cầm tay',
 'Máy retro handheld nhỏ gọn, chạy hệ điều hành Linux (hoặc OnionOS), thiết kế để chơi game cổ điển từ nhiều hệ khác nhau (NES, SNES, Game Boy, PS1, arcade, ...)',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 1390000, 1480000,
 'https://izzygame.com/wp-content/uploads/2023/04/photo_2023-04-29_21-30-49-600x600.jpg',
 NOW(), 3000, 6, 170, 1, 'Miyoo mini', 0, 'Hệ retro (NES → PS1)', 'Wi-Fi'),


-- STEAM
-- 15--
(2, 4, 'Steam Deck 512GB (NVMe SSD)',
 'Steam Deck phiên bản mới được nâng cấp với Màn hình OLED sống động hơn',
 'Thiết kế công thái học đẳng cấp thế giới cùng trải nghiệm trực quan như máy console, mang đến trải nghiệm chơi game mãn nhãn nhất cho game thủ.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 17990000, 20090000,
 'https://haloshop.vn/wp-content/uploads/2025/02/steam-deck-64gb-emmc-00-700x700-1.jpg',
 NOW(), 4000, 7, 640, 1, 'Steam Deck', 0, 'chơi trực tiếp từ thư viện Steam', 'Wi-Fi'),

-- 16--
(2, 4, 'Steam Deck OLED White Edition 1TB (NVMe SSD)',
 'Steam Deck phiên bản mới được nâng cấp với Màn hình OLED sống động hơn, thời lượng pin tốt hơn, WiFi nhanh hơn',
 'Thiết kế công thái học đẳng cấp thế giới cùng trải nghiệm trực quan như máy console, mang đến trải nghiệm chơi game mãn nhãn nhất cho game thủ.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 18800000, 19000000,
 'https://haloshop.vn/wp-content/uploads/2025/02/steam_deck_oled_1tb_white_edition_00-700x700-1.jpg',
 NOW(), 4000, 7, 640, 1, 'Steam Deck', 0, 'chơi trực tiếp từ thư viện Steam', 'Wi-Fi'),

-- 17--
(2, 4, 'Valve Steam Deck OLED 1TB Handheld',
 'Chiếc máy chơi game đến từ gã khổng lồ Valve chính thức xuất hiện.',
 ' Chiếc máy chơi game cầm tay này giúp người chơi trải nghiệm kho game đồ sộ trên nền tảng Steam nổi tiếng ở bất cứ đâu, đồng bộ hoàn hảo với thư viện Steam Library trên PC của bạn.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 19490000, 20790000,
 'https://bizweb.dktcdn.net/100/476/122/products/316282002-5677069459005263-5496119171875278767-n-1675087036737-1702023014787.jpg?v=1702023019493',
 NOW(), 5000, 9, 640, 1, 'Steam Deck', 0, 'chạy trực tiếp game từ thư viện Steam', 'WiFi & Bluetooth'),


-- MSI
-- 18--
(2, 5, 'Máy chơi game MSI Claw A1M',
 'Máy chơi game cầm tay',
 'Máy chơi game MSI Claw là chiếc máy PC Gaming Handheld đầu tiên của nhà sản xuất linh kiện vô cùng nổi tiếng – MSI.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 13990000, 19990000,
 'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-1.jpg',
 NOW(), 3000, 4, 675, 1, 'MSI', 0, 'Game PC (Steam/Epic/Uplay) trên Windows 11', 'WiFi & Bluetooth'),

-- 19--
(2, 5, 'MSI Claw A8 BZ2EM-025PL',
 'Máy chơi game cầm tay',
 'Máy được trang bị CPU AMD Ryzen™ Z2 Extreme mạnh mẽ cùng RAM 24GB LPDDR5X và màn hình 8 inch Full HD+ 120Hz sắc nét.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 24590000, 25990000,
 'https://techbox.com.gr/images/ab__webp/thumbnails/570/570/detailed/11627/msi-claw-a8-bz2em-025pl-portable-game-console-20-3-cm-8-1-tb-touchscreen-wi-fi-white-11746257_jpg.webp',
 NOW(), 3000, 5, 765, 1, 'MSI', 0, 'Game Steam/Epic/Xbox Game Pass', 'WiFi & Bluetooth'),

-- 20--
(2, 5, 'MSI Claw 8 AI+ A2VM-037PL',
 'Máy chơi game cầm tay',
 'Thiết bị handheld AI thế hệ mới, mang phong cách đậm chất gaming cùng sức mạnh đến từ vi xử lý Intel Core Ultra 7 258V và đồ họa tích hợp Intel Arc. ',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 26900000, 27290000,
 'https://techbox.com.gr/images/ab__webp/thumbnails/570/570/detailed/11431/msi-claw-8-ai-a2vm-037pl-portable-game-console-20-3-cm-8-1-tb-touchscreen-wi-fi-beige-11550743_jpg.webp',
 NOW(), 4500, 6, 300, 1, 'MSI', 0, 'Game Steam/Epic/Xbox Game Pass', 'WiFi & Bluetooth'),

-- GPD--
-- 21--
(2, 6, 'GPD WIN 5 (Al Max 385/AI Max Plus 395)',
 'Máy chơi game cầm tay',
 'Thế hệ máy chơi game cầm tay cao cấp nhất của GPD tính đến năm 2025, mang trong mình sức mạnh vượt trội từ vi xử lý AMD Ryzen AI Max 385 và AI Max Plus 395.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 45980000, 50900000,
 'https://pcngon.vn/wp-content/uploads/2025/11/May-tinh-cam-tay-GPD-WIN-5-Al-Max-385-AI-Max-Plus-395.jpg',
 NOW(), 5000, 6, 590, 1, 'GPD', 0, 'Steam, Epic, Xbox Game Pass', 'WiFi & Bluetooth' ),

-- 22-
(2, 6, 'GPD Win 4',
 'Máy chơi game cầm tay',
 'GPD Win 4 là dòng máy chơi game cầm tay (handheld PC) do GPD sản xuất, nổi bật ở hiệu năng PC mạnh mẽ trong kích thước nhỏ gọn',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 11000000, 12290000,
 'https://weirdstore.vn/wp-content/uploads/2024/03/n-2.jpg',
 NOW(), 3000, 6, 598, 1, 'GPD', 0, 'Game PC AAA, Steam, Epic, emulation', 'WiFi & Bluetooth' ),

-- 23--
(2, 6, 'GPD Win 4 8840U',
 'Máy chơi game cầm tay',
 'Máy chơi game cầm tay PC handheld chạy Windows 11, dùng chip AMD Ryzen 7 8840U, hiệu năng mạnh trong form nhỏ gọn cho game PC',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 20500000, 20900000,
 'https://weirdstore.vn/wp-content/uploads/2024/03/n-2.jpg',
 NOW(), 3000, 6, 598, 1, 'GPD', 0, 'Game PC AAA, Steam, Epic, emulation', 'WiFi & Bluetooth' ),



-- AYANEO --
-- 24--
(2, 7, 'AYANEO 2',
 'Máy chơi game cầm tay',
 'Trên tay AYANEO 2, Handheld PC chạy AMD Ryzen 7 6800U đầu tiên của hãng AYANEO',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 12000000, 13290000,
 'https://weirdstore.vn/wp-content/uploads/2024/03/AYANEOAIR_20_cfc73e29-919e-4371-9dbe-9f5696e8e9af-1536x1536.webp',
 NOW(), 12000, 5, 680, 1, 'Ayaneo', 0, 'Steam, Epic Games, Xbox Game Pass PC, GOG', 'WiFi & Bluetooth'),

-- 25--
(2, 7, 'AYANEO 2S – Order',
 'Máy chơi game cầm tay',
 'AYANEO 2S là handheld gaming PC chạy Windows 11, được hãng Ayaneo nâng cấp từ dòng AYANEO 2 với phần cứng mạnh mẽ',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 19900000, 20100000,
 'https://weirdstore.vn/wp-content/uploads/2024/03/n-3.png',
 NOW(), 13000, 6, 680, 1, 'Ayaneo', 0, 'Steam, Epic Games, Xbox Game Pass PC, GOG', 'WiFi & Bluetooth'),

-- 26--
(2, 7, 'AYANEO 3 32Gb – 1Tb chip AI370',
 'Máy chơi game cầm tay',
 'AYANEO 3 là một handheld gaming PC cao cấp chạy Windows 11 — được đánh giá là một trong những thiết bị chơi game portables mạnh nhất hiện nay',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 32000000, 33090000,
 'https://weirdstore.vn/wp-content/uploads/2024/11/Untitled-1.jpg',
 NOW(), 13000, 6, 680, 1 ,'Ayaneo', 0, 'Steam, Epic Games, Xbox Game Pass PC, GOG', 'WiFi & Bluetooth'),

-- 27--
(2, 7, 'AYANEO Geek',
 'Máy chơi game cầm tay',
 'AYANEO Geek là máy chơi game cầm tay dạng PC (Windows) của AYANEO, nhắm tới những người muốn hiệu năng gaming tốt nhưng giá mềm hơn so với AYANEO 2 / 2S.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 11000000, 12190000 ,
 'https://weirdstore.vn/wp-content/uploads/2024/03/image-61-935x800.png',
 NOW(), 13000, 6, 680, 1 ,'Ayaneo', 0, 'Steam, Epic Games, Xbox Game Pass PC, GOG', 'WiFi & Bluetooth'),

-- 28--
(2, 7, 'Ayaneo Pocket Micro',
 'Máy chơi game cầm tay',
 'Là handheld gaming nhỏ gọn chạy Android 13, được thiết kế chủ yếu để chơi game retro và giả lập nhưng vẫn đủ sức xử lý nhiều thể loại game nhẹ và trung bình trên nền Android.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 7690000, 7800000,
 'https://weirdstore.vn/wp-content/uploads/2024/09/AYANEO-POCKET-MICRO-SOUL-RED-DONE-01.png',
 NOW(), 2600, 6, 233, 1 ,'Ayaneo', 0, 'Android/Retro emulation', 'WiFi & Bluetooth'),

-- 29--
(2, 7, 'Ayaneo Pocket DS',
 'Máy chơi game cầm tay',
 'AYANEO Pocket DS là một má́y chơi game handheld chạy Android với thiết kế màn hình đôi dạng clamshell lấy cảm hứng từ các máy Nintendo Dual-Screen cổ điển nhưng nâng cấp hiện đại để chơi game Android',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 12800000, 13190000,
 'https://weirdstore.vn/wp-content/uploads/2025/08/ayaneo-pocket-ds-indiegogo-confirmation-kv-1067x800.jpg',
 NOW(), 8000, 10, 1000, 1 ,'Ayaneo', 0, 'Retro emulation từ NES → DS/3DS → PSP', 'WiFi & Bluetooth'),



-- Anbernic--
-- 30--
(2, 8, 'Anbernic – Retro Gamboy Flip RG35XXSP – 64GB – Green Transparent',
 'ANBERNIC RG35XXSP là một thiết bị chơi game retro cầm tay độc đáo',
 'kết hợp giữa thiết kế hoài cổ của Game Boy Advance SP với công nghệ hiện đại, màn hình IPS 3.5 inch sắc nét, hiệu năng mạnh mẽ và khả năng chơi nhiều hệ máy game cổ điển, RG35XXSP là một lựa chọn tuyệt vời cho những ai yêu thích game retro.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 1800000, 1990000,
 'https://herogame.vn/upload/images/img_02_01_2025/may-retro-game-cam-tay-rg35xxsp-nap-gap-nho-gon-hon-10000-games-anbernic-1_686716_67761b7012f4f1.05703435.jpg',
 NOW(), 3300, 6, 200, 1, 'Anbernic', 0, 'NES / Famicom, SNES ,Game Boy / GBC / GBA',  'WiFi & Bluetooth'),

-- 31--
(2, 8, 'Anbernic – Retro Game Handheld RG406 – 256GB',
 'Anbernic RG406 – Retro Game Handheld (256GB) dành cho những tựa game kinh điển của thập niên 80, 90 và đầu 2000',
 'Thiết kế công thái học: Vừa vặn trong tay, giúp bạn chơi hàng giờ liền mà không bị mỏi.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 5000000, 6190000,
 'https://haloshop.vn/wp-content/uploads/2025/03/anbernic_retro_game_handheld_rg406v_256gb_41-700x700-1.jpg',
 NOW(), 4500, 8, 260, 1, 'Anbernic', 0, 'NES / Famicom, SNES ,Game Boy / GBC / GBA', 'WiFi & Bluetooth'),

-- 32--
(2, 8, 'Anbernic Retro Game RG353P + 64GB Micro SD Card',
 'Máy chơi game Anbernic Retro Game là máy chơi game Retro của hãng Anbernic chuyên sản xuất các dòng máy game Retro',
 'Máy Anbernic Retro Game RG353P có thể chạy được giả lập các dòng máy Retro thịnh hành vào thời điểm 199x như Game Boy Advance, Game Boy Color, NES, SNES, SEGA MD, Neo Geo, Game Gear, Sega Master System Game Series,…',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 3850000, 3990000,
 'https://haloshop.vn/wp-content/uploads/2025/02/Anbernic-Retro-Game-RG353P-_-64GB-Micro-SD-C.jpg',
 NOW(), 3500, 5, 422, 1, 'Anbernic', 0, 'NES → PSP/PS1/N64', 'WiFi & Bluetooth'
),

-- 33-
(2, 8, 'Anbernic RG477V',
 'Máy chơi game cầm tay',
 'Đây là mẫu máy dọc mạnh nhất hiện tại của hãng, sau các đời 405v hay 406v thì mẫu này được cộng đồng đánh giá cao nhờ có thiết kế cải tiến gọn gàng hơn mà màn hình lại rất lớn',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 6789000, 6987000,
 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-2.jpg',
 NOW(), 5500, 8, 334, 1, 'Anbernic', 0, 'Game Android + giả lập retro (PS2/Wii U…)', 'WiFi & Bluetooth'),

-- 34--
(2, 8, 'Anbernic RG DS',
 'Một handheld Android màn hình đôi',
 'Hai màn hình có thể dùng cho game dual-screen, chạy hai ứng dụng cùng lúc hoặc dùng màn dưới làm menu/touch input khi chơi game.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 2990000, 3299000,
 'https://izzygame.com/wp-content/uploads/2025/12/anbernic-rgds-4.jpg',
 NOW(), 4000, 5, 321, 1, 'Anbernic', 0, 'Game Android & giả lập retro', 'WiFi & Bluetooth'),

-- 35--
(2, 8, 'Anbernic 476H',
 'Thiết kế gọn gàng, máy mạnh màn đẹp 120hz',
 'Anbernic 476h sử dụng màn hình có tần số quét cao đến 120hz phục vụ tốt cho nhu cầu chơi game android, màn hình hiển thị tỉ lệ 4:3',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 3790000, 3990000,
 'https://izzygame.com/wp-content/uploads/2025/09/anbernic-rg476h-120hz-9-1.jpg',
 NOW(), 5000, 6, 290, 1, 'Anbernic', 0, 'Game Android & giả lập retro', 'WiFi & Bluetooth'),


-- RETROID--
-- 36 --
(2, 9, 'Retroid Pocket G2',
 'Retroid Pocket G2 một phiên bản nâng cấp của retroid pocket 5',
 'Retroid Pocket G2 là mẫu máy chơi game cầm tay thuộc dòng “retro Android handheld” của hãng Retroid — được thiết kế để vừa chơi game Android hiện đại',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 6790000, 6980000,
 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-5.jpg',
 NOW(),  5000, 6, 280, 1, 'Retroid', 0, 'Android games + emulation (retro & 3D)',  'WiFi & Bluetooth'),

-- 37--
(2, 9, 'Retroid Pocket Mini V2',
 'Retroid Pocket Mini V2 nâng cấp màn hình tràn viền siêu đẹp.',
 'Màn hình được nâng cấp viền màn hình siêu mỏng, giúp tổng thể máy đẹp hơn bản V1 nhiều, không bị viền quá dày ở trên và dưới cho cảm giác thị giác đã hơn phiên bản tiền nhiệm.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 4750000, 4980000,
 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-1.jpg',
 NOW(),  4000, 6, 215, 1, 'Retroid', 0, 'Game Android và nhiều hệ emulator (PS1, N64, PSP/GC...)', 'WiFi & Bluetooth'),


-- 38--
(2, 9, 'Retroid Pocket Mini',
 'Thiết bị cầm tay chạy Android',
 'Pocket Mini là 1 trong những cái tên đáng cân nhắc vì cấu hình rất mạnh mẽ trong phân khúc kèm với thiết kế công thái học trong 1 thân hình nhỏ gọn khá phù hợp để mang theo mọi lúc.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 3990000, 4199000,
 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-1.jpg',
 NOW(), 4000, 6, 215, 1, 'Retroid', 0, 'Game Android và nhiều hệ emulator (PS1, N64, PSP/GC...)', 'WiFi & Bluetooth'),

-- 39--
(2, 9, 'Retroid Pocket Flip 2',
 'Máy chơi game handheld Android thiết kế dạng clamshell',
 'Trang bị màn hình oled cực đẹp với thiết kế viền màn hình mỏng hơn',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 4590000, 4890000,
 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-1.jpg',
 NOW(), 5000, 7, 300, 1, 'Retroid', 0, 'Game Android và nhiều hệ retro', 'WiFi & Bluetooth'),

-- 40--
(2, 9, 'Retroid Pocket 2S',
 'Retroid pocket 2s là bản nâng cấp cấu hình của dòng pcoket 2 ra mắt trước đó',
 'Bản nâng cấp được đánh giá cao vì cấu hình khỏe, nâng cấp phím cũng đáng giá hơn.',
 'Console và tay cầm chơi game mang đến trải nghiệm giải trí sống động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp nhiều tính năng giúp người chơi linh hoạt và tiện lợi.',
 2450000, 2890000,
 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-4.jpg',
 NOW(), 4000, 6, 200, 1, 'Retroid', 0, 'Game Android và nhiều hệ retro', 'WiFi & Bluetooth')




-- Hình ảnh của 40 sản phẩm loại handheld --
    INSERT INTO gallary(product_id, img) VALUES
-- ASUS --
-- 1--
    (null,'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/a/s/asus_rog_ally_-7.png'),
    (null,'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/a/s/asus_rog_ally_-6.png'),
    (null,'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/a/s/asus_rog_ally_-3.png'),

-- 2--
    (null, 'https://laptopworld.vn/media/product/18489_13724_m__y_ch__i_game_asus_rog_ally_2023_2.jpg'),
    (null, 'https://laptopworld.vn/media/product/18489_13724_m__y_ch__i_game_asus_rog_ally_2023_3.jpg'),
    (null, 'https://laptopworld.vn/media/product/18489_13724_m__y_ch__i_game_asus_rog_ally_2023_4.jpg'),

-- 3--
    (null, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/r/o/rog-xbox-ally-x-2.jpg'),
    (null,'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/r/o/rog-xbox-ally-x-1.jpg'),
    (null, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/r/o/rog-xbox-ally-x-3.jpg'),
-- 4--
    (null,'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/asus_rog_xbox_ally_03_70444b6eec.png'),
    (null,'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/asus_rog_xbox_ally_05_a31641d377.png'),
    (null,'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/asus_rog_xbox_ally_07_115c0d80ab.png'),

-- 5--
    (null, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_rc73_12_1.png'),
    (null, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_rc73_11_1.png'),
    (null, 'https://vn.store.asus.com/media/catalog/product/cache/74e490e088db727ef90851ac50e1fa20/r/o/rog_rc73_02_1.jpg'),


-- NINTENDO
-- 6--
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/123669-nintendo-switch-2-hand-pulling-right-joy-con-off-1200x675'),
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/123669-nintendo-switch-2-tabletop-2-2000x2000'),
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/123669-nintendo-switch-2-dock-system-joy-con-on-grip-1200x675'),

-- 7--
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/en_US/products/hardware/nintendo-switch-gray/110477-nintendo-switch-gray-gray-console-joy-con-tabletop-mode-1200x675'),
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/en_US/products/hardware/nintendo-switch-gray/110477-nintendo-switch-gray-gray-console-docked-joy-con-grip-1200x675'),
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/en_US/products/hardware/nintendo-switch-gray/110477-nintendo-switch-gray-gray-front-screen-on-lifestyle-1200x675'),

-- 8--
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/en_US/products/hardware/nintendo-switch-lite-turquoise/110663-nintendo-switch-lite-turquoise-lifestyle-1200x675'),
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,c_lpad,w_1065/b_white/f_auto/q_auto/ncom/en_US/products/hardware/nintendo-switch-lite-turquoise/110663-nintendo-switch-lite-turquoise-package-1200x675'),
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/en_US/products/hardware/nintendo-switch-lite-turquoise/110663-nintendo-switch-lite-turquoise-front-screen-on-1200x675'),

-- 9--
    (null, 'https://haloshop.vn/wp-content/uploads/2025/08/MAY-NINTENDO-SWITCH-OLED-PASTEL-PURPLE-AND-PASTEL-GREEN-JOY-CON_41.webp'),
    (null, 'https://haloshop.vn/wp-content/uploads/2025/08/MAY-NINTENDO-SWITCH-OLED-PASTEL-PURPLE-AND-PASTEL-GREEN-JOY-CON_42.webp'),
    (null, 'https://haloshop.vn/wp-content/uploads/2025/08/MAY-NINTENDO-SWITCH-OLED-PASTEL-PURPLE-AND-PASTEL-GREEN-JOY-CON_00.webp'),

-- 10--
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/en_US/products/hardware/nintendo-switch-red-blue/110478-nintendo-switch-neon-blue-neon-red-front-screen-on-neon-red-disconnected-angle-1200x675'),
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/en_US/products/hardware/nintendo-switch-red-blue/110478-nintendo-switch-neon-blue-neon-red-console-docked-joy-con-grip-1200x675'),
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/en_US/products/hardware/nintendo-switch-red-blue/110478-nintendo-switch-neon-blue-neon-red-front-screen-on-lifestyle-1200x675'),

-- 11--
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/123669-nintendo-switch-2-dock-joy-con-grip-2000x2000'),
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/123669-nintendo-switch-2-tabletop-2000x2000'),
    (null, 'https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_1.5/c_scale,w_700/ncom/My%20Nintendo%20Store/EN-US/Nintendo%20Switch%202/Hardware/123669-nintendo-switch-2-dock-system-joy-con-attached-1200x675'),


-- MIYOO
-- 12--
    (null, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-3-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-4-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2026/01/miyoo-mini-flip-5-600x600.jpg'),

-- 13--
    (null, 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-2-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-3-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2024/05/Miyoo-A30-6-600x600.jpg'),

-- 14--
    (null, 'https://izzygame.com/wp-content/uploads/2023/04/photo_2023-04-29_21-30-46-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2023/04/20230527_152623-600x800.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2023/04/Miyoo-mini-plus-den-600x600.jpg'),


-- STEAM
-- 15--
    (null, 'https://product.hstatic.net/200000637319/product/78124_may_choi_game_cam_tay_steam_deck_oled_512gb_nvme_ssd_2_bbd3227eba0a48ac93876ba49f230da8_master.jpg'),
    (null, 'https://product.hstatic.net/200000637319/product/78124_may_choi_game_cam_tay_steam_deck_oled_512gb_nvme_ssd_1_6d8d98db95004879ae016a3dd4c6400e_master.jpg'),
    (null, 'https://product.hstatic.net/200000637319/product/78124_may_choi_game_cam_tay_steam_deck_oled_512gb_nvme_ssd_1_6d8d98db95004879ae016a3dd4c6400e_master.jpg'),

-- 16--
    (null, 'https://haloshop.vn/wp-content/uploads/2025/02/steam_deck_oled_1tb_white_edition_41-700x700-1.jpg'),
    (null, 'https://haloshop.vn/wp-content/uploads/2025/02/steam_deck_oled_1tb_white_edition_42-700x700-1.jpg'),
    (null, 'https://haloshop.vn/wp-content/uploads/2025/02/steam_deck_oled_1tb_white_edition_45-700x700-1.jpg'),

-- 17--
    (null, 'https://bizweb.dktcdn.net/100/476/122/products/vh-installer-1-1702023014809.png?v=1702023021590'),
    (null, 'https://bizweb.dktcdn.net/100/476/122/products/vh-installer-1702023014820.png?v=1702023022600'),
    (null, 'https://bizweb.dktcdn.net/100/476/122/products/514pfkhblzl-ac-sx466-1675087036737-1702023014787.jpg?v=1702023020310'),

-- MSI
-- 18 --
    (null, 'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-3.jpg'),
    (null, 'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-2.jpg'),
    (null, 'https://www.droidshop.vn/wp-content/uploads/2024/06/May-choi-game-MSI-Claw-1-1.jpg'),

-- 19 --
    (null, 'https://techbox.com.gr/images/ab__webp/thumbnails/570/570/detailed/11627/msi-claw-a8-bz2em-025pl-portable-game-console-20-3-cm-8-1-tb-touchscreen-wi-fi-white-11746258_jpg.webp'),
    (null, 'https://techbox.com.gr/images/ab__webp/thumbnails/570/570/detailed/11627/msi-claw-a8-bz2em-025pl-portable-game-console-20-3-cm-8-1-tb-touchscreen-wi-fi-white-11746257_jpg.webp'),
    (null, 'https://techbox.com.gr/images/ab__webp/thumbnails/570/570/detailed/11627/msi-claw-a8-bz2em-025pl-portable-game-console-20-3-cm-8-1-tb-touchscreen-wi-fi-white-11746261_jpg.webp'),

-- 20--
    (null, 'https://techbox.com.gr/images/ab__webp/thumbnails/570/570/detailed/11431/msi-claw-8-ai-a2vm-037pl-portable-game-console-20-3-cm-8-1-tb-touchscreen-wi-fi-beige-11550738_jpg.webp'),
    (null, 'https://techbox.com.gr/images/ab__webp/thumbnails/570/570/detailed/11431/msi-claw-8-ai-a2vm-037pl-portable-game-console-20-3-cm-8-1-tb-touchscreen-wi-fi-beige-11550739_jpg.webp'),
    (null, 'https://techbox.com.gr/images/ab__webp/thumbnails/570/570/detailed/11431/msi-claw-8-ai-a2vm-037pl-portable-game-console-20-3-cm-8-1-tb-touchscreen-wi-fi-beige-11550736_jpg.webp'),

-- GPD
-- 21--
    (null, 'https://pcngon.vn/wp-content/uploads/2025/11/May-tinh-cam-tay-GPD-WIN-5-Al-Max-385-AI-Max-Plus-395-10.jpg'),
    (null, 'https://pcngon.vn/wp-content/uploads/2025/11/May-tinh-cam-tay-GPD-WIN-5-Al-Max-385-AI-Max-Plus-395-2.jpg'),
    (null, 'https://pcngon.vn/wp-content/uploads/2025/11/May-tinh-cam-tay-GPD-WIN-5-Al-Max-385-AI-Max-Plus-395-1.jpg'),

-- 22--
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230226_101554-Copy.jpg'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230226_101543-Copy.jpg'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230226_101920-Copy-1-1067x800.jpg'),

-- 23--
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-2.jpg'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230226_101543-Copy.jpg'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230226_101920-Copy-1-1067x800.jpg'),



-- AYANEO
-- 24-
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/AYANEOAIR_20_cfc73e29-919e-4371-9dbe-9f5696e8e9af-1536x1536.webp'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/AYANEOAIR_20_cfc73e29-919e-4371-9dbe-9f5696e8e9af-1536x1536.webp'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/20230110_085931-Copy-1.jpg'),

-- 25--
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-3.png'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-3.png'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/n-3.png'),

-- 26--
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/11/Untitled-1.jpg'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/11/Untitled-1.jpg'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/11/Untitled-1.jpg'),

-- 27
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/image-61-935x800.png'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/image-61-935x800.png'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/03/image-61-935x800.png'),

-- 28--
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/09/AYANEO-POCKET-MICRO-SOUL-RED-DONE-01.png'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/09/AYANEO-POCKET-MICRO-SOUL-RED-DONE-01.png'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2024/09/AYANEO-POCKET-MICRO-SOUL-RED-DONE-01.png'),

-- 29--
    (null, 'https://weirdstore.vn/wp-content/uploads/2025/08/ayaneo-pocket-ds-indiegogo-confirmation-kv-1067x800.jpg'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2025/08/ayaneo-pocket-ds-indiegogo-confirmation-kv-1067x800.jpg'),
    (null, 'https://weirdstore.vn/wp-content/uploads/2025/08/ayaneo-pocket-ds-indiegogo-confirmation-kv-1067x800.jpg'),


-- Anbernic---
-- 30--
    (null, 'https://herogame.vn/upload/images/img_02_01_2025/may-retro-game-cam-tay-rg35xxsp-nap-gap-nho-gon-hon-10000-games-anbernic-4_801428_67761b70133425.88983002.jpg'),
    (null, 'https://herogame.vn/upload/images/img_02_01_2025/may-retro-game-cam-tay-rg35xxsp-nap-gap-nho-gon-hon-10000-games-anbernic-6_373158_67761b70135fb1.86248728.jpg'),
    (null, 'https://herogame.vn/upload/images/img_02_01_2025/may-retro-game-cam-tay-rg35xxsp-nap-gap-nho-gon-hon-10000-games-anbernic-7_750418_67761b70137115.53368023.jpg'),

-- 31--
    (null, 'https://haloshop.vn/wp-content/uploads/2025/03/anbernic_retro_game_handheld_rg406v_256gb_42-700x700-1.jpg'),
    (null, 'https://haloshop.vn/wp-content/uploads/2025/03/anbernic_retro_game_handheld_rg406v_256gb_47-700x700-1.jpg'),
    (null, 'https://haloshop.vn/wp-content/uploads/2025/03/anbernic_retro_game_handheld_rg406v_256gb_43-700x700-1.jpg'),

-- 32--
    (null, 'https://haloshop.vn/wp-content/uploads/2025/02/anbernic-retro-game-rg353p-64gb-sd-card-46.jpg'),
    (null, 'https://haloshop.vn/wp-content/uploads/2025/02/Anbernic-Retro-Game-RG353P-_-64GB-Micro-SD-C-4.jpg'),
    (null, 'https://haloshop.vn/wp-content/uploads/2025/02/Anbernic-Retro-Game-RG353P-_-64GB-Micro-SD-C-5.jpg'),

-- 33--
    (null, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-5-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-4-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2026/01/anbernic-rg477v-8300-cuc-manh-6-600x600.jpg'),

-- 34--
    (null, 'https://izzygame.com/wp-content/uploads/2025/12/anbernic-rgds-3-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/12/anbernic-rgds-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/12/anbernic-rgds-4-600x600.jpg'),


-- 35--
    (null, 'https://izzygame.com/wp-content/uploads/2025/09/anbernic-rg476h-120hz-2-1-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/09/anbernic-rg476h-120hz-3-1-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/09/anbernic-rg476h-120hz-6-1-600x600.jpg'),


-- Retroid---
-- 36--
    (null, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-6-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-4-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/12/Retroid-pocket-g2-2-600x600.jpg'),

-- 37--
    (null, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-9-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-2-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/09/retroid-pocket-mini-v2-rpmini-3-600x600.jpg'),

-- 38--
    (null, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-2-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-7-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/06/retroid-pocket-mini-snapdragon-865-600x600.jpg'),

-- 39--
    (null, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-4-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-10-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2025/04/Retroid-Pocket-Flip-2-cao-cap-6-600x600.jpg'),

-- 40--
    (null, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-9-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-5-600x600.jpg'),
    (null, 'https://izzygame.com/wp-content/uploads/2023/09/Retroid-pocket-2s-8-600x600.jpg'),


-- Thêm bảng admin 24/01 Như
CREATE TABLE admin (
                       ID INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       fullname VARCHAR(100),
                       status TINYINT DEFAULT 1
);

-- username = Admin, password = Admin@12345
INSERT INTO admin(username, password, fullname) VALUES ('Admin', '$2a$10$EsoqYldgsgbopnxoOvxf7ujIcrjbb.BX5v86K9JCzC6s4PUtfC3hm', N'Administrator');

