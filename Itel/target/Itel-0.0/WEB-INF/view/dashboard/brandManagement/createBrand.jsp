<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Brand</title>
    </head>

    <body>
        <%-- <jsp:include page="../../components/navbar.jsp" /> --%>
        <jsp:include page="../../components/sidebar.jsp" />
        <jsp:include page="../../components/toast.jsp" /> 

        <h4>Create New Brand</h4>

        <div class="form-container">
            <%--  <% String actionValue = MainControllerServlet.ACTION_CREATE_BRAND; %>
             <% com.tourismapp.utils.ErrDialog.showError("Rendering createBrand.jsp - Action value: " + actionValue);%> --%>
            <form action="main" method="POST" onsubmit="return validateForm()"> 
                <input type="hidden" name="action" value="createBrand">
                <div class="form-group">
                    <label for="name">Brand Name:</label>
                    <input type="text" id="name" name="name" placeholder="Enter brand name" required>
                    <span id="nameError" class="error-message"></span>
                </div>
                <div class="form-group">
                    <label for="country">Country:</label>
                    <input type="text" id="country" name="country" placeholder="Enter country" required>
                    <span id="countryError" class="error-message"></span>
                </div>
                <div class="form-group">
                    <label for="description">Description:</label>
                    <textarea id="description" name="description" placeholder="Enter description" required></textarea>
                    <span id="descriptionError" class="error-message"></span>
                </div>
                <div class="form-group">
                    <label for="imageUrl">Image URL:</label>
                    <input type="text" id="imageUrl" name="imageUrl" placeholder="Enter image URL" required>
                    <span id="imageUrlError" class="error-message"></span>
                </div>
                <div class="form-group">
                    <label for="status">Status:</label>
                    <select id="status" name="status" required>
                        <option value="">Select Status</option>
                        <option value="ACTIVE">Active</option>
                        <option value="INACTIVE">Inactive</option>
                    </select>
                    <span id="statusError" class="error-message"></span>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Create Brand</button>
                    <a href="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.BRAND_MANAGEMENT_REDIRECT%>" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
        
        <script>
            function validateForm() {
                let isValid = true;
                
                // Clear previous errors
                clearErrors();
                
                // Validate brand name
                const name = document.getElementById('name').value.trim();
                if (!name) {
                    showError('nameError', 'Brand name is required');
                    isValid = false;
                } else if (name.length > 100) {
                    showError('nameError', 'Brand name cannot exceed 100 characters');
                    isValid = false;
                }
                
                // Validate country is required
                const country = document.getElementById('country').value.trim();
                if (!country) {
                    showError('countryError', 'Country is required');
                    isValid = false;
                } else if (country.length > 50) {
                    showError('countryError', 'Country name cannot exceed 50 characters');
                    isValid = false;
                }
                
                // Validate description is required
                const description = document.getElementById('description').value.trim();
                if (!description) {
                    showError('descriptionError', 'Description is required');
                    isValid = false;
                } else if (description.length > 500) {
                    showError('descriptionError', 'Description cannot exceed 500 characters');
                    isValid = false;
                }
                
                // Validate image URL is required
                const imageUrl = document.getElementById('imageUrl').value.trim();
                if (!imageUrl) {
                    showError('imageUrlError', 'Image URL is required');
                    isValid = false;
                } else if (!isValidUrl(imageUrl)) {
                    showError('imageUrlError', 'Please enter a valid URL');
                    isValid = false;
                }
                
                // Validate status is required
                const status = document.getElementById('status').value;
                if (!status || status.trim() === '') {
                    showError('statusError', 'Status is required');
                    isValid = false;
                }
                
                return isValid;
            }
            
            function showError(elementId, message) {
                const errorElement = document.getElementById(elementId);
                if (errorElement) {
                    errorElement.textContent = message;
                    errorElement.style.display = 'block';
                }
            }
            
            function clearErrors() {
                const errorElements = document.querySelectorAll('.error-message');
                errorElements.forEach(element => {
                    element.textContent = '';
                    element.style.display = 'none';
                });
            }
            
            function isValidUrl(string) {
                try {
                    new URL(string);
                    return true;
                } catch (_) {
                    return false;
                }
            }
        </script>
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
        
        .error-message {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: none;
        }
        
        .form-group input:invalid,
        .form-group textarea:invalid {
            border-color: #dc3545;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
    </style>
</html>