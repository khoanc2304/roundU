<%@ page import="java.util.List" %>
<%@ page import="com.tourismapp.model.Brand" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Brands</title>
    <script>
        let selectedBrandId = null;
        function showBrandProducts(brandId) {
            selectedBrandId = brandId;
            // Hide all product panels
            const panels = document.getElementsByClassName('brand-products-panel');
            for (let p of panels) p.style.display = 'none';
            // Show selected
            const panel = document.getElementById('products-panel-' + brandId);
            if (panel) panel.style.display = 'block';
            // Highlight selected brand
            const brandItems = document.getElementsByClassName('brand-list-item');
            for (let item of brandItems) item.classList.remove('selected');
            const selected = document.getElementById('brand-list-item-' + brandId);
            if (selected) selected.classList.add('selected');
        }
        document.addEventListener('DOMContentLoaded', function() {
            // Optionally, auto-select the first brand
            const firstBrand = document.querySelector('.brand-list-item');
            if (firstBrand) {
                const firstId = firstBrand.getAttribute('data-brand-id');
                showBrandProducts(firstId);
            }
        });
    </script>
</head>
<body>
    <jsp:include page="../../components/sidebar.jsp" />
    <jsp:include page="../../components/toast.jsp" />
<div class="main-content flex-container">
    <div class="brand-list-panel">
        <div class="brand-list-header">
            <h4>Thương hiệu</h4>
            <a href="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_MANAGE_BRAND %>" class="btn-link-table">Bảng tổng quan</a>
                    </div>
        <div class="brand-list">
            <c:forEach var="brand" items="${brands}">
                <div class="brand-list-item" id="brand-list-item-${brand.brandId}" data-brand-id="${brand.brandId}">
                    <img src="${brand.imageUrl}" alt="${brand.name}" onerror="this.src='https://via.placeholder.com/100'">
                    <div class="brand-info">
                        <div class="brand-name">${brand.name}</div>
                        <button class="btn-view" onclick="showBrandProducts('${brand.brandId}')">Xem</button>
                    </div>
                </div>
            </c:forEach>
        </div>
                </div>
    <div class="brand-products-wrapper">
        <c:forEach var="brand" items="${brands}">
            <div class="brand-products-panel" id="products-panel-${brand.brandId}" style="display:none;">
                <h4>Sản phẩm của ${brand.name}</h4>
                <div class="brand-details">
                    <p><strong>Quốc gia:</strong> ${brand.country}</p>
                    <p><strong>Trạng thái:</strong> ${brand.status}</p>
                    <p><strong>Mô tả:</strong> ${brand.description}</p>
                </div>
                <div class="product-list">
                    <c:if test="${not empty brand.productList}">
                        <div class="product-grid">
                            <c:forEach var="product" items="${brand.productList}">
                                <div class="product-card">
                                    <img src="${product.imageUrl}" alt="${product.name}" onerror="this.src='https://via.placeholder.com/150'">
                                    <div class="product-name">${product.name}</div>
                                    <div class="product-price">${product.price}</div>
                                    <div class="product-desc">${product.description}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                    <c:if test="${empty brand.productList}">
                        <p>Không có sản phẩm nào</p>
                    </c:if>
                </div>
            </div>
        </c:forEach>
        <div id="empty-panel" class="brand-products-panel" style="display:none;">
            <p>Chọn một thương hiệu để xem sản phẩm.</p>
        </div>
    </div>
                </div>
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #f9fbfd;
        margin: 0;
        padding: 0;
        color: #333;
    }
    .main-content.flex-container {
        display: flex;
        flex-direction: row;
        min-height: 100vh;
        margin-left: 250px;
        padding: 0;
        padding-top: 80px; /* Thêm dòng này để tránh bị header che */
    }
    .brand-list-panel {
        width: 340px;
        background: #fff;
        border-right: 1px solid #e0e7f0;
        padding: 30px 0 30px 0;
        box-shadow: 2px 0 12px rgba(0,0,0,0.06);
        min-height: 100vh;
        border-radius: 0 18px 18px 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        padding-top: 30px;
    }
    .brand-list-header {
        width: 90%;
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-bottom: 18px;
        gap: 8px;
    }
    .btn-link-table {
        display: inline-block;
        background: linear-gradient(90deg, #4a90e2 60%, #357ab7 100%);
        color: #fff;
        padding: 8px 22px;
        border-radius: 20px;
        font-weight: 600;
        text-decoration: none;
        font-size: 1rem;
        margin-top: 2px;
        box-shadow: 0 2px 8px rgba(74,144,226,0.08);
        transition: background 0.2s, box-shadow 0.2s;
    }
    .btn-link-table:hover {
        background: linear-gradient(90deg, #357ab7 60%, #4a90e2 100%);
        box-shadow: 0 4px 16px rgba(74,144,226,0.15);
    }
    .brand-list {
        display: flex;
        flex-direction: column;
        gap: 18px;
        width: 90%;
    }
    .brand-list-item {
        display: flex;
        align-items: center;
        gap: 16px;
        background: #f5f7fa;
        border-radius: 12px;
        padding: 14px 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        transition: background 0.2s, box-shadow 0.2s;
        cursor: pointer;
    }
    .brand-list-item.selected, .brand-list-item:hover {
        background: #e6f0fa;
        box-shadow: 0 4px 16px rgba(74,144,226,0.10);
    }
    .brand-list-item img {
        width: 60px;
        height: 60px;
        object-fit: contain;
        border-radius: 8px;
        background: #fff;
        border: 1px solid #e0e7f0;
    }
    .brand-info {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 6px;
    }
    .brand-name {
        font-weight: 600;
        font-size: 1.1rem;
        color: #357ab7;
    }
    .btn-view {
        padding: 8px 24px;
        background: linear-gradient(90deg, #357ab7 60%, #4a90e2 100%);
        color: #fff;
        border: none;
        border-radius: 18px;
        cursor: pointer;
        font-size: 1rem;
        font-weight: 600;
        transition: background 0.2s, box-shadow 0.2s;
        box-shadow: 0 2px 8px rgba(53,122,183,0.10);
    }
    .btn-view:hover {
        background: linear-gradient(90deg, #4a90e2 60%, #357ab7 100%);
        box-shadow: 0 4px 16px rgba(53,122,183,0.15);
    }
    .brand-products-wrapper {
        flex: 1;
        padding: 50px 50px 50px 50px;
        background: #f9fbfd;
        min-height: 100vh;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        align-items: center;
        padding-top: 50px;
    }
    .brand-products-panel {
        display: none;
        animation: fadeIn 0.3s;
        width: 100%;
        max-width: 1200px;
        margin: 0 auto;
    }
    .brand-products-panel[style*='display: block'] {
        display: block;
    }
    .brand-details {
/*        padding-top: 70px;*/
        margin-bottom: 18px;
        color: #555;
        font-size: 1.08rem;
    }
    .product-list {
        margin-top: 18px;
        width: 100%;
    }
    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
        gap: 28px;
        width: 100%;
    }
    .product-card {
        background: #fff;
        border-radius: 14px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        padding: 22px 16px;
        display: flex;
        flex-direction: column;
        align-items: center;
        min-height: 260px;
        transition: box-shadow 0.2s;
        border: 1px solid #e0e7f0;
    }
    .product-card img {
        width: 130px;
        height: 130px;
        object-fit: contain;
        border-radius: 10px;
        margin-bottom: 14px;
        background: #f5f7fa;
    }
    .product-name {
        font-weight: 700;
        font-size: 1.18rem;
        margin-bottom: 8px;
        color: #357ab7;
        text-align: center;
    }
    .product-price {
        color: #e67e22;
        font-weight: 700;
        margin-bottom: 10px;
        font-size: 1.08rem;
    }
    .product-desc {
        color: #666;
        font-size: 0.99rem;
        text-align: center;
    }
    @media (max-width: 900px) {
        .main-content.flex-container {
            flex-direction: column;
        }
        .brand-list-panel {
            width: 100%;
            min-height: unset;
            border-right: none;
            border-bottom: 1px solid #e0e7f0;
            box-shadow: none;
            padding: 20px 0;
            border-radius: 0;
        }
        .brand-products-wrapper {
            padding: 20px 10px;
        }
    }
    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
</style>
</html>
