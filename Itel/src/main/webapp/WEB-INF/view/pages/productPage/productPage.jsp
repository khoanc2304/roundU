<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="true" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Page</title>
        <!-- Bootstrap 5.3 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous"/>
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <!-- AOS CSS -->
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
        <style>
            .range-slider input[type=range] {
                -webkit-appearance: none;
                appearance: none;
                width: 100%;
                height: 6px;
                background: linear-gradient(to right, #d3d3d3 var(--min, 0%), #3498db var(--min, 0%) var(--max, 100%), #d3d3d3 var(--max, 100%));
                border-radius: 3px;
                outline: none;
                position: absolute;
            }
            .range-slider input[type=range]::-webkit-slider-thumb {
                -webkit-appearance: none;
                appearance: none;
                width: 18px;
                height: 18px;
                border-radius: 50%;
                background: #3498db;
                border: 2px solid #fff;
                cursor: pointer;
                position: relative;
                z-index: 3;
            }
            .range-slider input[type=range]::-moz-range-thumb {
                width: 18px;
                height: 18px;
                border-radius: 50%;
                background: #3498db;
                border: 2px solid #fff;
                cursor: pointer;
                position: relative;
                z-index: 3;
            }
            .filter-section .form-check {
                margin-bottom: 0.5rem;
            }
            .filter-section button {
                min-width: 60px;
            }
            .card {
                border: 1px solid #ddd;
                border-radius: 5px;
                text-align: center;
            }
            .card-img-top {
                object-fit: contain;
                height: 180px;
                border-top-left-radius: 5px;
                border-top-right-radius: 5px;
            }
            .card-title {
                font-size: 1rem;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            .card-text.text-danger {
                font-weight: bold;
                font-size: 1.1rem;
            }
            .btn-primary {
                width: 100%;
            }
        </style>
    </head>
    <body style="background-color: #e1dbdb; margin: 0; font-family: 'Roboto', sans-serif;">
        <!-- Navbar (optional) -->
        <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>

        <div class="container mt-4">
            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="#/">Trang chủ</a></li>
                        <c:if test="${not empty category}">
                        <li class="breadcrumb-item">
                            <a href="#">${category.name}</a>
                        </li>
                    </c:if>
                    <c:if test="${not empty brand}">
                        <li class="breadcrumb-item">
                            <a href="#">${brand.name}</a>
                        </li>
                    </c:if>
                    <c:if test="${not empty filterName}">
                        <li class="breadcrumb-item active" aria-current="page">${filterName}</li>
                        </c:if>
                </ol>
            </nav>

            <div class="row">
                <!-- Filter Section -->
                <%@ include file="filterLaptop.jsp" %>

                <!-- Product List -->
                <div class="col-lg-9">
                    <div class="row row-cols-2 row-cols-sm-3 row-cols-lg-4 g-3" id="productList">
                        <c:forEach var="entry" items="${sessionScope.mapProduct_Detail.entrySet()}">
                            <c:set var="product" value="${entry.key}" />
                            <c:set var="details" value="${entry.value}" />
                            <div class="col" data-cpu="${details[0]}">
                                <div class="card h-100">
                                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&id=${product.productId}">
                                        <img src="${product.imageUrl}" class="card-img-top" alt="Product Image">
                                    </a>
                                    <div class="card-body">
                                        <h6 class="card-title">${product.name}</h6>
                                        <c:if test="${sessionScope.categoryId == 1 }">
                                            <div class="product-specs d-flex flex-wrap justify-content-center gap-2 bg-light p-2 rounded mb-2">
                                                <span class="badge text-dark bg-light border"><i class="fas fa-microchip me-1"></i>${details[0]}</span>
                                                <span class="badge text-dark bg-light border"><i class="fas fa-memory me-1"></i>${details[1]}</span>
                                                <span class="badge text-dark bg-light border"><i class="fas fa-hdd me-1"></i>${details[2]}</span>
                                                <span class="badge text-dark bg-light border"><i class="fas fa-tv me-1"></i>${details[3]}</span>
                                                <span class="badge text-dark bg-light border"><i class="fas fa-sync-alt me-1"></i>${details[4]}</span>
                                            </div>
                                        </c:if>
                                        <p class="card-text text-danger">
                                            <fmt:formatNumber value="${product.price}" type="number" pattern="#,###" currencySymbol="" groupingUsed="true" /> VNĐ
                                        </p>
                                        <a href="#" class="btn btn-primary btn-sm mt-2">
                                            <i class="fas fa-plus me-1"></i> Thêm vào so sánh
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script>
            // Store product data client-side
            const products = [
            <c:forEach var="entry" items="${sessionScope.mapProduct_Detail.entrySet()}" varStatus="loop">
                <c:set var="product" value="${entry.key}" />
                <c:set var="details" value="${entry.value}" />
            {
            id: "${product.productId}",
                    name: "${product.name}",
                    imageUrl: "${product.imageUrl}",
                    price: ${product.price},
                    cpu: "${details[0]}",
                    ram: "${details[1]}",
                    storage: "${details[2]}",
                    screen: "${details[3]}",
                    gpu: "${details[4]}"
            }${loop.last ? '' : ','}
            </c:forEach>
            ];
            document.addEventListener('DOMContentLoaded', function() {
            const rangeMin = document.getElementById("rangeMin");
            const rangeMax = document.getElementById("rangeMax");
            const minPriceInput = document.getElementById("minPriceInput");
            const maxPriceInput = document.getElementById("maxPriceInput");
            const productList = document.querySelector("#productList");
            if (!rangeMin || !rangeMax || !minPriceInput || !maxPriceInput) {
            console.error("Filter elements not found in the DOM");
            return;
            }

            function formatVND(value) {
            return Number(value).toLocaleString("vi-VN") + "đ";
            }

            function updateSliderRange() {
            const min = parseInt(rangeMin.value);
            const max = parseInt(rangeMax.value);
            const maxValue = 200000000;
            const minPercent = (min / maxValue) * 100;
            const maxPercent = (max / maxValue) * 100;
            rangeMin.style.setProperty('--min', `${minPercent}%`);
            rangeMin.style.setProperty('--max', `${maxPercent}%`);
            rangeMax.style.setProperty('--min', `${minPercent}%`);
            rangeMax.style.setProperty('--max', `${maxPercent}%`);
            minPriceInput.value = formatVND(min);
            maxPriceInput.value = formatVND(max);
            fetchFilteredProducts();
            }

            function syncRangeFromInputs() {
            let min = parseInt(minPriceInput.value.replace(/\D/g, "")) || 0;
            let max = parseInt(maxPriceInput.value.replace(/\D/g, "")) || 0;
            if (min > max) [min, max] = [max, min];
            rangeMin.value = min;
            rangeMax.value = max;
            updateSliderRange();
            }

            // Client-side CPU filtering
            function filterProductsByCPU() {
            const selectedCPUs = Array.from(document.querySelectorAll('input.cpu-filter:checked')).map(cb => cb.value);
            const productElements = productList.querySelectorAll('.col');
            productElements.forEach(element => {
            const productCPU = element.dataset.cpu || '';
            if (selectedCPUs.length === 0 || selectedCPUs.includes(productCPU)) {
            element.style.display = 'block';
            } else {
            element.style.display = 'none';
            }
            });
            }

            // Event listeners
            document.querySelectorAll('input.cpu-filter').forEach(cb => {
            cb.addEventListener('change', filterProductsByCPU);
            });
            document.querySelectorAll('a.brand-filter').forEach(button => {
            button.addEventListener('click', function(e) {
            e.preventDefault();
            this.classList.toggle('active');
            fetchFilteredProducts();
            });
            });
            rangeMin.addEventListener("input", updateSliderRange);
            rangeMax.addEventListener("input", updateSliderRange);
            minPriceInput.addEventListener("change", syncRangeFromInputs);
            maxPriceInput.addEventListener("change", syncRangeFromInputs);
            // Placeholder for server-side filtering
            function fetchFilteredProducts() {
            // Server-side filtering logic
            }

            // Initial load
            filterProductsByCPU();
            });
        </script>
    </body>
</html>