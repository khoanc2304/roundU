<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đơn hàng của tôi - Itel Shop</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <!-- Navbar -->
        <div>
            <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>
        </div>

        <div class="content container mt-5">
            <div class="row">
                <div class="col-12">
                    <h2><i class="fas fa-receipt"></i> Đơn hàng của tôi</h2>
                    <p class="text-muted">Theo dõi và quản lý đơn hàng của bạn</p>
                    <hr>
                </div>
            </div>

            <!-- Debug Info -->
            <div class="alert alert-info">
                <h5>Debug Information:</h5>
                <p>User: <%= session.getAttribute("loggedUser") != null ? "Logged in" : "Not logged in" %></p>
                <p>Orders: ${orders != null ? orders.size() : 'null'}</p>
                <button class="btn btn-primary" onclick="testApiCall()">Test API Call</button>
            </div>

            <!-- Orders List -->
            <div id="ordersContainer">
                <p>Loading orders...</p>
            </div>
        </div>

        <!-- Footer -->
        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            function testApiCall() {
                console.log('Testing API call...');
                
                fetch('/Itel/api/orders')
                    .then(response => {
                        console.log('Response status:', response.status);
                        return response.json();
                    })
                    .then(data => {
                        console.log('API Response:', data);
                        document.getElementById('ordersContainer').innerHTML = 
                            '<pre>' + JSON.stringify(data, null, 2) + '</pre>';
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        document.getElementById('ordersContainer').innerHTML = 
                            '<div class="alert alert-danger">Error: ' + error.message + '</div>';
                    });
            }
            
            // Auto test on load
            document.addEventListener('DOMContentLoaded', function() {
                testApiCall();
            });
        </script>
    </body>
</html>

<style>
    body {
        margin: 0;
        background-color: #f8f9fa;
    }
    
    .content {
        padding-top: 150px;
        min-height: 80vh;
    }
</style>
