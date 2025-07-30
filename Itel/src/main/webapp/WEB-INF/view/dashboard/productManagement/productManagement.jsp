<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="true" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Com Product Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <jsp:include page="../../components/sidebar.jsp" />
    <jsp:include page="../../components/toast.jsp" />
    
    <div class="container-fluid main-container">
        <div class="row">
            <main class="col-12">
                <!-- Dashboard Header -->
                <div class="dashboard-header mb-4">
                    <div class="header-content">
                        <div class="header-text">
                            <h1 class="dashboard-title">
                                <div class="title-icon">
                                    <i class="fas fa-box-open"></i>
                                </div>
                                <div>
                                    <span class="title-main">Product Dashboard</span>
                                    <span class="title-sub">E-Commerce Management</span>
                                </div>
                            </h1>
                            <p class="dashboard-subtitle">Manage your products efficiently with advanced tools</p>
                        </div>
                        <div class="header-stats">
                            <div class="stat-item">
                                <div class="stat-number">${fn:length(products)}</div>
                                <div class="stat-label">Total Products</div>
                            </div>
                        </div>
                    </div>
                    <div class="header-decoration"></div>
                </div>

                <!-- Action Bar -->
                <div class="action-bar mb-4">
                    <div class="search-section">
                        <form action="main" method="get" class="search-form">
                            <input type="hidden" name="action" value="searchProduct">
                            <div class="search-input-group">
                                <div class="search-icon">
                                    <i class="fas fa-search"></i>
                                </div>
                                <input type="text" class="search-input" id="searchProduct" name="qProduct"
                                       placeholder="Search products by name, description..." value="${param.qProduct}"
                                       aria-label="Search products">
                                <button class="search-btn" type="submit">
                                    <i class="fas fa-search"></i>
                                    <span>Search</span>
                                </button>
                                <c:if test="${not empty param.qProduct}">
                                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTMANAGEMENT %>" class="clear-btn">
                                        <i class="fas fa-times"></i>
                                        <span>Clear</span>
                                    </a>
                                </c:if>
                            </div>
                        </form>
                    </div>
                    
                    <div class="action-buttons">
                        <button type="button" class="add-product-btn"
                                onclick="window.location.href = 'main?action=createProductForm'">
                            <i class="fas fa-plus"></i>
                            <span>Add New Product</span>
                        </button>
                    </div>
                </div>

                <div class="table-card">
                    <div class="table-header">
                        <h3 class="table-title">
                            <i class="fas fa-list"></i>
                            Products List
                        </h3>
                    </div>
                    
                    <div class="table-container">
                        <table class="products-table">
                            <thead>
                                <tr>
                                    <th scope="col">
                                        <div class="th-content">
                                            <i class="fas fa-image"></i>
                                            Image
                                        </div>
                                    </th>
                                    <th scope="col">
                                        <div class="th-content">
                                            <i class="fas fa-tag"></i>
                                            Product Name
                                        </div>
                                    </th>
                                    <th scope="col">
                                        <div class="th-content">
                                            <i class="fas fa-dollar-sign"></i>
                                            Price
                                        </div>
                                    </th>
                                    <th scope="col">
                                        <div class="th-content">
                                            <i class="fas fa-align-left"></i>
                                            Description
                                        </div>
                                    </th>
                                    <th scope="col">
                                        <div class="th-content">
                                            <i class="fas fa-toggle-on"></i>
                                            Status
                                        </div>
                                    </th>
                                    <th scope="col">
                                        <div class="th-content">
                                            <i class="fas fa-cogs"></i>
                                            Actions
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="page" value="${param.page != null && param.page > 0 ? param.page : 1}" />
                                <c:set var="itemsPerPage" value="10" />
                                <c:set var="totalItems" value="${fn:length(products)}" />
                                <c:set var="totalPages" value="${totalItems > 0 ? (totalItems + itemsPerPage - 1) div itemsPerPage : 0}" />
                                <c:set var="startIndex" value="${(page - 1) * itemsPerPage}" />
                                <c:set var="endIndex" value="${startIndex + itemsPerPage}" />
                                
                                <c:forEach var="product" items="${products}" varStatus="loop">
                                    <c:if test="${loop.index >= startIndex && loop.index < endIndex}">
                                        <tr class="product-row">
                                            <td>
                                                <div class="product-image-wrapper">
                                                    <img src="${product.imageUrl}" alt="${product.name}" class="product-image">
                                                    <div class="image-overlay">
                                                        <i class="fas fa-eye"></i>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="product-name">
                                                    <span class="name-text">${product.name}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="product-price">
                                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" groupingUsed="true" />
                                                </div>
                                            </td>
                                            <td>
                                                <div class="product-description" title="${product.description}">
                                                    ${product.description}
                                                </div>
                                            </td>
                                            <td>
                                                <span class="status-badge ${product.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                                    <i class="fas ${product.status == 'ACTIVE' ? 'fa-check-circle' : 'fa-pause-circle'}"></i>
                                                    <span>${product.status}</span>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-buttons-group">
                                                    <a href="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_MANAGE_PRODUCT%>&id=${product.productId}"
                                                        class="action-btn view-btn" title="View Details">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <form action="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_DELETE_PRODUCT %>"
                                                           method="post" class="d-inline">
                                                        <input type="hidden" name="productId" value="${product.productId}">
                                                        <button type="submit" class="action-btn delete-btn"
                                                                 onclick="return confirm('Are you sure you want to delete this product?')"
                                                                title="Delete Product">
                                                            <i class="fas fa-trash-alt"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Pagination -->
                <div class="pagination-wrapper">
                    <div class="pagination-info">
                        <i class="fas fa-info-circle"></i>
                        <span>Showing ${totalItems > 0 ? startIndex + 1 : 0} to ${endIndex > totalItems ? totalItems : endIndex} of ${totalItems} entries</span>
                    </div>
                    
                    <nav aria-label="Page navigation" class="pagination-nav">
                        <ul class="pagination-list">
                            <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="main?action=productManagement&page=${page - 1}${not empty param.qProduct ? '&qProduct=' : ''}${fn:escapeXml(param.qProduct)}">
                                    <i class="fas fa-chevron-left"></i>
                                    <span>Previous</span>
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${page == i ? 'active' : ''}">
                                    <a class="page-link" href="main?action=productManagement&page=${i}${not empty param.qProduct ? '&qProduct=' : ''}${fn:escapeXml(param.qProduct)}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${page >= totalPages || totalPages == 0 ? 'disabled' : ''}">
                                <a class="page-link" href="main?action=productManagement&page=${page + 1}${not empty param.qProduct ? '&qProduct=' : ''}${fn:escapeXml(param.qProduct)}">
                                    <span>Next</span>
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteSelectedProducts() {
            const selectedIds = [];
            document.querySelectorAll('input[name="productIds"]:checked').forEach(checkbox => {
                selectedIds.push(checkbox.value);
            });
            if (selectedIds.length > 0) {
                if (confirm('Are you sure to delete selected products?')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'main?action=deleteSelectedProducts';
                    selectedIds.forEach(id => {
                        const input = document.createElement('input');
                        input.type = 'hidden';
                        input.name = 'productIds';
                        input.value = id;
                        form.appendChild(input);
                    });
                    document.body.appendChild(form);
                    form.submit();
                }
            } else {
                alert('Please select at least one product to delete.');
            }
        }

        document.getElementById('selectAll')?.addEventListener('change', function () {
            document.querySelectorAll('input[name="productIds"]').forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        });

        document.addEventListener('DOMContentLoaded', function() {
            // Animate table rows on load
            const rows = document.querySelectorAll('.product-row');
            rows.forEach((row, index) => {
                row.style.animationDelay = `${index * 0.1}s`;
                row.classList.add('fade-in');
            });
        });
    </script>
</body>
</html>

<style>
    :root {
        --primary-color: #6366f1;
        --primary-dark: #4f46e5;
        --secondary-color: #8b5cf6;
        --success-color: #10b981;
        --danger-color: #ef4444;
        --warning-color: #f59e0b;
        --info-color: #06b6d4;
        --light-color: #f8fafc;
        --dark-color: #1e293b;
        --border-color: #e2e8f0;
        --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
        --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
        --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
        --border-radius: 12px;
        --border-radius-lg: 16px;
        --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    * {
        box-sizing: border-box;
    }

    body {
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #6366f1 100%);
        min-height: 100vh;
        margin: 0;
        margin-left: 50px;
        padding: 20px;
        color: var(--dark-color);
        line-height: 1.6;
    }

    .main-container {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        border-radius: var(--border-radius-lg);
        box-shadow: var(--shadow-xl);
        padding: 2rem;
        max-width: 1400px;
        margin: 0 auto;
        border: 1px solid rgba(255, 255, 255, 0.2);
    }

    /* Dashboard Header */
    .dashboard-header {
        background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        border-radius: var(--border-radius-lg);
        padding: 2rem;
        color: white;
        position: relative;
        overflow: hidden;
        margin-bottom: 2rem;
    }

    .dashboard-header::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
        opacity: 0.3;
    }

    .header-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: relative;
        z-index: 2;
    }

    .dashboard-title {
        display: flex;
        align-items: center;
        gap: 1.5rem;
        margin: 0;
        font-weight: 700;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
    }

    .title-icon {
        background: rgba(255, 255, 255, 0.2);
        padding: 1rem;
        border-radius: var(--border-radius);
        font-size: 1.5rem;
    }

    .title-main {
        display: block;
        font-size: 2rem;
        line-height: 1.2;
    }

    .title-sub {
        display: block;
        font-size: 1rem;
        opacity: 0.8;
        font-weight: 400;
    }

    .dashboard-subtitle {
        margin: 0.5rem 0 0 0;
        opacity: 0.9;
        font-size: 1.1rem;
    }

    .header-stats {
        text-align: center;
    }

    .stat-item {
        background: rgba(255, 255, 255, 0.15);
        padding: 1rem 1.5rem;
        border-radius: var(--border-radius);
        backdrop-filter: blur(10px);
    }

    .stat-number {
        font-size: 2rem;
        font-weight: 700;
        line-height: 1;
    }

    .stat-label {
        font-size: 0.875rem;
        opacity: 0.8;
        margin-top: 0.25rem;
    }

    .header-decoration {
        position: absolute;
        top: -50%;
        right: -10%;
        width: 200px;
        height: 200px;
        background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
        border-radius: 50%;
    }

    /* Action Bar */
    .action-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 1.5rem;
        margin-bottom: 2rem;
        flex-wrap: wrap;
    }

    .search-section {
        flex: 1;
        min-width: 300px;
    }

    .search-form {
        width: 100%;
    }

    .search-input-group {
        display: flex;
        align-items: center;
        background: white;
        border: 2px solid var(--border-color);
        border-radius: var(--border-radius);
        padding: 0.5rem;
        box-shadow: var(--shadow-sm);
        transition: var(--transition);
    }

    .search-input-group:focus-within {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
    }

    .search-icon {
        color: #6b7280;
        padding: 0 0.75rem;
        font-size: 1.1rem;
    }

    .search-input {
        flex: 1;
        border: none;
        outline: none;
        padding: 0.75rem 0.5rem;
        font-size: 1rem;
        background: transparent;
    }

    .search-input::placeholder {
        color: #9ca3af;
    }

    .search-btn, .clear-btn {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.75rem 1rem;
        border: none;
        border-radius: calc(var(--border-radius) - 2px);
        font-weight: 500;
        text-decoration: none;
        transition: var(--transition);
        cursor: pointer;
        font-size: 0.875rem;
    }

    .search-btn {
        background: var(--primary-color);
        color: white;
        margin-left: 0.5rem;
    }

    .search-btn:hover {
        background: var(--primary-dark);
        transform: translateY(-1px);
    }

    .clear-btn {
        background: var(--danger-color);
        color: white;
        margin-left: 0.5rem;
    }

    .clear-btn:hover {
        background: #dc2626;
        color: white;
        transform: translateY(-1px);
    }

    .action-buttons {
        display: flex;
        gap: 1rem;
    }

    .add-product-btn {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.875rem 1.5rem;
        background: var(--success-color);
        color: white;
        border: none;
        border-radius: var(--border-radius);
        font-weight: 600;
        text-decoration: none;
        transition: var(--transition);
        cursor: pointer;
        box-shadow: var(--shadow-md);
    }

    .add-product-btn:hover {
        background: #059669;
        transform: translateY(-2px);
        box-shadow: var(--shadow-lg);
    }

    /* Table Card */
    .table-card {
        background: white;
        border-radius: var(--border-radius-lg);
        box-shadow: var(--shadow-lg);
        overflow: hidden;
        border: 1px solid var(--border-color);
    }

    .table-header {
        background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
        padding: 1.5rem 2rem;
        border-bottom: 1px solid var(--border-color);
    }

    .table-title {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin: 0;
        font-size: 1.25rem;
        font-weight: 600;
        color: var(--dark-color);
    }

    .table-container {
        overflow-x: auto;
    }

    .products-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.875rem;
    }

    .products-table thead th {
        background: #f8fafc;
        padding: 1rem 1.5rem;
        text-align: left;
        font-weight: 600;
        color: var(--dark-color);
        border-bottom: 2px solid var(--border-color);
        white-space: nowrap;
    }

    .th-content {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .th-content i {
        color: var(--primary-color);
        font-size: 0.875rem;
    }

    .product-row {
        transition: var(--transition);
        border-bottom: 1px solid #f1f5f9;
    }

    .product-row:hover {
        background: #f8fafc;
        transform: translateY(-1px);
        box-shadow: var(--shadow-sm);
    }

    .product-row td {
        padding: 1.25rem 1.5rem;
        vertical-align: middle;
    }

    .product-image-wrapper {
        position: relative;
        width: 64px;
        height: 64px;
        border-radius: var(--border-radius);
        overflow: hidden;
        box-shadow: var(--shadow-md);
        transition: var(--transition);
    }

    .product-image-wrapper:hover {
        transform: scale(1.05);
        box-shadow: var(--shadow-lg);
    }

    .product-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .image-overlay {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.7);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        opacity: 0;
        transition: var(--transition);
    }

    .product-image-wrapper:hover .image-overlay {
        opacity: 1;
    }

    .product-name {
        font-weight: 500;
        color: var(--dark-color);
    }

    .name-text {
        display: block;
        max-width: 200px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .product-price {
        font-weight: 600;
        color: var(--success-color);
        font-size: 1rem;
    }

    .product-description {
        max-width: 250px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        color: #6b7280;
        line-height: 1.5;
    }

    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.5rem 1rem;
        border-radius: 50px;
        font-weight: 600;
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    .status-active {
        background: rgba(16, 185, 129, 0.1);
        color: var(--success-color);
        border: 1px solid rgba(16, 185, 129, 0.2);
    }

    .status-inactive {
        background: rgba(245, 158, 11, 0.1);
        color: var(--warning-color);
        border: 1px solid rgba(245, 158, 11, 0.2);
    }

    .action-buttons-group {
        display: flex;
        gap: 0.5rem;
    }

    .action-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 36px;
        height: 36px;
        border: none;
        border-radius: var(--border-radius);
        text-decoration: none;
        transition: var(--transition);
        cursor: pointer;
        font-size: 0.875rem;
    }

    .view-btn {
        background: rgba(99, 102, 241, 0.1);
        color: var(--primary-color);
        border: 1px solid rgba(99, 102, 241, 0.2);
    }

    .view-btn:hover {
        background: var(--primary-color);
        color: white;
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    .delete-btn {
        background: rgba(239, 68, 68, 0.1);
        color: var(--danger-color);
        border: 1px solid rgba(239, 68, 68, 0.2);
    }

    .delete-btn:hover {
        background: var(--danger-color);
        color: white;
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    /* Pagination */
    .pagination-wrapper {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 2rem;
        padding: 1.5rem 2rem;
        background: white;
        border-radius: var(--border-radius-lg);
        box-shadow: var(--shadow-md);
        flex-wrap: wrap;
        gap: 1rem;
    }

    .pagination-info {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        color: #6b7280;
        font-size: 0.875rem;
        background: #f8fafc;
        padding: 0.75rem 1rem;
        border-radius: var(--border-radius);
        border: 1px solid var(--border-color);
    }

    .pagination-info i {
        color: var(--info-color);
    }

    .pagination-list {
        display: flex;
        list-style: none;
        margin: 0;
        padding: 0;
        gap: 0.25rem;
    }

    .page-item {
        margin: 0;
    }

    .page-link {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.75rem 1rem;
        color: var(--dark-color);
        text-decoration: none;
        border: 1px solid var(--border-color);
        border-radius: var(--border-radius);
        transition: var(--transition);
        font-weight: 500;
        min-width: 44px;
        justify-content: center;
    }

    .page-link:hover {
        background: var(--primary-color);
        color: white;
        border-color: var(--primary-color);
        transform: translateY(-1px);
    }

    .page-item.active .page-link {
        background: var(--primary-color);
        color: white;
        border-color: var(--primary-color);
        box-shadow: var(--shadow-md);
    }

    .page-item.disabled .page-link {
        color: #9ca3af;
        background: #f9fafb;
        border-color: #e5e7eb;
        cursor: not-allowed;
        transform: none;
    }

    .page-item.disabled .page-link:hover {
        background: #f9fafb;
        color: #9ca3af;
        border-color: #e5e7eb;
        transform: none;
    }

    /* Animations */
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .fade-in {
        animation: fadeIn 0.6s ease-out forwards;
    }

    /* Responsive Design */
    @media (max-width: 1200px) {
        .main-container {
            padding: 1.5rem;
        }
        
        .header-content {
            flex-direction: column;
            text-align: center;
            gap: 1.5rem;
        }
    }

    @media (max-width: 768px) {
        body {
            padding: 10px;
        }
        
        .main-container {
            padding: 1rem;
        }
        
        .dashboard-header {
            padding: 1.5rem;
        }
        
        .title-main {
            font-size: 1.5rem;
        }
        
        .action-bar {
            flex-direction: column;
            align-items: stretch;
        }
        
        .search-section {
            min-width: auto;
        }
        
        .action-buttons {
            justify-content: center;
        }
        
        .table-header {
            padding: 1rem;
        }
        
        .products-table thead th,
        .product-row td {
            padding: 0.75rem 0.5rem;
        }
        
        .product-description,
        .name-text {
            max-width: 120px;
        }
        
        .pagination-wrapper {
            flex-direction: column;
            text-align: center;
        }
        
        .pagination-list {
            justify-content: center;
            flex-wrap: wrap;
        }
    }

    @media (max-width: 480px) {
        .dashboard-title {
            flex-direction: column;
            text-align: center;
            gap: 1rem;
        }
        
        .title-main {
            font-size: 1.25rem;
        }
        
        .search-btn span,
        .clear-btn span,
        .add-product-btn span {
            display: none;
        }
        
        .action-btn {
            width: 32px;
            height: 32px;
        }
        
        .page-link {
            padding: 0.5rem 0.75rem;
            font-size: 0.875rem;
        }
    }

    /* Custom scrollbar */
    .table-container::-webkit-scrollbar {
        height: 8px;
    }

    .table-container::-webkit-scrollbar-track {
        background: #f1f5f9;
        border-radius: 4px;
    }

    .table-container::-webkit-scrollbar-thumb {
        background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        border-radius: 4px;
    }

    .table-container::-webkit-scrollbar-thumb:hover {
        background: linear-gradient(135deg, var(--primary-dark) 0%, #7c3aed 100%);
    }
</style>
