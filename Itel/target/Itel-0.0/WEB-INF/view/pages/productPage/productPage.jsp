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

    <body style="background-color: #F3F4F6; margin: 0; font-family: 'Roboto', sans-serif;">
        <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>

        <div class="container mt-4" >
            <nav aria-label="breadcrumb" style="margin-left:45px; margin-right: 30px;">
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

            <div class="row" style="margin-left:30px; margin-right: 30px;">
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
                                        <button type="button" class="btn btn-primary btn-sm mt-2 add-to-compare" data-action="add" data-product-id="${product.productId}" id="btn-${product.productId}">
                                            Thêm vào so sánh
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <div class="container-fluid mt-4 added-products" style="position: fixed; bottom: 0; left: 0; right: 0; background: #fff; padding: 10px; box-shadow: 0 -2px 10px rgba(0,0,0,0.1); z-index: 1000; display: none; max-width: 100%;">
            <div class="row">
                <div class="col-8 d-flex align-items-center flex-wrap product-list-container" id="added-product-list" style="gap: 5px; overflow-x: auto; margin-right: 5px;"></div>
                <div class="col-4 d-flex align-items-center gap-2 action-buttons-container" id="action-buttons" style="height: 70px;">
                    <button class="btn btn-outline-primary btn-sm" id="clear-all">Xóa tất cả</button>
                    <button class="btn btn-outline-success btn-sm" id="compare-now">So sánh ngay <i class="fas fa-arrow-right"></i></button>
                    <button class="btn btn-outline-secondary btn-sm" id="toggle-bar"><i class="fas fa-caret-up"></i></button>
                </div>
            </div>
        </div>
        <div id="compare-toggle" style="display: none; position: fixed; bottom: 20px; left: 20px; padding: 10px 20px; background-color: #007bff; color: white; border: none; border-radius: 20px; font-size: 1rem; cursor: pointer; z-index: 1001; font-family: 'Roboto', sans-serif;"></div>

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
                const addedProducts = document.querySelector('.added-products');
                const addedProductList = document.getElementById('added-product-list');
                const clearAllBtn = document.getElementById('clear-all');
                const compareNowBtn = document.getElementById('compare-now');
                const toggleBarBtn = document.getElementById('toggle-bar');
                const compareToggle = document.getElementById('compare-toggle');

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

                const addProductBtn = document.querySelectorAll('.add-to-compare');
                let hasAddedProduct = false;
                const addedProductsSet = new Set();
                const MAX_SLOTS = 3;

                addProductBtn.forEach(button => {
                    button.addEventListener('click', (e) => {
                        e.preventDefault();
                        const productCard = e.target.closest('.card');
                        const productId = button.getAttribute('data-product-id');
                        const product = products.find(p => p.id == productId);
                        if (!product || addedProductsSet.has(productId) || addedProductsSet.size >= MAX_SLOTS)
                            return;

                        const productImage = product.imageUrl || 'https://via.placeholder.com/180';
                        const productName = product.name || 'Unnamed Product';

                        const newProduct = document.createElement('div');
                        newProduct.className = 'd-flex align-items-center mb-2 product-slot';
                        const img = document.createElement('img');
                        img.src = productImage;
                        img.alt = productName;
                        img.style.width = '50px';
                        img.style.height = '50px';
                        img.style.objectFit = 'contain';
                        img.style.marginRight = '10px';
                        const nameSpan = document.createElement('span');
                        nameSpan.textContent = productName;
                        const removeBtn = document.createElement('button');
                        removeBtn.className = 'btn btn-outline-secondary btn-sm remove-btn';
                        removeBtn.setAttribute('data-action', 'remove');
                        removeBtn.setAttribute('data-product-id', productId);
                        removeBtn.setAttribute('data-original-button-id', button.id || `btn-${productId}`);
                        removeBtn.textContent = 'X';
                        newProduct.appendChild(img);
                        newProduct.appendChild(nameSpan);
                        newProduct.appendChild(removeBtn);
                        addedProductList.appendChild(newProduct);

                        button.classList.remove('btn-primary', 'add-to-compare');
                        button.classList.add('btn-success', 'added');
                        button.innerHTML = '<i class="fas fa-check me-1"></i> Đã thêm vào so sánh';
                        button.removeAttribute('data-action');
                        addedProductsSet.add(productId);

                        if (!hasAddedProduct) {
                            addedProducts.style.display = 'flex';
                            hasAddedProduct = true;
                        }
                        updatePlaceholders();
                        updateCompareToggle();
                        updateCompareButton();
                    });
                });

                document.addEventListener('click', (e) => {
                    if (e.target.dataset.action === 'remove') {
                        const productId = e.target.getAttribute('data-product-id');
                        const originalButtonId = e.target.getAttribute('data-original-button-id');
                        const productElement = e.target.closest('.product-slot');

                        if (productElement) {
                            productElement.remove();
                        }

                        const buttonToRevert = document.getElementById(originalButtonId);
                        if (buttonToRevert) {
                            buttonToRevert.classList.remove('btn-success', 'added');
                            buttonToRevert.classList.add('btn-primary', 'add-to-compare');
                            buttonToRevert.innerHTML = '<i class="fas fa-plus me-1"></i> Thêm vào so sánh';
                            buttonToRevert.setAttribute('data-action', 'add');
                        }

                        addedProductsSet.delete(productId);

                        if (addedProductsSet.size > 0) {
                            addedProducts.style.display = 'flex';
                            updatePlaceholders();
                            updateCompareToggle();
                        } else {
                            addedProducts.style.display = 'none';
                            hasAddedProduct = false;
                            compareToggle.style.display = 'none';
                        }
                        updateCompareButton();
                    }
                });

                clearAllBtn.addEventListener('click', () => {
                    addedProductList.innerHTML = '';
                    addProductBtn.forEach(button => {
                        if (button.classList.contains('added')) {
                            button.classList.remove('btn-success', 'added');
                            button.classList.add('btn-primary', 'add-to-compare');
                            button.innerHTML = '<i class="fas fa-plus me-1"></i> Thêm vào so sánh';
                            button.setAttribute('data-action', 'add');
                        }
                    });
                    addedProductsSet.clear();
                    addedProducts.style.display = 'none';
                    hasAddedProduct = false;
                    compareToggle.style.display = 'none';
                    updateCompareButton();
                });

                compareNowBtn.addEventListener('click', () => {
                if (!compareNowBtn.disabled) {
                    const productIds = Array.from(addedProductsSet).join('-');
                    console.log("list productid: " + productIds);
                    window.location.href = `compare?productIds=` + productIds;
                    }
                });

                toggleBarBtn.addEventListener('click', () => {
                    addedProducts.style.display = 'none';
                    compareToggle.style.display = 'block';
                    updateCompareToggle();
                });

                compareToggle.addEventListener('click', () => {
                    compareToggle.style.display = 'none';
                    if (hasAddedProduct) {
                        addedProducts.style.display = 'flex';
                    }
                });

                function updatePlaceholders() {
                    const currentItems = addedProductList.querySelectorAll('.product-slot:not(.placeholder)').length;
                    const remainingSlots = MAX_SLOTS - currentItems;

                    document.querySelectorAll('#added-product-list .placeholder').forEach(placeholder => placeholder.remove());

                    if (currentItems > 0 && currentItems < MAX_SLOTS) {
                        const placeholdersNeeded = Math.min(2, remainingSlots);
                        for (let i = 0; i < placeholdersNeeded; i++) {
                            const placeholder = document.createElement('div');
                            placeholder.className = 'd-flex align-items-center mb-2 placeholder product-slot';
                            placeholder.innerHTML = '<span style="color: #007bff; font-size: 0.9rem;">Thêm sản phẩm</span>';
                            addedProductList.insertBefore(placeholder, addedProductList.firstChild);
                        }
                    }
                }

                function updateCompareToggle() {
                    const count = addedProductsSet.size;
                    if (count > 0 && count <= 3) {
                        compareToggle.textContent = 'So sánh (' + count + ')';
                    }
                }

                function updateCompareButton() {
                    const productCount = addedProductsSet.size;
                    compareNowBtn.disabled = productCount < 2;
                }

                filterProducts();
            });
        </script>
    </body>
</html>

<style>
    .range-slider input[type="range"] {
        -webkit-appearance: none;
        appearance: none;
        width: 100%;
        height: 6px;
        background: linear-gradient(to right, #d3d3d3 var(--min, 0%), #3498db var(--min, 0%) var(--max, 100%), #d3d3d3 var(--max, 100%));
        border-radius: 3px;
        outline: none;
        position: absolute;
    }

    .range-slider input[type="range"]::-webkit-slider-thumb {
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

    .range-slider input[type="range"]::-moz-range-thumb {
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
        background-color: #007bff;
        border-color: #007bff;
    }

    .btn-success.added {
        width: 100%;
        background-color: #28a745;
        border-color: #28a745;
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
        line-height: 1.5;
        border-radius: 0.2rem;
    }

    .filters {
        margin-bottom: 20px;
        background-color: #fff;
        padding: 15px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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

    .added-products {
        width: 100%;
    }

    .added-products .row {
        display: flex;
        justify-content: center;
        margin-left: auto;
        margin-right: auto;
        max-width: 90%;
    }

    .added-products .product-slot {
        background-color: #f0f8ff;
        border: 1px solid #ddd;
        border-radius: 5px;
        padding: 5px 10px;
        margin: 0;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        height: 70px;
        display: flex;
        align-items: center;
        flex: 0 0 auto;
        position: relative;
        width: 250px;
        margin-right: 10px;
    }

    .added-products .product-slot .remove-btn {
        position: absolute;
        right: 5px;
        top: 50%;
        transform: translateY(-50%);
        background-color: #f0f8ff;
        border: none;
        color: #333;
        padding: 0.1rem 0.4rem;
        font-size: 0.75rem;
        height: 30px;
        width: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .added-products img {
        border-radius: 3px;
    }

    .added-products .placeholder {
        background-color: #e9ecef;
        border: 1px solid #dee2e6;
        border-radius: 5px;
        padding: 5px 10px;
        margin: 0;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        height: 70px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex: 0 0 auto;
        width: 250px;
        margin-right: 10px;
    }

    .product-list-container {
        flex: 8;
        display: flex;
        align-items: center;
        flex-wrap: wrap;
        gap: 5px;
        overflow-x: auto;
        margin-right: 5px;
    }

    .action-buttons-container {
        flex: 2;
        display: flex;
        align-items: center;
        justify-content: flex-start;
        gap: 10px;
        height: 70px;
        margin: 0;
        padding: 0;
    }

    #clear-all, #compare-now, #toggle-bar {
        height: 100%;
        padding: 0.5rem 1rem;
        border-radius: 8px;
        font-weight: 600;
        min-width: 0;
        width: auto;
        transition: all 0.3s ease;
        border: none;
        cursor: pointer;
    }

    #clear-all {
        background-color: #e9ecef;
        color: #007bff;
    }

    #clear-all:hover {
        background-color: #007bff;
        color: #fff;
    }

    #compare-now {
        background-color: #28a745;
        color: #fff;
    }

    #compare-now:disabled {
        background-color: #a0d3a9;
        cursor: not-allowed;
    }

    #compare-now:hover:not(:disabled) {
        background-color: #218838;
        color: #fff;
    }

    #toggle-bar {
        height: 40px;
        width: 40px;
        border-radius: 50%;
        background-color: #6c757d;
        color: #fff;
        border: none;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    #toggle-bar:hover {
        background-color: #5a6268;
    }
</style>