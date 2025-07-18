<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chờ chuyển khoản - Itel Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-warning text-dark">
                    <h4 class="mb-0"><i class="fas fa-university"></i> Chờ chuyển khoản ngân hàng</h4>
                </div>
                <div class="card-body">
                    <div class="alert alert-info">
                        <b>Đơn hàng của bạn đã được tạo, vui lòng chuyển khoản để hoàn tất!</b>
                    </div>
                    <h5>Thông tin chuyển khoản:</h5>
                    <ul class="list-unstyled mb-3">
                        <li><b>Ngân hàng:</b> Vietcombank (VCB)</li>
                        <li><b>Số tài khoản:</b> 0123456789</li>
                        <li><b>Chủ tài khoản:</b> NGUYEN VAN A</li>
                        <li><b>Số tiền:</b> <fmt:formatNumber value="${order.totalAmount}" pattern="#,#00"/> VNĐ</li>
                        <li><b>Nội dung chuyển khoản:</b> DH${order.orderId} hoặc số điện thoại của bạn</li>
                    </ul>
                    <div class="mb-3">
                        <b>Quét mã QR để chuyển khoản nhanh:</b><br>
                        <img src="https://img.vietqr.io/image/970436-0123456789-compact2.jpg?amount=${order.totalAmount}&addInfo=DH${order.orderId}" alt="QR chuyển khoản" class="img-fluid" style="max-width: 300px;">
                        <div class="text-muted mt-2" style="font-size: 0.95em;">* Mã QR tự động điền số tài khoản, số tiền và nội dung chuyển khoản.</div>
                    </div>
                    <div class="mb-3">
                        <form action="/Itel/bankTransferNotify" method="post">
                            <input type="hidden" name="orderId" value="${order.orderId}"/>
                            <button type="submit" class="btn btn-success btn-lg">Tôi đã chuyển khoản</button>
                        </form>
                    </div>
                    <div class="alert alert-warning mt-3">
                        <i class="fas fa-info-circle"></i> Đơn hàng sẽ được xác nhận sau khi shop nhận được tiền chuyển khoản.<br>
                        Nếu bạn đã chuyển khoản, vui lòng chờ xác nhận hoặc liên hệ hỗ trợ nếu cần gấp.
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html> 