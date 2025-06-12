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

CREATE TABLE ProductImages (
    image_id INT IDENTITY(1,1) PRIMARY KEY,  -- Sử dụng IDENTITY để tự động tăng
    product_id INT,
    image_url VARCHAR(255) NOT NULL,          -- Đường dẫn tới hình ảnh
    is_primary BIT DEFAULT 0,                 -- Đánh dấu hình ảnh chính (0 = false, 1 = true)
    status NVARCHAR(20) CHECK (status IN ('active', 'inactive')) DEFAULT 'pending',  
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
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
('Bronze', 3.00),
('Silver', 5.00),
('Gold', 7.00),
('Dinamond', 10.00);

--User
INSERT INTO Users (username, password, fullName, email, phone, address, role, membership_level_id)
VALUES
('khoa', 'khoa', 'Nguyen Khoa', 'khoa@example.com', '0123456789', '123 Đường A, TP.HCM', 'admin', 4),
('nam', 'nam', 'Nguyen Nam', 'nam@example.com', '0987654321', '456 Đường B, Hà Nội', 'admin', 4),
('vinh', 'vinh', 'Nguyen Vinh', 'vinh@example.com', '0912345678', '789 Đường C, Đà Nẵng', 'admin', 4),
('hieu', 'hieu', 'Ngo Hieu', 'hieu@example.com', '0909876543', '12 Đường D, Hải Phòng', 'admin', 4),
('huy', 'huy', 'Le Huy', 'huy@example.com', '0999888777', '345 Đường E, Cần Thơ', 'admin', 4),
('admin', 'admin', 'Vu Van F', 'user5@example.com', '0966778899', '678 Đường F, Huế', 'admin', 4),
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
('MacBook Pro 13.3 i5 2.3GHz', 'Ultrabook with Retina Display and Intel i5', 34896950, 50, 1, 1, 'https://cdsassets.apple.com/live/SZLF0YNV/images/sp/111999_SP747_mbp13-gray.jpg'),
('Macbook Air 13.3 i5 1.8GHz 128GB', 'Lightweight Ultrabook with macOS', 23412208, 40, 1, 1, 'https://product.hstatic.net/200000373523/product/34925_laptop_apple_macbook_air_m0uu3_128gb__2017___silver__1_1_5308f3368d8245849dbe6c6c96a280cd_grande.jpg'),
('HP 250 G6 i5 7200U', 'Notebook for everyday use', 14974438, 60, 1, 3, 'https://anphat.com.vn/media/product/25740_laptop_hp_250_g6_2xr76pa_1.jpg'),
('MacBook Pro 15.4 i7 2.7GHz', 'High-performance Ultrabook with Radeon Pro', 66069823, 20, 1, 1, 'https://i.ebayimg.com/images/g/orgAAOSwIfRlJr97/s-l1200.jpg'),
('MacBook Pro 13.3 i5 3.1GHz', 'Ultrabook with Retina Display and Intel i5', 46980670, 30, 1, 1, 'https://pos.nvncdn.com/9d42d7-25235/ps/20210914_SdENq683RC0S9ZBVv5hhHgjX.jpg'),
('MacBook Pro 15.4 i7 2.2GHz', 'Ultrabook with Intel Iris Pro Graphics', 55730950, 25, 1, 1, 'https://macmall.vn/uploads/macbook-pro-15inch-2018-macmall_1718126810.png'),
('Macbook Air 13.3 i5 1.8GHz 256GB', 'Ultrabook with extended storage', 30183258, 35, 1, 1, 'https://cdn.tgdd.vn/Products/Images/44/106880/apple-macbook-air-mqd42sa-a-i5-5350u-8gb-256gb-bac-450x300-450x300.jpg'),
('ZenBook UX430UN', 'Ultrabook with Nvidia GeForce MX150', 38933538, 45, 1, 5, 'https://ducanhcomputer.com/uploads/san-pham/2019_03/gv096t.jpg'),
('Swift 3', 'Ultrabook with IPS display', 20052725, 50, 1, 6, 'https://cdn.tgdd.vn/Products/Images/44/269313/acer-swift-3-sf314-511-55qe-i5-nxabnsv003-120122-022600-600x600.jpg'),
('HP 250 G6 i3 6006U', 'Affordable Notebook with Intel i3', 8984663, 70, 1, 3, 'https://product.hstatic.net/1000296652/product/kk_1a586f1bece145bd8a4cbfc80f4c63f2_7a0b155ca637451e81f6e55005c1f568.jpg'),
('MacBook Pro 15.4 i7 2.8GHz', 'Ultrabook with AMD Radeon Pro 555', 63543700, 20, 1, 1, 'https://ttcenter.com.vn/uploads/product/8blddpkb-657-macbook-pro-2017-15-inch-i7-16gb-512gb-touchbar.jpg'),
('Inspiron 3567 i3 6006U', 'Notebook with Full HD display', 12995208, 60, 1, 2, 'https://cdn.tgdd.vn/Products/Images/44/91260/dell-inspiron-3567-i3-6006u-ava-600x600.jpg'),
('MacBook 12', 'Compact Ultrabook with Retina Display', 32865635, 30, 1, 1, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/m/a/macbook-mnyf2-1.jpg'),
('Inspiron 3567 i7 7500U', 'Notebook with Intel i7 and AMD Radeon', 19401663, 50, 1, 2, 'https://product.hstatic.net/200000680839/product/dell_15-35xx_6a55b1fcb5c945eb8ca0a3be0a6a79a7_1024x1024.png'),
('MacBook Pro 15.4 i7 2.9GHz', 'Ultrabook with AMD Radeon Pro 560', 74429465, 15, 1, 1, 'https://www.devicerefresh.com/cdn/shop/files/ba847be049015b2567b7de577c6b2e5a_417559ff-902c-485a-8e3b-7e56941e7195_800x.jpg?v=1720026879'),
('IdeaPad 320-15IKB', 'Notebook with Nvidia GeForce 940MX', 12995208, 55, 1, 4, 'https://maytinhcdc.vn/media/product/919_148.jpg'),
('XPS 13 i5 8250U', 'Ultrabook with Touchscreen display', 2495608, 40, 1, 2, 'https://laptopmd.vn/userdata/6449/wp-content/uploads/2022/10/37535-37521-36346-35154-dell-xps-13-9350-core-i5-6200u-2-2ghz-ram-4gb-256gb-ssd-13fhd-win-10-33563-1.png'),
('Vivobook E200HA', 'Lightweight Netbook for basic tasks', 5000160, 80, 1, 5, 'https://channel.vcmedia.vn/prupload/164/2016/03/img20160321235342405.jpg'),
('Legion Y520-15IKBN', 'Gaming laptop with GTX 1050', 26016458, 25, 1, 4, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBqNiZbjTx6WMnyBwiedE8HsyA4rTOSKizig&s'),
('HP 255 G6', 'Budget Notebook with AMD processor', 6718965, 65, 1, 3, 'https://www.notebookcheck.net/uploads/tx_nbc2/1503610-1_04.jpg'),
('Inspiron 5379', '2 in 1 Convertible with touchscreen', 21328808, 35, 1, 2, 'https://cohotech.vn/wp-content/uploads/2019/05/Laptop-Dell-Insprion-2in1-i5379-768x768.jpg'),
('HP 15-BS101nv', 'Ultrabook with Intel i7 and Full HD', 17162008, 45, 1, 3, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS63T43yHWJ7H24fL_MxWrZ9RSJrLB2R4FdUg&s'),
('Inspiron 5570', 'Notebook with AMD Radeon 530', 20834000, 50, 1, 2, 'https://bizweb.dktcdn.net/thumb/grande/100/244/033/products/0104539-dell-inspiron-5570-15-5000-series-i7-8550u-156-full-hd-notebook-600-jpeg-63c6b10e-389a-4f93-86b0-94b9da7826f8-93d7976c-e12d-4172-9590-19177f9d5c98.jpg?v=1561955966243'),
('Latitude 5590', 'Ultrabook with dual SSD storage', 33803165, 30, 1, 2, 'https://www.laptopvip.vn/images/companies/1/032018/Dell/Dell-Latitude-5590-8th-intel-core-review-3.png'),
('ProBook 470', 'Notebook with 17.3-inch display', 23334080, 40, 1, 3, 'https://www.laptopvip.vn/images/ab__webp/thumbnails/800/800/detailed/19/Hp_Probook_470_03.png.webp'),
('HP 17-ak001nv', 'Notebook with AMD Radeon 530', 11432658, 50, 1, 5, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUphPMt_I0fN15npz0LnWIQuqMXNp_Ayt9bw&s'),
('XPS 13 i7 8550U', 'Ultrabook with Quad HD+ display', 48673433, 25, 1, 2, 'https://product.hstatic.net/200000553329/product/xps_9370_core_i7_ram_16g_ssd_512g_laptopone_8a38fc7aa6e44968acf94d5f4a4b497b.jpg'),
('IdeaPad 120S-14IAP', 'Notebook with Intel Celeron', 6484583, 70, 1, 4, 'https://cdn.tgdd.vn/Products/Images/44/194252/lenovo-ideapad-120s-14iap-n4200-4gb-64gb-win10-81-15-600x600.jpg'),
('Inspiron 5770', 'Notebook with dual storage', 25495608, 45, 1, 2, 'https://laptopxachtay.com.vn/kcfinder/upload/images/Laptop/Dell/5000/5570.JPG'),
('ProBook 450', 'Notebook with Nvidia GeForce 930MX', 22891358, 40, 1, 3, 'https://cdn.tgdd.vn/Products/Images/44/315906/hp-probook-450-g10-i5-873d1pa-1-1-750x500.jpg'),
('X540UA-DM186', 'Notebook with Full HD and Linux', 10130533, 55, 1, 5, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLy7FEzOOzczRnST3NIwTvAjYA5dTdpm5Ccg&s'),
('Inspiron 7577', 'Gaming laptop with GTX 1060', 39037708, 20, 1, 2, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/i/n/inspiron-15-gaming-7577-70158745.jpg'),
('X542UQ-GO005', 'Notebook with Nvidia GeForce 940MX', 13620228, 50, 1, 5, 'https://cdn.bdstall.com/product-image/giant_62782.jpg'),
('Aspire A515-51G', 'Notebook with IPS display', 17760985, 45, 1, 6, 'https://cdn.tgdd.vn/Products/Images/44/111120/acer-aspire-a515-51g-52zs-i5-7200u-1-450x300.jpg'),
('Inspiron 7773', '2 in 1 Convertible with Nvidia GeForce', 26016458, 30, 1, 2, 'https://www.notebookcheck.net/uploads/tx_nbc2/DellInspiron17-7773__1_.JPG'),
('MacBook Pro 13.3 i5 2.0GHz', 'Ultrabook with Intel Iris Graphics', 36954308, 35, 1, 1, 'https://bizweb.dktcdn.net/thumb/grande/100/318/659/products/8836101-jpeg.jpg?v=1536732696847'),
('IdeaPad 320-15ISK', 'Notebook with Intel i3', 9609683, 60, 1, 4, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9C1N0Ucdv6__RNBFCARgxZKI_g4fo2f7M2w&s'),
('Rog Strix', 'Gaming laptop with AMD Ryzen', 33829208, 25, 1, 5, 'https://bizweb.dktcdn.net/100/512/769/files/1-d4dfca93-7ffd-4be2-8d78-7be1a8e2e693.jpg?v=1716189372866'),
('Inspiron 3567 i5 7200U', 'Notebook with AMD Radeon R5 M430', 16641158, 50, 1, 2, 'https://cdn.tgdd.vn/Products/Images/44/156861/dell-inspiron-3567-i5-7200u-70119158-450-300-600x600.png'),
('Logitech MX Master 3S', N'Chuột không dây cao cấp với cảm biến 8000 DPI, thiết kế công thái học, phù hợp cho văn phòng và sáng tạo', 2500000, 50, 3, 15, 'https://d28jzcg6y4v9j1.cloudfront.net/chuot_logitech_mx_3s_co_thiet_ke_chuan_cong_thai_hoc_1719808317791.jpg'),
('ASUS ROG Strix Scope NX TKL Deluxe', N'Bàn phím cơ gaming TKL với switch ASUS NX Red, đèn RGB, thiết kế nhỏ gọn', 3500000, 30, 5, 5, 'https://minhancomputercdn.com/media/product/10303_b__n_ph__m_c___asus_rog_strix_scope_nx_tkl_deluxe_1.jpg'),
('Logitech Combo Touch iPad Pro', N'Touchpad và bàn phím tích hợp cho iPad Pro 11-inch, kết nối Bluetooth, hỗ trợ đa góc nghiêng', 4500000, 20, 5, 15, 'https://resource.logitech.com/w_1200,h_630,c_limit,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/logitech/en/products/mobility/combo-touch-for-ipad-pro/combo-touch-ipadpro-og-image.jpg?v=1'),
('Razer DeathAdder V3 Pro', N'Chuột gaming không dây với cảm biến 30000 DPI, trọng lượng nhẹ 63g, tối ưu cho eSports', 3000000, 40, 3, 16, 'https://bizweb.dktcdn.net/100/329/122/products/chuot-gaming-khong-day-razer-deathadder-v3-pro-0a5a68a8-10c5-433d-bece-b49ec8828fc5.jpg?v=1746496978517'),
('Keychron K8 Pro', N'Bàn phím cơ không dây hot-swappable, switch Gateron Brown, đèn RGB, hỗ trợ macOS và Windows', 2200000, 25, 5, 19, 'https://s88.vn/media/lib/21-10-2023/8378_b__n_ph__m_keychron_k8_pro.jpg'),
-- MSI (brand_id=7, Laptop, category_id=1)
('MSI Katana 15', 'Gaming laptop with RTX 4070, 165Hz display', 36459500, 25, 1, 7, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/msi_katana_15_b13v_1_9310c95515.png'),
('MSI Stealth 16', 'Thin gaming laptop with RTX 4060, 144Hz', 41668000, 20, 1, 7, 'https://cdn.tgdd.vn/Products/Images/44/322946/msi-gaming-stealth-16-ai-studio-a1vgg-ultra-9-089vn-1-750x500.jpg'),
('MSI Prestige 14 Evo', 'Business laptop with Intel Core Ultra 7', 31251000, 30, 1, 7, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/msi_prestige_14_ai_studio_c1u_1_5ab50baa17.png'),
('MSI Creator Z17', 'Creator laptop with RTX 3080 Ti, 4K display', 65106250, 15, 1, 7, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/msi_creator_16_ai_studio_a1v_1_7eece4ea8a.png'),
-- Gigabyte (brand_id=8, Laptop, category_id=1)
('Gigabyte AORUS 17', 'Gaming laptop with RTX 4080, 240Hz display', 52085000, 20, 1, 8, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2022_9_26_637998081269981032_gigabyte-gaming-aorus-17-xe5-73vn534gh-i7-12700h-rtx3070ti-den-1.jpg'),
('Gigabyte AERO 15 OLED', 'Creator laptop with 4K AMOLED, RTX 3070', 46876500, 25, 1, 8, 'https://product.hstatic.net/200000837185/product/laptopgigabyteaero15oledkd-72s1623go_a4a4b601ef9c4bddb1bdfd1d12825bef.png'),
('Gigabyte G5', 'Budget gaming laptop with RTX 4050', 26042500, 35, 1, 8, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2023_5_5_638188828261835779_gigabyte-gaming-g5-kf-e3vn313sh-i5-12500h-den-3.jpg'),
-- Samsung (brand_id=9, Phone, category_id=2)
('Samsung Galaxy S24 Ultra', 'Flagship phone with Snapdragon 8 Gen 3', 31251000, 40, 2, 9, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2024_1_15_638409395342231798_samsung-galaxy-s24-ultra-xam-1.png'),
('Samsung Galaxy A35', 'Mid-range phone with Exynos 1380', 9114875, 60, 2, 9, 'https://cdn.mobilecity.vn/mobilecity-vn/images/2024/03/w300/samsung-galaxy-a35-tim.jpg.webp'),
('Samsung Galaxy Z Fold 6', 'Foldable phone with 7.6-inch AMOLED', 46876500, 20, 2, 9, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/samsung_galaxy_z_fold6_gray_a413f785af.png'),
-- Xiaomi (brand_id=10, Phone, category_id=2)
('Xiaomi 14 Pro', 'Flagship phone with Snapdragon 8 Gen 3', 20834000, 45, 2, 10, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/xiaomi_redmi_note_14_5g_xanh_3_a16f31cae7.jpg'),
('Redmi Note 14 Pro+', 'Mid-range phone with 120Hz AMOLED', 11719125, 50, 2, 10, 'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/xiaomi_redmi_note_14_pro_plus_3_4d3d0d8993.jpg'),
('Redmi A4 5G', 'Budget phone with Snapdragon 4s Gen 2', 5208500, 80, 2, 10, 'https://cdn.viettablet.com/images/detailed/65/redmi-a4-5g.jpg'),
-- OPPO (brand_id=11, Phone, category_id=2)
('OPPO Find X7 Ultra', 'Flagship phone with Snapdragon 8 Gen 3', 22136125, 35, 2, 11, 'https://cellphones.com.vn/sforum/wp-content/uploads/2024/03/OPPO-Find-X7-Ultra-DxOMark-1.jpeg'),
('OPPO Reno 11 Pro', 'Mid-range phone with Dimensity 8200', 10417000, 50, 2, 11, 'https://cdn.tgdd.vn/Products/Images/42/314210/oppo-reno-11-pro-xam-thumb-600x600.jpg'),
('OPPO A79 5G', 'Budget phone with Dimensity 6020', 6510625, 70, 2, 11, 'https://cdn.tgdd.vn/Products/Images/42/316776/oppo-a79-5g-tim-thumb-1-2-600x600.jpg'),
-- Vivo (brand_id=12, Phone, category_id=2)
('Vivo X100 Pro', 'Flagship phone with Dimensity 9300', 23438250, 30, 2, 12, 'https://www.xtmobile.vn/vnt_upload/product/11_2023/vivo-x100-pro-12gb-256gb-xtmobile.jpg'),
('Vivo V30 Pro', 'Mid-range phone with Snapdragon 7 Gen 3', 11719125, 55, 2, 12, 'https://cdn.tgdd.vn/Products/Images/42/320961/vivo-v30-pro-thumb-600x600.jpg'),
('Vivo Y28s', 'Budget phone with Helio G85', 5208500, 75, 2, 12, 'https://cdn-media.sforum.vn/storage/app/media/trannghia/vivo-y28s-5g-ra-mat-2.jpg'),
-- Realme (brand_id=13, Phone, category_id=2)
('Realme GT 6', 'Flagship phone with Snapdragon 8s Gen 3', 15625500, 40, 2, 13, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/r/e/realme-gt-5_4__1_1.png'),
('Realme Narzo 70 Pro', 'Mid-range phone with Dimensity 7050', 7812750, 60, 2, 13, 'https://cdn.tgdd.vn/News/Thumb/1563278/Realme-Narzo-70-Pro-5G-ra-mat-voi-camera-1-inch-thiet-ke-nhu-flagship-1200x675.jpg'),
('Realme C65', 'Budget phone with Helio G85', 4687650, 80, 2, 13, 'https://cdn.tgdd.vn/Products/Images/42/323002/realme-c65-thumb-1-600x600.jpg'),
-- Nokia (brand_id=14, Phone, category_id=2)
('Nokia X30', 'Mid-range phone with Snapdragon 695', 9114875, 50, 2, 14, 'https://cdn.tgdd.vn/Files/2022/09/05/1465498/nokia_x30_5g-1_1280x720-800-resize.jpg'),
('Nokia G42', 'Budget phone with Snapdragon 480+', 5729350, 70, 2, 14, 'https://cdn.tgdd.vn/Products/Images/42/309833/nokia-g42-5g-600x600.jpg'),
('Nokia C32', 'Entry-level phone with Unisoc SC9863A', 3906375, 90, 2, 14, 'https://cdn2.fptshop.com.vn/unsafe/2023_7_14_638249469495107256_nokia-c32-dd.jpg'),
-- Corsair (brand_id=17, Keyboard/Mouse, category_id=5/3)
('Corsair K100 RGB', 'Premium mechanical keyboard with OPX switches', 5208500, 40, 5, 17, 'https://product.hstatic.net/200000722513/product/phim_2ceafcd3b71942409b4724616258c73b_d44aa7fb2a70454d99b01bc9c1117f4f_030600be83d043258c9998e4edef6924_1024x1024.png'),
('Corsair Scimitar Elite', 'Gaming mouse with 18 programmable buttons', 2083400, 60, 3, 17, 'https://product.hstatic.net/200000722513/product/chuot-game-corsair-scimitar-rgb-elite_8c3acc8779564469a84f45ec97f6f35d_941d55c2e4394ac29895a299a97b2805_1024x1024.png'),
('Corsair HS80 RGB Wireless', 'Wireless gaming headset with Dolby Atmos', 3906375, 50, 4, 17, 'https://product.hstatic.net/200000722513/product/led_rgb_wireless_ca_9011235_ap_0001_2_436fee75cc8d499e9d7619b9efef8acd_8f3b7e1f606c49b8b209034703d29d54_1024x1024.jpg'),
-- SteelSeries (brand_id=18, Keyboard/Mouse, category_id=5/3)
('SteelSeries Apex Pro TKL', 'Mechanical keyboard with adjustable switches', 4687650, 45, 5, 18, 'https://nguyencongpc.vn/media/product/17186-b--n-ph--m-c---steelseries-apex-pro-tkl-3.jpg'),
('SteelSeries Aerox 5 Wireless', 'Lightweight gaming mouse with 9 buttons', 2604250, 55, 3, 18, 'https://file.hstatic.net/1000026716/file/gearvn-chuot-steelseries-aerox-5-wireless-1_15b7fafa0f42499394e87b7b75a7ac58_grande.png'),
('SteelSeries Arctis Nova Pro', 'Wireless gaming headset with ANC', 6510625, 40, 4, 18, 'https://product.hstatic.net/200000722513/product/800_crop-scale_optimize_subsampling-2_85403d08f58e43de8be56cbc40688980_92aaa444113d491c92b3096a44a385f9_1024x1024.png'),
-- Corsair (brand_id=17, Headphone=4, Keyboard=5, Mouse=3)
('Corsair Virtuoso RGB Wireless', 'Premium wireless gaming headset with 7.1 surround', 4687650, 35, 4, 17, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2021_11_9_637720718333788887_tai-nghe-khong-day-corsair-virtuoso-rgb-den-1.jpg'),
('Corsair K70 RGB TKL', 'Compact mechanical keyboard with Cherry MX Red', 3385525, 40, 5, 17, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/ban-phim-co-corsair-k70-rgb-champion-series.png?v=1698911457230'),
('Corsair Dark Core RGB Pro', 'Wireless gaming mouse with 18K DPI', 2343825, 50, 3, 17, 'https://product.hstatic.net/200000722513/product/-core-rgb-pro-wireless-gaming-mouse-1_b647046fefda46f7a86b1151dd4f138c_d2a85a2e839a4e60b6d790d65862053b.png'),
-- SteelSeries (brand_id=18, Headphone=4, Keyboard=5, Mouse=3)
('SteelSeries Arctis 7+', 'Wireless gaming headset with 30-hour battery', 4427225, 45, 4, 18, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2024_2_28_638447295329987245_tai-nghe-bluetooth-choang-dau-steelseries-arctis-nova-7-1.jpg'),
('SteelSeries Apex 7', 'Full-size mechanical keyboard with OLED display', 4166800, 30, 5, 18, 'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/ban_phim_co_gaming_co_day_apex_7_tkl_red_switch_steelseries_3_5f971f0236.jpg'),
('SteelSeries Rival 5', 'Versatile gaming mouse with 9 buttons', 1562550, 60, 3, 18, 'https://owlgaming.vn/wp-content/uploads/2024/06/chuot-steelseries-rival-5-3.jpg'),
-- MSI (brand_id=7, Keyboard=5, Mouse=3)
('MSI Vigor GK71 Sonic', 'Mechanical keyboard with Sonic Red switches', 3125100, 35, 5, 7, 'https://asset.msi.com/resize/image/global/product/product_16415411303a4f3ad1ddc39e1b18dd3904a62e4767.png62405b38c58fe0f07fcef2367d8a9ba1/600.png'),
('MSI Clutch GM41 Lightweight', 'Lightweight gaming mouse with 16K DPI', 1302125, 55, 3, 7, 'https://storage-asset.msi.com/global/picture/image/feature/mouse/GM41/images/kv_mouse.png'),
-- Gigabyte (brand_id=8, Keyboard=5, Mouse=3)
('Gigabyte AORUS K9 Optical', 'Optical mechanical keyboard with Flaretech switches', 3645950, 30, 5, 8, 'https://www.gigabyte.com/FileUpload/Global/KeyFeature/845/images/gallery/p001.jpg'),
('Gigabyte AORUS M5', 'Gaming mouse with 16K DPI and RGB', 1822975, 50, 3, 8, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbtPjPHYQbr2ZOQOxuYihY92SSh_0Kued3eQ&s'),
-- Xiaomi (brand_id=10, Headphone=4)
('Xiaomi Buds 5', 'True wireless earbuds with ANC', 2083400, 70, 4, 10, 'https://i02.appmifile.com/mi-com-product/fly-birds/xiaomi-buds-5/m/76caeb0cd8ff39e3df393e65a6a93535.jpg'),
('Redmi Buds 6 Active', 'Budget wireless earbuds with 30-hour battery', 1041700, 100, 4, 10, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/t/a/tai-nghe-bluetooth-xiaomi-redmi-buds-6-active.png'),
-- OPPO (brand_id=11, Headphone=4)
('OPPO Enco X3', 'Premium wireless earbuds with LHDC audio', 2604250, 60, 4, 11, 'https://cdn-media.sforum.vn/storage/app/media/trannghia/Oppo-Enco-X3-ra-mat-2.jpg'),
('OPPO Enco Air 4', 'Mid-range wireless earbuds with ANC', 1562550, 80, 4, 11, 'https://image.oppo.com/content/dam/oppo/common/mkt/v2-2/oppo-enco-air4-pro-en/specs/Specs_1574_720_Two-color.png'),
-- Vivo (brand_id=12, Headphone=4)
('Vivo TWS 4', 'Wireless earbuds with Hi-Fi audio', 2343825, 65, 4, 12, 'https://down-vn.img.susercontent.com/file/cn-11134207-7ras8-m2svswyici5j78'),
('Vivo TWS Air 2', 'Budget wireless earbuds with 25-hour battery', 1302125, 90, 4, 12, 'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/vivo-tws-air-2-2.jpeg'),
-- Realme (brand_id=13, Headphone=4)
('Realme Buds Air 6 Pro', 'Wireless earbuds with 50dB ANC', 2083400, 70, 4, 13, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rd6w-lv325z0e6pas45'),
('Realme Buds T300', 'Budget wireless earbuds with 30-hour battery', 1041700, 100, 4, 13, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/t/a/tai-nghe-khong-day-realme-buds-t300_4_.png'),
-- Nokia (brand_id=14, Headphone=4)
('Nokia Clarity Earbuds 2 Pro', 'Wireless earbuds with ANC', 1822975, 75, 4, 14, 'https://images.ctfassets.net/wcfotm6rrl7u/2Z3VgGVzRvyp79rtRQ2VOX/f1f855d234ba7531d9862d9f52b66237/nokia-TWS-852W-black-angled.png?h=1000&fm=png&fl=png8'),
('Nokia Go Earbuds+', 'Budget wireless earbuds with 20-hour battery', 781275, 110, 4, 14, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQXAiBYVepZP2H0uEnAhzU04JdKsZ78_N5VA&s');

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
-- ASUS ROG Strix Scope NX TKL Deluxe (product_id=41, category_id=5)
(41, 29, 'TKL'), -- Key Layout
(41, 30, 'NX Red'), -- Switch Type
(41, 31, 'Wired'), -- Connection Type
(41, 32, 'RGB'), -- Backlight
(41, 33, 'N/A'), -- Battery Life
(41, 34, '880'), -- Weight (g)
(41, 35, '35.6x13.6'), -- Dimensions (cm)
-- Logitech Combo Touch iPad Pro (product_id=42, category_id=5)
(42, 29, 'Standard with Touchpad'), -- Key Layout
(42, 30, 'Membrane'), -- Switch Type
(42, 31, 'Bluetooth'), -- Connection Type
(42, 32, 'White'), -- Backlight
(42, 33, '20 hours'), -- Battery Life
(42, 34, '645'), -- Weight (g)
(42, 35, '25.2x19.2'), -- Dimensions (cm)
-- Razer DeathAdder V3 Pro (product_id=43, category_id=3)
(43, 15, '30000'), -- DPI
(43, 16, 'Wireless'), -- Connection Type
(43, 17, '5'), -- Buttons
(43, 18, 'Optical'), -- Sensor Type
(43, 19, '1000'), -- Polling Rate (Hz)
(43, 20, '90 hours'), -- Battery Life
(43, 21, '63'), -- Weight (g)
-- Keychron K8 Pro (product_id=44, category_id=5)
(44, 29, '80%'), -- Key Layout
(44, 30, 'Gateron Brown'), -- Switch Type
(44, 31, 'Wireless'), -- Connection Type
(44, 32, 'RGB'), -- Backlight
(44, 33, '70 hours'), -- Battery Life
(44, 34, '990'), -- Weight (g)
(44, 35, '35.9x12.4'), -- Dimensions (cm)
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

INSERT INTO ProductImages (product_id, image_url, is_primary, status)
VALUES
-- Product 1: MacBook Pro 13.3 i5 2.3GHz (category_id=1)
(1, 'https://cdsassets.apple.com/live/SZLF0YNV/images/sp/111999_SP747_mbp13-gray.jpg', 1, 'active'),
(1, 'https://cdn.tgdd.vn/Products/Images/44/115387/apple-macbook-pro-mpxq2zp-a-core-i5-133-23ghz-8gb-1-450x300.jpg', 0, 'active'),
(1, 'https://cdsassets.apple.com/live/SZLF0YNV/images/sp/111999_SP747_mbp13-silver.jpg', 0, 'active'),
(1, 'https://ngocnguyen.vn/cdn/upload/files/do-hoa-vuot-troi-sac-net-tung-chi-tiet-37(63).png', 0, 'active'),
(1, 'https://laptoptitan.vn/wp-content/uploads/2020/02/Macbook-Pro-13-2019-4.jpg', 0, 'active'),
-- Product 2: MacBook Air 13.3 i5 1.8GHz 128GB (category_id=1)
(2, 'https://product.hstatic.net/200000373523/product/34925_laptop_apple_macbook_air_m0uu3_128gb__2017___silver__1_1_5308f3368d8245849dbe6c6c96a280cd_grande.jpg', 1, 'active'),
(2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQORjgFYoQPj-ILa7a7iMMHMV2vDlalPtbd-Q&s', 0, 'active'),
(2, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/308/710/products/51nqh-pphkl-jpeg.jpg?v=1672292782107', 0, 'active'),
(2, 'https://product.hstatic.net/1000384805/product/laptop_apple_macbook_air_2017_128gb_1.8ghz_intel_core_i5_2_2d4bfef3a30b412bb2561629dc8a36f7_master.jpg', 0, 'active'),
(2, 'https://laptoptitan.vn/wp-content/uploads/2021/04/Macbook_Air-13-inch-2013-204-2015-2016-2017-004.jpg', 0, 'active'),
-- Product 3: HP 250 G6 i5 7200U (category_id=1)
(3, 'https://anphat.com.vn/media/product/25740_laptop_hp_250_g6_2xr76pa_1.jpg', 1, 'active'),
(3, 'https://thegioiso247.vn/wp-content/uploads/2022/05/HP-250-G6-Notebook.jpg', 0, 'active'),
(3, 'https://cdn.cs.1worldsync.com/d2/f4/d2f48956-6c7d-45c0-8d13-5f6af7525c3e.jpg', 0, 'active'),
(3, 'https://salt.tikicdn.com/cache/w1200/ts/product/96/fd/7a/97ef5a6ba55dd25465c5cbffcb0f466e.jpg', 0, 'active'),
(3, 'https://ultrashop.uz/api/storage/product_thumbnails/680/5f73188bcc0a8.webp', 0, 'active'),
-- Product 4: MacBook Pro 15.4 i7 2.7GHz (category_id=1)
(4, 'https://i.ebayimg.com/images/g/orgAAOSwIfRlJr97/s-l1200.jpg', 1, 'active'),
(4, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/318/659/products/15-percentage-22-1-b-c-01051458-2c47-465f-96a2-93563bd56ceb.jpg?v=1534475784957', 0, 'active'),
(4, 'https://i.ebayimg.com/images/g/gsQAAOSw7SNlJr-A/s-l400.jpg', 0, 'active'),
(4, 'https://coretekcomputers.com/cdn/shop/products/MLH42LL_A_2_ab897357-5542-4dbf-b489-773425d33fa6_1024x1024.jpg?v=1608783392', 0, 'active'),
(4, 'https://www.atlascomputes.com/cdn/shop/products/Untitled13_20200628132008.png?v=1602274986', 0, 'active'),
-- Product 5: MacBook Pro 13.3 i5 3.1GHz (category_id=1)
(5, 'https://pos.nvncdn.com/9d42d7-25235/ps/20210914_SdENq683RC0S9ZBVv5hhHgjX.jpg', 1, 'active'),
(5, 'https://mac24h.vn/images/detailed/88/MacBook_Pro-13inch-2016-2017_005_8nr2-eq_zl6n-pj_qwqq-jm_rjzf-tm.jpeg', 0, 'active'),
(5, 'https://ngocnguyen.vn/cdn/upload/files/do-hoa-vuot-troi-sac-net-tung-chi-tiet-38(8).png', 0, 'active'),
(5, 'https://product.hstatic.net/200000782117/product/2_cc35dd0b5d734a0da04a042136c0e2ce_master.jpg', 0, 'active'),
(5, 'https://macvn.com.vn/wp-content/uploads/2024/08/Macbook-Pro-13inch-2016-USED-Core-i5-2.0Ghz-Ram-8Gb-SSD-256Gb-1-1200x846.jpg', 0, 'active'),
-- Product 6: MacBook Pro 15.4 i7 2.2GHz (category_id=1)
(6, 'https://macmall.vn/uploads/macbook-pro-15inch-2018-macmall_1718126810.png', 1, 'active'),
(6, 'https://m.media-amazon.com/images/I/61EaR0v9+7L._AC_UF894,1000_QL80_.jpg', 0, 'active'),
(6, 'https://bizweb.dktcdn.net/thumb/grande/100/318/659/files/15-percentage-22-3.png?v=1530849316860', 0, 'active'),
(6, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYwPJEhClbDMaDCwVMert09SOaUbxjHM38VA&s', 0, 'active'),
(6, 'https://muabanlaptopcuhcm.com/wp-content/uploads/2020/05/Macbook-Pro-Retina-2014-MGXA2-05.jpg', 0, 'active'),
-- Product 7: MacBook Air 13.3 i5 1.8GHz 256GB (category_id=1)
(7, 'https://cdn.tgdd.vn/Products/Images/44/106880/apple-macbook-air-mqd42sa-a-i5-5350u-8gb-256gb-bac-450x300-450x300.jpg', 1, 'active'),
(7, 'https://www.plug.tech/cdn/shop/products/Untitled_500x500px_93_967a8b56-4df4-416d-9804-f78c23d1a587.png?v=1659732800&width=500', 0, 'active'),
(7, 'https://laptoptitan.vn/wp-content/uploads/2021/04/Macbook_Air-13-inch-2013-204-2015-2016-2017-005.jpg', 0, 'active'),
(7, 'https://bizweb.dktcdn.net/100/046/882/products/apple-macbook-air-md226-md226ll-2011.jpg?v=1487428980417', 0, 'active'),
(7, 'https://cdnp0.stackassets.com/f8e8304f6729c2738dbcdb887dcb8a0b23b96dc3/store/64c5f2dafdcf0d48a9264d337a2caf320d4c80e036a94638df262d9dced4/product_340140_product_shots3.jpg', 0, 'active'),
-- Product 8: ZenBook UX430UN (category_id=1)
(8, 'https://ducanhcomputer.com/uploads/san-pham/2019_03/gv096t.jpg', 1, 'active'),
(8, 'https://phucanhcdn.com/media/product/31417-ux430un-gv091t-1.jpg', 0, 'active'),
(8, 'https://laptop88.vn/media/product/4313_ux430un_gv096t___2.jpg', 0, 'active'),
(8, 'https://product.hstatic.net/1000267672/product/asus_zenbook_ux430un-gv096t2_grande.jpg', 0, 'active'),
(8, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStA_htMmbXQhHjY5JZ9Sj5JFOVMOIuqutzQg&s', 0, 'active'),
-- Product 9: Swift 3 (category_id=1)
(9, 'https://cdn.tgdd.vn/Products/Images/44/269313/acer-swift-3-sf314-511-55qe-i5-nxabnsv003-120122-022600-600x600.jpg', 1, 'active'),
(9, 'https://www.acervietnam.com.vn/wp-content/uploads/2021/06/acer-swift-3-sf314-512-sf-314-512t-fingerprint-backlit-on-wallpaper-logo-pure-silver-01-min.png', 0, 'active'),
(9, 'https://bizweb.dktcdn.net/thumb/grande/100/512/769/products/acer-swift-3-2020-laptop-k1-1.jpg?v=1714407605737', 0, 'active'),
(9, 'https://bizweb.dktcdn.net/100/082/878/products/42871-laptop-acer-swift-3-sf314-512-56qn-2.jpg?v=1664805814097', 0, 'active'),
(9, 'https://no1computer.vn/images/products/2022/11/22/large/acer-swift-3-sf314-511-thietke2_1669110542.jpg', 0, 'active'),
-- Product 10: HP 250 G6 i3 6006U (category_id=1)
(10, 'https://product.hstatic.net/1000296652/product/kk_1a586f1bece145bd8a4cbfc80f4c63f2_7a0b155ca637451e81f6e55005c1f568.jpg', 1, 'active'),
(10, 'https://cdn.tgdd.vn/Products/Images/44/132735/hp-250-g6-i3-6006u-2fg16pa-2-2.png', 0, 'active'),
(10, 'https://cdn.tgdd.vn/Products/Images/44/132735/hp-250-g6-i3-6006u-2fg16pa-1.jpg', 0, 'active'),
(10, 'https://product.hstatic.net/1000296652/product/kk_1a586f1bece145bd8a4cbfc80f4c63f2_7a0b155ca637451e81f6e55005c1f568_1024x1024.jpg', 0, 'active'),
(10, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPzJFuQF_jTzRuceuo5vNZd0DWt5Zi1WbzyQ&s', 0, 'active'),
-- Product 11: MacBook Pro 15.4 i7 2.8GHz (category_id=1)
(11, 'https://ttcenter.com.vn/uploads/product/8blddpkb-657-macbook-pro-2017-15-inch-i7-16gb-512gb-touchbar.jpg', 1, 'active'),
(11, 'https://drive.gianhangvn.com/image/macbook-pro-2016-i7-2330191j20085.jpg', 0, 'active'),
(11, 'https://images-na.ssl-images-amazon.com/images/I/61n86eDhDjL.jpg', 0, 'active'),
(11, 'https://coretekcomputers.com/cdn/shop/products/A1398_3_62a0f734-53bc-428c-a10b-0b04435a17b8_1024x1024.jpg?v=1602127485', 0, 'active'),
(11, 'https://bizweb.dktcdn.net/thumb/grande/100/318/659/files/15-percentage-22-3.png?v=1530849316860', 0, 'active'),
-- Product 12: Inspiron 3567 i3 6006U (category_id=1)
(12, 'https://cdn.tgdd.vn/Products/Images/44/91260/dell-inspiron-3567-i3-6006u-ava-600x600.jpg', 1, 'active'),
(12, 'https://cdn.tgdd.vn/Products/Images/44/91260/dell-inspiron-3567-i3-6006u-den-1.jpg', 0, 'active'),
(12, 'https://product.hstatic.net/200000680839/product/dell-inspiron-15-3567-2_f0490b94410c440bb848ea7ce81bd5b8_1024x1024.jpg', 0, 'active'),
(12, 'https://suachuamaytinh24.com/wp-content/uploads/2021/08/67.jpg', 0, 'active'),
(12, 'https://product.hstatic.net/200000680839/product/dell-inspiron-15-3567-2_f0490b94410c440bb848ea7ce81bd5b8_1024x1024.jpg', 0, 'active'),
-- Product 13: MacBook 12 (category_id=1)
(13, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/m/a/macbook-mnyf2-1.jpg', 1, 'active'),
(13, 'https://halomobile.vn/wp-content/uploads/2015/05/macbook-12-inch-2017-silver-700x700.jpg', 0, 'active'),
(13, 'https://truonggiang.vn/wp-content/uploads/2022/03/Macbook-Retina-12-inch-2016.png', 0, 'active'),
(13, 'https://khong-gian-viet.net/wp-content/uploads/2024/06/The-New-Macbook-12-inch-1.jpg', 0, 'active'),
(13, 'https://bizweb.dktcdn.net/100/308/710/products/44.jpg?v=1529037286927', 0, 'active'),
-- Product 14: Inspiron 3567 i7 7500U (category_id=1)
(14, 'https://product.hstatic.net/200000680839/product/dell_15-35xx_6a55b1fcb5c945eb8ca0a3be0a6a79a7_1024x1024.png', 1, 'active'),
(14, 'https://microless.com/cdn/products/42a86f0ed40abedae44168d1ff0575b6-hi.jpg', 0, 'active'),
(14, 'https://product.hstatic.net/200000680839/product/3567_0df51b5deba14d659df41728a4f39b98.png', 0, 'active'),
(14, 'https://5.imimg.com/data5/SELLER/Default/2024/3/397369414/WZ/OS/EY/1888409/31.jpg', 0, 'active'),
(14, 'https://laptopbinhduongvtc.vn/FileUploads/Product/ImageList/2fdc8e4f027c4d3b84d31e723a9ffa56.jpeg', 0, 'active'),
-- Product 15: MacBook Pro 15.4 i7 2.9GHz (category_id=1)
(15, 'https://www.devicerefresh.com/cdn/shop/files/ba847be049015b2567b7de577c6b2e5a_417559ff-902c-485a-8e3b-7e56941e7195_800x.jpg?v=1720026879', 1, 'active'),
(15, 'https://laptopchat.vn/wp-content/uploads/2020/10/z2103851212499_46fe4ca538905be0bfec561f6c5f5b10.jpg', 0, 'active'),
(15, 'https://mac365.vn/wp-content/uploads/2018/11/macbook-pro-mptt2-2.jpg', 0, 'active'),
(15, 'https://tritienlaptop.com/wp-content/uploads/2022/09/Macbook-Pro-2017-anh-mo-ta-3-1.jpg', 0, 'active'),
(15, 'https://ngocnguyen.vn/cdn/upload/files/do-hoa-vuot-troi-sac-net-tung-chi-tiet-38(10).png', 0, 'active'),
-- Product 16: IdeaPad 320-15IKB (category_id=1)
(16, 'https://maytinhcdc.vn/media/product/919_148.jpg', 1, 'active'),
(16, 'https://maytinhcdc.vn/media/product/921_145.jpg', 0, 'active'),
(16, 'https://phongvu.vn/cong-nghe/wp-content/uploads/sites/2/2018/05/69-1.png', 0, 'active'),
(16, 'https://laptopre.vn/upload/picture/picture-21632901594.jpg', 0, 'active'),
(16, 'https://cdn.tgdd.vn/Products/Images/44/139339/lenovo-ideapad-320-15ikbn-i7-8550u-4gb-1tb-2gb-mx1-avarta-1-700x467.png', 0, 'active'),
-- Product 17: XPS 13 i5 8250U (category_id=1)
(17, 'https://laptopmd.vn/userdata/6449/wp-content/uploads/2022/10/37535-37521-36346-35154-dell-xps-13-9350-core-i5-6200u-2-2ghz-ram-4gb-256gb-ssd-13fhd-win-10-33563-1.png', 1, 'active'),
(17, 'https://laptopbaominh.com/wp-content/uploads/2019/12/38138_38134_dell-xps-13-9370-i7-8550u-8gb-256gb-pcie-13-3-qhd-touch-win-10_38023_2.jpg', 0, 'active'),
(17, 'https://laptopmd.vn/userdata/6449/wp-content/uploads/2022/10/dell-9370.jpg', 0, 'active'),
(17, 'https://laptopbaominh.com/wp-content/uploads/2020/05/559844_dell-xps-93506.png', 0, 'active'),
(17, 'https://maytinhnhapkhau.com.vn/wp-content/uploads/2019/01/xps-13-9370-hanoilab-3-1.jpg', 0, 'active'),
-- Product 18: Vivobook E200HA (category_id=1)
(18, 'https://channel.vcmedia.vn/prupload/164/2016/03/img20160321235342405.jpg', 1, 'active'),
(18, 'https://laptop88.vn/media/news/3006_AsusE200HA1.png', 0, 'active'),
(18, 'https://m.media-amazon.com/images/I/61m2mqgXERL.jpg', 0, 'active'),
(18, 'https://www.laptopsdirect.co.uk/Images/E200HA-FD0004T_3_LargeProductImage.jpg?v=2', 0, 'active'),
(18, 'https://5.imimg.com/data5/WG/LV/MY-5267823/asus-vivobook-e200ha-laptop.png', 0, 'active'),
-- Product 19: Legion Y520-15IKBN (category_id=1)
(19, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBqNiZbjTx6WMnyBwiedE8HsyA4rTOSKizig&s', 1, 'active'),
(19, 'https://cdn.tgdd.vn/Products/Images/44/113671/lenovo-y520-15ikbn-i7-7700hq-450x300-450x300.jpg', 0, 'active'),
(19, 'https://maytinhcdc.vn/media/product/930_107.png', 0, 'active'),
(19, 'https://anphat.com.vn/media/product/25214_laptop_lenovo_legion_y520_15ikbn_80wk015fvn__1.png', 0, 'active'),
(19, 'https://cohotech.vn/wp-content/uploads/2019/06/Laptop-Lenovo-Legion-Y520-mat-lung-va-phia-duoi.jpg', 0, 'active'),
-- Product 20: HP 255 G6 (category_id=1)
(20, 'https://www.notebookcheck.net/uploads/tx_nbc2/1503610-1_04.jpg', 1, 'active'),
(20, 'https://maytinhgiare.vn/hinh-anh/san-pham/HP%20Notebook%20255%20G6%201.jpg', 0, 'active'),
(20, 'https://maytinhgiare.vn/hinh-anh/san-pham/HP%20Notebook%20255%20G6%203.jpg', 0, 'active'),
(20, 'https://cdn.cs.1worldsync.com/bc/60/bc6027c3-e943-4f78-b1e9-154414fdeaa9.jpg', 0, 'active'),
(20, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH5O7noiJ65g7n33zlhI0cSZ3K0MprmrayoQ&s', 0, 'active'),
-- Product 21: Inspiron 5379 (category_id=1)
(21, 'https://cohotech.vn/wp-content/uploads/2019/05/Laptop-Dell-Insprion-2in1-i5379-768x768.jpg', 1, 'active'),
(21, 'https://cdn.tgdd.vn/Products/Images/44/155735/dell-inspiron-5379-i7-8550u-c3ti7501w-xam-2-750x500.jpg', 0, 'active'),
(21, 'https://cdn.tgdd.vn/Products/Images/44/155735/dell-inspiron-5379-i7-8550u-c3ti7501w-xam-13-750x500.jpg', 0, 'active'),
(21, 'https://cdn.tgdd.vn/Products/Images/44/155735/dell-inspiron-5379-i7-8550u-c3ti7501w-xam-1-750x500.jpg', 0, 'active'),
(21, 'https://cdn.tgdd.vn/Products/Images/44/155735/Kit/dell-inspiron-5379-i7-8550u-c3ti7501w-bo-ban-hang-org.jpg', 0, 'active'),
-- Product 22: HP 15-BS101nv (category_id=1)
(22, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS63T43yHWJ7H24fL_MxWrZ9RSJrLB2R4FdUg&s', 1, 'active'),
(22, 'https://nairobicomputershop.co.ke/media/cache/a5/65/a56519764950bb67e8cefeb5559929ed.jpg', 0, 'active'),
(22, 'https://allegro.stati.pl/AllegroIMG/PRODUCENCI/HP/4TY92EA/03-stylowy-elegancki%2Cprzenosny.jpg', 0, 'active'),
(22, 'https://allegro.stati.pl/AllegroIMG/PRODUCENCI/HP/4TY94EA/03-stylowy-elegancki%2Cprzenosny.jpg', 0, 'active'),
(22, 'https://kozak.pl/userdata/public/gfx/1637/HP-15-db1019nw.jpg', 0, 'active'),
-- Product 23: Inspiron 5570 (category_id=1)
(23, 'https://bizweb.dktcdn.net/thumb/grande/100/244/033/products/0104539-dell-inspiron-5570-15-5000-series-i7-8550u-156-full-hd-notebook-600-jpeg-63c6b10e-389a-4f93-86b0-94b9da7826f8-93d7976c-e12d-4172-9590-19177f9d5c98.jpg?v=1561955966243', 1, 'active'),
(23, 'https://www.laptopvip.vn/images/ab__webp/detailed/10/DELL-Inspiron-5570-1.8GHz-i7-8550U-15.webp', 0, 'active'),
(23, 'https://product.hstatic.net/1000287389/product/5570-i5-4gb-1tb-vga-ati-m530-2g-15-6-fhd-win10-m5i5238w-b-bac-_37924_2_3fbe18de5bf94cfc92f2eb3766d22fca_master.png', 0, 'active'),
(23, 'https://ttcenter.com.vn/uploads/photos/1695108414_1818_2f07a92784a9efd990e4cced8357694d.png', 0, 'active'),
(23, 'https://drive.gianhangvn.com/image/dell-inspiron-5570-i5-8250u-tai-laptop43-2180060j20085.jpg', 0, 'active'),
-- Product 24: Latitude 5590 (category_id=1)
(24, 'https://www.laptopvip.vn/images/companies/1/032018/Dell/Dell-Latitude-5590-8th-intel-core-review-3.png', 1, 'active'),
(24, 'https://i.dell.com/sites/imagecontent/products/PublishingImages/latitude/5000/15-5590/laptop-latitude-15-5590-mlk-love-pdp-design-3.jpg', 0, 'active'),
(24, 'https://laptopre.vn/storage/photos/1/hinh-that/Dell/5590-latitude/laptop-Dell-latitude-5590.png', 0, 'active'),
(24, 'https://reviewed.vn/wp-content/uploads/2019/08/csm_Dell_Latitude_5590_4_68d4986001-e1565405911619.jpg', 0, 'active'),
(24, 'https://laptophitech.vn/media/product/264_laptophitech_vn_dell_latitude_5590__7_.jpg', 0, 'active'),
-- Product 25: ProBook 470 (category_id=1)
(25, 'https://www.laptopvip.vn/images/ab__webp/thumbnails/800/800/detailed/19/Hp_Probook_470_03.png.webp', 1, 'active'),
(25, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFrA3L_qIJaQDKg-qHQX5575n82E7VyRLdVA&s', 0, 'active'),
(25, 'https://maytinhviet.vn/hinh-anh/san-pham/hp-probook-470-1.jpg', 0, 'active'),
(25, 'https://laptopnow.vn/uploads/products/2024/12/hp-470-g7-3-1735540784.webp', 0, 'active'),
(25, 'https://www.laptopvip.vn/images/ab__webp/thumbnails/800/800/detailed/10/Hp_Probook_470_01_5p4g-w9.png.webp', 0, 'active'),
-- Product 26: HP 17-ak001nv (category_id=1)
(26, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUphPMt_I0fN15npz0LnWIQuqMXNp_Ayt9bw&s', 1, 'active'),
(26, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzO_bHpWaz6LZNi4xQST1qBwFtlhxfMnKqTI9bPG7bEPDpY73kZmgeRzlpHEoKgjkd0iw&usqp=CAU', 0, 'active'),
(26, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThnM5M9u5dC4bqGKgkUmnJFtaFUKaDv3tvgQ&s', 0, 'active'),
(26, 'https://mtsplus.tn/1193-large_default/pc-portable-hp-laptop-15-dw3000nk-i3-11e-gen-4go-1to.jpg', 0, 'active'),
(26, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzlfKaPEiWTOjHUNIOphRhC51pQQtm9CjC3lsbaM3Rna8sF4yfh6NyNAd_a8hmmgwMXWE&usqp=CAU', 0, 'active'),
-- Product 27: XPS 13 i7 8550U (category_id=1)
(27, 'https://product.hstatic.net/200000553329/product/xps_9370_core_i7_ram_16g_ssd_512g_laptopone_8a38fc7aa6e44968acf94d5f4a4b497b.jpg', 1, 'active'),
(27, 'https://laptoptitan.vn/wp-content/uploads/2019/08/Dell-Xps-13-9370-7.jpg', 0, 'active'),
(27, 'https://ducvietco.com/mediacenter/media/images/346/products/346/1936/s250_0/tai-xuong-48-1695116025.jpg', 0, 'active'),
(27, 'https://gamalaptop.vn/wp-content/uploads/2019/12/Dell-XPS-13-9370-i7-8550u_05.jpg', 0, 'active'),
(27, 'https://laptoplongs.vn/uploads/images/laptop-dell-xps-9370.jpg', 0, 'active'),
-- Product 28: IdeaPad 120S-14IAP (category_id=1)
(28, 'https://cdn.tgdd.vn/Products/Images/44/194252/lenovo-ideapad-120s-14iap-n4200-4gb-64gb-win10-81-15-600x600.jpg', 1, 'active'),
(28, 'https://www.anphatpc.com.vn/media/lib/30752_phongvulenovo120S-14IAP2.jpg', 0, 'active'),
(28, 'https://p1-ofp.static.pub/medias/bWFzdGVyfHJvb3R8Nzc4NjF8aW1hZ2UvcG5nfGg3My9oNTEvOTQ5NDA1OTEyMjcxOC5wbmd8OTcyMDdhMTFlNTBjZTg0NjQyZmM0YWM3OTM2N2QxOTg1ZDU2ZmY5N2JlMTZkN2RlMzg4ZDhjYjBiNGZhZDI1Mw/lenovo-laptop-ideapad-120s-14-hero.png', 0, 'active'),
(28, 'https://anphat.com.vn/media/product/30752_laptop_lenovo_ideapad_120s_14iap_81a500jyvn_3.jpg', 0, 'active'),
(28, 'https://cdn.myshoptet.com/usr/www.pocitarna.cz/user/shop/big/47984-3_lenovo-ideapad-120s-14iap-4.jpg?67116d40', 0, 'active'),
-- Product 29: Inspiron 5770 (category_id=1)
(29, 'https://laptopxachtay.com.vn/kcfinder/upload/images/Laptop/Dell/5000/5570.JPG', 1, 'active'),
(29, 'https://laptopxachtay.com.vn/Images/Products/38432_38172_38074_37994_37970_37942_37925_dell-inspiron-5570-i5-4gb-1tb-vga-ati-m530-2g-15-6-fhd-win10-m5i5238w-b-bac-_37924_2.png?', 0, 'active'),
(29, 'https://images-na.ssl-images-amazon.com/images/I/51YEhR7CsjL.jpg', 0, 'active'),
(29, 'https://www.laptopvip.vn/images/ab__webp/detailed/19/71NwsvKTnuL._SL1500_.webp', 0, 'active'),
(29, 'https://worklap.vn/image/dell-precision-5770-laptop-cu-gia-re-ryydddv.jpg', 0, 'active'),
-- Product 30: ProBook 450 (category_id=1)
(30, 'https://cdn.tgdd.vn/Products/Images/44/315906/hp-probook-450-g10-i5-873d1pa-1-1-750x500.jpg', 1, 'active'),
(30, 'https://laptopworld.vn/media/product/16336_hp_probook_450_g10_logo.jpg', 0, 'active'),
(30, 'https://static.hungphatlaptop.com/wp-content/uploads/2022/10/HP-ProBook-450-G9-2022-H4.jpeg', 0, 'active'),
(30, 'https://lapvip.vn/upload/file/thumb_800x0/hp-probook-450-g8-lapvip-3-1626408741.jpg', 0, 'active'),
(30, 'https://cdn.tgdd.vn/Products/Images/44/291154/hp-probook-450-g9-i5-6m0y9pa-thumb-1-600x600.jpg', 0, 'active'),
-- Product 31: X540UA-DM186 (category_id=1)
(31, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLy7FEzOOzczRnST3NIwTvAjYA5dTdpm5Ccg&s', 1, 'active'),
(31, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpHLwZKtj2ZheP7VVjIYoAOydOrjic9LZWG9DZBo8fPFlLCWxN1NvCNHh42jt4_Mo0FgA&usqp=CAU', 0, 'active'),
(31, 'https://mauricomputacion.com.ar/images/productos/galerias/20301/500x500/595430538.webp', 0, 'active'),
(31, 'https://u-begemota.ru/wa-data/public/shop/products/60/24/108332460/images/88461/88461.750@2x.jpg', 0, 'active'),
(31, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVAn1cxczP0KUkahCP3-ePx3tVHRRefD35Vd3bUwYlPw6FBZauAh29oxHIXhn369VyB_s&usqp=CAU', 0, 'active'),
-- Product 32: Inspiron 7577 (category_id=1)
(32, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/i/n/inspiron-15-gaming-7577-70158745.jpg', 1, 'active'),
(32, 'https://gamalaptop.vn/wp-content/uploads/2021/09/Dell-Inspiron-7577-i7-7700HQ-GTX-1060-06.jpg', 0, 'active'),
(32, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/i/n/inspiron-15-gaming-7577-70158745-2.png', 0, 'active'),
(32, 'https://laptopre.vn/upload/picture/picture-01622619191.jpg', 0, 'active'),
(32, 'https://laptoptld.com/wp-content/uploads/2022/05/Laptop-Dell-Gaming-Inspiron-15-7577--300x212.jpg', 0, 'active'),
-- Product 33: X542UQ-GO005 (category_id=1)
(33, 'https://cdn.bdstall.com/product-image/giant_62782.jpg', 1, 'active'),
(33, 'https://img3.softcom.cz/asus-x542uq-15-6-i5-7200u-256-ssd-8g-w10-sedy_ien208251.jpg', 0, 'active'),
(33, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6pYXHrSRJJXzXO88hqwRDwKOB-iP0wFz4W_UzDwD05cKjiv-LfX28-OASz2s0MxKVRTE&usqp=CAU', 0, 'active'),
(33, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYGFIwk1ttVasiso9SKeYnsIiTtMCdVsJ-PePlYjzS050jBKUQfcOV4cfbKlM8ilWRpWo&usqp=CAU', 0, 'active'),
(33, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-d3bZ9o-_gKA6vcg-Achk2EBDPTrfTUIvMTUe-Ti3kqDe339oIgB0luKy-9vmeOqKFSk&usqp=CAU', 0, 'active'),
-- Product 34: Aspire A515-51G (category_id=1)
(34, 'https://cdn.tgdd.vn/Products/Images/44/111120/acer-aspire-a515-51g-52zs-i5-7200u-1-450x300.jpg', 1, 'active'),
(34, 'https://cdn.tgdd.vn/Products/Images/44/111120/acer-aspire-a515-51g-52zs-i5-7200u-1-1.jpg', 0, 'active'),
(34, 'https://images-na.ssl-images-amazon.com/images/I/71HaIH7W5gL.jpg', 0, 'active'),
(34, 'https://maytinhcdc.vn/media/product/422_116.jpg', 0, 'active'),
(34, 'https://i5.walmartimages.com/asr/55a4e3de-710c-4e1e-95a6-66ffaac2620f_1.7fe85a24344059f1b298d8441f2858f4.jpeg?odnHeight=768&odnWidth=768&odnBg=FFFFFF', 0, 'active'),
-- Product 35: Inspiron 7773 (category_id=1)
(35, 'https://www.notebookcheck.net/uploads/tx_nbc2/DellInspiron17-7773__1_.JPG', 1, 'active'),
(35, 'https://tuanphong.vn/pictures/full/2019/12/1577598437-577-nang-cap-ssd-ram-cho-laptop-dell-inspiron-17-7773-1.jpg', 0, 'active'),
(35, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQG0chUJDBqZrgnGSUJDmNW20v-_V1fdO8WIi0-J29gidWZT2LDCDeTlnQ-cBpjS9l4kxA&usqp=CAU', 0, 'active'),
(35, 'https://laptoptoanthanh.com/upload/sanpham/476826196642.jpg', 0, 'active'),
(35, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQv7FoSbAymqpCwBPL1VFZ8AKmP3EfvNaBiRKEwl71y1taYbjEIUMA54ZxFzTLdo-68qTw&usqp=CAU', 0, 'active'),
-- Product 36: MacBook Pro 13.3 i5 2.0GHz (category_id=1)
(36, 'https://bizweb.dktcdn.net/thumb/grande/100/318/659/products/8836101-jpeg.jpg?v=1536732696847', 1, 'active'),
(36, 'https://zshop.vn/images/thumbnails/2035/1500/detailed/55/1588593628_IMG_1351869_nt99-vj_tm90-xc.jpg', 0, 'active'),
(36, 'https://www.thienthientan.vn/wp-content/uploads/2020/06/5-36.jpg', 0, 'active'),
(36, 'https://www.thienthientan.vn/wp-content/uploads/2020/06/4-45.jpg', 0, 'active'),
(36, 'https://cdn.askul.co.jp/img/product/3L2/EJ08832_3L2.jpg', 0, 'active'),
-- Product 37: IdeaPad 320-15ISK (category_id=1)
(37, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9C1N0Ucdv6__RNBFCARgxZKI_g4fo2f7M2w&s', 1, 'active'),
(37, 'https://maytinhcdc.vn/media/product/919_148.jpg', 0, 'active'),
(37, 'https://salt.tikicdn.com/cache/w300/ts/product/27/61/e5/cd443361b7648733a953a11c3b81b3bd.jpg', 0, 'active'),
(37, 'https://images.tokopedia.net/img/cache/500-square/product-1/2019/11/24/4607130/4607130_3c418106-19fe-45e1-a440-cc6be6a23819_700_700.jpg', 0, 'active'),
(37, 'https://www.phucanh.vn/media/lib/30140_LaptopLenovoIdeapad32015ISK80XH0044VNBlack-1.jpg', 0, 'active'),
-- Product 38: Rog Strix (category_id=1)
(38, 'https://bizweb.dktcdn.net/100/512/769/files/1-d4dfca93-7ffd-4be2-8d78-7be1a8e2e693.jpg?v=1716189372866', 1, 'active'),
(38, 'https://anphat.com.vn/media/product/49165_laptop_asus_rog_strix_g16_g614ju_n4132w__2_.jpg', 0, 'active'),
(38, 'https://nvs.tn-cdn.net/2023/04/laptop-asus-rog-strix-g16-g614ji-n4084w-2.webp', 0, 'active'),
(38, 'https://image.ceneostatic.pl/data/products/154379565/p-laptop-asus-rog-strix-g16-16-i7-16gb-512gb-win11-g614jun4132w.jpg', 0, 'active'),
(38, 'https://assets.mmsrg.com/isr/166325/c1/-/ASSET_MMS_117336232?x=536&y=402&format=jpg&quality=80&sp=yes&strip=yes&trim&ex=536&ey=402&align=center&resizesource&unsharp=1.5x1+0.7+0.02&cox=0&coy=0&cdx=536&cdy=402', 0, 'active'),
-- Product 39: Inspiron 3567 i5 7200U (category_id=1)
(39, 'https://cdn.tgdd.vn/Products/Images/44/156861/dell-inspiron-3567-i5-7200u-70119158-450-300-600x600.png', 1, 'active'),
(39, 'https://cdn.tgdd.vn/Products/Images/44/91260/dell-inspiron-3567-i3-6006u-den-1.jpg', 0, 'active'),
(39, 'https://maytinhgiare.vn/hinh-anh/san-pham/3567%202.jpeg', 0, 'active'),
(39, 'https://hienlaptop.com/wp-content/uploads/2022/08/LAPTOP-CU-DELL-INSPIRON-3567.jpg', 0, 'active'),
(39, 'https://5.imimg.com/data5/BI/HS/XH/SELLER-22993468/dell-inspiron-3567-i5-laptop-500x500.jpg', 0, 'active'),
-- Product 40: Logitech MX Master 3S (category_id=3)
(40, 'https://d28jzcg6y4v9j1.cloudfront.net/chuot_logitech_mx_3s_co_thiet_ke_chuan_cong_thai_hoc_1719808317791.jpg', 1, 'active'),
(40, 'https://cdn.tgdd.vn/Products/Images/86/326660/chuot-bluetooth-logitech-mx-master-3s-for-mac-xam-1-750x500.jpg', 0, 'active'),
(40, 'https://product.hstatic.net/200000637319/product/ezgif-4-a3b797d08b_fbab0a465ae94587bd4e4c8a26e74a38_master.jpg', 0, 'active'),
(40, 'https://bizweb.dktcdn.net/100/450/414/products/6000053-tinhte-logitech-mx-master-3s-22.jpg?v=1664462416213', 0, 'active'),
(40, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/1/2/12_37_1.jpg', 0, 'active'),
-- Product 41: ASUS ROG Strix Scope NX TKL Deluxe (category_id=5)
(41, 'https://minhancomputercdn.com/media/product/10303_b__n_ph__m_c___asus_rog_strix_scope_nx_tkl_deluxe_1.jpg', 1, 'active'),
(41, 'https://product.hstatic.net/200000722513/product/ix-scope-nx-tkl-deluxe_-_red_switch-3_7234fdc478f84cdc966a0683b3f05a74_fc21cc2f99e24abea3ae6ffaeae108d8_grande.jpg', 0, 'active'),
(41, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/f/r/frame_379_-_2025-05-27t161541.953.png', 0, 'active'),
(41, 'https://product.hstatic.net/1000333506/product/10303_b__n_ph__m_c___asus_rog_strix_scope_nx_tkl_deluxe_4_550268e2ed774611a0fec5b103b16b3f.jpg', 0, 'active'),
(41, 'https://product.hstatic.net/200000722513/product/ix-scope-nx-tkl-deluxe_-_red_switch-3_7234fdc478f84cdc966a0683b3f05a74_fc21cc2f99e24abea3ae6ffaeae108d8_grande.jpg', 0, 'active'),
-- Product 42: Logitech Combo Touch iPad Pro (category_id=5)
(42, 'https://resource.logitech.com/w_1200,h_630,c_limit,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/logitech/en/products/mobility/combo-touch-for-ipad-pro/combo-touch-ipadpro-og-image.jpg?v=1', 1, 'active'),
(42, 'https://cdn8.web4s.vn/media/products/1050/hpnf2-av1.jpg', 0, 'active'),
(42, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS14sokrM_sFoVcX3AbULxjaWP4isy7a8Lwkg&s', 0, 'active'),
(42, 'https://cdn8.web4s.vn/media/products/logitech%20combo%20touch/logitech%20combo%20touch%20keyboard%2011%20inch%20-%202.jpg', 0, 'active'),
(42, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSePt1hniSJcKSJHoy7XZ-FwER9RkkphzmNoQ&s', 0, 'active'),
-- Product 43: Razer DeathAdder V3 Pro (category_id=3)
(43, 'https://bizweb.dktcdn.net/100/329/122/products/chuot-gaming-khong-day-razer-deathadder-v3-pro-0a5a68a8-10c5-433d-bece-b49ec8828fc5.jpg?v=1746496978517', 1, 'active'),
(43, 'https://product.hstatic.net/200000722513/product/f7a42cd48b1a7f325af695b3dba_1024x1024_d0730f9347bd45858c1a36aa992b51fb_64e87797e31545279c73ab9f23cf1228.png', 0, 'active'),
(43, 'https://hanoicomputercdn.com/media/product/67663_chuot_game_khong_day_razer_deathadder_v3_pro_ergonomic_usb_rgb_rz01_04630100_r3a1_0004_5.jpg', 0, 'active'),
(43, 'https://product.hstatic.net/200000837185/product/da-v3-pro-5_compressed_7b9af5e4d9634f818c9da580f547d4f3_master.jpg', 0, 'active'),
(43, 'https://product.hstatic.net/200000837185/product/da-v3-pro-4_compressed_b00078bd813243fa8bf11769fa32ef29_master.jpg', 0, 'active'),
-- Product 44: Keychron K8 Pro (category_id=5)
(44, 'https://s88.vn/media/lib/21-10-2023/8378_b__n_ph__m_keychron_k8_pro.jpg', 1, 'active'),
(44, 'https://lucas.vn/wp-content/uploads/2022/07/Ban-phim-Keychron-K8-Pro-15-546x400-1.png', 0, 'active'),
(44, 'https://photo2.tinhte.vn/data/attachment-files/2022/07/6065508_tinhte_keychron_k8_pro_14.jpg', 0, 'active'),
(44, 'https://cdn.shopify.com/s/files/1/0608/5145/4022/files/Keychron-K8-Pro-9_8a966894-1bc7-4ae3-85a9-191aa948d10a.png?v=1728184248', 0, 'active'),
(44, 'https://nguyencongpc.vn/media/product/17232-b--n-ph--m-c---keychron-k8-rgb----aluminum-frame--1.png', 0, 'active'),
-- Product 45: MSI Katana 15
(45, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/msi_katana_15_b13v_1_9310c95515.png', 1, 'active'),
(45, 'https://cdn.tgdd.vn/Products/Images/44/310447/msi-katana-15-b13vfk-i7-676vn-1-750x500.jpg', 0, 'active'),
(45, 'https://storage-asset.msi.com/global/picture/image/feature/nb/GF/Katana-15-A13V/photo15-3.png', 0, 'active'),
(45, 'https://bizweb.dktcdn.net/thumb/large/100/386/607/products/msi-katana-15-ban-phim-42844f95-eace-4702-90cc-4f9ca0c4ce33-11913e79-988f-4193-a232-eb730c36de85.jpg?v=1730688292573', 0, 'active'),
(45, 'https://product.hstatic.net/200000722513/product/1205vn_da651643e91047bfa9729c53f93ffc6e_large_39f1561f3448481c94add35d7fda7dc4.png', 0, 'active'),
-- Product 46: MSI Stealth 16
(46, 'https://cdn.tgdd.vn/Products/Images/44/322946/msi-gaming-stealth-16-ai-studio-a1vgg-ultra-9-089vn-1-750x500.jpg', 1, 'active'),
(46, 'https://storage-asset.msi.com/global/picture/image/feature/nb/2022_RPL/stealth_16_a13/msi-stealth16-13th-kv-laptop-black.png', 0, 'active'),
(46, 'https://asset.msi.com/resize/image/global/product/product_16687515612223872ac159b752cf4a719ab4a9b90c.png62405b38c58fe0f07fcef2367d8a9ba1/600.png', 0, 'active'),
(46, 'https://storage-asset.msi.com/global/picture/image/feature/nb/2022_RPL/stealth_16_a13/msi-stealth16-thine-blue-new.png', 0, 'active'),
(46, 'https://storage-asset.msi.com/global/picture/image/feature/nb/2022_RPL/stealth_16_a13/msi-stealth16-thine-white-new.png', 0, 'active'),
-- Product 47: MSI Prestige 14 Evo
(47, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/msi_prestige_14_ai_studio_c1u_1_5ab50baa17.png', 1, 'active'),
(47, 'https://cdn.tgdd.vn/Products/Images/44/310451/msi-prestige-14-evo-b13m-i5-401vn-130723-111542-600x600.jpg', 0, 'active'),
(47, 'https://bizweb.dktcdn.net/thumb/large/100/386/607/products/msi-prestige-14-evo-b13m.png?v=1729400940147', 0, 'active'),
(47, 'https://product.hstatic.net/200000837185/product/1024_4a5ffa7c8b99451a9b4296acf4010146_master.png', 0, 'active'),
(47, 'https://storage-asset.msi.com/global/picture/image/feature/nb/2024_LNL/Prestige-14-AI-plus-Evo-C2VM/thin-img-m.png', 0, 'active'),
-- Product 48: MSI Creator Z17
(48, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/msi_creator_16_ai_studio_a1v_1_7eece4ea8a.png', 1, 'active'),
(48, 'https://storage-asset.msi.com/global/picture/image/feature/nb/2023_RPLS/Creator-Z17-HX-Studio-A14V/gallery02.png', 0, 'active'),
(48, 'https://asset.msi.com/resize/image/global/product/product_1689735851cb8c08d72a33d36b86e5e203c03e2c02.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png', 0, 'active'),
(48, 'https://minhancomputercdn.com/media/product/13510_msi_creator_z17_hx_studio_a13vgt_068vn_04.jpg', 0, 'active'),
(48, 'https://storage-asset.msi.com/global/picture/image/feature/nb/2022_RPL/creator-z17-a13v/images/kv-nb.png', 0, 'active'),
-- Product 49: Gigabyte AORUS 17
(49, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2022_9_26_637998081269981032_gigabyte-gaming-aorus-17-xe5-73vn534gh-i7-12700h-rtx3070ti-den-1.jpg', 1, 'active'),
(49, 'https://laptopbaoloc.vn/wp-content/uploads/2023/07/Laptop-Gaming-Gigabyte-AORUS-17-BKF-73VN254SH-4.jpg', 0, 'active'),
(49, 'https://product.hstatic.net/200000304081/product/1000__19__2712988dec1d4b47ba6a1029717d682f_grande.png', 0, 'active'),
(49, 'https://songphuong.vn/Content/uploads/2023/03/Laptop-Gigabyte-AORUS-17-BKF-73VN254SH-4-songphuong.vn_.jpg', 0, 'active'),
(49, 'https://lapvip.vn/upload/products/thumb_800x0/gigabyte-aorus-17-xe4-lapvip-4-1709633084.jpg', 0, 'active'),
-- Product 50: Gigabyte AERO 15 OLED
(50, 'https://product.hstatic.net/200000837185/product/laptopgigabyteaero15oledkd-72s1623go_a4a4b601ef9c4bddb1bdfd1d12825bef.png', 1, 'active'),
(50, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRj85ZdsZ4miECQrZnLZEz9Ww6k2yU7i0tUCw&s', 0, 'active'),
(50, 'https://bcavn.com/Image/Picture/Gigabyte/laptop/KD-72S1623GH.jpg', 0, 'active'),
(50, 'https://www.thienthientan.vn/wp-content/uploads/2021/06/9-3.jpg', 0, 'active'),
(50, 'https://laptoptld.com/wp-content/uploads/2023/04/4-2-300x300.webp', 0, 'active'),
-- Product 51: Gigabyte G5
(51, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2023_5_5_638188828261835779_gigabyte-gaming-g5-kf-e3vn313sh-i5-12500h-den-3.jpg', 1, 'active'),
(51, 'https://product.hstatic.net/200000304081/product/1000_55648a86099145528b054c604fc91a74_master_7ef755837b3547f587b411cd99891391.png', 0, 'active'),
(51, 'https://static.gigabyte.com/StaticFile/Image/Global/d164dfdb6ef49adb4d1d9bd5cae2f01e/Product/28519/Png', 0, 'active'),
(51, 'https://cdn.tgdd.vn/Products/Images/44/251426/gigabyte-gaming-g5-i5-5s11130sh-191021-102800-600x600.jpg', 0, 'active'),
(51, 'https://product.hstatic.net/200000680839/product/giga-g5-12th-18_4e0b3c0d103f4d1db3a7031b30d3c455_1024x1024.jpg', 0, 'active'),
-- Product 52: Samsung Galaxy S24 Ultra
(52, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2024_1_15_638409395342231798_samsung-galaxy-s24-ultra-xam-1.png', 1, 'active'),
(52, 'https://images.samsung.com/is/image/samsung/p6pim/vn/2401/gallery/vn-galaxy-s24-s928-sm-s928bzvqxxv-539307706?$684_547_PNG$', 0, 'active'),
(52, 'https://www.didongmy.com/vnt_upload/product/01_2024/thumbs/(600x600)_samsung_galaxy_s24_ultra_5g_den_didongmy_thumb_600x600_1_3.jpg', 0, 'active'),
(52, 'https://cdn.tgdd.vn/Products/Images/42/307174/samsung-galaxy-s24-ultra-xam-1-750x500.jpg', 0, 'active'),
(52, 'https://bvtmobile.com/uploads/source/sam-sung/s24-series/s24-ultra/samsung-galaxy-s24-ultra-5g.jpg', 0, 'active'),
-- Product 53: Samsung Galaxy A35
(53, 'https://cdn.mobilecity.vn/mobilecity-vn/images/2024/03/w300/samsung-galaxy-a35-tim.jpg.webp', 1, 'active'),
(53, 'https://cdn.tgdd.vn/Products/Images/42/321772/samsung-galaxy-a35-xanh-nhat-1-750x500.jpg', 0, 'active'),
(53, 'https://thetekcoffee.com/wp-content/uploads/2024/05/galaxy-a35-5g.png', 0, 'active'),
(53, 'https://images.samsung.com/is/image/samsung/p6pim/vn/feature/165055000/vn-feature-trendy-colors-that-look-amazing-540189928?$FB_TYPE_A_MO_JPG$', 0, 'active'),
(53, 'https://happyphone.vn/wp-content/uploads/2024/04/Samsung-Galaxy-A35.png', 0, 'active'),
-- Product 54: Samsung Galaxy Z Fold 6
(54, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/samsung_galaxy_z_fold6_gray_a413f785af.png', 1, 'active'),
(54, 'https://images.samsung.com/vn/smartphones/galaxy-z-fold6/images/galaxy-z-fold6-features-kv.jpg?imbypass=true', 0, 'active'),
(54, 'https://images.samsung.com/is/image/samsung/assets/vn/smartphones/galaxy-z-fold6/buy/Color_Selection_Silver_MO.png?imbypass=true', 0, 'active'),
(54, 'https://achaumobile.com/wp-content/uploads/2024/07/Frame-87575.png', 0, 'active'),
(54, 'https://images.samsung.com/vn/smartphones/galaxy-z-fold6/images/galaxy-z-fold6-features-accessories-mo.jpg?imbypass=true', 0, 'active'),
-- Product 55: Xiaomi 14 Pro
(55, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/xiaomi_redmi_note_14_5g_xanh_3_a16f31cae7.jpg', 1, 'active'),
(55, 'https://cdn.tgdd.vn/Products/Images/42/307882/xiaomi-14-pro-600x600.jpg', 0, 'active'),
(55, 'https://i02.appmifile.com/mi-com-product/fly-birds/redmi-note-14-pro-5g/m/57f3fc00566803602d256af1c1385b45.jpg', 0, 'active'),
(55, 'https://mihome.vn/wp-content/uploads/2023/10/xiaomi-14-2-420x420.jpg', 0, 'active'),
(55, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNimVAEGeJJRId-U18P_3IwcyB5lNgYBxBcg&s', 0, 'active'),
-- Product 56: Redmi Note 14 Pro+
(56, 'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/xiaomi_redmi_note_14_pro_plus_3_4d3d0d8993.jpg', 1, 'active'),
(56, 'https://www.didongmy.com/vnt_upload/product/01_2025/thumbs/(600x600)_xiaomi_redmi_note_14_pro_plus_5g_den_thumb_600x600_1.jpg', 0, 'active'),
(56, 'https://cdn.tgdd.vn/Products/Images/42/320731/xiaomi-redmi-note-14-pro-plus-thumb-600x600.jpg', 0, 'active'),
(56, 'https://i02.appmifile.com/321_operator_sg/10/03/2025/ad5654341f5ff7be53d3c68d098c323f.png', 0, 'active'),
(56, 'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/redmi_note_14_pro_gia_nhap_bang_xep_hang_antutu_thang_9_2_ea5bc4e7b9.jpg', 0, 'active'),
-- Product 57: Redmi A4 5G
(57, 'https://cdn.viettablet.com/images/detailed/65/redmi-a4-5g.jpg', 1, 'active'),
(57, 'https://rukminid2.flixcart.com/image/850/1000/xif0q/mobile/z/h/f/a4-5g-a4-5g-redmi-original-imah6yhdg9kpnzgd.jpeg?q=90&crop=false', 0, 'active'),
(57, 'https://www.financialexpress.com/wp-content/uploads/2024/11/cropped-Redmi-A4-5G1.jpg?w=640', 0, 'active'),
(57, 'https://bsmedia.business-standard.com/_media/bs/img/article/2024-11/20/full/1732097410-3511.png', 0, 'active'),
(57, 'https://img.baba-blog.com/2024/10/redmi-A4.jpg?x-oss-process=style%2Ffull', 0, 'active'),
-- Product 58: OPPO Find X7 Ultra
(58, 'https://cellphones.com.vn/sforum/wp-content/uploads/2024/03/OPPO-Find-X7-Ultra-DxOMark-1.jpeg', 1, 'active'),
(58, 'https://didongthongminh.vn/images/products/2024/05/21/large/oppo-find-x7-ultra-black_1716283217.jpeg', 0, 'active'),
(58, 'https://cdn.mobilecity.vn/mobilecity-vn/images/2024/01/oppo-find-x7-ultra-xanh.jpg.webp', 0, 'active'),
(58, 'https://sonpixel.vn/wp-content/uploads/2024/07/oppo-find-x7-ultra-1.jpg', 0, 'active'),
(58, 'https://images-cdn.ubuy.com.sa/6640ee91b46c8314af44c144-oppo-find-x7-ultra-5g-snapdragon-8-gen-3.jpg', 0, 'active'),
-- Product 59: OPPO Reno 11 Pro
(59, 'https://cdn.tgdd.vn/Products/Images/42/314210/oppo-reno-11-pro-xam-thumb-600x600.jpg', 1, 'active'),
(59, 'https://cdn.viettablet.com/images/detailed/59/oppo-reno11-pro-viettablet.jpg', 0, 'active'),
(59, 'https://image.oppo.com/content/dam/oppo/common/mkt/v2-2/reno11-pro-5g-en/specs/reno11-pro-860-720.png', 0, 'active'),
(59, 'https://cdn.tgdd.vn/Products/Images/42/314210/Kit/oppo-reno-11-pro-note-3.jpg', 0, 'active'),
(59, 'https://bvtmobile.com/uploads/source/oppo/oppo-reno11-pro/oppo-reno-11-pro-xam-5.jpg', 0, 'active'),
-- Product 60: OPPO A79 5G
(60, 'https://cdn.tgdd.vn/Products/Images/42/316776/oppo-a79-5g-tim-thumb-1-2-600x600.jpg', 1, 'active'),
(60, 'https://product.hstatic.net/1000063620/product/den_dfcb94183f00457497aeec219c7d7ab4.jpg', 0, 'active'),
(60, 'https://www.oppo.com/content/dam/oppo/common/mkt/v2-2/a79-5g-en/specs/a79-5g-860_720-bpg.jpg', 0, 'active'),
(60, 'https://file.hstatic.net/1000063620/file/oa792-271023-225532-800-resize_1024x1024.jpg', 0, 'active'),
(60, 'https://bachlongstore.vn/vnt_upload/product/11_2024/oppo_a79_tim_8_750x500.jpg', 0, 'active'),
-- Product 61: Vivo X100 Pro
(61, 'https://www.xtmobile.vn/vnt_upload/product/11_2023/vivo-x100-pro-12gb-256gb-xtmobile.jpg', 1, 'active'),
(61, 'https://netdeptinhte.vn/wp-content/uploads/2024/05/Vivo-X100-Pro-1-400x400.jpg', 0, 'active'),
(61, 'https://didongthongminh.vn/images/products/2024/08/22/large/2_1724316601.webp', 0, 'active'),
(61, 'https://sonpixel.vn/wp-content/uploads/2024/06/vivo-x100-pro-16.webp', 0, 'active'),
(61, 'https://bizweb.dktcdn.net/100/506/962/products/vivo-x100-pro-371d756f-d3cb-4f3d-98c3-08709ba5b372.jpg?v=1710173965630', 0, 'active'),
-- Product 62: Vivo V30 Pro
(62, 'https://cdn.tgdd.vn/Products/Images/42/320961/vivo-v30-pro-thumb-600x600.jpg', 1, 'active'),
(62, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/d/i/dien-thoai-vivo-v30-pro_1_.png', 0, 'active'),
(62, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/d/i/dien-thoai-vivo-v30-pro_2_.png', 0, 'active'),
(62, 'https://www.duchuymobile.com/images/news/67/vivo-v30-pro-gia-bao-nhieu.jpg', 0, 'active'),
(62, 'https://in-exstatic-vivofs.vivo.com/gdHFRinHEMrj3yPG/product/1726213254481/zip/img/mobi/kv-bg.png', 0, 'active'),
-- Product 63: Vivo Y28s
(63, 'https://cdn-media.sforum.vn/storage/app/media/trannghia/vivo-y28s-5g-ra-mat-2.jpg', 1, 'active'),
(63, 'https://cdn.kalvo.com/uploads/img/gallery/62731-vivo-y28s-1.jpg', 0, 'active'),
(63, 'https://cdn.mobilecity.vn/mobilecity-vn/images/2024/07/w300/vivo-y28s-5g-global-nau.jpg.webp', 0, 'active'),
(63, 'https://cdn.tgdd.vn/News/0/A%CC%89nhma%CC%80nhi%CC%80nh2024-06-27lu%CC%81c11.07.43-1280x720.jpeg', 0, 'active'),
(63, 'https://cdn.kalvo.com/uploads/img/gallery/62735-vivo-y28s-3.jpg', 0, 'active'),
-- Product 64: Realme GT 6
(64, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/r/e/realme-gt-5_4__1_1.png', 1, 'active'),
(64, 'https://dienthoaihay.vn/images/products/2024/07/09/original/1720487887138c89a5700bb9c44938ad_1720511078.png.png', 0, 'active'),
(64, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQy1I68VDULekfDQ8ow2SmczZCs3IlLXM59VA&s', 0, 'active'),
(64, 'https://bizweb.dktcdn.net/100/257/835/articles/202406180042152782.jpg?v=1723455781567', 0, 'active'),
(64, 'https://static2.realme.net/images/realme-gt-6t/design/1.png', 0, 'active'),
-- Product 65: Realme Narzo 70 Pro
(65, 'https://cdn.tgdd.vn/News/Thumb/1563278/Realme-Narzo-70-Pro-5G-ra-mat-voi-camera-1-inch-thiet-ke-nhu-flagship-1200x675.jpg', 1, 'active'),
(65, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtOBS3wFqrndOb0jbWoPZrjs0a8GkEqIHpEw&s', 0, 'active'),
(65, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKYE0r6YABSEswi1NzCbt_C_HER8g4YMi3Bg&s', 0, 'active'),
(65, 'https://www.duchuymobile.com/images/companies/1/1-tin-moi/2023/phi/thang-4/5/realme-narzo-70-pro-5g-2-mau.jpg', 0, 'active'),
(65, 'https://www.gizmochina.com/wp-content/uploads/2024/03/Realme-Narzo-70-Pro-5G-Featured.jpeg', 0, 'active'),
-- Product 66: Realme C65
(66, 'https://cdn.tgdd.vn/Products/Images/42/323002/realme-c65-thumb-1-600x600.jpg', 1, 'active'),
(66, 'https://www.didongmy.com/vnt_upload/product/08_2024/thumbs/(600x600)_realme_c65_purple_thumb_600x600.jpg', 0, 'active'),
(66, 'https://images-na.ssl-images-amazon.com/images/I/71nva4btzuL.jpg', 0, 'active'),
(66, 'https://img-prd-pim.poorvika.com/product/Realme-c65-5g-speedy-red-128gb-6gb-ram-Front-Back-View.png', 0, 'active'),
(66, 'https://cdn.tgdd.vn/Products/Images/42/323002/realme-c65-den-1-750x500.jpg', 0, 'active'),
-- Product 67: Nokia X30
(67, 'https://cdn.tgdd.vn/Files/2022/09/05/1465498/nokia_x30_5g-1_1280x720-800-resize.jpg', 1, 'active'),
(67, 'https://cdn.kalvo.com/uploads/img/gallery/nokia-x30-1.jpg', 0, 'active'),
(67, 'https://images-na.ssl-images-amazon.com/images/I/614u17tecvL.jpg', 0, 'active'),
(67, 'https://cdn2.fptshop.com.vn/unsafe/Uploads/images/tin-tuc/149260/Originals/Nokia-X30-5G-2.jpeg', 0, 'active'),
(67, 'https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/474273hNZ/nokia-x30-1.jpg', 0, 'active'),
-- Product 68: Nokia G42
(68, 'https://cdn.tgdd.vn/Products/Images/42/309833/nokia-g42-5g-600x600.jpg', 1, 'active'),
(68, 'https://cdn.kalvo.com/uploads/img/gallery/53021-nokia-g42-6.jpg', 0, 'active'),
(68, 'https://images.ctfassets.net/wcfotm6rrl7u/2A76sbRJjZNQH31EiAQJjc/94a6234187d7803fc9000526cb083227/nokia_G42-DTC-VIDEO-mobile.png', 0, 'active'),
(68, 'https://images.ctfassets.net/wcfotm6rrl7u/3BhWVje5jB1wHYpUs7Ty8L/15f4aec50ba0b30679c9ccee4874d809/nokia-G42_5G-so_pink-front_back-int.png?h=1000&fm=png&fl=png8', 0, 'active'),
(68, 'https://media.vov.vn/sites/default/files/styles/large/public/2023-10/2_0_34.jpg', 0, 'active'),
-- Product 69: Nokia C32
(69, 'https://cdn2.fptshop.com.vn/unsafe/2023_7_14_638249469495107256_nokia-c32-dd.jpg', 1, 'active'),
(69, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/n/o/nokia-c32_2_1_1.png', 0, 'active'),
(69, 'https://clickbuy.com.vn/uploads/pro/nokia-c32-4gb-128gb-chinh-hang-lg-193969.png', 0, 'active'),
(69, 'https://cdn.hoanghamobile.com/i/previewV2/Uploads/2023/06/28/nokiac32-charcoal-7.png', 0, 'active'),
(69, 'https://chamsocdidong.com/upload_images/images/2023/05/04/sua-loi-phan-mem-nokia-c32-1.jpg', 0, 'active'),
-- Product 70: Corsair K100 RGB
(70, 'https://product.hstatic.net/200000722513/product/phim_2ceafcd3b71942409b4724616258c73b_d44aa7fb2a70454d99b01bc9c1117f4f_030600be83d043258c9998e4edef6924_1024x1024.png', 1, 'active'),
(70, 'https://owlgaming.vn/wp-content/uploads/2024/10/Ban-phim-Gaming-Corsair-K100-Midnight-Gold-RGB-1.jpg', 0, 'active'),
(70, 'https://hanoicomputercdn.com/media/product/55864_ban_phim_corsair_k100_rgb_speed_switch_ch_912a014_na_0000_1.jpg', 0, 'active'),
(70, 'https://product.hstatic.net/200000637319/product/half-keyboard_0158752c6bee4d54a8d8ba0af34469f9_master.png', 0, 'active'),
(70, 'https://nguyencongpc.vn/media/product/17197-corsair-k100-rgb-cherry-mx-speed-black-6.JPG', 0, 'active'),
-- Product 71: Corsair Scimitar Elite
(71, 'https://product.hstatic.net/200000722513/product/chuot-game-corsair-scimitar-rgb-elite_8c3acc8779564469a84f45ec97f6f35d_941d55c2e4394ac29895a299a97b2805_1024x1024.png', 1, 'active'),
(71, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsNwLsTeVRUx_AgGgEK0m2k135huEtvh6gCg&s', 0, 'active'),
(71, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/410/941/products/2-e8cd04e1-a65e-4ca7-a755-263d1e56c7e3.jpg?v=1613786367570', 0, 'active'),
(71, 'https://product.hstatic.net/200000478869/product/-ch-9304211-ap-gallery-scimitar-elite-blk-22_e44920a5f0cc4635bf49a460d767b7f8.jpg', 0, 'active'),
(71, 'https://www.tnc.com.vn/uploads/product/gallery/Corsair-Scimitar-RGB-ELITE---PMW3391-5.png', 0, 'active'),
-- Product 72: Corsair HS80 RGB Wireless
(72, 'https://product.hstatic.net/200000722513/product/led_rgb_wireless_ca_9011235_ap_0001_2_436fee75cc8d499e9d7619b9efef8acd_8f3b7e1f606c49b8b209034703d29d54_1024x1024.jpg', 1, 'active'),
(72, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0pyBAFUDbvktfms0BtlocbzKITwf5ycPAGA&s', 0, 'active'),
(72, 'https://product.hstatic.net/200000722513/product/led_rgb_wireless_ca_9011235_ap_0000_1_e81eb3874c3e4bd683f2342d248de7e4_ce4c5d7db9414a90bcf227ff8df58a75.jpg', 0, 'active'),
(72, 'https://bizweb.dktcdn.net/100/329/122/files/hs80-image.jpg?v=1649754743801', 0, 'active'),
(72, 'https://bienhoagear.com/wp-content/uploads/2024/03/corsair-hs80-1.jpg', 0, 'active'),
-- Product 73: SteelSeries Apex Pro TKL
(73, 'https://nguyencongpc.vn/media/product/17186-b--n-ph--m-c---steelseries-apex-pro-tkl-3.jpg', 1, 'active'),
(73, 'https://azaudio.vn/wp-content/uploads/2024/10/steelseries-apex-pro-tkl-wireless-gen3-2024-3.jpg', 0, 'active'),
(73, 'https://songphuong.vn/Content/uploads/2021/07/Ban_phim_co_steelseries_apex_pro_tkl_4_songphuong.vn_.jpg', 0, 'active'),
(73, 'https://nguyencongpc.vn/media/product/17186-b--n-ph--m-c---steelseries-apex-pro-tkl-2.jpg', 0, 'active'),
(73, 'https://bizweb.dktcdn.net/thumb/grande/100/410/941/products/annotation-2023-06-05-155015-c1686fe6-95d6-44d9-9d43-2975cb10e1af.jpg?v=1685955330817', 0, 'active'),
-- Product 74: SteelSeries Aerox 5 Wireless
(74, 'https://file.hstatic.net/1000026716/file/gearvn-chuot-steelseries-aerox-5-wireless-1_15b7fafa0f42499394e87b7b75a7ac58_grande.png', 1, 'active'),
(74, 'https://product.hstatic.net/200000722513/product/_q100_crop-fit_optimize_subsampling-2_36b24c7c9351454b988c38bf55e36b1b_8b41cbe6c65541ec84f85186542b9c3e_1024x1024.png', 0, 'active'),
(74, 'https://hanoicomputercdn.com/media/product/69600_chuot_gaming_khong_day_steelseries_aerox_5_wireless_62406_6.jpg', 0, 'active'),
(74, 'https://hanoicomputercdn.com/media/product/69600_chuot_gaming_khong_day_steelseries_aerox_5_wireless_62406_2.jpg', 0, 'active'),
(74, 'https://tanthanhdanh.vn/wp-content/uploads/2024/02/Aerox-5-Wireless-PRODUCT-2.png', 0, 'active'),
-- Product 75: SteelSeries Arctis Nova Pro
(75, 'https://product.hstatic.net/200000722513/product/800_crop-scale_optimize_subsampling-2_85403d08f58e43de8be56cbc40688980_92aaa444113d491c92b3096a44a385f9_1024x1024.png', 1, 'active'),
(75, 'https://www.ubuy.vn/productimg/?image=aHR0cHM6Ly9tLm1lZGlhLWFtYXpvbi5jb20vaW1hZ2VzL0kvNjE0SVF5dHFBdUwuX0FDX1NMMTUwMF8uanBn.jpg', 0, 'active'),
(75, 'https://hanoicomputercdn.com/media/product/86050_tai_nghe_steelseries_arctis_nova_pro_wireless_infinity_power_system_white_61524_01.jpg', 0, 'active'),
(75, 'https://tanphat.com.vn/media/product/5244_49398_steelseries_arctis_nova_pro_wireless_61520_a1_.jpg', 0, 'active'),
(75, 'https://gameone.ph/media/catalog/product/cache/d378a0f20f83637cdb1392af8dc032a2/s/t/steelseries-nova-pro-wireless.jpg', 0, 'active'),
-- Product 76: Corsair Virtuoso RGB Wireless
(76, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2021_11_9_637720718333788887_tai-nghe-khong-day-corsair-virtuoso-rgb-den-1.jpg', 1, 'active'),
(76, 'https://product.hstatic.net/1000129940/product/corsair-virtuoso-rgb-wireless-white_9cbcc325b43340a9b22e34a1064955d1_master.jpg', 0, 'active'),
(76, 'https://product.hstatic.net/1000129940/product/tai_nghe_corsair_virtuoso_rgb_wireless_se_-_espresso_19a8cf7a3dad455d8930085b7d3fa0cb.png', 0, 'active'),
(76, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rbk7-lnxrx9727nvsf0', 0, 'active'),
(76, 'https://www.tnc.com.vn/uploads/product/gallery/Tai-nghe-khong-day-Corsair-Virtuoso-RGB-Carbon-3.png', 0, 'active'),
-- Product 77: Corsair K70 RGB TKL
(77, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/ban-phim-co-corsair-k70-rgb-champion-series.png?v=1698911457230', 1, 'active'),
(77, 'https://product.hstatic.net/200000478869/product/81hzi6dwrel._ac_sl1500__3af9d49456ef4dd68994575b0dd7a278.jpg', 0, 'active'),
(77, 'https://product.hstatic.net/200000637319/product/-base-k70-rgb-tkl-gallery-ch-911__16__4ee866623ae9453cb86f66b42738ce49_master.png', 0, 'active'),
(77, 'https://gearshop.vn/upload/images/Product/Corsair/B%C3%A0n%20Ph%C3%ADm/K70%20TKL%20MX%20Speed/ban-phim-corsair-tkl-k70-rgb-mx-speed-(6).png', 0, 'active'),
(77, 'https://tanphat.com.vn/media/product/3810_43375_key_cor_ch_9119010_na_a.jpg', 0, 'active'),
-- Product 78: Corsair Dark Core RGB Pro
(78, 'https://product.hstatic.net/200000722513/product/-core-rgb-pro-wireless-gaming-mouse-1_b647046fefda46f7a86b1151dd4f138c_d2a85a2e839a4e60b6d790d65862053b.png', 1, 'active'),
(78, 'https://hanoicomputercdn.com/media/product/53100_chuot_corsair_dark_core_rgb_pro_0001_2.jpg', 0, 'active'),
(78, 'https://product.hstatic.net/1000333506/product/chuot-corsair-dark-core-rgb-pro-se-4_f1a3cbf9237d44e2a8339725cf4d211f_cd71a79229b94a4dbe5d0ebab6dc3e19.png', 0, 'active'),
(78, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIF6cGHrPu1lexXCZqH0s8D4xx162yMRd87w&s', 0, 'active'),
(78, 'https://www.tncstore.vn/media/product/9490-tnc-store-chuot-corsair-20.jpg', 0, 'active'),
-- Product 79: SteelSeries Arctis 7+
(79, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2024_2_28_638447295329987245_tai-nghe-bluetooth-choang-dau-steelseries-arctis-nova-7-1.jpg', 1, 'active'),
(79, 'https://hanoicomputercdn.com/media/product/79118_tai_nghe_gaming_khong_day_steelseries_arctis_7_white_1.jpg', 0, 'active'),
(79, 'https://owlgaming.vn/wp-content/uploads/2024/06/ARCTIS-7-1.jpg', 0, 'active'),
(79, 'https://product.hstatic.net/200000637319/product/2_4420e12bfc694739a1910713ffc6c565_master.png', 0, 'active'),
(79, 'https://azaudio.vn/wp-content/uploads/2024/05/steelseries-arctis-7-nova-faze-clan-edition-1.jpg', 0, 'active'),
-- Product 80: SteelSeries Apex 7
(80, 'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/ban_phim_co_gaming_co_day_apex_7_tkl_red_switch_steelseries_3_5f971f0236.jpg', 1, 'active'),
(80, 'https://product.hstatic.net/200000722513/product/7eae419aaa4a4a8e83ad04772215a4_grande_d2ee9ab18f1946c7ba271940f135dde0_4e816ff9bb79469891316b713db6578d.png', 0, 'active'),
(80, 'https://bizweb.dktcdn.net/100/433/921/products/10347-steelseries-apex-7-tkl-us-red-switch-1.jpg?v=1714102577630', 0, 'active'),
(80, 'https://tanphat.com.vn/media/product/4357_36893_apex_7_tkl_ha2.jpeg', 0, 'active'),
(80, 'https://minhancomputercdn.com/media/product/10302_steelseries_apex_7_tkl_us_red_switch_8.jpg', 0, 'active'),
-- Product 81: SteelSeries Rival 5
(81, 'https://owlgaming.vn/wp-content/uploads/2024/06/chuot-steelseries-rival-5-3.jpg', 1, 'active'),
(81, 'https://product.hstatic.net/200000637319/product/imgbuy_rival5_002.png__1920x1080_q100_crop-fit_optimize_subsampling-2_fffef4b9eee64d279969211fca97c353_master.jpg', 0, 'active'),
(81, 'https://product.hstatic.net/200000320233/product/imgbuy_rival5_004.png__1920x1080_q100_crop-fit_optimize_subsampling-2_b05924a86ac64b0bbc91b7c74f93cf0e.png', 0, 'active'),
(81, 'https://bienhoagear.com/wp-content/uploads/2024/06/chuot-steelseries-rival-5-1_7ca8e3197adf4a679ce4751e3e762e48_master.jpg', 0, 'active'),
(81, 'https://m.media-amazon.com/images/I/61QdKZP26rS._AC_UF894,1000_QL80_.jpg', 0, 'active'),
-- Product 82: MSI Vigor GK71 Sonic
(82, 'https://asset.msi.com/resize/image/global/product/product_16415411303a4f3ad1ddc39e1b18dd3904a62e4767.png62405b38c58fe0f07fcef2367d8a9ba1/600.png', 1, 'active'),
(82, 'https://asset.msi.com/resize/image/global/product/product_16415411345fd4741cb1cb02d1e48d0dd14a503160.png62405b38c58fe0f07fcef2367d8a9ba1/600.png', 0, 'active'),
(82, 'https://asset.msi.com/resize/image/global/product/product_1641541132255eaef826d8a8be32af3f490500df74.png62405b38c58fe0f07fcef2367d8a9ba1/600.png', 0, 'active'),
(82, 'https://m.media-amazon.com/images/I/81KTNadJ8QL._AC_UF894,1000_QL80_.jpg', 0, 'active'),
(82, 'https://hanoicomputercdn.com/media/lib/04-06-2022/ban-phim-game-msi-vigor-gk71-sonic-den-usb-rgb-sonic-sw-06.jpg', 0, 'active'),
-- Product 83: MSI Clutch GM41 Lightweight
(83, 'https://storage-asset.msi.com/global/picture/image/feature/mouse/GM41/images/kv_mouse.png', 1, 'active'),
(83, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/_/0/_0000_1024_1.jpg', 0, 'active'),
(83, 'https://storage-asset.msi.com/global/picture/image/feature/multimeda/mouse/GM41/GM41-feature.png', 0, 'active'),
(83, 'https://hanoicomputercdn.com/media/product/65968_chuot_game_msi_clutch_gm41_lightweight_v2_den_usb_rgb_0000_1.jpg', 0, 'active'),
(83, 'https://cdn.tgdd.vn/Products/Images/86/313220/chuot-co-day-gaming-msi-clutch-gm41-lightweight-v2-2-750x500.jpg', 0, 'active'),
-- Product 84: Gigabyte AORUS K9 Optical
(84, 'https://www.gigabyte.com/FileUpload/Global/KeyFeature/845/images/gallery/p001.jpg', 1, 'active'),
(84, 'https://manhhungcomputer.com/media/product/786_b__n_ph__m_c___gigabyte_aorus_k9_rgb___cao_c___p.jpg', 0, 'active'),
(84, 'https://www.relaxedtech.com/reviews/gigabyte/aorus-k9-optical-mechanical-gaming-keyboard/gigabyte-aorus-k9.jpg', 0, 'active'),
(84, 'https://aphnetworks.com/review/gigabyte-aorus-k9-optical/004.jpg', 0, 'active'),
(84, 'https://nl.hardware.info/images/products_500x300/416274/gigabyte-aorus-k9-optical.jpg', 0, 'active'),
-- Product 85: Gigabyte AORUS M5
(85, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbtPjPHYQbr2ZOQOxuYihY92SSh_0Kued3eQ&s', 1, 'active'),
(85, 'https://songphuong.vn/Content/uploads/2020/05/1_Aorus_M5_songphuong.vn_.jpg', 0, 'active'),
(85, 'https://product.hstatic.net/1000129940/product/aorus_m5-1_large.jpg', 0, 'active'),
(85, 'https://www.gigabyte.com/FileUpload/Global/KeyFeature/960/img/mouse/04.png', 0, 'active'),
(85, 'https://product.hstatic.net/200000722513/product/-chuot-gaming-gigabyte-aorus-m5-rgb-1_e82686f3a8b64fe792328398bd18d362_2459efae16d4487e8866ab78d7880bed.png', 0, 'active'),
-- Product 86: Xiaomi Buds 5
(86, 'https://i02.appmifile.com/mi-com-product/fly-birds/xiaomi-buds-5/m/76caeb0cd8ff39e3df393e65a6a93535.jpg', 1, 'active'),
(86, 'https://i02.appmifile.com/900_operator_sg/11/09/2024/32c0343069cfae4ad8e9af1216eba34e.png', 0, 'active'),
(86, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/t/a/tai-nghe-khong-day-xiaomi-redmi-buds-5-6.png', 0, 'active'),
(86, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5qkRpMuJTpLm0DuPPeAIsWSaJI2tFVfGWzg&s', 0, 'active'),
(86, 'https://cdn2.fptshop.com.vn/unsafe/tai_nghe_bluetooth_xiaomi_redmi_buds_5_trang_4_bdc8010b65.jpg', 0, 'active'),
-- Product 87: Redmi Buds 6 Active
(87, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/t/a/tai-nghe-bluetooth-xiaomi-redmi-buds-6-active.png', 1, 'active'),
(87, 'https://i02.appmifile.com/mi-com-product/fly-birds/redmi-buds-6-active/m/hongmilanyaerjibgm.png', 0, 'active'),
(87, 'https://product.hstatic.net/1000382236/product/6_active_den_60d70d3e50f34a2da50925464026d4a7_grande.jpg', 0, 'active'),
(87, 'https://i02.appmifile.com/863_item_vn/09/04/2025/c2a2c2a5cf823fecb78af8ecc738f4ac!400x400!85.png', 0, 'active'),
(87, 'https://mihome.vn/wp-content/uploads/2024/08/Untitled-1-4.jpg', 0, 'active'),
-- Product 88: OPPO Enco X3
(88, 'https://cdn-media.sforum.vn/storage/app/media/trannghia/Oppo-Enco-X3-ra-mat-2.jpg', 1, 'active'),
(88, 'https://www.giztop.com/media/catalog/product/cache/97cc1143d2e20f2b0c8ea91aaa12053c/o/p/oppo_enco_x3.png', 0, 'active'),
(88, 'https://nghenhinvietnam.vn/uploads/global/quanghuy/2024/10/21/oppo/nghenhin_oppo_enco_x3_4.png', 0, 'active'),
(88, 'https://i.gadgets360cdn.com/large/oppo_enco_x3_oppo_1729511427228.jpg?downsize=400:*', 0, 'active'),
(88, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_bGRKlWQpEoTVXKj9Z5j6qunLvJiDOB20LQ&s', 0, 'active'),
-- Product 89: OPPO Enco Air 4
(89, 'https://image.oppo.com/content/dam/oppo/common/mkt/v2-2/oppo-enco-air4-pro-en/specs/Specs_1574_720_Two-color.png', 1, 'active'),
(89, 'https://product.hstatic.net/200000845283/product/trang_-_01_05732fa4c2a84d91872177e973dd67ec.jpg', 0, 'active'),
(89, 'https://product.hstatic.net/200000845283/product/1_2783e345f18a4f6abef7bcc653f92554.jpg', 0, 'active'),
(89, 'https://images2.thanhnien.vn/528068263637045248/2024/7/18/tainghe-1721274901933203198663.png', 0, 'active'),
(89, 'https://product.hstatic.net/200000845283/product/den_-_01_486f320219b84022bd12d3e52a676414_medium.jpg', 0, 'active'),
-- Product 90: Vivo TWS 4
(90, 'https://down-vn.img.susercontent.com/file/cn-11134207-7ras8-m2svswyici5j78', 1, 'active'),
(90, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rccz-ltdb2rejp58sa1', 0, 'active'),
(90, 'https://nghenhinvietnam.vn/uploads/global/tunglampv/2024/t03/27/vivo/vivo_tws_4_001.jpg', 0, 'active'),
(90, 'https://images.fonearena.com/blog/wp-content/uploads/2024/03/vivo-TWS-4-Hi-Fi.jpg', 0, 'active'),
(90, 'https://www.oksouq.com/web/image/product.template/10634/image_1024?unique=c61a0fa', 0, 'active'),
-- Product 91: Vivo TWS Air 2
(91, 'https://cellphones.com.vn/sforum/wp-content/uploads/2023/10/vivo-tws-air-2-2.jpeg', 1, 'active'),
(91, 'https://vstatic.vietnam.vn/vietnam/resource/IMAGE/2025/1/19/e838162475f54ced8a4a2acae6c4d8e2', 0, 'active'),
(91, 'https://ae01.alicdn.com/kf/S7160b152e48c40ce99a6663cfb44e5350.jpg', 0, 'active'),
(91, 'https://imgaz3.staticbg.com/thumb/large/oaupload/banggood/images/5A/10/1af2bf8e-bfaf-4641-9bb8-12b6885e6665.jpg.webp', 0, 'active'),
(91, 'https://nghenhinvietnam.vn/uploads/global/tunglampv/2023/t10/21/vivo/vivo_tws_air_2_a1.jpg', 0, 'active'),
-- Product 92: Realme Buds Air 6 Pro
(92, 'https://down-vn.img.susercontent.com/file/sg-11134201-7rd6w-lv325z0e6pas45', 1, 'active'),
(92, 'https://img.lazcdn.com/g/p/6930ff79363d6bffbd387a3a4190019e.png_720x720q80.png', 0, 'active'),
(92, 'https://cellphones.com.vn/sforum/wp-content/uploads/2024/05/Realme-Buds-Air-6-Pro-1024x579-1.jpg', 0, 'active'),
(92, 'https://adminapi.applegadgetsbd.com/storage/media/large/realme-Buds-Air-6-Pro-ANC-TWS-Earbuds-Black-1243.jpg', 0, 'active'),
(92, 'https://vn-test-11.slatic.net/p/7d64ee108155c0d99aa911c12304ef81.png', 0, 'active'),
-- Product 93: Realme Buds T300
(93, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/t/a/tai-nghe-khong-day-realme-buds-t300_4_.png', 1, 'active'),
(93, 'https://laz-img-sg.alicdn.com/p/67625a43f25f73997f4066707dc77428.jpg', 0, 'active'),
(93, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/t/a/tai-nghe-khong-day-realme-buds-t300_2_.png', 0, 'active'),
(93, 'https://www.smcyberzone.com/_ipx/f_webp/https://www.smcyberzone.com/app/uploads/2024/03/CYBERZONE-WEBSITE-UPLOAD-1080-%C3%97-1080-px-2024-03-27T093112.149.png', 0, 'active'),
(93, 'https://cdn.phonebunch.com/news-images/2023/09/Realme-Buds-T300-colors-India.webp', 0, 'active'),
-- Product 94: Nokia Clarity Earbuds 2 Pro
(94, 'https://images.ctfassets.net/wcfotm6rrl7u/2Z3VgGVzRvyp79rtRQ2VOX/f1f855d234ba7531d9862d9f52b66237/nokia-TWS-852W-black-angled.png?h=1000&fm=png&fl=png8', 1, 'active'),
(94, 'https://i.ebayimg.com/images/g/0sEAAOSwTXpmulZo/s-l1200.jpg', 0, 'active'),
(94, 'https://pcchip.hr/wp-content/uploads/2022/09/Nokia-Clarity-Earbuds-2-Pro-scaled.webp', 0, 'active'),
(94, 'https://gagadget.com/media/post_big/Nokia_Clarity_Earbuds_2_Pro.jpg', 0, 'active'),
(94, 'https://media.vov.vn/sites/default/files/styles/large/public/2021-07/2_314.jpg', 0, 'active'),
-- Product 95: Nokia Go Earbuds+
(95, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQXAiBYVepZP2H0uEnAhzU04JdKsZ78_N5VA&s', 1, 'active'),
(95, 'https://m.media-amazon.com/images/I/510Ks6DUyqL.jpg', 0, 'active'),
(95, 'https://wibutech.com/wp-content/uploads/2022/10/DSC4488.png', 0, 'active'),
(95, 'https://cdn.24h.com.vn/upload/3-2021/images/2021-07-27/4-1627399622-632-width660height371.jpg', 0, 'active'),
(95, 'https://manuals.plus/wp-content/uploads/2022/10/NOKIA-TWS-201-Go-Earbuds-Wireless-Earbuds-Featured-Image.jpg', 0, 'active');
SELECT * FROM Product WHERE name LIKE '%mac%';

