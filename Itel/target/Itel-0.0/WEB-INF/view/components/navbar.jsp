<%-- 
    Document   : navbar
    Created on : Mar 8, 2025, 5:43:41 PM
    Author     : ADMIN
--%>

<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>8386 Shop - Laptop & PC</title>

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
        <a href="#" class="logo">
            <img src="resources/itel.png" alt="Itel Shop Logo">
        </a>
        <div class="search-box">
            <form action="search" method="GET" style="display: flex; width: 100%;">
                <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm..." value="${param.keyword}">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
        </div>
        <nav class="nav-links d-flex align-items-center gap-3">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <div class="d-flex align-items-center gap-2">
                        <img src="${sessionScope.loggedInUser.avatar}" alt="Avatar" class="rounded-circle" style="width: 40px; height: 40px;">
                        <span class="text-white fw-bold">${sessionScope.loggedInUser.fullName}</span>
                        <a href="logout" class="nav-link text-white"><i class="fas fa-sign-out-alt me-1"></i> Đăng xuất</a>
                    </div>
                </c:when>
                <c:when test="${not empty sessionScope.googleName}">
                    <div class="d-flex align-items-center gap-2">
                        <img src="${sessionScope.googlePicture}" alt="Avatar" class="rounded-circle" style="width: 40px; height: 40px;">
                        <span class="text-white fw-bold">${sessionScope.googleName}</span>
                        <a href="logout" class="nav-link text-white"><i class="fas fa-sign-out-alt me-1"></i> Đăng xuất</a>
                    </div>
                </c:when>
                <c:when test="${not empty sessionScope.facebookName}">
                    <div class="d-flex align-items-center gap-2">
                        <img src="${not empty sessionScope.facebookPicture ? sessionScope.facebookPicture : 'https://via.placeholder.com/40'}" alt="Avatar" class="rounded-circle" style="width: 40px; height: 40px;">
                        <span class="text-white fw-bold">${sessionScope.facebookName}</span>
                        <a href="logout" class="nav-link text-white"><i class="fas fa-sign-out-alt me-1"></i> Đăng xuất</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="#" class="nav-link"><i class="fas fa-user me-1"></i> Đăng Nhập</a>
                </c:otherwise>
            </c:choose>
            <a href="#" class="nav-link"><i class="fas fa-bell me-1"></i> Thông báo</a>
            <a href="<%= ProjectPaths.HREF_TO_CARTPAGE %>" class="nav-link position-relative">
                <i class="fas fa-shopping-cart me-1"></i> Giỏ hàng
            </a>
            <a href="#" class="nav-link"><i class="fas fa-headset me-1"></i> Hỗ trợ</a>
            <a href="<%= ProjectPaths.HREF_TO_DASHBOARDPAGE %>" class="nav-link"><i class="fas fa-headset me-1"></i> Dashboard</a>
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
        background: #f0f2f5;
        color: #212529;
        overflow-x: hidden;
    }

    /* Header */
    .header {
        background-color: #ff6666;
        padding: 1rem 2rem;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        position: sticky;
        top: 0;
        z-index: 1030;
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
    }

    .search-box button {
        background: none;
        border: none;
        font-size: 18px;
        color: #2a5298;
        cursor: pointer;
        transition: color 0.3s;
    }

    .search-box button:hover {
        color: #ff6f00; 
    }

    .search-box:focus-within {
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
        width: 450px;
    }

    .nav-links .nav-link {
        color: #fff;
        font-weight: 500;
        padding: 0.75rem 1.5rem;
        border-radius: 25px;
        transition: all 0.3s ease;
    }

    .nav-links .nav-link:hover {
        background: rgba(255, 255, 255, 0.25);
        color: #fff;
    }
</style>

<script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
