<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Đã xem gần đây</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .recently-viewed-list { display: flex; gap: 24px; flex-wrap: wrap; justify-content: flex-start; margin-top: 32px; }
        .recently-viewed-item { width: 160px; background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(44,123,184,0.06); padding: 16px 10px; text-align: center; transition: box-shadow 0.2s; }
        .recently-viewed-item:hover { box-shadow: 0 4px 16px rgba(44,123,184,0.14); }
        .recently-viewed-item img { width: 100px; height: 100px; object-fit: cover; border-radius: 8px; margin-bottom: 8px; border: 1px solid #eee; }
        .recently-viewed-name { font-weight: 600; font-size: 1.05rem; margin-bottom: 4px; color: #222; }
        .recently-viewed-price { color: #2c7bb8; font-weight: 600; font-size: 1.02rem; }
    </style>
</head>
<body style="background: #f4f6fb;">
    <div class="container mt-5">
        <h3>Đã xem gần đây</h3>
        <c:if test="${not empty sessionScope.recentlyViewed}">
            <div class="recently-viewed-list">
                <c:forEach var="product" items="${sessionScope.recentlyViewed}">
                    <div class="recently-viewed-item">
                        <a href="${pageContext.request.contextPath}/main?action=viewProduct&id=${product.productId}">
                            <img src="${product.imageUrl}" alt="${product.name}" />
                            <div class="recently-viewed-name">${product.name}</div>
                            <div class="recently-viewed-price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/></div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        <c:if test="${empty sessionScope.recentlyViewed}">
            <div class="alert alert-info mt-4">Bạn chưa xem sản phẩm nào gần đây.</div>
        </c:if>
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/main?action=homePage" class="btn btn-outline-primary">&larr; Quay lại trang chủ</a>
        </div>
    </div>
</body>
</html> 