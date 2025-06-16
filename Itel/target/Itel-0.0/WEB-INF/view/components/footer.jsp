<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Bootstrap & Font Awesome CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous"/>

<footer class="custom-footer">
    <div class="container">
        <div class="row">

            <div class="col-md-3 mb-4">
                <h5 class="fw-bold">KẾT NỐI VỚI ITEl SHOP</h5>
                <div class="d-flex gap-3 fs-5 mb-3">
                    <a href="#"><i class="fab fa-facebook-f" style="color: #1877f2;"></i></a>
                    <a href="#"><i class="fas fa-comment-dots" style="color: #25d366;"></i></a> <!-- hoặc chọn màu đại diện Zalo -->
                    <a href="#"><i class="fab fa-youtube" style="color: #ff0000;"></i></a>
                    <a href="#"><i class="fab fa-tiktok" style="color: #000000;"></i></a>
                </div>
                <h6 class="fw-bold">TỔNG ĐÀI MIỄN PHÍ</h6>
                <p class="mb-1">Tư vấn mua hàng:<br><strong>1800.9999</strong> (Nhánh 1)</p>
                <p class="mb-1">Hỗ trợ kỹ thuật:<br><strong>1800.6789</strong> (Nhánh 2)</p>
                <p class="mb-0">Góp ý, khiếu nại:<br><strong>1800.0001</strong> (8h00 - 22h00)</p>
            </div>

            <div class="col-md-3 mb-4">
                <h5 class="fw-bold">VỀ CHÚNG TÔI</h5>
                <ul class="list-unstyled">
                    <li><a href="#">Giới thiệu về công ty</a></li>
                    <li><a href="#">Quy chế hoạt động</a></li>
                    <li><a href="#">Dự án Doanh nghiệp</a></li>
                    <li><a href="#">Tin tức khuyến mại</a></li>
                    <li><a href="#">Hướng dẫn mua hàng</a></li>
                    <li><a href="#">Đại lý uỷ quyền Apple</a></li>
                    <li><a href="#">Tra cứu hoá đơn</a></li>
                    <li><a href="#">Tra cứu bảo hành</a></li>
                </ul>
            </div>

            <div class="col-md-3 mb-4">
                <h5 class="fw-bold">CHÍNH SÁCH</h5>
                <ul class="list-unstyled">
                    <li><a href="#">Chính sách bảo hành</a></li>
                    <li><a href="#">Chính sách đổi trả</a></li>
                    <li><a href="#">Chính sách bảo mật</a></li>
                    <li><a href="#">Chính sách trả góp</a></li>
                    <li><a href="#">Chính sách dữ liệu cá nhân</a></li>
                    <li><a href="#">Chính sách lắp đặt điện máy</a></li>
                </ul>
            </div>

            <div class="col-md-3 mb-4">
                <h5 class="fw-bold">HỖ TRỢ THANH TOÁN</h5>
                <div class="d-flex flex-wrap gap-3 mb-3 fs-4">
                    <i class="fab fa-cc-visa" style="color: #1a1f71;"></i>
                    <i class="fab fa-cc-mastercard" style="color: #eb001b;"></i>
                    <i class="fab fa-cc-apple-pay" style="color: #000000;"></i>
                    <i class="fab fa-cc-paypal" style="color: #003087;"></i>
                    <i class="fas fa-wallet" style="color: #4caf50;"></i>
                </div>
                <h5 class="fw-bold">CHỨNG NHẬN</h5>
                <div class="d-flex flex-wrap gap-2 fs-5">
                    <i class="fas fa-certificate" style="color: #f1c40f;"></i>
                    <i class="fas fa-shield-alt" style="color: #3498db;"></i>
                    <i class="fas fa-check-circle" style="color: #2ecc71;"></i>
                </div>
            </div>
        </div>
    </div>
</footer>

<style>
    .custom-footer {
        background: #ffffff;
        padding: 40px 0;
        font-size: 14px;
    }

    .custom-footer a {
        color: #000000;
        text-decoration: none;
        transition: color 0.3s ease;
    }

    .custom-footer a:hover {
        text-decoration: underline;
    }

    .custom-footer h5,
    .custom-footer h6 {
        color: #000000;
        font-weight: bold;
    }

    .custom-footer i {
        transition: transform 0.3s ease;
    }

    .custom-footer i:hover {
        transform: scale(1.2);
    }
</style>
