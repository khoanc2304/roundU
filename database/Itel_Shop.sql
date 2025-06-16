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
IF OBJECT_ID('ProductImages') IS NOT NULL DROP TABLE ProductImages;
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
	image_url  NVARCHAR(255) NULL,
    CONSTRAINT FK_Users_MembershipLevel FOREIGN KEY (membership_level_id) REFERENCES MembershipLevel(level_id)
);

CREATE TABLE Category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX) NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
	image_url NVARCHAR(255) NULL
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
    image_url NVARCHAR(1024) NULL,
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
    image_url VARCHAR(1023) NOT NULL,          -- Đường dẫn tới hình ảnh
    is_primary BIT DEFAULT 0,                 -- Đánh dấu hình ảnh chính (0 = false, 1 = true)
    status NVARCHAR(20) CHECK (status IN ('active', 'inactive')) DEFAULT 'active',  
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
INSERT INTO Users (username, password, fullName, email, phone, address, role, membership_level_id, image_url)
VALUES
('khoa', 'khoa', 'Nguyen Khoa', 'khoa@gmail.com', '0123456789', '123 Đường A, TP.HCM', 'admin', 4, 'https://i.pinimg.com/736x/03/eb/d6/03ebd625cc0b9d636256ecc44c0ea324.jpg'),
('nam', 'nam', 'Nguyen Nam', 'nam@gmail.com', '0987654321', '456 Đường B, Hà Nội', 'admin', 4, 'https://i.pinimg.com/736x/16/a9/57/16a9570117787327d84c592bb7dd01c6.jpg'),
('vinh', 'vinh', 'Nguyen Vinh', 'vinh@gmail.com', '0912345678', '789 Đường C, Đà Nẵng', 'admin', 4, 'https://i.pinimg.com/736x/1c/4b/12/1c4b12f45f56d1d37934dde85af2f4d4.jpg'),
('hieu', 'hieu', 'Ngo Hieu', 'hieu@gmail.com', '0909876543', '12 Đường D, Hải Phòng', 'admin', 4, 'https://i.pinimg.com/736x/bf/50/e2/bf50e22082af5810b2976308c721ee5b.jpg'),
('huy', 'huy', 'Huynh Huy', 'huy@gmail.com', '0999888777', '345 Đường E, Cần Thơ', 'admin', 4, 'https://i.pinimg.com/736x/6f/d4/ee/6fd4ee9b13076f991aab35529bc71644.jpg'),
('admin', 'admin', 'Vu Van F', 'admin@gmail.com', '0966778899', '678 Đường F, Huế', 'admin', 4, 'https://i.pinimg.com/736x/5c/3b/62/5c3b6262a1850c17d2b4350ee22de1fc.jpg'),
('user1', 'user1', 'Dang Thi G', 'user1@gmail.com', '0933445566', '901 Đường G, Vinh', 'customer', null, 'https://i.pinimg.com/736x/d5/c9/d7/d5c9d700340d8eb6122485602e42b578.jpg'),
('user2', 'user2', 'Bui Van H', 'user2@gmail.com', '0977555333', '234 Đường H, Nha Trang', 'customer', 2, 'https://i.pinimg.com/736x/82/26/96/822696099c99ecca6054821746001a8b.jpg'),
('user3', 'user3', 'Nguyen Thi I', 'user3@gmail.com', '0988123456', '567 Đường I, Phan Thiết', 'customer', 3, 'https://i.pinimg.com/736x/bb/6a/fd/bb6afdb250780ae260d010278381e31b.jpg'),
('user4', 'user4', 'Tran Van J', 'user4@gmail.com', '0911222333', '890 Đường J, Quy Nhơn', 'customer', 4, 'https://i.pinimg.com/736x/f1/52/b6/f152b6a30a837fe8f3c0211cd1f6da25.jpg'),
('user5', 'user5', 'Le Thi K', 'user5@gmail.com', '0933555777', '123 Đường K, Buôn Ma Thuột', 'customer', 3, 'https://i.pinimg.com/736x/3f/01/86/3f01867f8c79b33506f19d2a58d7c446.jpg'),
('user6', 'user6', 'Pham Van L', 'user6@gmail.com', '0922333444', '456 Đường L, Vũng Tàu', 'customer', 2, 'https://i.pinimg.com/736x/d1/9d/f6/d19df63ed0a685cb54f2a0b368af201b.jpg'),
('user7', 'user7', 'Hoang Thi M', 'user7@gmail.com', '0977666555', '789 Đường M, Pleiku', 'customer', 1, 'https://i.pinimg.com/736x/6b/5a/a1/6b5aa17b15866cc9d758310d659adf94.jpg'),
('user8', 'user8', 'Vu Van N', 'user8@gmail.com', '0966443322', '123 Đường N, Cao Lãnh', 'customer', null, 'https://i.pinimg.com/736x/28/bb/13/28bb13d3081336fa6ac50dd208d0fb9f.jpg'),
('user9', 'user9', 'Dang Thi O', 'user9@gmail.com', '0955777999', '456 Đường O, Tây Ninh', 'customer', null, 'https://i.pinimg.com/736x/17/a8/03/17a8037acfc725075a8f0899b960c717.jpg');

--Category
INSERT INTO Category (name, description, image_url)
VALUES
('Laptop', 'Portable computers with balanced performance and mobility', 'https://i.pinimg.com/736x/6a/e2/b3/6ae2b3c8bd720ed3d21b80c7a3c86074.jpg'), --id 1
('Phone', 'Smart mobile devices used for communication, apps, and media', 'https://i.pinimg.com/736x/49/b1/ff/49b1ff3581fe6704f34f303dccb1fd5b.jpg'), --id 2
('Mouse', 'Input device used to control the pointer and navigate interfaces', 'https://i.pinimg.com/736x/ff/c2/2f/ffc22f227c1777507ec46bc0bc2aa9e5.jpg'), --id 3
('Headphones', 'Audio device worn over ears for personal listening', 'https://i.pinimg.com/736x/fa/9f/44/fa9f4483c304fe087d7ad7cf2a3e4c7d.jpg'), --id 4
('Keyboard', 'Input device consisting of keys used to type text or commands', 'https://i.pinimg.com/736x/b1/d6/2f/b1d62f8bc01c91b50bef41f45b08d785.jpg'); --id 5

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
('Samsung', 'South Korea', 'Galaxy series & Headphones', 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Samsung_Logo.svg/1024px-Samsung_Logo.svg.png'), --id:9
('Xiaomi', 'China', 'Redmi, Mi, Poco', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Xiaomi_logo_%282021-%29.svg/1200px-Xiaomi_logo_%282021-%29.svg.png'), --id:10
('OPPO', 'China', 'Reno, A series', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/OPPO_LOGO_2019.svg/1280px-OPPO_LOGO_2019.svg.png'), --id:11
('Vivo', 'China', 'X series, Y series', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Vivo_logo_2019.svg/1200px-Vivo_logo_2019.svg.png'), --id:12
('Realme', 'China', 'Narzo, GT series', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Realme_logo_SVG.svg/1200px-Realme_logo_SVG.svg.png'), --id:13
('Nokia', 'Finland', 'Android One phones', 'https://1024logos.net/wp-content/uploads/2017/03/Nokia-Logo.jpg'), --id:14

-- Accessories
('Logitech', 'Switzerland', 'Famous for mice, keyboards, and headphones for both office and gaming.', 'https://upload.wikimedia.org/wikipedia/commons/1/17/Logitech_logo.svg'), --id:15
('Razer', 'USA/Singapore', 'Specializes in RGB gaming gear: keyboards, mice, headphones.', 'https://upload.wikimedia.org/wikipedia/vi/a/a1/Razer_snake_logo.png'), --id:16
('Corsair', 'USA', 'Gaming peripherals manufacturer: keyboards, mice, headsets.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSK7HxPKivG9Zq16GNTcdKQDVg60OYQnP3QYw&s'), --id:17
('SteelSeries', 'Denmark', 'eSports-focused brand with gaming mice, keyboards, and headphones.', 'https://upload.wikimedia.org/wikipedia/en/7/7f/Steelseries-logo.png'), --id:18
('HyperX', 'USA', 'Best known for gaming headsets, also offers mice and keyboards.', 'https://1024logos.net/wp-content/uploads/2021/04/HyperX-logo.jpg'); --id:19



--Attribute
INSERT INTO Attribute (category_id, name, data_type, unit)
VALUES
-- laptop (cate 1)
(1, 'CPU', 'text', NULL), -- id 1
(1, 'RAM', 'number', 'GB'), -- id 2
(1, 'Storage', 'number', 'GB'), -- id 3
(1, 'GPU', 'text', NULL), -- id 4
(1, 'Màn hình', 'text', NULL), -- id 5
(1, 'Hệ điều hành', 'text', NULL), --id 6
(1, 'Cổng kết nối', 'text', NULL), -- id 7
(1, 'Bàn phím', 'text', NULL), -- id 8
(1, 'Webcam', 'text', NULL), -- id 9
(1, 'Wi-Fi', 'text', NULL), -- id 10
(1, 'Bluetooth', 'text', NULL), -- id 11
(1, 'Pin', 'number', 'Wh'), -- id 12
(1, 'Trọng lượng', 'number', 'kg'), -- id 13
(1, 'Kích thước', 'text', NULL), -- id 14

--phone (cate 2)
(2, 'Màn hình', 'text', NULL), -- id 15
(2, 'Độ phân giải màn hình', 'text', NULL), -- id 16
(2, 'Camera', 'text', NULL), -- id 17
(2, 'Chip xử lý', 'text', NULL), -- id 18
(1, 'Hệ điều hành', 'text', NULL), --id19
(2, 'RAM', 'number', 'GB'), -- id 20
(2, 'Bộ nhớ trong', 'number', 'GB'), -- id 21
(2, 'Kết nối', 'text', NULL), -- id 22
(2, 'Dung lượng pin', 'number', 'mAh'), -- id 23
(2, 'Sạc', 'text', NULL), -- id 24
(2, 'Màu sắc', 'text', NULL), --id 25
(2, 'Trọng lượng', 'number', 'g'), -- id 26
(2, 'Tốc độ xử lý', 'number', 'GHz'), -- id 27

--chuột (cate 3)
(3, 'DPI', 'number', NULL), --id 28
(3, 'Connection Type', 'text', NULL),   --id 29       -- Wired / Wireless / Bluetooth
(3, 'Buttons', 'number', NULL), --id 30
(3, 'Sensor Type', 'text', NULL),   --id 31          -- Optical / Laser
(3, 'Polling Rate', 'number', 'Hz'), --id 32
(3, 'Battery Life', 'text', NULL), --id 33           -- e.g., "70 hours"
(3, 'Weight', 'number', 'g'), --id 34

-- tai nghe (cate 4)
(4, 'Driver Size', 'number', 'mm'), --id 35
(4, 'Connection Type', 'text', NULL), --id 36        -- 3.5mm / Bluetooth / USB-C
(4, 'Microphone', 'boolean', NULL), --id 37
(4, 'Noise Cancelling', 'boolean', NULL), --id 38
(4, 'Battery Life', 'text', NULL), --id 39            -- e.g., "20 hours"
(4, 'Frequency Response', 'text', 'Hz'), --id 40      -- e.g., "20Hz - 20kHz"
(4, 'Weight', 'number', 'g'), --id 41

-- bàn phím (cate 5)
(5, 'Key Layout', 'text', NULL), --id 42             -- ANSI, ISO, TKL, 60%, 75%...
(5, 'Switch Type', 'text', NULL), --id 43             -- Mechanical, Membrane, Optical
(5, 'Connection Type', 'text', NULL), --id 44        -- Wired / Wireless / Bluetooth
(5, 'Backlight', 'text', NULL), --id 45              -- RGB / Single color / None
(5, 'Battery Life', 'text', NULL),  --id 46          -- Nếu dùng pin
(5, 'Weight', 'number', 'g'), --id 47
(5, 'Dimensions', 'text', 'cm'); --id 48

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
('HP 250 G6 i3 6006U', 'Affordable Notebook with Intel i3', 8984663, 70, 1, 3, 'https://product.hstatic.net/1024296652/product/kk_1a586f1bece145bd8a4cbfc80f4c63f2_7a0b155ca637451e81f6e55005c1f568.jpg'),
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
('MSI Prestige 14 Evo', 'Business laptop with Intel Core Ultra 7', 31251024, 30, 1, 7, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/msi_prestige_14_ai_studio_c1u_1_5ab50baa17.png'),
('MSI Creator Z17', 'Creator laptop with RTX 3080 Ti, 4K display', 65106250, 15, 1, 7, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/msi_creator_16_ai_studio_a1v_1_7eece4ea8a.png'),
-- Gigabyte (brand_id=8, Laptop, category_id=1)
('Gigabyte AORUS 17', 'Gaming laptop with RTX 4080, 240Hz display', 52085000, 20, 1, 8, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2022_9_26_637998081269981032_gigabyte-gaming-aorus-17-xe5-73vn534gh-i7-12700h-rtx3070ti-den-1.jpg'),
('Gigabyte AERO 15 OLED', 'Creator laptop with 4K AMOLED, RTX 3070', 46876500, 25, 1, 8, 'https://product.hstatic.net/200000837185/product/laptopgigabyteaero15oledkd-72s1623go_a4a4b601ef9c4bddb1bdfd1d12825bef.png'),
('Gigabyte G5', 'Budget gaming laptop with RTX 4050', 26042500, 35, 1, 8, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2023_5_5_638188828261835779_gigabyte-gaming-g5-kf-e3vn313sh-i5-12500h-den-3.jpg'),
-- Samsung (brand_id=9, Phone, category_id=2)
('Samsung Galaxy S24 Ultra', 'Flagship phone with Snapdragon 8 Gen 3', 31251024, 40, 2, 9, 'https://cdn2.fptshop.com.vn/unsafe/750x0/filters:format(webp):quality(75)/2024_1_15_638409395342231798_samsung-galaxy-s24-ultra-xam-1.png'),
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
('SteelSeries Aerox 5 Wireless', 'Lightweight gaming mouse with 9 buttons', 2604250, 55, 3, 18, 'https://file.hstatic.net/1024026716/file/gearvn-chuot-steelseries-aerox-5-wireless-1_15b7fafa0f42499394e87b7b75a7ac58_grande.png'),
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
('Nokia Clarity Earbuds 2 Pro', 'Wireless earbuds with ANC', 1822975, 75, 4, 14, 'https://images.ctfassets.net/wcfotm6rrl7u/2Z3VgGVzRvyp79rtRQ2VOX/f1f855d234ba7531d9862d9f52b66237/nokia-TWS-852W-black-angled.png?h=1024&fm=png&fl=png8'),
('Nokia Go Earbuds+', 'Budget wireless earbuds with 20-hour battery', 781275, 110, 4, 14, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQXAiBYVepZP2H0uEnAhzU04JdKsZ78_N5VA&s'),
-- Apple MacBook (3 sản phẩm, category_id=1, brand_id=1)
('MacBook Air 13-inch M4 2025', 'Ultra-thin laptop with M4 chip, 13.6-inch Liquid Retina display, 16GB RAM, 256GB SSD, up to 18 hours battery life.', 26048925, 100, 1, 1, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/t/e/text_ng_n_2__9_14.png'),
('MacBook Pro 14-inch M4 Pro 2024', 'Powerful laptop with M4 Pro chip, 14.2-inch Liquid Retina XDR, 24GB RAM, 512GB SSD, ideal for professionals.', 41693925, 80, 1, 1, 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/mbp14-spaceblack-select-202410?wid=892&hei=820&fmt=jpeg&qlt=90&.v=YnlWZDdpMFo0bUpJZnBpZjhKM2M3VGhTSEZFNjlmT2xUUDNBTjljV1BxWjZkZE52THZKR1lubXJyYmRyWWlhOXZvdUZlR0V0VUdJSjBWaDVNVG95Yk15Y0c3T3Y4UWZwZExHUFdTUC9lN28'),
('MacBook Air 15-inch M4 2025', 'Larger 15.3-inch Liquid Retina display, M4 chip, 16GB RAM, 512GB SSD, lightweight design.', 31263925, 120, 1, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTr_pzU6s_NX7DXKnZrLEXancCOK24Zw3j6Vg&s'),
-- Apple iPhone (12 sản phẩm, category_id=2, brand_id=1)
('iPhone 16', '6.1-inch Super Retina XDR, A18 chip, 48MP dual-camera, iOS 18, 128GB storage.', 20833925, 150, 2, 1, 'https://cdn.tgdd.vn/Products/Images/42/329143/iphone-16-pro-titan-trang.png'),
('iPhone 16 Plus', '6.7-inch Super Retina XDR, A18 chip, 48MP dual-camera, iOS 18, 128GB storage.', 23441425, 140, 2, 1, 'https://cdn.tgdd.vn/Products/Images/42/329138/iphone-16-plus-den-thumb-600x600.jpg'),
('iPhone 16 Pro', '6.3-inch Super Retina XDR, A18 Pro chip, 48MP triple-camera, iOS 18, 256GB storage.', 26048925, 130, 2, 1, 'https://cdn.tgdd.vn/Products/Images/42/329143/iphone-16-pro-titan-trang.png'),
('iPhone 16 Pro Max', '6.9-inch Super Retina XDR, A18 Pro chip, 48MP triple-camera, iOS 18, 256GB storage.', 31263925, 110, 2, 1, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:0/q:90/plain/https://cellphones.com.vn/media/wysiwyg/Phone/Apple/iPhone-16/iPhone-16-Pro-Max-12.jpg'),
('iPhone 17', '6.1-inch Super Retina XDR, A19 chip, 50MP dual-camera, iOS 19, 128GB storage.', 22137675, 160, 2, 1, 'https://www.didongmy.com/vnt_upload/product/01_2025/thumbs/600_iphone-17-128gb-didongmy-thumb-600x600.jpg'),
('iPhone 17 Plus', '6.7-inch Super Retina XDR, A19 chip, 50MP dual-camera, iOS 19, 128GB storage.', 24745175, 150, 2, 1, 'https://cdn.xtmobile.vn/vnt_upload/product/03_2025/thumbs/600_iphone_17_plus_xtmobile.jpg'),
('iPhone 17 Pro', '6.3-inch Super Retina XDR, A19 Pro chip, 50MP triple-camera, iOS 19, 256GB storage.', 27352675, 140, 2, 1, 'https://file.hstatic.net/200000845283/article/iphone-17pro-thumb_cc2e30d7824c44fca43d1dbbb8fa6933.jpg'),
('iPhone 17 Pro Max', '6.9-inch Super Retina XDR, A19 Pro chip, 50MP triple-camera, iOS 19, 256GB storage.', 32567675, 120, 2, 1, 'https://www.didongmy.com/vnt_upload/product/03_2025/thumbs/600_iphone-17-pro-max-512gb-specs-thumb-600x600.jpg'),
('iPhone 16e', '6.1-inch Super Retina XDR, A18 chip, 48MP single-camera, iOS 18, 64GB storage.', 15618925, 180, 2, 1, 'https://cdn.tgdd.vn/Products/Images/42/334864/iphone-16e-white-thumb-600x600.jpg'),
('iPhone 17 Air', '6.3-inch Super Retina XDR, A19 chip, 50MP dual-camera, iOS 19, 128GB storage, ultra-thin design.', 23441425, 130, 2, 1, 'https://images2.thanhnien.vn/528068263637045248/2024/12/13/iphone-17-air-1734098971397-173409897177948585030.jpg'),
('iPhone 16 Mini', '5.4-inch Super Retina XDR, A18 chip, 48MP dual-camera, iOS 18, 128GB storage.', 18226425, 170, 2, 1, 'https://kenh14cdn.com/203336854389633024/2024/7/25/iphone-se-4-3-1721873842327-17218738428261928574281.jpg'),
('iPhone 17 Slim', '6.4-inch Super Retina XDR, A19 chip, 50MP dual-camera, iOS 19, 256GB storage, slim design.', 26048925, 140, 2, 1, 'https://cdn.xtmobile.vn/vnt_upload/news/06_2024/iphone-17-slim-gia-bao-nhieu-xtmobile.jpg'),
-- Samsung (9 sản phẩm, category_id=2, brand_id=9)
('Samsung Galaxy S25', '6.2-inch Dynamic AMOLED 2X, Snapdragon 8 Gen 4, 50MP triple-camera, Android 15, 128GB storage.', 20833925, 150, 2, 9, 'https://samcenter.vn/images/thumbs/0010679_samsung-galaxy-s25-256gb.png'),
('Samsung Galaxy S25 Plus', '6.7-inch Dynamic AMOLED 2X, Snapdragon 8 Gen 4, 50MP triple-camera, Android 15, 256GB storage.', 26048925, 130, 2, 9, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/d/i/dien-thoai-samsung-galaxy_4_.png'),
('Samsung Galaxy S25 Ultra', '6.8-inch Dynamic AMOLED 2X, Snapdragon 8 Gen 4, 200MP quad-camera, Android 15, 512GB storage.', 33871425, 100, 2, 9, 'https://cdn.viettelstore.vn/Images/Product/ProductImage/84336239.jpeg'),
('Samsung Galaxy Z Fold 7', '7.6-inch Dynamic AMOLED 2X foldable, Snapdragon 8 Gen 4, 50MP triple-camera, Android 15, 256GB storage.', 46908925, 80, 2, 9, 'https://samcenter.vn/images/thumbs/0014263_z-fold-7-cau-hinh-1_1900.jpeg'),
('Samsung Galaxy Z Flip 7', '6.7-inch Dynamic AMOLED 2X foldable, Snapdragon 8 Gen 4, 50MP dual-camera, Android 15, 256GB storage.', 26048925, 120, 2, 9, 'https://cdn2.fptshop.com.vn/unsafe/800x0/samsung_galaxy_z_flip_7_gia_bao_nhieu_3_fe890230a5.jpg'),
('Samsung Galaxy A56', '6.6-inch Super AMOLED, Exynos 1580, 50MP triple-camera, Android 15, 128GB storage.', 13011425, 200, 2, 9, 'https://cdn.mobilecity.vn/mobilecity-vn/images/2025/03/samsung-galaxy-a56-5g-xanh.jpg.webp'),
('Samsung Galaxy A36', '6.5-inch Super AMOLED, Exynos 1380, 48MP triple-camera, Android 15, 128GB storage.', 10403925, 180, 2, 9, 'https://happyphone.vn/wp-content/uploads/2024/05/Samsung-Galaxy-A36-Den.jpg'),
('Samsung Galaxy M55', '6.7-inch Super AMOLED, Snapdragon 7 Gen 1, 50MP triple-camera, Android 15, 128GB storage.', 9100175, 190, 2, 9, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/s/a/samsung_galaxy_m55.png'),
('Samsung Galaxy S25 FE', '6.6-inch Dynamic AMOLED 2X, Exynos 2300, 50MP triple-camera, Android 15, 128GB storage.', 18226425, 160, 2, 9, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/d/i/dien-thoai-samsung-galaxy-s25-plus_2_1.png'),
-- DELL (4 sản phẩm, category_id=1, brand_id=2)
('DELL XPS 14 2025', '14.5-inch OLED, Intel Core Ultra 7 155H, 16GB RAM, 512GB SSD, NVIDIA RTX 4050, Windows 11 Pro.', 36478925, 90, 1, 2, 'https://www.laptopvip.vn/images/ab__webp/thumbnails/300/300/detailed/39/notebook-xps-14-9440t-sl-gallery-9-4uf6-aa-www.laptopvip.vn-1727146970.png.webp'),
('DELL XPS 16 2025', '16.3-inch OLED, Intel Core Ultra 9 185H, 32GB RAM, 1TB SSD, NVIDIA RTX 4070, Windows 11 Pro.', 46908925, 70, 1, 2, 'https://www.laptopvip.vn/images/ab__webp/thumbnails/300/300/detailed/42/notebook-laptop-xps-16-9640-nt--3--www.laptopvip.vn-1744699863.png.webp'),
('DELL Inspiron 14 Plus 2025', '14.0-inch QHD+, Snapdragon X Plus, 16GB RAM, 512GB SSD, Windows 11 Home, long battery life.', 23441425, 110, 1, 2, 'https://ttcenter.com.vn/uploads/product/1ph8wnbp-1970-dell-inspiron-14-plus-7440f-2025-core7-240h-16gb-ssd-1tb-14inch-qhd-2-5k-90hz-new.jpg'),
('DELL Latitude 7450 2025', '14.0-inch FHD+, Intel Core Ultra 5 125U, 16GB RAM, 512GB SSD, Windows 11 Pro, business-focused.', 33871425, 100, 1, 2, 'https://static.hungphatlaptop.com/wp-content/uploads/2024/05/DELL-Latitude-7450-2024-Features-03-1.jpeg'),
-- ASUS (4 sản phẩm, category_id=1, brand_id=5)
('ASUS Zenbook S 14 2025', '14.0-inch OLED, Intel Core Ultra 7 258V, 16GB RAM, 512GB SSD, Windows 11 Home, ultra-portable.', 31263925, 100, 1, 5, 'https://trungtran.vn/upload_images/images/products/asus-zenbook-series/asus_zenbook_s14_white.jpg'),
('ASUS ROG Zephyrus G16 2025', '16.0-inch OLED, AMD Ryzen AI 9 HX 370, 32GB RAM, 1TB SSD, NVIDIA RTX 4070, Windows 11 Pro.', 52123925, 80, 1, 5, 'https://dlcdnwebimgs.asus.com/gain/AA196938-7A28-4264-904C-F7569F80B7B6'),
('ASUS Vivobook 16 2025', '16.0-inch WUXGA, AMD Ryzen 7 7735HS, 16GB RAM, 512GB SSD, Windows 11 Home, versatile performance.', 20833925, 120, 1, 5, 'https://imagor.owtg.one/unsafe/fit-in/560x560/https://media-api-beta.thinkpro.vn/media/core/products/2024/10/23/laptop-asus-vivobook-s-16-oled-s5606ma-mx051w-undefined.png'),
('ASUS ProArt P16 2025', '16.0-inch OLED, AMD Ryzen AI 9 HX 370, 32GB RAM, 1TB SSD, NVIDIA RTX 4070, Windows 11 Pro.', 41693925, 90, 1, 5, 'https://2tmobile.com/wp-content/uploads/2025/01/asus-proart-p16-h7606-2024-2tmobile.webp');

--ProductDetail
INSERT INTO ProductDetail (product_id, attribute_id, attribute_value)
VALUES
-- MacBook Pro 13.3 i5 2.3GHz (product_id=1, category_id=1)
(1, 1, 'Intel Core i5 2.3GHz'), -- CPU
(1, 2, '8'), -- RAM (GB)
(1, 3, '128'), -- Storage (GB)
(1, 4, 'Intel Iris Plus Graphics 640'), -- GPU
(1, 5, '13.3-inch Retina'), -- Màn hình
(1, 6, 'macOS'), -- Hệ điều hành
(1, 7, '2x Thunderbolt 3'), -- Cổng kết nối
(1, 8, 'Backlit Keyboard'), -- Bàn phím
(1, 9, '720p FaceTime HD'), -- Webcam
(1, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(1, 11, 'Bluetooth 4.2'), -- Bluetooth
(1, 12, '49.2'), -- Pin (Wh)
(1, 13, '1.37'), -- Trọng lượng (kg)
(1, 14, '30.41 x 21.24 x 1.49 cm'), -- Kích thước

-- MacBook Air 13.3 i5 1.8GHz 128GB (product_id=2, category_id=1)
(2, 1, 'Intel Core i5 1.8GHz'), -- CPU
(2, 2, '8'), -- RAM (GB)
(2, 3, '128'), -- Storage (GB)
(2, 4, 'Intel HD Graphics 6000'), -- GPU
(2, 5, '13.3-inch LED'), -- Màn hình
(2, 6, 'macOS'), -- Hệ điều hành
(2, 7, '2x USB 3.0, Thunderbolt 2'), -- Cổng kết nối
(2, 8, 'Backlit Keyboard'), -- Bàn phím
(2, 9, '720p FaceTime HD'), -- Webcam
(2, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(2, 11, 'Bluetooth 4.0'), -- Bluetooth
(2, 12, '45'), -- Pin (Wh)
(2, 13, '1.35'), -- Trọng lượng (kg)
(2, 14, '32.5 x 22.7 x 1.7 cm'), -- Kích thước

-- HP 250 G6 i5 7200U (product_id=3, category_id=1)
(3, 1, 'Intel Core i5 7200U 2.5GHz'), -- CPU
(3, 2, '8'), -- RAM (GB)
(3, 3, '256'), -- Storage (GB)
(3, 4, 'Intel HD Graphics 620'), -- GPU
(3, 5, '15.6-inch HD'), -- Màn hình
(3, 6, 'No OS'), -- Hệ điều hành
(3, 7, 'HDMI, 2x USB 3.1, USB 2.0'), -- Cổng kết nối
(3, 8, 'Standard Keyboard'), -- Bàn phím
(3, 9, 'VGA Webcam'), -- Webcam
(3, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(3, 11, 'Bluetooth 4.2'), -- Bluetooth
(3, 12, '41'), -- Pin (Wh)
(3, 13, '1.86'), -- Trọng lượng (kg)
(3, 14, '38.0 x 25.4 x 2.4 cm'), -- Kích thước

-- MacBook Pro 15.4 i7 2.7GHz (product_id=4, category_id=1)
(4, 1, 'Intel Core i7 2.7GHz'), -- CPU
(4, 2, '16'), -- RAM (GB)
(4, 3, '512'), -- Storage (GB)
(4, 4, 'AMD Radeon Pro 455'), -- GPU
(4, 5, '15.4-inch Retina'), -- Màn hình
(4, 6, 'macOS'), -- Hệ điều hành
(4, 7, '4x Thunderbolt 3'), -- Cổng kết nối
(4, 8, 'Backlit Keyboard'), -- Bàn phím
(4, 9, '720p FaceTime HD'), -- Webcam
(4, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(4, 11, 'Bluetooth 4.2'), -- Bluetooth
(4, 12, '76'), -- Pin (Wh)
(4, 13, '1.83'), -- Trọng lượng (kg)
(4, 14, '34.93 x 24.07 x 1.55 cm'), -- Kích thước

-- MacBook Pro 13.3 i5 3.1GHz (product_id=5, category_id=1)
(5, 1, 'Intel Core i5 3.1GHz'), -- CPU
(5, 2, '8'), -- RAM (GB)
(5, 3, '256'), -- Storage (GB)
(5, 4, 'Intel Iris Plus Graphics 650'), -- GPU
(5, 5, '13.3-inch Retina'), -- Màn hình
(5, 6, 'macOS'), -- Hệ điều hành
(5, 7, '2x Thunderbolt 3'), -- Cổng kết nối
(5, 8, 'Backlit Keyboard'), -- Bàn phím
(5, 9, '720p FaceTime HD'), -- Webcam
(5, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(5, 11, 'Bluetooth 4.2'), -- Bluetooth
(5, 12, '49.2'), -- Pin (Wh)
(5, 13, '1.37'), -- Trọng lượng (kg)
(5, 14, '30.41 x 21.24 x 1.49 cm'), -- Kích thước

-- MacBook Pro 15.4 i7 2.2GHz (product_id=6, category_id=1)
(6, 1, 'Intel Core i7 2.2GHz'), -- CPU
(6, 2, '16'), -- RAM (GB)
(6, 3, '256'), -- Storage (GB)
(6, 4, 'Intel Iris Pro Graphics'), -- GPU
(6, 5, '15.4-inch Retina'), -- Màn hình
(6, 6, 'macOS'), -- Hệ điều hành
(6, 7, '4x Thunderbolt 3'), -- Cổng kết nối
(6, 8, 'Backlit Keyboard'), -- Bàn phím
(6, 9, '720p FaceTime HD'), -- Webcam
(6, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(6, 11, 'Bluetooth 4.2'), -- Bluetooth
(6, 12, '76'), -- Pin (Wh)
(6, 13, '2.04'), -- Trọng lượng (kg)
(6, 14, '34.93 x 24.07 x 1.55 cm'), -- Kích thước

-- MacBook Air 13.3 i5 1.8GHz 256GB (product_id=7, category_id=1)
(7, 1, 'Intel Core i5 1.8GHz'), -- CPU
(7, 2, '8'), -- RAM (GB)
(7, 3, '256'), -- Storage (GB)
(7, 4, 'Intel HD Graphics 6000'), -- GPU
(7, 5, '13.3-inch LED'), -- Màn hình
(7, 6, 'macOS'), -- Hệ điều hành
(7, 7, '2x USB 3.0, Thunderbolt 2'), -- Cổng kết nối
(7, 8, 'Backlit Keyboard'), -- Bàn phím
(7, 9, '720p FaceTime HD'), -- Webcam
(7, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(7, 11, 'Bluetooth 4.0'), -- Bluetooth
(7, 12, '45'), -- Pin (Wh)
(7, 13, '1.35'), -- Trọng lượng (kg)
(7, 14, '32.5 x 22.7 x 1.7 cm'), -- Kích thước

-- ZenBook UX430UN (product_id=8, category_id=1)
(8, 1, 'Intel Core i7 8550U 1.8GHz'), -- CPU
(8, 2, '16'), -- RAM (GB)
(8, 3, '512'), -- Storage (GB)
(8, 4, 'Nvidia GeForce MX150'), -- GPU
(8, 5, '14.0-inch Full HD'), -- Màn hình
(8, 6, 'Windows 10'), -- Hệ điều hành
(8, 7, 'HDMI, USB-C, 2x USB 3.0'), -- Cổng kết nối
(8, 8, 'Backlit Keyboard'), -- Bàn phím
(8, 9, 'HD Webcam'), -- Webcam
(8, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(8, 11, 'Bluetooth 4.2'), -- Bluetooth
(8, 12, '50'), -- Pin (Wh)
(8, 13, '1.25'), -- Trọng lượng (kg)
(8, 14, '32.4 x 22.5 x 1.59 cm'), -- Kích thước

-- Swift 3 (product_id=9, category_id=1)
(9, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(9, 2, '8'), -- RAM (GB)
(9, 3, '256'), -- Storage (GB)
(9, 4, 'Intel UHD Graphics 620'), -- GPU
(9, 5, '14.0-inch Full HD IPS'), -- Màn hình
(9, 6, 'Windows 10'), -- Hệ điều hành
(9, 7, 'HDMI, USB-C, 2x USB 3.0'), -- Cổng kết nối
(9, 8, 'Backlit Keyboard'), -- Bàn phím
(9, 9, 'HD Webcam'), -- Webcam
(9, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(9, 11, 'Bluetooth 4.0'), -- Bluetooth
(9, 12, '48'), -- Pin (Wh)
(9, 13, '1.6'), -- Trọng lượng (kg)
(9, 14, '33.8 x 23.4 x 1.79 cm'), -- Kích thước

-- HP 250 G6 i3 6006U (product_id=10, category_id=1)
(10, 1, 'Intel Core i3 6006U 2GHz'), -- CPU
(10, 2, '4'), -- RAM (GB)
(10, 3, '512'), -- Storage (GB)
(10, 4, 'Intel HD Graphics 520'), -- GPU
(10, 5, '15.6-inch HD'), -- Màn hình
(10, 6, 'No OS'), -- Hệ điều hành
(10, 7, 'HDMI, 2x USB 3.1, USB 2.0'), -- Cổng kết nối
(10, 8, 'Standard Keyboard'), -- Bàn phím
(10, 9, 'VGA Webcam'), -- Webcam
(10, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(10, 11, 'Bluetooth 4.0'), -- Bluetooth
(10, 12, '41'), -- Pin (Wh)
(10, 13, '1.86'), -- Trọng lượng (kg)
(10, 14, '38.0 x 25.4 x 2.4 cm'), -- Kích thước

-- MacBook Pro 15.4 i7 2.8GHz (product_id=11, category_id=1)
(11, 1, 'Intel Core i7 2.8GHz'), -- CPU
(11, 2, '16'), -- RAM (GB)
(11, 3, '256'), -- Storage (GB)
(11, 4, 'AMD Radeon Pro 555'), -- GPU
(11, 5, '15.4-inch Retina'), -- Màn hình
(11, 6, 'macOS'), -- Hệ điều hành
(11, 7, '4x Thunderbolt 3'), -- Cổng kết nối
(11, 8, 'Backlit Keyboard'), -- Bàn phím
(11, 9, '720p FaceTime HD'), -- Webcam
(11, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(11, 11, 'Bluetooth 4.2'), -- Bluetooth
(11, 12, '76'), -- Pin (Wh)
(11, 13, '1.83'), -- Trọng lượng (kg)
(11, 14, '34.93 x 24.07 x 1.55 cm'), -- Kích thước

-- Inspiron 3567 i3 6006U (product_id=12, category_id=1)
(12, 1, 'Intel Core i3 6006U 2GHz'), -- CPU
(12, 2, '4'), -- RAM (GB)
(12, 3, '256'), -- Storage (GB)
(12, 4, 'Intel HD Graphics 520'), -- GPU
(12, 5, '15.6-inch Full HD'), -- Màn hình
(12, 6, 'Windows 10'), -- Hệ điều hành
(12, 7, 'HDMI, 2x USB 3.0, USB 2.0'), -- Cổng kết nối
(12, 8, 'Standard Keyboard'), -- Bàn phím
(12, 9, 'HD Webcam'), -- Webcam
(12, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(12, 11, 'Bluetooth 4.0'), -- Bluetooth
(12, 12, '45'), -- Pin (Wh)
(12, 13, '2.2'), -- Trọng lượng (kg)
(12, 14, '38.0 x 26.0 x 2.53 cm'), -- Kích thước

-- MacBook 12 (product_id=13, category_id=1)
(13, 1, 'Intel Core m3 1.2GHz'), -- CPU
(13, 2, '8'), -- RAM (GB)
(13, 3, '256'), -- Storage (GB)
(13, 4, 'Intel HD Graphics 615'), -- GPU
(13, 5, '12.0-inch Retina'), -- Màn hình
(13, 6, 'macOS'), -- Hệ điều hành
(13, 7, '1x USB-C'), -- Cổng kết nối
(13, 8, 'Backlit Keyboard'), -- Bàn phím
(13, 9, '480p FaceTime'), -- Webcam
(13, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(13, 11, 'Bluetooth 4.2'), -- Bluetooth
(13, 12, '41.4'), -- Pin (Wh)
(13, 13, '0.92'), -- Trọng lượng (kg)
(13, 14, '28.05 x 19.65 x 1.31 cm'), -- Kích thước

-- Inspiron 3567 i7 7500U (product_id=14, category_id=1)
(14, 1, 'Intel Core i7 7500U 2.7GHz'), -- CPU
(14, 2, '8'), -- RAM (GB)
(14, 3, '256'), -- Storage (GB)
(14, 4, 'AMD Radeon R7 M440'), -- GPU
(14, 5, '15.6-inch Full HD'), -- Màn hình
(14, 6, 'Windows 10'), -- Hệ điều hành
(14, 7, 'HDMI, 2x USB 3.0, USB 2.0'), -- Cổng kết nối
(14, 8, 'Standard Keyboard'), -- Bàn phím
(14, 9, 'HD Webcam'), -- Webcam
(14, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(14, 11, 'Bluetooth 4.0'), -- Bluetooth
(14, 12, '45'), -- Pin (Wh)
(14, 13, '2.2'), -- Trọng lượng (kg)
(14, 14, '38.0 x 26.0 x 2.53 cm'), -- Kích thước

-- MacBook Pro 15.4 i7 2.9GHz (product_id=15, category_id=1)
(15, 1, 'Intel Core i7 2.9GHz'), -- CPU
(15, 2, '16'), -- RAM (GB)
(15, 3, '512'), -- Storage (GB)
(15, 4, 'AMD Radeon Pro 560'), -- GPU
(15, 5, '15.4-inch Retina'), -- Màn hình
(15, 6, 'macOS'), -- Hệ điều hành
(15, 7, '4x Thunderbolt 3'), -- Cổng kết nối
(15, 8, 'Backlit Keyboard'), -- Bàn phím
(15, 9, '720p FaceTime HD'), -- Webcam
(15, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(15, 11, 'Bluetooth 4.2'), -- Bluetooth
(15, 12, '76'), -- Pin (Wh)
(15, 13, '1.83'), -- Trọng lượng (kg)
(15, 14, '34.93 x 24.07 x 1.55 cm'), -- Kích thước

-- IdeaPad 320-15IKB (product_id=16, category_id=1)
(16, 1, 'Intel Core i3 7100U 2.4GHz'), -- CPU
(16, 2, '8'), -- RAM (GB)
(16, 3, '1024'), -- Storage (GB)
(16, 4, 'Nvidia GeForce 940MX'), -- GPU
(16, 5, '15.6-inch Full HD'), -- Màn hình
(16, 6, 'No OS'), -- Hệ điều hành
(16, 7, 'HDMI, 2x USB 3.0, USB-C'), -- Cổng kết nối
(16, 8, 'Standard Keyboard'), -- Bàn phím
(16, 9, 'HD Webcam'), -- Webcam
(16, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(16, 11, 'Bluetooth 4.1'), -- Bluetooth
(16, 12, '45'), -- Pin (Wh)
(16, 13, '2.2'), -- Trọng lượng (kg)
(16, 14, '37.8 x 26.0 x 2.29 cm'), -- Kích thước

-- XPS 13 i5 8250U (product_id=17, category_id=1)
(17, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(17, 2, '8'), -- RAM (GB)
(17, 3, '256'), -- Storage (GB)
(17, 4, 'Intel UHD Graphics 620'), -- GPU
(17, 5, '13.3-inch Full HD Touch'), -- Màn hình
(17, 6, 'Windows 10'), -- Hệ điều hành
(17, 7, 'Thunderbolt 3, 2x USB-C'), -- Cổng kết nối
(17, 8, 'Backlit Keyboard'), -- Bàn phím
(17, 9, '720p Webcam'), -- Webcam
(17, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(17, 11, 'Bluetooth 4.1'), -- Bluetooth
(17, 12, '52'), -- Pin (Wh)
(17, 13, '1.22'), -- Trọng lượng (kg)
(17, 14, '30.2 x 19.9 x 1.16 cm'), -- Kích thước

-- Vivobook E200HA (product_id=18, category_id=1)
(18, 1, 'Intel Atom x5-Z8350'), -- CPU
(18, 2, '2'), -- RAM (GB)
(18, 3, '256'), -- Storage (GB)
(18, 4, 'Intel HD Graphics'), -- GPU
(18, 5, '11.6-inch HD'), -- Màn hình
(18, 6, 'Windows 10'), -- Hệ điều hành
(18, 7, 'HDMI, USB 3.0, USB 2.0'), -- Cổng kết nối
(18, 8, 'Standard Keyboard'), -- Bàn phím
(18, 9, 'VGA Webcam'), -- Webcam
(18, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(18, 11, 'Bluetooth 4.0'), -- Bluetooth
(18, 12, '38'), -- Pin (Wh)
(18, 13, '0.98'), -- Trọng lượng (kg)
(18, 14, '28.6 x 19.3 x 1.75 cm'), -- Kích thước

-- Legion Y520-15IKBN (product_id=19, category_id=1)
(19, 1, 'Intel Core i5 7300HQ 2.5GHz'), -- CPU
(19, 2, '8'), -- RAM (GB)
(19, 3, '1024'), -- Storage (GB)
(19, 4, 'Nvidia GeForce GTX 1050'), -- GPU
(19, 5, '15.6-inch Full HD IPS'), -- Màn hình
(19, 6, 'Windows 10'), -- Hệ điều hành
(19, 7, 'HDMI, 2x USB 3.0, USB-C'), -- Cổng kết nối
(19, 8, 'Backlit Keyboard'), -- Bàn phím
(19, 9, 'HD Webcam'), -- Webcam
(19, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(19, 11, 'Bluetooth 4.1'), -- Bluetooth
(19, 12, '62'), -- Pin (Wh)
(19, 13, '2.5'), -- Trọng lượng (kg)
(19, 14, '38.0 x 26.5 x 2.59 cm'), -- Kích thước

-- HP 255 G6 (product_id=20, category_id=1)
(20, 1, 'AMD E2-9000e 1.5GHz'), -- CPU
(20, 2, '4'), -- RAM (GB)
(20, 3, '256'), -- Storage (GB)
(20, 4, 'AMD Radeon R2'), -- GPU
(20, 5, '15.6-inch HD'), -- Màn hình
(20, 6, 'Windows 11'), -- Hệ điều hành
(20, 7, 'HDMI, 2x USB 3.1, USB 2.0'), -- Cổng kết nối
(20, 8, 'Standard Keyboard'), -- Bàn phím
(20, 9, 'VGA Webcam'), -- Webcam
(20, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(20, 11, 'Bluetooth 4.2'), -- Bluetooth
(20, 12, '41'), -- Pin (Wh)
(20, 13, '1.86'), -- Trọng lượng (kg)
(20, 14, '38.0 x 25.4 x 2.4 cm'), -- Kích thước

-- Inspiron 5379 (product_id=21, category_id=1)
(21, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(21, 2, '8'), -- RAM (GB)
(21, 3, '256'), -- Storage (GB)
(21, 4, 'Intel UHD Graphics 620'), -- GPU
(21, 5, '13.3-inch Full HD Touch'), -- Màn hình
(21, 6, 'Windows 10'), -- Hệ điều hành
(21, 7, 'HDMI, USB-C, 2x USB 3.1'), -- Cổng kết nối
(21, 8, 'Backlit Keyboard'), -- Bàn phím
(21, 9, 'HD Webcam'), -- Webcam
(21, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(21, 11, 'Bluetooth 4.2'), -- Bluetooth
(21, 12, '42'), -- Pin (Wh)
(21, 13, '1.62'), -- Trọng lượng (kg)
(21, 14, '32.4 x 22.4 x 1.95 cm'), -- Kích thước

-- HP 15-BS101nv (product_id=22, category_id=1)
(22, 1, 'Intel Core i7 8550U 1.8GHz'), -- CPU
(22, 2, '8'), -- RAM (GB)
(22, 3, '256'), -- Storage (GB)
(22, 4, 'Intel UHD Graphics 620'), -- GPU
(22, 5, '15.6-inch Full HD'), -- Màn hình
(22, 6, 'Windows 10'), -- Hệ điều hành
(22, 7, 'HDMI, 2x USB 3.1, USB 2.0'), -- Cổng kết nối
(22, 8, 'Backlit Keyboard'), -- Bàn phím
(22, 9, 'HD Webcam'), -- Webcam
(22, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(22, 11, 'Bluetooth 4.2'), -- Bluetooth
(22, 12, '41'), -- Pin (Wh)
(22, 13, '1.91'), -- Trọng lượng (kg)
(22, 14, '38.0 x 25.4 x 2.38 cm'), -- Kích thước

-- Inspiron 5570 (product_id=23, category_id=1)
(23, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(23, 2, '8'), -- RAM (GB)
(23, 3, '256'), -- Storage (GB)
(23, 4, 'AMD Radeon 530'), -- GPU
(23, 5, '15.6-inch Full HD'), -- Màn hình
(23, 6, 'Windows 10'), -- Hệ điều hành
(23, 7, 'HDMI, USB-C, 2x USB 3.1'), -- Cổng kết nối
(23, 8, 'Backlit Keyboard'), -- Bàn phím
(23, 9, 'HD Webcam'), -- Webcam
(23, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(23, 11, 'Bluetooth 4.2'), -- Bluetooth
(23, 12, '42'), -- Pin (Wh)
(23, 13, '2.2'), -- Trọng lượng (kg)
(23, 14, '38.0 x 25.8 x 2.27 cm'), -- Kích thước

-- Latitude 5590 (product_id=24, category_id=1)
(24, 1, 'Intel Core i7 8650U 1.9GHz'), -- CPU
(24, 2, '8'), -- RAM (GB)
(24, 3, '512'), -- Storage (GB)
(24, 4, 'Intel UHD Graphics 620'), -- GPU
(24, 5, '15.6-inch Full HD'), -- Màn hình
(24, 6, 'Windows 10'), -- Hệ điều hành
(24, 7, 'HDMI, USB-C, 3x USB 3.1'), -- Cổng kết nối
(24, 8, 'Backlit Keyboard'), -- Bàn phím
(24, 9, 'HD Webcam'), -- Webcam
(24, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(24, 11, 'Bluetooth 4.2'), -- Bluetooth
(24, 12, '56'), -- Pin (Wh)
(24, 13, '1.88'), -- Trọng lượng (kg)
(24, 14, '37.6 x 25.1 x 2.06 cm'), -- Kích thước

-- ProBook 470 (product_id=25, category_id=1)
(25, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(25, 2, '8'), -- RAM (GB)
(25, 3, '1024'), -- Storage (GB)
(25, 4, 'Nvidia GeForce 930MX'), -- GPU
(25, 5, '17.3-inch Full HD'), -- Màn hình
(25, 6, 'Windows 10'), -- Hệ điều hành
(25, 7, 'HDMI, USB-C, 2x USB 3.1'), -- Cổng kết nối
(25, 8, 'Backlit Keyboard'), -- Bàn phím
(25, 9, 'HD Webcam'), -- Webcam
(25, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(25, 11, 'Bluetooth 4.2'), -- Bluetooth
(25, 12, '55'), -- Pin (Wh)
(25, 13, '2.5'), -- Trọng lượng (kg)
(25, 14, '41.6 x 27.6 x 2.58 cm'), -- Kích thước

-- HP 17-ak001nv (product_id=26)
(26, 1, 'AMD A6-9220 2.5GHz'),
(26, 2, '4'),
(26, 3, '500'),
(26, 4, 'AMD Radeon 530'),
(26, 5, '17.3-inch HD+'),
(26, 6, 'Windows 10'),
(26, 7, 'HDMI, 2x USB 3.1, USB 2.0'),
(26, 8, 'Standard Keyboard'),
(26, 9, 'VGA Webcam'),
(26, 10, 'Wi-Fi 802.11ac'),
(26, 11, 'Bluetooth 4.2'),
(26, 12, '41'),
(26, 13, '2.71'),
(26, 14, '41.5 x 27.8 x 2.46 cm'),

-- XPS 13 i7 8550U (product_id=27)
(27, 1, 'Intel Core i7 8550U 1.8GHz'),
(27, 2, '16'),
(27, 3, '512'),
(27, 4, 'Intel UHD Graphics 620'),
(27, 5, '13.3-inch Quad HD+ Touch'),
(27, 6, 'Windows 10'),
(27, 7, 'Thunderbolt 3, 2x USB-C'),
(27, 8, 'Backlit Keyboard'),
(27, 9, '720p Webcam'),
(27, 10, 'Wi-Fi 802.11ac'),
(27, 11, 'Bluetooth 4.1'),
(27, 12, '52'),
(27, 13, '1.2'),
(27, 14, '30.2 x 19.9 x 1.16 cm'),

-- IdeaPad 120S-14IAP (product_id=28)
(28, 1, 'Intel Celeron N3350 1.1GHz'),
(28, 2, '4'),
(28, 3, '64'),
(28, 4, 'Intel HD Graphics 500'),
(28, 5, '14.0-inch HD'),
(28, 6, 'Windows 10'),
(28, 7, 'HDMI, USB-C, USB 3.0'),
(28, 8, 'Standard Keyboard'),
(28, 9, 'VGA Webcam'),
(28, 10, 'Wi-Fi 802.11ac'),
(28, 11, 'Bluetooth 4.0'),
(28, 12, '32'),
(28, 13, '1.44'),
(28, 14, '33.4 x 23.5 x 1.88 cm'),

-- Inspiron 5770 (product_id=29)
(29, 1, 'Intel Core i5 8250U 1.6GHz'),
(29, 2, '8'),
(29, 3, '1128'),
(29, 4, 'AMD Radeon 530'),
(29, 5, '17.3-inch Full HD'),
(29, 6, 'Windows 10'),
(29, 7, 'HDMI, USB-C, 2x USB 3.1'),
(29, 8, 'Backlit Keyboard'),
(29, 9, 'HD Webcam'),
(29, 10, 'Wi-Fi 802.11ac'),
(29, 11, 'Bluetooth 4.2'),
(29, 12, '56'),
(29, 13, '2.8'),
(29, 14, '41.6 x 27.9 x 2.5 cm'),

(30, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(30, 2, '8'), -- RAM (GB)
(30, 3, '256'), -- Storage (GB)
(30, 4, 'Nvidia GeForce 930MX'), -- GPU
(30, 5, '15.6-inch Full HD'), -- Màn hình
(30, 6, 'Windows 10'), -- Hệ điều hành
(30, 7, 'HDMI, USB-C, 2x USB 3.1'), -- Cổng kết nối
(30, 8, 'Backlit Keyboard'), -- Bàn phím
(30, 9, 'HD Webcam'), -- Webcam
(30, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(30, 11, 'Bluetooth 4.2'), -- Bluetooth
(30, 12, '48'), -- Pin (Wh)
(30, 13, '2.1'), -- Trọng lượng (kg)
(30, 14, '37.6 x 25.7 x 2.09 cm'), -- Kích thước

(31, 1, 'Intel Core i3 6006U 2GHz'), -- CPU
(31, 2, '4'), -- RAM (GB)
(31, 3, '1024'), -- Storage (GB)
(31, 4, 'Intel HD Graphics 520'), -- GPU
(31, 5, '15.6-inch Full HD'), -- Màn hình
(31, 6, 'Linux'), -- Hệ điều hành
(31, 7, 'HDMI, 2x USB 3.0, USB 2.0'), -- Cổng kết nối
(31, 8, 'Standard Keyboard'), -- Bàn phím
(31, 9, 'VGA Webcam'), -- Webcam
(31, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(31, 11, 'Bluetooth 4.0'), -- Bluetooth
(31, 12, '41'), -- Pin (Wh)
(31, 13, '2.0'), -- Trọng lượng (kg)
(31, 14, '38.1 x 25.2 x 2.72 cm'), -- Kích thước

(32, 1, 'Intel Core i7 7700HQ 2.8GHz'), -- CPU
(32, 2, '16'), -- RAM (GB)
(32, 3, '256'), -- Storage (GB)
(32, 4, 'Nvidia GeForce GTX 1060'), -- GPU
(32, 5, '15.6-inch Full HD IPS'), -- Màn hình
(32, 6, 'Windows 10'), -- Hệ điều hành
(32, 7, 'HDMI, Thunderbolt 3, 3x USB 3.1'), -- Cổng kết nối
(32, 8, 'Backlit Keyboard'), -- Bàn phím
(32, 9, 'HD Webcam'), -- Webcam
(32, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(32, 11, 'Bluetooth 4.2'), -- Bluetooth
(32, 12, '56'), -- Pin (Wh)
(32, 13, '2.65'), -- Trọng lượng (kg)
(32, 14, '38.4 x 27.4 x 2.5 cm'), -- Kích thước

(33, 1, 'Intel Core i5 7200U 2.5GHz'), -- CPU
(33, 2, '8'), -- RAM (GB)
(33, 3, '1024'), -- Storage (GB)
(33, 4, 'Nvidia GeForce 940MX'), -- GPU
(33, 5, '15.6-inch Full HD'), -- Màn hình
(33, 6, 'Linux'), -- Hệ điều hành
(33, 7, 'HDMI, 2x USB 3.0, USB 2.0'), -- Cổng kết nối
(33, 8, 'Standard Keyboard'), -- Bàn phím
(33, 9, 'VGA Webcam'), -- Webcam
(33, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(33, 11, 'Bluetooth 4.0'), -- Bluetooth
(33, 12, '41'), -- Pin (Wh)
(33, 13, '2.3'), -- Trọng lượng (kg)
(33, 14, '38.1 x 25.2 x 2.72 cm'), -- Kích thước

(34, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(34, 2, '4'), -- RAM (GB)
(34, 3, '256'), -- Storage (GB)
(34, 4, 'Nvidia GeForce MX150'), -- GPU
(34, 5, '15.6-inch Full HD IPS'), -- Màn hình
(34, 6, 'Windows 10'), -- Hệ điều hành
(34, 7, 'HDMI, USB-C, 2x USB 3.0'), -- Cổng kết nối
(34, 8, 'Backlit Keyboard'), -- Bàn phím
(34, 9, 'HD Webcam'), -- Webcam
(34, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(34, 11, 'Bluetooth 4.0'), -- Bluetooth
(34, 12, '48'), -- Pin (Wh)
(34, 13, '2.2'), -- Trọng lượng (kg)
(34, 14, '38.1 x 26.3 x 2.1 cm'), -- Kích thước

(35, 1, 'Intel Core i5 8250U 1.6GHz'), -- CPU
(35, 2, '12'), -- RAM (GB)
(35, 3, '1024'), -- Storage (GB)
(35, 4, 'Nvidia GeForce 150MX'), -- GPU
(35, 5, '17.3-inch Full HD Touch'), -- Màn hình
(35, 6, 'Windows 10'), -- Hệ điều hành
(35, 7, 'HDMI, USB-C, 2x USB 3.1'), -- Cổng kết nối
(35, 8, 'Backlit Keyboard'), -- Bàn phím
(35, 9, 'HD Webcam'), -- Webcam
(35, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(35, 11, 'Bluetooth 4.2'), -- Bluetooth
(35, 12, '56'), -- Pin (Wh)
(35, 13, '2.77'), -- Trọng lượng (kg)
(35, 14, '41.6 x 27.9 x 2.5 cm'), -- Kích thước

(36, 1, 'Intel Core i5 2.0GHz'), -- CPU
(36, 2, '8'), -- RAM (GB)
(36, 3, '256'), -- Storage (GB)
(36, 4, 'Intel Iris Graphics'), -- GPU
(36, 5, '13.3-inch Retina'), -- Màn hình
(36, 6, 'macOS'), -- Hệ điều hành
(36, 7, '2x Thunderbolt 3'), -- Cổng kết nối
(36, 8, 'Backlit Keyboard'), -- Bàn phím
(36, 9, '720p FaceTime HD'), -- Webcam
(36, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(36, 11, 'Bluetooth 4.2'), -- Bluetooth
(36, 12, '49.2'), -- Pin (Wh)
(36, 13, '1.37'), -- Trọng lượng (kg)
(36, 14, '30.41 x 21.24 x 1.49 cm'), -- Kích thước

(37, 1, 'Intel Core i3 6006U 2GHz'), -- CPU
(37, 2, '4'), -- RAM (GB)
(37, 3, '128'), -- Storage (GB)
(37, 4, 'Intel HD Graphics 520'), -- GPU
(37, 5, '15.6-inch Full HD'), -- Màn hình
(37, 6, 'No OS'), -- Hệ điều hành
(37, 7, 'HDMI, 2x USB 3.0, USB-C'), -- Cổng kết nối
(37, 8, 'Standard Keyboard'), -- Bàn phím
(37, 9, 'HD Webcam'), -- Webcam
(37, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(37, 11, 'Bluetooth 4.1'), -- Bluetooth
(37, 12, '45'), -- Pin (Wh)
(37, 13, '2.2'), -- Trọng lượng (kg)
(37, 14, '37.8 x 26.0 x 2.29 cm'), -- Kích thước

(38, 1, 'AMD Ryzen 7 1700 3GHz'), -- CPU
(38, 2, '8'), -- RAM (GB)
(38, 3, '256'), -- Storage (GB)
(38, 4, 'AMD Radeon RX 580'), -- GPU
(38, 5, '15.6-inch Full HD 120Hz'), -- Màn hình
(38, 6, 'Windows 10'), -- Hệ điều hành
(38, 7, 'HDMI, USB-C, 3x USB 3.1'), -- Cổng kết nối
(38, 8, 'RGB Backlit Keyboard'), -- Bàn phím
(38, 9, 'HD Webcam'), -- Webcam
(38, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(38, 11, 'Bluetooth 4.2'), -- Bluetooth
(38, 12, '66'), -- Pin (Wh)
(38, 13, '3.2'), -- Trọng lượng (kg)
(38, 14, '38.4 x 26.2 x 2.62 cm'), -- Kích thước

(39, 1, 'Intel Core i5 7200U 2.5GHz'), -- CPU
(39, 2, '4'), -- RAM (GB)
(39, 3, '256'), -- Storage (GB)
(39, 4, 'AMD Radeon R5 M430'), -- GPU
(39, 5, '15.6-inch Full HD'), -- Màn hình
(39, 6, 'Windows 10'), -- Hệ điều hành
(39, 7, 'HDMI, 2x USB 3.0, USB 2.0'), -- Cổng kết nối
(39, 8, 'Standard Keyboard'), -- Bàn phím
(39, 9, 'HD Webcam'), -- Webcam
(39, 10, 'Wi-Fi 802.11ac'), -- Wi-Fi
(39, 11, 'Bluetooth 4.0'), -- Bluetooth
(39, 12, '45'), -- Pin (Wh)
(39, 13, '2.3'), -- Trọng lượng (kg)
(39, 14, '38.0 x 26.0 x 2.53 cm'), -- Kích thước

(40, 28, '8000'), -- DPI
(40, 29, 'Wireless'), -- Connection Type
(40, 30, '7'), -- Buttons
(40, 31, 'Optical'), -- Sensor Type
(40, 32, '1024'), -- Polling Rate (Hz)
(40, 33, '70 hours'), -- Battery Life
(40, 34, '141'), -- Weight (g)

(41, 42, 'TKL'), -- Key Layout
(41, 43, 'ASUS NX Red'), -- Switch Type
(41, 44, 'Wired'), -- Connection Type
(41, 45, 'RGB'), -- Backlight
(41, 46, 'N/A'), -- Battery Life
(41, 47, '880'), -- Weight (g)
(41, 48, '35.6 x 13.6 x 3.9 cm'), -- Dimensions

(42, 42, 'Standard with Touchpad'), -- Key Layout
(42, 43, 'Membrane'), -- Switch Type
(42, 44, 'Bluetooth'), -- Connection Type
(42, 45, 'White'), -- Backlight
(42, 46, '20 hours'), -- Battery Life
(42, 47, '645'), -- Weight (g)
(42, 48, '25.2 x 19.2 x 1.6 cm'), -- Dimensions

(43, 28, '30000'), -- DPI
(43, 29, 'Wireless'), -- Connection Type
(43, 30, '5'), -- Buttons
(43, 31, 'Optical'), -- Sensor Type
(43, 32, '1024'), -- Polling Rate (Hz)
(43, 33, '90 hours'), -- Battery Life
(43, 34, '63'), -- Weight (g)

(44, 42, '80%'), -- Key Layout
(44, 43, 'Gateron Brown'), -- Switch Type
(44, 44, 'Wireless'), -- Connection Type
(44, 45, 'RGB'), -- Backlight
(44, 46, '70 hours'), -- Battery Life
(44, 47, '990'), -- Weight (g)
(44, 48, '35.9 x 12.4 x 4.2 cm'), -- Dimensions

(45, 1, 'Intel Core i7 13620H 2.4GHz'), -- CPU
(45, 2, '16'), -- RAM (GB)
(45, 3, '1024'), -- Storage (GB)
(45, 4, 'Nvidia RTX 4070'), -- GPU
(45, 5, '15.6-inch Full HD 165Hz'), -- Màn hình
(45, 6, 'Windows 11'), -- Hệ điều hành
(45, 7, 'HDMI, USB-C, 3x USB 3.2'), -- Cổng kết nối
(45, 8, 'RGB Backlit Keyboard'), -- Bàn phím
(45, 9, 'HD Webcam'), -- Webcam
(45, 10, 'Wi-Fi 6'), -- Wi-Fi
(45, 11, 'Bluetooth 5.2'), -- Bluetooth
(45, 12, '53.5'), -- Pin (Wh)
(45, 13, '2.25'), -- Trọng lượng (kg)
(45, 14, '35.9 x 25.9 x 2.49 cm'), -- Kích thước

(46, 1, 'Intel Core i7 13700H 2.4GHz'), -- CPU
(46, 2, '16'), -- RAM (GB)
(46, 3, '512'), -- Storage (GB)
(46, 4, 'Nvidia RTX 4060'), -- GPU
(46, 5, '16.0-inch Full HD 144Hz'), -- Màn hình
(46, 6, 'Windows 11'), -- Hệ điều hành
(46, 7, 'HDMI, USB-C, 2x USB 3.2'), -- Cổng kết nối
(46, 8, 'RGB Backlit Keyboard'), -- Bàn phím
(46, 9, 'HD Webcam'), -- Webcam
(46, 10, 'Wi-Fi 6E'), -- Wi-Fi
(46, 11, 'Bluetooth 5.3'), -- Bluetooth
(46, 12, '99.9'), -- Pin (Wh)
(46, 13, '1.88'), -- Trọng lượng (kg)
(46, 14, '35.5 x 24.6 x 1.99 cm'), -- Kích thước

(47, 1, 'Intel Core Ultra 7 155H 1.4GHz'), -- CPU
(47, 2, '16'), -- RAM (GB)
(47, 3, '512'), -- Storage (GB)
(47, 4, 'Intel Arc Graphics'), -- GPU
(47, 5, '14.0-inch Full HD+'), -- Màn hình
(47, 6, 'Windows 11'), -- Hệ điều hành
(47, 7, 'HDMI, 2x Thunderbolt 4, USB 3.2'), -- Cổng kết nối
(47, 8, 'Backlit Keyboard'), -- Bàn phím
(47, 9, 'FHD Webcam'), -- Webcam
(47, 10, 'Wi-Fi 7'), -- Wi-Fi
(47, 11, 'Bluetooth 5.4'), -- Bluetooth
(47, 12, '70'), -- Pin (Wh)
(47, 13, '1.49'), -- Trọng lượng (kg)
(47, 14, '31.4 x 22.7 x 1.79 cm'), -- Kích thước

(48, 1, 'Intel Core i9 13950HX 2.2GHz'), -- CPU
(48, 2, '32'), -- RAM (GB)
(48, 3, '2000'), -- Storage (GB)
(48, 4, 'Nvidia RTX 3080 Ti'), -- GPU
(48, 5, '17.0-inch 4K Touch'), -- Màn hình
(48, 6, 'Windows 11 Pro'), -- Hệ điều hành
(48, 7, 'HDMI, Thunderbolt 4, 2x USB 3.2'), -- Cổng kết nối
(48, 8, 'RGB Backlit Keyboard'), -- Bàn phím
(48, 9, 'FHD Webcam'), -- Webcam
(48, 10, 'Wi-Fi 6E'), -- Wi-Fi
(48, 11, 'Bluetooth 5.3'), -- Bluetooth
(48, 12, '99'), -- Pin (Wh)
(48, 13, '2.49'), -- Trọng lượng (kg)
(48, 14, '38.2 x 26.0 x 1.9 cm'), -- Kích thước

(49, 1, 'Intel Core i9 13980HX 2.2GHz'), -- CPU
(49, 2, '32'), -- RAM (GB)
(49, 3, '1024'), -- Storage (GB)
(49, 4, 'Nvidia RTX 4080'), -- GPU
(49, 5, '17.3-inch QHD 240Hz'), -- Màn hình
(49, 6, 'Windows 11'), -- Hệ điều hành
(49, 7, 'HDMI, Thunderbolt 4, 2x USB 3.2'), -- Cổng kết nối
(49, 8, 'RGB Backlit Keyboard'), -- Bàn phím
(49, 9, 'FHD Webcam'), -- Webcam
(49, 10, 'Wi-Fi 6E'), -- Wi-Fi
(49, 11, 'Bluetooth 5.2'), -- Bluetooth
(49, 12, '99'), -- Pin (Wh)
(49, 13, '2.7'), -- Trọng lượng (kg)
(49, 14, '39.8 x 27.3 x 2.6 cm'), -- Kích thước

(50, 1, 'Intel Core i7 13700H 2.4GHz'), -- CPU
(50, 2, '16'), -- RAM (GB)
(50, 3, '1024'), -- Storage (GB)
(50, 4, 'Nvidia RTX 3070'), -- GPU
(50, 5, '15.6-inch 4K AMOLED'), -- Màn hình
(50, 6, 'Windows 11'), -- Hệ điều hành
(50, 7, 'HDMI, Thunderbolt 4, 2x USB 3.2'), -- Cổng kết nối
(50, 8, 'RGB Backlit Keyboard'), -- Bàn phím
(50, 9, 'FHD Webcam'), -- Webcam
(50, 10, 'Wi-Fi 6E'), -- Wi-Fi
(50, 11, 'Bluetooth 5.2'), -- Bluetooth
(50, 12, '94'), -- Pin (Wh)
(50, 13, '2.1'), -- Trọng lượng (kg)
(50, 14, '35.6 x 25.0 x 2.39 cm'); -- Kích thước

INSERT INTO ProductDetail (product_id, attribute_id, attribute_value)
VALUES
-- Gigabyte G5 (product_id=51, category_id=1)
(51, 1, 'Intel Core i5 13500H 2.6GHz'), -- CPU
(51, 2, '8'), -- RAM (GB)
(51, 3, '512'), -- Storage (GB)
(51, 4, 'Nvidia RTX 4050'), -- GPU
(51, 5, '15.6-inch Full HD 144Hz'), -- Màn hình
(51, 6, 'Windows 11'), -- Hệ điều hành
(51, 7, 'HDMI, USB-C, 2x USB 3.2'), -- Cổng kết nối
(51, 8, 'Backlit Keyboard'), -- Bàn phím
(51, 9, 'HD Webcam'), -- Webcam
(51, 10, 'Wi-Fi 6'), -- Wi-Fi
(51, 11, 'Bluetooth 5.2'), -- Bluetooth
(51, 12, '54'), -- Pin (Wh)
(51, 13, '2.08'), -- Trọng lượng (kg)
(51, 14, '36.0 x 23.8 x 2.27 cm'), -- Kích thước

-- Samsung Galaxy S24 Ultra (product_id=52, category_id=2)
(52, 15, '6.8-inch Dynamic AMOLED 2X'), -- Màn hình
(52, 16, '3120 x 1440'), -- Độ phân giải màn hình
(52, 17, '200MP + 12MP + 10MP + 10MP'), -- Camera
(52, 18, 'Snapdragon 8 Gen 3'), -- Chip xử lý
(52, 19, 'Android 14'), -- Hệ điều hành
(52, 20, '12'), -- RAM (GB)
(52, 21, '256'), -- Bộ nhớ trong (GB)
(52, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(52, 23, '5000'), -- Dung lượng pin (mAh)
(52, 24, '45W Fast Charging'), -- Sạc
(52, 25, 'Titanium Black'), -- Màu sắc
(52, 26, '232'), -- Trọng lượng (g)
(52, 27, '3.4'), -- Tốc độ xử lý (GHz)

-- Samsung Galaxy A35 (product_id=53, category_id=2)
(53, 15, '6.6-inch Super AMOLED'), -- Màn hình
(53, 16, '1080 x 2340'), -- Độ phân giải màn hình
(53, 17, '50MP + 8MP + 5MP'), -- Camera
(53, 18, 'Exynos 1380'), -- Chip xử lý
(53, 19, 'Android 14'), -- Hệ điều hành
(53, 20, '6'), -- RAM (GB)
(53, 21, '128'), -- Bộ nhớ trong (GB)
(53, 22, '5G, Wi-Fi 5, Bluetooth 5.3'), -- Kết nối
(53, 23, '5000'), -- Dung lượng pin (mAh)
(53, 24, '25W Fast Charging'), -- Sạc
(53, 25, 'Awesome Lilac'), -- Màu sắc
(53, 26, '209'), -- Trọng lượng (g)
(53, 27, '2.3'), -- Tốc độ xử lý (GHz)

-- Samsung Galaxy Z Fold 6 (product_id=54, category_id=2)
(54, 15, '7.6-inch Dynamic AMOLED 2X'), -- Màn hình
(54, 16, '2160 x 1856'), -- Độ phân giải màn hình
(54, 17, '50MP + 12MP + 10MP'), -- Camera
(54, 18, 'Snapdragon 8 Gen 3'), -- Chip xử lý
(54, 19, 'Android 14'), -- Hệ điều hành
(54, 20, '12'), -- RAM (GB)
(54, 21, '512'), -- Bộ nhớ trong (GB)
(54, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(54, 23, '4400'), -- Dung lượng pin (mAh)
(54, 24, '25W Fast Charging'), -- Sạc
(54, 25, 'Phantom Black'), -- Màu sắc
(54, 26, '239'), -- Trọng lượng (g)
(54, 27, '3.4'), -- Tốc độ xử lý (GHz)

-- Xiaomi 14 Pro (product_id=55, category_id=2)
(55, 15, '6.73-inch LTPO AMOLED'), -- Màn hình
(55, 16, '1440 x 3200'), -- Độ phân giải màn hình
(55, 17, '50MP + 50MP + 50MP'), -- Camera
(55, 18, 'Snapdragon 8 Gen 3'), -- Chip xử lý
(55, 19, 'Android 14'), -- Hệ điều hành
(55, 20, '8'), -- RAM (GB)
(55, 21, '256'), -- Bộ nhớ trong (GB)
(55, 22, '5G, Wi-Fi 7, Bluetooth 5.4'), -- Kết nối
(55, 23, '4880'), -- Dung lượng pin (mAh)
(55, 24, '120W HyperCharge'), -- Sạc
(55, 25, 'Black'), -- Màu sắc
(55, 26, '223'), -- Trọng lượng (g)
(55, 27, '3.3'), -- Tốc độ xử lý (GHz)

-- Redmi Note 14 Pro+ (product_id=56, category_id=2)
(56, 15, '6.67-inch AMOLED'), -- Màn hình
(56, 16, '1220 x 2712'), -- Độ phân giải màn hình
(56, 17, '50MP + 8MP + 2MP'), -- Camera
(56, 18, 'Dimensity 7300 Ultra'), -- Chip xử lý
(56, 19, 'Android 14'), -- Hệ điều hành
(56, 20, '8'), -- RAM (GB)
(56, 21, '256'), -- Bộ nhớ trong (GB)
(56, 22, '5G, Wi-Fi 6, Bluetooth 5.4'), -- Kết nối
(56, 23, '6200'), -- Dung lượng pin (mAh)
(56, 24, '90W Fast Charging'), -- Sạc
(56, 25, 'Phantom Black'), -- Màu sắc
(56, 26, '210'), -- Trọng lượng (g)
(56, 27, '2.8'), -- Tốc độ xử lý (GHz)

-- Redmi A4 5G (product_id=57, category_id=2)
(57, 15, '6.67-inch IPS LCD'), -- Màn hình
(57, 16, '720 x 1600'), -- Độ phân giải màn hình
(57, 17, '13MP + 2MP'), -- Camera
(57, 18, 'Snapdragon 4s Gen 2'), -- Chip xử lý
(57, 19, 'Android 14'), -- Hệ điều hành
(57, 20, '4'), -- RAM (GB)
(57, 21, '64'), -- Bộ nhớ trong (GB)
(57, 22, '5G, Wi-Fi 5, Bluetooth 5.1'), -- Kết nối
(57, 23, '5000'), -- Dung lượng pin (mAh)
(57, 24, '18W Fast Charging'), -- Sạc
(57, 25, 'Midnight Black'), -- Màu sắc
(57, 26, '200'), -- Trọng lượng (g)
(57, 27, '2.0'), -- Tốc độ xử lý (GHz)

-- OPPO Find X7 Ultra (product_id=58, category_id=2)
(58, 15, '6.82-inch LTPO AMOLED'), -- Màn hình
(58, 16, '1440 x 3168'), -- Độ phân giải màn hình
(58, 17, '50MP + 50MP + 50MP + 50MP'), -- Camera
(58, 18, 'Snapdragon 8 Gen 3'), -- Chip xử lý
(58, 19, 'Android 14'), -- Hệ điều hành
(58, 20, '16'), -- RAM (GB)
(58, 21, '512'), -- Bộ nhớ trong (GB)
(58, 22, '5G, Wi-Fi 7, Bluetooth 5.4'), -- Kết nối
(58, 23, '5000'), -- Dung lượng pin (mAh)
(58, 24, '100W SuperVOOC'), -- Sạc
(58, 25, 'Ocean Blue'), -- Màu sắc
(58, 26, '221'), -- Trọng lượng (g)
(58, 27, '3.3'), -- Tốc độ xử lý (GHz)

-- OPPO Reno 11 Pro (product_id=59, category_id=2)
(59, 15, '6.74-inch AMOLED'), -- Màn hình
(59, 16, '1240 x 2772'), -- Độ phân giải màn hình
(59, 17, '50MP + 32MP + 8MP'), -- Camera
(59, 18, 'Dimensity 8200'), -- Chip xử lý
(59, 19, 'Android 14'), -- Hệ điều hành
(59, 20, '8'), -- RAM (GB)
(59, 21, '256'), -- Bộ nhớ trong (GB)
(59, 22, '5G, Wi-Fi 6, Bluetooth 5.3'), -- Kết nối
(59, 23, '4700'), -- Dung lượng pin (mAh)
(59, 24, '80W SuperVOOC'), -- Sạc
(59, 25, 'Pearl White'), -- Màu sắc
(59, 26, '190'), -- Trọng lượng (g)
(59, 27, '2.8'), -- Tốc độ xử lý (GHz)

-- OPPO A79 5G (product_id=60, category_id=2)
(60, 15, '6.72-inch IPS LCD'), -- Màn hình
(60, 16, '1080 x 2400'), -- Độ phân giải màn hình
(60, 17, '50MP + 2MP'), -- Camera
(60, 18, 'Dimensity 6020'), -- Chip xử lý
(60, 19, 'Android 13'), -- Hệ điều hành
(60, 20, '4'), -- RAM (GB)
(60, 21, '128'), -- Bộ nhớ trong (GB)
(60, 22, '5G, Wi-Fi 5, Bluetooth 5.3'), -- Kết nối
(60, 23, '5000'), -- Dung lượng pin (mAh)
(60, 24, '33W SuperVOOC'), -- Sạc
(60, 25, 'Mystery Black'), -- Màu sắc
(60, 26, '193'), -- Trọng lượng (g)
(60, 27, '2.2'), -- Tốc độ xử lý (GHz)

-- Vivo X100 Pro (product_id=61, category_id=2)
(61, 15, '6.78-inch LTPO AMOLED'), -- Màn hình
(61, 16, '1440 x 3200'), -- Độ phân giải màn hình
(61, 17, '50MP + 50MP + 64MP'), -- Camera
(61, 18, 'Dimensity 9300'), -- Chip xử lý
(61, 19, 'Android 14'), -- Hệ điều hành
(61, 20, '16'), -- RAM (GB)
(61, 21, '512'), -- Bộ nhớ trong (GB)
(61, 22, '5G, Wi-Fi 7, Bluetooth 5.4'), -- Kết nối
(61, 23, '5400'), -- Dung lượng pin (mAh)
(61, 24, '100W Fast Charging'), -- Sạc
(61, 25, 'Asteroid Black'), -- Màu sắc
(61, 26, '225'), -- Trọng lượng (g)
(61, 27, '3.2'), -- Tốc độ xử lý (GHz)

-- Vivo V30 Pro (product_id=62, category_id=2)
(62, 15, '6.78-inch AMOLED'), -- Màn hình
(62, 16, '1260 x 2800'), -- Độ phân giải màn hình
(62, 17, '50MP + 50MP + 50MP'), -- Camera
(62, 18, 'Snapdragon 7 Gen 3'), -- Chip xử lý
(62, 19, 'Android 14'), -- Hệ điều hành
(62, 20, '8'), -- RAM (GB)
(62, 21, '256'), -- Bộ nhớ trong (GB)
(62, 22, '5G, Wi-Fi 6, Bluetooth 5.3'), -- Kết nối
(62, 23, '5000'), -- Dung lượng pin (mAh)
(62, 24, '80W Fast Charging'), -- Sạc
(62, 25, 'Bloom White'), -- Màu sắc
(62, 26, '188'), -- Trọng lượng (g)
(62, 27, '2.7'), -- Tốc độ xử lý (GHz)

-- Vivo Y28s (product_id=63, category_id=2)
(63, 15, '6.56-inch IPS LCD'), -- Màn hình
(63, 16, '720 x 1612'), -- Độ phân giải màn hình
(63, 17, '50MP + 2MP'), -- Camera
(63, 18, 'Helio G85'), -- Chip xử lý
(63, 19, 'Android 14'), -- Hệ điều hành
(63, 20, '6'), -- RAM (GB)
(63, 21, '128'), -- Bộ nhớ trong (GB)
(63, 22, '5G, Wi-Fi 5, Bluetooth 5.0'), -- Kết nối
(63, 23, '5000'), -- Dung lượng pin (mAh)
(63, 24, '15W Fast Charging'), -- Sạc
(63, 25, 'Mocha Brown'), -- Màu sắc
(63, 26, '186'), -- Trọng lượng (g)
(63, 27, '2.0'), -- Tốc độ xử lý (GHz)

-- Realme GT 6 (product_id=64, category_id=2)
(64, 15, '6.78-inch LTPO AMOLED'), -- Màn hình
(64, 16, '1260 x 2780'), -- Độ phân giải màn hình
(64, 17, '50MP + 8MP + 2MP'), -- Camera
(64, 18, 'Snapdragon 8s Gen 3'), -- Chip xử lý
(64, 19, 'Android 14'), -- Hệ điều hành
(64, 20, '12'), -- RAM (GB)
(64, 21, '256'), -- Bộ nhớ trong (GB)
(64, 22, '5G, Wi-Fi 6, Bluetooth 5.3'), -- Kết nối
(64, 23, '5500'), -- Dung lượng pin (mAh)
(64, 24, '120W SuperCharge'), -- Sạc
(64, 25, 'Razor Green'), -- Màu sắc
(64, 26, '199'), -- Trọng lượng (g)
(64, 27, '3.0'), -- Tốc độ xử lý (GHz)

-- Realme Narzo 70 Pro (product_id=65, category_id=2)
(65, 15, '6.67-inch AMOLED'), -- Màn hình
(65, 16, '1080 x 2400'), -- Độ phân giải màn hình
(65, 17, '50MP + 8MP + 2MP'), -- Camera
(65, 18, 'Dimensity 7050'), -- Chip xử lý
(65, 19, 'Android 14'), -- Hệ điều hành
(65, 20, '8'), -- RAM (GB)
(65, 21, '128'), -- Bộ nhớ trong (GB)
(65, 22, '5G, Wi-Fi 5, Bluetooth 5.2'), -- Kết nối
(65, 23, '5000'), -- Dung lượng pin (mAh)
(65, 24, '67W Fast Charging'), -- Sạc
(65, 25, 'Glass Green'), -- Màu sắc
(65, 26, '195'), -- Trọng lượng (g)
(65, 27, '2.6'), -- Tốc độ xử lý (GHz)


-- Realme C65 (product_id=66, category_id=2)
(66, 15, '6.67-inch IPS LCD'), -- Màn hình
(66, 16, '720 x 1604'), -- Độ phân giải màn hình
(66, 17, '50MP + 2MP'), -- Camera
(66, 18, 'Helio G85'), -- Chip xử lý
(66, 19, 'Android 14'), -- Hệ điều hành
(66, 20, '6'), -- RAM (GB)
(66, 21, '128'), -- Bộ nhớ trong (GB)
(66, 22, '4G, Wi-Fi 5, Bluetooth 5.0'), -- Kết nối
(66, 23, '5000'), -- Dung lượng pin (mAh)
(66, 24, '45W Fast Charging'), -- Sạc
(66, 25, 'Starry Black'), -- Màu sắc
(66, 26, '185'), -- Trọng lượng (g)
(66, 27, '2.0'), -- Tốc độ xử lý (GHz)

-- Nokia X30 (product_id=67, category_id=2)
(67, 15, '6.43-inch AMOLED'), -- Màn hình
(67, 16, '1080 x 2400'), -- Độ phân giải màn hình
(67, 17, '50MP + 13MP'), -- Camera
(67, 18, 'Snapdragon 695'), -- Chip xử lý
(67, 19, 'Android 12'), -- Hệ điều hành
(67, 20, '6'), -- RAM (GB)
(67, 21, '128'), -- Bộ nhớ trong (GB)
(67, 22, '5G, Wi-Fi 5, Bluetooth 5.1'), -- Kết nối
(67, 23, '4200'), -- Dung lượng pin (mAh)
(67, 24, '33W Fast Charging'), -- Sạc
(67, 25, 'Cloudy Blue'), -- Màu sắc
(67, 26, '185'), -- Trọng lượng (g)
(67, 27, '2.2'), -- Tốc độ xử lý (GHz)

-- Nokia G42 (product_id=68, category_id=2)
(68, 15, '6.56-inch IPS LCD'), -- Màn hình
(68, 16, '720 x 1612'), -- Độ phân giải màn hình
(68, 17, '50MP + 2MP + 2MP'), -- Camera
(68, 18, 'Snapdragon 480+'), -- Chip xử lý
(68, 19, 'Android 13'), -- Hệ điều hành
(68, 20, '6'), -- RAM (GB)
(68, 21, '128'), -- Bộ nhớ trong (GB)
(68, 22, '5G, Wi-Fi 5, Bluetooth 5.1'), -- Kết nối
(68, 23, '5000'), -- Dung lượng pin (mAh)
(68, 24, '20W Fast Charging'), -- Sạc
(68, 25, 'So Grey'), -- Màu sắc
(68, 26, '193.8'), -- Trọng lượng (g)
(68, 27, '2.0'), -- Tốc độ xử lý (GHz)

-- Nokia C32 (product_id=69, category_id=2)
(69, 15, '6.5-inch IPS LCD'), -- Màn hình
(69, 16, '720 x 1600'), -- Độ phân giải màn hình
(69, 17, '50MP + 2MP'), -- Camera
(69, 18, 'Unisoc SC9863A'), -- Chip xử lý
(69, 19, 'Android 13'), -- Hệ điều hành
(69, 20, '4'), -- RAM (GB)
(69, 21, '64'), -- Bộ nhớ trong (GB)
(69, 22, '4G, Wi-Fi 4, Bluetooth 5.2'), -- Kết nối
(69, 23, '5000'), -- Dung lượng pin (mAh)
(69, 24, '10W Charging'), -- Sạc
(69, 25, 'Charcoal'), -- Màu sắc
(69, 26, '199.4'), -- Trọng lượng (g)
(69, 27, '1.6'), -- Tốc độ xử lý (GHz)

-- Corsair K100 RGB (product_id=70, category_id=5)
(70, 42, 'Full-size'), -- Key Layout
(70, 43, 'Corsair OPX'), -- Switch Type
(70, 44, 'Wired'), -- Connection Type
(70, 45, 'RGB'), -- Backlight
(70, 46, 'N/A'), -- Battery Life
(70, 47, '1350'), -- Weight (g)
(70, 48, '47.0 x 16.6 x 3.8 cm'), -- Dimensions

-- Corsair Scimitar Elite (product_id=71, category_id=3)
(71, 28, '18000'), -- DPI
(71, 29, 'Wired'), -- Connection Type
(71, 30, '17'), -- Buttons
(71, 31, 'Optical'), -- Sensor Type
(71, 32, '1024'), -- Polling Rate (Hz)
(71, 33, 'N/A'), -- Battery Life
(71, 34, '122'), -- Weight (g)

-- Corsair HS80 RGB Wireless (product_id=72, category_id=4)
(72, 35, '50'), -- Driver Size (mm)
(72, 36, 'Wireless'), -- Connection Type
(72, 37, 'TRUE'), -- Microphone
(72, 38, 'TRUE'), -- Noise Cancelling
(72, 39, '40 hours'), -- Battery Life
(72, 40, '20-20000'), -- Frequency Response (Hz)
(72, 41, '300'), -- Weight (g)

-- SteelSeries Apex Pro TKL (product_id=73, category_id=5)
(73, 42, 'TKL'), -- Key Layout
(73, 43, 'OmniPoint 2.0'), -- Switch Type
(73, 44, 'Wired'), -- Connection Type
(73, 45, 'RGB'), -- Backlight
(73, 46, 'N/A'), -- Battery Life
(73, 47, '960'), -- Weight (g)
(73, 48, '35.5 x 13.9 x 4.0 cm'), -- Dimensions

-- SteelSeries Aerox 5 Wireless (product_id=74, category_id=3)
(74, 28, '18000'), -- DPI
(74, 29, 'Wireless'), -- Connection Type
(74, 30, '9'), -- Buttons
(74, 31, 'Optical'), -- Sensor Type
(74, 32, '1024'), -- Polling Rate (Hz)
(74, 33, '180 hours'), -- Battery Life
(74, 34, '74'), -- Weight (g)

-- SteelSeries Arctis Nova Pro (product_id=75, category_id=4)
(75, 35, '40'), -- Driver Size (mm)
(75, 36, 'Wireless'), -- Connection Type
(75, 37, 'TRUE'), -- Microphone
(75, 38, 'TRUE'), -- Noise Cancelling
(75, 39, '44 hours'), -- Battery Life
(75, 40, '10-40000'), -- Frequency Response (Hz)
(75, 41, '337'), -- Weight (g)

-- Corsair Virtuoso RGB Wireless (product_id=76, category_id=4)
(76, 35, '50'), -- Driver Size (mm)
(76, 36, 'Wireless'), -- Connection Type
(76, 37, 'TRUE'), -- Microphone
(76, 38, 'TRUE'), -- Noise Cancelling
(76, 39, '60 hours'), -- Battery Life
(76, 40, '20-40000'), -- Frequency Response (Hz)
(76, 41, '360'), -- Weight (g)

-- Corsair K70 RGB TKL (product_id=77, category_id=5)
(77, 42, 'TKL'), -- Key Layout
(77, 43, 'Cherry MX Red'), -- Switch Type
(77, 44, 'Wired'), -- Connection Type
(77, 45, 'RGB'), -- Backlight
(77, 46, 'N/A'), -- Battery Life
(77, 47, '880'), -- Weight (g)
(77, 48, '36.0 x 16.4 x 3.8 cm'), -- Dimensions

-- Corsair Dark Core RGB Pro (product_id=78, category_id=3)
(78, 28, '18000'), -- DPI
(78, 29, 'Wireless'), -- Connection Type
(78, 30, '8'), -- Buttons
(78, 31, 'Optical'), -- Sensor Type
(78, 32, '2000'), -- Polling Rate (Hz)
(78, 33, '50 hours'), -- Battery Life
(78, 34, '142'), -- Weight (g)

-- SteelSeries Arctis 7+ (product_id=79, category_id=4)
(79, 35, '40'), -- Driver Size (mm)
(79, 36, 'Wireless'), -- Connection Type
(79, 37, 'TRUE'), -- Microphone
(79, 38, 'TRUE'), -- Noise Cancelling
(79, 39, '30 hours'), -- Battery Life
(79, 40, '20-20000'), -- Frequency Response (Hz)
(79, 41, '352'), -- Weight (g)

-- SteelSeries Apex 7 (product_id=80, category_id=5)
(80, 42, 'Full-size'), -- Key Layout
(80, 43, 'SteelSeries QX2 Red'), -- Switch Type
(80, 44, 'Wired'), -- Connection Type
(80, 45, 'RGB'), -- Backlight
(80, 46, 'N/A'), -- Battery Life
(80, 47, '953'), -- Weight (g)
(80, 48, '43.7 x 13.9 x 4.0 cm'), -- Dimensions

-- SteelSeries Rival 5 (product_id=81, category_id=3)
(81, 28, '18000'), -- DPI
(81, 29, 'Wired'), -- Connection Type
(81, 30, '9'), -- Buttons
(81, 31, 'Optical'), -- Sensor Type
(81, 32, '1024'), -- Polling Rate (Hz)
(81, 33, 'N/A'), -- Battery Life
(81, 34, '85'), -- Weight (g)

-- MSI Vigor GK71 Sonic (product_id=82, category_id=5)
(82, 42, 'Full-size'), -- Key Layout
(82, 43, 'MSI Sonic Red'), -- Switch Type
(82, 44, 'Wired'), -- Connection Type
(82, 45, 'RGB'), -- Backlight
(82, 46, 'N/A'), -- Battery Life
(82, 47, '854'), -- Weight (g)
(82, 48, '44.2 x 13.8 x 3.8 cm'), -- Dimensions

-- MSI Clutch GM41 Lightweight (product_id=83, category_id=3)
(83, 28, '16000'), -- DPI
(83, 29, 'Wired'), -- Connection Type
(83, 30, '6'), -- Buttons
(83, 31, 'Optical'), -- Sensor Type
(83, 32, '1024'), -- Polling Rate (Hz)
(83, 33, 'N/A'), -- Battery Life
(83, 34, '65'), -- Weight (g)

-- Gigabyte AORUS K9 Optical (product_id=84, category_id=5)
(84, 42, 'Full-size'), -- Key Layout
(84, 43, 'Flaretech Optical'), -- Switch Type
(84, 44, 'Wired'), -- Connection Type
(84, 45, 'RGB'), -- Backlight
(84, 46, 'N/A'), -- Battery Life
(84, 47, '1120'), -- Weight (g)
(84, 48, '44.0 x 15.0 x 4.0 cm'), -- Dimensions

-- Gigabyte AORUS M5 (product_id=85, category_id=3)
(85, 28, '16000'), -- DPI
(85, 29, 'Wired'), -- Connection Type
(85, 30, '7'), -- Buttons
(85, 31, 'Optical'), -- Sensor Type
(85, 32, '1024'), -- Polling Rate (Hz)
(85, 33, 'N/A'), -- Battery Life
(85, 34, '118'), -- Weight (g)

-- Xiaomi Buds 5 (product_id=86, category_id=4)
(86, 35, '11'), -- Driver Size (mm)
(86, 36, 'Bluetooth'), -- Connection Type
(86, 37, 'TRUE'), -- Microphone
(86, 38, 'TRUE'), -- Noise Cancelling
(86, 39, '40 hours'), -- Battery Life
(86, 40, '20-40000'), -- Frequency Response (Hz)
(86, 41, '52'), -- Weight (g)

-- Redmi Buds 6 Active (product_id=87, category_id=4)
(87, 35, '10'), -- Driver Size (mm)
(87, 36, 'Bluetooth'), -- Connection Type
(87, 37, 'TRUE'), -- Microphone
(87, 38, 'FALSE'), -- Noise Cancelling
(87, 39, '30 hours'), -- Battery Life
(87, 40, '20-20000'), -- Frequency Response (Hz)
(87, 41, '48'), -- Weight (g)

-- OPPO Enco X3 (product_id=88, category_id=4)
(88, 35, '11'), -- Driver Size (mm)
(88, 36, 'Bluetooth'), -- Connection Type
(88, 37, 'TRUE'), -- Microphone
(88, 38, 'TRUE'), -- Noise Cancelling
(88, 39, '44 hours'), -- Battery Life
(88, 40, '20-40000'), -- Frequency Response (Hz)
(88, 41, '54'), -- Weight (g)

-- OPPO Enco Air 4 (product_id=89, category_id=4)
(89, 35, '10'), -- Driver Size (mm)
(89, 36, 'Bluetooth'), -- Connection Type
(89, 37, 'TRUE'), -- Microphone
(89, 38, 'TRUE'), -- Noise Cancelling
(89, 39, '30 hours'), -- Battery Life
(89, 40, '20-20000'), -- Frequency Response (Hz)
(89, 41, '50'), -- Weight (g)

-- Vivo TWS 4 (product_id=90, category_id=4)
(90, 35, '11'), -- Driver Size (mm)
(90, 36, 'Bluetooth'), -- Connection Type
(90, 37, 'TRUE'), -- Microphone
(90, 38, 'TRUE'), -- Noise Cancelling
(90, 39, '45 hours'), -- Battery Life
(90, 40, '20-40000'), -- Frequency Response (Hz)
(90, 41, '53'), -- Weight (g)

-- Vivo TWS Air 2 (product_id=91, category_id=4)
(91, 35, '10'), -- Driver Size (mm)
(91, 36, 'Bluetooth'), -- Connection Type
(91, 37, 'TRUE'), -- Microphone
(91, 38, 'FALSE'), -- Noise Cancelling
(91, 39, '25 hours'), -- Battery Life
(91, 40, '20-20000'), -- Frequency Response (Hz)
(91, 41, '49'), -- Weight (g)

-- Realme Buds Air 6 Pro (product_id=92, category_id=4)
(92, 35, '11'), -- Driver Size (mm)
(92, 36, 'Bluetooth'), -- Connection Type
(92, 37, 'TRUE'), -- Microphone
(92, 38, 'TRUE'), -- Noise Cancelling
(92, 39, '40 hours'), -- Battery Life
(92, 40, '20-40000'), -- Frequency Response (Hz)
(92, 41, '52'), -- Weight (g)

-- Realme Buds T300 (product_id=93, category_id=4)
(93, 35, '10'), -- Driver Size (mm)
(93, 36, 'Bluetooth'), -- Connection Type
(93, 37, 'TRUE'), -- Microphone
(93, 38, 'FALSE'), -- Noise Cancelling
(93, 39, '30 hours'), -- Battery Life
(93, 40, '20-20000'), -- Frequency Response (Hz)
(93, 41, '48'), -- Weight (g)

-- Nokia Clarity Earbuds 2 Pro (product_id=94, category_id=4)
(94, 35, '10'), -- Driver Size (mm)
(94, 36, 'Bluetooth'), -- Connection Type
(94, 37, 'TRUE'), -- Microphone
(94, 38, 'TRUE'), -- Noise Cancelling
(94, 39, '35 hours'), -- Battery Life
(94, 40, '20-20000'), -- Frequency Response (Hz)
(94, 41, '50'), -- Weight (g)

-- Nokia Go Earbuds+ (product_id=95, category_id=4)
(95, 35, '10'), -- Driver Size (mm)
(95, 36, 'Bluetooth'), -- Connection Type
(95, 37, 'TRUE'), -- Microphone
(95, 38, 'FALSE'), -- Noise Cancelling
(95, 39, '20 hours'), -- Battery Life
(95, 40, '20-20000'), -- Frequency Response (Hz)
(95, 41, '46'), -- Weight (g)

-- MacBook Air 13-inch M4 2025 (product_id=96, category_id=1)
(96, 1, 'Apple M4'), -- CPU
(96, 2, '16'), -- RAM (GB)
(96, 3, '256'), -- Storage (GB)
(96, 4, 'Apple 10-core GPU'), -- GPU
(96, 5, '13.6-inch Liquid Retina, 2560x1664'), -- Màn hình
(96, 6, 'macOS Sequoia'), -- Hệ điều hành
(96, 7, 'MagSafe, 2 Thunderbolt 4'), -- Cổng kết nối
(96, 8, 'Backlit Magic Keyboard'), -- Bàn phím
(96, 9, '12MP Center Stage'), -- Webcam
(96, 10, 'Wi-Fi 6E'), -- Wi-Fi
(96, 11, 'Bluetooth 5.3'), -- Bluetooth
(96, 12, '52.6'), -- Pin (Wh)
(96, 13, '1.24'), -- Trọng lượng (kg)
(96, 14, '30.41 x 21.5 x 1.13 cm'), -- Kích thước

-- MacBook Pro 14-inch M4 Pro 2024 (product_id=97, category_id=1)
(97, 1, 'Apple M4 Pro'), -- CPU
(97, 2, '24'), -- RAM (GB)
(97, 3, '512'), -- Storage (GB)
(97, 4, 'Apple 16-core GPU'), -- GPU
(97, 5, '14.2-inch Liquid Retina XDR, 3024x1964'), -- Màn hình
(97, 6, 'macOS Sequoia'), -- Hệ điều hành
(97, 7, 'MagSafe, 3 Thunderbolt 4, HDMI, SDXC'), -- Cổng kết nối
(97, 8, 'Backlit Magic Keyboard'), -- Bàn phím
(97, 9, '12MP Center Stage'), -- Webcam
(97, 10, 'Wi-Fi 6E'), -- Wi-Fi
(97, 11, 'Bluetooth 5.3'), -- Bluetooth
(97, 12, '70.0'), -- Pin (Wh)
(97, 13, '1.55'), -- Trọng lượng (kg)
(97, 14, '31.26 x 22.12 x 1.55 cm'), -- Kích thước

-- MacBook Air 15-inch M4 2025 (product_id=98, category_id=1)
(98, 1, 'Apple M4'), -- CPU
(98, 2, '16'), -- RAM (GB)
(98, 3, '512'), -- Storage (GB)
(98, 4, 'Apple 10-core GPU'), -- GPU
(98, 5, '15.3-inch Liquid Retina, 2880x1864'), -- Màn hình
(98, 6, 'macOS Sequoia'), -- Hệ điều hành
(98, 7, 'MagSafe, 2 Thunderbolt 4'), -- C港口 kết nối
(98, 8, 'Backlit Magic Keyboard'), -- Bàn phím
(98, 9, '12MP Center Stage'), -- Webcam
(98, 10, 'Wi-Fi 6E'), -- Wi-Fi
(98, 11, 'Bluetooth 5.3'), -- Bluetooth
(98, 12, '66.5'), -- Pin (Wh)
(98, 13, '1.51'), -- Trọng lượng (kg)
(98, 14, '34.04 x 23.76 x 1.15 cm'), -- Kích thước

-- iPhone 16 (product_id=99, category_id=2)
(99, 15, '6.1-inch Super Retina XDR'), -- Màn hình
(99, 16, '2556 x 1179'), -- Độ phân giải màn hình
(99, 17, '48MP + 12MP'), -- Camera
(99, 18, 'A18'), -- Chip xử lý
(99, 19, 'iOS 18'), -- Hệ điều hành
(99, 20, '6'), -- RAM (GB)
(99, 21, '128'), -- Bộ nhớ trong (GB)
(99, 22, '5G, Wi-Fi 6, Bluetooth 5.3'), -- Kết nối
(99, 23, '3561'), -- Dung lượng pin (mAh)
(99, 24, '35W Fast Charging'), -- Sạc
(99, 25, 'Black Titanium'), -- Màu sắc
(99, 26, '170'), -- Trọng lượng (g)
(99, 27, '3.8'), -- Tốc độ xử lý (GHz)

-- iPhone 16 Plus (product_id=100, category_id=2)
(100, 15, '6.7-inch Super Retina XDR'), -- Màn hình
(100, 16, '2796 x 1290'), -- Độ phân giải màn hình
(100, 17, '48MP + 12MP'), -- Camera
(100, 18, 'A18'), -- Chip xử lý
(100, 19, 'iOS 18'), -- Hệ điều hành
(100, 20, '6'), -- RAM (GB)
(100, 21, '128'), -- Bộ nhớ trong (GB)
(100, 22, '5G, Wi-Fi 6, Bluetooth 5.3'), -- Kết nối
(100, 23, '4674'), -- Dung lượng pin (mAh)
(100, 24, '35W Fast Charging'), -- Sạc
(100, 25, 'Ultramarine'), -- Màu sắc
(100, 26, '199'), -- Trọng lượng (g)
(100, 27, '3.8'); -- Tốc độ xử lý (GHz)

INSERT INTO ProductDetail (product_id, attribute_id, attribute_value)
VALUES
-- iPhone 16 Pro (product_id=101, category_id=2)
(101, 15, '6.3-inch Super Retina XDR'), -- Màn hình
(101, 16, '2622 x 1206'), -- Độ phân giải màn hình
(101, 17, '48MP + 48MP + 12MP'), -- Camera
(101, 18, 'A18 Pro'), -- Chip xử lý
(101, 19, 'iOS 18'), -- Hệ điều hành
(101, 20, '8'), -- RAM (GB)
(101, 21, '256'), -- Bộ nhớ trong (GB)
(101, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(101, 23, '3559'), -- Dung lượng pin (mAh)
(101, 24, '45W Fast Charging'), -- Sạc
(101, 25, 'Desert Titanium'), -- Màu sắc
(101, 26, '199'), -- Trọng lượng (g)
(101, 27, '4.0'), -- Tốc độ xử lý (GHz)

-- iPhone 16 Pro Max (product_id=102, category_id=2)
(102, 15, '6.9-inch Super Retina XDR'), -- Màn hình
(102, 16, '2868 x 1320'), -- Độ phân giải màn hình
(102, 17, '48MP + 48MP + 12MP'), -- Camera
(102, 18, 'A18 Pro'), -- Chip xử lý
(102, 19, 'iOS 18'), -- Hệ điều hành
(102, 20, '8'), -- RAM (GB)
(102, 21, '256'), -- Bộ nhớ trong (GB)
(102, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(102, 23, '4680'), -- Dung lượng pin (mAh)
(102, 24, '45W Fast Charging'), -- Sạc
(102, 25, 'White Titanium'), -- Màu sắc
(102, 26, '227'), -- Trọng lượng (g)
(102, 27, '4.0'), -- Tốc độ xử lý (GHz)

-- iPhone 17 (product_id=103, category_id=2)
(103, 15, '6.1-inch Super Retina XDR'), -- Màn hình
(103, 16, '2556 x 1179'), -- Độ phân giải màn hình
(103, 17, '50MP + 12MP'), -- Camera
(103, 18, 'A19'), -- Chip xử lý
(103, 19, 'iOS 19'), -- Hệ điều hành
(103, 20, '6'), -- RAM (GB)
(103, 21, '128'), -- Bộ nhớ trong (GB)
(103, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(103, 23, '3600'), -- Dung lượng pin (mAh)
(103, 24, '40W Fast Charging'), -- Sạc
(103, 25, 'Midnight Blue'), -- Màu sắc
(103, 26, '170'), -- Trọng lượng (g)
(103, 27, '4.1'), -- Tốc độ xử lý (GHz)

-- iPhone 17 Plus (product_id=104, category_id=2)
(104, 15, '6.7-inch Super Retina XDR'), -- Màn hình
(104, 16, '2796 x 1290'), -- Độ phân giải màn hình
(104, 17, '50MP + 12MP'), -- Camera
(104, 18, 'A19'), -- Chip xử lý
(104, 19, 'iOS 19'), -- Hệ điều hành
(104, 20, '6'), -- RAM (GB)
(104, 21, '128'), -- Bộ nhớ trong (GB)
(104, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(104, 23, '4750'), -- Dung lượng pin (mAh)
(104, 24, '40W Fast Charging'), -- Sạc
(104, 25, 'Starlight Gold'), -- Màu sắc
(104, 26, '199'), -- Trọng lượng (g)
(104, 27, '4.1'), -- Tốc độ xử lý (GHz)

-- iPhone 17 Pro (product_id=105, category_id=2)
(105, 15, '6.3-inch Super Retina XDR'), -- Màn hình
(105, 16, '2622 x 1206'), -- Độ phân giải màn hình
(105, 17, '50MP + 50MP + 12MP'), -- Camera
(105, 18, 'A19 Pro'), -- Chip xử lý
(105, 19, 'iOS 19'), -- Hệ điều hành
(105, 20, '8'), -- RAM (GB)
(105, 21, '256'), -- Bộ nhớ trong (GB)
(105, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(105, 23, '3650'), -- Dung lượng pin (mAh)
(105, 24, '50W Fast Charging'), -- Sạc
(105, 25, 'Black Titanium'), -- Màu sắc
(105, 26, '199'), -- Trọng lượng (g)
(105, 27, '4.3'), -- Tốc độ xử lý (GHz)

-- iPhone 17 Pro Max (product_id=106, category_id=2)
(106, 15, '6.9-inch Super Retina XDR'), -- Màn hình
(106, 16, '2868 x 1320'), -- Độ phân giải màn hình
(106, 17, '50MP + 50MP + 12MP'), -- Camera
(106, 18, 'A19 Pro'), -- Chip xử lý
(106, 19, 'iOS 19'), -- Hệ điều hành
(106, 20, '8'), -- RAM (GB)
(106, 21, '256'), -- Bộ nhớ trong (GB)
(106, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(106, 23, '4800'), -- Dung lượng pin (mAh)
(106, 24, '50W Fast Charging'), -- Sạc
(106, 25, 'Silver Titanium'), -- Màu sắc
(106, 26, '227'), -- Trọng lượng (g)
(106, 27, '4.3'), -- Tốc độ xử lý (GHz)

-- iPhone 16e (product_id=107, category_id=2)
(107, 15, '6.1-inch Super Retina XDR'), -- Màn hình
(107, 16, '2556 x 1179'), -- Độ phân giải màn hình
(107, 17, '48MP'), -- Camera
(107, 18, 'A18'), -- Chip xử lý
(107, 19, 'iOS 18'), -- Hệ điều hành
(107, 20, '6'), -- RAM (GB)
(107, 21, '64'), -- Bộ nhớ trong (GB)
(107, 22, '5G, Wi-Fi 6, Bluetooth 5.0'), -- Kết nối
(107, 23, '3500'), -- Dung lượng pin (mAh)
(107, 24, '30W Fast Charging'), -- Sạc
(107, 25, 'Space Gray'), -- Màu sắc
(107, 26, '165'), -- Trọng lượng (g)
(107, 27, '3.8'), -- Tốc độ xử lý (GHz)

-- iPhone 17 Air (product_id=108, category_id=2)
(108, 15, '6.3-inch Super Retina XDR'), -- Màn hình
(108, 16, '2622 x 1206'), -- Độ phân giải màn hình
(108, 17, '50MP + 12MP'), -- Camera
(108, 18, 'A19'), -- Chip xử lý
(108, 19, 'iOS 19'), -- Hệ điều hành
(108, 20, '6'), -- RAM (GB)
(108, 21, '128'), -- Bộ nhớ trong (GB)
(108, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(108, 23, '3700'), -- Dung lượng pin (mAh)
(108, 24, '40W Fast Charging'), -- Sạc
(108, 25, 'White Starlight'), -- Màu sắc
(108, 26, '185'), -- Trọng lượng (g)
(108, 27, '4.1'), -- Tốc độ xử lý (GHz)

-- iPhone 16 Mini (product_id=109, category_id=2)
(109, 15, '5.4-inch Super Retina XDR'), -- Màn hình
(109, 16, '2340 x 1080'), -- Độ phân giải màn hình
(109, 17, '48MP + 12MP'), -- Camera
(109, 18, 'A18'), -- Chip xử lý
(109, 19, 'iOS 18'), -- Hệ điều hành
(109, 20, '6'), -- RAM (GB)
(109, 21, '128'), -- Bộ nhớ trong (GB)
(109, 22, '5G, Wi-Fi 6, Bluetooth 5.3'), -- Kết nối
(109, 23, '2400'), -- Dung lượng pin (mAh)
(109, 24, '30W Fast Charging'), -- Sạc
(109, 25, 'Pink'), -- Màu sắc
(109, 26, '141'), -- Trọng lượng (g)
(109, 27, '3.8'), -- Tốc độ xử lý (GHz)

-- iPhone 17 Slim (product_id=110, category_id=2)
(110, 15, '6.4-inch Super Retina XDR'), -- Màn hình
(110, 16, '2622 x 1206'), -- Độ phân giải màn hình
(110, 17, '50MP + 12MP'), -- Camera
(110, 18, 'A19'), -- Chip xử lý
(110, 19, 'iOS 19'), -- Hệ điều hành
(110, 20, '6'), -- RAM (GB)
(110, 21, '256'), -- Bộ nhớ trong (GB)
(110, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(110, 23, '3800'), -- Dung lượng pin (mAh)
(110, 24, '45W Fast Charging'), -- Sạc
(110, 25, 'Graphite'), -- Màu sắc
(110, 26, '180'), -- Trọng lượng (g)
(110, 27, '4.1'), -- Tốc độ xử lý (GHz)

-- Samsung Galaxy S25 (product_id=111, category_id=2)
(111, 15, '6.2-inch Dynamic AMOLED 2X'), -- Màn hình
(111, 16, '2400 x 1080'), -- Độ phân giải màn hình
(111, 17, '50MP + 10MP + 12MP'), -- Camera
(111, 18, 'Snapdragon 8 Gen 4'), -- Chip xử lý
(111, 19, 'Android 15'), -- Hệ điều hành
(111, 20, '8'), -- RAM (GB)
(111, 21, '128'), -- Bộ nhớ trong (GB)
(111, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(111, 23, '4000'), -- Dung lượng pin (mAh)
(111, 24, '45W Fast Charging'), -- Sạc
(111, 25, 'Phantom Black'), -- Màu sắc
(111, 26, '185'), -- Trọng lượng (g)
(111, 27, '3.7'), -- Tốc độ xử lý (GHz)

-- Samsung Galaxy S25 Plus (product_id=112, category_id=2)
(112, 15, '6.7-inch Dynamic AMOLED 2X'), -- Màn hình
(112, 16, '3120 x 1440'), -- Độ phân giải màn hình
(112, 17, '50MP + 10MP + 12MP'), -- Camera
(112, 18, 'Snapdragon 8 Gen 4'), -- Chip xử lý
(112, 19, 'Android 15'), -- Hệ điều hành
(112, 20, '12'), -- RAM (GB)
(112, 21, '256'), -- Bộ nhớ trong (GB)
(112, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(112, 23, '4900'), -- Dung lượng pin (mAh)
(112, 24, '45W Fast Charging'), -- Sạc
(112, 25, 'Cream White'), -- Màu sắc
(112, 26, '196'), -- Trọng lượng (g)
(112, 27, '3.7'), -- Tốc độ xử lý (GHz)

-- Samsung Galaxy S25 Ultra (product_id=113, category_id=2)
(113, 15, '6.8-inch Dynamic AMOLED 2X'), -- Màn hình
(113, 16, '3120 x 1440'), -- Độ phân giải màn hình
(113, 17, '200MP + 50MP + 12MP'), -- Camera
(113, 18, 'Snapdragon 8 Gen 4'), -- Chip xử lý
(113, 19, 'Android 15'), -- Hệ điều hành
(113, 20, '12'), -- RAM (GB)
(113, 21, '512'), -- Bộ nhớ trong (GB)
(113, 22, '5G, Wi-Fi 7, Bluetooth 5.3'), -- Kết nối
(113, 23, '5000'), -- Dung lượng pin (mAh)
(113, 24, '45W Fast Charging'), -- Sạc
(113, 25, 'Titanium Gray'), -- Màu sắc
(113, 26, '228'), -- Trọng lượng (g)
(113, 27, '3.8'), -- Tốc độ xử lý (GHz)

-- Samsung Galaxy Z Fold 7 (product_id=114, category_id=2)
(114, 15, '7.6-inch Dynamic AMOLED 2X'), -- Màn hình
(114, 16, '2160 x 1856'), -- Độ phân giải màn hình
(114, 17, '50MP + 10MP + 12MP'), -- Camera
(114, 18, 'Snapdragon 8 Gen 4'), -- Chip xử lý
(114, 19, 'Android 15'), -- Hệ điều hành
(114, 20, '12'), -- RAM (GB)
(114, 21, '256'), -- Bộ nhớ trong (GB)
(114, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(114, 23, '4400'), -- Dung lượng pin (mAh)
(114, 24, '25W Fast Charging'), -- Sạc
(114, 25, 'Silver Shadow'), -- Màu sắc
(114, 26, '253'), -- Trọng lượng (g)
(114, 27, '3.7'), -- Tốc độ xử lý (GHz)

-- Samsung Galaxy Z Flip 7 (product_id=115, category_id=2)
(115, 15, '6.7-inch Dynamic AMOLED 2X'), -- Màn hình
(115, 16, '2400 x 1080'), -- Độ phân giải
(115, 17, '50MP + 12MP'), -- Camera
(115, 18, 'Snapdragon 8 Gen 4'), -- Chip xử lý
(115, 19, 'Android 15'), -- Hệ điều hành
(115, 20, '8'), -- RAM (GB)
(115, 21, '256'), -- Bộ nhớ trong (GB)
(115, 22, '5G, Wi-Fi 6E, Bluetooth 5.3'), -- Kết nối
(115, 23, '3700'), -- Dung lượng pin (mAh)
(115, 24, '25W Fast Charging'), -- Sạc
(115, 25, 'Mint Green'), -- Màu sắc
(115, 26, '183'), -- Trọng lượng (g)
(115, 27, '3.7'), -- Tốc độ xử lý (GHz)

-- Samsung Galaxy A56 (product_id=116, category_id=2)
(116, 15, '6.6-inch Super AMOLED'), -- Màn hình
(116, 16, '2400 x 1080'), -- Độ phân giải
(116, 17, '50MP + 8MP + 5MP'), -- Camera
(116, 18, 'Exynos 1280'), -- Chip xử lý
(116, 19, 'Android 15'), -- Hệ điều hành
(116, 20, '6'), -- RAM (GB)
(116, 21, '128'), -- Bộ nhớ trong (GB)
(116, 22, '5G, Wi-Fi 6, Bluetooth 5.2'), -- Kết nối
(116, 23, '5000'), -- Dung lượng pin (mAh)
(116, 24, '25W Fast Charging'), -- Sạc
(116, 25, 'Awesome Black'), -- Màu sắc
(116, 26, '189'), -- Trọng lượng (g)
(116, 27, '2.8'), -- Tốc độ xử lý (GHz)

-- Samsung Galaxy A36 (product_id=117, category_id=2)
(117, 15, '6.5-inch Super AMOLED'), -- Màn hình
(117, 16, '2400 x 1080'), -- Độ phân giải
(117, 17, '48MP + 8MP + 2MP'), -- Camera
(117, 18, 'Exynos 1380'), -- Chip xử lý
(117, 19, 'Android 15'), -- Hệ điều hành
(117, 20, '6'), -- RAM (GB)
(117, 21, '128'), -- Bộ nhớ trong (GB)
(117, 22, '5G, Wi-Fi 5, Bluetooth 5.2'), -- Kết nối
(117, 23, '5000'), -- Dung lượng pin (mAh)
(117, 24, '25W Fast Charging'), -- Sạc
(117, 25, 'Awesome Blue'), -- Màu sắc
(117, 26, '192'), -- Trọng lượng (g)
(117, 27, '2.6'), -- Tốc độ xử lý (GHz)

-- Samsung Galaxy M55 (product_id=118, category_id=2)
(118, 15, '6.7-inch Super AMOLED'), -- Màn hình
(118, 16, '2400 x 1080'), -- Độ phân giải
(118, 17, '50MP + 8MP + 2MP'), -- Camera
(118, 18, 'Snapdragon 7 Gen 1'), -- Chip xử lý
(118, 19, 'Android 15'), -- Hệ điều hành
(118, 20, '8'), -- RAM (GB)
(118, 21, '128'), -- Bộ nhớ trong (GB)
(118, 22, '5G, Wi-Fi 5, Bluetooth 5.2'), -- Kết nối
(118, 23, '5000'), -- Dung lượng pin (mAh)
(118, 24, '45W Fast Charging'), -- Sạc
(118, 25, 'Light Green'), -- Màu sắc
(118, 26, '180'), -- Trọng lượng (g)
(118, 27, '2.8'), -- Tốc độ xử lý (GHz)

-- Samsung Galaxy S25 FE (product_id=119, category_id=2)
(119, 15, '6.6-inch Dynamic AMOLED 2X'), -- Màn hình
(119, 16, '2400 x 1080'), -- Độ phân giải
(119, 17, '50MP + 12MP + 8MP'), -- Camera
(119, 18, 'Exynos 2300'), -- Chip xử lý
(119, 19, 'Android 15'), -- Hệ điều hành
(119, 20, '8'), -- RAM (GB)
(119, 21, '128'), -- Bộ nhớ trong (GB)
(119, 22, '5G, Wi-Fi 6, Bluetooth 5.3'), -- Kết nối
(119, 23, '4600'), -- Dung lượng pin (mAh)
(119, 24, '45W Fast Charging'), -- Sạc
(119, 25, 'Graphite'), -- Màu sắc
(119, 26, '190'), -- Trọng lượng (g)
(119, 27, '3.0'), -- Tốc độ xử lý (GHz)

-- DELL XPS 15 2024 (product_id=120, category_id=1)
(120, 1, 'Intel Core Ultra 7 155H'), -- CPU
(120, 2, '16'), -- RAM (GB)
(120, 3, '512'), -- Storage (GB)
(120, 4, 'NVIDIA GeForce RTX 4050'), -- GPU
(120, 5, '14.5-inch OLED, 3200x2000'), -- Màn hình
(120, 6, 'Windows 11 Pro'), -- Hệ điều hành
(120, 7, '3 Thunderbolt 4, 3.5mm jack'), -- Cổng kết nối
(120, 8, 'Backlit Keyboard'), -- Bàn phím
(120, 9, '1080p'), -- Webcam
(120, 10, 'Wi-Fi 6E'), -- Wi-Fi
(120, 11, 'Bluetooth 5.3'), -- Bluetooth
(120, 12, '69.5'), -- Pin (Wh)
(120, 13, '1.68'), -- Trọng lượng (kg)
(120, 14, '32.0 x 21.6 x 1.8 cm'), -- Kích thước

-- DELL XPS 17 2025 (product_id=121, category_id=1)
(121, 1, 'Intel Core Ultra 9 185H'), -- CPU
(121, 2, '32'), -- RAM (GB)
(121, 3, '1024'), -- Storage (GB)
(121, 4, 'NVIDIA GeForce RTX 4070'), -- GPU
(121, 5, '16.3-inch OLED, 3840x2400'), -- Màn hình
(121, 6, 'Windows 11 Pro'), -- Hệ điều hành
(121, 7, '3 Thunderbolt 4, 3.5mm jack'), -- Cổng kết nối
(121, 8, 'Backlit Keyboard'), -- Bàn phím
(121, 9, '1080p'), -- Webcam
(121, 10, 'Wi-Fi 6E'), -- Wi-Fi
(121, 11, 'Bluetooth 5.3'), -- Bluetooth
(121, 12, '99.5'), -- Pin (Wh)
(121, 13, '2.1'), -- Trọng lượng (kg)
(121, 14, '35.8 x 24.0 x 1.9 cm'), -- Kích thước

-- DELL Inspiron 13 Plus 2024 (product_id=122, category_id=1)
(122, 1, 'Snapdragon X Plus'), -- CPU
(122, 2, '16'), -- RAM (GB)
(122, 3, '512'), -- Storage (GB)
(122, 4, 'Adreno GPU'), -- GPU
(122, 5, '14.0-inch QHD+, 2560x1600'), -- Màn hình
(122, 6, 'Windows 11 Home'), -- Hệ điều hành
(122, 7, '2 USB-C, 1 USB-A, 3.5mm jack'), -- Cổng kết nối
(122, 8, 'Backlit Keyboard'), -- Bàn phím
(122, 9, '1080p'), -- Webcam
(122, 10, 'Wi-Fi 7'), -- Wi-Fi
(122, 11, 'Bluetooth 5.4'), -- Bluetooth
(122, 12, '54'), -- Pin (Wh)
(122, 13, '1.4'), -- Trọng lượng (kg)
(122, 14, '31.4 x 22.3 x 1.7 cm'), -- Kích thước

-- DELL Latitude 7455 2024 (product_id=123, category_id=1)
(123, 1, 'Intel Core Ultra 5 125U'), -- CPU
(123, 2, '16'), -- RAM (GB)
(123, 3, '512'), -- Storage (GB)
(123, 4, 'Intel Graphics'), -- GPU
(123, 5, '14.0-inch FHD+, 1920x1200'), -- Màn hình
(123, 6, 'Windows 11 Pro'), -- Hệ điều hành
(123, 7, '2 Thunderbolt 4, 2 USB-A, HDMI'), -- Cổng kết nối
(123, 8, 'Backlit Keyboard'), -- Bàn phím
(123, 9, '1080p'), -- Webcam
(123, 10, 'Wi-Fi 6E'), -- Wi-Fi
(123, 11, 'Bluetooth 5.3'), -- Bluetooth
(123, 12, '54'), -- Pin (Wh)
(123, 13, '1.5'), -- Trọng lượng (kg)
(123, 14, '31.0 x 22.0 x 1.8 cm'), -- Kích thước

-- ASUS Zenbook S 15 2024 (product_id=124, category_id=1)
(124, 1, 'Intel Core Ultra 7 258V'), -- CPU
(124, 2, '16'), -- RAM (GB)
(124, 3, '512'), -- Storage (GB)
(124, 4, 'Intel Arc Graphics'), -- GPU
(124, 5, '14.0-inch OLED, 2880x1800'), -- Màn hình
(124, 6, 'Windows 11 Home'), -- Hệ điều hành
(124, 7, '2 Thunderbolt 4, 1 USB-A, HDMI'), -- Cổng kết nối
(124, 8, 'Backlit Keyboard'), -- Bàn phím
(124, 9, '1080p'), -- Webcam
(124, 10, 'Wi-Fi 7'), -- Wi-Fi
(124, 11, 'Bluetooth 5.4'), -- Bluetooth
(124, 12, '70'), -- Pin (Wh)
(124, 13, '1.2'), -- Trọng lượng (kg)
(124, 14, '31.2 x 21.4 x 1.1 cm'), -- Kích thước

-- ASUS ROG Zephyrus G17 2024 (product_id=125, category_id=1)
(125, 1, 'AMD Ryzen AI 9 HX 370'), -- CPU
(125, 2, '32'), -- RAM (GB)
(125, 3, '1024'), -- Storage (GB)
(125, 4, 'NVIDIA GeForce RTX 4070'), -- GPU
(125, 5, '16.0-inch OLED, 2560x1600'), -- Màn hình
(125, 6, 'Windows 11 Pro'), -- Hệ điều hành
(125, 7, '2 USB-C, 2 USB-A, HDMI, SD'), -- Cổng kết nối
(125, 8, 'RGB Backlit Keyboard'), -- Bàn phím
(125, 9, '1080p'), -- Webcam
(125, 10, 'Wi-Fi 6E'), -- Wi-Fi
(125, 11, 'Bluetooth 5.3'), -- Bluetooth
(125, 12, '90'), -- Pin (Wh)
(125, 13, '1.85'), -- Trọng lượng (kg)
(125, 14, '35.5 x 24.3 x 1.7 cm'), -- Kích thước

-- ASUS Vivobook 17 2024 (product_id=126, category_id=1)
(126, 1, 'AMD Ryzen 7 7735HS'), -- CPU
(126, 2, '16'), -- RAM (GB)
(126, 3, '512') , -- Storage (GB)
(126, 4, 'AMD Radeon Graphics'), -- GPU
(126, 5, '16.0-inch WUXGA, 1920x1200'), -- Màn hình
(126, 6, 'Windows 11 Home'), -- Hệ điều hành
(126, 7, '2 USB-C, 2 USB-A, HDMI'), -- Cổng kết nối
(126, 8, 'Backlit Keyboard'), -- Bàn phím
(126, 9, '720p'), -- Webcam
(126, 10, 'Wi-Fi 6'), -- Wi-Fi
(126, 11, 'Bluetooth 5.2'), -- Bluetooth
(126, 12, '50'), -- Pin (Wh)
(126, 13, '1.9'), -- Trọng lượng (kg)
(126, 14, '35.8 x 24.9 x 1.9 cm'), -- Kích thước

-- ASUS ProArt P17 2024 (product_id=127, category_id=1)
(127, 1, 'AMD Ryzen AI 9 HX 370'), -- CPU
(127, 2, '32'), -- RAM (GB)
(127, 3, '1024'), -- Storage (GB)
(127, 4, 'NVIDIA GeForce RTX 4070'), -- GPU
(127, 5, '16.0-inch OLED, 3840x2400'), -- Màn hình
(127, 6, 'Windows 11 Pro'), -- Hệ điều hành
(127, 7, '2 Thunderbolt 4, 2 USB-A, HDMI, SD'), -- Cổng kết nối
(127, 8, 'Backlit Keyboard'), -- Bàn phím
(127, 9, '1080p'), -- Webcam
(127, 10, 'Wi-Fi 7'), -- Wi-Fi
(127, 11, 'Bluetooth 5.4'), -- Bluetooth
(127, 12, '90'), -- Pin (Wh)
(127, 13, '1.85'), -- Trọng lượng (kg)
(127, 14, '35.5 x 24.9 x 1.7 cm'); -- Kích thước

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
(2, 'https://product.hstatic.net/1024384805/product/laptop_apple_macbook_air_2017_128gb_1.8ghz_intel_core_i5_2_2d4bfef3a30b412bb2561629dc8a36f7_master.jpg', 0, 'active'),
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
(6, 'https://m.media-amazon.com/images/I/61EaR0v9+7L._AC_UF894,1024_QL80_.jpg', 0, 'active'),
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
(8, 'https://product.hstatic.net/1024267672/product/asus_zenbook_ux430un-gv096t2_grande.jpg', 0, 'active'),
(8, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStA_htMmbXQhHjY5JZ9Sj5JFOVMOIuqutzQg&s', 0, 'active'),
-- Product 9: Swift 3 (category_id=1)
(9, 'https://cdn.tgdd.vn/Products/Images/44/269313/acer-swift-3-sf314-511-55qe-i5-nxabnsv003-120122-022600-600x600.jpg', 1, 'active'),
(9, 'https://www.acervietnam.com.vn/wp-content/uploads/2021/06/acer-swift-3-sf314-512-sf-314-512t-fingerprint-backlit-on-wallpaper-logo-pure-silver-01-min.png', 0, 'active'),
(9, 'https://bizweb.dktcdn.net/thumb/grande/100/512/769/products/acer-swift-3-2020-laptop-k1-1.jpg?v=1714407605737', 0, 'active'),
(9, 'https://bizweb.dktcdn.net/100/082/878/products/42871-laptop-acer-swift-3-sf314-512-56qn-2.jpg?v=1664805814097', 0, 'active'),
(9, 'https://no1computer.vn/images/products/2022/11/22/large/acer-swift-3-sf314-511-thietke2_1669110542.jpg', 0, 'active'),
-- Product 10: HP 250 G6 i3 6006U (category_id=1)
(10, 'https://product.hstatic.net/1024296652/product/kk_1a586f1bece145bd8a4cbfc80f4c63f2_7a0b155ca637451e81f6e55005c1f568.jpg', 1, 'active'),
(10, 'https://cdn.tgdd.vn/Products/Images/44/132735/hp-250-g6-i3-6006u-2fg16pa-2-2.png', 0, 'active'),
(10, 'https://cdn.tgdd.vn/Products/Images/44/132735/hp-250-g6-i3-6006u-2fg16pa-1.jpg', 0, 'active'),
(10, 'https://product.hstatic.net/1024296652/product/kk_1a586f1bece145bd8a4cbfc80f4c63f2_7a0b155ca637451e81f6e55005c1f568_1024x1024.jpg', 0, 'active'),
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
(23, 'https://product.hstatic.net/1024287389/product/5570-i5-4gb-1tb-vga-ati-m530-2g-15-6-fhd-win10-m5i5238w-b-bac-_37924_2_3fbe18de5bf94cfc92f2eb3766d22fca_master.png', 0, 'active'),
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
(41, 'https://product.hstatic.net/1024333506/product/10303_b__n_ph__m_c___asus_rog_strix_scope_nx_tkl_deluxe_4_550268e2ed774611a0fec5b103b16b3f.jpg', 0, 'active'),
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
(49, 'https://product.hstatic.net/200000304081/product/1024__19__2712988dec1d4b47ba6a1029717d682f_grande.png', 0, 'active'),
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
(51, 'https://product.hstatic.net/200000304081/product/1024_55648a86099145528b054c604fc91a74_master_7ef755837b3547f587b411cd99891391.png', 0, 'active'),
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
(57, 'https://rukminid2.flixcart.com/image/850/1024/xif0q/mobile/z/h/f/a4-5g-a4-5g-redmi-original-imah6yhdg9kpnzgd.jpeg?q=90&crop=false', 0, 'active'),
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
(60, 'https://product.hstatic.net/1024063620/product/den_dfcb94183f00457497aeec219c7d7ab4.jpg', 0, 'active'),
(60, 'https://www.oppo.com/content/dam/oppo/common/mkt/v2-2/a79-5g-en/specs/a79-5g-860_720-bpg.jpg', 0, 'active'),
(60, 'https://file.hstatic.net/1024063620/file/oa792-271023-225532-800-resize_1024x1024.jpg', 0, 'active'),
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
(68, 'https://images.ctfassets.net/wcfotm6rrl7u/3BhWVje5jB1wHYpUs7Ty8L/15f4aec50ba0b30679c9ccee4874d809/nokia-G42_5G-so_pink-front_back-int.png?h=1024&fm=png&fl=png8', 0, 'active'),
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
(74, 'https://file.hstatic.net/1024026716/file/gearvn-chuot-steelseries-aerox-5-wireless-1_15b7fafa0f42499394e87b7b75a7ac58_grande.png', 1, 'active'),
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
(76, 'https://product.hstatic.net/1024129940/product/corsair-virtuoso-rgb-wireless-white_9cbcc325b43340a9b22e34a1064955d1_master.jpg', 0, 'active'),
(76, 'https://product.hstatic.net/1024129940/product/tai_nghe_corsair_virtuoso_rgb_wireless_se_-_espresso_19a8cf7a3dad455d8930085b7d3fa0cb.png', 0, 'active'),
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
(78, 'https://product.hstatic.net/1024333506/product/chuot-corsair-dark-core-rgb-pro-se-4_f1a3cbf9237d44e2a8339725cf4d211f_cd71a79229b94a4dbe5d0ebab6dc3e19.png', 0, 'active'),
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
(81, 'https://m.media-amazon.com/images/I/61QdKZP26rS._AC_UF894,1024_QL80_.jpg', 0, 'active'),
-- Product 82: MSI Vigor GK71 Sonic
(82, 'https://asset.msi.com/resize/image/global/product/product_16415411303a4f3ad1ddc39e1b18dd3904a62e4767.png62405b38c58fe0f07fcef2367d8a9ba1/600.png', 1, 'active'),
(82, 'https://asset.msi.com/resize/image/global/product/product_16415411345fd4741cb1cb02d1e48d0dd14a503160.png62405b38c58fe0f07fcef2367d8a9ba1/600.png', 0, 'active'),
(82, 'https://asset.msi.com/resize/image/global/product/product_1641541132255eaef826d8a8be32af3f490500df74.png62405b38c58fe0f07fcef2367d8a9ba1/600.png', 0, 'active'),
(82, 'https://m.media-amazon.com/images/I/81KTNadJ8QL._AC_UF894,1024_QL80_.jpg', 0, 'active'),
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
(85, 'https://product.hstatic.net/1024129940/product/aorus_m5-1_large.jpg', 0, 'active'),
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
(87, 'https://product.hstatic.net/1024382236/product/6_active_den_60d70d3e50f34a2da50925464026d4a7_grande.jpg', 0, 'active'),
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
(94, 'https://images.ctfassets.net/wcfotm6rrl7u/2Z3VgGVzRvyp79rtRQ2VOX/f1f855d234ba7531d9862d9f52b66237/nokia-TWS-852W-black-angled.png?h=1024&fm=png&fl=png8', 1, 'active'),
(94, 'https://i.ebayimg.com/images/g/0sEAAOSwTXpmulZo/s-l1200.jpg', 0, 'active'),
(94, 'https://pcchip.hr/wp-content/uploads/2022/09/Nokia-Clarity-Earbuds-2-Pro-scaled.webp', 0, 'active'),
(94, 'https://gagadget.com/media/post_big/Nokia_Clarity_Earbuds_2_Pro.jpg', 0, 'active'),
(94, 'https://media.vov.vn/sites/default/files/styles/large/public/2021-07/2_314.jpg', 0, 'active'),
-- Product 95: Nokia Go Earbuds+
(95, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQXAiBYVepZP2H0uEnAhzU04JdKsZ78_N5VA&s', 1, 'active'),
(95, 'https://m.media-amazon.com/images/I/510Ks6DUyqL.jpg', 0, 'active'),
(95, 'https://wibutech.com/wp-content/uploads/2022/10/DSC4488.png', 0, 'active'),
(95, 'https://cdn.24h.com.vn/upload/3-2021/images/2021-07-27/4-1627399622-632-width660height371.jpg', 0, 'active'),
(95, 'https://manuals.plus/wp-content/uploads/2022/10/NOKIA-TWS-201-Go-Earbuds-Wireless-Earbuds-Featured-Image.jpg', 0, 'active'),
-- MacBook Air 13-inch M4 2025 (product_id=96, category_id=1)
(96, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/t/e/text_ng_n_2__9_14.png', 1, 'active'),
(96, 'https://macad.vn/application/upload/products/thumbs/macbook-air-15inch-kleuren.jpg', 0, 'active'),
(96, 'https://cdnv2.tgdd.vn/mwg-static/common/News/0/air-m4-1.jpg', 0, 'active'),
(96, 'https://cdn-images.vtv.vn/zoom/640_400/66349b6076cb4dee98746cf1/2024/10/31/macbook-air-72690458999240396732663-35732766113761555784082.jpg', 0, 'active'),
(96, 'https://macone.vn/wp-content/uploads/2025/03/macbook-air-m4-skyblue-gallery4-202503-1024x787.jpeg', 0, 'active'),
-- MacBook Pro 14-inch M4 Pro 2024 (product_id=97, category_id=1)
(97, 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/mbp14-spaceblack-select-202410?wid=892&hei=820&fmt=jpeg&qlt=90&.v=YnlWZDdpMFo0bUpJZnBpZjhKM2M3VGhTSEZFNjlmT2xUUDNBTjljV1BxWjZkZE52THZKR1lubXJyYmRyWWlhOXZvdUZlR0V0VUdJSjBWaDVNVG95Yk15Y0c3T3Y4UWZwZExHUFdTUC9lN28', 1, 'active'),
(97, 'https://macone.vn/wp-content/uploads/2024/10/Macbook-Pro-2024-M4-1.jpeg', 0, 'active'),
(97, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:0/q:90/plain/https://cellphones.com.vn/media/wysiwyg/laptop/macbook/macbook-pro/M4/macbook-pro-14-inch-m4-16gb-512gb-2.jpg', 0, 'active'),
-- MacBook Air 15-inch M4 2025 (product_id=98, category_id=1)
(98, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTr_pzU6s_NX7DXKnZrLEXancCOK24Zw3j6Vg&s', 1, 'active'),
(98, 'https://m.media-amazon.com/images/I/61FUlY6MiLL.jpg', 0, 'active'),
(98, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3ZEGR8ZrOibvW7SfNNZl8QX3GPUUDJNpOUQ&s', 0, 'active'),
(98, 'https://substackcdn.com/image/fetch/f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F14528d03-0a49-422b-a71b-a4296f3ad8fa_2226x1252.png', 0, 'active'),
-- iPhone 16 (product_id=99, category_id=2)
(99, 'https://cdn.tgdd.vn/Products/Images/42/329143/iphone-16-pro-titan-trang.png', 1, 'active'),
(99, 'https://cdn.viettelstore.vn/Images/Product/ProductImage/579726099.jpeg', 0, 'active'),
(99, 'https://bizweb.dktcdn.net/100/257/835/articles/iphone-16-side-2-feature.jpg?v=1725176880867', 0, 'active'),
(99, 'https://cafefcdn.com/203337114487263232/2024/1/2/iphone-16-17041083576101027027491-1704156018768-1704156018826446072037.jpeg', 0, 'active'),
(99, 'https://genk.mediacdn.vn/139269124445442048/2024/6/24/60124-123512-iphone16renders1-xl-1719269524373-171926952716556352051.jpg', 0, 'active'),
-- iPhone 16 Plus (product_id=100, category_id=2)
(100, 'https://cdn.tgdd.vn/Products/Images/42/329138/iphone-16-plus-den-thumb-600x600.jpg', 1, 'active'),
(100, 'https://www.didongmy.com/vnt_upload/product/09_2024/thumbs/(600x600)_iphone_16_plus_mau_trang_didongmy_thumb_600x600_2.jpg', 0, 'active'),
(100, 'https://cdn.xtmobile.vn/vnt_upload/product/09_2024/thumbs/600_16x_2_5.jpg', 0, 'active'),
-- iPhone 16 Pro (product_id=101, category_id=2)
(101, 'https://cdn.tgdd.vn/Products/Images/42/329143/iphone-16-pro-titan-trang.png', 1, 'active'),
(101, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:0/q:90/plain/https://cellphones.com.vn/media/wysiwyg/Phone/Apple/iPhone-16/dien-thoai-iphone-16-pro-5.jpg', 0, 'active'),
(101, 'https://nhistore.com.vn/wp-content/uploads/2024/09/iphone-16-pro-6-3inch-deserttitanium-nhistore-2.png', 0, 'active'),
-- iPhone 16 Pro Max (product_id=102, category_id=2)
(102, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:0/q:90/plain/https://cellphones.com.vn/media/wysiwyg/Phone/Apple/iPhone-16/iPhone-16-Pro-Max-12.jpg', 1, 'active'),
(102, 'https://lesang.vn/images/san-pham/lens-cuong-luc-dan-camera-iphone-16-pro-max-16-pro-zeelot-titanium1726660964.jpg', 0, 'active'),
(102, 'https://mainguyen.sgp1.digitaloceanspaces.com/279271/Cap-Nhat-Moi-Ve-Kich-Thuoc-iPhone-16-Pro-va-iPhone-16-Pro-Max-TechTimes-%281%29.jpg', 0, 'active'),
-- iPhone 17 (product_id=103, category_id=2)
(103, 'https://www.didongmy.com/vnt_upload/product/01_2025/thumbs/600_iphone-17-128gb-didongmy-thumb-600x600.jpg', 1, 'active'),
(103, 'https://baobinhduong.vn/image/fckeditor/upload/2024/20241213/images/2.jpg', 0, 'active'),
(103, 'https://img-s1.onedio.com/id-6802335f27c6d7eb7cf93ee0/rev-0/w-600/h-337/f-jpg/s-ebc4d5d9a67ff53b3736cdb6ab1d5badc70f746a.jpg', 0, 'active'),
-- iPhone 17 Plus (product_id=104, category_id=2)
(104, 'https://cdn.xtmobile.vn/vnt_upload/product/03_2025/thumbs/600_iphone_17_plus_xtmobile.jpg', 1, 'active'),
(104, 'https://akm-img-a-in.tosshub.com/businesstoday/images/story/202404/6621b050dd93c-apple-iphone-15-plus-184415852-16x9.jpg?size=948:533', 0, 'active'),
-- iPhone 17 Pro (product_id=105, category_id=2)
(105, 'https://file.hstatic.net/200000845283/article/iphone-17pro-thumb_cc2e30d7824c44fca43d1dbbb8fa6933.jpg', 1, 'active'),
(105, 'https://images2.thanhnien.vn/528068263637045248/2024/11/30/1-17330086062081288630678.jpg', 0, 'active'),
(105, 'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/thiet_ke_gay_soc_cua_iphone_17_pro_duoc_tiet_lo_1_dddfdf477f.jpg', 0, 'active'),
-- iPhone 17 Pro Max (product_id=106, category_id=2)
(106, 'https://www.didongmy.com/vnt_upload/product/03_2025/thumbs/600_iphone-17-pro-max-512gb-specs-thumb-600x600.jpg', 1, 'active'),
(106, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMBnQFPz1cYMPBviqMrUxdcmRpbqjxcsXVkw&s', 0, 'active'),
(106, 'https://iphonethanhnhan.vn/upload/product/z6448283526305c2e2199665b931b8b40311791504bf14-4073.jpg', 0, 'active'),
-- iPhone 16e (product_id=107, category_id=2)
(107, 'https://cdn.tgdd.vn/Products/Images/42/334864/iphone-16e-white-thumb-600x600.jpg', 1, 'active'),
(107, 'https://www.apple.com/newsroom/images/2025/02/apple-debuts-iphone-16e-a-powerful-new-member-of-the-iphone-16-family/geo/article/Apple-iPhone-16e-hero-GEO-250219_inline.jpg.large.jpg', 0, 'active'),
(107, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:0/q:90/plain/https://cellphones.com.vn/media/wysiwyg/Phone/Apple/iphone-16e/iphone-16e-7.jpg', 0, 'active'),
(107, 'https://www.androidheadlines.com/wp-content/uploads/2025/01/Apple-iPhone-16E-concept-design-featured-scaled.jpg', 0, 'active'),
(107, 'https://media-ds.nguoiduatin.vn/media/bien-tap-vien/2025/02/20/iphone-16e1.jpg', 0, 'active'),
-- iPhone 17 Air (product_id=108, category_id=2)
(108, 'https://images2.thanhnien.vn/528068263637045248/2024/12/13/iphone-17-air-1734098971397-173409897177948585030.jpg', 1, 'active'),
(108, 'https://cdnphoto.dantri.com.vn/Y0hELO9MGi78qhqNQp6ufVSJWpg=/thumb_w/1020/2025/06/02/iphone-17jpg-1748805111056.jpg', 0, 'active'),
(108, 'https://vcdn1-sohoa.vnecdn.net/2025/03/12/iPhone-17-Air-Size-Feature-174-4097-9738-1741794789.jpg?w=460&h=0&q=100&dpr=2&fit=crop&s=o7OOsgYOhvL3cWZMaNXvnw', 0, 'active'),
-- iPhone 16 Mini (product_id=109, category_id=2)
(109, 'https://kenh14cdn.com/203336854389633024/2024/7/25/iphone-se-4-3-1721873842327-17218738428261928574281.jpg', 1, 'active'),
(109, 'https://kenh14cdn.com/zoom/700_438/203336854389633024/2024/7/28/avatar1722154118052-17221541184932018392803.jpg', 0, 'active'),
(109, 'https://cdnv2.tgdd.vn/mwg-static/common/News/1572308/1570472-8.jpg', 0, 'active'),
-- iPhone 17 Slim (product_id=110, category_id=2)
(110, 'https://cdn.xtmobile.vn/vnt_upload/news/06_2024/iphone-17-slim-gia-bao-nhieu-xtmobile.jpg', 1, 'active'),
(110, 'https://www.maclife.de/media/maclife/styles/tec_frontend_fullscreen/public/images/editors/2024_42/image-124950--4614814.jpg?itok=hSEA2aWt', 0, 'active'),
(110, 'https://cdn.xtmobile.vn/vnt_upload/news/06_2024/iphone-17-slim-thiet-ke-xtmobile.jpg', 0, 'active'),
-- Samsung Galaxy S25 (product_id=111, category_id=2)
(111, 'https://samcenter.vn/images/thumbs/0010679_samsung-galaxy-s25-256gb.png', 1, 'active'),
(111, 'https://images.samsung.com/is/image/samsung/p6pim/vn/translationfeature/165816469/vn-featureunit-simple--impactful-544896089?$FB_TYPE_A_MO_JPG$', 0, 'active'),
(111, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRla5QBAXrvicnsg26ZFzJCI2g51g4JM6ct0A&s', 0, 'active'),
-- Samsung Galaxy S25 Plus (product_id=112, category_id=2)
(112, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/d/i/dien-thoai-samsung-galaxy_4_.png', 1, 'active'),
(112, 'https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/42/333359/samsung-galaxy-s25-plus-acv-15-638732483862051348.jpg', 0, 'active'),
(112, 'https://admin.vov.gov.vn/UploadFolder/KhoTin/Images/UploadFolder/VOVVN/Images/sites/default/files/styles/large/public/2024-07/1_11.jpg', 0, 'active'),
-- Samsung Galaxy S25 Ultra (product_id=113, category_id=2)
(113, 'https://cdn.viettelstore.vn/Images/Product/ProductImage/84336239.jpeg', 1, 'active'),
(113, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/d/i/dien-thoai-samsung-galaxy-s25-utra_1.png', 0, 'active'),
(113, 'https://clickbuy.com.vn/uploads/images/tin%20tuc/Quanh/xmi/samsung-galaxy-s25-ultra-1.jpg', 0, 'active'),
-- Samsung Galaxy Z Fold 7 (product_id=114, category_id=2)
(114, 'https://samcenter.vn/images/thumbs/0014263_z-fold-7-cau-hinh-1_1900.jpeg', 1, 'active'),
(114, 'https://images2.thanhnien.vn/528068263637045248/2024/10/27/galaxyzfold6samsung1721300455509-1729998734093-17299987346881421283019.jpg', 0, 'active'),
(114, 'https://hoanghamobile.com/tin-tuc/wp-content/uploads/2024/12/Anh-thumb-2-3.jpg', 0, 'active'),
-- Samsung Galaxy Z Flip 7 (product_id=115, category_id=2)
(115, 'https://cdn2.fptshop.com.vn/unsafe/800x0/samsung_galaxy_z_flip_7_gia_bao_nhieu_3_fe890230a5.jpg', 1, 'active'),
(115, 'https://cdn.tgdd.vn/Files/2022/08/09/1454644/zflip4kem-31-_2048x1159-800-resize.jpg', 0, 'active'),
(115, 'https://samcenter.vn/images/uploaded/Samsung%20zFlip7/z%20flip%207%20news/galaxy-z-flip-7-durability-and-hinge-design.png', 0, 'active'),
-- Samsung Galaxy A56 (product_id=116, category_id=2)
(116, 'https://cdn.mobilecity.vn/mobilecity-vn/images/2025/03/samsung-galaxy-a56-5g-xanh.jpg.webp', 1, 'active'),
(116, 'https://imagedelivery.net/4fYuQyy-r8_rpBpcY7lH_A/falabellaPE/119452481_01/w=800,h=800,fit=pad', 0, 'active'),
(116, 'https://bloganchoi.com/wp-content/uploads/2025/01/dien-thoai-samsung-1-696x361.jpg', 0, 'active'),
-- Samsung Galaxy A36 (product_id=117, category_id=2)
(117, 'https://happyphone.vn/wp-content/uploads/2024/05/Samsung-Galaxy-A36-Den.jpg', 1, 'active'),
(117, 'https://mobilebulgaria.com/img/cms/506/821506.jpg', 0, 'active'),
(117, 'https://cdn.viettablet.com/images/companies/1/minh-duc-3/samsung-galaxy-a36/samsung-galaxy-a36-2.jpg?1741141570319', 0, 'active'),
-- Samsung Galaxy M55 (product_id=118, category_id=2)
(118, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/s/a/samsung_galaxy_m55.png', 1, 'active'),
(118, 'https://cdn.viettablet.com/images/companies/1/samsung-galaxy-m55-5g/galaxy-m55.jpg?1706073885546', 0, 'active'),
(118, 'https://cdn.xtmobile.vn/vnt_upload/news/01_2024/13/galaxy-m55-5g-sap-ra-mat-xtmobile.jpg', 0, 'active'),
-- Samsung Galaxy S25 FE (product_id=119, category_id=2)
(119, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/d/i/dien-thoai-samsung-galaxy-s25-plus_2_1.png', 1, 'active'),
(119, 'https://images.samsung.com/is/image/samsung/assets/in/smartphones/galaxy-s24-fe/buy/S24_FE_Group_KV_Global_MO.jpg', 0, 'active'),
(119, 'https://media.johnlewiscontent.com/i/JohnLewis/112586484alt1?fmt=auto&$background-off-white$', 0, 'active'),
-- DELL XPS 15 2024 (product_id=120, category_id=1)
(120, 'https://www.laptopvip.vn/images/ab__webp/thumbnails/300/300/detailed/39/notebook-xps-14-9440t-sl-gallery-9-4uf6-aa-www.laptopvip.vn-1727146970.png.webp', 1, 'active'),
(120, 'https://m.media-amazon.com/images/I/71IuiJEue9L._AC_SL1500_.jpg', 0, 'active'),
(120, 'https://m.media-amazon.com/images/I/71ehNDXWK2L.jpg', 0, 'active'),
(120, 'https://astringo-rugged.com/wp-content/uploads/2023/10/New-Project-44.png', 0, 'active'),
(120, 'https://www.laptopvip.vn/images/ab__webp/detailed/31/notebook-xps-15-9530-t-black-galle~1-sq3v-iq-www.laptopvip.vn-1683083302.webp', 0, 'active'),
-- DELL XPS 17 2025 (product_id=121, category_id=1)
(121, 'https://www.laptopvip.vn/images/ab__webp/thumbnails/300/300/detailed/42/notebook-laptop-xps-16-9640-nt--3--www.laptopvip.vn-1744699863.png.webp', 1, 'active'),
(121, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIQjNFi-WLIMhJsJhUjBOf4gB7JCyPWh771g&s', 0, 'active'),
(121, 'https://static.hungphatlaptop.com/wp-content/uploads/2023/03/DELL-XPS-17-9730-2023-H4.jpeg', 0, 'active'),
(121, 'https://imagor.owtg.one/unsafe/fit-in/800x800/https://d28jzcg6y4v9j1.cloudfront.net/media/core/products/2023/4/18/dell-xps-17-9730-2023-thinkpro-JfE.png', 0, 'active'),
(121, 'https://www.laptopvip.vn/images/ab__webp/thumbnails/800/800/detailed/22/xs9700nt-xnb-shot04-bk-hero-crop-c31u-uz-www.laptopvip.vn-1620357364.png.webp', 0, 'active'),
-- DELL Inspiron 13 Plus 2024 (product_id=122, category_id=1)
(122, 'https://ttcenter.com.vn/uploads/product/1ph8wnbp-1970-dell-inspiron-14-plus-7440f-2025-core7-240h-16gb-ssd-1tb-14inch-qhd-2-5k-90hz-new.jpg', 1, 'active'),
(122, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQGTc3WXEFwlRrsypZyb0OLUSE5AyFOUBlOg&s', 0, 'active'),
(122, 'https://2tmobile.com/wp-content/uploads/2024/12/dell-inspiron-13-5330n-2024-keyboard-2tmobile.webp', 0, 'active'),
(122, 'https://laptopaz.vn/media/product/3163_2798_4.png', 0, 'active'),
(122, 'https://nvs.tn-cdn.net/2023/09/laptop-dell-xps-13-plus-9320-5cg58-6.webp', 0, 'active'),
-- DELL Latitude 7455 2024 (product_id=123, category_id=1)
(123, 'https://static.hungphatlaptop.com/wp-content/uploads/2024/05/DELL-Latitude-7450-2024-Features-03-1.jpeg', 1, 'active'),
(123, 'https://laptops.vn/wp-content/uploads/2024/10/z6218230602755_615c30eb66c85a8f839e08b6ce097340.jpg', 0, 'active'),
(123, 'https://nghenhinvietnam.vn/uploads/global/quanghuy/2024/5/22/latitude/nghenhin_dell_latitude-7455-1.jpg', 0, 'active'),
(123, 'https://static.hungphatlaptop.com/wp-content/uploads/2024/05/DELL-Latitude-7450-2024-H2-1.jpeg', 0, 'active'),
(123, 'https://laptopg7.com.vn/upload/product/251951_Dell%20Latitude%207455%20LAPTOPG7%20COM%20VN%2004.jpg', 0, 'active'),
-- ASUS Zenbook S 15 2024 (product_id=124, category_id=1)
(124, 'https://trungtran.vn/upload_images/images/products/asus-zenbook-series/asus_zenbook_s14_white.jpg', 1, 'active'),
(124, 'https://vinhpici.vn/wp-content/uploads/2024/04/laptop-asus-vivobook-s15-ultra7-155h-intel-arc-ram-32gb-ssd-1tb-15-6%E2%80%B3-2-8k-120hz-2.png', 0, 'active'),
(124, 'https://bsmedia.business-standard.com/_media/bs/img/article/2024-03/13/full/1710324908-095.jpg?im=FaceCrop,size=(826,465)', 0, 'active'),
(124, 'https://image.ceneostatic.pl/data/products/178017912/p-laptop-asus-vivobook-s-16-oled-m5606wa-mx023x-16-ryzen-ai-9-32gb-1tb-win11-90nb14b3m00850.jpg', 0, 'active'),
(124, 'https://dlcdnwebimgs.asus.com/gain/967dccac-f21d-4932-a7a2-ef84abaf9800/', 0, 'active'),
-- ASUS ROG Zephyrus G17 2024 (product_id=125, category_id=1)
(125, 'https://dlcdnwebimgs.asus.com/gain/AA196938-7A28-4264-904C-F7569F80B7B6', 1, 'active'),
(125, 'https://m.media-amazon.com/images/I/51kUwhoFB1L.jpg', 0, 'active'),
(125, 'https://dlcdnwebimgs.asus.com/files/media/8CF497C8-1A77-404F-ABF1-85822D3BE077/v1/img/performance/rog-strix-g-16.png', 0, 'active'),
(125, 'https://2tmobile.com/wp-content/uploads/2024/07/asus-rog-zephyrus-g16-gu605-2024-gray-2tmobile.jpg', 0, 'active'),
(125, 'https://assets.mmsrg.com/isr/166325/c1/-/ASSET_MMS_105141850?x=536&y=402&format=jpg&quality=80&sp=yes&strip=yes&trim&ex=536&ey=402&align=center&resizesource&unsharp=1.5x1+0.7+0.02&cox=0&coy=0&cdx=536&cdy=402', 0, 'active'),
-- ASUS Vivobook 17 2024 (product_id=126, category_id=1)
(126, 'https://imagor.owtg.one/unsafe/fit-in/560x560/https://media-api-beta.thinkpro.vn/media/core/products/2024/10/23/laptop-asus-vivobook-s-16-oled-s5606ma-mx051w-undefined.png', 1, 'active'),
(126, 'https://cdn2.fptshop.com.vn/unsafe/800x0/laptop_asus_17inch_2024_5_4beb2b71f1.jpg', 0, 'active'),
(126, 'https://m.media-amazon.com/images/I/51rVkLPTOXL.jpg', 0, 'active'),
(126, 'https://m.media-amazon.com/images/I/61KqKz0f-9L.jpg', 0, 'active'),
(126, 'https://image.ceneostatic.pl/data/products/180622154/p-laptop-asus-vivobook-17-x1704va-au431-17-3-i5-16gb-1tb-noos-90nb10v1m00eb0.jpg', 0, 'active'),
-- ASUS ProArt P17 2024 (product_id=127, category_id=1)
(127, 'https://2tmobile.com/wp-content/uploads/2025/01/asus-proart-p16-h7606-2024-2tmobile.webp', 1, 'active'),
(127, 'https://cdn-media.sforum.vn/storage/app/media/lyanhkiet/AnhKiet/asus-proart-copilot-ra-mat-1.jpg', 0, 'active'),
(127, 'https://event.mediacdn.vn/thumb_w/800/257767050295742464/image/btc/2024/8/29/proart-px13-3-1717432503413572338110-172491747504362636355.jpg', 0, 'active'),
(127, 'https://event.mediacdn.vn/thumb_w/800/257767050295742464/image/btc/2024/8/29/sfvabrsdfb-1724917475032295053051.jpg', 0, 'active'),
(127, 'https://www.laptopvip.vn/images/ab__webp/detailed/39/asus-proart-pz13-ht5306-635e444c-5e08-4081-99f1-119085969cae-ci03-yc-www.laptopvip.vn-1727150181.webp', 0, 'active');

-- mapping brand_id & category_id -> query
CREATE TABLE Brand_Category (
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (brand_id, category_id),
    FOREIGN KEY (brand_id) REFERENCES Brand(brand_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- Apple: Laptop (1), Phone (2), Headphones (4)
INSERT INTO Brand_Category (brand_id, category_id) VALUES (1, 1), (1, 2), (1, 4);

-- Dell, HP, Lenovo, Asus, Acer, MSI, Gigabyte: Laptop (1)
INSERT INTO Brand_Category (brand_id, category_id) VALUES 
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1);

-- Samsung: Phone (2), Headphones (4)
INSERT INTO Brand_Category (brand_id, category_id) VALUES 
(9, 2),
(9, 4);

-- Xiaomi, OPPO, Vivo, Realme, Nokia: Phone (2)
INSERT INTO Brand_Category (brand_id, category_id) VALUES 
(10, 2),
(11, 2),
(12, 2),
(13, 2),
(14, 2);

-- Logitech: Mouse (3), Headphones (4), Keyboard (5)
INSERT INTO Brand_Category (brand_id, category_id) VALUES 
(15, 3),
(15, 4),
(15, 5);

-- Razer: Mouse (3), Headphones (4), Keyboard (5)
INSERT INTO Brand_Category (brand_id, category_id) VALUES 
(16, 3),
(16, 4),
(16, 5);

-- Corsair: Mouse (3), Headphones (4), Keyboard (5)
INSERT INTO Brand_Category (brand_id, category_id) VALUES 
(17, 3),
(17, 4),
(17, 5);

-- SteelSeries: Mouse (3), Headphones (4), Keyboard (5)
INSERT INTO Brand_Category (brand_id, category_id) VALUES 
(18, 3),
(18, 4),
(18, 5);

-- HyperX: Mouse (3), Headphones (4), Keyboard (5)
INSERT INTO Brand_Category (brand_id, category_id) VALUES 
(19, 3),
(19, 4),
(19, 5);

SELECT 
                b.brand_id, b.name AS brand_name, b.image_url AS brand_image_url, b.Country AS brand_country,
                c.category_id, c.name AS category_name, c.image_url AS category_image_url
            FROM Brand_Category bc
            JOIN Brand b ON bc.brand_id = b.brand_id
            JOIN Category c ON bc.category_id = c.category_id
            WHERE b.status = 'active' AND c.status = 'active' AND c.category_id = 1

SELECT top 5 p.attribute_value, a.unit
        FROM ProductDetail p
        JOIN Attribute a ON p.attribute_id = a.attribute_id
        WHERE p.product_id = 1
;
               
SELECT DISTINCT p.*
FROM Product p
JOIN ProductDetail pd_cpu ON p.product_id = pd_cpu.product_id
WHERE p.status = 'active'
  AND p.brand_id IN ( 1, 2)
  --AND p.price BETWEEN 15000000 AND 30000000
  AND pd_cpu.attribute_id = 1
  AND pd_cpu.attribute_value IN ('%Intel core%');
