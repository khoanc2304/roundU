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

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous"/>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    </head>
    <body style="background-color: #F3F4F6; margin: 0; font-family: 'Roboto', sans-serif;">

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

                                <div class="mb-3 button-container d-flex gap-3">
                                    <form action="${pageContext.request.contextPath}/cart/add" method="post" style="flex:1;">
                                        <input type="hidden" name="productId" value="${product.productId}" />
                                        <input type="hidden" name="quantity" value="1" />
                                        <button type="submit" class="btn btn-custom-buy btn-lg w-100">Mua ngay
                                            <span class="buy-info">Giao tận nơi hoàn tiền tại cửa hàng</span>
                                        </button>
                                    </form>
                                    <button type="button" class="btn btn-outline-secondary btn-lg w-100" data-bs-toggle="modal" data-bs-target="#shareModal" style="flex:1;">Giới thiệu sản phẩm</button>
                                </div>

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

            <section class="row similar-products mt-4">
                <div class="container">
                    <div class="carousel-header d-flex justify-content-between align-items-center mb-3">
                        <h3 class="carousel-title">Sản phẩm tương tự</h3>
                        <div class="carousel-subtitle">
                            <i class="fa fa-truck text-danger me-1"></i> Trả góp 0%
                        </div>
                    </div>

                    <div class="carousel-wrapper position-relative">
                        <button class="carousel-btn left" onclick="scrollLeft()">‹</button>

                        <div class="carousel-container" id="similarCarousel">
                            <c:forEach var="entry" items="${suggestionMap}">
                                <div class="product-card">
                                    <div class="product-img-wrapper">
                                        <img src="${entry.key.imageUrl}" class="product-img" alt="product image" />
                                    </div>
                                    <div class="product-info">
                                        <div class="product-name">${entry.key.name}</div>
                                        <div class="product-specs">
                                            <c:forEach var="i" begin="0" end="4">
                                                <c:if test="${not empty attributeNames and not empty entry.value and i lt fn:length(attributeNames) and i lt fn:length(entry.value)}">
                                                    <div class="spec-item">
                                                        <strong>${attributeNames[i]}:</strong> ${entry.value[i]}
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                        <div class="product-price text-danger fw-bold mt-2">
                                            <fmt:formatNumber value="${entry.key.price}" type="number" pattern="#,###" />đ
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <button class="carousel-btn right" onclick="scrollRight()">›</button>
                    </div>
                </div>
            </section>
        </div>

        <div class="container product-container mt-3" style="background-color: #F3F4F6; padding-left: 15px; padding-right: 15px;">
            <div class="row">
                <div class="col-md-8 product-info" style="background-color: #ffffff; padding: 15px;">
                    <h3 style="font-size: 18px; font-weight: bold; margin-bottom: 10px;">Thông tin sản phẩm</h3>
                    <p style="font-size: 14px; margin-bottom: 5px;">Thông số kỹ thuật:</p>
                    <table class="spec-table">
                        <c:forEach var="entry" items="${infoProduct.entrySet()}">
                            <tr>
                                <td class="spec-key">${entry.key}</td>
                                <td class="spec-value">${entry.value}</td>
                            </tr>
                        </c:forEach>
                    </table>

                    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

                    <c:set var="title0" value="${fn:replace('Đánh giá chi tiết laptop ${name}', '${name}', product.name)}" />
                    <c:set var="title4" value="${fn:replace('Màn hình Full HD sắc nét trên ${name}', '${name}', product.name)}" />

                    <c:set var="titles" value="${[title0, 'Thiết kế mạnh mẽ đậm chất gaming', 'Bàn phím dễ thao tác', 'Cấu hình vượt trội chơi game thả ga', title4]}" />

                    <c:set var="descriptions" value="${[
                                                       'Laptop gaming MSI Katana 15 B13VEK 252VN đáp ứng mọi nhu cầu chơi game của người dùng. Được sản xuất bởi hãng MSI với phần trau chuốt kỹ lưỡng về thiết kế cũng như đầu tư từ những linh kiện hàng đầu hứa hẹn một sản phẩm tuyệt vời cho các tín đồ đam mê game, tham chiến cùng bạn bè. Hãy cùng ITEl tìm hiểu về chiếc laptop này nhé!',
                                                       'Laptop MSI Katana 15 sở hữu từng đường nét vuông vắn mạnh mẽ được bao phủ một màu đen cá tính. Phần khung được làm từ chất liệu cao cấp tạo độ cứng cáp cho toàn bộ linh kiện bên trong laptop MSI. Trọng lượng chỉ khoảng 2.25kg nên việc bỏ vào balo mang đi bất cứ đâu cũng vô cùng dễ dàng cho người dùng.',
                                                       'Bàn phím của MSI Katana 15 cho một độ nảy phím ổn định với hành trình phím sâu tạo cảm giác thoải mái cho mọi thao tác nhấn. Ngoài ra, bàn phím của MSI Katana 15 còn được trang bị hệ thống đèn nền LED 4 vùng gia tăng thêm sự mạnh mẽ cá tính đầy thu hút. Bên cạnh đó việc thao tác trong môi trường thiếu ánh sáng cũng chính xác hơn, dễ dàng đạt được mục tiêu mong muốn trong mọi hoàn cảnh. ',
                                                       'MSI Katana 15 được trang bị bộ vi xử lý Intel Core i7-13620H với xung nhịp cơ bản là 3.6GHz có thể nâng cấp tối đa lên đến 4.9 GHz. Mọi thao tác từ văn phòng cơ bản đến thiết kế nâng cao đều không thể làm khó được chiếc laptop này. Kết hợp cùng card đồ họa NVIDIA GeForce RTX 4050 đem lại trải nghiệm đồ họa đẹp mắt với tốc độ xử lý mượt mà trên mọi khung hình. Laptop MSI gaming có thể đáp ứng mọi yêu cầu khắc nghiệt của người dùng ở bất kỳ tựa game cấu hình cao như là FPS, MOBA,...',
                                                       'MSI Katana 15 có kích thước màn hình 15.6 inch Full HD, độ phân giải 1920x1080 cực sắc nét. Tốc độ xử lý nhanh chóng với độ mượt mà cao trên chiếc màn hình 144Hz làm cắt giảm hoàn toàn tình trạng giật lag và nhòe màn hình khi chơi game. Giờ đây người dùng không cần tốn nhiều thời gian đến những tiệm net chất lượng cao khi chiếc laptop gaming MSI này có thể đáp ứng đủ mọi nhu cầu sử dụng của họ tại nhà hay bất cứ đâu.'
                                                       ]}" />

                    <div class="mt-3">
                        <c:forEach var="image" items="${productImages}" varStatus="loop">
                            <div class="thumbnail-wrapper mb-4 mt-3">
                                <h5 class="fw-bold mb-4">${titles[loop.index]}</h5>

                                <img src="${image.imageUrl}" alt="Thumbnail ${loop.count}" class="product-detail-image img-fluid"
                                     onclick="changeImage(this)" data-src="${image.imageUrl}">

                                <p class="mt-3">${descriptions[loop.index]}</p>
                            </div>
                        </c:forEach>
                    </div>

                </div>

                <div class="col-md-4 product-image" style="padding-left: 15px; padding-top: 0; padding-right: 0">
                    <div style="background-color: #f5f5f5; padding: 10px; border: 1px solid #ddd; border-radius: 5px; margin-top: 0;">
                        <h3 style="font-size: 18px; font-weight: bold; margin-bottom: 10px; color: #1a0dab;">Tin tức về công nghệ</h3>
                        <ul class="news-list" style="list-style: none; padding: 0; margin: 0;">
                            <li>
                                <a href="#" style="color: #1a0dab; text-decoration: none;">
                                    <img src="${pageContext.request.contextPath}/assets/news/n1.png" alt="News 1"
                                         style="vertical-align: middle; margin-right: 10px; width: 50px; height: 35px; object-fit: cover;">
                                    Hướng dẫn cách sử dụng khoá vàng tự động Roblox trên PC và điện thoại
                                </a>
                            </li>
                            <li>
                                <a href="#" style="color: #1a0dab; text-decoration: none;">
                                    <img src="${pageContext.request.contextPath}/assets/news/n2.png" alt="News 2"
                                         style="vertical-align: middle; margin-right: 10px; width: 50px; height: 35px; object-fit: cover;">
                                    Chi tiết cách ẩn bạn bè trên Facebook trên máy tính, điện thoại nhanh chóng
                                </a>
                            </li>
                            <li>
                                <a href="#" style="color: #1a0dab; text-decoration: none;">
                                    <img src="${pageContext.request.contextPath}/assets/news/n3.png" alt="News 3"
                                         style="vertical-align: middle; margin-right: 10px; width: 50px; height: 35px; object-fit: cover;">
                                    Link nhận Spin Coin Master free, code Spin Master mới nhất 2025
                                </a>
                            </li>
                            <li>
                                <a href="#" style="color: #1a0dab; text-decoration: none;">
                                    <img src="${pageContext.request.contextPath}/assets/news/n4.png" alt="News 4"
                                         style="vertical-align: middle; margin-right: 10px; width: 50px; height: 35px; object-fit: cover;">
                                    Cách tạo Zalo không cần số điện thoại trên PC, điện thoại nhanh chóng
                                </a>
                            </li>
                            <li>
                                <a href="#" style="color: #1a0dab; text-decoration: none;">
                                    <img src="${pageContext.request.contextPath}/assets/news/n5.png" alt="News 5"
                                         style="vertical-align: middle; margin-right: 10px; width: 50px; height: 35px; object-fit: cover;">
                                    Tổng hợp 10+ app học tiếng Anh miễn phí tốt nhất cho người mới
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-3">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>
        
        <!-- Modal Giới thiệu sản phẩm -->
        <div class="modal fade" id="shareModal" tabindex="-1" aria-labelledby="shareModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="shareModalLabel">Chia sẻ sản phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <div class="input-group mb-3">
                  <input type="text" class="form-control" id="shareLink" value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/main?action=productPage&id=${product.productId}" readonly>
                  <button class="btn btn-primary" type="button" id="copyBtn">Copy</button>
                </div>
                <div id="copyMsg" class="text-success" style="display:none;">Đã copy link!</div>
              </div>
            </div>
          </div>
        </div>
        
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                AOS.init();

                const mainImage = document.getElementById('mainImage');
                const thumbnails = document.querySelectorAll('.thumbnail');
                let currentIndex = 0;

                function changeImage(thumbnail) {
                    const imageUrl = thumbnail.getAttribute('data-src');
                    mainImage.src = imageUrl;
                    currentIndex = Array.from(thumbnails).indexOf(thumbnail);
                    updateActiveThumbnail();
                }

                function updateActiveThumbnail() {
                    thumbnails.forEach(thumb => thumb.classList.remove('active'));
                    if (thumbnails[currentIndex]) {
                        thumbnails[currentIndex].classList.add('active');
                    }
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

                document.querySelector('.prev-btn').addEventListener('click', prevImage);
                document.querySelector('.next-btn').addEventListener('click', nextImage);

                thumbnails.forEach(thumb => {
                    thumb.addEventListener('click', function () {
                        changeImage(this);
                    });
                });

                if (thumbnails.length > 0) {
                    changeImage(thumbnails[0]);
                }

                window.scrollToProductInfo = function () {
                    const productInfo = document.querySelector('.product-info');
                    if (productInfo) {
                        productInfo.scrollIntoView({behavior: 'smooth'});
                    }
                };
            });
        </script>
        <script>
document.addEventListener('DOMContentLoaded', function() {
  var copyBtn = document.getElementById('copyBtn');
  var shareLink = document.getElementById('shareLink');
  var copyMsg = document.getElementById('copyMsg');
  if (copyBtn && shareLink) {
    copyBtn.onclick = function() {
      shareLink.select();
      shareLink.setSelectionRange(0, 99999);
      document.execCommand('copy');
      copyMsg.style.display = 'block';
      setTimeout(function(){ copyMsg.style.display = 'none'; }, 1500);
    };
  }
});
</script>
    </body>
    <style>
        .product-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
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
        .detail-image {
            width: 90px;
            height: 90px;
            object-fit: cover;
            cursor: pointer;
            margin: 0 15px;
            border: 2px solid #ddd;
        }
        .detail-image.active {
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
            opacity: 0;
            transition: opacity 0.3s ease;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: rgba(0, 0, 0, 0.5);
            color: white;
        }
        .nav-btn:hover {
            opacity: 1;
        }
        .image-wrapper:hover .nav-btn {
            opacity: 1;
        }
        .prev-btn {
            left: 30px;
        }
        .next-btn {
            right: 30px;
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
            background-color: #ffffff !important;
            border-radius: 1px;
            padding: 15px;
            border: 1px solid #dee2e6;
        }
        .promotion-section {
            border: 1px solid #dee2e6;
            border-radius: 5px;
            overflow: hidden;
        }
        .promotion-section p {
            background-color: #f8f9fa;
            margin: 0;
            padding: 10px;
            font-weight: bold;
        }
        .alert-custom {
            background-color: #e5f6f8;
            color: #333333;
            border-color: #c3e6cb;
            border-radius: 5px;
            padding: 10px;
        }
        .button-container {
            display: flex;
            justify-content: space-between;
            width: 100%;
            align-items: center;
        }
        .btn-custom-buy {
            background-color: #BAE7FB;
            color: #000000;
            border-color: #6c757d;
            padding: 8px 20px;
            font-weight: bold;
            width: 48%;
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            height: 60px;
            line-height: 1;
        }
        .btn-custom-buy:hover {
            transform: scale(1.05);
            color: inherit;
            border-color: inherit;
        }
        .btn-custom-buy .buy-info {
            font-size: 12px;
            color: #000000;
            margin-top: 3px;
            width: 100%;
        }
        .buy-info {
            padding-top: 5px;
        }
        .btn-outline-secondary {
            background-color: #BAE7FB;
            color: #000000;
            border-color: #6c757d;
            padding: 10px 20px;
            width: 48%;
            text-align: center;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .btn-outline-secondary:hover {
            transform: scale(1.05);
            background-color: #BAE7FB !important;
            color: inherit;
            border-color: inherit;
        }
        .similar-products {
            background-color: #ffffff;
            padding: 20px;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            margin-top: 20px;
        }
        .similar-products .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .similar-products .section-title {
            background-color: #ffffff;
            color: #000000;
            padding: 10px 10px;
            font-weight: bold;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .product-card {
            border: 1px solid #dee2e6;
            border-radius: 5px;
            background-color: #ffffff;
        }
        .product-card:hover {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transform: scale(1.02);
            transition: all 0.3s ease;
        }
        .product-card img {
            width: 100%;
            height: auto;
        }
        .col-md-3 {
            margin-bottom: 20px;
        }
        .product-info {
            padding-right: 15px;
            border-radius: 4px;
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
        .news-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .news-list li {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .news-list li a {
            display: flex;
            align-items: center;
            text-decoration: none;
            color: #000;
            font-size: 14px;
            transition: color 0.2s ease;
        }
        .news-list li a:hover {
            color: #007bff;
        }
        .news-list img {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 5px;
            margin-right: 10px;
        }
        .news-list span {
            line-height: 1.4;
        }
        .product-detail-image {
            display: block;
            margin: 0 auto;
            width: 440px;
            height: 330px;
            object-fit: cover;
            cursor: pointer;
        }
        .product-detail-image.active {
            border-color: #007bff;
        }
        .product-info {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .section-title {
            font-size: 22px;
            font-weight: 600;
            color: #1a0dab;
            margin-bottom: 15px;
            padding-bottom: 8px;
            border-bottom: 2px solid #e0e0e0;
        }

        .info-subtitle {
            font-size: 16px;
            font-weight: 500;
            color: #333;
            margin-bottom: 10px;
        }

        .spec-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .spec-table tr {
            border-bottom: 1px solid #e0e0e0;
        }

        .spec-table tr:last-child {
            border-bottom: none;
        }

        .spec-key {
            width: 30%;
            padding: 12px 15px;
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
            vertical-align: top;
            border-right: 1px solid #e0e0e0;
        }

        .spec-value {
            padding: 12px 15px;
            color: #444;
            vertical-align: top;
        }

        .section-subtitle {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 12px;
        }

        .description-text {
            font-size: 15px;
            line-height: 1.6;
            color: #444;
            margin-bottom: 20px;
        }

        .product-detail-image {
            width: 440px;
            height: 330px;
            object-fit: cover;
            border-radius: 4px;
            cursor: pointer;
            margin: 0 auto;
            display: block;
        }
        
        
        /*        HUY*/
        /* Section container */
        .similar-products {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 48px 0;
            margin: 40px 0;
            position: relative;
            overflow: hidden;
        }

        .similar-products::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(0,0,0,0.1), transparent);
        }

        /* Container */
        .container {
            max-width: 1240px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Carousel header */
        .carousel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            padding: 0 20px;
        }

        .carousel-title {
            font-size: 2rem;
            font-weight: 700;
            color: #212529;
            margin: 0;
            position: relative;
            letter-spacing: -0.5px;
        }

        .carousel-title::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 60px;
            height: 3px;
            background: linear-gradient(90deg, #dc3545, #fd7e14);
            border-radius: 2px;
        }

        .carousel-subtitle {
            font-size: 0.9rem;
            font-weight: 600;
            color: #dc3545;
            display: flex;
            align-items: center;
            gap: 6px;
            background: rgba(220, 53, 69, 0.1);
            padding: 8px 16px;
            border-radius: 20px;
            border: 1px solid rgba(220, 53, 69, 0.2);
        }

        /* Carousel wrapper */
        .carousel-wrapper {
            position: relative;
            padding: 0 60px;
        }

        /* Carousel buttons */
        .carousel-btn {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: #ffffff;
            border: 2px solid #e9ecef;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            font-size: 1.5rem;
            color: #495057;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            z-index: 10;
            user-select: none;
        }

        .carousel-btn.left {
            left: 10px;
        }

        .carousel-btn.right {
            right: 10px;
        }

        .carousel-btn:hover {
            background: #dc3545;
            color: white;
            border-color: #dc3545;
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.3);
            transform: translateY(-50%) scale(1.05);
        }

        .carousel-btn:active {
            transform: translateY(-50%) scale(0.95);
        }

        .carousel-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            background: #f8f9fa;
            color: #6c757d;
        }

        .carousel-btn:disabled:hover {
            background: #f8f9fa;
            color: #6c757d;
            transform: translateY(-50%);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        /* Carousel container */
        .carousel-container {
            display: flex;
            gap: 20px;
            overflow: hidden;
            padding: 20px 0;
            position: relative;

            overflow-x: hidden;
            scroll-behavior: smooth;
            scroll-snap-type: x mandatory;
        }

        .carousel-track {
            display: flex;
            gap: 20px;
            transition: transform 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            will-change: transform;
        }

        /* Product card */
.product-card {
    flex: 0 0 280px;
    height: 450px;
    background: #ffffff;
    border: 1px solid #e9ecef;
    border-radius: 16px;
    padding: 20px;
    transition: all 0.3s ease;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    box-sizing: border-box;
    position: relative;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    scroll-snap-align: start;
}

.product-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    background: linear-gradient(90deg, #dc3545, #fd7e14);
    transform: scaleX(0);
    transform-origin: left;
    transition: transform 0.3s ease;
}

.product-card:hover::before {
    transform: scaleX(1);
}

.product-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12);
    border-color: #dc3545;
}

/* Product image wrapper */
.product-img-wrapper {
    width: 100%;
    height: 240px;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 10px;
    background-color: #ffffff;
    border-radius: 12px;
    overflow: hidden;
    position: relative;
}

/* Product image */
.product-img {
    width: 100%;
    height: 100%;
    object-fit: contain !important; /* Override mọi nơi khác */
    object-position: center;
    display: block;
    transition: transform 0.3s ease;
}

/* Hover effect */
.product-card:hover .product-img {
    transform: scale(1.05); /* Nhẹ nhàng không phá bố cục */
}



        /* Product info */
        .product-info {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .product-name {
            font-size: 1rem;
            font-weight: 600;
            color: #212529;
            line-height: 1.4;
            min-height: 50px;
            margin-bottom: 12px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            transition: color 0.3s ease;
        }

        .product-card:hover .product-name {
            color: #dc3545;
        }

        .product-specs {
            flex-grow: 1;
            font-size: 0.85rem;
            color: #6c757d;
            line-height: 1.6;
            margin-bottom: 12px;
        }

        .spec-item {
            margin-bottom: 6px;
            padding: 4px 0;
            border-bottom: 1px solid #f8f9fa;
        }

        .spec-item:last-child {
            border-bottom: none;
        }

        .spec-item strong {
            font-weight: 600;
            color: #495057;
        }

        .product-price {
            font-size: 1.2rem;
            font-weight: 700;
            color: #dc3545;
            margin-top: 12px;
            padding: 8px 0;
            border-top: 2px solid #f8f9fa;
            position: relative;
        }

        .product-price::before {
            content: '';
            position: absolute;
            top: -2px;
            left: 0;
            width: 40px;
            height: 2px;
            background: #dc3545;
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-price::before {
            transform: scaleX(1);
        }

        /* Indicators */
        .carousel-indicators {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-top: 20px;
        }

        .indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #dee2e6;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .indicator.active {
            background: #dc3545;
            transform: scale(1.2);
        }





    </style>




    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const carousel = document.getElementById("similarCarousel");
            const cards = carousel?.querySelectorAll(".product-card");
            if (!carousel || !cards.length)
                return;

            const gap = parseInt(getComputedStyle(carousel).gap) || 20;
            const cardWidth = cards[0].offsetWidth + gap;

            document.querySelector(".carousel-btn.left").addEventListener("click", function () {
                carousel.scrollBy({left: -cardWidth, behavior: "smooth"});
            });

            document.querySelector(".carousel-btn.right").addEventListener("click", function () {
                carousel.scrollBy({left: cardWidth, behavior: "smooth"});
            });
        });
    </script>

    </style>
</html>