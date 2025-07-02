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
            body { background-color: #f8f9fa; }
            .content { padding-top: 150px; min-height: 80vh; }
            .order-card { margin-bottom: 20px; border-radius: 10px; }
            .order-card:hover { box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
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

            <!-- Server-side Orders Display -->
            <c:choose>
                <c:when test="${orders != null && orders.size() > 0}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> Tìm thấy ${orders.size()} đơn hàng
                    </div>
                    
                    <c:forEach var="order" items="${orders}">
                        <div class="card order-card">
                            <div class="card-header d-flex justify-content-between">
                                <div>
                                    <strong>Đơn hàng #${order.orderId}</strong>
                                    <small class="text-muted ms-2">
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </small>
                                </div>
                                <span class="badge bg-warning">${order.status}</span>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <p><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}</p>
                                        <p><strong>Tổng tiền:</strong> 
                                            <span class="text-primary fs-5">
                                                <fmt:formatNumber value="${order.totalAmount}" pattern="#,###.###"/> VNĐ
                                            </span>
                                        </p>
                                        
                                        <!-- Order Details -->
                                        <c:if test="${order.orderDetails != null && order.orderDetails.size() > 0}">
                                            <h6>Chi tiết đơn hàng:</h6>
                                            <c:forEach var="detail" items="${order.orderDetails}">
                                                <div class="border p-2 mb-2 rounded">
                                                    <div class="row align-items-center">
                                                        <div class="col-md-2">
                                                            <img src="${detail.product.imageUrl}" 
                                                                 class="img-fluid rounded" 
                                                                 style="height: 60px; object-fit: cover;"
                                                                 onerror="this.src='https://via.placeholder.com/60x60?text=No+Image'">
                                                        </div>
                                                        <div class="col-md-6">
                                                            <strong>${detail.product.name}</strong><br>
                                                            <small class="text-muted">Số lượng: ${detail.quantity}</small>
                                                        </div>
                                                        <div class="col-md-2">
                                                            <fmt:formatNumber value="${detail.unitPrice}" pattern="#,###.###"/> VNĐ
                                                        </div>
                                                        <div class="col-md-2">
                                                            <span class="badge bg-primary">${detail.status != null ? detail.status : 'PENDING'}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:if>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <button class="btn btn-outline-primary btn-sm mb-2">
                                            <i class="fas fa-eye"></i> Xem chi tiết
                                        </button><br>
                                        <button class="btn btn-outline-danger btn-sm">
                                            <i class="fas fa-times"></i> Hủy đơn
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                        <h5 class="text-muted">Không có đơn hàng nào</h5>
                        <p class="text-muted">Bạn chưa có đơn hàng nào</p>
                        <a href="/Itel/main?action=homePage" class="btn btn-primary">
                            <i class="fas fa-shopping-bag"></i> Mua sắm ngay
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Debug Info -->
            <div class="mt-4">
                <details>
                    <summary class="btn btn-outline-secondary btn-sm">Debug Info</summary>
                    <div class="mt-2 p-3 bg-light rounded">
                        <p><strong>User:</strong> ${sessionScope.loggedUser != null ? sessionScope.loggedUser.fullName : 'Not logged in'}</p>
                        <p><strong>Orders count:</strong> ${orders != null ? orders.size() : 'null'}</p>
                        <p><strong>User ID:</strong> ${sessionScope.loggedUser != null ? sessionScope.loggedUser.userId : 'N/A'}</p>
                        
                        <button class="btn btn-info btn-sm" onclick="testAPI()">Test API</button>
                        <div id="apiResult" class="mt-2"></div>
                    </div>
                </details>
            </div>
        </div>

        <!-- Footer -->
        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function testAPI() {
                document.getElementById('apiResult').innerHTML = '<div class="spinner-border spinner-border-sm"></div> Testing...';
                
                fetch('/Itel/api/orders')
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('apiResult').innerHTML = 
                            '<pre class="bg-white p-2 rounded mt-2">' + JSON.stringify(data, null, 2) + '</pre>';
                    })
                    .catch(error => {
                        document.getElementById('apiResult').innerHTML = 
                            '<div class="alert alert-danger mt-2">Error: ' + error.message + '</div>';
                    });
            }
        </script>
    </body>
</html>
