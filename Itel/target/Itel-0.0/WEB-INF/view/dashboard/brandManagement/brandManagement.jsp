<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Brand Management Page</title>
    </head>
    <body>
        <input type="hidden" id="currentPage" name="currentPage" value="brandManagement">
        <jsp:include page="../../components/sidebar.jsp" />
        <jsp:include page="../../components/toast.jsp" />

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 50px 50px 0 70px; max-width: 1200px; margin-left: auto; margin-right: auto;">
            <!-- Search Bar on the left -->
            <form action="<%= ProjectPaths.HREF_TO_MAINCONTROLLER%>" method="get" style="display: inline; margin-right: 20px;">
                <input type="hidden" name="action" value="<%= MainControllerServlet.ACTION_FIND_BRAND %>">
                <input type="hidden" name="currentPage" value="brandManagement">
                <input type="text" name="searchName" placeholder="Search by name..." style="padding: 5px; border: 1px solid #ddd; border-radius: 4px;">
                <button type="submit" class="btn btn-secondary" style="padding: 5px 10px;">Search</button>
            </form>
            <!-- Brand List in the middle -->
            <h4 style="margin: 0;">Brand List</h4>
            <!-- Create Button on the right -->
            <div>
                <a href="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT + "&currentPage=brandManagement"%>" class="btn btn-info" style="margin-right: 10px;">Back to Manage Brand</a>
                <a href="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_NAVIGATE_TO_CREATE_BRAND%>&currentPage=brandManagement" class="btn btn-primary">Create New Brand</a>
            </div>
        </div>
        <table style="max-width: 1200px; margin-left: auto; margin-right: auto;">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Country</th>
                <th>Description</th>
                <th>Image</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <c:forEach var="brand" items="${brands}">
                <tr>
                    <td>${brand.brandId}</td>
                    <td>${brand.name}</td>
                    <td>${brand.country}</td>
                    <td>${brand.description}</td>
                    <td><img src="${brand.imageUrl}" alt="${brand.name}" style="max-width: 100px; max-height: 100px;"></td>
                    <td>${brand.status}</td>
                    <td>
                        <form action="<%= ProjectPaths.HREF_TO_MAINCONTROLLER%>" method="get" style="display: inline;">
                            <input type="hidden" name="action" value="<%= MainControllerServlet.ACTION_NAVIGATE_TO_UPDATE_BRAND %>">
                            <input type="hidden" name="brandId" value="${brand.brandId}">
                            <input type="hidden" name="currentPage" value="brandManagement">
                            <button type="submit" class="btn btn-warning btn-sm">Edit</button>
                        </form>
<!--                        <form action="main" method="POST" style="display: inline;">
                            <input type="hidden" name="action" value="deleteBrand">
                            <input type="hidden" name="brandId" value="${brand.brandId}">
                            <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                        </form>-->
                    </td>
                </tr>
            </c:forEach>
        </table>

    </body>


    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f4f4f4, #e0e7ff);
            margin: 0;
            padding: 20px;
            color: #333;
        }

        h4 {
            color: #2c3e50;
            font-size: 1.8rem;
            text-align: center;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        table {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

        th, td {
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
            font-size: 0.95rem;
        }

        th {
            background: #3498db;
            color: #fff;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            color: #555;
        }

        tr:nth-child(even) {
            background: #f9f9f9;
        }

        tr:hover {
            background: #f1f9ff;
            transition: background 0.2s ease;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .action-buttons input[type="submit"] {
            padding: 6px 12px;
            border-radius: 4px;
            border: none;
            background: #e74c3c;
            color: #fff;
            font-size: 0.9rem;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .action-buttons input[type="submit"]:hover {
            background: #c0392b;
        }

        @media (max-width: 768px) {
            table {
                font-size: 0.85rem;
            }

            th, td {
                padding: 8px 10px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 4px;
            }

            .action-buttons input[type="submit"] {
                width: 100%;
                text-align: center;
            }
        }

        img {
            max-width: 100px;
            max-height: 100px;
            object-fit: contain;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .btn-sm {
            padding: 5px 10px;
            font-size: 0.875rem;
        }

        .btn-warning {
            background-color: #ffc107;
            border-color: #ffc107;
        }

        .btn-warning:hover {
            background-color: #e0a800;
            border-color: #e0a800;
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
            border-color: #c82333;
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
            padding: 10px 20px;
            border-radius: 5px;
            color: #fff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }

        .btn-secondary {
            padding: 10px 20px;
            font-size: 1rem;
            background-color: #6c757d;
            border-color: #6c757d;
            border-radius: 5px;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #5a6268;
        }
    </style>
</html>
<!--<script>
    // Sử dụng JavaScript để truyền currentPage từ input ẩn sang form trong navbar
    document.addEventListener("DOMContentLoaded", function() {
        var currentPage = document.getElementById("currentPage").value;
        var searchForm = document.querySelector(".search-box form");
        if (searchForm) {
            var hiddenInput = document.createElement("input");
            hiddenInput.type = "hidden";
            hiddenInput.name = "currentPage";
            hiddenInput.value = currentPage;
            searchForm.appendChild(hiddenInput);
        }
    });
</script>-->