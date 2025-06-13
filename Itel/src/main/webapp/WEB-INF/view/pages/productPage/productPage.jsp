<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Detail Page</title>

        <!-- Bootstrap 5.3 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous"/>

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <!-- Add AOS CSS -->
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    </head>
    <body style="background-color: #e1dbdb; margin: 0; font-family: 'Roboto', sans-serif;">

        <!-- Navbar (optional) -->
        <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>

        <div class="container product-container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-12 p-0">
                    <div class="card shadow-sm" style="border-radius: 5px; background-color: #ffffff; padding: 30px;">
                        <div class="row">
                            <div class="col-md-6 product-image" data-aos="fade-right">
                                <div class="image-wrapper">
                                    <button class="nav-btn prev-btn" onclick="prevImage()">❮</button>
                                    <img src="${productImages[0].imageUrl}" alt="Main Image" class="main-image" id="mainImage">
                                    <button class="nav-btn next-btn" onclick="nextImage()">❯</button>
                                </div>

                                <div class="text-center mt-3 thumbnail-container">
                                    <c:forEach var="image" items="${productImages}" varStatus="loop">
                                        <img src="${image.imageUrl}" alt="Thumbnail ${loop.count}" class="thumbnail" onclick="changeImage(this)" data-src="${image.imageUrl}">
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="col-md-6 product-detail" data-aos="fade-left">
                                <h2 class="fw-bold">${product.name}</h2>

                                <p class="text-muted mb-2">0.0★ - Hiện tại không có đánh giá</p>

                                <h3 class="price mb-2" style="padding-bottom: 20px; padding-top: 15px">
                                    <fmt:formatNumber value="${product.price}" type="number" pattern="#,###" />đ
                                    <span class="original-price text-decoration-line-through text-secondary ms-2">99.999.999đ</span>
                                    <span class="discount text-success ms-2">(-20%)</span>
                                </h3>

                                <div class="alert alert-custom mb-3" role="alert">
                                    <strong>Quà tặng khuyến mãi:</strong><br><br> Tặng ngay 1x Bàn Tản Nhiệt Cooler Master NotePal C3 trị giá 230.000đ
                                </div>

                                <div class="mb-3 button-container">
                                    <button class="btn btn-custom-buy btn-lg me-2">Mua ngay
                                        <span class="buy-info">Giao tận nơi hoàn tiền tại cửa hàng</span>
                                    </button>
                                    <button class="btn btn-outline-secondary btn-lg" onclick="scrollToProductInfo()">Giới thiệu sản phẩm</button>                                </div>
                                <hr class="my-3">

                                <div class="mt-3">
                                    <p><strong>Quà tặng:</strong> <i class="fas fa-gift text-warning"></i> Balo Acer SUV</p>
                                    <hr class="my-3">
                                    <ul class="list-unstyled mt-2">
                                        <li><i class="fas fa-check text-success"></i> Bảo hành chân chính hàng 24 tháng.</li>
                                        <li><i class="fas fa-check text-success"></i> Hỗ trợ đổi mới trong 7 ngày.</li>
                                        <li><i class="fas fa-check text-success"></i> Windows bản quyền tích hợp.</li>
                                        <li><i class="fas fa-check text-success"></i> Miễn phí giao hàng toàn quốc.</li>
                                    </ul>
                                </div>
                                <hr class="my-3">

                                <div class="mt-3 promotion-section">
                                    <p><strong>Khuyến mãi</strong></p>
                                    <div class="bg-light p-3 rounded">
                                        <ul class="list-unstyled">
                                            <li><i class="fas fa-check text-success"></i> Giảm 10% (tối đa 200.000đ) khi mua Gaming Gear ASUS kèm với Laptop. (Xem thêm)</li>
                                            <li><i class="fas fa-check text-success"></i> Ứu đãi 500.000đ khi nâng cấp RAM cho Laptop Gaming. (Xem thêm)</li>
                                        </ul>
                                    </div>
                                </div>
                                <hr class="my-3">

                                <div class="mt-3">
                                    <p><strong>Showroom HCM</strong></p>
                                    <ul class="list-unstyled">
                                        <li><i class="fas fa-map-marker-alt text-primary"></i> 999-1000-1001 Hoàng Hoa Thám, P.12, Q. Tân Bình, TP.HCM</li>
                                        <li><i class="fas fa-map-marker-alt text-primary"></i> 1234 Trần Hưng Đạo, P.5, Q.5, TP.HCM</li>
                                        <li><i class="fas fa-map-marker-alt text-primary"></i> 987 Nguyễn Cư Trí, P.17, Q. Bình Thạnh, TP.HCM <span class="text-danger">New!</span></li>
                                    </ul>
                                </div>
                                <hr class="my-3">

                                <div class="mt-3">
                                    <p><strong>Showroom DN</strong></p>
                                    <ul class="list-unstyled">
                                        <li><i class="fas fa-map-marker-alt text-primary"></i> 999 Lê Văn Hiến, P.Hoà Hải, Q.Ngũ Hành Sơn, TP.Đà Nẵng</li>
                                        <li><i class="fas fa-map-marker-alt text-primary"></i> 789 Nguyễn Hữu Thọ, P.Hoà Thuận Tây, Q.Hải Châu, TP.Đà Nẵng</li>
                                        <li><i class="fas fa-map-marker-alt text-primary"></i> 1111 Điện Biên Phủ, P.An Khê, Q.Thanh Khê, TP.Đà Nẵng</li>
                                    </ul>
                                </div>
                                <hr class="my-3">

                                <div class="mt-3">
                                    <p><strong>Showroom HN</strong></p>
                                    <ul class="list-unstyled">
                                        <li><i class="fas fa-map-marker-alt text-primary"></i> 99-100-101 Thái Hà, P. Trung Liệt, Q.Đống Đa, Hà Nội</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sản pDhẩm tương tự -->
            <section class="row similar-products mt-4">
                <div class="container">
                    <h3 class="section-title">Sản phẩm tương tự</h3>
                </div>
            </section>
        </div>

        <div class="container product-container mt-4" style="background-color: #e1dbdb; padding-left: 15px; padding-right: 15px;">
            <div class="row">
                <div class="col-md-8 product-info" style="background-color: #ffffff; padding: 15px;">
                    <h3 style="font-size: 18px; font-weight: bold; margin-bottom: 10px;">Thông tin sản phẩm</h3>
                    <p style="font-size: 14px; margin-bottom: 5px;">Thông số kỹ thuật:</p>
                    <table style="width: 100%; font-size: 14px; border-collapse: collapse;">
                        <c:forEach var="entry" items="${infoProduct.entrySet()}">
                            <tr>
                                <td style="padding: 5px; border: 1px solid #ddd;"><strong>${entry.key}</strong></td>
                                <td style="padding: 5px; border: 1px solid #ddd;">${entry.value}</td>
                            </tr>
                        </c:forEach>

                    </table>
                </div>

                <div class="col-md-4 product-image" style="padding-left: 15px; padding-top: 0; padding-right: 0">
                    <div style="background-color: #f5f5f5; padding: 10px; border: 1px solid #ddd; border-radius: 5px; margin-top: 0;">
                        <h3 style="font-size: 18px; font-weight: bold; margin-bottom: 10px; color: #1a0dab;">Tin tức về công nghệ</h3>
                        <ul style="list-style: none; padding: 0; margin: 0;">
                            <li style="margin-bottom: 5px;"><a href="#" style="color: #1a0dab; text-decoration: none;"><img src="https://via.placeholder.com/50x50" alt="News 1" style="vertical-align: middle; margin-right: 10px;">Hướng dẫn cách sử dụng khoá vàng tự động Roblox trên PC và điện thoại</a></li>
                            <li style="margin-bottom: 5px;"><a href="#" style="color: #1a0dab; text-decoration: none;"><img src="https://via.placeholder.com/50x50" alt="News 2" style="vertical-align: middle; margin-right: 10px;">Chi tiết cách ẩn bạn bè trên Facebook trên máy tính, điện thoại nhanh chóng</a></li>
                            <li style="margin-bottom: 5px;"><a href="#" style="color: #1a0dab; text-decoration: none;"><img src="https://via.placeholder.com/50x50" alt="News 3" style="vertical-align: middle; margin-right: 10px;">Link nhận Spin Coin Master free, code Spin Master mới nhất 2025</a></li>
                            <li style="margin-bottom: 5px;"><a href="#" style="color: #1a0dab; text-decoration: none;"><img src="https://via.placeholder.com/50x50" alt="News 4" style="vertical-align: middle; margin-right: 10px;">Cách tạo Zalo không cần số điện thoại trên PC, điện thoại nhanh chóng</a></li>
                            <li style="margin-bottom: 5px;"><a href="#" style="color: #1a0dab; text-decoration: none;"><img src="https://via.placeholder.com/50x50" alt="News 5" style="vertical-align: middle; margin-right: 10px;">Tổng hợp 10+ app học tiếng Anh miễn phí tốt nhất cho người mới</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
                                        document.addEventListener('DOMContentLoaded', function () {
                                            AOS.init();

                                            let currentIndex = 0;
                                            const thumbnails = document.querySelectorAll('.thumbnail');
                                            const mainImage = document.getElementById('mainImage');

                                            function changeImage(thumbnail) {
                                                mainImage.src = thumbnail.getAttribute('data-src');
                                                currentIndex = Array.from(thumbnails).indexOf(thumbnail);
                                                updateActiveThumbnail();
                                            }

                                            function updateActiveThumbnail() {
                                                thumbnails.forEach(img => img.classList.remove('active'));
                                                thumbnails[currentIndex].classList.add('active');
                                            }

                                            function prevImage() {
                                                currentIndex = (currentIndex > 0) ? currentIndex - 1 : thumbnails.length - 1;
                                                mainImage.src = thumbnails[currentIndex].getAttribute('data-src');
                                                updateActiveThumbnail();
                                            }

                                            function nextImage() {
                                                currentIndex = (currentIndex < thumbnails.length - 1) ? currentIndex + 1 : 0;
                                                mainImage.src = thumbnails[currentIndex].getAttribute('data-src');
                                                updateActiveThumbnail();
                                            }

                                            // Set the first thumbnail as active and load its image
                                            if (thumbnails.length > 0) {
                                                thumbnails[0].classList.add('active');
                                                mainImage.src = thumbnails[0].getAttribute('data-src');
                                            }

                                            // Hàm cuộn đến product info
                                            window.scrollToProductInfo = function () {
                                                const productInfo = document.getElementById('productInfo');
                                                if (productInfo) {
                                                    productInfo.scrollIntoView({behavior: 'smooth'});
                                                }
                                            };
                                        });
        </script>
    </body>
    <style>
        .product-container {
            max-width: 1200px;
            margin: 0 auto; /* Căn giữa */
            padding: 0 15px; /* Đảm bảo có padding đều */
        }
        .card {
            border: none;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .main-image {
            width: 400px;
            height: 350px;
            object-fit: cover;
            padding: 0;
            display: block;
            margin: 0 auto;
        }
        .image-wrapper {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .thumbnail-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .thumbnail {
            width: 90px;
            height: 90px;
            object-fit: cover;
            cursor: pointer;
            margin: 0 15px;
            border: 2px solid #ddd;
        }
        .thumbnail.active {
            border-color: #007bff;
        }
        .nav-btn {
            font-size: 24px;
            background: none;
            border: none;
            cursor: pointer;
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            z-index: 1;
            opacity: 0; /* Ẩn mặc định */
            transition: opacity 0.3s ease; /* Hiệu ứng chuyển đổi mượt mà */
            width: 40px;
            height: 40px;
            border-radius: 50%; /* Viền tròn */
            background-color: rgba(0, 0, 0, 0.5); /* Nền mờ khi hover */
            color: white;
        }
        .nav-btn:hover {
            opacity: 1; /* Hiển thị khi hover */
        }
        .image-wrapper:hover .nav-btn {
            opacity: 1; /* Hiển thị nút khi hover vào image-wrapper */
        }
        .prev-btn {
            left: 30px; /* Nút gần main-image */
        }
        .next-btn {
            right: 30px; /* Nút gần main-image */
        }
        .product-image {
            text-align: center;
        }
        .price {
            color: #dc3545;
            font-size: 34px;
            font-weight: bold;
        }
        .original-price {
            color: #6c757d;
            font-size: 20px;
        }
        .discount {
            color: #28a745;
            font-size: 20px;
        }
        .product-detail {
            padding-left: 30px;
        }
        .product-detail h2 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .btn-warning {
            background-color: #ffc107;
            border-color: #ffc107;
            padding: 10px 20px;
        }
        .btn-warning:hover {
            background-color: #e0a800;
            border-color: #e0a800;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #dc3545;
            border-color: #f5c6cb;
            padding: 10px;
            border-radius: 5px;
        }
        .text-success {
            color: #28a745 !important;
        }
        .text-primary {
            color: #007bff !important;
        }
        .list-unstyled li {
            margin-bottom: 5px;
        }
        .text-danger {
            color: #dc3545 !important;
        }
        .form-check-label {
            margin-left: 5px;
        }
        .bg-light {
            background-color: #ffffff !important; /* Màu trắng giống phần bên dưới */
            border-radius: 1px;
            padding: 15px;
            border: 1px solid #dee2e6; /* Viền mỏng bao quanh */
        }
        .promotion-section {
            border: 1px solid #dee2e6; /* Viền bao quanh toàn bộ */
            border-radius: 5px;
            overflow: hidden; /* Đảm bảo viền bo tròn áp dụng cho cả nội dung */
        }

        .promotion-section p {
            background-color: #f8f9fa; /* Màu xám nhạt cho tiêu đề */
            margin: 0;
            padding: 10px;
            font-weight: bold;
        }
        .alert-custom {
            background-color: #e5f6f8; /* Màu xanh nhạt */
            color: #333333; /* Màu chữ đậm hơn để tương phản */
            border-color: #c3e6cb; /* Viền xanh nhạt */
            border-radius: 5px;
            padding: 10px;
        }
        .button-container {
            display: flex;
            justify-content: space-between; /* Chia đều không gian */
            width: 100%; /* Chiếm trọn nguyên row */
            align-items: center;
        }

        .btn-custom-buy {
            background-color: #BAE7FB; /* Màu vàng như ảnh */
            color: #000000; /* Màu chữ đen */
            border-color: #6c757d;
            padding: 8px 20px; /* Giảm padding để ngắn lại */
            font-weight: bold;
            width: 48%; /* Chia đôi không gian */
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            height: 60px; /* Đặt chiều cao cố định */
            line-height: 1; /* Điều chỉnh dòng chữ */
        }

        .btn-custom-buy:hover {
            transform: scale(1.05); /* Chỉ thay đổi kích thước khi hover */
            background-color: #BAE7FB !important; /* Bỏ màu nền */
            color: inherit; /* Giữ nguyên màu chữ */
            border-color: inherit; /* Giữ nguyên màu viền */
        }

        .btn-custom-buy .buy-info {
            font-size: 12px; /* Kích thước chữ nhỏ hơn cho dòng thông tin */
            color: #000000; /* Màu đỏ */
            margin-top: 3px; /* Giảm khoảng cách để ngắn lại */
            width: 100%;
        }
        .buy-info{
            padding-top:5px;
        }
        .btn-outline-secondary {
            background-color: #BAE7FB;
            color: #000000; /* Màu chữ đen */
            border-color: #6c757d;
            padding: 10px 20px; /* Giữ padding mặc định */
            width: 48%; /* Chia đôi không gian */
            text-align: center;
            height: 60px; /* Đặt chiều cao cố định để đồng đều */
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-outline-secondary:hover {
            transform: scale(1.05); /* Chỉ thay đổi kích thước khi hover */
            background-color: #BAE7FB !important; /* Bỏ màu nền */
            color: inherit; /* Giữ nguyên màu chữ */
            border-color: inherit; /* Giữ nguyên màu viền */
        }
        /* Sản phẩm tương tự */
        .similar-products {
            background-color: #ffffff; /* Nền trắng */
            padding: 20px; /* Khoảng cách từ viền đến nội dung */
            border: 1px solid #dee2e6; /* Viền màu xám */
            border-radius: 5px; /* Bo tròn góc */
            margin-top: 20px; /* Khoảng cách từ phần trên */
        }

        .similar-products .container {
            max-width: 1200px; /* Đặt chiều rộng tối đa */
            margin: 0 auto; /* Căn giữa */
        }

        .similar-products .section-title {
            background-color: #ffffff; /* Nền trắng */
            color: #000000; /* Màu chữ đen */
            padding: 10px 10px; /* Khoảng cách bên trong */
            font-weight: bold; /* Chữ đậm */
            border-radius: 5px; /* Bo tròn viền */
            margin-bottom: 20px; /* Khoảng cách phía dưới */
        }

        .product-card {
            border: 1px solid #dee2e6; /* Viền xung quanh */
            border-radius: 5px; /* Bo tròn viền */
            background-color: #ffffff; /* Nền trắng */
        }

        .product-card:hover {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Bóng mờ */
            transform: scale(1.02); /* Phóng to khi hover */
            transition: all 0.3s ease; /* Hiệu ứng mượt mà */
        }
        .product-card img {
            width: 100%; /* Làm cho ảnh tự co giãn với kích thước của card */
            height: auto;
        }
        .col-md-3 {
            margin-bottom: 20px; /* Khoảng cách giữa các cột sản phẩm */
        }
        .product-info {
            padding-right: 15px;
        }
        .product-info h3 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .product-info ul {
            font-size: 16px;
        }
        .product-info ul ul {
            margin-left: 20px;
        }
        .product-image {
            text-align: center;
        }
    </style>
</html>