<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="true" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Details Management Page</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <jsp:include page="../../components/sidebar.jsp" />
        <jsp:include page="../../components/toast.jsp" />

        <div class="content">
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="text-dark">Product Details</h2>
                </div>
                <a href="<%= ProjectPaths.HREF_TO_PRODUCTMANAGEMENT %>" class="btn btn-secondary mt-3">Quay lại danh sách sản phẩm</a>

                <button id="editButton" class="btn btn-warning mt-3" onclick="toggleEditMode()">Sửa Sản Phẩm</button>

                <form id="productForm" action="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_EDIT_PRODUCT %>" method="post">
                    <input type="hidden" id="productId" name="productId" value="${product.productId}">                    
                    <div class="row mt-4">
                        <div class="col-md-4 mb-4">
                            <div class="product-card">
                                <img src="${product.imageUrl}" alt="Product Image" class="img-fluid product-img">
                            </div>
                        </div>

                        <div class="col-md-8 mb-4">
                            <div class="product-card">
                                <div class="form-group" id="nameField">
                                    <label for="name">Tên Sản Phẩm</label>
                                    <input type="text" class="form-control editable-field" id="name" name="name" value="${product.name}" readonly>
                                </div>

                                <div class="form-group" id="descriptionField">
                                    <label for="description">Mô Tả</label>
                                    <textarea class="form-control editable-field" id="description" name="description" rows="3" readonly>${product.description}</textarea>
                                </div>

                                <div class="form-group" id="priceField">
                                    <label for="price">Giá</label>
                                    <input type="number" class="form-control editable-field" id="price" name="price" value="${product.price}" step="0.01" readonly>
                                </div>

                                <div class="form-group" id="stockQuantityField">
                                    <label for="stockQuantity">Số Lượng Tồn Kho</label>
                                    <input type="number" class="form-control editable-field" id="stockQuantity" name="stockQuantity" value="${product.stockQuantity}" readonly>
                                </div>

                                <div class="form-group" id="brandField">
                                    <label for="brand">Thương Hiệu</label>
                                    <select class="form-control editable-field" id="brand" name="brandId" disabled>
                                        <c:forEach var="brand" items="${brands}">
                                            <option value="${brand.brandId}" ${product.brand.brandId == brand.brandId ? 'selected' : ''}>${brand.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-group" id="categoryField">
                                    <label for="category">Danh Mục</label>
                                    <select class="form-control editable-field" id="category" name="categoryId" disabled>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryId}" ${product.category.categoryId == category.categoryId ? 'selected' : ''}>${category.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-group" id="statusField">
                                    <label for="status">Trạng Thái</label>
                                    <select class="form-control editable-field" id="status" name="status" disabled>
                                        <option value="ACTIVE" ${product.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                        <option value="INACTIVE" ${product.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                                    </select>
                                </div>

                                <div class="form-group" id="createdAtField">
                                    <label for="createdAt">Ngày Tạo</label>
                                    <input type="text" class="form-control readonly-field" id="createdAt" name="createdAt" value="${product.createdAt}" readonly>
                                </div>

                                <div class="form-group" id="updatedAtField">
                                    <label for="updatedAt">Ngày Cập Nhật</label>
                                    <input type="text" class="form-control readonly-field" id="updatedAt" name="updatedAt" value="${product.updatedAt}" readonly>
                                </div>

                                <div class="mt-3" id="saveCancelButtons" style="display: none;">
                                    <button type="submit" class="btn btn-primary btn-sm">Lưu Thay Đổi</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function toggleEditMode() {
                let formFields = document.querySelectorAll('input, textarea, select');
                formFields.forEach(function (field) {
                    if (field.id !== "createdAt" && field.id !== "updatedAt" && field.id !== "productId") {
                        if (field.readOnly || field.disabled) {
                            field.readOnly = false;
                            field.disabled = false;
                            field.classList.add('editing');
                        } else {
                            field.readOnly = true;
                            field.disabled = true;
                            field.classList.remove('editing');
                            if (field.id === "name")
                                field.value = "${product.name}";
                            if (field.id === "description")
                                field.value = "${product.description}";
                            if (field.id === "price")
                                field.value = "${product.price}";
                            if (field.id === "stockQuantity")
                                field.value = "${product.stockQuantity}";
                            if (field.id === "brand")
                                field.value = "${product.brand.brandId}";
                            if (field.id === "category")
                                field.value = "${product.category.categoryId}";
                            if (field.id === "status")
                                field.value = "${product.status}";
                        }
                    }
                });

                let saveCancelButtons = document.getElementById('saveCancelButtons');
                saveCancelButtons.style.display = saveCancelButtons.style.display === 'none' ? 'block' : 'none';

                let editButton = document.getElementById('editButton');
                editButton.textContent = editButton.textContent === 'Sửa Sản Phẩm' ? 'Hủy Chỉnh Sửa' : 'Sửa Sản Phẩm';
            }
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

<style>
    body {
        background-color: #f4f6f9;
        font-family: 'Roboto', sans-serif;
        color: #333;
    }
    .product-card {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 6px 12px rgba(0,0,0,0.08);
        padding: 25px;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0,0,0,0.12);
    }
    .product-img {
        max-height: 300px;
        width: auto;
        object-fit: contain;
        border-radius: 8px;
        background: #f8f9fa;
        padding: 15px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        display: block;
        margin: 0 auto;
    }
    .btn-edit {
        background-color: #3399ff;
        border-color: #007bff;
        color: white;
        border-radius: 8px;
        padding: 8px 16px;
    }
    .btn-edit:hover {
        transform: scale(1.05);
        background-color: #007bff;
        border-color: #0056b3;
    }
    .btn-danger {
        background-color: #ff0033;
        border-color: #ff0000;
        color: white;
        border-radius: 8px;
        padding: 8px 16px;
    }
    .btn-danger:hover {
        transform: scale(1.05);
        background-color: #ff0000;
        border-color: #cc0000;
    }
    .btn-secondary {
        background-color: #6c757d;
        border-color: #6c757d;
        border-radius: 8px;
        padding: 8px 16px;
    }
    .btn-secondary:hover {
        background-color: #5a6268;
        border-color: #545b62;
        transform: scale(1.05);
    }
    .editable-field {
        background-color: #e9ecef;
    }
    .editable-field.editing {
        background-color: #ffffff;
    }
    .readonly-field {
        background-color: #e9ecef !important;
    }
    #saveCancelButtons {
        display: flex ; /* Force flexbox to align buttons in a row */
        flex-wrap: nowrap; /* Prevent wrapping to the next line */
        gap: 10px; /* Space between buttons */
        justify-content: flex-start; /* Align buttons to the start */
        align-items: center; /* Vertically center the buttons */
        width: 100%; /* Ensure the container takes full available width */
        min-width: 300px; /* Ensure enough space for both buttons */
    }

    #saveCancelButtons .btn {
        width: 120px;
        height: 40px;
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: #6c757d;
        border-color: #6c757d;
        border-radius: 8px;
        color: white;
        text-decoration: none;
        transition: transform 0.3s ease, background-color 0.3s ease;
        flex-shrink: 0 !important; /* Prevent buttons from shrinking */
        white-space: nowrap; /* Prevent text wrapping inside buttons */
    }

    #saveCancelButtons .btn:hover {
        transform: scale(1.05);
    }

    #saveCancelButtons .btn-primary {
        background-color: #6c757d;
        border-color: #6c757d;
    }

    #saveCancelButtons .btn-primary:hover {
        background-color: #0066ff !important;
        border-color: #0066ff;
    }

    #saveCancelButtons .btn-secondary {
        background-color: #6c757d;
        border-color: #6c757d;
    }

    #saveCancelButtons .btn-secondary:hover {
        background-color: #dc3545;
        border-color: #dc3545;
    }
</style>