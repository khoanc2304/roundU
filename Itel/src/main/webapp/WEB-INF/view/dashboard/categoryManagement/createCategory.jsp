<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Danh Mục</title>
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
        <!-- Gọi sidebar -->
        <jsp:include page="../../components/sidebar.jsp" />
        <!-- Gọi toast -->
        <jsp:include page="../../components/toast.jsp" />

        <div class="container mt-5">
            <h2 class="mb-4">Thêm Danh Mục Mới</h2>
            <form action="main" method="POST">
                <input type="hidden" name="action" value="createCategory">
                <div class="mb-3">
                    <label for="name" class="form-label">Tên Danh Mục</label>
                    <input type="text" class="form-control" id="name" name="name" required>
                </div>
                <div class="mb-3">
                    <label for="description" class="form-label">Mô Tả</label>
                    <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                </div>
                <div class="mb-3">
                    <label for="ImageUrl" class="form-label">Image URL</label>
                    <input class="form-control" id="imageUrl" name="imageUrl" required>
                </div>
                <button type="submit" class="btn btn-primary">Thêm Danh Mục</button>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>

<style>
    .container {
        max-width: 800px;
        margin: 0 auto;
        padding: 40px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1); /* Đổ bóng cho form */
    }

    h2 {
        font-size: 28px;
        font-weight: 600;
        margin-bottom: 30px;
        text-align: center;
    }

    input, select, textarea {
        width: 100%;
        padding: 10px;
        margin-bottom: 20px; /* Khoảng cách giữa các trường */
        border-radius: 6px;
        border: 1px solid #ccc;
        font-size: 16px;
        box-sizing: border-box; /* Đảm bảo padding không làm thay đổi kích thước */
    }

    input:focus, select:focus, textarea:focus {
        outline: none;
        border-color: #398cb6; /* Thay đổi màu viền khi focus */
        box-shadow: 0 0 5px rgba(57, 140, 182, 0.6); /* Thêm bóng mờ khi focus */
    }

    textarea {
        resize: vertical; /* Cho phép người dùng thay đổi chiều cao của textarea */
    }

    button {
        background-color: #398cb6;
        color: white;
        padding: 12px 25px;
        border-radius: 6px;
        font-size: 18px;
        cursor: pointer;
        border: none;
        transition: background-color 0.3s;
        width: 100%;
    }

    button:hover {
        background-color: #2c7bb8;
        transform: scale(1.05); /* Làm nút hơi phóng to khi hover */
    }

    select {
        background-color: #fff;
        border: 1px solid #ccc;
        font-size: 16px;
        padding: 10px;
    }

    label {
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 8px;
        display: inline-block;
    }

    form {
        width: 100%;
        padding: 20px;
        background-color: #f9f9f9;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    .mb-3 {
        margin-bottom: 20px; /* Khoảng cách giữa các trường */
    }

    input[type="file"] {
        padding: 8px;
        background-color: #f1f1f1;
        border-radius: 5px;
        margin-bottom: 20px;
    }
</style>
