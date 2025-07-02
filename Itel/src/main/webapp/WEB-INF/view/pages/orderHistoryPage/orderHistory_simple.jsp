<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đơn hàng của tôi - Itel Shop</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .content {
                padding-top: 150px;
                min-height: 80vh;
            }
            .order-card {
                transition: transform 0.2s ease;
                border-radius: 10px;
                margin-bottom: 20px;
            }
            .order-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .status-pending { border-left: 4px solid #ffc107; }
            .status-confirmed { border-left: 4px solid #17a2b8; }
            .status-shipping { border-left: 4px solid #007bff; }
            .status-delivered { border-left: 4px solid #28a745; }
            .status-reviewed { border-left: 4px solid #6c757d; }
        </style>
    </head>
    <body>
        <!-- Navbar -->
        <div>
            <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>
        </div>

        <div class="content container mt-5">
            <div class="row">
                <div class="col-12">
                    <h2><i class="fas fa-receipt"></i> Đơn hàng của tôi</h2>
                    <p class="text-muted">Theo dõi và quản lý đơn hàng của bạn</p>
                    <hr>
                </div>
            </div>

            <!-- Order Status Summary -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card text-center border-warning">
                        <div class="card-body">
                            <i class="fas fa-clock fa-2x text-warning mb-2"></i>
                            <h5>Chờ xác nhận</h5>
                            <h3 class="text-warning" id="pendingCount">0</h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center border-info">
                        <div class="card-body">
                            <i class="fas fa-box fa-2x text-info mb-2"></i>
                            <h5>Chờ giao hàng</h5>
                            <h3 class="text-info" id="confirmedCount">0</h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center border-success">
                        <div class="card-body">
                            <i class="fas fa-truck fa-2x text-success mb-2"></i>
                            <h5>Đã giao</h5>
                            <h3 class="text-success" id="deliveredCount">0</h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center border-secondary">
                        <div class="card-body">
                            <i class="fas fa-star fa-2x text-secondary mb-2"></i>
                            <h5>Đánh giá</h5>
                            <h3 class="text-secondary" id="reviewedCount">0</h3>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Orders List -->
            <div class="row">
                <div class="col-12">
                    <div id="ordersContainer">
                        <div class="text-center py-4">
                            <div class="spinner-border text-primary" role="status"></div>
                            <p class="mt-2">Đang tải đơn hàng...</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            let orders = [];
            
            document.addEventListener('DOMContentLoaded', function() {
                loadOrders();
            });
            
            function loadOrders() {
                fetch('/Itel/api/orders')
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            orders = data.orders;
                            displayOrders();
                        } else {
                            showError(data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showError('Có lỗi xảy ra khi tải đơn hàng');
                    });
            }
            
            function displayOrders() {
                const container = document.getElementById('ordersContainer');
                
                if (!orders || orders.length === 0) {
                    container.innerHTML = `
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                            <h5 class="text-muted">Không có đơn hàng nào</h5>
                            <a href="/Itel/main?action=homePage" class="btn btn-primary">Mua sắm ngay</a>
                        </div>
                    `;
                    return;
                }
                
                let html = '';
                let statusCounts = { PENDING: 0, CONFIRMED: 0, SHIPPING: 0, DELIVERED: 0, REVIEWED: 0 };
                
                orders.forEach(order => {
                    if (order.orderDetails && order.orderDetails.length > 0) {
                        order.orderDetails.forEach(detail => {
                            const status = detail.status || 'PENDING';
                            statusCounts[status]++;
                            
                            html += generateOrderCard(order, detail);
                        });
                    }
                });
                
                container.innerHTML = html;
                updateCounts(statusCounts);
            }
            
            function generateOrderCard(order, detail) {
                const statusClass = 'status-' + (detail.status || 'pending').toLowerCase();
                const statusText = getStatusText(detail.status);
                
                return `
                    <div class="card order-card ${statusClass}">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div>
                                <strong>Đơn hàng #${order.orderId}</strong>
                                <small class="text-muted ms-2">${formatDate(order.orderDate)}</small>
                            </div>
                            <span class="badge bg-primary">${statusText}</span>
                        </div>
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-md-2">
                                    <img src="${detail.product.imageUrl}" class="img-fluid rounded" 
                                         alt="${detail.product.name}" style="height: 80px; object-fit: cover;"
                                         onerror="this.src='https://via.placeholder.com/80x80?text=No+Image'">
                                </div>
                                <div class="col-md-6">
                                    <h6 class="mb-1">${detail.product.name}</h6>
                                    <p class="text-muted mb-1">Số lượng: ${detail.quantity}</p>
                                    <p class="text-muted mb-0">Giá: ${formatCurrency(detail.unitPrice)} VNĐ</p>
                                </div>
                                <div class="col-md-2 text-end">
                                    <h5 class="text-primary">${formatCurrency(detail.unitPrice * detail.quantity)} VNĐ</h5>
                                </div>
                                <div class="col-md-2 text-end">
                                    ${generateActionButton(detail.status, order.orderId, detail.orderDetailId)}
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            }
            
            function getStatusText(status) {
                const statusMap = {
                    'PENDING': 'Chờ xác nhận',
                    'CONFIRMED': 'Đã xác nhận', 
                    'SHIPPING': 'Đang giao hàng',
                    'DELIVERED': 'Đã giao',
                    'REVIEWED': 'Đã đánh giá'
                };
                return statusMap[status] || 'Chờ xác nhận';
            }
            
            function generateActionButton(status, orderId, detailId) {
                switch(status) {
                    case 'PENDING':
                        return `<button class="btn btn-outline-danger btn-sm" onclick="cancelOrder(${orderId}, ${detailId})">
                                    <i class="fas fa-times"></i> Hủy đơn
                                </button>`;
                    case 'CONFIRMED':
                    case 'SHIPPING':
                        return `<button class="btn btn-outline-primary btn-sm" onclick="trackOrder(${orderId}, ${detailId})">
                                    <i class="fas fa-map-marker-alt"></i> Theo dõi
                                </button>`;
                    case 'DELIVERED':
                        return `<button class="btn btn-primary btn-sm" onclick="writeReview(${orderId}, ${detailId})">
                                    <i class="fas fa-star"></i> Đánh giá
                                </button>`;
                    default:
                        return '';
                }
            }
            
            function updateCounts(counts) {
                document.getElementById('pendingCount').textContent = counts.PENDING || 0;
                document.getElementById('confirmedCount').textContent = (counts.CONFIRMED || 0) + (counts.SHIPPING || 0);
                document.getElementById('deliveredCount').textContent = counts.DELIVERED || 0;
                document.getElementById('reviewedCount').textContent = counts.REVIEWED || 0;
            }
            
            function formatDate(dateString) {
                return new Date(dateString).toLocaleDateString('vi-VN');
            }
            
            function formatCurrency(amount) {
                return new Intl.NumberFormat('vi-VN').format(amount);
            }
            
            function cancelOrder(orderId, detailId) {
                if (confirm('Bạn có chắc muốn hủy sản phẩm này?')) {
                    alert('Chức năng hủy đơn đang được phát triển');
                }
            }
            
            function trackOrder(orderId, detailId) {
                alert('Chức năng theo dõi đơn hàng đang được phát triển');
            }
            
            function writeReview(orderId, detailId) {
                alert('Chức năng đánh giá đang được phát triển');
            }
            
            function showError(message) {
                document.getElementById('ordersContainer').innerHTML = `
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle"></i> ${message}
                    </div>
                `;
            }
        </script>
    </body>
</html>
