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

            <!-- Order Status Tabs -->
            <div class="row">
                <div class="col-12">
                    <ul class="nav nav-pills order-status-tabs mb-4" id="orderStatusTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="pending-tab" data-bs-toggle="pill" data-bs-target="#pending" type="button" role="tab">
                                <i class="fas fa-clock"></i>
                                <span>Chờ xác nhận</span>
                                <span class="badge bg-warning ms-2" id="pendingCount">0</span>
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="confirmed-tab" data-bs-toggle="pill" data-bs-target="#confirmed" type="button" role="tab">
                                <i class="fas fa-box"></i>
                                <span>Chờ giao hàng</span>
                                <span class="badge bg-info ms-2" id="confirmedCount">0</span>
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="delivered-tab" data-bs-toggle="pill" data-bs-target="#delivered" type="button" role="tab">
                                <i class="fas fa-truck"></i>
                                <span>Đã giao</span>
                                <span class="badge bg-success ms-2" id="deliveredCount">0</span>
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="reviewed-tab" data-bs-toggle="pill" data-bs-target="#reviewed" type="button" role="tab">
                                <i class="fas fa-star"></i>
                                <span>Đánh giá</span>
                                <span class="badge bg-secondary ms-2" id="reviewedCount">0</span>
                            </button>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Tab Content -->
            <div class="tab-content" id="orderStatusTabContent">
                <!-- Chờ xác nhận -->
                <div class="tab-pane fade show active" id="pending" role="tabpanel">
                    <div id="pendingOrders" class="order-list">
                        <div class="text-center py-4">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-2">Đang tải đơn hàng...</p>
                        </div>
                    </div>
                </div>

                <!-- Chờ giao hàng -->
                <div class="tab-pane fade" id="confirmed" role="tabpanel">
                    <div id="confirmedOrders" class="order-list"></div>
                </div>

                <!-- Đã giao -->
                <div class="tab-pane fade" id="delivered" role="tabpanel">
                    <div id="deliveredOrders" class="order-list"></div>
                </div>

                <!-- Đánh giá -->
                <div class="tab-pane fade" id="reviewed" role="tabpanel">
                    <div id="reviewedOrders" class="order-list"></div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Order History JavaScript -->
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
                            groupAndDisplayOrders();
                        } else {
                            console.error('Failed to load orders:', data.message);
                            showError(data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error loading orders:', error);
                        showError('Có lỗi xảy ra khi tải đơn hàng');
                    });
            }
            
            function groupAndDisplayOrders() {
                const grouped = {
                    PENDING: [],
                    CONFIRMED: [],
                    SHIPPING: [],
                    DELIVERED: [],
                    REVIEWED: []
                };
                
                // Group order details by their individual status
                orders.forEach(order => {
                    if (order.orderDetails && order.orderDetails.length > 0) {
                        order.orderDetails.forEach(detail => {
                            const status = detail.status || 'PENDING';
                            if (!grouped[status]) grouped[status] = [];
                            
                            // Create a virtual order for each detail with its status
                            grouped[status].push({
                                ...order,
                                orderDetails: [detail], // Single detail per "order"
                                effectiveStatus: status
                            });
                        });
                    }
                });
                
                // Display in tabs
                displayOrdersInTab('pending', [...grouped.PENDING]);
                displayOrdersInTab('confirmed', [...grouped.CONFIRMED, ...grouped.SHIPPING]);
                displayOrdersInTab('delivered', [...grouped.DELIVERED]);
                displayOrdersInTab('reviewed', [...grouped.REVIEWED]);
                
                // Update counts
                updateTabCounts(grouped);
            }
            
            function displayOrdersInTab(tabId, orders) {
                const container = document.getElementById(tabId + 'Orders');
                
                if (orders.length === 0) {
                    container.innerHTML = `
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                            <h5 class="text-muted">Không có đơn hàng nào</h5>
                            <p class="text-muted">Bạn chưa có đơn hàng nào trong trạng thái này</p>
                            <a href="/Itel/main?action=homePage" class="btn btn-primary">
                                <i class="fas fa-shopping-bag"></i> Mua sắm ngay
                            </a>
                        </div>
                    `;
                    return;
                }
                
                let html = '';
                orders.forEach(order => {
                    html += generateOrderCard(order);
                });
                
                container.innerHTML = html;
            }
            
            function generateOrderCard(order) {
                const detail = order.orderDetails[0]; // Single detail per card
                const statusInfo = getStatusInfo(detail.status);
                
                return `
                    <div class="card order-card mb-3">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div>
                                <strong>Đơn hàng #${order.orderId}</strong>
                                <small class="text-muted ms-2">${formatDate(order.orderDate)}</small>
                            </div>
                            <span class="badge ${statusInfo.class}">${statusInfo.text}</span>
                        </div>
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-md-2">
                                    <img src="${detail.product.imageUrl}" class="img-fluid rounded" alt="${detail.product.name}" style="height: 80px; object-fit: cover;" onerror="this.src='/Itel/images/placeholder.jpg'">
                                </div>
                                <div class="col-md-5">
                                    <h6 class="mb-1">${detail.product.name}</h6>
                                    <p class="text-muted mb-1">Số lượng: <span class="fw-bold">${detail.quantity}</span></p>
                                    <p class="text-muted mb-0">Giá: <span class="fw-bold">${formatCurrency(detail.unitPrice)} VNĐ</span></p>
                                </div>
                                <div class="col-md-3 text-end">
                                    <p class="mb-1">Thành tiền:</p>
                                    <h5 class="text-primary mb-2">${formatCurrency(detail.unitPrice * detail.quantity)} VNĐ</h5>
                                </div>
                                <div class="col-md-2 text-end">
                                    <div class="btn-group-vertical">
                                        ${generateActionButtons(detail.status, order.orderId, detail.orderDetailId)}
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Order Progress -->
                            <div class="mt-4">
                                <div class="order-progress">
                                    ${generateProgressSteps(detail.status)}
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            }
            
            function getStatusInfo(status) {
                const statusMap = {
                    'PENDING': { text: 'Chờ xác nhận', class: 'bg-warning' },
                    'CONFIRMED': { text: 'Đã xác nhận', class: 'bg-info' },
                    'SHIPPING': { text: 'Đang giao hàng', class: 'bg-primary' },
                    'DELIVERED': { text: 'Đã giao', class: 'bg-success' },
                    'REVIEWED': { text: 'Đã đánh giá', class: 'bg-secondary' }
                };
                return statusMap[status] || statusMap['PENDING'];
            }
            
            function generateActionButtons(status, orderId, detailId) {
                switch(status) {
                    case 'PENDING':
                        return `
                            <button class="btn btn-outline-danger btn-sm mb-1" onclick="cancelOrder(${orderId}, ${detailId})">
                                <i class="fas fa-times"></i> Hủy đơn
                            </button>
                        `;
                    case 'CONFIRMED':
                    case 'SHIPPING':
                        return `
                            <button class="btn btn-outline-primary btn-sm mb-1" onclick="trackOrder(${orderId}, ${detailId})">
                                <i class="fas fa-map-marker-alt"></i> Theo dõi
                            </button>
                        `;
                    case 'DELIVERED':
                        return `
                            <button class="btn btn-primary btn-sm mb-1" onclick="writeReview(${orderId}, ${detailId})">
                                <i class="fas fa-star"></i> Đánh giá
                            </button>
                            <button class="btn btn-outline-secondary btn-sm" onclick="reorder(${detailId})">
                                <i class="fas fa-redo"></i> Mua lại
                            </button>
                        `;
                    case 'REVIEWED':
                        return `
                            <button class="btn btn-outline-primary btn-sm mb-1" onclick="viewReview(${detailId})">
                                <i class="fas fa-eye"></i> Xem đánh giá
                            </button>
                            <button class="btn btn-outline-secondary btn-sm" onclick="reorder(${detailId})">
                                <i class="fas fa-redo"></i> Mua lại
                            </button>
                        `;
                    default:
                        return '';
                }
            }
            
            function generateProgressSteps(currentStatus) {
                const steps = [
                    { key: 'PENDING', text: 'Chờ xác nhận', icon: 'clock' },
                    { key: 'CONFIRMED', text: 'Đã xác nhận', icon: 'check' },
                    { key: 'SHIPPING', text: 'Đang giao', icon: 'truck' },
                    { key: 'DELIVERED', text: 'Đã giao', icon: 'box-open' }
                ];
                
                const statusOrder = ['PENDING', 'CONFIRMED', 'SHIPPING', 'DELIVERED', 'REVIEWED'];
                const currentIndex = statusOrder.indexOf(currentStatus);
                
                let html = '<div class="progress-steps d-flex justify-content-between align-items-center">';
                
                steps.forEach((step, index) => {
                    const isActive = index <= currentIndex;
                    const isCompleted = index < currentIndex;
                    
                    html += `
                        <div class="progress-step ${isActive ? 'active' : ''} ${isCompleted ? 'completed' : ''}">
                            <div class="step-icon">
                                <i class="fas fa-${step.icon}"></i>
                            </div>
                            <div class="step-text">${step.text}</div>
                        </div>
                    `;
                    
                    if (index < steps.length - 1) {
                        html += `<div class="progress-line ${isCompleted ? 'completed' : ''}"></div>`;
                    }
                });
                
                html += '</div>';
                return html;
            }
            
            function updateTabCounts(grouped) {
                document.getElementById('pendingCount').textContent = grouped.PENDING.length;
                document.getElementById('confirmedCount').textContent = grouped.CONFIRMED.length + grouped.SHIPPING.length;
                document.getElementById('deliveredCount').textContent = grouped.DELIVERED.length;
                document.getElementById('reviewedCount').textContent = grouped.REVIEWED.length;
            }
            
            function formatDate(dateString) {
                return new Date(dateString).toLocaleDateString('vi-VN', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit',
                    hour: '2-digit',
                    minute: '2-digit'
                });
            }
            
            function formatCurrency(amount) {
                return new Intl.NumberFormat('vi-VN').format(amount);
            }
            
            // Action Functions
            function cancelOrder(orderId, detailId) {
                if (confirm('Bạn có chắc muốn hủy sản phẩm này?')) {
                    fetch('/Itel/api/orders', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'action=cancelOrder&orderDetailId=' + detailId
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            showSuccess('Đã hủy sản phẩm thành công');
                            loadOrders(); // Reload data
                        } else {
                            showError('Lỗi: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showError('Có lỗi xảy ra khi hủy sản phẩm');
                    });
                }
            }
            
            function trackOrder(orderId, detailId) {
                showInfo('Chức năng theo dõi đơn hàng đang được phát triển');
            }
            
            function writeReview(orderId, detailId) {
                showInfo('Chức năng đánh giá đang được phát triển');
            }
            
            function viewReview(detailId) {
                showInfo('Chức năng xem đánh giá đang được phát triển');
            }
            
            function reorder(detailId) {
                showInfo('Chức năng mua lại đang được phát triển');
            }
            
            function showError(message) {
                showAlert(message, 'danger');
            }
            
            function showSuccess(message) {
                showAlert(message, 'success');
            }
            
            function showInfo(message) {
                showAlert(message, 'info');
            }
            
            function showAlert(message, type) {
                const alertDiv = document.createElement('div');
                alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
                alertDiv.style.cssText = 'top: 100px; right: 20px; z-index: 9999; min-width: 300px;';
                alertDiv.innerHTML = `
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                `;
                
                document.body.appendChild(alertDiv);
                
                // Auto dismiss after 5 seconds
                setTimeout(() => {
                    if (alertDiv.parentNode) {
                        alertDiv.remove();
                    }
                }, 5000);
            }
        </script>
    </body>
</html>

<style>
    body {
        margin: 0;
        background-color: #f8f9fa;
    }
    
    .content {
        padding-top: 150px;
        min-height: 80vh;
    }
    
    .order-status-tabs .nav-link {
        border-radius: 25px;
        margin-right: 10px;
        padding: 15px 25px;
        border: 2px solid transparent;
        color: #6c757d;
        transition: all 0.3s ease;
        font-weight: 500;
    }
    
    .order-status-tabs .nav-link:hover {
        color: #007bff;
        border-color: #e9ecef;
        transform: translateY(-2px);
    }
    
    .order-status-tabs .nav-link.active {
        background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
        border-color: #007bff;
        color: white;
        box-shadow: 0 4px 15px rgba(0,123,255,0.3);
    }
    
    .order-status-tabs .nav-link i {
        margin-right: 8px;
        font-size: 1.1em;
    }
    
    .order-card {
        transition: all 0.3s ease;
        border: 1px solid #e9ecef;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    
    .order-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        border-color: #007bff;
    }
    
    .order-card .card-header {
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-bottom: 1px solid #dee2e6;
    }
    
    .progress-steps {
        margin-top: 20px;
        padding: 20px 0;
        background: #f8f9fa;
        border-radius: 10px;
    }
    
    .progress-step {
        text-align: center;
        flex: 1;
        position: relative;
    }
    
    .step-icon {
        width: 45px;
        height: 45px;
        border-radius: 50%;
        background: linear-gradient(135deg, #e9ecef 0%, #dee2e6 100%);
        color: #6c757d;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 12px;
        border: 3px solid #e9ecef;
        transition: all 0.4s ease;
        font-size: 1.1em;
    }
    
    .progress-step.active .step-icon {
        background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
        color: white;
        border-color: #007bff;
        box-shadow: 0 0 20px rgba(0,123,255,0.5);
    }
    
    .progress-step.completed .step-icon {
        background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%);
        color: white;
        border-color: #28a745;
        box-shadow: 0 0 20px rgba(40,167,69,0.5);
    }
    
    .step-text {
        font-size: 13px;
        color: #6c757d;
        font-weight: 500;
    }
    
    .progress-step.active .step-text,
    .progress-step.completed .step-text {
        color: #007bff;
        font-weight: 600;
    }
    
    .progress-line {
        height: 3px;
        background: linear-gradient(90deg, #e9ecef 0%, #dee2e6 100%);
        flex: 1;
        margin: 0 15px;
        position: relative;
        top: -23px;
        border-radius: 2px;
    }
    
    .progress-line.completed {
        background: linear-gradient(90deg, #28a745 0%, #20c997 100%);
        box-shadow: 0 0 10px rgba(40,167,69,0.3);
    }
    
    .btn {
        border-radius: 20px;
        font-weight: 500;
        transition: all 0.3s ease;
    }
    
    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
    }
    
    @media (max-width: 768px) {
        .order-status-tabs {
            flex-direction: column;
        }
        
        .order-status-tabs .nav-link {
            margin-right: 0;
            margin-bottom: 8px;
            text-align: center;
        }
        
        .progress-steps {
            flex-direction: column;
        }
        
        .progress-line {
            display: none;
        }
        
        .order-card .card-body .row {
            text-align: center;
        }
        
        .order-card .card-body .col-md-2,
        .order-card .card-body .col-md-3,
        .order-card .card-body .col-md-5 {
            margin-bottom: 15px;
        }
    }
</style>
