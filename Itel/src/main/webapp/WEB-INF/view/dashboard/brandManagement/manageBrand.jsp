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
        function showDetails(brandId) {
            const details = document.getElementsByClassName('details');
            for (let i = 0; i < details.length; i++) {
                details[i].classList.remove('active');
            }
            const detail = document.getElementById('details-' + brandId);
            if (detail) {
                detail.classList.add('active');
                detail.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }

        function showProductDetails(productId) {
            const detail = document.getElementById('product-details-' + productId);
            if (detail) {
                detail.classList.add('active');
            }
        }

        function closeProductDetails(productId) {
            const detail = document.getElementById('product-details-' + productId);
            if (detail) {
                detail.classList.remove('active');
            }
        }

        document.addEventListener('DOMContentLoaded', () => {
            const brandItems = document.getElementsByClassName('brand-item');
            for (let item of brandItems) {
                item.onclick = (e) => {
                    const brandId = e.target.closest('.brand-item').getAttribute('data-brand-id');
                    showDetails(brandId);
                };
            }

            const productItems = document.getElementsByClassName('product-item');
            for (let item of productItems) {
                item.onclick = (e) => {
                    const productId = e.target.closest('.product-item').getAttribute('data-product-id');
                    showProductDetails(productId);
                };
            }
        });
    </script>
</head>
<body>
    <jsp:include page="../../components/sidebar.jsp" />
    <jsp:include page="../../components/toast.jsp" />
    <div class="main-content">
        <h4>Manage Brands</h4>

        <button class="btn-manage" onclick="goToManage()">Manage</button>
        <div class="brand-container">
            <c:forEach var="brand" items="${brands}">
                <div class="brand-item" data-brand-id="${brand.brandId}" onclick="showDetails(${brand.brandId})">
                    <img src="${brand.imageUrl}" alt="${brand.name}" onerror="this.src='https://via.placeholder.com/150'">
                    <p>${brand.name}</p>
                </div>
                <div id="details-${brand.brandId}" class="details">
                    <h5>${brand.name} Details</h5>
                    <p><strong>Country:</strong> ${brand.country}</p>
                    <p><strong>Status:</strong> ${brand.status}</p>
                    <p><strong>Description:</strong> ${brand.description}</p>
                    <div class="product-list">
                        <h6>Products</h6>
                        <div class="product-grid">
                            <c:forEach var="product" items="${brand.productList}">
                                <div class="product-item" data-product-id="${product.productId}">
                                    <img src="${product.imageUrl}" alt="${product.name}" onerror="this.src='https://via.placeholder.com/150'">
                                    <p>${product.name} - ${product.price}</p>
                                </div>
                                <div id="product-details-${product.productId}" class="product-details">
                                    <button class="close-btn" onclick="closeProductDetails(${product.productId})">×</button>
                                    <h5>${product.name} Details</h5>
                                    <img src="${product.imageUrl}" alt="${product.name}" onerror="this.src='https://via.placeholder.com/150'">
                                    <p><strong>Price:</strong> ${product.price}</p>
                                    <p><strong>Description:</strong> ${product.description}</p>
                                    <p><strong>Stock Quantity:</strong> ${product.stockQuantity}</p>
                                    <p><strong>Category:</strong> ${product.category.categoryId}</p>
                                    <p><strong>Brand:</strong> ${product.brand.brandId}</p>
                                    <p><strong>Image URL:</strong> ${product.imageUrl}</p>
                                    <p><strong>Status:</strong> ${product.status}</p>
                                    <p><strong>Created At:</strong> ${product.createdAt}</p>
                                    <p><strong>Updated At:</strong> ${product.updatedAt}</p>
                                </div>
                            </c:forEach>
                            <c:if test="${empty brand.productList}">
                                <p>No products available</p>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <script>
        function goToManage() {
            window.location.href = "<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_MANAGE_BRAND %>";
        }
    </script>
</body>
<style>
    :root {
        --primary-color: #4a90e2;
        --secondary-color: #357ab7;
        --bg-color: #f9fbfd;
        --card-bg: #ffffff;
        --text-color: #333333;
        --shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        --border-color: #e0e7f0;
    }
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: var(--bg-color);
        margin: 0;
        padding: 0;
        color: var(--text-color);
        line-height: 1.6;
        overflow-x: hidden;
    }
    .main-content {
        margin-left: 250px;
        padding: 30px 20px;
        min-height: 100vh;
    }
    h4 {
        padding-top: 50px;
        color: var(--primary-color);
        font-size: 2.5rem;
        text-align: center;
        margin-bottom: 40px;
        text-transform: uppercase;
        letter-spacing: 2px;
        font-weight: 700;
        position: relative;
        z-index: 1;
    }
    .brand-container {
        max-width: 1200px;
        margin: 0 auto;
        background: var(--card-bg);
        padding: 30px;
        border-radius: 15px;
        box-shadow: var(--shadow);
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 30px;
    }
    .brand-item {
        text-align: center;
        cursor: pointer;
        padding: 20px;
        border: 1px solid var(--border-color);
        border-radius: 12px;
        background: var(--card-bg);
        transition: all 0.3s ease;
        min-height: 350px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }
    .brand-item img {
        max-width: 100%;
        height: 150px;
        object-fit: contain;
        border-radius: 8px;
        margin-bottom: 15px;
    }
    .brand-item p {
        margin: 10px 0 0;
        font-size: 1.2rem;
        font-weight: 500;
        color: var(--text-color);
    }
    .brand-item:hover {
        transform: translateY(-8px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
    }
    .details {
        display: none;
        margin-top: 25px;
        padding: 25px;
        border: 1px solid var(--border-color);
        border-radius: 12px;
        background: var(--card-bg);
        animation: fadeIn 0.3s ease-in;
        box-shadow: var(--shadow);
        color: brown;
    }
    .details.active {
        display: block;
    }
    .product-list {
        margin-top: 20px;
    }
    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 25px;
        padding: 0;
        list-style: none;
    }
    .product-item {
        cursor: pointer;
        padding: 20px;
        border: 1px solid var(--border-color);
        border-radius: 12px;
        background: var(--card-bg);
        box-shadow: var(--shadow);
        transition: all 0.3s ease;
        text-align: center;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        min-height: 350px;
    }
    .product-item img {
        max-width: 100%;
        height: 180px;
        object-fit: cover;
        border-radius: 8px;
        margin-bottom: 15px;
    }
    .product-item p {
        margin: 10px 0 0;
        font-size: 1.1rem;
        color: var(--text-color);
        font-weight: 500;
    }
    .product-item:hover {
        transform: translateY(-6px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
    }
    .product-details {
        display: none;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: var(--card-bg);
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        z-index: 1000;
        max-width: 500px;
        width: 90%;
        text-align: center;
        color: black;
    }
    .product-details.active {
        display: block;
    }
    .product-details img {
        max-width: 100%;
        height: 250px;
        object-fit: cover;
        border-radius: 10px;
        margin-bottom: 20px;
    }
    .close-btn {
        position: absolute;
        top: 15px;
        right: 15px;
        background: none;
        border: none;
        font-size: 2rem;
        color: #999;
        cursor: pointer;
        transition: color 0.3s ease;
    }
    .close-btn:hover {
        color: var(--primary-color);
    }
    .btn-manage {
        display: block;
        margin: 30px auto;
        padding: 12px 30px;
        background-color: var(--primary-color);
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 1.1rem;
        transition: background-color 0.3s ease;
    }
    .btn-manage:hover {
        background-color: var(--secondary-color);
    }
    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
    @media (max-width: 768px) {
        .main-content {
            margin-left: 0;
            padding: 15px;
        }
        h4 {
            font-size: 2rem;
            margin-bottom: 20px;
        }
        .brand-container {
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            padding: 15px;
            gap: 15px;
        }
        .product-grid {
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
        }
        .product-item, .brand-item {
            min-height: 300px;
        }
        .product-item img {
            height: 140px;
        }
        .product-details {
            padding: 20px;
            max-width: 85%;
        }
        .product-details img {
            height: 200px;
        }
    }
</style>
</html>