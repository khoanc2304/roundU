<%-- 
    Document   : navbar
    Created on : Mar 8, 2025, 5:43:41 PM
    Author     : ADMIN
--%>

<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Itel Shop </title>

    <!-- Bootstrap 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- AOS Animation -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

</head>
<header class="header">
    <div class="container d-flex align-items-center justify-content-between">
        <a href="<%= ProjectPaths.HREF_TO_HOMEPAGE %>" class="logo">
            <img src="resources/itel.png" alt="Itel Shop Logo">
        </a>
        <div class="search-box">
            <form action="main" method="GET" style="display: flex; width: 100%;">
                <input type="hidden" name="action" value="searchActiveProduct">
                <input type="text" name="qProduct" placeholder="Tìm kiếm sản phẩm..." value="${param.qProduct}">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
        </div>
        <nav class="nav-links d-flex align-items-center gap-3">
            <a href="#" class="nav-link"><i class="fas fa-bell me-1"></i> Thông báo</a>
            <a href="#" class="nav-link"><i class="fas fa-headset me-1"></i> Hỗ trợ</a>
            <a href="<%= ProjectPaths.HREF_TO_CARTPAGE %>" class="nav-link position-relative">
                <i class="fas fa-shopping-cart me-1"></i> Giỏ hàng
            </a>

            <c:choose>
                <c:when test="${not empty sessionScope.loggedUser.role}">
                    <div class="dropdown">
                        <div class="dropdown-toggle d-flex align-items-center gap-2">
                            <img src="${sessionScope.loggedUser.imageUrl}" alt="Avatar" class="rounded-circle" style="width: 35px; height: 35px;">
                            <span class="text-black fw-bold">Xin chào, ${sessionScope.loggedUser.fullName}</span>
                        </div>
                        <div class="dropdown-content">
                            <c:if test="${sessionScope.loggedUser.role.getValue() == 'admin' || sessionScope.loggedUser.role.getValue() == 'staff'}">
                                <a href="<%= ProjectPaths.HREF_TO_DASHBOARDPAGE %>"><i class="fas fa-arrow-left"></i> Quay lại Dashboard</a>
                            </c:if>
                            <a href="<%= ProjectPaths.HREF_TO_PROFILEPAGE %>"><i class="fas fa-users"></i> Hello, ${sessionScope.loggedUser.fullName}</a>
                            <a href="#"><i class="fas fa-shopping-bag"></i> Đơn hàng của tôi</a>
                            <a href="#"><i class="fas fa-eye"></i> Đã xem gần đây</a>
                            <a href="<%= ProjectPaths.HREF_TO_LOGOUTPAGE %>"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="<%= ProjectPaths.HREF_TO_LOGINPAGE %>" class="nav-link"><i class="fas fa-user me-1"></i> Đăng Nhập</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Roboto', sans-serif;
    }

    body {
        color: #212529;
        overflow-x: hidden;
        line-height: 1.6;
        position: relative;
    }

    /* Header */
    .header {
        background: linear-gradient(to bottom, #B3E5FC 0%, #E6F4FA 100%);
        padding: 1rem 2rem;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        position: sticky;
        top: 0;
        z-index: 1030;
        transition: padding 0.3s ease;
    }

    .header .logo img {
        height: 60px;
        transition: transform 0.3s ease;
        border-radius: 20px;
    }

    .header .logo img:hover {
        transform: scale(1.1);
    }

    .search-box {
        display: flex;
        align-items: center;
        background: #ffffff;
        padding: 10px 20px;
        border-radius: 25px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        width: 400px;
        transition: all 0.4s ease;
    }

    .search-box input {
        border: none;
        outline: none;
        background: transparent;
        font-size: 16px;
        width: 100%;
        color: #333;
        padding: 5px;
    }

    .search-box button {
        background: none;
        border: none;
        font-size: 18px;
        color: #33ccff;
        cursor: pointer;
        transition: color 0.3s;
    }

    .search-box button:hover {
        color: #104E8B;
    }

    .search-box:focus-within {
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
        width: 400px;
    }

    .nav-links .nav-link {
        color: #000000;
        font-weight: 500;
        padding: 0.75rem 1.5rem;
        border-radius: 25px;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-flex; /* Changed to inline-flex */
        align-items: center;
        gap: 5px;
        white-space: nowrap; /* Prevent text wrapping */
        min-width: 120px; /* Ensure minimum width to hold text */
    }

    .nav-links .nav-link:hover {
        background: rgba(30, 144, 255, 0.2);
        color: #333333;
    }

    /* Dropdown Styles */
    .dropdown {
        position: relative;
        display: inline-block;
    }
    .dropdown .dropdown-toggle {
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    .dropdown-content {
        display: none;
        position: absolute;
        background-color: #fff;
        min-width: 200px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        border: 1px solid #ddd;
        border-radius: 5px;
        right: 0;
        top: 100%;
        z-index: 1000;
        padding: 5px 0;
    }
    .dropdown:hover .dropdown-content {
        display: block;
    }
    .dropdown-content a {
        color: #000;
        padding: 8px 16px;
        text-decoration: none;
        display: flex;
        align-items: center;
        font-weight: 400;
        transition: background-color 0.2s;
    }
    .dropdown-content a:hover {
        background-color: #f8f9fa;
        color: #000;
    }
    .dropdown-content a i {
        margin-right: 10px;
        font-size: 14px;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .header {
            padding: 0.5rem 1rem;
        }
        .search-box {
            width: 100%;
            margin: 0 10px;
        }
        .nav-links .nav-link {
            padding: 0.5rem 1rem;
            font-size: 14px;
        }
        .dropdown-content {
            right: auto;
            left: 0;
            min-width: 150px;
        }
    }

    /* Accessibility */
    .nav-links .nav-link:focus {
        outline: 2px solid #1E90FF;
        outline-offset: 2px;
    }

    .search-box input::placeholder {
        color: #888;
    }

    body {
        font-size: 16px;
    }
</style>
<script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>