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
        <title>E-Com Product Dashboard</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
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
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
                        <h1 class="h2">E-Com Product Dashboard</h1>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <form action="main" method="get" class="flex-grow-1">
                            <input type="hidden" name="action" value="searchProduct">
                            <div class="input-group search-container">
                                <input type="text" class="form-control" id="searchProduct" name="qProduct"
                                       placeholder="Search products..." value="${param.qProduct}"
                                       aria-label="Search products">
                                <button class="btn btn-primary" type="submit">
                                    <i class="fas fa-search"></i>
                                </button>
                                <c:if test="${not empty param.qProduct}">
                                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTMANAGEMENT %>" class="btn btn-secondary ms-2">
                                        <i class="fas fa-arrow-left"></i>
                                    </a>
                                </c:if>
                            </div>
                        </form>

                        <div class="ms-3">
                            <button type="button" class="btn btn-success btn-md" onclick="window.location.href = 'main?action=createProductForm'">
                                <i class="fas fa-plus"></i> Add Product
                            </button>
                            <!--                            <button type="button" class="btn btn-danger btn-md ms-2" onclick="if(confirm('Are you sure to delete selected products?')) { deleteSelectedProducts(); }">
                                                            <i class="fas fa-trash"></i> Delete
                                                        </button>
                                                        <div class="btn-group ms-2">
                                                            <button type="button" class="btn btn-info btn-md dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                                                Action <i class="fas fa-caret-down"></i>
                                                            </button>
                                                            <ul class="dropdown-menu">
                                                                <li><a class="dropdown-item" href="#">Export</a></li>
                                                                <li><a class="dropdown-item" href="#">Import</a></li>
                                                            </ul>
                                                        </div>-->
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-striped table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th><input type="checkbox" id="selectAll"></th>
                                    <th>Image</th>
                                    <th>Name</th>
                                    <th>Price</th>
                                    <th>Status</th>
                                    <th>Permissions</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${products}" varStatus="loop">
                                    <tr>
                                        <td><input type="checkbox" name="productIds" value="${product.productId}"></td>
                                        <td><img src="${product.imageUrl}" alt="${product.name}" width="50"></td>
                                        <td>${product.name}</td>
                                        <td><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" groupingUsed="true" /></td>
                                        <td>
                                            <label class="switch">
                                                <input type="checkbox" ${product.status == 'ACTIVE' ? 'checked' : ''} disabled>
                                                <span class="slider round"></span>
                                            </label>
                                        </td>
                                        <td>
                                            <span class="badge ${product.status == 'ACTIVE' ? 'bg-success' : 'bg-warning'}">${product.status}</span>
                                        </td>
                                        <td>
                                            <a href="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_MANAGE_PRODUCT%>&id=${product.productId}" class="btn btn-sm btn-primary"><i class="fas fa-eye"></i></a>
                                            <form action="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_DELETE_PRODUCT %>" method="post" class="d-inline">
                                                <input type="hidden" name="productId" value="${product.productId}">
                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">
                                                    <i class="fas fa-trash-alt"></i> Xóa
                                                </button>
                                            </form>                                        
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-end">
                            <c:set var="page" value="${param.page != null ? param.page : 1}" />
                            <c:set var="totalPages" value="${totalPages}" />
                            <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="main?action=productList&page=${page - 1}">Previous</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${page == i ? 'active' : ''}">
                                    <a class="page-link" href="main?action=productList&page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${page >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="main?action=productList&page=${page + 1}">Next</a>
                            </li>
                        </ul>
                    </nav>
                    <div class="text-muted mt-2">Showing ${startIndex + 1} to ${endIndex} of ${totalItems} entries</div>
                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
        function deleteSelectedProducts() {
            const selectedIds = [];
            document.querySelectorAll('input[name="productIds"]:checked').forEach(checkbox => {
                selectedIds.push(checkbox.value);
            });
            if (selectedIds.length > 0) {
                if (confirm('Are you sure to delete selected products?')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'main?action=deleteSelectedProducts';
                    selectedIds.forEach(id => {
                        const input = document.createElement('input');
                        input.type = 'hidden';
                        input.name = 'productIds';
                        input.value = id;
                        form.appendChild(input);
                    });
                    document.body.appendChild(form);
                    form.submit();
                }
            } else {
                alert('Please select at least one product to delete.');
            }
        }

        document.getElementById('selectAll').addEventListener('change', function () {
            document.querySelectorAll('input[name="productIds"]').forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        });
        </script>
    </body>
</html>

<style>
    body {
        font-family: 'Roboto', sans-serif;
        margin: 0;
        background-color: #f5f7fa;
    }

    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 250px;
        height: 100%;
        background-color: #2c3e50;
        color: white;
        z-index: 1000;
        transition: all 0.3s ease;
    }

    .main-container {
        padding: 20px;
        max-width: 1600px;
        transition: margin-left 0.3s ease;
    }

    .table thead th {
        background-color: #f8f9fa;
        font-weight: 600;
        color: #2c3e50;
    }

    .table img {
        border-radius: 5px;
    }

    .switch {
        position: relative;
        display: inline-block;
        width: 60px;
        height: 34px;
    }

    .switch input {
        display:none;
    }

    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        -webkit-transition: .4s;
        transition: .4s;
        border-radius: 34px;
    }

    .slider:before {
        position: absolute;
        content: "";
        height: 26px;
        width: 26px;
        left: 4px;
        bottom: 4px;
        background-color: white;
        -webkit-transition: .4s;
        transition: .4s;
        border-radius: 50%;
    }

    input:checked + .slider {
        background-color: #28a745;
    }

    input:focus + .slider {
        box-shadow: 0 0 1px #28a745;
    }

    input:checked + .slider:before {
        -webkit-transform: translateX(26px);
        -ms-transform: translateX(26px);
        transform: translateX(26px);
    }

    .btn-success {
        background-color: #28a745;
        border: none;
    }
    .btn-success:hover {
        background-color: #218838;
    }
    .btn-danger {
        background-color: #dc3545;
        border: none;
    }
    .btn-danger:hover {
        background-color: #c82333;
    }
    .btn-info {
        background-color: #17a2b8;
        border: none;
    }
    .btn-info:hover {
        background-color: #138496;
    }
    .btn-sm {
        padding: 5px 10px;
        font-size: 12px;
    }
    .search-container {
        max-width: 300px;
    }
    .search-container input {
        border-radius: 5px 0 0 5px;
    }
    .search-container button {
        border-radius: 0 5px 5px 0;
    }
</style>