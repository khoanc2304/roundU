<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">   
        <!-- Navbar -->
        <div>
            <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>
        </div>
        
        <c:if test="${orders != null && orders.size() > 0}">
            <div class="card">
                <div class="card-header">
                    <h5>Orders Found: ${orders.size()}</h5>
                </div>
                <div class="card-body">
                    <c:forEach var="order" items="${orders}">
                        <div class="alert alert-info">
                            <h6>Order #${order.orderId}</h6>
                            <p>Status: ${order.status}</p>
                            <p>Amount: ${order.totalAmount} VNĐ</p>
                            <p>Details count: ${order.orderDetails != null ? order.orderDetails.size() : 'NULL'}</p>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
        
        <c:if test="${orders == null || orders.size() == 0}">
            <div class="alert alert-warning">
                <h5>❌ NO ORDERS FOUND</h5>
            </div>
        </c:if>
        
        <!--Footer-->                                 
        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>
    </div>
</body>
</html>
