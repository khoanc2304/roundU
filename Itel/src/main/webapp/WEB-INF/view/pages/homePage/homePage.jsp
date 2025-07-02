<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Home Page</title>

        <!-- Bootstrap 5.3 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous"/>

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <!-- Add AOS CSS -->
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    </head>

    <body>
        <!-- Navbar (optional) -->
        <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>

        <!-- Main Banner -->
        <div class="banner-wrapper">
            <div id="bannerCarousel" class="carousel slide banner-container" data-bs-ride="carousel" data-bs-interval="3000">
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="${pageContext.request.contextPath}/assets/images/banner/b1.png" alt="Banner 1" class="d-block w-100">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/assets/images/banner/b2.png" alt="Banner 2" class="d-block w-100">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/assets/images/banner/b3.png" alt="Banner 3" class="d-block w-100">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/assets/images/banner/b4.png" alt="Banner 4" class="d-block w-100">
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#bannerCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#bannerCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </div>

        <div class="container my-5">
            <div class="layout-3col d-flex justify-content-center gap-4">

                <!-- Cột Trái -->
                <div class="left-col d-flex flex-column gap-3">
                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&c=Laptop" class="category-link">
                        <div class="category-box">
                            <h4>Laptop</h4>
                            <img src="${sessionScope.LaptopImageUrl}" alt="Laptop" class="category-image">
                        </div>
                    </a>
                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&c=Phone" class="category-link">
                        <div class="category-box">
                            <h4>Điện thoại</h4>
                            <img src="${sessionScope.PhoneImageUrl}" alt="Phone" class="category-image">
                        </div>
                    </a>
                </div>

                <!-- Cột Giữa -->
                <div class="middle-col d-flex align-items-center justify-content-center">
                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&c=Mouse" class="category-link w-100">
                        <div class="category-box-mid">
                            <h4>Chuột</h4>
                            <img src="${sessionScope.MouseImageUrl}" alt="Mouse" class="category-image mouse-image">
                        </div>
                    </a>
                </div>

                <!-- Cột Phải -->
                <div class="right-col d-flex flex-column gap-3">
                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&c=Headphones" class="category-link">
                        <div class="category-box">
                            <h4>Tai nghe</h4>
                            <img src="${sessionScope.HeadphonesImageUrl}" alt="Headphones" class="category-image">
                        </div>
                    </a>
                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&c=Keyboard" class="category-link">
                        <div class="category-box">
                            <h4>Bàn phím</h4>
                            <img src="${sessionScope.KeyboardImageUrl}" alt="Keyboard" class="category-image">
                        </div>
                    </a>
                </div>

            </div>
        </div>

        <div class="container my-5">
            <div class="row">
                <div class="col-12 col-md-4 col-lg-3">
                    <div class="sidebar list-group" data-aos="fade-up">
                        <!-- Mega menu chung -->
                        <div id="mega-menu" class="mega-menu shadow bg-white"></div>
                        <!-- Mục Laptop -->
                        <div class="list-group-item list-group-item-action d-flex align-items-center category-item position-relative" data-mega-menu='
                             <div class="mega-menu-content">
                             <div class="menu-column">
                             <h6 class="fw-bold">Thương Hiệu</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Asus</a></li>
                             <li><a href="#">Acer</a></li>
                             <li><a href="#">MSI</a></li>
                             <li><a href="#">Lenovo</a></li>
                             <li><a href="#">Gigabyte</a></li>
                             <li><a href="#">Apple</a></li>
                             <li><a href="#">Dell</a></li>
                             <li><a href="#">HP</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Giá bán</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Dưới 15 triệu</a></li>
                             <li><a href="#">Từ 15 đến 20 triệu</a></li>
                             <li><a href="#">Trên 20 triệu</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">CPU Intel - AMD</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Intel Core i3</a></li>
                             <li><a href="#">Intel Core i5</a></li>
                             <li><a href="#">Intel Core i7</a></li>
                             <li><a href="#">Intel Core i9</a></li>
                             <li><a href="#">AMD Ryzen 5</a></li>
                             <li><a href="#">AMD Ryzen 7</a></li>
                             <li><a href="#">AMD Ryzen 9</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Nhu cầu sử dụng</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Đồ họa - Studio</a></li>
                             <li><a href="#">Học sinh - Sinh viên</a></li>
                             <li><a href="#">Mỏng nhẹ cao cấp</a></li>
                             <li><a href="#">Ổ cứng độ bền</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Linh phụ kiện Laptop</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Ram laptop</a></li>
                             <li><a href="#">SSD laptop</a></li>
                             <li><a href="#">Ổ cứng di động</a></li>
                             </ul>
                             </div>
                             </div>
                             '>
                            <a href="#" class="text-decoration-none text-dark flex-grow-1">
                                <i class="fas fa-laptop me-2"></i> Laptop
                            </a>
                        </div>
                        <!-- Mục PC -->
                        <div class="list-group-item list-group-item-action d-flex align-items-center category-item position-relative" data-mega-menu='
                             <div class="mega-menu-content">
                             <div class="menu-column">
                             <h6 class="fw-bold">Thương Hiệu</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Asus</a></li>
                             <li><a href="#">Acer</a></li>
                             <li><a href="#">MSI</a></li>
                             <li><a href="#">Lenovo</a></li>
                             <li><a href="#">Gigabyte</a></li>
                             <li><a href="#">Apple</a></li>
                             <li><a href="#">Dell</a></li>
                             <li><a href="#">HP</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Giá bán</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Dưới 15 triệu</a></li>
                             <li><a href="#">Từ 15 đến 20 triệu</a></li>
                             <li><a href="#">Trên 20 triệu</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">CPU Intel - AMD</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Intel Core i3</a></li>
                             <li><a href="#">Intel Core i5</a></li>
                             <li><a href="#">Intel Core i7</a></li>
                             <li><a href="#">Intel Core i9</a></li>
                             <li><a href="#">AMD Ryzen 5</a></li>
                             <li><a href="#">AMD Ryzen 7</a></li>
                             <li><a href="#">AMD Ryzen 9</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Nhu cầu sử dụng</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Đồ họa - Studio</a></li>
                             <li><a href="#">Học sinh - Sinh viên</a></li>
                             <li><a href="#">Mỏng nhẹ cao cấp</a></li>
                             <li><a href="#">Ổ cứng độ bền</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Linh phụ kiện PC</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Ram PC</a></li>
                             <li><a href="#">SSD PC</a></li>
                             <li><a href="#">Ổ cứng di động</a></li>
                             </ul>
                             </div>
                             </div>
                             '>
                            <a href="#" class="text-decoration-none text-dark flex-grow-1">
                                <i class="fas fa-desktop me-2"></i> PC
                            </a>
                        </div>
                        <!-- Mục Điện thoại -->
                        <div class="list-group-item list-group-item-action d-flex align-items-center category-item position-relative" data-mega-menu='
                             <div class="mega-menu-content">
                             <div class="menu-column">
                             <h6 class="fw-bold">Thương Hiệu</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Apple</a></li>
                             <li><a href="#">Samsung</a></li>
                             <li><a href="#">Xiaomi</a></li>
                             <li><a href="#">Oppo</a></li>
                             <li><a href="#">Vivo</a></li>
                             <li><a href="#">Realme</a></li>
                             <li><a href="#">OnePlus</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Khoảng giá</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Dưới 3 triệu</a></li>
                             <li><a href="#">Từ 3 đến 7 triệu</a></li>
                             <li><a href="#">Từ 7 đến 15 triệu</a></li>
                             <li><a href="#">Trên 15 triệu</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Hệ điều hành</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Android</a></li>
                             <li><a href="#">iOS</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Tính năng nổi bật</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">5G</a></li>
                             <li><a href="#">Chống nước</a></li>
                             <li><a href="#">Sạc nhanh</a></li>
                             <li><a href="#">Màn hình lớn</a></li>
                             <li><a href="#">Camera chất lượng cao</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Phụ kiện điện thoại</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Ốp lưng</a></li>
                             <li><a href="#">Sạc dự phòng</a></li>
                             <li><a href="#">Tai nghe Bluetooth</a></li>
                             </ul>
                             </div>
                             </div>
                             '>
                            <a href="#" class="text-decoration-none text-dark flex-grow-1">
                                <i class="fas fa-mobile-alt me-2"></i> Điện thoại
                            </a>
                        </div>
                        <!-- Mục Tai nghe -->
                        <div class="list-group-item list-group-item-action d-flex align-items-center category-item position-relative" data-mega-menu='
                             <div class="mega-menu-content">
                             <div class="menu-column">
                             <h6 class="fw-bold">Thương Hiệu</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Sony</a></li>
                             <li><a href="#">Bose</a></li>
                             <li><a href="#">JBL</a></li>
                             <li><a href="#">Apple</a></li>
                             <li><a href="#">Sennheiser</a></li>
                             <li><a href="#">Anker</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Loại tai nghe</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Tai nghe không dây</a></li>
                             <li><a href="#">Tai nghe có dây</a></li>
                             <li><a href="#">Tai nghe chống ồn</a></li>
                             <li><a href="#">Tai nghe gaming</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Phụ kiện tai nghe</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Đệm tai</a></li>
                             <li><a href="#">Cáp sạc</a></li>
                             <li><a href="#">Bảo vệ case</a></li>
                             </ul>
                             </div>
                             </div>
                             '>
                            <a href="#" class="text-decoration-none text-dark flex-grow-1">
                                <i class="fas fa-headphones-alt me-2"></i> Tai nghe
                            </a>
                        </div>
                        <!-- Mục Bàn phím -->
                        <div class="list-group-item list-group-item-action d-flex align-items-center category-item position-relative" data-mega-menu='
                             <div class="mega-menu-content">
                             <div class="menu-column">
                             <h6 class="fw-bold">Thương Hiệu</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Logitech</a></li>
                             <li><a href="#">Razer</a></li>
                             <li><a href="#">Corsair</a></li>
                             <li><a href="#">Keychron</a></li>
                             <li><a href="#">SteelSeries</a></li>
                             <li><a href="#">Microsoft</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Loại bàn phím</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Bàn phím cơ</a></li>
                             <li><a href="#">Bàn phím membrane</a></li>
                             <li><a href="#">Bàn phím không dây</a></li>
                             <li><a href="#">Bàn phím gaming</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Phụ kiện bàn phím</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Keycap</a></li>
                             <li><a href="#">Dây cáp</a></li>
                             <li><a href="#">Tấm kê tay</a></li>
                             </ul>
                             </div>
                             </div>
                             '>
                            <a href="#" class="text-decoration-none text-dark flex-grow-1">
                                <i class="fas fa-keyboard me-2"></i> Bàn phím
                            </a>
                        </div>
                        <!-- Mục Chuột -->
                        <div class="list-group-item list-group-item-action d-flex align-items-center category-item position-relative" data-mega-menu='
                             <div class="mega-menu-content">
                             <div class="menu-column">
                             <h6 class="fw-bold">Thương Hiệu</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Logitech</a></li>
                             <li><a href="#">Razer</a></li>
                             <li><a href="#">Corsair</a></li>
                             <li><a href="#">SteelSeries</a></li>
                             <li><a href="#">Apple</a></li>
                             <li><a href="#">Microsoft</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Loại chuột</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Chuột không dây</a></li>
                             <li><a href="#">Chuột có dây</a></li>
                             <li><a href="#">Chuột gaming</a></li>
                             <li><a href="#">Chuột chuyên dụng đồ họa</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Phụ kiện chuột</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Lót chuột</a></li>
                             <li><a href="#">Dây cáp</a></li>
                             <li><a href="#">Bảo vệ chuột</a></li>
                             </ul>
                             </div>
                             </div>
                             '>
                            <a href="#" class="text-decoration-none text-dark flex-grow-1">
                                <i class="fas fa-mouse me-2"></i> Chuột
                            </a>
                        </div>
                        <!-- Mục PC - Máy tính bàn -->
                        <div class="list-group-item list-group-item-action d-flex align-items-center category-item position-relative" data-mega-menu='
                             <div class="mega-menu-content">
                             <div class="menu-column">
                             <h6 class="fw-bold">Thương Hiệu</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Dell</a></li>
                             <li><a href="#">HP</a></li>
                             <li><a href="#">Lenovo</a></li>
                             <li><a href="#">Asus</a></li>
                             <li><a href="#">Acer</a></li>
                             <li><a href="#">MSI</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Loại PC</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">PC Gaming</a></li>
                             <li><a href="#">PC Văn phòng</a></li>
                             <li><a href="#">PC Đồ họa - Thiết kế</a></li>
                             <li><a href="#">PC Server</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Phụ kiện PC</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Bàn phím</a></li>
                             <li><a href="#">Chuột</a></li>
                             <li><a href="#">Màn hình</a></li>
                             <li><a href="#">Loa</a></li>
                             </ul>
                             </div>
                             </div>
                             '>
                            <a href="#" class="text-decoration-none text-dark flex-grow-1">
                                <i class="fas fa-desktop me-2"></i> PC - Máy tính bàn
                            </a>
                        </div>

                        <!-- Mục Màn hình máy tính -->
                        <div class="list-group-item list-group-item-action d-flex align-items-center category-item position-relative" data-mega-menu='
                             <div class="mega-menu-content">
                             <div class="menu-column">
                             <h6 class="fw-bold">Thương Hiệu</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Dell</a></li>
                             <li><a href="#">LG</a></li>
                             <li><a href="#">Samsung</a></li>
                             <li><a href="#">Asus</a></li>
                             <li><a href="#">BenQ</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Kích thước màn hình</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Dưới 24 inch</a></li>
                             <li><a href="#">24 - 27 inch</a></li>
                             <li><a href="#">Trên 27 inch</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Loại màn hình</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">IPS</a></li>
                             <li><a href="#">VA</a></li>
                             <li><a href="#">TN</a></li>
                             <li><a href="#">Màn hình cong</a></li>
                             </ul>
                             </div>
                             </div>
                             '>
                            <a href="#" class="text-decoration-none text-dark flex-grow-1">
                                <i class="fas fa-tv me-2"></i> Màn hình máy tính
                            </a>
                        </div>

                        <!-- Mục Linh kiện máy tính -->
                        <div class="list-group-item list-group-item-action d-flex align-items-center category-item position-relative" data-mega-menu='
                             <div class="mega-menu-content">
                             <div class="menu-column">
                             <h6 class="fw-bold">Thành phần linh kiện</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Mainboard</a></li>
                             <li><a href="#">CPU</a></li>
                             <li><a href="#">RAM</a></li>
                             <li><a href="#">Card màn hình</a></li>
                             <li><a href="#">Ổ cứng SSD/HDD</a></li>
                             <li><a href="#">Nguồn máy tính</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Phụ kiện linh kiện</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Quạt tản nhiệt</a></li>
                             <li><a href="#">Tản nhiệt nước</a></li>
                             <li><a href="#">Cáp nối</a></li>
                             </ul>
                             </div>
                             </div>
                             '>
                            <a href="#" class="text-decoration-none text-dark flex-grow-1">
                                <i class="fas fa-microchip me-2"></i> Linh kiện máy tính
                            </a>
                        </div>

                        <!-- Mục Phụ kiện máy tính -->
                        <div class="list-group-item list-group-item-action d-flex align-items-center category-item position-relative" data-mega-menu='
                             <div class="mega-menu-content">
                             <div class="menu-column">
                             <h6 class="fw-bold">Phụ kiện phổ biến</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Dây cáp USB</a></li>
                             <li><a href="#">Hub USB</a></li>
                             <li><a href="#">Bàn di chuột</a></li>
                             <li><a href="#">Sạc dự phòng</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Phụ kiện mở rộng</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Đế tản nhiệt</a></li>
                             <li><a href="#">Tấm chắn bụi</a></li>
                             <li><a href="#">Kẹp giữ dây</a></li>
                             </ul>
                             </div>
                             </div>
                             '>
                            <a href="#" class="text-decoration-none text-dark flex-grow-1">
                                <i class="fas fa-plug me-2"></i> Phụ kiện máy tính
                            </a>
                        </div>

                        <!-- Mục Gaming Gear -->
                        <div class="list-group-item list-group-item-action d-flex align-items-center category-item position-relative" data-mega-menu='
                             <div class="mega-menu-content">
                             <div class="menu-column">
                             <h6 class="fw-bold">Thiết bị chơi game</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Bàn phím gaming</a></li>
                             <li><a href="#">Chuột gaming</a></li>
                             <li><a href="#">Ghế gaming</a></li>
                             <li><a href="#">Tai nghe gaming</a></li>
                             </ul>
                             </div>
                             <div class="menu-column">
                             <h6 class="fw-bold">Phụ kiện Gaming</h6>
                             <ul class="list-unstyled">
                             <li><a href="#">Mousepad</a></li>
                             <li><a href="#">Bàn di</a></li>
                             <li><a href="#">Đèn LED RGB</a></li>
                             </ul>
                             </div>
                             </div>
                             '>
                            <a href="#" class="text-decoration-none text-dark flex-grow-1">
                                <i class="fas fa-gamepad me-2"></i> Gaming Gear
                            </a>
                        </div>
                    </div>
                </div>


                <div class="col-12 col-md-8 col-lg-9">
                    <div class="content" data-aos="fade-left">
                        <div class="row">
                            <div class="product-grid">
                                <c:forEach var="product" items="${activeProducts}">
                                    <div class="product-card card h-100 mb-4" data-aos="zoom-in">
<!--                                        <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&id=${product.productId}" 
                                           class="stretched-link" style="position: absolute; inset: 0; z-index: 1;"></a>-->
                                        <div class="image-container">
                                            <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&id=${product.productId}">
                                                <img src="${product.imageUrl}" class="product-img card-img-top" alt="${product.name}">
                                            </a>
                                        </div>
                                        <div class="card-body text-center">
                                            <h5 class="product-name card-title">${product.name}</h5>
                                            <p class="card-text text-danger fw-bold">
                                                <fmt:formatNumber value="${product.price}" type="number" pattern="#,###" currencySymbol="" groupingUsed="true" /> VNĐ
                                            </p>
                                            <div class="d-flex justify-content-center gap-2">
                                                <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&id=${product.productId}" class="btn btn-buy text-white">Xem chi tiết</a>
                                                <button type="button" class="btn btn-cart text-white" onclick="addToCart(${product.productId}, '${product.name}')">
                                                    <i class="fas fa-shopping-cart me-1"></i>Thêm vào giỏ
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!--Footer-->                                 
        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>

        <!-- Bootstrap Bundle JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>

        <!-- Carousel Auto Init -->
        <script>
                                                    const myCarousel = document.querySelector('#bannerCarousel');
                                                    new bootstrap.Carousel(myCarousel, {
                                                        interval: 3000,
                                                        ride: 'carousel'
                                                    });
        </script>

        <!-- Add AOS JS and initialize -->
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
                                                    AOS.init();
        </script>

        <!-- JavaScript để điều chỉnh chiều cao và hiển thị mega menu -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const sidebar = document.querySelector('.sidebar');
                const megaMenu = document.querySelector('#mega-menu');
                const categoryItems = document.querySelectorAll('.category-item');

                if (sidebar && megaMenu) {
                    const sidebarHeight = sidebar.offsetHeight;
                    megaMenu.style.height = sidebarHeight + 'px';
                }

                let isMouseOverSidebar = false;
                let isMouseOverMegaMenu = false;
                let hideTimeout = null;

                function showMegaMenu(content) {
                    if (hideTimeout) {
                        clearTimeout(hideTimeout);
                        hideTimeout = null;
                    }
                    megaMenu.innerHTML = content;
                    megaMenu.style.display = 'block';
                }

                function tryHideMegaMenu() {
                    // Delay 200ms trước khi ẩn để tránh ẩn nhầm khi rê nhanh
                    hideTimeout = setTimeout(() => {
                        if (!isMouseOverSidebar && !isMouseOverMegaMenu) {
                            megaMenu.style.display = 'none';
                            megaMenu.innerHTML = '';
                        }
                    }, 200);
                }

                categoryItems.forEach(item => {
                    item.addEventListener('mouseenter', function () {
                        const megaMenuContent = this.getAttribute('data-mega-menu');
                        if (megaMenuContent) {
                            showMegaMenu(megaMenuContent);
                        }
                        isMouseOverSidebar = true;
                    });

                    item.addEventListener('mouseleave', function (event) {
                        isMouseOverSidebar = false;
                        tryHideMegaMenu();
                    });
                });

                sidebar.addEventListener('mouseenter', () => {
                    isMouseOverSidebar = true;
                    if (hideTimeout) {
                        clearTimeout(hideTimeout);
                        hideTimeout = null;
                    }
                });

                sidebar.addEventListener('mouseleave', () => {
                    isMouseOverSidebar = false;
                    tryHideMegaMenu();
                });

                megaMenu.addEventListener('mouseenter', () => {
                    isMouseOverMegaMenu = true;
                    if (hideTimeout) {
                        clearTimeout(hideTimeout);
                        hideTimeout = null;
                    }
                });

                megaMenu.addEventListener('mouseleave', () => {
                    isMouseOverMegaMenu = false;
                    tryHideMegaMenu();
                });
            });
        </script>
        <!-- Add to Cart -->
        <script>
            document.querySelectorAll('.add-to-cart').forEach(button => {
                button.addEventListener('click', function () {
                    const productId = this.getAttribute('data-product-id');
                    fetch('<%= MainControllerServlet.CARTPAGE_SERVLET %>', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: `action=<%= MainControllerServlet.ACTION_ADD_ITEMS %>&productId=${productId}&quantity=1`
                    })
                            .then(response => response.json())
                            .then(data => {
                                if (data.success) {
                                    window.location.href = '<%= ProjectPaths.HREF_TO_CARTPAGE %>';
                                } else {
                                    alert(data.message || 'Failed to add product to cart');
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('An error occurred while adding to cart');
                            });
                });
            });
        </script>  
        <!-- Toast Notification for Cart Actions -->
        <div class="position-fixed top-0 end-0 p-3" style="z-index: 11; margin-top: 80px;">
            <div id="cartToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header">
                    <i class="fas fa-shopping-cart text-success me-2"></i>
                    <strong class="me-auto">Giỏ hàng</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body" id="cartToastMessage">
                    <!-- Message will be inserted here -->
                </div>
            </div>
        </div>

        <!-- Cart JavaScript -->
        <script>
            function addToCart(productId, productName) {
                // Show loading state
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang thêm...';
                button.disabled = true;

                // Send AJAX request to add product to cart
                fetch('/Itel/cart/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'productId=' + productId + '&quantity=1'
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                showCartToast('Đã thêm "' + productName + '" vào giỏ hàng!', 'success');
                                updateCartCount(data.cartCount);
                            } else {
                                showCartToast('Lỗi: ' + data.message, 'error');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            showCartToast('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng!', 'error');
                        })
                        .finally(() => {
                            // Restore button state
                            button.innerHTML = originalText;
                            button.disabled = false;
                        });
            }

            function showCartToast(message, type) {
                const toast = document.getElementById('cartToast');
                const toastMessage = document.getElementById('cartToastMessage');
                const toastHeader = toast.querySelector('.toast-header');

                // Update message
                toastMessage.textContent = message;

                // Update styling based on type
                if (type === 'success') {
                    toast.className = 'toast';
                    toastHeader.querySelector('i').className = 'fas fa-shopping-cart text-success me-2';
                } else {
                    toast.className = 'toast';
                    toastHeader.querySelector('i').className = 'fas fa-exclamation-triangle text-danger me-2';
                }

                // Show toast
                const bootstrapToast = new bootstrap.Toast(toast);
                bootstrapToast.show();
            }

            function updateCartCount(count) {
                // Update cart count in navbar if it exists
                const cartCountElements = document.querySelectorAll('.cart-count');
                cartCountElements.forEach(element => {
                    element.textContent = count;
                    if (count > 0) {
                        element.style.display = 'inline';
                    }
                });
            }
        </script>
        <style>
            .sidebar {
                background-color: #f0f0f0;
                position: relative;
                z-index: 1000;
            }

            .content {
                background-color: #eae7e7;
            }

            body {
                background-color: #eae7e7;
                margin: 0;
                font-family: 'Roboto', sans-serif;
            }

            .banner-wrapper {
                margin-top: 5px;
                padding-top: 20px;
            }

            .carousel-inner {
                width: 100%;
            }

            .carousel-item img {
                width: 100%;
                height: auto;
                max-height: 550px;
                object-fit: contain;
                display: block;
                margin: 0 auto;
            }

            .carousel-control-prev-icon,
            .carousel-control-next-icon {
                background-color: rgba(0, 0, 0, 0.6);
                border-radius: 50%;
                width: 40px;
                height: 40px;
                background-size: 60% 60%;
                background-position: center;
                background-repeat: no-repeat;
                padding: 10px;
            }

            .carousel-control-prev:hover .carousel-control-prev-icon,
            .carousel-control-next:hover .carousel-control-next-icon {
                background-color: rgba(0, 0, 0, 0.85);
                transition: 0.3s;
            }

            /* Sidebar */
            .sidebar {
                background-color: #f0f0f0;
                position: relative; /* Đặt position: relative để làm tham chiếu cho .mega-menu */
                z-index: 1000;
            }

            .list-group-item {
                background-color: #ffffff; /* Nền trắng mặc định */
                color: #000000; /* Chữ đen mặc định */
                transition: background-color 0.3s, color 0.3s;
                border-radius: 5px; /* Thêm bo góc nếu cần giống hình */
            }

            .list-group-item a {
                color: #000000; /* Chữ đen cho liên kết */
                text-decoration: none;
                width: 100%; /* Đảm bảo <a> chiếm toàn bộ không gian */
            }

            .list-group-item i {
                color: #000000; /* Biểu tượng đen mặc định */
            }

            .list-group-item:hover {
                background-color: #66ccff; /* Nền xanh khi hover */
                color: #000000; /* Chữ đen khi hover */
            }

            .list-group-item:hover a, .list-group-item:hover i {
                color: #000000 !important; /* Đảm bảo chữ và biểu tượng đen khi hover */
            }

            /* Mega menu */
            .category-item {
                position: static; /* Không cần position: relative */
            }

            .mega-menu {
                margin-left: 10px;
                display: none;
                position: absolute;
                top: 0; /* Cố định ở đỉnh của .sidebar */
                left: 100%; /* Bên phải sidebar */
                width: 980px; /* Độ rộng cố định */
                background: #fff;
                z-index: 2000; /* Đảm bảo che phủ product-card */
                border: 1px solid #ddd;
                border-radius: 1%;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                padding: 20px;
            }

            .mega-menu-content {
                display: flex;
                justify-content: space-between;
                height: 100%;
            }

            .menu-column {
                flex: 1;
                margin-right: 20px;
            }

            .menu-column h6 {
                font-size: 14px;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .menu-column ul {
                list-style: none;
                padding: 0;
            }

            .menu-column ul li a {
                display: block;
                padding: 5px 0;
                color: #000;
                text-decoration: none;
            }

            .menu-column ul li a:hover {
                color: #007bff;
            }

            .product-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 2rem;
            }

            .image-container {
                width: 100%;
                height: 260px; /* Tăng chiều cao lên 280px */
                overflow: hidden;
                position: relative;
            }

            .product-img {
                width: 100%;
                height: 260px; /* Tăng chiều cao lên 280px */
                object-fit: cover;
                transition: transform 0.3s ease;
            }

            .product-img:hover {
                transform: scale(1.05);
            }

            .btn-buy, .btn-cart {
                background-color: #66ccff;
                border: none;
            }

            .btn-buy {
                background-color: #66c0ff; /* Màu nền bình thường */
                color: white;
                border-radius: 4px;
                padding: 6px 12px;
                transition: background-color 0.3s ease;
                border: none;
                text-align: center;
                display: inline-block;
                cursor: pointer;
                user-select: none;
            }

            .btn-buy:hover,
            .btn-buy:focus {
                background-color: #4aa6f9; /* Màu nền khi hover */
                color: white; /* Giữ chữ trắng */
                text-decoration: none; /* Không gạch chân */
                outline: none; /* Bỏ viền focus mặc định */
            }

            .btn-cart {
                background-color: #28a745;
                border: none;
                border-radius: 4px;
                padding: 6px 12px;
                transition: background-color 0.3s ease;
            }

            .btn-cart:hover,
            .btn-cart:focus {
                background-color: #218838;
                color: white;
                text-decoration: none;
                outline: none;
            }

            .product-card {
                position: relative;
                z-index: 1000;
            }

            /* Cố định layout của card-body */
            .product-card .card-body {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                height: 150px;
                padding: 10px;
            }

            /* Cố định chiều cao của tên sản phẩm */
            .product-name {
                height: 48px;
                line-height: 24px;
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                margin-bottom: 10px;
            }

            /* Giá sản phẩm */
            .card-text {
                margin-bottom: 10px;
            }

            /* Cố định vị trí các nút */
            .d-flex.justify-content-center {
                margin-top: auto;
            }

            /* Thêm CSS để khớp với giao diện trong ảnh */
            .carousel-control-next-icon,
            .carousel-control-prev-icon {
                background-color: rgba(0, 0, 0, 0.6);
                border-radius: 50%;
                width: 40px;
                height: 40px;
                background-size: 60% 60%;
                background-position: center;
                background-repeat: no-repeat;
                padding: 10px;
            }

            .carousel-control-prev:hover .carousel-control-prev-icon,
            .carousel-control-next:hover .carousel-control-next-icon {
                background-color: rgba(0, 0, 0, 0.85);
                transition: 0.3s;
            }

            .layout-3col {
                display: flex;
                justify-content: center;
                gap: 40px; /* Khoảng cách đều 2 bên */
                flex-wrap: wrap;
            }

            .left-col, .right-col {
                width: 280px;
            }

            .middle-col {
                width: 240px;
            }

            .category-link {
                text-decoration: none;
                display: block;
            }

            .category-box,
            .category-box-mid {
                background-color: #fff;
                padding: 12px 8px;
                text-align: center;
                border-radius: 12px;
                overflow: hidden;
                display: flex;
                flex-direction: column;
                justify-content: center;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .category-box {
                height: 150px;
            }

            .category-box-mid {
                height: 310px;
                align-items: center;
            }

            .category-image {
                max-width: 80px;
                max-height: 80px;
                object-fit: contain;
                margin: 6px auto 0;
            }

            .mouse-image {
                width: 80%;
                height: 250px;
                max-width: unset;
                max-height: unset;
            }

            .category-box h4,
            .category-box-mid h4 {
                font-size: 1rem;
                font-weight: 700;
                color: #000;
                margin-bottom: 6px;
            }

        </style>
    </body>
</html>