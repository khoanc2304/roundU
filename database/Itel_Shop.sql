-- Xóa database nếu đã tồn tại
IF DB_ID('Itel_Shop') IS NOT NULL
BEGIN
    DROP DATABASE Itel_Shop;
END
GO

-- Tạo lại database
CREATE DATABASE Itel_Shop;
GO

USE Itel_Shop;
GO

-- Xóa bảng theo thứ tự tránh lỗi ràng buộc
IF OBJECT_ID('Payment') IS NOT NULL DROP TABLE Payment;
IF OBJECT_ID('Review') IS NOT NULL DROP TABLE Review;
IF OBJECT_ID('Order_Detail') IS NOT NULL DROP TABLE Order_Detail;
IF OBJECT_ID('Orders') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('ProductDetail') IS NOT NULL DROP TABLE ProductDetail;
IF OBJECT_ID('Product') IS NOT NULL DROP TABLE Product;
IF OBJECT_ID('Attribute') IS NOT NULL DROP TABLE Attribute;
IF OBJECT_ID('Brand') IS NOT NULL DROP TABLE Brand;
IF OBJECT_ID('Category') IS NOT NULL DROP TABLE Category;
IF OBJECT_ID('Users') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('MembershipLevel') IS NOT NULL DROP TABLE MembershipLevel;
GO

-- Bắt đầu tạo bảng
CREATE TABLE MembershipLevel (
    level_id INT IDENTITY(1,1) PRIMARY KEY,
    level_name NVARCHAR(50) NOT NULL,
    discount_percent DECIMAL(5,2) NOT NULL
);

CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(100) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL,
	fullName VARCHAR(255),
    email NVARCHAR(255) UNIQUE NOT NULL,
    phone NVARCHAR(20) NULL,
	address TEXT,
    role NVARCHAR(20) CHECK (role IN ('customer', 'admin', 'staff')) DEFAULT 'customer',
    membership_level_id INT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Users_MembershipLevel FOREIGN KEY (membership_level_id) REFERENCES MembershipLevel(level_id)
);

CREATE TABLE Category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX) NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive'))
);

CREATE TABLE Brand (
    brand_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    Country VARCHAR(100),
    description NVARCHAR(MAX) NULL,
    image_url NVARCHAR(255) NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive'))
);

CREATE TABLE Attribute (
    attribute_id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    data_type NVARCHAR(50) NOT NULL,
    unit NVARCHAR(20) NULL,
    CONSTRAINT FK_Attribute_Category FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL,
    price DECIMAL(12,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    category_id INT NULL,
    brand_id INT NULL,
    image_url NVARCHAR(255) NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Product_Category FOREIGN KEY (category_id) REFERENCES Category(category_id),
    CONSTRAINT FK_Product_Brand FOREIGN KEY (brand_id) REFERENCES Brand(brand_id)
);

CREATE TABLE ProductDetail (
    detail_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    attribute_id INT NOT NULL,
    attribute_value NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_ProductDetail_Product FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE,
    CONSTRAINT FK_ProductDetail_Attribute FOREIGN KEY (attribute_id) REFERENCES Attribute(attribute_id) ON DELETE CASCADE
);

CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    status NVARCHAR(20) CHECK (status IN ('pending', 'shipped', 'completed', 'canceled')) DEFAULT 'pending',
    total_amount DECIMAL(12,2) NOT NULL,
    shipping_address NVARCHAR(500) NULL,
    CONSTRAINT FK_Order_User FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Order_Detail (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    CONSTRAINT FK_OrderDetail_Order FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT FK_OrderDetail_Product FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE Review (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating TINYINT CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment NVARCHAR(MAX) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Review_Product FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CONSTRAINT FK_Review_User FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    payment_method NVARCHAR(50) CHECK (payment_method IN ('cash', 'banking', 'cash_on_delivery')) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    status NVARCHAR(20) CHECK (status IN ('pending', 'completed', 'failed')) DEFAULT 'pending',
    CONSTRAINT FK_Payment_Order FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


--Chèn dữ liệu--
/*
1- MembershipLevels
2- Categories
3- Brands
4- Users
5- Attributes
6- Product
7- Promotion
8- Orders
9- Order_Details
10- Reviews
11- Payments
*/

--Membership
INSERT INTO MembershipLevel (level_name, discount_percent)
VALUES
('Đồng', 3.00),
('Bạc', 5.00),
('Vàng', 7.00),
('Kim Cương', 10.00);

--User
INSERT INTO Users (username, password, fullName, email, phone, address, role, membership_level_id)
VALUES
('khoa', 'khoa', 'Nguyen Khoa', 'khoa@gmail.com', '0123456789', '123 Đường A, TP.HCM', 'admin', 4),
('nam', 'nam', 'Nguyen Nam', 'nam@gmail.com', '0987654321', '456 Đường B, Hà Nội', 'admin', 4),
('vinh', 'vinh', 'Nguyen Vinh', 'vinh@gmail.com', '0912345678', '789 Đường C, Đà Nẵng', 'admin', 4),
('hieu', 'hieu', 'Ngo Hieu', 'hieu@gmail.com', '0909876543', '12 Đường D, Hải Phòng', 'admin', 4),
('huy', 'huy', 'Huynh Huy', 'huy@gmail.com', '0999888777', '345 Đường E, Cần Thơ', 'admin', 4),
('admin', 'admin', 'ADMIN', 'admin@gmail.com', '0966778899', '678 Đường F, Huế', 'admin', 4),
('user1', 'user1', 'Dang Thi G', 'user1@gmail.com', '0933445566', '901 Đường G, Vinh', 'customer', null),
('user2', 'user2', 'Bui Van H', 'user2@gmail.com', '0977555333', '234 Đường H, Nha Trang', 'customer', 2),
('user3', 'user3', 'Nguyen Thi I', 'user3@gmail.com', '0988123456', '567 Đường I, Phan Thiết', 'customer', 3),
('user4', 'user4', 'Tran Van J', 'user4@gmail.com', '0911222333', '890 Đường J, Quy Nhơn', 'customer', 4),
('user5', 'user5', 'Le Thi K', 'user5@gmail.com', '0933555777', '123 Đường K, Buôn Ma Thuột', 'customer', 3),
('user6', 'user6', 'Pham Van L', 'user6@gmail.com', '0922333444', '456 Đường L, Vũng Tàu', 'customer', 2),
('user7', 'user7', 'Hoang Thi M', 'user7@gmail.com', '0977666555', '789 Đường M, Pleiku', 'customer', 1),
('user8', 'user8', 'Vu Van N', 'user8@gmail.com', '0966443322', '123 Đường N, Cao Lãnh', 'customer', null),
('user9', 'user9', 'Dang Thi O', 'user9@gmail.com', '0955777999', '456 Đường O, Tây Ninh', 'customer', null);

--Category
INSERT INTO Category (name, description)
VALUES
('Laptop', 'Portable computers with balanced performance and mobility'), --id 1
('Phone', 'Smart mobile devices used for communication, apps, and media'), --id 2
('Mouse', 'Input device used to control the pointer and navigate interfaces'), --id 3
('Headphones', 'Audio device worn over ears for personal listening'), --id 4
('Keyboard', 'Input device consisting of keys used to type text or commands'); --id 5

--Brand
INSERT INTO Brand (name, Country, description, image_url) VALUES
-- Laptop
('Apple', 'USA', 'MacBook series & iPhone series & AirPods', 'https://i.pinimg.com/736x/d8/8f/32/d88f3243954f744b4b212ef93581a124.jpg'), --id:1
('Dell', 'USA', 'Inspiron, XPS, Alienware', 'https://i.pinimg.com/736x/ea/04/68/ea0468c87f90885acbdb057accfa7eeb.jpg'), --id:2
('HP', 'USA', 'Pavilion, Spectre, Envy', 'https://i.pinimg.com/736x/cd/06/95/cd0695814f175babfbcefe0e1b96fa38.jpg'), --id:3
('Lenovo', 'China', 'ThinkPad, IdeaPad, Legion', 'https://i.pinimg.com/736x/28/41/19/284119f1dee57574f8ff5fd308d7a74b.jpg'), --id:4
('Asus', 'Taiwan', 'ZenBook, ROG, TUF', 'https://i.pinimg.com/736x/86/e0/50/86e05042b9fae73b0c12517ee5cef558.jpg'), --id:5
('Acer', 'Taiwan', 'Aspire, Nitro, Swift', 'https://i.pinimg.com/736x/69/47/b9/6947b9b5bef862437e5313aa78442a1d.jpg'), --id:6
('MSI', 'Taiwan', 'Gaming laptops', 'https://i.pinimg.com/736x/50/37/85/50378573ae6e10c00c0c63eb0edf98c8.jpg'), --id:7
('Gigabyte', 'Taiwan', 'AERO, AORUS', 'https://i.pinimg.com/736x/55/f3/42/55f342fcf288825e3e3a9752eb503897.jpg'), --id:8

-- Phone
('Samsung', 'South Korea', 'Galaxy series & Headphones', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Samsung_Logo.svg/1000px-Samsung_Logo.svg.png'), --id:9
('Xiaomi', 'China', 'Redmi, Mi, Poco', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Xiaomi_logo_%282021-%29.svg/1200px-Xiaomi_logo_%282021-%29.svg.png'), --id:10
('OPPO', 'China', 'Reno, A series', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/OPPO_LOGO_2019.svg/1280px-OPPO_LOGO_2019.svg.png'), --id:11
('Vivo', 'China', 'X series, Y series', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Vivo_logo_2019.svg/1200px-Vivo_logo_2019.svg.png'), --id:12
('Realme', 'China', 'Narzo, GT series', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Realme_logo_SVG.svg/1200px-Realme_logo_SVG.svg.png'), --id:13
('Nokia', 'Finland', 'Android One phones', 'https://1000logos.net/wp-content/uploads/2017/03/Nokia-Logo.jpg'), --id:14

-- Accessories
('Logitech', 'Switzerland', 'Famous for mice, keyboards, and headphones for both office and gaming.', 'https://upload.wikimedia.org/wikipedia/commons/1/17/Logitech_logo.svg'), --id:15
('Razer', 'USA/Singapore', 'Specializes in RGB gaming gear: keyboards, mice, headphones.', 'https://upload.wikimedia.org/wikipedia/vi/a/a1/Razer_snake_logo.png'), --id:16
('Corsair', 'USA', 'Gaming peripherals manufacturer: keyboards, mice, headsets.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSK7HxPKivG9Zq16GNTcdKQDVg60OYQnP3QYw&s'), --id:17
('SteelSeries', 'Denmark', 'eSports-focused brand with gaming mice, keyboards, and headphones.', 'https://upload.wikimedia.org/wikipedia/en/7/7f/Steelseries-logo.png'), --id:18
('HyperX', 'USA', 'Best known for gaming headsets, also offers mice and keyboards.', 'https://1000logos.net/wp-content/uploads/2021/04/HyperX-logo.jpg'); --id:19



--Attribute
INSERT INTO Attribute (category_id, name, data_type, unit)
VALUES
--laptop (cate 1)
(1, 'CPU', 'text', NULL), --id 1
(1, 'RAM', 'number', 'GB'), --id 2
(1, 'Storage', 'number', 'GB'), --id 3
(1, 'Screen Size', 'number', 'inch'), --id 4
(1, 'Weight', 'number', 'kg'), --id 5
(1, 'Operating System', 'text', NULL), --id 6
(1, 'GPU', 'text', NULL), --id 7

--phone (cate 2)
(2, 'CPU', 'text', NULL), --id 8
(2, 'RAM', 'number', 'GB'), --id 9
(2, 'Storage', 'number', 'GB'), --id 10
(2, 'Screen Size', 'number', 'inch'), --id 11
(2, 'Battery Capacity', 'number', 'mAh'), --id 12
(2, 'Camera Resolution', 'number', 'MP'), --id 13
(2, 'Operating System', 'text', NULL), --id 14

--chuột (cate 3)
(3, 'DPI', 'number', NULL), --id 15
(3, 'Connection Type', 'text', NULL),   --id 16       -- Wired / Wireless / Bluetooth
(3, 'Buttons', 'number', NULL), --id 17
(3, 'Sensor Type', 'text', NULL),   --id 18          -- Optical / Laser
(3, 'Polling Rate', 'number', 'Hz'), --id 19
(3, 'Battery Life', 'text', NULL), --id 20           -- e.g., "70 hours"
(3, 'Weight', 'number', 'g'), --id 21

-- tai nghe (cate 4)
(4, 'Driver Size', 'number', 'mm'), --id 22
(4, 'Connection Type', 'text', NULL), --id 23        -- 3.5mm / Bluetooth / USB-C
(4, 'Microphone', 'boolean', NULL), --id 24
(4, 'Noise Cancelling', 'boolean', NULL), --id 25
(4, 'Battery Life', 'text', NULL), --id 26            -- e.g., "20 hours"
(4, 'Frequency Response', 'text', 'Hz'), --id 27      -- e.g., "20Hz - 20kHz"
(4, 'Weight', 'number', 'g'), --id 28

-- bàn phím (cate 5)
(5, 'Key Layout', 'text', NULL), --id 29             -- ANSI, ISO, TKL, 60%, 75%...
(5, 'Switch Type', 'text', NULL), --id 30             -- Mechanical, Membrane, Optical
(5, 'Connection Type', 'text', NULL), --id 31        -- Wired / Wireless / Bluetooth
(5, 'Backlight', 'text', NULL), --id 32              -- RGB / Single color / None
(5, 'Battery Life', 'text', NULL),  --id 33          -- Nếu dùng pin
(5, 'Weight', 'number', 'g'), --id 34
(5, 'Dimensions', 'text', 'cm'); --id 35

--Products
INSERT INTO Product (name, description, price, stock_quantity, category_id, brand_id, image_url)
VALUES
('MacBook Pro 13.3 i5 2.3GHz', 'Ultrabook with Retina Display and Intel i5', 1339.69, 50, 1, 1, 'https://pos.nvncdn.com/ac3ac6-57746/ps/20200131_zOQ7D6fd6mK0XMTE1rTBwWXO.jpg'),
('Macbook Air 13.3 i5 1.8GHz 128GB', 'Lightweight Ultrabook with macOS', 898.94, 40, 1, 1, 'https://product.hstatic.net/200000373523/product/34925_laptop_apple_macbook_air_m0uu3_128gb__2017___silver__1_1_5308f3368d8245849dbe6c6c96a280cd_grande.jpg'),
('HP 250 G6 i5 7200U', 'Notebook for everyday use', 575.00, 60, 1, 3, 'https://anphat.com.vn/media/product/25740_laptop_hp_250_g6_2xr76pa_1.jpg'),
('MacBook Pro 15.4 i7 2.7GHz', 'High-performance Ultrabook with Radeon Pro', 2537.45, 20, 1, 1, 'https://i.ebayimg.com/images/g/orgAAOSwIfRlJr97/s-l1200.jpg'),
('MacBook Pro 13.3 i5 3.1GHz', 'Ultrabook with Retina Display and Intel i5', 1803.60, 30, 1, 1, 'https://pos.nvncdn.com/9d42d7-25235/ps/20210914_SdENq683RC0S9ZBVv5hhHgjX.jpg'),
('MacBook Pro 15.4 i7 2.2GHz', 'Ultrabook with Intel Iris Pro Graphics', 2139.97, 25, 1, 1, 'https://bizweb.dktcdn.net/100/046/882/products/macbook-mc723-thiet-ke-sang-trong-hien-dai.png?v=1487564393597'),
('Macbook Air 13.3 i5 1.8GHz 256GB', 'Ultrabook with extended storage', 1158.70, 35, 1, 1, 'https://cdn.tgdd.vn/Products/Images/44/106880/apple-macbook-air-mqd42sa-a-i5-5350u-8gb-256gb-bac-450x300-450x300.jpg'),
('ZenBook UX430UN', 'Ultrabook with Nvidia GeForce MX150', 1495.00, 45, 1, 5, 'https://ducanhcomputer.com/uploads/san-pham/2019_03/gv096t.jpg'),
('Swift 3', 'Ultrabook with IPS display', 770.00, 50, 1, 6, 'https://cdn.tgdd.vn/Products/Images/44/269313/acer-swift-3-sf314-511-55qe-i5-nxabnsv003-120122-022600-600x600.jpg'),
('HP 250 G6 i3 6006U', 'Affordable Notebook with Intel i3', 344.99, 70, 1, 3, 'https://product.hstatic.net/1000296652/product/kk_1a586f1bece145bd8a4cbfc80f4c63f2_7a0b155ca637451e81f6e55005c1f568.jpg'),
('MacBook Pro 15.4 i7 2.8GHz', 'Ultrabook with AMD Radeon Pro 555', 2439.97, 20, 1, 1, 'https://ttcenter.com.vn/uploads/product/8blddpkb-657-macbook-pro-2017-15-inch-i7-16gb-512gb-touchbar.jpg'),
('Inspiron 3567 i3 6006U', 'Notebook with Full HD display', 498.90, 60, 1, 2, 'https://cdn.tgdd.vn/Products/Images/44/91260/dell-inspiron-3567-i3-6006u-ava-600x600.jpg'),
('MacBook 12', 'Compact Ultrabook with Retina Display', 1262.40, 30, 1, 1, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/m/a/macbook-mnyf2-1.jpg'),
('Inspiron 3567 i7 7500U', 'Notebook with Intel i7 and AMD Radeon', 745.00, 50, 1, 2, 'https://product.hstatic.net/200000680839/product/dell_15-35xx_6a55b1fcb5c945eb8ca0a3be0a6a79a7_1024x1024.png'),
('MacBook Pro 15.4 i7 2.9GHz', 'Ultrabook with AMD Radeon Pro 560', 2858.00, 15, 1, 1, 'https://www.devicerefresh.com/cdn/shop/files/ba847be049015b2567b7de577c6b2e5a_417559ff-902c-485a-8e3b-7e56941e7195_800x.jpg?v=1720026879'),
('IdeaPad 320-15IKB', 'Notebook with Nvidia GeForce 940MX', 499.00, 55, 1, 4, 'https://maytinhcdc.vn/media/product/919_148.jpg'),
('XPS 13 i5 8250U', 'Ultrabook with Touchscreen display', 979.00, 40, 1, 2, 'https://laptopmd.vn/userdata/6449/wp-content/uploads/2022/10/37535-37521-36346-35154-dell-xps-13-9350-core-i5-6200u-2-2ghz-ram-4gb-256gb-ssd-13fhd-win-10-33563-1.png'),
('Vivobook E200HA', 'Lightweight Netbook for basic tasks', 191.90, 80, 1, 5, 'https://channel.vcmedia.vn/prupload/164/2016/03/img20160321235342405.jpg'),
('Legion Y520-15IKBN', 'Gaming laptop with GTX 1050', 999.00, 25, 1, 4, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBqNiZbjTx6WMnyBwiedE8HsyA4rTOSKizig&s'),
('HP 255 G6', 'Budget Notebook with AMD processor', 258.00, 65, 1, 3, 'https://www.notebookcheck.net/uploads/tx_nbc2/1503610-1_04.jpg'),
('Inspiron 5379', '2 in 1 Convertible with touchscreen', 819.00, 35, 1, 2, 'https://cohotech.vn/wp-content/uploads/2019/05/Laptop-Dell-Insprion-2in1-i5379-768x768.jpg'),
('HP 15-BS101nv', 'Ultrabook with Intel i7 and Full HD', 659.00, 45, 1, 3, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS63T43yHWJ7H24fL_MxWrZ9RSJrLB2R4FdUg&s'),
('Inspiron 5570', 'Notebook with AMD Radeon 530', 800.00, 50, 1, 2, 'https://bizweb.dktcdn.net/thumb/grande/100/244/033/products/0104539-dell-inspiron-5570-15-5000-series-i7-8550u-156-full-hd-notebook-600-jpeg-63c6b10e-389a-4f93-86b0-94b9da7826f8-93d7976c-e12d-4172-9590-19177f9d5c98.jpg?v=1561955966243'),
('Latitude 5590', 'Ultrabook with dual SSD storage', 1298.00, 30, 1, 2, 'https://www.laptopvip.vn/images/companies/1/032018/Dell/Dell-Latitude-5590-8th-intel-core-review-3.png'),
('ProBook 470', 'Notebook with 17.3-inch display', 896.00, 40, 1, 3, 'https://www.laptopvip.vn/images/ab__webp/thumbnails/800/800/detailed/19/Hp_Probook_470_03.png.webp'),
('HP 17-ak001nv', 'Notebook with AMD Radeon 530', 439.00, 50, 1, 5, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUphPMt_I0fN15npz0LnWIQuqMXNp_Ayt9bw&s'),
('XPS 13 i7 8550U', 'Ultrabook with Quad HD+ display', 1869.00, 25, 1, 2, 'https://product.hstatic.net/200000553329/product/xps_9370_core_i7_ram_16g_ssd_512g_laptopone_8a38fc7aa6e44968acf94d5f4a4b497b.jpg'),
('IdeaPad 120S-14IAP', 'Notebook with Intel Celeron', 249.00, 70, 1, 4, 'https://cdn.tgdd.vn/Products/Images/44/194252/lenovo-ideapad-120s-14iap-n4200-4gb-64gb-win10-81-15-600x600.jpg'),
('Inspiron 5770', 'Notebook with dual storage', 979.00, 45, 1, 2, 'https://laptopxachtay.com.vn/kcfinder/upload/images/Laptop/Dell/5000/5570.JPG'),
('ProBook 450', 'Notebook with Nvidia GeForce 930MX', 879.00, 40, 1, 3, 'https://cdn.tgdd.vn/Products/Images/44/315906/hp-probook-450-g10-i5-873d1pa-1-1-750x500.jpg'),
('X540UA-DM186', 'Notebook with Full HD and Linux', 389.00, 55, 1, 5, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLy7FEzOOzczRnST3NIwTvAjYA5dTdpm5Ccg&s'),
('Inspiron 7577', 'Gaming laptop with GTX 1060', 1499.00, 20, 1, 2, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/i/n/inspiron-15-gaming-7577-70158745.jpg'),
('X542UQ-GO005', 'Notebook with Nvidia GeForce 940MX', 522.99, 50, 1, 5, 'https://cdn.bdstall.com/product-image/giant_62782.jpg'),
('Aspire A515-51G', 'Notebook with IPS display', 682.00, 45, 1, 6, 'https://cdn.tgdd.vn/Products/Images/44/111120/acer-aspire-a515-51g-52zs-i5-7200u-1-450x300.jpg'),
('Inspiron 7773', '2 in 1 Convertible with Nvidia GeForce', 999.00, 30, 1, 2, 'https://www.notebookcheck.net/uploads/tx_nbc2/DellInspiron17-7773__1_.JPG'),
('MacBook Pro 13.3 i5 2.0GHz', 'Ultrabook with Intel Iris Graphics', 1419.00, 35, 1, 1, 'https://bizweb.dktcdn.net/thumb/grande/100/318/659/products/8836101-jpeg.jpg?v=1536732696847'),
('IdeaPad 320-15ISK', 'Notebook with Intel i3', 369.00, 60, 1, 4, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9C1N0Ucdv6__RNBFCARgxZKI_g4fo2f7M2w&s'),
('Rog Strix', 'Gaming laptop with AMD Ryzen', 1299.00, 25, 1, 5, 'https://bizweb.dktcdn.net/100/512/769/files/1-d4dfca93-7ffd-4be2-8d78-7be1a8e2e693.jpg?v=1716189372866'),
('Inspiron 3567 i5 7200U', 'Notebook with AMD Radeon R5 M430', 639.00, 50, 1, 2, 'https://cdn.tgdd.vn/Products/Images/44/156861/dell-inspiron-3567-i5-7200u-70119158-450-300-600x600.png'),
('Logitech MX Master 3S', N'Chuột không dây cao cấp với cảm biến 8000 DPI, thiết kế công thái học, phù hợp cho văn phòng và sáng tạo', 2500000.00, 50, 3, 15, 'https://d28jzcg6y4v9j1.cloudfront.net/chuot_logitech_mx_3s_co_thiet_ke_chuan_cong_thai_hoc_1719808317791.jpg'),
('ASUS ROG Strix Scope NX TKL Deluxe', N'Bàn phím cơ gaming TKL với switch ASUS NX Red, đèn RGB, thiết kế nhỏ gọn', 3500000.00, 30, 5, 5, 'https://minhancomputercdn.com/media/product/10303_b__n_ph__m_c___asus_rog_strix_scope_nx_tkl_deluxe_1.jpg'),
('Logitech Combo Touch iPad Pro', N'Touchpad và bàn phím tích hợp cho iPad Pro 11-inch, kết nối Bluetooth, hỗ trợ đa góc nghiêng', 4500000.00, 20, 5, 15, 'https://resource.logitech.com/w_1200,h_630,c_limit,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/logitech/en/products/mobility/combo-touch-for-ipad-pro/combo-touch-ipadpro-og-image.jpg?v=1'),
('Razer DeathAdder V3 Pro', N'Chuột gaming không dây với cảm biến 30000 DPI, trọng lượng nhẹ 63g, tối ưu cho eSports', 3000000.00, 40, 3, 16, 'https://bizweb.dktcdn.net/100/329/122/products/chuot-gaming-khong-day-razer-deathadder-v3-pro-0a5a68a8-10c5-433d-bece-b49ec8828fc5.jpg?v=1746496978517'),
('Keychron K8 Pro', N'Bàn phím cơ không dây hot-swappable, switch Gateron Brown, đèn RGB, hỗ trợ macOS và Windows', 2200000.00, 25, 5, 19, 'https://s88.vn/media/lib/21-10-2023/8378_b__n_ph__m_keychron_k8_pro.jpg'),
-- MSI (brand_id=7, Laptop, category_id=1)
('MSI Katana 15', 'Gaming laptop with RTX 4070, 165Hz display', 1400.00, 25, 1, 7, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/msi_katana_15_b13v_1_9310c95515.png'),
('MSI Stealth 16', 'Thin gaming laptop with RTX 4060, 144Hz', 1600.00, 20, 1, 7, 'https://cdn.tgdd.vn/Products/Images/44/322946/msi-gaming-stealth-16-ai-studio-a1vgg-ultra-9-089vn-1-750x500.jpg'),
('MSI Prestige 14 Evo', 'Business laptop with Intel Core Ultra 7', 1200.00, 30, 1, 7, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/msi_prestige_14_ai_studio_c1u_1_5ab50baa17.png'),
('MSI Creator Z17', 'Creator laptop with RTX 3080 Ti, 4K display', 2500.00, 15, 1, 7, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/msi_creator_16_ai_studio_a1v_1_7eece4ea8a.png'),
-- Gigabyte (brand_id=8, Laptop, category_id=1)
('Gigabyte AORUS 17', 'Gaming laptop with RTX 4080, 240Hz display', 2000.00, 20, 1, 8, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2022_9_26_637998081269981032_gigabyte-gaming-aorus-17-xe5-73vn534gh-i7-12700h-rtx3070ti-den-1.jpg'),
('Gigabyte AERO 15 OLED', 'Creator laptop with 4K AMOLED, RTX 3070', 1800.00, 25, 1, 8, 'https://product.hstatic.net/200000837185/product/laptopgigabyteaero15oledkd-72s1623go_a4a4b601ef9c4bddb1bdfd1d12825bef.png'),
('Gigabyte G5', 'Budget gaming laptop with RTX 4050', 1000.00, 35, 1, 8, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2023_5_5_638188828261835779_gigabyte-gaming-g5-kf-e3vn313sh-i5-12500h-den-3.jpg'),
-- Samsung (brand_id=9, Phone, category_id=2)
('Samsung Galaxy S24 Ultra', 'Flagship phone with Snapdragon 8 Gen 3', 1200.00, 40, 2, 9, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2024_1_15_638409395342231798_samsung-galaxy-s24-ultra-xam-1.png'),
('Samsung Galaxy A35', 'Mid-range phone with Exynos 1380', 350.00, 60, 2, 9, 'https://cdn.mobilecity.vn/mobilecity-vn/images/2024/03/w300/samsung-galaxy-a35-tim.jpg.webp'),
('Samsung Galaxy Z Fold 6', 'Foldable phone with 7.6-inch AMOLED', 1800.00, 20, 2, 9, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/samsung_galaxy_z_fold6_gray_a413f785af.png'),
-- Xiaomi (brand_id=10, Phone, category_id=2)
('Xiaomi 14 Pro', 'Flagship phone with Snapdragon 8 Gen 3', 800.00, 45, 2, 10, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/xiaomi_redmi_note_14_5g_xanh_3_a16f31cae7.jpg'),
('Redmi Note 14 Pro+', 'Mid-range phone with 120Hz AMOLED', 450.00, 50, 2, 10, 'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/xiaomi_redmi_note_14_pro_plus_3_4d3d0d8993.jpg'),
('Redmi A4 5G', 'Budget phone with Snapdragon 4s Gen 2', 200.00, 80, 2, 10, 'https://cdn.viettablet.com/images/detailed/65/redmi-a4-5g.jpg'),
-- OPPO (brand_id=11, Phone, category_id=2)
('OPPO Find X7 Ultra', 'Flagship phone with Snapdragon 8 Gen 3', 850.00, 35, 2, 11, 'https://cellphones.com.vn/sforum/wp-content/uploads/2024/03/OPPO-Find-X7-Ultra-DxOMark-1.jpeg'),
('OPPO Reno 11 Pro', 'Mid-range phone with Dimensity 8200', 400.00, 50, 2, 11, 'https://cdn.tgdd.vn/Products/Images/42/314210/oppo-reno-11-pro-xam-thumb-600x600.jpg'),
('OPPO A79 5G', 'Budget phone with Dimensity 6020', 250.00, 70, 2, 11, 'https://cdn.tgdd.vn/Products/Images/42/316776/oppo-a79-5g-tim-thumb-1-2-600x600.jpg'),
-- Vivo (brand_id=12, Phone, category_id=2)
('Vivo X100 Pro', 'Flagship phone with Dimensity 9300', 900.00, 30, 2, 12, 'https://example.com/vivo_x100pro.jpg'),
('Vivo V30 Pro', 'Mid-range phone with Snapdragon 7 Gen 3', 450.00, 55, 2, 12, 'https://example.com/vivo_v30pro.jpg'),
('Vivo Y28s', 'Budget phone with Helio G85', 200.00, 75, 2, 12, 'https://example.com/vivo_y28s.jpg'),
-- Realme (brand_id=13, Phone, category_id=2)
('Realme GT 6', 'Flagship phone with Snapdragon 8s Gen 3', 600.00, 40, 2, 13, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/r/e/realme-gt-5_4__1_1.png'),
('Realme Narzo 70 Pro', 'Mid-range phone with Dimensity 7050', 300.00, 60, 2, 13, 'https://cdn.tgdd.vn/News/Thumb/1563278/Realme-Narzo-70-Pro-5G-ra-mat-voi-camera-1-inch-thiet-ke-nhu-flagship-1200x675.jpg'),
('Realme C65', 'Budget phone with Helio G85', 180.00, 80, 2, 13, 'https://cdn.tgdd.vn/Products/Images/42/323002/realme-c65-thumb-1-600x600.jpg'),
-- Nokia (brand_id=14, Phone, category_id=2)
('Nokia X30', 'Mid-range phone with Snapdragon 695', 350.00, 50, 2, 14, 'https://cdn.tgdd.vn/Files/2022/09/05/1465498/nokia_x30_5g-1_1280x720-800-resize.jpg'),
('Nokia G42', 'Budget phone with Snapdragon 480+', 220.00, 70, 2, 14, 'https://cdn.tgdd.vn/Products/Images/42/309833/nokia-g42-5g-600x600.jpg'),
('Nokia C32', 'Entry-level phone with Unisoc SC9863A', 150.00, 90, 2, 14, 'https://cdn2.fptshop.com.vn/unsafe/2023_7_14_638249469495107256_nokia-c32-dd.jpg'),
-- Corsair (brand_id=17, Keyboard/Mouse, category_id=5/3)
('Corsair K100 RGB', 'Premium mechanical keyboard with OPX switches', 200.00, 40, 5, 17, 'https://product.hstatic.net/200000722513/product/phim_2ceafcd3b71942409b4724616258c73b_d44aa7fb2a70454d99b01bc9c1117f4f_030600be83d043258c9998e4edef6924_1024x1024.png'),
('Corsair Scimitar Elite', 'Gaming mouse with 18 programmable buttons', 80.00, 60, 3, 17, 'https://product.hstatic.net/200000722513/product/chuot-game-corsair-scimitar-rgb-elite_8c3acc8779564469a84f45ec97f6f35d_941d55c2e4394ac29895a299a97b2805_1024x1024.png'),
('Corsair HS80 RGB Wireless', 'Wireless gaming headset with Dolby Atmos', 150.00, 50, 4, 17, 'https://product.hstatic.net/200000722513/product/led_rgb_wireless_ca_9011235_ap_0001_2_436fee75cc8d499e9d7619b9efef8acd_8f3b7e1f606c49b8b209034703d29d54_1024x1024.jpg'),
-- SteelSeries (brand_id=18, Keyboard/Mouse, category_id=5/3)
('SteelSeries Apex Pro TKL', 'Mechanical keyboard with adjustable switches', 180.00, 45, 5, 18, 'https://nguyencongpc.vn/media/product/17186-b--n-ph--m-c---steelseries-apex-pro-tkl-3.jpg'),
('SteelSeries Aerox 5 Wireless', 'Lightweight gaming mouse with 9 buttons', 100.00, 55, 3, 18, 'https://file.hstatic.net/1000026716/file/gearvn-chuot-steelseries-aerox-5-wireless-1_15b7fafa0f42499394e87b7b75a7ac58_grande.png'),
('SteelSeries Arctis Nova Pro', 'Wireless gaming headset with ANC', 250.00, 40, 4, 18, 'https://product.hstatic.net/200000722513/product/800_crop-scale_optimize_subsampling-2_85403d08f58e43de8be56cbc40688980_92aaa444113d491c92b3096a44a385f9_1024x1024.png'),
-- Corsair (brand_id=17, Headphone=4, Keyboard=5, Mouse=3)
('Corsair Virtuoso RGB Wireless', 'Premium wireless gaming headset with 7.1 surround', 180.00, 35, 4, 17, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2021_11_9_637720718333788887_tai-nghe-khong-day-corsair-virtuoso-rgb-den-1.jpg'),
('Corsair K70 RGB TKL', 'Compact mechanical keyboard with Cherry MX Red', 130.00, 40, 5, 17, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/ban-phim-co-corsair-k70-rgb-champion-series.png?v=1698911457230'),
('Corsair Dark Core RGB Pro', 'Wireless gaming mouse with 18K DPI', 90.00, 50, 3, 17, 'https://product.hstatic.net/200000722513/product/-core-rgb-pro-wireless-gaming-mouse-1_b647046fefda46f7a86b1151dd4f138c_d2a85a2e839a4e60b6d790d65862053b.png'),
-- SteelSeries (brand_id=18, Headphone=4, Keyboard=5, Mouse=3)
('SteelSeries Arctis 7+', 'Wireless gaming headset with 30-hour battery', 170.00, 45, 4, 18, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2024_2_28_638447295329987245_tai-nghe-bluetooth-choang-dau-steelseries-arctis-nova-7-1.jpg'),
('SteelSeries Apex 7', 'Full-size mechanical keyboard with OLED display', 160.00, 30, 5, 18, 'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/ban_phim_co_gaming_co_day_apex_7_tkl_red_switch_steelseries_3_5f971f0236.jpg'),
('SteelSeries Rival 5', 'Versatile gaming mouse with 9 buttons', 60.00, 60, 3, 18, 'https://owlgaming.vn/wp-content/uploads/2024/06/chuot-steelseries-rival-5-3.jpg'),
-- MSI (brand_id=7, Keyboard=5, Mouse=3)
('MSI Vigor GK71 Sonic', 'Mechanical keyboard with Sonic Red switches', 120.00, 35, 5, 7, 'https://asset.msi.com/resize/image/global/product/product_16415411303a4f3ad1ddc39e1b18dd3904a62e4767.png62405b38c58fe0f07fcef2367d8a9ba1/600.png'),
('MSI Clutch GM41 Lightweight', 'Lightweight gaming mouse with 16K DPI', 50.00, 55, 3, 7, 'https://storage-asset.msi.com/global/picture/image/feature/mouse/GM41/images/kv_mouse.png'),
-- Gigabyte (brand_id=8, Keyboard=5, Mouse=3)
('Gigabyte AORUS K9 Optical', 'Optical mechanical keyboard with Flaretech switches', 140.00, 30, 5, 8, 'https://www.gigabyte.com/FileUpload/Global/KeyFeature/845/images/gallery/p001.jpg'),
('Gigabyte AORUS M5', 'Gaming mouse with 16K DPI and RGB', 70.00, 50, 3, 8, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbtPjPHYQbr2ZOQOxuYihY92SSh_0Kued3eQ&s'),
-- Xiaomi (brand_id=10, Headphone=4)
('Xiaomi Buds 5', 'True wireless earbuds with ANC', 80.00, 70, 4, 10, 'https://i02.appmifile.com/mi-com-product/fly-birds/xiaomi-buds-5/m/76caeb0cd8ff39e3df393e65a6a93535.jpg'),
('Redmi Buds 6 Active', 'Budget wireless earbuds with 30-hour battery', 40.00, 100, 4, 10, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/t/a/tai-nghe-bluetooth-xiaomi-redmi-buds-6-active.png'),
-- OPPO (brand_id=11, Headphone=4)
('OPPO Enco X3', 'Premium wireless earbuds with LHDC audio', 100.00, 60, 4, 11, 'https://cdn-media.sforum.vn/storage/app/media/trannghia/Oppo-Enco-X3-ra-mat-2.jpg'),
('OPPO Enco Air 4', 'Mid-range wireless earbuds with ANC', 60.00, 80, 4, 11, 'https://image.oppo.com/content/dam/oppo/common/mkt/v2-2/oppo-enco-air4-pro-en/specs/Specs_1574_720_Two-color.png'),
-- Vivo (brand_id=12, Headphone=4)
('Vivo TWS 4', 'Wireless earbuds with Hi-Fi audio', 90.00, 65, 4, 12, 'https://down-vn.img.susercontent.com/file/cn-11134207-7ras8-m2svswyici5j78'),
('Vivo TWS Air 2', 'Budget wireless earbuds with 25-hour battery', 50.00, 90, 4, 12, 'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/vivo-tws-air-2-2.jpeg'),
-- Realme (brand_id=13, Headphone=4)
('Realme Buds Air 6 Pro', 'Wireless earbuds with 50dB ANC', 80.00, 70, 4, 13, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rd6w-lv325z0e6pas45'),
('Realme Buds T300', 'Budget wireless earbuds with 30-hour battery', 40.00, 100, 4, 13, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/t/a/tai-nghe-khong-day-realme-buds-t300_4_.png'),
-- Nokia (brand_id=14, Headphone=4)
('Nokia Clarity Earbuds 2 Pro', 'Wireless earbuds with ANC', 70.00, 75, 4, 14, 'https://images.ctfassets.net/wcfotm6rrl7u/2Z3VgGVzRvyp79rtRQ2VOX/f1f855d234ba7531d9862d9f52b66237/nokia-TWS-852W-black-angled.png?h=1000&fm=png&fl=png8'),
('Nokia Go Earbuds+', 'Budget wireless earbuds with 20-hour battery', 30.00, 110, 4, 14, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQXAiBYVepZP2H0uEnAhzU04JdKsZ78_N5VA&s');

--ProductDetail
INSERT INTO ProductDetail (product_id, attribute_id, attribute_value)
VALUES
-- MacBook Pro 13.3 i5 2.3GHz (product_id=1, category_id=1)
(1, 1, 'Intel Core i5 2.3GHz'), -- CPU
(1, 2, '8'), -- RAM (GB)
(1, 3, '128'), -- Storage (GB)
(1, 4, '13.3'), -- Screen Size (inch)
(1, 5, '1.37'), -- Weight (kg)
(1, 6, 'macOS'), -- Operating System
(1, 7, 'Intel Iris Plus Graphics 640'), -- GPU
-- MacBook Air 13.3 i5 1.8GHz 128GB (product_id=2, category_id=1)
(2, 1, 'Intel Core i5 1.8GHz'), -- CPU
(2, 2, '8'), -- RAM (GB)
(2, 3, '128'), -- Storage (GB)
(2, 4, '13.3'), -- Screen Size (inch)
(2, 5, '1.34'), -- Weight (kg)
(2, 6, 'macOS'), -- Operating System
(2, 7, 'Intel HD Graphics 6000'), -- GPU
-- HP 250 G6 i5 7200U (product_id=3, category_id=1)
(3, 1, 'Intel Core i5 7200U 2.5GHz'), -- CPU
(3, 2, '8'), -- RAM (GB)
(3, 3, '256'), -- Storage (GB)
(3, 4, '15.6'), -- Screen Size (inch)
(3, 5, '1.86'), -- Weight (kg)
(3, 6, 'No OS'), -- Operating System
(3, 7, 'Intel HD Graphics 620'), -- GPU
-- MacBook Pro 15.4 i7 2.7GHz (product_id=4, category_id=1)
(4, 1, 'Intel Core i7 2.7GHz'), -- CPU
(4, 2, '16'), -- RAM (GB)
(4, 3, '512'), -- Storage (GB)
(4, 4, '15.4'), -- Screen Size (inch)
(4, 5, '1.83'), -- Weight (kg)
(4, 6, 'macOS'), -- Operating System
(4, 7, 'AMD Radeon Pro 455'), -- GPU
-- MacBook Pro 13.4 i5 3.1GHz (product_id=5, category_id=1)
(5, 1, 'Intel Core i5 3.1GHz'), -- CPU
(5, 2, '8'), -- RAM (GB)
(5, 3, '256'), -- Storage (GB)
(5, 4, '13.3'), -- Screen Size (inch)
(5, 5, '1.37'), -- Weight (kg)
(5, 6, 'macOS'), -- Operating System
(5, 7, 'Intel Iris Plus Graphics 650'), -- GPU
-- MacBook Pro 15.4 i7 2.2GHz (product_id=6, category_id=1)
(6, 1, 'Intel Core i7 2.2GHz'), -- CPU
(6, 2, '16'), -- RAM (GB)
(6, 3, '256'), -- Storage (GB)
(6, 4, '15.4'), -- Screen Size (inch)
(6, 5, '2.04'), -- Weight (kg)
(6, 6, 'macOS'), -- Operating System
(6, 7, 'Intel Iris Pro Graphics'), -- GPU
-- MacBook Air 13.3 i5 1.8GHz 256GB (product_id=7, category_id=1)
(7, 1, 'Intel Core i5 1.8GHz'), -- CPU
(7, 2, '8'), -- RAM (GB)
(7, 3, '256'), -- Storage (GB)
(7, 4, '13.3'), -- Screen Size (inch)
(7, 5, '1.34'), -- Weight (g)
(7, 6, 'macOS'), -- Operating System
(7, 7, 'Intel HD Graphics 6000'), -- GPU
-- ZenBook UX430UN (product_id=8, category_id=1)
(8, 1, 'Intel Core i7 8550U 1.8GHz'), -- CPU
(8, 2, '16'), -- RAM (GB)
(8, 3, '512'), -- Storage (GB)
(8, 4, '14.0'), -- Screen Size (inch)
(8, 5, '1.25'), -- Weight (kg)
(8, 6, 'Windows 10'), -- Operating System
(8, 7, 'Nvidia GeForce MX150'), -- GPU
-- Swift 3 (product_id=9, category_id=1)
(9, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(9, 2, '8'), -- RAM (GB)
(9, 3, '256'), -- Storage (GB)
(9, 4, '14.0'), -- Screen Size (inch)
(9, 5, '1.6'), -- Weight (kg)
(9, 6, 'Windows 10'), -- Operating System
(9, 7, 'Intel UHD Graphics 620'), -- GPU
-- HP 250 G6 i3 6006U (product_id=10, category_id=1)
(10, 1, 'Intel Core i3 6006U 2GHz'), -- CPU
(10, 2, '4'), -- RAM (GB)
(10, 3, '500'), -- Storage (GB)
(10, 4, '15.6'), -- Screen Size (inch)
(10, 5, '1.86'), -- Weight (kg)
(10, 6, 'No OS'), -- Operating System
(10, 7, 'Intel HD Graphics 520'), -- GPU
-- MacBook Pro 15.4 i7 2.8GHz (product_id=11, category_id=1)
(11, 1, 'Intel Core i7 2.8GHz'), -- CPU
(11, 2, '16'), -- RAM (GB)
(11, 3, '256'), -- Storage (GB)
(11, 4, '15.4'), -- Screen Size (inch)
(11, 5, '1.83'), -- Weight (kg)
(11, 6, 'macOS'), -- Operating System
(11, 7, 'AMD Radeon Pro 555'), -- GPU
-- Inspiron 3567 i3 6006U (product_id=12, category_id=1)
(12, 1, 'Intel Core i3 6006U 2GHz'), -- CPU
(12, 2, '4'), -- RAM (GB)
(12, 3, '256'), -- Storage (GB)
(12, 4, '15.6'), -- Screen Size (inch)
(12, 5, '2.2'), -- Weight (kg)
(12, 6, 'Windows 10'), -- Operating System
(12, 7, 'Intel HD Graphics 520'), -- GPU
-- MacBook 12 (product_id=13, category_id=1)
(13, 1, 'Intel Core M m3 m3 1.2GHz'), -- CPU
(13, 2, '8'), -- RAM (GB)
(13, 3, '256'), -- Storage (GB)
(13, 4, '12.0'), -- Screen Size (inch)
(13, 5, '0.92'), -- Weight (kg)
(13, 6, 'macOS'), -- Operating System
(13, 7, 'Intel HD Graphics 615'), -- GPU
-- Inspiron 3567 i7 7500U (product_id=14, category_id=1)
(14, 1, 'Intel Core i7 7500U 2.7GHz'), -- CPU
(14, 2, '8'), -- RAM (GB)
(14, 3, '256'), -- Storage (GB)
(14, 4, '15.6'), -- Screen Size (inch)
(14, 5, '2.2'), -- Weight (kg)
(14, 6, 'Windows 10'), -- Operating System
(14, 7, 'AMD Radeon R7 M440'), -- GPU
-- MacBook Pro 15.4 i7 2.9GHz (product_id=15, category_id=1)
(15, 1, 'Intel Core i7 2.9GHz'), -- CPU
(15, 2, '16'), -- RAM (GB)
(15, 3, '512'), -- Storage (GB)
(15, 4, '15.4'), -- Screen Size (inch)
(15, 5, '1.83'), -- Weight (kg)
(15, 6, 'macOS'), -- Operating System
(15, 7, 'AMD Radeon Pro 560'), -- GPU
-- IdeaPad 320-15IKB (product_id=16, category_id=1)
(16, 1, 'Intel Core i3 7100U 2.4GHz'), -- CPU
(16, 2, '8'), -- RAM (GB)
(16, 3, '1000'), -- Storage (GB)
(16, 4, '15.6'), -- Screen Size (inch)
(16, 5, '2.2'), -- Weight (kg)
(16, 6, 'No OS'), -- Operating System
(16, 7, 'Nvidia GeForce 940MX'), -- GPU
-- XPS 13 i5 8250U (product_id=17, category_id=1)
(17, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(17, 2, '8'), -- RAM (GB)
(17, 3, '128'), -- Storage (GB)
(17, 4, '13.3'), -- Screen Size (inch)
(17, 5, '1.22'), -- Weight (kg)
(17, 6, 'Windows 10'), -- Operating System
(17, 7, 'Intel UHD Graphics 620'), -- GPU
-- Vivobook E2000HA (product_id=18, category_id=1)
(18, 1, 'Intel Atom x5-Z8350'), -- CPU
(18, 2, '2'), -- RAM (GB)
(18, 3, '32'), -- Storage (GB)
(18, 4, '11.6'), -- Screen Size (inch)
(18, 5, '0.98'), -- Weight (kg)
(18, 6, 'Windows 10'), -- Operating System
(18, 7, 'Intel HD'), -- Weight
-- Legion Y520-15IKBN (product_id=19, category_id=1)
(19, 1, 'Intel Core i5 7300HQ 2.5'), -- CPU
(19, 2, '8'), -- RAM (GB)
(19, 3, '1000'), -- Storage (GB)
(19, 4, '15.6'), -- Screen Size (inch)
(19, 5, '2.5'), -- Weight (kg)
(19, 6, 'Windows 10'), -- Operating System
(19, 7, 'Nvidia GeForce GTX 1050'), -- GPU
-- HP 255 G6 (product_id=20, category_id=1)
(20, 1, 'AMD E-Series E2-9000e'), -- CPU
(20, 2, '4'), -- RAM (GB)
(20, 3, '256'), -- Storage (GB)
(20, 4, '15.6'), -- Screen Size
(20, 5, '1.86'), -- g
(20, 6, 'Windows 11'), -- g
(20, 7, 'AMD Radeon R2'),
-- Inspiron 5379 (product_id=21, category_id=1)
(21, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(21, 2, '8'), -- RAM
(21, 3, '256'), -- Storage
(21, 4, '13.3'), -- Screen Size
(21, 5, '1.62'), -- Weight
(21, 6, 'Windows 10'), -- (21, 7, 'Intel UHD Graphics 620'),
-- HP 15-BS101nv (product_id=22, category_id=1)
(22, 1, 'Intel Core i7 8550U 1.5GHz'), -- CPU
(22, 2, '8'), -- RAM
(22, 3, '256'), -- Storage
(22, 4, '15.6'), -- Screen Size
(22, 5, '1.91'), -- Weight
(22, 6, 'Windows 10'), -- Operating System
(22, 7, 'Intel UHD Graphics 620'), -- GPU
-- Inspiron 5570 (product_id=23, category_id=1)
(23, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(23, 2, '8'), -- RAM
(23, 3, '256'), -- Storage
(23, 4, '15.6'), -- Screen Size
(23, 5, '2.2'), -- Weight
(23, 6, 'Windows 10'), -- Operating System
(23, 7, 'AMD Radeon 530'), -- GPU
-- Latitude 5590 (product_id=24, category_id=1)
(24, 1, 'Intel Core i7 8650U 1.9GHz'), -- CPU
(24, 2, '8'), -- RAM
(24, 3, '512'), -- Storage
(24, 4, '15.6'), -- Screen Size
(24, 5, '1.88'), -- Weight
(24, 6, 'Windows 10'), -- Operating System
(24, 7, 'Intel UHD Graphics 620'), -- GPU
-- ProBook 470 (product_id=25, category_id=1)
(25, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(25, 2, '8'), -- RAM
(25, 3, '1000'), -- Storage
(25, 4, '17.3'), -- Screen Size
(25, 5, '2.5'), -- Weight
(25, 6, 'Windows 10'), -- Operating System
(25, 7, 'Nvidia GeForce 930MX'), -- GPU
-- HP 17-ak001nv (product_id=26, category_id=1)
(26, 1, 'AMD A6-Series 9220 2.5GHz'), -- CPU
(26, 2, '4'), -- RAM
(26, 3, '500'), -- Storage
(26, 4, '17.3'), -- Screen Size
(26, 5, '2.71'), -- Weight
(26, 6, 'Windows 10'), -- Operating System
(26, 7, 'AMD Radeon 530'), -- GPU
-- XPS 13 i7 8550U (product_id=27, category_id=1)
(27, 1, 'Intel Core i7 8550U 1.8GHz'), -- CPU
(27, 2, '16'), -- RAM
(27, 3, '512'), -- Storage
(27, 4, '13.3'), -- Screen Size
(27, 5, '1.2'), -- Weight
(27, 6, 'Windows 10'), -- Operating System
(27, 7, 'Intel UHD Graphics 620'), -- GPU
-- IdeaPad 120S-14IAP (product_id=28, category_id=1)
(28, 1, 'Intel Celeron Dual Core N3350 1.1GHz'), -- CPU
(28, 2, '4'), -- RAM
(28, 3, '64'), -- Storage
(28, 4, '14.0'), -- Screen Size
(28, 5, '1.44'), -- Weight
(28, 6, 'Windows 10'), -- Operating System
(28, 7, 'Intel HD Graphics 500'), -- GPU
-- Inspiron 5770 (product_id=29, category_id=1)
(29, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(29, 2, '8'), -- RAM
(29, 3, '1128'), -- Storage
(29, 4, '17.3'), -- Screen Size
(29, 5, '2.8'), -- Weight
(29, 6, 'Windows 10'), -- Operating System
(29, 7, 'AMD Radeon 530'), -- GPU
-- ProBook 450 (product_id=30, category_id=1)
(30, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(30, 2, '8'), -- RAM
(30, 3, '256'), -- Storage
(30, 4, '15.6'), -- Screen Size
(30, 5, '2.1'), -- Weight
(30, 6, 'Windows 10'), -- Operating System
(30, 7, 'Nvidia GeForce 930MX'), -- GPU
-- X540UA-DM186 (product_id=31, category_id=1)
(31, 1, 'Intel Core i3 6006U 2GHz'), -- CPU
(31, 2, '4'), -- RAM
(31, 3, '1000'), -- Storage
(31, 4, '15.6'), -- Screen Size
(31, 5, '2'), -- Weight
(31, 6, 'Linux'), -- Operating System
(31, 7, 'Intel HD Graphics 520'), -- GPU
-- Inspiron 7577 (product_id=32, category_id=1)
(32, 1, 'Intel Core i7 7700HQ 2.8GHz'), -- CPU
(32, 2, '16'), -- RAM
(32, 3, '256'), -- Storage
(32, 4, '15.6'), -- Screen Size
(32, 5, '2.65'), -- Weight
(32, 6, 'Windows 10'), -- Operating System
(32, 7, 'Nvidia GeForce GTX 1060'), -- GPU
-- X542UQ-GO005 (product_id=33, category_id=1)
(33, 1, 'Intel Core i5 7200U 2.5GHz'), -- CPU
(33, 2, '8'), -- RAM
(33, 3, '1000'), -- Storage
(33, 4, '15.6'), -- Screen Size
(33, 5, '2.3'), -- Weight
(33, 6, 'Linux'), -- Operating System
(33, 7, 'Nvidia GeForce 940MX'), -- GPU
-- Aspire A515-51G (product_id=34, category_id=1)
(34, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(34, 2, '4'), -- RAM
(34, 3, '256'), -- Storage
(34, 4, '15.6'), -- Screen Size
(34, 5, '2.2'), -- Weight
(34, 6, 'Windows 10'), -- Operating System
(34, 7, 'Nvidia GeForce MX150'), -- GPU
-- Inspiron 7773 (product_id=35, category_id=1)
(35, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(35, 2, '12'), -- RAM
(35, 3, '1000'), -- Storage
(35, 4, '17.3'), -- Screen Size
(35, 5, '2.77'), -- Weight
(35, 6, 'Windows 10'), -- Operating System
(35, 7, 'Nvidia GeForce 150MX'), -- GPU
-- MacBook Pro 13.3 i5 2.0GHz (product_id=36, category_id=1)
(36, 1, 'Intel Core i5 2.0GHz'), -- CPU
(36, 2, '8'), -- RAM
(36, 3, '256'), -- Storage
(36, 4, '13.3'), -- Screen Size
(36, 5, '1.37'), -- Weight
(36, 6, 'macOS'), -- Operating System
(36, 7, 'Intel Iris Graphics'), -- GPU
-- IdeaPad 320-15ISK (product_id=37, category_id=1)
(37, 1, 'Intel Core i3 6006U 2GHz'), -- CPU
(37, 2, '4'), -- RAM
(37, 3, '128'), -- Storage
(37, 4, '15.6'), -- Screen Size
(37, 5, '2.2'), -- Weight
(37, 6, 'No OS'), -- Operating System
(37, 7, 'Intel HD Graphics 520'), -- GPU
-- Rog Strix (product_id=38, category_id=1)
(38, 1, 'AMD Ryzen 1700 3GHz'), -- CPU
(38, 2, '8'), -- RAM
(38, 3, '256'), -- Storage
(38, 4, '15.6'), -- Screen Size
(38, 5, '3.2'), -- Weight
(38, 6, 'Windows 10'), -- Operating System
(38, 7, 'AMD Radeon RX 580'), -- GPU
-- Inspiron 3567 i5 7200U (product_id=39, category_id=1)
(39, 1, 'Intel Core i5 7200U 2.5GHz'), -- CPU
(39, 2, '4'), -- RAM
(39, 3, '256'), -- Storage
(39, 4, '15.6'), -- Screen Size
(39, 5, '2.3'), -- Weight
(39, 6, 'Windows 10'), -- Operating System
(39, 7, 'AMD Radeon R5 M430'), -- GPU
-- Logitech MX Master 3S (product_id=40, category_id=3)
(40, 15, '8000'), -- DPI
(40, 16, 'Wireless'), -- Connection Type
(40, 17, '7'), -- Buttons
(40, 18, 'Optical'), -- Sensor Type
(40, 19, '1000'), -- Polling Rate (Hz)
(40, 20, '400 hours'), -- Battery Life
(40, 21, '141'), -- Weight (g)
-- Razer DeathAdder V3 Pro (product_id=41, category_id=3)
(41, 15, '30000'), -- DPI
(41, 16, 'Wireless'), -- Connection Type
(41, 17, '5'), -- Buttons
(41, 18, 'Optical'), -- Sensor Type
(41, 19, '1000'), -- Polling Rate (Hz)
(41, 20, '90 hours'), -- Battery Life
(41, 21, '63'), -- Weight (g)
-- ASUS ROG Strix Scope NX TKL Deluxe (product_id=42, category_id=5)
(42, 29, 'TKL'), -- Key Layout
(42, 30, 'NX Red'), -- Switch Type
(42, 31, 'Wired'), -- Connection Type
(42, 32, 'RGB'), -- Backlight
(42, 33, 'N/A'), -- Battery Life
(42, 34, '880'), -- Weight (g)
(42, 35, '35.6x13.6'), -- Dimensions (cm)
-- Keychron K8 Pro (product_id=43, category_id=5)
(43, 29, '80%'), -- Key Layout
(43, 30, 'Gateron Brown'), -- Switch Type
(43, 31, 'Wireless'), -- Connection Type
(43, 32, 'RGB'), -- Backlight
(43, 33, '70 hours'), -- Battery Life
(43, 34, '990'), -- Weight (g)
(43, 35, '35.9x12.4'), -- Dimensions (cm)
-- Logitech Combo Touch iPad Pro (product_id=44, category_id=5)
(44, 29, 'Standard with Touchpad'), -- Key Layout
(44, 30, 'Membrane'), -- Switch Type
(44, 31, 'Bluetooth'), -- Connection Type
(44, 32, 'White'), -- Backlight
(44, 33, '20 hours'), -- Battery Life
(44, 34, '645'), -- Weight (g)
(44, 35, '25.2x19.2'), -- Dimensions (cm)
-- MSI Katana 15 (product_id=45, category_id=1)
(45, 1, 'Intel Core i7 13620H'), -- CPU
(45, 2, '16'), -- RAM (GB)
(45, 3, '1000'), -- Storage (GB)
(45, 4, '15.6'), -- Screen Size (inch)
(45, 5, '2.25'), -- Weight (kg)
(45, 6, 'Windows 11'), -- Operating System
(45, 7, 'Nvidia RTX 4070'), -- GPU
-- MSI Stealth 16 (product_id=46, category_id=1)
(46, 1, 'Intel Core i7 13700H'), -- CPU
(46, 2, '16'), -- RAM (GB)
(46, 3, '512'), -- Storage (GB)
(46, 4, '16.0'), -- Screen Size (inch)
(46, 5, '1.88'), -- Weight (kg)
(46, 6, 'Windows 11'), -- Operating System
(46, 7, 'Nvidia RTX 4060'), -- GPU
-- MSI Prestige 14 Evo (product_id=47, category_id=1)
(47, 1, 'Intel Core Ultra 7 155H'), -- CPU
(47, 2, '16'), -- RAM (GB)
(47, 3, '512'), -- Storage (GB)
(47, 4, '14.0'), -- Screen Size (inch)
(47, 5, '1.49'), -- Weight (kg)
(47, 6, 'Windows 11'), -- Operating System
(47, 7, 'Intel Arc Graphics'), -- GPU
-- MSI Creator Z17 (product_id=48, category_id=1)
(48, 1, 'Intel Core i9 13950HX'), -- CPU
(48, 2, '32'), -- RAM (GB)
(48, 3, '2000'), -- Storage (GB)
(48, 4, '17.0'), -- Screen Size (inch)
(48, 5, '2.49'), -- Weight (kg)
(48, 6, 'Windows 11 Pro'), -- Operating System
(48, 7, 'Nvidia RTX 3080 Ti'), -- GPU
-- Gigabyte AORUS 17 (product_id=49, category_id=1)
(49, 1, 'Intel Core i9 13980HX'), -- CPU
(49, 2, '32'), -- RAM (GB)
(49, 3, '1000'), -- Storage (GB)
(49, 4, '17.3'), -- Screen Size (inch)
(49, 5, '2.7'), -- Weight (kg)
(49, 6, 'Windows 11'), -- Operating System
(49, 7, 'Nvidia RTX 4080'), -- GPU
-- Gigabyte AERO 15 OLED (product_id=50, category_id=1)
(50, 1, 'Intel Core i7 13700H'), -- CPU
(50, 2, '16'), -- RAM (GB)
(50, 3, '1000'), -- Storage (GB)
(50, 4, '15.6'), -- Screen Size (inch)
(50, 5, '2.1'), -- Weight (kg)
(50, 6, 'Windows 11'), -- Operating System
(50, 7, 'Nvidia RTX 3070'), -- GPU
-- Gigabyte G5 (product_id=51, category_id=1)
(51, 1, 'Intel Core i5 13500H'), -- CPU
(51, 2, '8'), -- RAM (GB)
(51, 3, '512'), -- Storage (GB)
(51, 4, '15.6'), -- Screen Size (inch)
(51, 5, '2.08'), -- Weight (kg)
(51, 6, 'Windows 11'), -- Operating System
(51, 7, 'Nvidia RTX 4050'), -- GPU
-- Samsung Galaxy S24 Ultra (product_id=52, category_id=2)
(52, 8, 'Snapdragon 8 Gen 3'), -- CPU
(52, 9, '12'), -- RAM (GB)
(52, 10, '256'), -- Storage (GB)
(52, 11, '6.8'), -- Screen Size (inch)
(52, 12, '5000'), -- Battery Capacity (mAh)
(52, 13, '200'), -- Camera Resolution (MP)
(52, 14, 'Android 14'), -- Operating System
-- Samsung Galaxy A35 (product_id=53, category_id=2)
(53, 8, 'Exynos 1380'), -- CPU
(53, 9, '6'), -- RAM (GB)
(53, 10, '128'), -- Storage (GB)
(53, 11, '6.6'), -- Screen Size (inch)
(53, 12, '5000'), -- Battery Capacity (mAh)
(53, 13, '50'), -- Camera Resolution (MP)
(53, 14, 'Android 14'), -- Operating System
-- Samsung Galaxy Z Fold 6 (product_id=54, category_id=2)
(54, 8, 'Snapdragon 8 Gen 3'), -- CPU
(54, 9, '12'), -- RAM (GB)
(54, 10, '512'), -- Storage (GB)
(54, 11, '7.6'), -- Screen Size (inch)
(54, 12, '4400'), -- Battery Capacity (mAh)
(54, 13, '50'), -- Camera Resolution (MP)
(54, 14, 'Android 14'), -- Operating System
-- Xiaomi 14 Pro (product_id=55, category_id=2)
(55, 8, 'Snapdragon 8 Gen 3'), -- CPU
(55, 9, '8'), -- RAM (GB)
(55, 10, '256'), -- Storage (GB)
(55, 11, '6.73'), -- Screen Size (inch)
(55, 12, '4880'), -- Battery Capacity (mAh)
(55, 13, '50'), -- Camera Resolution (MP)
(55, 14, 'Android 14'), -- Operating System
-- Redmi Note 14 Pro+ (product_id=56, category_id=2)
(56, 8, 'Dimensity 7300 Ultra'), -- CPU
(56, 9, '8'), -- RAM (GB)
(56, 10, '256'), -- Storage (GB)
(56, 11, '6.67'), -- Screen Size (inch)
(56, 12, '6200'), -- Battery Capacity (mAh)
(56, 13, '50'), -- Camera Resolution (MP)
(56, 14, 'Android 14'), -- Operating System
-- Redmi A4 5G (product_id=57, category_id=2)
(57, 8, 'Snapdragon 4s Gen 2'), -- CPU
(57, 9, '4'), -- RAM (GB)
(57, 10, '64'), -- Storage (GB)
(57, 11, '6.67'), -- Screen Size (inch)
(57, 12, '5000'), -- Battery Capacity (mAh)
(57, 13, '13'), -- Camera Resolution (MP)
(57, 14, 'Android 14'), -- Operating System
-- OPPO Find X7 Ultra (product_id=58, category_id=2)
(58, 8, 'Snapdragon 8 Gen 3'), -- CPU
(58, 9, '16'), -- RAM (GB)
(58, 10, '512'), -- Storage (GB)
(58, 11, '6.82'), -- Screen Size (inch)
(58, 12, '5000'), -- Battery Capacity (mAh)
(58, 13, '50'), -- Camera Resolution (MP)
(58, 14, 'Android 14'), -- Operating System
-- OPPO Reno 11 Pro (product_id=59, category_id=2)
(59, 8, 'Dimensity 8200'), -- CPU
(59, 9, '8'), -- RAM (GB)
(59, 10, '256'), -- Storage (GB)
(59, 11, '6.74'), -- Screen Size (inch)
(59, 12, '4700'), -- Battery Capacity (mAh)
(59, 13, '50'), -- Camera Resolution (MP)
(59, 14, 'Android 14'), -- Operating System
-- OPPO A79 5G (product_id=60, category_id=2)
(60, 8, 'Dimensity 6020'), -- CPU
(60, 9, '4'), -- RAM (GB)
(60, 10, '128'), -- Storage (GB)
(60, 11, '6.72'), -- Screen Size (inch)
(60, 12, '5000'), -- Battery Capacity (mAh)
(60, 13, '50'), -- Camera Resolution (MP)
(60, 14, 'Android 13'), -- Operating System
-- Vivo X100 Pro (product_id=61, category_id=2)
(61, 8, 'Dimensity 9300'), -- CPU
(61, 9, '16'), -- RAM (GB)
(61, 10, '512'), -- Storage (GB)
(61, 11, '6.78'), -- Screen Size (inch)
(61, 12, '5400'), -- Battery Capacity (mAh)
(61, 13, '50'), -- Camera Resolution (MP)
(61, 14, 'Android 14'), -- Operating System
-- Vivo V30 Pro (product_id=62, category_id=2)
(62, 8, 'Snapdragon 7 Gen 3'), -- CPU
(62, 9, '8'), -- RAM (GB)
(62, 10, '256'), -- Storage (GB)
(62, 11, '6.78'), -- Screen Size (inch)
(62, 12, '5000'), -- Battery Capacity (mAh)
(62, 13, '50'), -- Camera Resolution (MP)
(62, 14, 'Android 14'), -- Operating System
-- Vivo Y28s (product_id=63, category_id=2)
(63, 8, 'Helio G85'), -- CPU
(63, 9, '6'), -- RAM (GB)
(63, 10, '128'), -- Storage (GB)
(63, 11, '6.56'), -- Screen Size (inch)
(63, 12, '5000'), -- Battery Capacity (mAh)
(63, 13, '50'), -- Camera Resolution (MP)
(63, 14, 'Android 14'), -- Operating System
-- Realme GT 6 (product_id=64, category_id=2)
(64, 8, 'Snapdragon 8s Gen 3'), -- CPU
(64, 9, '12'), -- RAM (GB)
(64, 10, '256'), -- Storage (GB)
(64, 11, '6.78'), -- Screen Size (inch)
(64, 12, '5500'), -- Battery Capacity (mAh)
(64, 13, '50'), -- Camera Resolution (MP)
(64, 14, 'Android 14'), -- Operating System
-- Realme Narzo 70 Pro (product_id=65, category_id=2)
(65, 8, 'Dimensity 7050'), -- CPU
(65, 9, '8'), -- RAM (GB)
(65, 10, '128'), -- Storage (GB)
(65, 11, '6.67'), -- Screen Size (inch)
(65, 12, '5000'), -- Battery Capacity (mAh)
(65, 13, '50'), -- Camera Resolution (MP)
(65, 14, 'Android 14'), -- Operating System
-- Realme C65 (product_id=66, category_id=2)
(66, 8, 'Helio G85'), -- CPU
(66, 9, '6'), -- RAM (GB)
(66, 10, '128'), -- Storage (GB)
(66, 11, '6.67'), -- Screen Size (inch)
(66, 12, '5000'), -- Battery Capacity (mAh)
(66, 13, '50'), -- Camera Resolution (MP)
(66, 14, 'Android 14'), -- Operating System
-- Nokia X30 (product_id=67, category_id=2)
(67, 8, 'Snapdragon 695'), -- CPU
(67, 9, '6'), -- RAM (GB)
(67, 10, '128'), -- Storage (GB)
(67, 11, '6.43'), -- Screen Size (inch)
(67, 12, '4200'), -- Battery Capacity (mAh)
(67, 13, '50'), -- Camera Resolution (MP)
(67, 14, 'Android 12'), -- Operating System
-- Nokia G42 (product_id=68, category_id=2)
(68, 8, 'Snapdragon 480+'), -- CPU
(68, 9, '6'), -- RAM (GB)
(68, 10, '128'), -- Storage (GB)
(68, 11, '6.56'), -- Screen Size (inch)
(68, 12, '5000'), -- Battery Capacity (mAh)
(68, 13, '50'), -- Camera Resolution (MP)
(68, 14, 'Android 13'), -- Operating System
-- Nokia C32 (product_id=69, category_id=2)
(69, 8, 'Unisoc SC9863A'), -- CPU
(69, 9, '4'), -- RAM (GB)
(69, 10, '64'), -- Storage (GB)
(69, 11, '6.5'), -- Screen Size (inch)
(69, 12, '5000'), -- Battery Capacity (mAh)
(69, 13, '50'), -- Camera Resolution (MP)
(69, 14, 'Android 13'), -- Operating System
-- Corsair K100 RGB (product_id=70, category_id=5)
(70, 29, 'Full-size'), -- Key Layout
(70, 30, 'Corsair OPX'), -- Switch Type
(70, 31, 'Wired'), -- Connection Type
(70, 32, 'RGB'), -- Backlight
(70, 33, 'N/A'), -- Battery Life
(70, 34, '1350'), -- Weight (g)
(70, 35, '47.0x16.6'), -- Dimensions (cm)
-- Corsair Scimitar Elite (product_id=71, category_id=3)
(71, 15, '18000'), -- DPI
(71, 16, 'Wired'), -- Connection Type
(71, 17, '17'), -- Buttons
(71, 18, 'Optical'), -- Sensor Type
(71, 19, '1000'), -- Polling Rate (Hz)
(71, 20, 'N/A'), -- Battery Life
(71, 21, '122'), -- Weight (g)
-- Corsair HS80 RGB Wireless (product_id=72, category_id=4)
(72, 22, '50'), -- Driver Size (mm)
(72, 23, 'Wireless'), -- Connection Type
(72, 24, 'Yes'), -- Microphone
(72, 25, 'Yes'), -- Noise Cancelling
(72, 26, '40 hours'), -- Battery Life
(72, 27, '20-20000'), -- Frequency Response (Hz)
(72, 28, '300'), -- Weight (g)
-- SteelSeries Apex Pro TKL (product_id=73, category_id=5)
(73, 29, 'TKL'), -- Key Layout
(73, 30, 'OmniPoint 2.0'), -- Switch Type
(73, 31, 'Wired'), -- Connection Type
(73, 32, 'RGB'), -- Backlight
(73, 33, 'N/A'), -- Battery Life
(73, 34, '960'), -- Weight (g)
(73, 35, '35.5x13.9'), -- Dimensions (cm)
-- SteelSeries Aerox 5 Wireless (product_id=74, category_id=3)
(74, 15, '18000'), -- DPI
(74, 16, 'Wireless'), -- Connection Type
(74, 17, '9'), -- Buttons
(74, 18, 'Optical'), -- Sensor Type
(74, 19, '1000'), -- Polling Rate (Hz)
(74, 20, '180 hours'), -- Battery Life
(74, 21, '74'), -- Weight (g)
-- SteelSeries Arctis Nova Pro (product_id=75, category_id=4)
(75, 22, '40'), -- Driver Size (mm)
(75, 23, 'Wireless'), -- Connection Type
(75, 24, 'Yes'), -- Microphone
(75, 25, 'Yes'), -- Noise Cancelling
(75, 26, '44 hours'), -- Battery Life
(75, 27, '10-40000'), -- Frequency Response (Hz)
(75, 28, '337'), -- Weight (g)
-- Corsair Virtuoso RGB Wireless (product_id=76, category_id=4)
(76, 22, '50'), -- Driver Size (mm)
(76, 23, 'Wireless'), -- Connection Type
(76, 24, 'Yes'), -- Microphone
(76, 25, 'Yes'), -- Noise Cancelling
(76, 26, '60 hours'), -- Battery Life
(76, 27, '20-40000'), -- Frequency Response (Hz)
(76, 28, '360'), -- Weight (g)
-- Corsair K70 RGB TKL (product_id=77, category_id=5)
(77, 29, 'TKL'), -- Key Layout
(77, 30, 'Cherry MX Red'), -- Switch Type
(77, 31, 'Wired'), -- Connection Type
(77, 32, 'RGB'), -- Backlight
(77, 33, 'N/A'), -- Battery Life
(77, 34, '880'), -- Weight (g)
(77, 35, '36.0x16.4'), -- Dimensions (cm)
-- Corsair Dark Core RGB Pro (product_id=78, category_id=3)
(78, 15, '18000'), -- DPI
(78, 16, 'Wireless'), -- Connection Type
(78, 17, '8'), -- Buttons
(78, 18, 'Optical'), -- Sensor Type
(78, 19, '2000'), -- Polling Rate (Hz)
(78, 20, '50 hours'), -- Battery Life
(78, 21, '142'), -- Weight (g)
-- SteelSeries Arctis 7+ (product_id=79, category_id=4)
(79, 22, '40'), -- Driver Size (mm)
(79, 23, 'Wireless'), -- Connection Type
(79, 24, 'Yes'), -- Microphone
(79, 25, 'Yes'), -- Noise Cancelling
(79, 26, '30 hours'), -- Battery Life
(79, 27, '20-20000'), -- Frequency Response (Hz)
(79, 28, '352'), -- Weight (g)
-- SteelSeries Apex 7 (product_id=80, category_id=5)
(80, 29, 'Full-size'), -- Key Layout
(80, 30, 'SteelSeries QX2 Red'), -- Switch Type
(80, 31, 'Wired'), -- Connection Type
(80, 32, 'RGB'), -- Backlight
(80, 33, 'N/A'), -- Battery Life
(80, 34, '953'), -- Weight (g)
(80, 35, '43.7x13.9'), -- Dimensions (cm)
-- SteelSeries Rival 5 (product_id=81, category_id=3)
(81, 15, '18000'), -- DPI
(81, 16, 'Wired'), -- Connection Type
(81, 17, '9'), -- Buttons
(81, 18, 'Optical'), -- Sensor Type
(81, 19, '1000'), -- Polling Rate (Hz)
(81, 20, 'N/A'), -- Battery Life
(81, 21, '85'), -- Weight (g)
-- MSI Vigor GK71 Sonic (product_id=82, category_id=5)
(82, 29, 'Full-size'), -- Key Layout
(82, 30, 'MSI Sonic Red'), -- Switch Type
(82, 31, 'Wired'), -- Connection Type
(82, 32, 'RGB'), -- Backlight
(82, 33, 'N/A'), -- Battery Life
(82, 34, '854'), -- Weight (g)
(82, 35, '44.2x13.8'), -- Dimensions (cm)
-- MSI Clutch GM41 Lightweight (product_id=83, category_id=3)
(83, 15, '16000'), -- DPI
(83, 16, 'Wired'), -- Connection Type
(83, 17, '6'), -- Buttons
(83, 18, 'Optical'), -- Sensor Type
(83, 19, '1000'), -- Polling Rate (Hz)
(83, 20, 'N/A'), -- Battery Life
(83, 21, '65'), -- Weight (g)
-- Gigabyte AORUS K9 Optical (product_id=84, category_id=5)
(84, 29, 'Full-size'), -- Key Layout
(84, 30, 'Flaretech Optical'), -- Switch Type
(84, 31, 'Wired'), -- Connection Type
(84, 32, 'RGB'), -- Backlight
(84, 33, 'N/A'), -- Battery Life
(84, 34, '1120'), -- Weight (g)
(84, 35, '44.0x15.0'), -- Dimensions (cm)
-- Gigabyte AORUS M5 (product_id=85, category_id=3)
(85, 15, '16000'), -- DPI
(85, 16, 'Wired'), -- Connection Type
(85, 17, '7'), -- Buttons
(85, 18, 'Optical'), -- Sensor Type
(85, 19, '1000'), -- Polling Rate (Hz)
(85, 20, 'N/A'), -- Battery Life
(85, 21, '118'), -- Weight (g)
-- Xiaomi Buds 5 (product_id=86, category_id=4)
(86, 22, '11'), -- Driver Size (mm)
(86, 23, 'Bluetooth'), -- Connection Type
(86, 24, 'Yes'), -- Microphone
(86, 25, 'Yes'), -- Noise Cancelling
(86, 26, '40 hours'), -- Battery Life
(86, 27, '20-40000'), -- Frequency Response (Hz)
(86, 28, '52'), -- Weight (g)
-- Redmi Buds 6 Active (product_id=87, category_id=4)
(87, 22, '10'), -- Driver Size (mm)
(87, 23, 'Bluetooth'), -- Connection Type
(87, 24, 'Yes'), -- Microphone
(87, 25, 'No'), -- Noise Cancelling
(87, 26, '30 hours'), -- Battery Life
(87, 27, '20-20000'), -- Frequency Response (Hz)
(87, 28, '48'), -- Weight (g)
-- OPPO Enco X3 (product_id=88, category_id=4)
(88, 22, '11'), -- Driver Size (mm)
(88, 23, 'Bluetooth'), -- Connection Type
(88, 24, 'Yes'), -- Microphone
(88, 25, 'Yes'), -- Noise Cancelling
(88, 26, '44 hours'), -- Battery Life
(88, 27, '20-40000'), -- Frequency Response (Hz)
(88, 28, '54'), -- Weight (g)
-- OPPO Enco Air 4 (product_id=89, category_id=4)
(89, 22, '10'), -- Driver Size (mm)
(89, 23, 'Bluetooth'), -- Connection Type
(89, 24, 'Yes'), -- Microphone
(89, 25, 'Yes'), -- Noise Cancelling
(89, 26, '30 hours'), -- Battery Life
(89, 27, '20-20000'), -- Frequency Response (Hz)
(89, 28, '50'), -- Weight (g)
-- Vivo TWS 4 (product_id=90, category_id=4)
(90, 22, '11'), -- Driver Size (mm)
(90, 23, 'Bluetooth'), -- Connection Type
(90, 24, 'Yes'), -- Microphone
(90, 25, 'Yes'), -- Noise Cancelling
(90, 26, '45 hours'), -- Battery Life
(90, 27, '20-40000'), -- Frequency Response (Hz)
(90, 28, '53'), -- Weight (g)
-- Vivo TWS Air 2 (product_id=91, category_id=4)
(91, 22, '10'), -- Driver Size (mm)
(91, 23, 'Bluetooth'), -- Connection Type
(91, 24, 'Yes'), -- Microphone
(91, 25, 'No'), -- Noise Cancelling
(91, 26, '25 hours'), -- Battery Life
(91, 27, '20-20000'), -- Frequency Response (Hz)
(91, 28, '49'), -- Weight (g)
-- Realme Buds Air 6 Pro (product_id=92, category_id=4)
(92, 22, '11'), -- Driver Size (mm)
(92, 23, 'Bluetooth'), -- Connection Type
(92, 24, 'Yes'), -- Microphone
(92, 25, 'Yes'), -- Noise Cancelling
(92, 26, '40 hours'), -- Battery Life
(92, 27, '20-40000'), -- Frequency Response (Hz)
(92, 28, '52'), -- Weight (g)
-- Realme Buds T300 (product_id=93, category_id=4)
(93, 22, '10'), -- Driver Size (mm)
(93, 23, 'Bluetooth'), -- Connection Type
(93, 24, 'Yes'), -- Microphone
(93, 25, 'No'), -- Noise Cancelling
(93, 26, '30 hours'), -- Battery Life
(93, 27, '20-20000'), -- Frequency Response (Hz)
(93, 28, '48'), -- Weight (g)
-- Nokia Clarity Earbuds 2 Pro (product_id=94, category_id=4)
(94, 22, '10'), -- Driver Size (mm)
(94, 23, 'Bluetooth'), -- Connection Type
(94, 24, 'Yes'), -- Microphone
(94, 25, 'Yes'), -- Noise Cancelling
(94, 26, '35 hours'), -- Battery Life
(94, 27, '20-20000'), -- Frequency Response (Hz)
(94, 28, '50'), -- Weight (g)
-- Nokia Go Earbuds+ (product_id=95, category_id=4)
(95, 22, '10'), -- Driver Size (mm)
(95, 23, 'Bluetooth'), -- Connection Type
(95, 24, 'Yes'), -- Microphone
(95, 25, 'No'), -- Noise Cancelling
(95, 26, '20 hours'), -- Battery Life
(95, 27, '20-20000'), -- Frequency Response (Hz)
(95, 28, '46'); -- Weight (g)

--Order
INSERT INTO Orders (user_id, status, total_amount, shipping_address)
VALUES
(1, 'completed', 1339.69, '123 Main St, Hanoi'), -- MacBook Pro 13.3 i5 2.3GHz
(1, 'pending', 898.94, '123 Main St, Hanoi'),   -- Macbook Air 13.3 i5 1.8GHz 128GB
(3, 'shipped', 999.00, '456 Elm St, Ho Chi Minh City'), -- Legion Y520-15IKBN
(1, 'canceled', 1495.00, '123 Main St, Hanoi'); -- ZenBook UX430UN

--OrderDetail
INSERT INTO Order_Detail (order_id, product_id, quantity, unit_price)
VALUES
(1, 6, 1, 1339.69),  -- Order 1: MacBook Pro 13.3 i5 2.3GHz
(2, 7, 1, 898.94),   -- Order 2: Macbook Air 13.3 i5 1.8GHz 128GB
(3, 24, 1, 999.00),  -- Order 3: Legion Y520-15IKBN
(4, 13, 1, 1495.00); -- Order 4: ZenBook UX430UN

--Review
INSERT INTO Review (product_id, user_id, rating, comment, created_at)
VALUES
(1, 1, 5, 'Excellent performance and display quality!', '2025-05-21 12:00:00'), -- MacBook Pro
(2, 1, 4, 'Great for portability, but storage is limited.', '2025-05-26 15:00:00'), -- Macbook Air
(19, 3, 5, 'Perfect for gaming, solid GPU performance.', '2025-05-29 10:00:00'), -- Legion Y520
(8, 1, 3, 'Good specs, but a bit pricey.', '2025-05-31 09:00:00'); -- ZenBook UX430UN


--Payment
INSERT INTO Payment (order_id, payment_method, amount, status)
VALUES
(1, 'cash', 1200.00, 'completed'), -- Đơn hàng 1: Asus ZenBook 14
(2, 'banking', 600.00, 'pending'),       -- Đơn hàng 2: Acer Aspire 5
(3, 'banking', 999.00, 'completed'),-- Đơn hàng 3: Legion Y520-15IKBN
(4, 'cash_on_delivery', 1500.00, 'pending'); -- Đơn hàng 4: Apple MacBook Air M2


SELECT * FROM Product WHERE name LIKE '%mac%';

