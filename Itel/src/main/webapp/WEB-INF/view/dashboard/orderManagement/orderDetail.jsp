<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Chi tiết đơn hàng</title>
    <style>
        body { font-family: 'Roboto', Arial, sans-serif; background: #f4f6fb; margin: 0; padding: 0; }
        .order-detail-container { max-width: 700px; margin: 40px auto; background: #fff; border-radius: 16px; box-shadow: 0 4px 24px rgba(44,123,184,0.08); padding: 32px; }
        h2 { color: #2c3e50; margin-bottom: 24px; }
        .order-info p { margin: 8px 0; font-size: 16px; }
        .order-products { margin-top: 32px; }
        .order-products table { width: 100%; border-collapse: collapse; }
        .order-products th, .order-products td { padding: 10px; border-bottom: 1px solid #eee; text-align: left; }
        .order-products th { background: #e9ecef; }
        .order-products tr:last-child td { border-bottom: none; }
    </style>
</head>
<body>
    <div class="order-detail-container">
        <h2>Chi tiết đơn hàng #${order.orderId}</h2>
        <div class="order-info">
            <p><strong>Khách hàng:</strong> ${order.user.fullName} (${order.user.email})</p>
            <p><strong>Trạng thái:</strong> ${order.status}</p>
            <p><strong>Ngày đặt:</strong> ${order.orderDateFormatted}</p>
            <p><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}</p>
            <p><strong>Tổng tiền:</strong> <span style="color:#2c7bb8; font-weight:700;">${order.totalAmount}</span></p>
        </div>
        <c:if test="${not empty order.orderDetails}">
            <div class="order-products">
                <h3>Sản phẩm trong đơn hàng</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Tên sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="detail" items="${order.orderDetails}">
                            <tr>
                                <td>${detail.product.name}</td>
                                <td>${detail.quantity}</td>
                                <td><fmt:formatNumber value="${detail.unitPrice}" type="currency" currencySymbol="$"/></td>
                                <td><fmt:formatNumber value="${detail.unitPrice * detail.quantity}" type="currency" currencySymbol="$"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        <c:if test="${empty order.orderDetails}">
            <div class="order-products">
                <em>Đơn hàng này không có sản phẩm nào.</em>
            </div>
        </c:if>
        <div style="margin-top:24px;">
            <a href="main?action=orderManagement" style="color:#2c7bb8; text-decoration:underline;">&larr; Quay lại danh sách đơn hàng</a>
        </div>
    </div>
</body>
</html> 