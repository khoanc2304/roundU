<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="java.util.*" %>
<div class="col-12 col-lg-3">
    <div class="border rounded p-3 bg-white shadow-sm filter-section">
        <h5 class="mb-3"><i class="fas fa-filter me-2"></i> Bộ lọc tìm kiếm</h5>

        <div class="accordion" id="filterAccordion">
            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#brandFilter">Hãng sản xuất</button></h2>
                <div id="brandFilter" class="accordion-collapse collapse show">
                    <div class="accordion-body">
                        <div class="row row-cols-3 g-2">
                            <c:forEach var="bcDTO" items="${sessionScope.brandCategoryDTOs}">
                                <div class="col text-center">
                                    <div class="btn btn-outline-light border w-100 shadow-sm brand-filter"
                                         data-brand-id="${bcDTO.brandId}">
                                        <img src="${bcDTO.brandImageUrl}" width="40" alt="${bcDTO.brandName}">
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#priceFilter"> Mức giá </button></h2>
                <div id="priceFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted">Chọn mức giá:</label>
                            <div class="form-check">
                                <input class="form-check-input price-check" type="checkbox" name="priceRange" id="all" value="all">
                                <label class="form-check-label" for="all">Tất cả</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input price-check" type="checkbox" name="priceRange" id="under10" value="under10">
                                <label class="form-check-label" for="under10">Dưới 10 triệu</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input price-check" type="checkbox" name="priceRange" id="10-20" value="10-20">
                                <label class="form-check-label" for="10-20">Từ 10 - 20 triệu</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input price-check" type="checkbox" name="priceRange" id="20-30" value="20-30">
                                <label class="form-check-label" for="20-30">Từ 20 - 30 triệu</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input price-check" type="checkbox" name="priceRange" id="30-40" value="30-40">
                                <label class="form-check-label" for="30-40">Từ 30 - 40 triệu</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input price-check" type="checkbox" name="priceRange" id="over40" value="over40">
                                <label class="form-check-label" for="over40">Trên 40 triệu</label>
                            </div>
                        </div>
                        <div class="custom-range-section">
                            <label class="form-label fw-bold text-muted">Nhập khoảng giá:</label>
                            <div class="d-flex align-items-center mb-3">
                                <input type="text" id="minPriceInput" class="form-control form-control-sm me-2 text-end border-primary" value="0" placeholder="Min">
                                <span class="text-secondary mx-2">~</span>
                                <input type="text" id="maxPriceInput" class="form-control form-control-sm text-end border-primary" value="200000000" placeholder="Max">
                            </div>
                            <!--
                            <div class="range-slider position-relative">
                                <input type="range" id="rangeMin" min="0" max="200000000" step="1000000" value="34923000" class="form-range w-100">
                                <input type="range" id="rangeMax" min="0" max="200000000" step="1000000" value="137161000" class="form-range w-100">
                            </div>
                            -->
                        </div>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#cpuFilter">CPU</button></h2>
                <div id="cpuFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <div class="form-check">
                            <input class="form-check-input cpu-filter" type="checkbox" name="cpu" id="all-cpu" value="all">
                            <label class="form-check-label" for="all-cpu">Tất cả</label>
                        </div>
                        <c:forEach var="cpu" items="${['Apple M4','Intel Core i3','Intel Core i5','Intel Core i7','Intel Core i9','AMD Ryzen 5','AMD Ryzen 7','Intel Core Ultra','AMD Ryzen AI']}">
                            <div class="form-check">
                                <input class="form-check-input cpu-filter" type="checkbox" id="${fn:replace(cpu, ' ', '-')}" name="cpu" value="${cpu}">
                                <label class="form-check-label" for="${fn:replace(cpu, ' ', '-')}">${cpu}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#ramFilter">RAM</button></h2>
                <div id="ramFilter" class="accordion-collapse collapse">
                    <div class="accordion-body d-flex flex-wrap gap-2">
                        <c:forEach var="ram" items="${['2 GB','4 GB','8 GB','16 GB','32 GB','64 GB']}">
                            <button class="btn btn-outline-secondary btn-sm" data-filter="ram" data-value="${ram}">${ram}</button>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#gpuFilter">Card đồ họa</button></h2>
                <div id="gpuFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="gpu" id="all-gpu" value="all">
                            <label class="form-check-label" for="all-gpu">Tất cả</label>
                        </div>
                        <c:forEach var="gpu" items="${['Intel Iris Series','Intel UHD Graphics Series','Intel HD Graphics Series','AMD Radeon Series','NVIDIA GeForce Series','Apple GPU Series']}">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="${fn:replace(gpu, ' ', '-')}" name="gpu" value="${gpu}">
                                <label class="form-check-label" for="${fn:replace(gpu, ' ', '-')}">${gpu}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#storageFilter">SSD</button></h2>
                <div id="storageFilter" class="accordion-collapse collapse">
                    <div class="accordion-body d-flex flex-wrap gap-2">
                        <c:forEach var="storage" items="${['64 GB','128 GB','256 GB','512 GB','1 TB','2 TB']}">
                            <button class="btn btn-outline-secondary btn-sm" data-filter="storage" data-value="${storage}">${storage}</button>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#screenFilter">Kích thước màn hình</button></h2>
                <div id="screenFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="screen" id="all-screen" value="all">
                            <label class="form-check-label" for="all-screen">Tất cả</label>
                        </div>
                        <c:forEach var="screen" items="${['Dưới 14 inch','14-15 inch','15-17 inch']}">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="${fn:replace(screen, ' ', '-')}" name="screen" value="${screen}">
                                <label class="form-check-label" for="${fn:replace(screen, ' ', '-')}">${screen}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#keyboardFilter">Bàn phím</button></h2>
                <div id="keyboardFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="keyboard" id="all-keyboard" value="all">
                            <label class="form-check-label" for="all-keyboard">Tất cả</label>
                        </div>
                        <c:forEach var="keyboard" items="${['Backlit Keyboard','RGB Backlit Keyboard','Standard Keyboard']}">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="${fn:replace(keyboard, ' ', '-')}" name="keyboard" value="${keyboard}">
                                <label class="form-check-label" for="${fn:replace(keyboard, ' ', '-')}">${keyboard}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#osFilter">Hệ điều hành</button></h2>
                <div id="osFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="os" id="all-os" value="all">
                            <label class="form-check-label" for="all-os">Tất cả</label>
                        </div>
                        <c:forEach var="os" items="${['Windows 10','Windows 11','MacOS','Linux', 'No OS']}">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="F${fn:replace(os, ' ', '-')}" name="os" value="${os}">
                                <label class="form-check-label" for="${fn:replace(os, ' ', '-')}">${os}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#colorFilter">Màu sắc</button></h2>
                <div id="colorFilter" class="accordion-collapse collapse">
                    <div class="accordion-body d-flex flex-wrap gap-2">
                        <c:forEach var="color" items="${['Black','Silver','Grey','White','Blue']}">
                            <button class="btn btn-outline-dark btn-sm" data-filter="color" data-value="${color}">${color}</button>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
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

    .filter-section {
        position: sticky;
        top: 20px; 
        align-self: flex-start;
        max-height: calc(100vh - 40px); 
        overflow-y: auto; 
        z-index: 1000;
    }

    #filterAccordion {
        display: block;
    }
</style>
