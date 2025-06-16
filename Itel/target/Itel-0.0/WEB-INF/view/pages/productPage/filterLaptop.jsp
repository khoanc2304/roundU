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
            <!-- Hãng sản xuất -->
            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#brandFilter">Hãng sản xuất</button></h2>
                <div id="brandFilter" class="accordion-collapse collapse show">
                    <div class="accordion-body">
                        <div class="row row-cols-3 g-2">
                            <c:forEach var="bcDTO" items="${sessionScope.brandCategoryDTOs}">
                                <div class="col text-center">
                                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&c=Laptop&brand=${bcDTO.brandName}" 
                                       class="btn btn-outline-light border w-100 shadow-sm brand-filter" data-brand="${bcDTO.brandName}">
                                        <img src="${bcDTO.brandImageUrl}" width="40" alt="${bcDTO.brandName}">
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Mức giá -->
            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#priceFilter">Mức giá</button></h2>
                <div id="priceFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <label class="form-label">Nhập khoảng giá:</label>
                        <div class="d-flex align-items-center mb-2">
                            <input type="text" id="minPriceInput" class="form-control form-control-sm me-1 text-end" value="10000000">
                            <span class="mx-1">~</span>
                            <input type="text" id="maxPriceInput" class="form-control form-control-sm text-end" value="150000000">
                        </div>
                        <div class="range-slider position-relative" style="height: 40px;">
                            <input type="range" id="rangeMin" min="0" max="200000000" step="1000000" value="10000000">
                            <input type="range" id="rangeMax" min="0" max="200000000" step="1000000" value="150000000">
                        </div>
                    </div>
                </div>
            </div>
            <!-- CPU -->
            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#cpuFilter">CPU</button></h2>
                <div id="cpuFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <c:forEach var="cpu" items="${['Apple M4 series','Intel Core i3','Intel Core i5','Intel Core i7','Intel Core i9','AMD Ryzen 5','AMD Ryzen 7','Intel Core Ultra','AMD Ryzen AI']}">
                            <div class="form-check">
                                <input class="form-check-input cpu-filter" type="checkbox" id="${fn:replace(cpu, ' ', '-')}" name="cpu" value="${cpu}">
                                <label class="form-check-label" for="${fn:replace(cpu, ' ', '-')}">${cpu}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <!-- RAM -->
            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#ramFilter">RAM</button></h2>
                <div id="ramFilter" class="accordion-collapse collapse">
                    <div class="accordion-body d-flex flex-wrap gap-2">
                        <c:forEach var="ram" items="${['8GB','16GB','32GB','64GB']}">
                            <button class="btn btn-outline-secondary btn-sm" data-filter="ram" data-value="${ram}">${ram}</button>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <!-- Card đồ họa -->
            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#gpuFilter">Card đồ họa</button></h2>
                <div id="gpuFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <c:forEach var="gpu" items="${['Intel Iris Series','Intel UHD Graphics Series','Intel HD Graphics Series','AMD Radeon Series','NVIDIA GeForce RTX Series','Apple GPU Series']}">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="${fn:replace(gpu, ' ', '-')}" name="gpu" value="${gpu}">
                                <label class="form-check-label" for="${fn:replace(gpu, ' ', '-')}">${gpu}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <!-- Ổ cứng -->
            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#storageFilter">Ổ cứng</button></h2>
                <div id="storageFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <c:forEach var="ssd" items="${['256GB','512GB','1TB']}">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="${fn:replace(ssd, ' ', '-')}" name="storage" value="${ssd}">
                                <label class="form-check-label" for="${fn:replace(ssd, ' ', '-')}">${ssd}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <!-- Màn hình -->
            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#screenFilter">Kích thước màn hình</button></h2>
                <div id="screenFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <c:forEach var="screen" items="${['11.6-13 inch','14-15.6 inch','16-17.3 inch']}">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="${fn:replace(screen, ' ', '-')}" name="screen" value="${screen}">
                                <label class="form-check-label" for="${fn:replace(screen, ' ', '-')}">${screen}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <!-- Bàn phím -->
            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#keyboardFilter">Bàn phím</button></h2>
                <div id="keyboardFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <c:forEach var="keyboard" items="${['Backlit Keyboard','RGB Backlit Keyboard','Standard Keyboard']}">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="${fn:replace(keyboard, ' ', '-')}" name="keyboard" value="${keyboard}">
                                <label class="form-check-label" for="${fn:replace(keyboard, ' ', '-')}">${keyboard}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <!-- Hệ điều hành -->
            <div class="accordion-item">
                <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#osFilter">Hệ điều hành</button></h2>
                <div id="osFilter" class="accordion-collapse collapse">
                    <div class="accordion-body">
                        <c:forEach var="os" items="${['Windows 10','Windows 11','macOS','Linux/No OS']}">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="F${fn:replace(os, ' ', '-')}" name="os" value="${os}">
                                <label class="form-check-label" for="${fn:replace(os, ' ', '-')}">${os}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <!-- Màu sắc -->
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