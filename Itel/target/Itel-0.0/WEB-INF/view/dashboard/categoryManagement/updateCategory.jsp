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
        <title>Category Details Management Page</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <!-- Gọi sidebar -->
        <jsp:include page="../../components/sidebar.jsp" />
        <!-- Gọi toast -->
        <jsp:include page="../../components/toast.jsp" />

        <div class="content">
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center mb-4 mt-4">
                    <h2 class="text-dark">Category Details</h2>
                </div>

                <a href="<%= ProjectPaths.HREF_TO_CATEGORYMANAGEMENT %>" class="btn btn-secondary mt-3">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại danh sách danh mục
                </a>

                <button id="editButton" class="btn btn-warning mt-3" onclick="toggleEditMode()">
                    <i class="fas fa-edit"></i>
                    Sửa Danh Mục
                </button>

                <form id="categoryForm" action="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_EDIT_CATEGORY %>" method="post" novalidate>
                    <input type="hidden" id="categoryId" name="categoryId" value="${category.categoryId}">                    
                    <div class="row mt-4">
                        <div class="col-md-4 mb-4">
                            <div class="category-card">
                                <img src="${category.imageUrl}" alt="Category Image" class="img-fluid category-img">
                                <div class="form-group image-url-field" id="imageUrlField">
                                    <label for="imageUrl">URL Hình Ảnh</label>
                                    <input type="text" class="form-control editable-field" id="imageUrl" name="imageUrl" value="${category.imageUrl}" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-8 mb-4">
                            <div class="category-card">
                                <div class="form-group" id="nameField">
                                    <label for="name">Tên Danh Mục</label>
                                    <input type="text" class="form-control editable-field" id="name" name="name" value="${category.name}" readonly required>
                                    <div class="invalid-feedback">Tên danh mục không được để trống.</div>
                                </div>

                                <div class="form-group" id="descriptionField">
                                    <label for="description">Mô Tả</label>
                                    <textarea class="form-control editable-field" id="description" name="description" rows="3" readonly>${category.description}</textarea>
                                </div>
                                
                                <div class="form-group" id="statusField">
                                    <label for="status">Trạng Thái</label>
                                    <select class="form-control editable-field" id="status" name="status" disabled required>
                                        <option value="ACTIVE" ${category.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                        <option value="INACTIVE" ${category.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                                    </select>
                                    <div class="invalid-feedback">Vui lòng chọn trạng thái.</div>
                                </div>

                                <div class="mt-3" id="saveCancelButtons" style="display: none;">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i>
                                        Lưu Thay Đổi
                                    </button>
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
                    if (field.id !== "categoryId") {
                        if (field.readOnly || field.disabled) {
                            field.readOnly = false;
                            field.disabled = false;
                            field.classList.add('editing');
                        } else {
                            field.readOnly = true;
                            field.disabled = true;
                            field.classList.remove('editing');
                            field.classList.remove('is-invalid');
                            if (field.id === "name")
                                field.value = "${category.name}";
                            if (field.id === "description")
                                field.value = "${category.description}";
                            if (field.id === "imageUrl")
                                field.value = "${category.imageUrl}";
                            if (field.id === "status")
                                field.value = "${category.status}";
                        }
                    }
                });

                let imageUrlField = document.getElementById('imageUrlField');
                imageUrlField.classList.toggle('editing');
                let saveCancelButtons = document.getElementById('saveCancelButtons');
                saveCancelButtons.style.display = saveCancelButtons.style.display === 'none' ? 'block' : 'none';
                let editButton = document.getElementById('editButton');
                editButton.innerHTML = editButton.innerHTML.includes('Sửa Danh Mục') ?
                        '<i class="fas fa-times"></i> Hủy Chỉnh Sửa' :
                        '<i class="fas fa-edit"></i> Sửa Danh Mục';
            }

            // Form validation on submit
            document.getElementById('categoryForm').addEventListener('submit', function(event) {
                let isValid = true;
                const nameInput = document.getElementById('name');
                const statusInput = document.getElementById('status');

                if (!nameInput.value.trim()) {
                    nameInput.classList.add('is-invalid');
                    isValid = false;
                } else {
                    nameInput.classList.remove('is-invalid');
                }

                if (!statusInput.value) {
                    statusInput.classList.add('is-invalid');
                    isValid = false;
                } else {
                    statusInput.classList.remove('is-invalid');
                }

                if (!isValid) {
                    event.preventDefault();
                    event.stopPropagation();
                }
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        color: #2d3748;
        line-height: 1.6;
        min-height: 100vh;
    }

    .content {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        border-radius: 20px;
        margin: 20px;
        padding: 30px;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        min-height: calc(100vh - 40px);
    }

    h2 {
        color: #1a202c;
        font-weight: 700;
        font-size: 2.5rem;
        margin-bottom: 1rem;
        position: relative;
        display: inline-block;
    }

    h2::after {
        content: '';
        position: absolute;
        bottom: -8px;
        left: 0;
        width: 60px;
        height: 4px;
        background: linear-gradient(90deg, #667eea, #764ba2);
        border-radius: 2px;
    }

    .btn {
        border: none;
        border-radius: 12px;
        padding: 12px 24px;
        font-weight: 600;
        font-size: 0.95rem;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        position: relative;
        overflow: hidden;
    }

    .btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        transition: left 0.5s;
    }

    .btn:hover::before {
        left: 100%;
    }

    .btn-secondary {
        background: linear-gradient(135deg, #718096, #4a5568);
        color: white;
        box-shadow: 0 4px 15px rgba(113, 128, 150, 0.4);
    }

    .btn-secondary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(113, 128, 150, 0.6);
        color: white;
    }

    .btn-warning {
        background: linear-gradient(135deg, #ed8936, #dd6b20);
        color: white;
        box-shadow: 0 4px 15px rgba(237, 137, 54, 0.4);
    }

    .btn-warning:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(237, 137, 54, 0.6);
        color: white;
    }

    .btn-primary {
        background: linear-gradient(135deg, #4299e1, #3182ce);
        color: white;
        box-shadow: 0 4px 15px rgba(66, 153, 225, 0.4);
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(66, 153, 225, 0.6);
        color: white;
    }

    .category-card {
        background: white;
        border-radius: 20px;
        padding: 30px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        position: relative;
        overflow: hidden;
    }

    .category-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, #667eea, #764ba2);
    }

    .category-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
    }

    .category-img {
        max-height: 350px;
        width: 100%;
        object-fit: contain;
        border-radius: 16px;
        background: linear-gradient(135deg, #f7fafc, #edf2f7);
        padding: 20px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;
    }

    .category-img:hover {
        transform: scale(1.02);
    }

    .form-group {
        margin-bottom: 1.5rem;
        position: relative;
    }

    .form-group label {
        font-weight: 600;
        color: #4a5568;
        margin-bottom: 8px;
        display: block;
        font-size: 0.95rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .form-control {
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        padding: 12px 16px;
        font-size: 1rem;
        transition: all 0.3s ease;
        background: #f8fafc;
        color: #2d3748;
    }

    .form-control:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        background: white;
        outline: none;
    }

    .form-control:hover {
        border-color: #cbd5e0;
    }

    .editable-field {
        background: #f1f5f9;
        border-color: #cbd5e0;
    }

    .editable-field.editing {
        background: white;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .readonly-field {
        background: #edf2f7 !important;
        color: #718096;
        cursor: not-allowed;
    }

    #saveCancelButtons {
        display: flex;
        gap: 15px;
        justify-content: flex-start;
        align-items: center;
        margin-top: 20px;
        padding-top: 20px;
        border-top: 2px solid #e2e8f0;
    }

    #saveCancelButtons .btn {
        min-width: 140px;
        height: 48px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        font-size: 0.9rem;
    }

    @media (max-width: 768px) {
        .content {
            margin: 10px;
            padding: 20px;
            border-radius: 15px;
        }

        h2 {
            font-size: 2rem;
        }

        .category-card {
            padding: 20px;
            margin-bottom: 20px;
        }

        .btn {
            padding: 10px 20px;
            font-size: 0.9rem;
        }

        #saveCancelButtons {
            flex-direction: column;
            align-items: stretch;
        }

        #saveCancelButtons .btn {
            width: 100%;
            min-width: auto;
        }
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .category-card {
        animation: fadeInUp 0.6s ease-out;
    }

    .category-card:nth-child(2) {
        animation-delay: 0.1s;
    }

    select.form-control {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
        background-position: right 12px center;
        background-repeat: no-repeat;
        background-size: 16px;
        padding-right: 40px;
        appearance: none;
    }

    textarea.form-control {
        resize: vertical;
        min-height: 100px;
    }

    .btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
        position: relative;
    }

    .btn:disabled::after {
        content: '';
        position: absolute;
        width: 16px;
        height: 16px;
        margin: auto;
        border: 2px solid transparent;
        border-top-color: currentColor;
        border-radius: 50%;
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        0% {
            transform: rotate(0deg);
        }
        100% {
            transform: rotate(360deg);
        }
    }

    .form-control.is-valid {
        border-color: #48bb78;
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%2348bb78' d='m2.3 6.73.94-.94 1.44 1.44L7.4 4.5l.94.94L4.66 9.2z'/%3e%3c/svg%3e");
    }

    .form-control.is-invalid {
        border-color: #f56565;
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23f56565'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath d='m5.5 5.5 1 1m0-1-1 1'/%3e%3c/svg%3e");
    }

    .invalid-feedback {
        display: none;
        color: #f56565;
        font-size: 0.875rem;
        margin-top: 0.25rem;
    }

    .form-control.is-invalid ~ .invalid-feedback {
        display: block;
    }

    .form-control:not([readonly]):not([disabled]):hover {
        border-color: #a0aec0;
        background: white;
    }

    .form-group:focus-within label {
        color: #667eea;
        transform: translateY(-2px);
        transition: all 0.3s ease;
    }

    .image-url-field {
        display: none;
    }

    .image-url-field.editing {
        display: block;
    }
</style>