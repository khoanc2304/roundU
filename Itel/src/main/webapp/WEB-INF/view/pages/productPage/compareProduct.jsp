<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>So sánh sản phẩm</title>
        <!-- Bootstrap 5.3 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous"/>
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <!-- Add AOS CSS -->
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    </head>
    <body>
        <!-- Navbar -->
        <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>

        <div class="compare-container mt-5">
            <h2 class="page-title" data-aos="fade-up">So sánh sản phẩm</h2>

            <c:choose>
                <c:when test="${empty sessionScope.compareDetails or fn:length(sessionScope.compareDetails) == 0}">
                    <div class="no-products" data-aos="fade-up">
                        <i class="fas fa-info-circle fa-2x mb-3" style="color: #1976d2;" aria-label="Information"></i>
                        <p>Chưa có sản phẩm nào để so sánh.</p>
                        <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE %>&c=Laptop">
                            <i class="fas fa-plus-circle me-2" aria-label="Add product"></i>Thêm sản phẩm ngay!
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="product-row" data-aos="fade-up">
                        <c:forEach var="entry" items="${sessionScope.compareDetails}">
                            <div class="product-card" data-id="${entry.key.productId}">
                                <span class="remove-btn" onclick="removeProduct(${entry.key.productId})">×</span>
                                <div class="product-content">
                                    <div class="image-container">
                                        <img src="${fn:escapeXml(entry.key.imageUrl) != '' ? fn:escapeXml(entry.key.imageUrl) : '/images/placeholder.png'}" alt="${fn:escapeXml(entry.key.name)}">
                                    </div>
                                    <div class="product-info">
                                        <div class="product-name">${fn:escapeXml(entry.key.name)}</div>
                                        <div class="price">
                                            <fmt:formatNumber value="${entry.key.price}" type="number" pattern="#,###"/> <span>VNĐ</span>
                                        </div>
                                        <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE %>&id=${entry.key.productId}" class="buy-now-btn">
                                            <i class="fas fa-shopping-cart me-2" aria-label="Shopping cart"></i>Mua ngay
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${fn:length(sessionScope.compareDetails) < 3}">
                            <c:forEach begin="${fn:length(sessionScope.compareDetails)}" end="2">
                                <div class="product-card">
                                    <div class="product-content">
                                        <div class="image-container">
                                            <div class="placeholder" style="cursor: pointer;">+</div>
                                        </div>

                                        <div class="product-info">
                                            <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE %>&c=Laptop" class="add-placeholder">
                                                <i class="fas fa-plus-circle me-1" aria-label="Add product"></i>Thêm sản phẩm
                                            </a>
                                        </div>
<!--                                        <div class="product-info">
                                            <a href="javascript:void(0);" class="add-placeholder" onclick="history.back()">
                                                <i class="fas fa-plus-circle me-1" aria-label="Add product"></i>Thêm sản phẩm
                                            </a>
                                        </div>-->

                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>

                    <div class="filter-checkbox" data-aos="fade-up">
                        <input type="checkbox" id="filterDifferent" checked>
                        <label for="filterDifferent"><i class="fas fa-filter me-2" aria-label="Filter"></i>Chỉ hiển thị thông tin khác nhau</label>
                    </div>

                    <table class="compare-table" data-aos="fade-up" id="compareTable">
                        <thead>
                            <tr>
                                <th>Thông số</th>
                                    <c:forEach var="entry" items="${sessionScope.compareDetails}">
                                    <th>${fn:escapeXml(entry.key.name)}</th>
                                    </c:forEach>
                                    <c:if test="${fn:length(sessionScope.compareDetails) < 3}">
                                        <c:forEach begin="${fn:length(sessionScope.compareDetails)}" end="2">
                                        <th></th>
                                        </c:forEach>
                                    </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="detailIndex" begin="0" end="13" varStatus="loop">
                                <tr data-index="${loop.index}">
                                    <td>
                                        <c:choose>
                                            <c:when test="${detailIndex == 0}"><i class="fas fa-microchip me-2" aria-label="CPU"></i>Bộ vi xử lý (CPU)</c:when>
                                            <c:when test="${detailIndex == 1}"><i class="fas fa-memory me-2" aria-label="RAM"></i>RAM</c:when>
                                            <c:when test="${detailIndex == 2}"><i class="fas fa-hdd me-2" aria-label="Storage"></i>Ổ cứng</c:when>
                                            <c:when test="${detailIndex == 3}"><i class="fas fa-desktop me-2" aria-label="GPU"></i>Card đồ họa (GPU)</c:when>
                                            <c:when test="${detailIndex == 4}"><i class="fas fa-tv me-2" aria-label="Display"></i>Màn hình</c:when>
                                            <c:when test="${detailIndex == 5}"><i class="fab fa-windows me-2" aria-label="Operating System"></i>Hệ điều hành</c:when>
                                            <c:when test="${detailIndex == 6}"><i class="fas fa-plug me-2" aria-label="Ports"></i>Cổng kết nối</c:when>
                                            <c:when test="${detailIndex == 7}"><i class="fas fa-keyboard me-2" aria-label="Keyboard"></i>Bàn phím</c:when>
                                            <c:when test="${detailIndex == 8}"><i class="fas fa-camera me-2" aria-label="Webcam"></i>Webcam</c:when>
                                            <c:when test="${detailIndex == 9}"><i class="fas fa-wifi me-2" aria-label="Wi-Fi"></i>Kết nối Wi-Fi</c:when>
                                            <c:when test="${detailIndex == 10}"><i class="fab fa-bluetooth-b me-2" aria-label="Bluetooth"></i>Kết nối Bluetooth</c:when>
                                            <c:when test="${detailIndex == 11}"><i class="fas fa-battery-full me-2" aria-label="Battery"></i>Dung lượng pin (Wh)</c:when>
                                            <c:when test="${detailIndex == 12}"><i class="fas fa-weight me-2" aria-label="Weight"></i>Trọng lượng (kg)</c:when>
                                            <c:when test="${detailIndex == 13}"><i class="fas fa-ruler-combined me-2" aria-label="Dimensions"></i>Kích thước</c:when>
                                        </c:choose>
                                    </td>
                                    <c:forEach var="entry" items="${sessionScope.compareDetails}">
                                        <td>${fn:escapeXml(entry.value[detailIndex])}</td>
                                    </c:forEach>
                                    <c:if test="${fn:length(sessionScope.compareDetails) < 3}">
                                        <c:forEach begin="${fn:length(sessionScope.compareDetails)}" end="2">
                                            <td></td>
                                        </c:forEach>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>

            <!--            <div class="back-button mt-4" data-aos="fade-up">
                            <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE %>&c=Laptop">
                                <i class="fas fa-arrow-left me-2" aria-label="Back"></i>Quay lại trang sản phẩm
                            </a>
                        </div>-->
        </div>

        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <!-- AOS JS -->
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <!-- Custom JS -->
        <script>
                                                document.addEventListener("DOMContentLoaded", () => {
                                                    // Declare AOS variable
                                                    const AOS = window.AOS

                                                    // Initialize AOS
                                                    AOS.init({
                                                        duration: 800,
                                                        easing: "ease-in-out",
                                                        once: true,
                                                    })

                                                    // Filter different values
                                                    function filterDifferentValues() {
                                                        const checkbox = document.getElementById("filterDifferent")
                                                        const table = document.getElementById("compareTable")
                                                        const rows = table.getElementsByTagName("tr")
                                                        const productCount = document.querySelectorAll(".product-card:not(:empty)").length

                                                        if (checkbox.checked) {
                                                            for (let i = 1; i < rows.length; i++) {
                                                                const cells = rows[i].getElementsByTagName("td")
                                                                let allSame = true
                                                                const values = []

                                                                // Collect all values (excluding empty cells)
                                                                for (let j = 1; j < cells.length; j++) {
                                                                    const value = cells[j].textContent.trim()
                                                                    if (value !== "") {
                                                                        values.push(value)
                                                                    }
                                                                }

                                                                // Check if all non-empty values are the same
                                                                if (values.length > 1) {
                                                                    const firstValue = values[0]
                                                                    for (let k = 1; k < values.length; k++) {
                                                                        if (values[k] !== firstValue) {
                                                                            allSame = false
                                                                            break
                                                                        }
                                                                    }
                                                                }

                                                                // Hide row if all values are the same
                                                                if (allSame && values.length > 1) {
                                                                    rows[i].style.display = "none"
                                                                } else {
                                                                    rows[i].style.display = ""

                                                                    // Highlight different values
                                                                    if (!allSame) {
                                                                        for (let j = 1; j < cells.length; j++) {
                                                                            cells[j].classList.add("different-value")
                                                                        }
                                                                    } else {
                                                                        for (let j = 1; j < cells.length; j++) {
                                                                            cells[j].classList.remove("different-value")
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } else {
                                                            // Show all rows and remove highlighting
                                                            for (let i = 1; i < rows.length; i++) {
                                                                rows[i].style.display = ""
                                                                const cells = rows[i].getElementsByTagName("td")
                                                                for (let j = 1; j < cells.length; j++) {
                                                                    cells[j].classList.remove("different-value")
                                                                }
                                                            }
                                                        }
                                                    }

                                                    // Add event listener to checkbox
                                                    const checkbox = document.getElementById("filterDifferent")
                                                    if (checkbox) {
                                                        checkbox.addEventListener("change", filterDifferentValues)

                                                        // Run filter on page load if checkbox is checked
                                                        if (checkbox.checked) {
                                                            filterDifferentValues()
                                                        }
                                                    }

                                                    // Add hover effect to placeholder
                                                    const placeholders = document.querySelectorAll(".placeholder")
                                                    placeholders.forEach((placeholder) => {
                                                        placeholder.addEventListener("mouseenter", function () {
                                                            this.style.transform = "scale(1.05)"
                                                        })

                                                        placeholder.addEventListener("mouseleave", function () {
                                                            this.style.transform = "scale(1)"
                                                        })
                                                    })
                                                })

                                                // Function to remove product
                                                function removeProduct(productId) {
                                                    const urlParams = new URLSearchParams(window.location.search)
                                                    let productIds = urlParams.get("productIds") ? urlParams.get("productIds").split("-") : []
                                                    productIds = productIds.filter((id) => id != productId)

                                                    // Add animation before redirect
                                                    const productCard = document.querySelector(`.product-card[data-id="${productId}"]`)
                                                    if (productCard) {
                                                        productCard.style.transform = "scale(0.8)"
                                                        productCard.style.opacity = "0"

                                                        setTimeout(() => {
                                                            if (productIds.length > 0) {
                                                                window.location.href = "http://localhost:9999/Itel/compare?productIds=" + productIds.join("-")
                                                            } else {
                                                                window.location.href = document.querySelector(".back-button a").getAttribute("href")
                                                            }
                                                        }, 300)
                                                    } else {
                                                        if (productIds.length > 0) {
                                                            window.location.href = "http://localhost:9999/Itel/compare?productIds=" + productIds.join("-")
                                                        } else {
                                                            window.location.href = document.querySelector(".back-button a").getAttribute("href")
                                                        }
                                                    }
                                                }
        </script>
    </body>
</html>

<style>
    /* Main Styles */
    body {
        font-family: "Roboto", sans-serif;
        background: #faf8f8;
        color: #333;
        margin: 0;
        padding: 0;
        min-height: 100vh;
    }

    .compare-container {
        max-width: 1500px;
        margin: 0 auto;
        padding: 30px 15px;
    }

    /* Page Title */
    .page-title {
        text-align: center;
        margin-bottom: 2rem;
        color: #1a5f9c;
        font-size: 2.2rem;
        font-weight: 700;
        position: relative;
        padding-bottom: 15px;
    }

    .page-title::after {
        content: "";
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 80px;
        height: 3px;
        background: linear-gradient(to right, #1a5f9c, #64b5f6);
        border-radius: 3px;
    }

    /* Product Cards Row */
    .product-row {
        display: flex;
        justify-content: center;
        margin-bottom: 30px;
        gap: 20px;
        width: 100%;
        max-width: 1200px;
        margin-left: auto;
        margin-right: auto;
    }

    .product-card {
        flex: 1;
        max-width: 380px;
        text-align: center;
        padding: 20px;
        position: relative;
        min-height: 250px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        background-color: rgba(255, 255, 255, 0.9);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        border-radius: 15px;
        transition: all 0.3s ease;
        border: 1px solid rgba(255, 255, 255, 0.5);
        backdrop-filter: blur(5px);
    }

    .product-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15);
        background-color: #ffffff;
    }

    .product-content {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 15px;
        height: 100%;
    }

    .image-container {
        flex-shrink: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        height: 150px;
        margin-bottom: 10px;
    }

    .product-card img {
        max-width: 160px;
        max-height: 140px;
        object-fit: contain;
        transition: transform 0.3s ease;
    }

    .product-card:hover img {
        transform: scale(1.05);
    }

    .product-info {
        width: 100%;
        text-align: center;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 10px;
    }

    .product-card .product-name {
        font-size: 1.2rem;
        font-weight: 600;
        color: #1a5f9c;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        max-width: 100%;
        margin: 0;
        line-height: 1.4;
        height: 2.8rem;
    }

    .product-card .price {
        color: #e53935;
        font-weight: 700;
        font-size: 1.4rem;
        margin: 5px 0;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 5px;
    }

    .price span {
        font-size: 0.9rem;
        font-weight: 500;
    }

    .buy-now-btn {
        display: inline-block;
        padding: 8px 20px;
        background: linear-gradient(to right, #1976d2, #64b5f6);
        color: #fff;
        text-decoration: none;
        border-radius: 30px;
        font-size: 1rem;
        font-weight: 500;
        transition: all 0.3s ease;
        border: none;
        box-shadow: 0 4px 8px rgba(25, 118, 210, 0.3);
        width: 80%;
        margin-top: 10px;
    }

    .buy-now-btn:hover {
        background: linear-gradient(to right, #1565c0, #42a5f5);
        box-shadow: 0 6px 12px rgba(25, 118, 210, 0.4);
        transform: translateY(-2px);
        color: #fff;
    }

    .remove-btn {
        color: #e53935;
        cursor: pointer;
        font-size: 1.2rem;
        position: absolute;
        top: 10px;
        right: 10px;
        background: rgba(255, 255, 255, 0.95);
        border-radius: 50%;
        width: 30px;
        height: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        border: 1px solid rgba(229, 57, 53, 0.2);
    }

    .remove-btn:hover {
        color: #b71c1c;
        background: #fff;
        transform: rotate(90deg);
        box-shadow: 0 3px 8px rgba(0, 0, 0, 0.15);
    }

    /* Placeholder Card */
    .placeholder {
        border: 2px dashed #90caf9;
        height: 140px;
        width: 140px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #1976d2;
        font-size: 3em;
        border-radius: 10px;
        background-color: rgba(144, 202, 249, 0.1);
        transition: all 0.3s ease;
    }

    .placeholder:hover {
        background-color: rgba(144, 202, 249, 0.2);
        border-color: #64b5f6;
    }

    .add-placeholder {
        color: #1976d2;
        font-size: 1.1rem;
        cursor: pointer;
        text-decoration: none;
        font-weight: 500;
        margin-top: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 5px;
        transition: all 0.3s ease;
    }

    .add-placeholder:hover {
        color: #1565c0;
        transform: translateY(-2px);
    }

    .add-placeholder i {
        font-size: 1.2rem;
    }

    /* Comparison Table */
    .filter-checkbox {
        width: 100%;
        max-width: 1200px;
        margin: 20px auto;
        text-align: right;
        padding: 10px 15px;
        background-color: rgba(255, 255, 255, 0.8);
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        display: flex;
        justify-content: flex-end;
        align-items: center;
    }

    .filter-checkbox label {
        margin-left: 8px;
        color: #1a5f9c;
        font-weight: 500;
        cursor: pointer;
    }

    .filter-checkbox input[type="checkbox"] {
        width: 18px;
        height: 18px;
        accent-color: #1976d2;
        cursor: pointer;
    }

    .compare-table {
        width: 100%;
        max-width: 1200px;
        margin: 20px auto;
        border-collapse: separate;
        border-spacing: 0 8px;
    }

    .compare-table th,
    .compare-table td {
        padding: 15px;
        text-align: center;
        vertical-align: middle;
        background-color: #fff;
        position: relative;
    }

    .compare-table tr {
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        transition: all 0.2s ease;
    }

    .compare-table tr:hover {
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
    }

    .compare-table td:first-child {
        width: 200px;
        min-width: 200px;
        text-align: left;
        font-weight: 600;
        color: #1a5f9c;
        border-radius: 10px 0 0 10px;
        background-color: rgba(144, 202, 249, 0.2);
    }

    .compare-table th:not(:first-child),
    .compare-table td:not(:first-child) {
        width: 333.33px;
        min-width: 333.33px;
    }

    .compare-table th:last-child,
    .compare-table td:last-child {
        border-radius: 0 10px 10px 0;
    }

    .compare-table th {
        background: linear-gradient(to right, #1976d2, #64b5f6);
        font-weight: 600;
        color: #fff;
        font-size: 1.1rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .compare-table th:first-child {
        background: linear-gradient(to right, #1565c0, #1976d2);
    }

    /* Different values highlighting */
    .different-value {
        background-color: rgba(255, 248, 225, 0.7);
    }

    /* No Products Message */
    .no-products {
        text-align: center;
        color: #1a5f9c;
        padding: 40px;
        background-color: rgba(255, 255, 255, 0.9);
        border-radius: 15px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        max-width: 700px;
        margin: 40px auto;
        font-size: 1.2rem;
        border: 1px solid rgba(144, 202, 249, 0.5);
    }

    .no-products a {
        display: inline-block;
        margin-top: 15px;
        padding: 10px 25px;
        background: linear-gradient(to right, #1976d2, #64b5f6);
        color: #fff;
        text-decoration: none;
        border-radius: 30px;
        font-weight: 500;
        transition: all 0.3s ease;
        box-shadow: 0 4px 8px rgba(25, 118, 210, 0.3);
    }

    .no-products a:hover {
        background: linear-gradient(to right, #1565c0, #42a5f5);
        box-shadow: 0 6px 12px rgba(25, 118, 210, 0.4);
        transform: translateY(-2px);
    }

    /* Back to Products Button */
    .back-button {
        text-align: center;
        margin-top: 30px;
    }

    .back-button a {
        display: inline-block;
        padding: 12px 30px;
        background: linear-gradient(to right, #1976d2, #64b5f6);
        color: #fff;
        text-decoration: none;
        border-radius: 30px;
        font-size: 1.1rem;
        font-weight: 500;
        transition: all 0.3s ease;
        box-shadow: 0 4px 8px rgba(25, 118, 210, 0.3);
    }

    .back-button a:hover {
        background: linear-gradient(to right, #1565c0, #42a5f5);
        box-shadow: 0 6px 12px rgba(25, 118, 210, 0.4);
        transform: translateY(-2px);
    }

    /* Responsive Design */
    @media (max-width: 1200px) {
        .compare-table,
        .product-row,
        .filter-checkbox {
            max-width: 95%;
        }
    }

    @media (max-width: 992px) {
        .product-row {
            flex-wrap: wrap;
            gap: 15px;
        }

        .product-card {
            min-width: 280px;
            flex: 0 0 calc(50% - 15px);
        }

        .compare-table th:not(:first-child),
        .compare-table td:not(:first-child) {
            width: auto;
            min-width: 200px;
        }
    }

    @media (max-width: 768px) {
        .compare-table {
            display: block;
            overflow-x: auto;
            white-space: nowrap;
        }

        .product-card {
            flex: 0 0 100%;
            max-width: 100%;
        }

        .page-title {
            font-size: 1.8rem;
        }
    }

    @media (max-width: 576px) {
        .compare-container {
            padding: 20px 10px;
        }

        .product-content {
            flex-direction: column;
        }

        .image-container {
            width: 100%;
            margin-bottom: 15px;
        }

        .product-info {
            width: 100%;
        }

        .filter-checkbox {
            justify-content: center;
        }
    }

    /* Animation for AOS */
    [data-aos] {
        opacity: 0;
        transition-property: opacity, transform;
    }

    [data-aos].aos-animate {
        opacity: 1;
    }

    [data-aos="fade-up"] {
        transform: translateY(30px);
    }

    [data-aos="fade-up"].aos-animate {
        transform: translateY(0);
    }

    ::-webkit-scrollbar {
        width: 8px;
        height: 8px;
    }

    ::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
    }

    ::-webkit-scrollbar-thumb {
        background: #90caf9;
        border-radius: 10px;
    }

    ::-webkit-scrollbar-thumb:hover {
        background: #64b5f6;
    }

</style>
