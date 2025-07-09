<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="true" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Page</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous"/>
        
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    </head>
    
    <body style="background-color: #e1dbdb; margin: 0; font-family: 'Roboto', sans-serif;">
        <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>

        <div class="container mt-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="#/">Trang chủ</a></li>
                        <c:if test="${not empty category}">
                        <li class="breadcrumb-item"><a href="#">${category.name}</a></li>
                        </c:if>
                        <c:if test="${not empty brand}">
                        <li class="breadcrumb-item"><a href="#">${brand.name}</a></li>
                        </c:if>
                        <c:if test="${not empty filterName}">
                        <li class="breadcrumb-item active" aria-current="page">${filterName}</li>
                        </c:if>
                </ol>
            </nav>

            <div class="row">
                <%@ include file="filterLaptop.jsp" %>

                <div class="col-lg-9">
                    <div class="row row-cols-2 row-cols-sm-3 row-cols-lg-4 g-3" id="productList">
                        <c:forEach var="entry" items="${sessionScope.mapProduct_Detail.entrySet()}">
                            <c:set var="product" value="${entry.key}" />
                            <c:set var="details" value="${entry.value}" />
                            <div class="col" data-cpu="${fn:escapeXml(details[0])}">
                                <div class="card h-100">
                                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&id=${product.productId}">
                                        <img src="${fn:escapeXml(product.imageUrl) != '' ? fn:escapeXml(product.imageUrl) : 'https://via.placeholder.com/180'}" class="card-img-top" alt="Hình ảnh sản phẩm">
                                    </a>
                                    <div class="card-body">
                                        <h6 class="card-title">${fn:escapeXml(product.name)}</h6>
                                        <c:if test="${sessionScope.categoryId == 1}">
                                            <div class="product-specs d-flex flex-wrap justify-content-center gap-2 bg-light p-2 rounded mb-2">
                                                <span class="badge text-dark bg-light border"><i class="fas fa-microchip me-1"></i>${fn:escapeXml(details[0])}</span>
                                                <span class="badge text-dark bg-light border"><i class="fas fa-memory me-1"></i>${fn:escapeXml(details[1])}</span>
                                                <span class="badge text-dark bg-light border"><i class="fas fa-hdd me-1"></i>${fn:escapeXml(details[2])}</span>
                                                <span class="badge text-dark bg-light border"><i class="fas fa-tv me-1"></i>${fn:escapeXml(details[3])}</span>
                                                <span class="badge text-dark bg-light border"><i class="fas fa-sync-alt me-1"></i>${fn:escapeXml(details[4])}</span>
                                            </div>
                                        </c:if>
                                        <p class="card-text text-danger">
                                            <fmt:formatNumber value="${product.price}" type="number" pattern="#,###" currencySymbol="" groupingUsed="true" /> VNĐ
                                        </p>
                                        <a href="#" class="btn btn-primary btn-sm mt-2"><i class="fas fa-plus me-1"></i> Thêm vào so sánh</a>
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
            const products = [
            <c:forEach var="entry" items="${sessionScope.mapProduct_Detail.entrySet()}" varStatus="loop">
                <c:set var="product" value="${entry.key}" />
                <c:set var="details" value="${entry.value}" />
            {
            id: "${fn:escapeXml(product.productId)}",
                    name: "${fn:escapeXml(product.name)}",
                    imageUrl: "${fn:escapeXml(product.imageUrl) != '' ? fn:escapeXml(product.imageUrl) : 'https://via.placeholder.com/180'}",
                    price: ${product.price},
            cpu: "${fn:escapeXml(details[0])}",
                    ram: "${fn:escapeXml(details[1])}",
                    storage: "${fn:escapeXml(details[2])}",
                    gpu: "${fn:escapeXml(details[3])}",
            screen: "${fn:escapeXml(details[4])}",
                    os: "${fn:escapeXml(details[5])}",
                    keyboard: "${fn:escapeXml(details[7])}",
                    brandId: "${fn:escapeXml(product.brand.brandId)}"
            }${loop.last ? '' : ','}
            </c:forEach>
            ];
            console.log("Danh sách sản phẩm:", products);

            document.addEventListener('DOMContentLoaded', () => {
                const minPriceInput = document.getElementById('minPriceInput');
                const maxPriceInput = document.getElementById('maxPriceInput');
                const priceChecks = document.querySelectorAll('.price-check');
                const productList = document.querySelector("#productList");
                const ramButtons = document.querySelectorAll('button[data-filter="ram"]');
                const cpuCheckboxes = document.querySelectorAll('input.cpu-filter');
                const gpuCheckboxes = document.querySelectorAll('input[name="gpu"]');
                const storageButtons = document.querySelectorAll('button[data-filter="storage"]');
                const screenCheckboxes = document.querySelectorAll('input[name="screen"]');
                const osCheckboxes = document.querySelectorAll('input[name="os"]');
                const brandButtons = document.querySelectorAll('.brand-filter');
                const keyboardCheckboxes = document.querySelectorAll('input[name="keyboard"]');

                function formatVND(num) {
                    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
                }

                function parseVND(str) {
                    return parseInt(str.replace(/\./g, '')) || 0;
                }

                function normalize(str) {
                    return (str || '').toLowerCase().trim().replace(/\s+/g, ' ').replace(/[-–—]/g, ' ');
                }

                function normalizeStorage(value) {
                    if (!value || value.trim() === '')
                        return '';
                    const normalized = normalize(value);
                    const match = normalized.match(/([\d.]+)/);
                    const num = match ? parseFloat(match[1]) : NaN;
                    if (normalized.includes("tb"))
                        return num >= 2 ? "2 TB" : "1 TB";
                    if (!isNaN(num)) {
                        if (num >= 2000)
                            return "2 TB";
                        else if (num >= 1000)
                            return "1 TB";
                        else
                            return num + " gb";
                    }
                    return normalized;
                }

                function normalizeScreenSize(screenStr) {
                    if (!screenStr)
                        return NaN;
                    const match = screenStr.match(/([\d.]+)/);
                    return match ? parseFloat(match[1]) : NaN;
                }

                priceChecks.forEach(checkbox => {
                    checkbox.addEventListener('change', () => {
                        let minVal = 0;
                        let maxVal = 200000000;

                        if (checkbox.id === 'all' && checkbox.checked) {
                            priceChecks.forEach(cb => cb.checked = cb.id === 'all');
                            minVal = 0;
                            maxVal = 200000000;
                        } else if (checkbox.checked) {
                            document.getElementById('all').checked = false;
                            switch (checkbox.value) {
                                case 'under10':
                                    minVal = 0;
                                    maxVal = 10000000;
                                    break;
                                case '10-20':
                                    minVal = 10000000;
                                    maxVal = 20000000;
                                    break;
                                case '20-30':
                                    minVal = 20000000;
                                    maxVal = 30000000;
                                    break;
                                case '30-40':
                                    minVal = 30000000;
                                    maxVal = 40000000;
                                    break;
                                case 'over40':
                                    minVal = 40000000;
                                    maxVal = 200000000;
                                    break;
                            }
                        }

                        minPriceInput.value = formatVND(minVal);
                        maxPriceInput.value = formatVND(maxVal);
                        filterProducts();
                    });
                });

                [minPriceInput, maxPriceInput].forEach(input => {
                    input.addEventListener('input', () => {
                        let minVal = parseVND(minPriceInput.value) || 0;
                        let maxVal = parseVND(maxPriceInput.value) || 200000000;
                        if (minVal > maxVal)
                            maxVal = minVal;
                        if (minVal < 0)
                            minVal = 0;
                        if (maxVal > 200000000)
                            maxVal = 200000000;
                        minPriceInput.value = formatVND(minVal);
                        maxPriceInput.value = formatVND(maxVal);
                        priceChecks.forEach(cb => cb.checked = cb.id === 'all' && minVal === 0 && maxVal === 200000000);
                    });

                    input.addEventListener('blur', () => {
                        let minVal = parseVND(minPriceInput.value) || 0;
                        let maxVal = parseVND(maxPriceInput.value) || 200000000;
                        if (maxVal < minVal)
                            maxPriceInput.value = formatVND(minVal);
                        if (minVal < 0)
                            minPriceInput.value = formatVND(0);
                        if (maxVal > 200000000)
                            maxPriceInput.value = formatVND(200000000);
                        filterProducts();
                    });
                });

                minPriceInput.value = formatVND(parseVND(minPriceInput.value) || 0);
                maxPriceInput.value = formatVND(parseVND(maxPriceInput.value) || 200000000);

                function filterProducts() {
                    const selectedRAMs = Array.from(ramButtons).filter(btn => btn.classList.contains("active")).map(btn => normalize(btn.dataset.value));
                    const selectedCPUs = Array.from(cpuCheckboxes).filter(cb => cb.checked && cb.id !== 'all-cpu').map(cb => normalize(cb.value));
                    const allCPUs = document.getElementById('all-cpu').checked;
                    const selectedGPUs = Array.from(gpuCheckboxes).filter(cb => cb.checked && cb.id !== 'all-gpu').map(cb => {
                        const normalizedValue = normalize(cb.value.replace(/series/i, '').trim());
                        return normalizedValue === 'apple gpu' ? 'apple' : normalizedValue;
                    });
                    const allGPUs = document.getElementById('all-gpu').checked;
                    const selectedStorages = Array.from(storageButtons).filter(btn => btn.classList.contains("active")).map(btn => normalizeStorage(btn.dataset.value));
                    const selectedScreens = Array.from(screenCheckboxes).filter(cb => cb.checked && cb.id !== 'all-screen').map(cb => cb.value);
                    const allScreens = document.getElementById('all-screen').checked;
                    const selectedOS = Array.from(osCheckboxes).filter(cb => cb.checked && cb.id !== 'all-os').map(cb => normalize(cb.value));
                    const allOS = document.getElementById('all-os').checked;
                    const selectedBrandIds = Array.from(brandButtons).filter(btn => btn.classList.contains("active")).map(btn => btn.dataset.brandId);
                    const selectedKeyboards = Array.from(keyboardCheckboxes).filter(cb => cb.checked && cb.id !== 'all-keyboard').map(cb => normalize(cb.value));
                    const allKeyboards = document.getElementById('all-keyboard').checked;
                    const minPrice = parseVND(minPriceInput.value) || 0;
                    const maxPrice = parseVND(maxPriceInput.value) || 200000000;

                    const productElements = productList.querySelectorAll('.col');
                    productElements.forEach(element => {
                        const productId = element.querySelector('a').getAttribute('href').split('id=')[1];
                        const product = products.find(p => p.id == productId);
                        if (!product || !product.storage) {
                            element.style.display = 'none';
                            return;
                        }
                        const normalizedProductStorage = normalizeStorage(product.storage);
                        const ramMatch = selectedRAMs.length === 0 || selectedRAMs.includes(normalize(product.ram));
                        const cpuMatch = allCPUs || (selectedCPUs.length === 0 || selectedCPUs.some(cpuFilter => normalize(product.cpu).startsWith(cpuFilter)));
                        const gpuMatch = allGPUs || (selectedGPUs.length === 0 || selectedGPUs.some(gpuFilter => normalize(product.gpu).includes(gpuFilter)));
                        const storageMatch = selectedStorages.length === 0 || selectedStorages.includes(normalizedProductStorage);
                        const screenMatch = allScreens || (selectedScreens.length === 0 || (() => {
                            const screenSize = normalizeScreenSize(product.screen);
                            if (isNaN(screenSize))
                                return false;
                            if (screenSize < 14)
                                return selectedScreens.includes("Dưới 14 inch");
                            if (screenSize >= 14 && screenSize < 15)
                                return selectedScreens.includes("14-15 inch");
                            return selectedScreens.includes("15-17 inch");
                        })());
                        const osMatch = allOS || (selectedOS.length === 0 || selectedOS.includes(normalize(product.os)));
                        const brandMatch = selectedBrandIds.length === 0 || selectedBrandIds.includes(String(product.brandId));
                        const keyboardMatch = allKeyboards || selectedKeyboards.length === 0 || selectedKeyboards.includes(normalize(product.keyboard));
                        const priceMatch = product.price >= minPrice && product.price <= maxPrice;
                        element.style.display = (priceMatch && ramMatch && cpuMatch && gpuMatch && storageMatch && screenMatch && osMatch && brandMatch && keyboardMatch) ? 'block' : 'none';
                    });
                }

                ramButtons.forEach(btn => {
                    btn.addEventListener('click', () => {
                        btn.classList.toggle('active');
                        filterProducts();
                    });
                });

                cpuCheckboxes.forEach(cb => {
                    cb.addEventListener('change', () => {
                        if (cb.id === 'all-cpu' && cb.checked) {
                            cpuCheckboxes.forEach(otherCb => {
                                if (otherCb.id !== 'all-cpu')
                                    otherCb.checked = false;
                            });
                        } else if (cb.checked) {
                            document.getElementById('all-cpu').checked = false;
                        }
                        filterProducts();
                    });
                });

                gpuCheckboxes.forEach(cb => {
                    cb.addEventListener('change', () => {
                        if (cb.id === 'all-gpu' && cb.checked) {
                            gpuCheckboxes.forEach(otherCb => {
                                if (otherCb.id !== 'all-gpu')
                                    otherCb.checked = false;
                            });
                        } else if (cb.checked) {
                            document.getElementById('all-gpu').checked = false;
                        }
                        filterProducts();
                    });
                });

                storageButtons.forEach(btn => {
                    btn.addEventListener('click', () => {
                        btn.classList.toggle('active');
                        filterProducts();
                    });
                });

                screenCheckboxes.forEach(cb => {
                    cb.addEventListener('change', () => {
                        if (cb.id === 'all-screen' && cb.checked) {
                            screenCheckboxes.forEach(otherCb => {
                                if (otherCb.id !== 'all-screen')
                                    otherCb.checked = false;
                            });
                        } else if (cb.checked) {
                            document.getElementById('all-screen').checked = false;
                        }
                        filterProducts();
                    });
                });

                osCheckboxes.forEach(cb => {
                    cb.addEventListener('change', () => {
                        if (cb.id === 'all-os' && cb.checked) {
                            osCheckboxes.forEach(otherCb => {
                                if (otherCb.id !== 'all-os')
                                    otherCb.checked = false;
                            });
                        } else if (cb.checked) {
                            document.getElementById('all-os').checked = false;
                        }
                        filterProducts();
                    });
                });

                brandButtons.forEach(btn => {
                    btn.addEventListener('click', (e) => {
                        e.preventDefault();
                        btn.classList.toggle('active');
                        filterProducts();
                    });
                });

                keyboardCheckboxes.forEach(cb => {
                    cb.addEventListener('change', () => {
                        if (cb.id === 'all-keyboard' && cb.checked) {
                            keyboardCheckboxes.forEach(otherCb => {
                                if (otherCb.id !== 'all-keyboard')
                                    otherCb.checked = false;
                            });
                        } else if (cb.checked) {
                            document.getElementById('all-keyboard').checked = false;
                        }
                        filterProducts();
                    });
                });

                filterProducts();
            });
        </script>
    </body>
</html>

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
    .filters {
        margin-bottom: 20px;
        background-color: #fff;
        padding: 15px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .filter-group {
        margin-bottom: 15px;
    }
    .filter-group strong {
        display: block;
        margin-bottom: 5px;
        font-size: 1.1em;
    }
    .filter-group label {
        margin-right: 10px;
        font-size: 0.9em;
    }
    .brand-filter.active {
        border-color: #007bff !important;
        background-color: #e6f0ff;
        box-shadow: 0 0 0 0.15rem rgba(0, 123, 255, 0.25);
    }
    .custom-range-section {
        margin-top: 15px;
    }
    .form-control-sm {
        max-width: 120px;
    }
    .border-primary {
        border-color: #007bff !important;
    }
    .price-check:checked + label {
        color: #007bff;
        font-weight: bold;
    }
    h5.mb-3 {
        position: relative;
        z-index: 1001;
        background-color: #fff;
        padding-bottom: 10px;
        margin-bottom: 0;
    }
    .filter-section {
        position: sticky;
        top: 60px;
        align-self: flex-start;
        max-height: calc(100vh - 80px);
        overflow-y: auto;
        z-index: 1000;
    }
    #filterAccordion {
        display: block;
    }
</style>