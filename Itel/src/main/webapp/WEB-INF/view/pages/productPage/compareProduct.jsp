<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>So sánh sản phẩm</title>

    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous"/>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <!-- Add AOS CSS -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <style>
        .compare-container {
            max-width: 1500px;
            margin: 0 auto;
            padding: 20px 0;
        }
        .product-row {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
            gap: 0;
            width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }
        .product-card {
            width: 400px;
            text-align: center;
            padding: 10px;
            position: relative;
            height: 220px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background-color: #ffffff;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-right: 1px solid #e0e0e0;
        }
        .product-card:last-child {
            border-right: none;
        }
        .product-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
        }
        .product-content {
            display: flex;
            flex-direction: row;
            align-items: center;
            justify-content: center;
            gap: 5px;
            height: 100%;
        }
        .image-container {
            flex-shrink: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 200px;
        }
        .product-card img {
            max-width: 140px;
            max-height: 140px;
            object-fit: contain;
        }
        .product-info {
            flex: 1;
            text-align: left;
            display: flex;
            flex-direction: column;
            justify-content: center;
            height: 100%;
            padding: 0 10px;
        }
        .product-card .product-name {
            font-size: 1.2em;
            font-weight: 500;
            color: #333;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 100%;
            margin: 0 0 8px 0;
            font-family: 'Roboto', sans-serif;
            line-height: 1.3;
        }
        .product-card .price {
            color: #ff4d4d;
            font-weight: 600;
            font-size: 1.3em;
            margin: 8px 0;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .buy-now-btn {
            display: inline-block;
            padding: 6px 12px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1em;
            transition: background-color 0.3s ease;
        }
        .buy-now-btn:hover {
            background-color: #0056b3;
            color: #fff;
        }
        .remove-btn {
            color: #ff4d4d;
            cursor: pointer;
            font-size: 1.5em;
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
        }
        .remove-btn:hover {
            color: #cc0000;
            background: rgba(255, 255, 255, 1);
            transform: scale(1.1);
        }
        .placeholder {
            border: 2px dashed #ddd;
            height: 200px;
            width: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #888;
            font-size: 3em;
            border-radius: 10px;
            background-color: #f9f9f9;
        }
        .add-placeholder {
            color: #007bff;
            font-size: 1.2em;
            cursor: pointer;
            text-decoration: none;
            font-weight: 500;
            margin-top: 8px;
        }
        .add-placeholder:hover {
            color: #0056b3;
        }
        .compare-table {
            width: 1200px;
            margin-left: auto;
            margin-right: auto;
            border-collapse: collapse;
            margin-top: 30px;
        }
        .compare-table th, .compare-table td {
            padding: 15px;
            text-align: center;
            vertical-align: middle;
            border: 1px solid #eee;
            background-color: #fff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            border-radius: 8px;
        }
        .compare-table th:first-child, .compare-table td:first-child {
            width: 200px;
            min-width: 200px;
        }
        .compare-table th:not(:first-child), .compare-table td:not(:first-child) {
            width: 333.33px;
            min-width: 333.33px;
        }
        .compare-table th {
            background-color: #e9ecef;
            font-weight: 600;
            color: #333;
            font-size: 1.2em;
        }
        .filter-checkbox {
            width: 1200px;
            margin: 20px auto;
            text-align: right; /* Căn phải */
            padding-right: 10px; /* Thêm padding để không sát mép */
        }
        .no-products {
            text-align: center;
            color: #666;
            padding: 40px;
            background-color: #f9f9f9;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            max-width: 700px;
            margin: 0 auto;
            font-size: 1.1em;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>

    <div class="compare-container mt-5">
        <h2 class="text-center mb-4" data-aos="fade-up">So sánh sản phẩm</h2>
        <c:choose>
            <c:when test="${empty compareDetails or fn:length(compareDetails) == 0}">
                <div class="no-products" data-aos="fade-up">
                    Chưa có sản phẩm nào để so sánh. 
                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE %>&c=Laptop" class="add-placeholder">Thêm sản phẩm ngay!</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="product-row" data-aos="fade-up">
                    <c:forEach var="entry" items="${compareDetails}" varStatus="loop">
                        <div class="product-card">
                            <span class="remove-btn" onclick="removeProduct(${entry.key.productId})">×</span>
                            <div class="product-content">
                                <div class="image-container">
                                    <img src="${fn:escapeXml(entry.key.imageUrl) != '' ? fn:escapeXml(entry.key.imageUrl) : 'https://via.placeholder.com/200'}" alt="${fn:escapeXml(entry.key.name)}">
                                </div>
                                <div class="product-info">
                                    <div class="product-name">${fn:escapeXml(entry.key.name)}</div>
                                    <div class="price">
                                        <fmt:formatNumber value="${entry.key.price}" type="number" pattern="#,###"/> <span>VNĐ</span>
                                    </div>
                                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&id=${entry.key.productId}" class="buy-now-btn">Mua ngay</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${fn:length(compareDetails) < 3}">
                        <c:forEach begin="${fn:length(compareDetails)}" end="2">
                            <div class="product-card">
                                <div class="product-content">
                                    <div class="image-container">
                                        <div class="placeholder">+</div>
                                    </div>
                                    <div class="product-info">
                                        <div class="add-placeholder">Thêm sản phẩm</div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>

                <div class="filter-checkbox">
                    <input type="checkbox" id="filterDifferent" onchange="filterDifferentValues()">
                    <label for="filterDifferent">Chỉ hiển thị thông tin khác nhau</label>
                </div>

                <table class="compare-table" data-aos="fade-up" id="compareTable">
                    <thead>
                        <tr>
                            <th>Thông số</th>
                            <c:forEach var="entry" items="${compareDetails}" varStatus="loop">
                                <th>${fn:escapeXml(entry.key.name)}</th>
                            </c:forEach>
                            <!-- Thêm tiêu đề trống cho placeholder -->
                            <c:if test="${fn:length(compareDetails) < 3}">
                                <c:forEach begin="${fn:length(compareDetails)}" end="2">
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
                                        <c:when test="${detailIndex == 0}">Bộ vi xử lý (CPU)</c:when>
                                        <c:when test="${detailIndex == 1}">RAM</c:when>
                                        <c:when test="${detailIndex == 2}">Ổ cứng</c:when>
                                        <c:when test="${detailIndex == 3}">Card đồ họa (GPU)</c:when>
                                        <c:when test="${detailIndex == 4}">Màn hình</c:when>
                                        <c:when test="${detailIndex == 5}">Hệ điều hành</c:when>
                                        <c:when test="${detailIndex == 6}">Cổng kết nối</c:when>
                                        <c:when test="${detailIndex == 7}">Bàn phím</c:when>
                                        <c:when test="${detailIndex == 8}">Webcam</c:when>
                                        <c:when test="${detailIndex == 9}">Kết nối Wi-Fi</c:when>
                                        <c:when test="${detailIndex == 10}">Kết nối Bluetooth</c:when>
                                        <c:when test="${detailIndex == 11}">Dung lượng pin (Wh)</c:when>
                                        <c:when test="${detailIndex == 12}">Trọng lượng (kg)</c:when>
                                        <c:when test="${detailIndex == 13}">Kích thước</c:when>
                                    </c:choose>
                                </td>
                                <c:forEach var="entry" items="${compareDetails}">
                                    <td>${fn:escapeXml(entry.value[detailIndex])}</td>
                                </c:forEach>
                                <c:if test="${fn:length(compareDetails) < 3}">
                                    <c:forEach begin="${fn:length(compareDetails)}" end="2">
                                        <td></td>
                                    </c:forEach>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
        <div class="text-center mt-4">
            <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE %>&c=Laptop" class="btn btn-primary">Quay lại trang sản phẩm</a>
        </div>
    </div>

    <div class="mt-5">
        <jsp:include page="/WEB-INF/view/components/footer.jsp" />
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init({
            duration: 1000,
            easing: 'ease-in-out'
        });

        function removeProduct(productId) {
            const urlParams = new URLSearchParams(window.location.search);
            let productIds = urlParams.get('productIds') ? urlParams.get('productIds').split(",") : [];

            productIds = productIds.filter(id => id != productId);

            if (productIds.length > 0) {
                window.location.href = "compare?productIds=" + productIds.join(",");
            } else {
                window.location.href = "<%= ProjectPaths.HREF_TO_PRODUCTPAGE %>";
            }
        }

        function filterDifferentValues() {
            const checkbox = document.getElementById('filterDifferent');
            const table = document.getElementById('compareTable');
            const rows = table.getElementsByTagName('tr');
            const productCount = ${fn:length(compareDetails)}; 

            if (checkbox.checked) {
                for (let i = 1; i < rows.length; i++) {
                    const cells = rows[i].getElementsByTagName('td');
                    let allSame = true;

                    for (let j = 1; j < productCount + 1; j++) {
                        const currentValue = cells[j].textContent.trim();
                        const nextValue = cells[j + 1] ? cells[j + 1].textContent.trim() : '';

                        if (currentValue !== nextValue && currentValue !== '' && nextValue !== '') {
                            allSame = false;
                            break;
                        }
                    }

                    if (allSame) {
                        rows[i].style.display = 'none';
                    } else {
                        rows[i].style.display = '';
                    }
                }
            } else {
                for (let i = 1; i < rows.length; i++) {
                    rows[i].style.display = '';
                }
            }
        }

        window.onload = function() {
            filterDifferentValues();
        };
    </script>
</body>
</html>