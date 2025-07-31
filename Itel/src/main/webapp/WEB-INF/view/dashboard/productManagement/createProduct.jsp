<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="true" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Sản Phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <jsp:include page="../../components/sidebar.jsp" />
    <jsp:include page="../../components/toast.jsp" />
    
    <div class="container mt-5">
        <h2 class="mb-4">Thêm Sản Phẩm Mới</h2>
        <form action="main" method="POST" id="productForm" novalidate>
            <input type="hidden" name="action" value="createProduct">
            <div class="mb-3">
                <label for="name" class="form-label">Tên Sản Phẩm</label>
                <input type="text" class="form-control" id="name" name="name" required oninput="restrictNameInput(this)">
                <div class="invalid-feedback" id="nameFeedback">Vui lòng nhập tên sản phẩm.</div>
            </div>
            <div class="mb-3">
                <label for="description" class="form-label">Mô Tả</label>
                <textarea class="form-control" id="description" name="description" rows="4"></textarea>
<!--                <div class="invalid-feedback">Vui lòng nhập mô tả sản phẩm.</div>-->
            </div>
            <div class="mb-3">
                <label for="price" class="form-label">Giá Sản Phẩm</label>
                <input type="text" class="form-control" id="price" name="price" required oninput="restrictNumberInput(this)">
                <div class="invalid-feedback" id="priceFeedback">Giá phải là số không âm (ví dụ: 92.9 hoặc 92,9).</div>
            </div>
            <div class="mb-3">
                <label for="stockQuantity" class="form-label">Số Lượng Tồn Kho</label>
                <input type="text" class="form-control" id="stockQuantity" name="stockQuantity" required oninput="restrictIntegerInput(this)">
                <div class="invalid-feedback" id="stockFeedback">Số lượng tồn kho phải là số nguyên không âm.</div>
            </div>
            <div class="mb-3">
                <label for="category" class="form-label">Danh Mục</label>
                <select class="form-select" id="category" name="categoryId" required>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.categoryId}">${category.name}</option>
                    </c:forEach>
                </select>
                <div class="invalid-feedback">Vui lòng chọn danh mục.</div>
            </div>
            <div class="mb-3">
                <label for="brand" class="form-label">Thương Hiệu</label>
                <select class="form-select" id="brand" name="brandId" required>
                    <c:forEach var="brand" items="${brands}">
                        <option value="${brand.brandId}">${brand.name}</option> 
                    </c:forEach>
                </select>
                <div class="invalid-feedback">Vui lòng chọn thương hiệu.</div>
            </div>
            <div class="mb-3">
                <label for="imageUrl" class="form-label">URL Hình Ảnh</label>
                <input type="text" class="form-control" id="imageUrl" name="imageUrl" placeholder="Nhập URL hình ảnh sản phẩm">
            </div>
            <button type="submit" class="btn btn-primary">Thêm Sản Phẩm</button>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function restrictNameInput(input) {
            let feedback = document.getElementById('nameFeedback');
            let value = input.value.trim();

            if (!value) {
                input.classList.add('is-invalid');
                feedback.textContent = 'Tên sản phẩm không được để trống.';
            } else {
                input.classList.remove('is-invalid');
                feedback.textContent = 'Vui lòng nhập tên sản phẩm.';
            }
        }

        function restrictNumberInput(input) {
            let feedback = document.getElementById('priceFeedback');
            let value = input.value.replace(',', '.');

            if (!value) {
                input.classList.add('is-invalid');
                feedback.textContent = 'Giá không được để trống.';
            } else if (isNaN(value) || /[^0-9.]/.test(value)) {
                input.classList.add('is-invalid');
                feedback.textContent = 'Giá chỉ được chứa số và dấu thập phân.';
            } else if (parseFloat(value) < 0) {
                input.classList.add('is-invalid');
                feedback.textContent = 'Giá không được âm.';
            } else {
                input.classList.remove('is-invalid');
                feedback.textContent = 'Giá phải là số không âm (ví dụ: 92.9 hoặc 92,9).';
                let parts = value.split('.');
                if (parts.length > 2) {
                    value = parts[0] + '.' + parts.slice(1).join('');
                }
                if (value.startsWith('0') && value.length > 1 && !value.startsWith('0.')) {
                    value = value.replace(/^0+/, '') || '0';
                }
                input.value = value;
            }
        }

        function restrictIntegerInput(input) {
            let feedback = document.getElementById('stockFeedback');
            let value = input.value;

            if (!value) {
                input.classList.add('is-invalid');
                feedback.textContent = 'Số lượng không được để trống.';
            } else if (isNaN(value) || /[^0-9]/.test(value)) {
                input.classList.add('is-invalid');
                feedback.textContent = 'Số lượng tồn kho chỉ được chứa số nguyên (>=0).';
            } else if (parseInt(value) < 0) {
                input.classList.add('is-invalid');
                feedback.textContent = 'Số lượng không được âm.';
            } else if (!Number.isInteger(parseFloat(value))) {
                input.classList.add('is-invalid');
                feedback.textContent = 'Số lượng tồn kho chỉ được chứa số nguyên (>=0).';
            } else {
                input.classList.remove('is-invalid');
                feedback.textContent = 'Số lượng tồn kho phải là số nguyên không âm.';
                input.value = parseInt(value);
            }
        }

        document.getElementById('productForm').addEventListener('submit', function(event) {
            let isValid = true;
            const priceInput = document.getElementById('price');
            const stockInput = document.getElementById('stockQuantity');
            const nameInput = document.getElementById('name');
            const descriptionInput = document.getElementById('description');
            const brandInput = document.getElementById('brand');
            const categoryInput = document.getElementById('category');
            const priceFeedback = document.getElementById('priceFeedback');
            const stockFeedback = document.getElementById('stockFeedback');
            const nameFeedback = document.getElementById('nameFeedback');

            // Validate name
            if (!nameInput.value.trim()) {
                nameInput.classList.add('is-invalid');
                nameFeedback.textContent = 'Tên sản phẩm không được để trống.';
                isValid = false;
            } else {
                nameInput.classList.remove('is-invalid');
            }

            // Validate price
            let priceValue = priceInput.value.replace(',', '.');
            if (!priceValue) {
                priceInput.classList.add('is-invalid');
                priceFeedback.textContent = 'Giá không được để trống.';
                isValid = false;
            } else if (isNaN(priceValue) || /[^0-9.]/.test(priceValue)) {
                priceInput.classList.add('is-invalid');
                priceFeedback.textContent = 'Giá chỉ được chứa số và dấu thập phân.';
                isValid = false;
            } else if (parseFloat(priceValue) < 0) {
                priceInput.classList.add('is-invalid');
                priceFeedback.textContent = 'Giá không được âm.';
                isValid = false;
            } else {
                priceInput.classList.remove('is-invalid');
                priceInput.value = priceValue;
            }

            // Validate stock quantity
            if (!stockInput.value) {
                stockInput.classList.add('is-invalid');
                stockFeedback.textContent = 'Số lượng không được để trống.';
                isValid = false;
            } else if (isNaN(stockInput.value) || /[^0-9]/.test(stockInput.value)) {
                stockInput.classList.add('is-invalid');
                stockFeedback.textContent = 'Số lượng tồn kho chỉ được chứa số nguyên (>=0).';
                isValid = false;
            } else if (parseInt(stockInput.value) < 0) {
                stockInput.classList.add('is-invalid');
                stockFeedback.textContent = 'Số lượng không được âm.';
                isValid = false;
            } else if (!Number.isInteger(parseFloat(stockInput.value))) {
                stockInput.classList.add('is-invalid');
                stockFeedback.textContent = 'Số lượng tồn kho chỉ được chứa số nguyên (>=0).';
                isValid = false;
            } else {
                stockInput.classList.remove('is-invalid');
                stockInput.value = parseInt(stockInput.value);
            }

//            if (!descriptionInput.value.trim()) {
//                descriptionInput.classList.add('is-invalid');
//                isValid = false;
//            } else {
//                descriptionInput.classList.remove('is-invalid');
//            }

            if (!brandInput.value) {
                brandInput.classList.add('is-invalid');
                isValid = false;
            } else {
                brandInput.classList.remove('is-invalid');
            }

            if (!categoryInput.value) {
                categoryInput.classList.add('is-invalid');
                isValid = false;
            } else {
                categoryInput.classList.remove('is-invalid');
            }

            if (!isValid) {
                event.preventDefault();
                event.stopPropagation();
            }
        });
    </script>
</body>
</html>

<style>
    .container {
        max-width: 800px;
        margin: 0 auto;
        padding: 40px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    }

    h2 {
        font-size: 28px;
        font-weight: 600;
        margin-bottom: 30px;
        text-align: center;
    }

    .form-control, .form-select {
        border-radius: 6px;
        font-size: 16px;
    }

    .form-control:focus, .form-select:focus {
        border-color: #398cb6;
        box-shadow: 0 0 5px rgba(57, 140, 182, 0.6);
    }

    textarea {
        resize: vertical;
    }

    .btn-primary {
        background-color: #398cb6;
        border: none;
        padding: 12px 25px;
        border-radius: 6px;
        font-size: 18px;
        width: 100%;
        transition: background-color 0.3s, transform 0.3s;
    }

    .btn-primary:hover {
        background-color: #2c7bb8;
        transform: scale(1.05);
    }

    .form-label {
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 8px;
    }

    form {
        background-color: #f9f9f9;
        border-radius: 8px;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    .invalid-feedback {
        font-size: 14px;
    }

    @media (max-width: 576px) {
        .container {
            padding: 20px;
        }

        h2 {
            font-size: 24px;
        }

        .btn-primary {
            font-size: 16px;
            padding: 10px;
        }
    }
</style>