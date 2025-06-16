<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SideBar</title>

    </head>
    <body id="body-pd">
        <!-- Header -->
        <header id="header" class="header bg-light shadow-sm py-2">
            <div class="container-fluid">
                <div class="row align-items-center">
                    <div class="col-3">
                        <div class="header_toggle">
                            <i class='bx bx-menu' id="header-toggle"></i>
                        </div>
                    </div>

                    <div class="col-6 d-flex justify-content-center">
                    </div>

                    <div class="col-3 d-flex justify-content-end align-items-center">
                        <div class="d-flex align-items-center ms-3">
                            <img src="${sessionScope.loggedUser.imageUrl}" alt="avatar" class="rounded-circle border" width="40px">
                            <a href="#" class="ms-2 text-dark fw-semibold text-decoration-none">
                                ${sessionScope.loggedUser.fullName}
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Sidebar -->
        <div class="l-navbar" id="nav-bar">
            <nav class="nav">
                <div>
                    <a href="<%= ProjectPaths.HREF_TO_HOMEPAGE %>" class="nav_logo">
                        <img src="resources/itel.png" alt="Logo">
                    </a>

                    <div class="nav_list">
                        <a href="<%= ProjectPaths.HREF_TO_DASHBOARDPAGE %>" class="nav_link">
                            <i class='bx bx-home nav_icon'></i>
                            <span class="nav_name">Dashboard</span>
                        </a>
                        <a href="<%= ProjectPaths.HREF_TO_USERMANAGEMENT %>" class="nav_link">
                            <i class='bx bx-user-circle nav_icon'></i>
                            <span class="nav_name">Users</span>
                        </a>
                        <a href="<%= ProjectPaths.HREF_TO_BRANDMANAGEMENT %>" class="nav_link">
                            <i class='bx bx-purchase-tag nav_icon'></i>
                            <span class="nav_name">Brands</span>
                        </a>
                        <a href="<%= ProjectPaths.HREF_TO_CATEGORYMANAGEMENT %>" class="nav_link">
                            <i class='bx bx-category nav_icon'></i>
                            <span class="nav_name">Categories</span>
                        </a>
                        <a href="<%= ProjectPaths.HREF_TO_PRODUCTMANAGEMENT %>" class="nav_link">
                            <i class='bx bx-package nav_icon'></i>
                            <span class="nav_name">Products</span>
                        </a>
                        <a href="<%= ProjectPaths.HREF_TO_ORDERMANAGEMENT %>" class="nav_link">
                            <i class='bx bx-cart nav_icon'></i>
                            <span class="nav_name">Orders</span>
                        </a>
                        <a href="#" class="nav_link">
                            <i class='bx bx-store nav_icon'></i>
                            <span class="nav_name">All Product</span>
                        </a>

                    </div>
                </div>

                <a href="#" class="nav_link text-dark fw-semibold" data-bs-toggle="modal" data-bs-target="#logoutModal">
                    <i class='bx bx-log-out nav_icon'></i>
                    <span class="nav_name">Đăng Xuất</span>
                </a>

            </nav>
        </div>

        <div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="logoutModalLabel">Đang đăng xuất...</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này không?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <a href="<%= ProjectPaths.HREF_TO_LOGOUTPAGE %>" class="btn btn-primary">Đăng Xuất</a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function (event) {

                const showNavbar = (toggleId, navId, bodyId, headerId) => {
                    const toggle = document.getElementById(toggleId),
                            nav = document.getElementById(navId),
                            bodypd = document.getElementById(bodyId),
                            headerpd = document.getElementById(headerId)

                    if (toggle && nav && bodypd && headerpd) {
                        toggle.addEventListener('click', () => {
                            nav.classList.toggle('show')
                            toggle.classList.toggle('bx-x')
                            bodypd.classList.toggle('body-pd')
                            headerpd.classList.toggle('body-pd')
                        })
                    }
                }

                showNavbar('header-toggle', 'nav-bar', 'body-pd', 'header')

                /*===== LINK ACTIVE =====*/
                const linkColor = document.querySelectorAll('.nav_link')

                function colorLink() {
                    if (linkColor) {
                        linkColor.forEach(l => l.classList.remove('active'))
                        this.classList.add('active')
                    }
                }
                linkColor.forEach(l => l.addEventListener('click', colorLink))

            });
        </script>
    </body>
</html>

<!-- CSS Links -->
<style>
    @import url("https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap");

    :root {
        --header-height: 3rem;
        --nav-width: 68px;
        --first-color: #4723D9;
        --first-color-light: #AFA5D9;
        --white-color: #F7F6FB;
        --body-font: 'Nunito', sans-serif;
        --normal-font-size: 1rem;
        --z-fixed: 100;
    }

    *, ::before, ::after {
        box-sizing: border-box;
    }

    body {
        position: relative;
        margin: var(--header-height) 0 0 0;
        padding: 0 1rem;
        font-family: var(--body-font);
        font-size: var(--normal-font-size);
        transition: .5s;
    }

    a {
        text-decoration: none;
    }

    .header {
        width: 100%;
        height: var(--header-height);
        position: fixed;
        top: 0;
        left: 0;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 1rem;
        background-color: var(--white-color);
        z-index: var(--z-fixed);
        transition: .5s;
    }

    .input-group .form-control {

        border-radius: 0.5rem 0 0 0.5rem;
    }
    .input-group .btn {
        border-radius: 0 0.5rem 0.5rem 0;
    }

    .header_toggle {
        margin-top: 12px;
    }
    .input-group {
        margin-top: 12px;
    }

    .header_toggle {
        color: #666666;
        font-size: 2rem;
        cursor: pointer;
    }

    .header_img {
        width: 35px;
        height: 35px;
        display: flex;
        justify-content: center;
        border-radius: 50%;
        overflow: hidden;
    }

    .header_img img {
        width: 40px;
    }

    .nav_logo img {
        width: 72px;
        height: auto;
        margin-left: 0;
        display: block;
    }

    .btn-primary {
        background-color: #6c757d !important;
        border-color: #6c757d !important;
        color: white !important;
    }
    .btn-primary:hover {
        background-color: #5c636a !important;
        border-color: #565e64 !important;
    }


    .l-navbar {
        position: fixed;
        top: 0;
        left: -30%;
        width: var(--nav-width);
        height: 100vh;
        background-color: #cccccc;
        padding: .5rem 1rem 0 0;
        transition: .5s;
        z-index: var(--z-fixed);
    }

    .nav {
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        overflow: hidden;
    }

    .nav_logo, .nav_link {
        display: grid;
        grid-template-columns: max-content max-content;
        align-items: center;
        column-gap: 1rem;
        padding: .5rem 0 .5rem 1.5rem;
    }

    .nav_logo {
        margin-bottom: 2rem;
    }

    .nav_logo-icon {
        font-size: 1.25rem;
        color: var(--white-color);
    }

    .nav_logo-name {
        color: var(--white-color);
        font-weight: 700;
    }

    .nav_link {
        position: relative;
        color: #000000; /* hoặc #212529 cho màu đen nhẹ đẹp */
        font-weight: 600;
        margin-bottom: 0.5rem;
        transition: .3s;
        opacity: 0.9;
    }

    .nav_link:hover {
        color: var(--white-color);
    }

    .nav_icon {
        font-size: 1.25rem;
    }

    .show {
        left: 0;
    }

    .body-pd {
        padding-left: calc(var(--nav-width) + 1rem);
    }

    .active {
        color: var(--white-color);
    }

    .active::before {
        content: '';
        position: absolute;
        left: 0;
        width: 2px;
        height: 32px;
        background-color: var(--white-color);
    }

    .height-100 {
        height: 100vh;
    }

    @media screen and (min-width: 768px) {
        body {
            margin: calc(var(--header-height) + 1rem) 0 0 0;
            padding-left: calc(var(--nav-width) + 2rem);
        }

        .header {
            height: calc(var(--header-height) + 1rem);
            padding: 0 2rem 0 calc(var(--nav-width) + 2rem);
        }

        .header_img {
            width: 40px;
            height: 40px;
        }

        .header_img img {
            width: 45px;
        }

        .l-navbar {
            left: 0;
            padding: 1rem 1rem 0 0;
        }

        .show {
            width: calc(var(--nav-width) + 156px);
        }

        .body-pd {
            padding-left: calc(var(--nav-width) + 188px);
        }
    }
</style>
<%-- BOOTSTRAP --%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

<link href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css" rel="stylesheet">