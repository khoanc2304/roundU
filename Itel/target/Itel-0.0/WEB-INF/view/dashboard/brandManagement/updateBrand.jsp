<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Brand</title>
    </head>
    <body>
        <jsp:include page="../../components/navbar.jsp" />
        <jsp:include page="../../components/sidebar.jsp" />
        <jsp:include page="../../components/toast.jsp" />

        <h4>Update Brand</h4>

        <!-- Form to update a brand -->
        <div class="form-container">
            <form action="main" method="POST">
                <input type="hidden" name="action" value="editBrand">
                <input type="hidden" name="brandId" value="${brand.brandId}">
                <div class="form-group">
                    <label for="name">Brand Name:</label>
                    <input type="text" id="name" name="name" value="${brand.name}" required>
                </div>
                <div class="form-group">
                    <label for="country">Country:</label>
                    <input type="text" id="country" name="country" value="${brand.country}">
                </div>
                <div class="form-group">
                    <label for="description">Description:</label>
                    <textarea id="description" name="description">${brand.description}</textarea>
                </div>
                <div class="form-group">
                    <label for="imageUrl">Image URL:</label>
                    <input type="text" id="imageUrl" name="imageUrl" value="${brand.imageUrl}">
                </div>
                <div class="form-group">
                    <label for="status">Status:</label>
                    <select id="status" name="status">
                        <option value="ACTIVE" ${brand.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                        <option value="INACTIVE" ${brand.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Update Brand</button>
                    <a href="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT%>" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </body>
</html>

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

    .form-container {
        max-width: 500px;
        margin: 0 auto;
        background: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .form-group {
        margin-bottom: 15px;
    }

    .form-group label {
        display: block;
        font-weight: 600;
        margin-bottom: 5px;
        color: #2c3e50;
    }

    .form-group input[type="text"],
    .form-group textarea,
    .form-group select {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 0.95rem;
        color: #555;
    }

    .form-group textarea {
        height: 100px;
        resize: vertical;
    }

    .form-group button {
        padding: 10px 20px;
        font-size: 1rem;
        border-radius: 5px;
        cursor: pointer;
    }

    .btn-primary {
        background-color: #007bff;
        border-color: #007bff;
        color: #fff;
    }

    .btn-primary:hover {
        background-color: #0056b3;
        border-color: #0056b3;
    }

    .btn-secondary {
        background-color: #6c757d;
        border-color: #6c757d;
        color: #fff;
        text-decoration: none;
        padding: 10px 20px;
        border-radius: 5px;
    }

    .btn-secondary:hover {
        background-color: #5a6268;
        border-color: #5a6268;
    }
</style>