<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>
    <div class="toast-container">
        <c:choose>
            <c:when test="${sessionScope != null && not empty sessionScope.successMessage}">
                <div class="toast success">
                    <i class="fa-solid fa-circle-check toast-icon" style="color: green"></i>
                    <div class="toast-content">
                        <div class="toast-title success"><strong>Thành Công</strong></div>
                        <c:out value="${sessionScope.successMessage}" />
                    </div>
                    <button class="close-btn" onclick="this.parentElement.style.display = 'none'">&times;</button>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:when>
            <c:when test="${sessionScope != null && not empty sessionScope.errorMessage}">
                <div class="toast error">
                    <i class="fa-solid fa-circle-xmark toast-icon" style="color: red"></i>
                    <div class="toast-content">
                        <div class="toast-title error"><strong>Thất Bại</strong></div>
                        <c:out value="${sessionScope.errorMessage}" />
                    </div>
                    <button class="close-btn" onclick="this.parentElement.style.display = 'none'">&times;</button>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:when>
            <c:when test="${sessionScope != null && not empty sessionScope.warningMessage}">
                <div class="toast warning">
                    <i class="fa-solid fa-exclamation toast-icon" style="color: #838300"></i>
                    <div class="toast-content">
                        <div class="toast-title warning"><strong>Cảnh Báo</strong></div>
                        <c:out value="${sessionScope.warningMessage}" />
                    </div>
                    <button class="close-btn" onclick="this.parentElement.style.display = 'none'">&times;</button>
                </div>
                <c:remove var="warningMessage" scope="session" />
            </c:when>
        </c:choose>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const toastElList = document.querySelectorAll('.toast');
            toastElList.forEach(toastEl => {
                toastEl.classList.add('show');

                setTimeout(() => {
                    toastEl.classList.add('fade-out');
                }, 3000);

                setTimeout(() => {
                    toastEl.style.display = 'none';
                }, 6000);

                toastEl.querySelector('.close-btn').addEventListener('click', () => {
                    toastEl.style.display = 'none';
                });
            });
        });
    </script>
</body>

<style>
    .toast-container {
        position: fixed;
        top: 4.5rem;
        right: 20px;
        z-index: 9999;
    }

    .toast {
        font-size: 1.1rem;
        display: flex;
        align-items: center;
        background: #fff;
        padding: 15px 20px;
        margin-bottom: 10px;
        border-radius: 8px;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        opacity: 0;
        transform: translateX(100%);
        animation: slideIn 0.5s forwards;
    }

    .toast-icon {
        font-size: 2rem;
        width: 30px;
        height: 30px;
        display: flex;
        justify-content: center;
        align-items: center;
        margin-right: 10px;
    }

    .toast-content {
        margin-left: 7px;
    }

    .toast-title {
        font-weight: lighter;
        font-size: 1.2rem;
        margin-bottom: 7px;
    }

    .toast-title.success {
        color: green;
    }

    .toast-title.error {
        color: red;
    }

    .toast-title.warning {
        color: orange;
    }

    .toast.success {
        border-left: 4px solid #00ff0a;
        /*background: rgba(213, 255, 213, 0.2);*/
        background: #90ddae;
    }

    .toast.error {
        border-left: 4px solid #ff1100;
        background: rgba(255, 218, 214, 0.2);
    }

    .toast.warning {
        border-left: 4px solid #ffdd00;
        background: rgba(255, 248, 202, 0.2);
    }

    .toast i {
        margin-right: 10px;
        font-size: 1.2rem;
    }

    .toast .close-btn {
        background: none;
        border: none;
        font-size: 1.2rem;
        margin-left: auto;
        cursor: pointer;
    }

    @keyframes slideIn {
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    @keyframes fadeOut {
        0% {
            opacity: 1;
            transform: translateX(0);
        }
        100% {
            opacity: 0;
            transform: translateX(100%);
        }
    }

    .toast.fade-out {
        animation: fadeOut 3s forwards;
        pointer-events: none;
    }

</style>