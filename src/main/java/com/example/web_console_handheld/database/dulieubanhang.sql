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
                         ID VARCHAR(50) PRIMARY KEY,
                         products_id INT,
                         users_id INT,
                         rating INT,
                         review_text VARCHAR(255),
                         imgReviews VARCHAR(255),
                         reviewDate DATETIME,
                         status VARCHAR(50),
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









INSERT INTO banner (title, link, active) VALUES ('Banner Sale', '/banner/sale.png', 1);



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

INSERT INTO reviews VALUES
    ('RV01', 1, 1, 5, 'Rất tốt', '/review/r1.png', NOW(), 'active');

INSERT INTO bill VALUES
    (1, 1, NOW());

INSERT INTO history VALUES
    (1, 1, 1, NOW(), 'Hoàn thành', 500000);
