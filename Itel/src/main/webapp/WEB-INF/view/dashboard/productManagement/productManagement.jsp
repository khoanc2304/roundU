<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="true" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Management Page</title>
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
        <jsp:include page="../../components/sidebar.jsp" />
        <jsp:include page="../../components/toast.jsp" />

        <div class="main-container">
            <div class="row">
                <main class="fade-in" id="page-title">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Danh Sách Sản Phẩm</h1>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <form action="main" method="get" class="flex-grow-1">
                            <input type="hidden" name="action" value="searchProduct">
                            <div class="input-group search-container">
                                <input type="text" class="form-control" id="searchProduct" name="qProduct"
                                       placeholder="Nhập tên sản phẩm cần tìm..." value="${param.qProduct}"
                                       aria-label="Tìm sản phẩm">
                                <button class="btn btn-primary" type="submit">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                                <c:if test="${not empty param.qProduct}">
                                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTMANAGEMENT %>" class="btn btn-secondary ms-2">
                                        <i class="fas fa-arrow-left"></i> Quay lại
                                    </a>
                                </c:if>
                            </div>
                        </form>

                        <form action="main" method="get" class="ms-3">
                            <input type="hidden" name="action" value="createProductForm">
                            <button type="submit" class="btn btn-custom btn-md">
                                <i class="fas fa-plus"></i> Thêm Sản Phẩm
                            </button>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-striped table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Giá</th>
                                    <th>Trạng thái</th>
                                    <th>Quản lý sản phẩm</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${products}" varStatus="loop">
                                    <tr>
                                        <td>${loop.count}</td>
                                        <td>${product.name}</td>
                                        <td><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" groupingUsed="true" /></td>
                                        <td>
                                            <span class="badge rounded-pill
                                                  <c:choose>
                                                      <c:when test="${product.status == 'ACTIVE'}">bg-success</c:when>
                                                      <c:otherwise>bg-danger</c:otherwise>
                                                  </c:choose>
                                                  fs-6 px-2 py-1">
                                                ${product.status}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_MANAGE_PRODUCT%>&id=${product.productId}" class="btn btn-primary btn-sm me-1"><i class="fas fa-eye"></i> Xem</a>
                                            <form action="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_DELETE_PRODUCT %>" method="post" class="d-inline">
                                                <input type="hidden" name="productId" value="${product.productId}">
                                                <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-trash-alt"></i> Xóa</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>


    </body>
</html>

<style>
    body {
        /*        background: linear-gradient(to top, #ffffff, #66ccff);*/
        min-height: 100vh;
        margin: 0;
        font-family: 'Roboto', sans-serif;
    }

    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 250px;
        height: 100%;
        background-color: #343a40;
        color: white;
        z-index: 1000;
        transition: all 0.3s ease;
    }


    #main-content {
        margin-left: 250px;
        padding: 20px;
        width: calc(100% - 250px);
        overflow-x: hidden;
        transition: margin-left 0.3s ease;
    }

    .sidebar.closed {
        width: 0;
    }

    #main-content.closed {
        margin-left: 0;
        width: 100%;
    }

    /* Buttons and table style */
    .add-product-btn {
        background: #28a745;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        font-size: 14px;
        cursor: pointer;
        text-decoration: none;
    }
    .add-product-btn:hover {
        background: #218838;
    }

    .table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    th, td {
        padding: 12px 15px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }

    th {
        background: #f8f9fa;
        font-weight: 600;
        color: #2c3e50;
    }

    td {
        font-size: 14px;
    }

    .search-container {
        display: flex; /* Căn chỉnh các phần tử theo hàng ngang */
        max-width: 600px; /* Chiều rộng tối đa */
        width: 100%; /* Chiếm hết không gian có sẵn */
        margin-bottom: 15px; /* Khoảng cách dưới cho đẹp */
    }

    .search-container input {
        width: 100%; /* Chiếm hết không gian của input */
        padding: 10px 15px; /* Thêm padding để nội dung hiển thị rõ ràng */
        border-radius: 5px 0 0 5px; /* Bo tròn góc trái */
        border: 1px solid #ccc;
        font-size: 14px;
        box-sizing: border-box; /* Đảm bảo padding không làm thay đổi kích thước */
    }

    .search-container button {
        background-color: #858f93 !important; /* Màu nền của nút */
        color: white; /* Màu chữ */
        border: none; /* Bỏ viền */
        padding: 10px 20px; /* Thêm padding cho nút */
        border-radius: 0 5px 5px 0; /* Bo tròn góc phải */
        cursor: pointer; /* Thay đổi con trỏ khi hover */
    }

    .search-container button:hover {
        background-color: #5992af !important; /* Màu nền khi hover */
        border-color: #004085 !important; /* Màu viền khi hover */
    }

    /* Hiệu ứng focus cho nút tìm kiếm khi nhấp vào */
    .search-container button:focus {
        outline: none;
        box-shadow: 0 0 5px rgba(0, 123, 255, 0.5); /* Thêm bóng mờ khi nhấp */
    }

    /* Chỉ ảnh hưởng đến nút "Thêm Sản Phẩm" */
    .btn-custom {
        background-color: #398cb6;
        color: white;
        padding: 15px 30px;
        border-radius: 6px;
        font-size: 18px;
        cursor: pointer; /* Thêm cursor pointer khi hover */
        border: none;
        transition: background-color 0.3s ease;
        margin-right: 30px;
        margin-top: 20px;
    }

    .btn-custom:hover {
        background-color: #2c7bb8;
        transform: scale(1.05);
        color: white;
    }

    .btn-primary {
        background-color: #999999 !important;
        color: white;
        border: none;
        padding: 5px 12px;
        border-radius: 5px;
        font-size: 14px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .btn-primary:hover {
        background-color: #0000ff !important;
    }

    .btn-secondary {
        background-color: #999999 !important;
        border: none;
        padding: 5px 12px;
        border-radius: 5px;
        font-size: 14px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .btn-secondary:hover {
        background-color: #0000ff !important;
    }

    .btn-danger {
        background-color: #999999 !important;
        color: white;
        border: none;
        padding: 5px 12px;
        border-radius: 5px;
        font-size: 14px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .btn-danger:hover {
        background-color: #ff0000 !important;
    }

</style>
