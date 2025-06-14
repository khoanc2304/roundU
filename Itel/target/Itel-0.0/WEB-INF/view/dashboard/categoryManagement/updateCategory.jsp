<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Category Details Management Page</title>
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
        <!-- Gọi sidebar -->
        <jsp:include page="../../components/sidebar.jsp" />
        <!-- Gọi toast -->
        <jsp:include page="../../components/toast.jsp" />

        <div class="content">
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="text-dark">Category Details</h2>
                </div>

                <a href="<%= ProjectPaths.HREF_TO_CATEGORYMANAGEMENT %>" class="btn btn-secondary mt-3">Quay lại danh sách danh mục</a>

                <button id="editButton" class="btn btn-warning mt-3" onclick="toggleEditMode()">Sửa Danh Mục</button>

                <form id="categoryForm" action="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_EDIT_CATEGORY %>" method="post">
                    <input type="hidden" id="categoryId" name="categoryId" value="${category.categoryId}">                    
                    <div class="row mt-4">
                        <div class="col-md-4 mb-4">
                            <div class="category-card">
                                <img src="${category.imageUrl}" alt="Category Image" class="img-fluid category-img">
                            </div>
                        </div>

                        <div class="col-md-8 mb-4">
                            <div class="category-card">
                                <div class="form-group" id="nameField">
                                    <label for="name">Tên Danh Mục</label>
                                    <input type="text" class="form-control editable-field" id="name" name="name" value="${category.name}" readonly>
                                </div>

                                <div class="form-group" id="descriptionField">
                                    <label for="description">Mô Tả</label>
                                    <textarea class="form-control editable-field" id="description" name="description" rows="3" readonly>${category.description}</textarea>
                                </div>
                                
                                <div class="form-group" id="imageUrlField">
                                    <label for="imageUrl">Image URL</label>
                                    <textarea class="form-control editable-field" id="imageUrl" name="imageUrl" rows="3" readonly>${category.imageUrl}</textarea>
                                </div>
                                
                                <div class="form-group" id="statusField">
                                    <label for="status">Trạng Thái</label>
                                    <select class="form-control editable-field" id="status" name="status" disabled>
                                        <option value="ACTIVE" ${category.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                        <option value="INACTIVE" ${category.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                                    </select>
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
                    if (field.id !== "categoryId") {
                        if (field.readOnly || field.disabled) {
                            field.readOnly = false;
                            field.disabled = false;
                            field.classList.add('editing');
                        } else {
                            field.readOnly = true;
                            field.disabled = true;
                            field.classList.remove('editing');
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

                let saveCancelButtons = document.getElementById('saveCancelButtons');
                saveCancelButtons.style.display = saveCancelButtons.style.display === 'none' ? 'block' : 'none';

                let editButton = document.getElementById('editButton');
                editButton.textContent = editButton.textContent === 'Sửa Danh Mục' ? 'Hủy Chỉnh Sửa' : 'Sửa Danh Mục';
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
    .category-card {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 6px 12px rgba(0,0,0,0.08);
        padding: 25px;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .category-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0,0,0,0.12);
    }
    .category-img {
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
