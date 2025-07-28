<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .order-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(44,123,184,0.08);
            margin-bottom: 28px;
            padding: 24px 28px;
            transition: box-shadow 0.2s;
        }
        .order-card:hover {
            box-shadow: 0 8px 32px rgba(44,123,184,0.16);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .order-status {
            font-weight: bold;
            border-radius: 12px;
            padding: 4px 16px;
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
        }
        .order-status.pending { background: #fff3cd; color: #b8860b; }
        .order-status.completed { background: #d4edda; color: #218838; }
        .order-status.canceled { background: #f8d7da; color: #c82333; }
        .order-status.shipped { background: #d1ecf1; color: #117a8b; }
        .order-products-preview {
            display: flex;
            gap: 16px;
            margin-bottom: 8px;
        }
        .order-product-thumb {
            width: 48px; height: 48px; border-radius: 8px; object-fit: cover; border: 1px solid #eee;
        }
        .order-product-info {
            display: flex; flex-direction: column; font-size: 0.95rem;
        }
        .order-actions {
            margin-top: 10px;
        }
        .order-actions a, .order-actions button {
            margin-right: 10px;
        }
        .order-meta { color: #888; font-size: 0.98rem; }
        .order-total { color: #2c7bb8; font-weight: bold; font-size: 1.1rem; }
        @media (max-width: 600px) {
            .order-card { padding: 12px 6px; }
            .order-header { flex-direction: column; align-items: flex-start; gap: 6px; }
            .order-products-preview { flex-direction: column; gap: 6px; }
        }
        .order-products-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .order-product-row {
            display: flex;
            align-items: center;
            background: #f8fafd;
            border-radius: 10px;
            padding: 12px 16px;
            box-shadow: 0 1px 4px rgba(44,123,184,0.04);
            border: 1px solid #e9ecef;
        }
        .order-product-thumb {
            width: 56px; height: 56px; border-radius: 8px; object-fit: cover; margin-right: 16px;
            border: 1px solid #eee;
        }
        .order-product-info {
            flex: 1;
        }
        .order-product-name {
            font-weight: 600;
            font-size: 1.05rem;
            margin-bottom: 4px;
        }
        .order-product-meta {
            color: #555;
            font-size: 0.98rem;
        }
        .order-product-price, .order-product-total {
            color: #2c7bb8;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container mt-5">   
        <!-- Navbar -->
        <div>
            <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>
        </div>
        
        <!-- Filter trạng thái (chỉ khung, chưa xử lý JS) -->
        <div class="mb-4 d-flex gap-2 flex-wrap">
            <a href="orderHistory?status=all" class="btn btn-outline-primary btn-sm ${param.status == 'all' || empty param.status ? 'active' : ''}">Tất cả</a>
            <a href="orderHistory?status=pending" class="btn btn-outline-secondary btn-sm ${param.status == 'pending' ? 'active' : ''}">Đang xử lý</a>
            <a href="orderHistory?status=shipped" class="btn btn-outline-info btn-sm ${param.status == 'shipped' ? 'active' : ''}">Đang giao</a>
            <a href="orderHistory?status=completed" class="btn btn-outline-success btn-sm ${param.status == 'completed' ? 'active' : ''}">Đã giao</a>
            <a href="orderHistory?status=canceled" class="btn btn-outline-danger btn-sm ${param.status == 'canceled' ? 'active' : ''}">Đã hủy</a>
        </div>
        <c:if test="${orders != null && orders.size() > 0}">
            <c:forEach var="order" items="${orders}" varStatus="orderStatus">
                <div class="order-card">
                    <div class="order-header">
                        <div>
                            <span class="order-meta">Order #${order.orderId}</span>
                            <span class="order-meta ms-3">${order.orderDateFormatted}</span>
                        </div>
                        <span class="order-status ${order.status}">
                            <c:choose>
                                <c:when test="${order.status eq 'pending'}">
                                    <i class="fa-regular fa-clock"></i> PENDING
                                </c:when>
                                <c:when test="${order.status eq 'completed'}">
                                    <i class="fa-solid fa-check"></i> COMPLETED
                                </c:when>
                                <c:when test="${order.status eq 'canceled'}">
                                    <i class="fa-solid fa-xmark"></i> CANCELED
                                </c:when>
                                <c:when test="${order.status eq 'shipped'}">
                                    <i class="fa-solid fa-truck"></i> SHIPPED
                                </c:when>
                                <c:otherwise>
                                    <i class="fa-solid fa-question"></i> ${order.status}
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="order-products-preview">
                        <c:forEach var="detail" items="${order.orderDetails}" varStatus="pStatus">
                            <c:if test="${pStatus.index lt 3}">
                                <div class="d-flex align-items-center gap-2">
                                    <img src="${detail.product.imageUrl}" class="order-product-thumb" alt="Ảnh SP"/>
                                    <div class="order-product-info">
                                        <span>${detail.product.name}</span>
                                        <span>x${detail.quantity} - <fmt:formatNumber value="${detail.unitPrice}" type="currency" currencySymbol="₫"/></span>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        <c:if test="${order.orderDetails.size() > 3}">
                            <span class="text-muted">...và ${order.orderDetails.size() - 3} sản phẩm khác</span>
                        </c:if>
                    </div>
                    <div class="order-meta mb-2">Tổng tiền: <span class="order-total"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></span></div>
                    <div class="order-actions">
                        <button class="btn btn-primary btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#orderDetails${orderStatus.index}" aria-expanded="false" aria-controls="orderDetails${orderStatus.index}">
                            Xem chi tiết
                        </button>
                        <c:choose>
                            <c:when test="${order.status eq 'shipped'}">
                                <form action="main" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="updateOrderStatus"/>
                                    <input type="hidden" name="orderId" value="${order.orderId}"/>
                                    <input type="hidden" name="status" value="completed"/>
                                    <input type="hidden" name="from" value="user"/>
                                    <button type="submit" class="btn btn-success btn-sm ms-2">Đã nhận hàng</button>
                                </form>
                            </c:when>
                            <c:when test="${order.status eq 'pending'}">
                                <form action="main" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="updateOrderStatus"/>
                                    <input type="hidden" name="orderId" value="${order.orderId}"/>
                                    <input type="hidden" name="status" value="canceled"/>
                                    <input type="hidden" name="from" value="user"/>
                                    <button type="submit" class="btn btn-danger btn-sm ms-2">Hủy hàng</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <!-- Không hiển thị nút nào nếu đã completed/canceled -->
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="collapse mt-3" id="orderDetails${orderStatus.index}">
                        <div class="card card-body">
                            <h6>Chi tiết sản phẩm</h6>
                            <div class="order-products-list">
                                <c:forEach var="detail" items="${order.orderDetails}">
                                    <div class="order-product-row">
                                        <img src="${detail.product.imageUrl}" class="order-product-thumb" alt="Ảnh SP"/>
                                        <div class="order-product-info">
                                            <div class="order-product-name">${detail.product.name}</div>
                                            <div class="order-product-meta">
                                                x${detail.quantity} &nbsp;|&nbsp;
                                                <span class="order-product-price"><fmt:formatNumber value="${detail.unitPrice}" type="currency" currencySymbol="₫"/></span>
                                                &nbsp;|&nbsp;
                                                <span class="order-product-total"><fmt:formatNumber value="${detail.unitPrice * detail.quantity}" type="currency" currencySymbol="₫"/></span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        
        <c:if test="${orders == null || orders.size() == 0}">
            <div class="alert alert-warning">
                <h5>❌ NO ORDERS FOUND</h5>
            </div>
        </c:if>
        
        <!--Footer-->                                 
        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>
    </div>
<!-- Bootstrap JS (v5) for collapse functionality -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
