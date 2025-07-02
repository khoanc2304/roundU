<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Confirmation - Itel Shop</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div>
            <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>
        </div>

        <div class="content container mt-5">
            <!-- Success Message -->
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card border-success">
                        <div class="card-header bg-success text-white text-center">
                            <i class="fas fa-check-circle fa-3x mb-3"></i>
                            <h2 class="mb-0">Order Placed Successfully!</h2>
                        </div>
                        <div class="card-body p-4">
                            <div class="text-center mb-4">
                                <h4 class="text-success">Thank you for your order!</h4>
                                <p class="lead">Your order has been received and is being processed.</p>
                            </div>
                            
                            <!-- Order Information -->
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="info-box">
                                        <h6 class="fw-bold mb-2">
                                            <i class="fas fa-receipt text-primary"></i> Order Details
                                        </h6>
                                        <p class="mb-1"><strong>Order ID:</strong> #${order.orderId}</p>
                                        <p class="mb-1"><strong>Order Date:</strong> 
                                            <c:choose>
                                                <c:when test="${order.orderDate != null}">
                                                    ${order.orderDate}
                                                </c:when>
                                                <c:otherwise>
                                                    N/A
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p class="mb-1"><strong>Status:</strong> 
                                            <span class="badge bg-warning text-dark">${order.status}</span>
                                        </p>
                                        <p class="mb-0"><strong>Total Amount:</strong> 
                                            <span class="text-success fw-bold">
                                                <fmt:formatNumber value="${order.totalAmount}" type="currency" 
                                                                  currencySymbol="₫" maxFractionDigits="0"/>
                                            </span>
                                        </p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-box">
                                        <h6 class="fw-bold mb-2">
                                            <i class="fas fa-credit-card text-success"></i> Payment Information
                                        </h6>
                                        <p class="mb-1"><strong>Payment Method:</strong> ${payment.paymentMethod.value}</p>
                                        <c:if test="${paymentResult.transactionId != null}">
                                            <p class="mb-1"><strong>Transaction ID:</strong> ${paymentResult.transactionId}</p>
                                        </c:if>
                                        <p class="mb-1"><strong>Payment Status:</strong> 
                                            <span class="badge bg-success">
                                                <c:choose>
                                                    <c:when test="${payment.paymentMethod == 'CASH_ON_DELIVERY'}">
                                                        Pending (COD)
                                                    </c:when>
                                                    <c:otherwise>
                                                        Completed
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </p>
                                        <p class="mb-0 text-muted small">${paymentResult.message}</p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Shipping Address -->
                            <div class="mb-4">
                                <h6 class="fw-bold mb-2">
                                    <i class="fas fa-truck text-info"></i> Shipping Address
                                </h6>
                                <div class="alert alert-light">
                                    <p class="mb-0">${order.shippingAddress}</p>
                                </div>
                            </div>
                            
                            <!-- What's Next -->
                            <div class="mb-4">
                                <h6 class="fw-bold mb-3">
                                    <i class="fas fa-clock text-warning"></i> What's Next?
                                </h6>
                                <div class="timeline">
                                    <div class="timeline-item active">
                                        <div class="timeline-marker bg-success">
                                            <i class="fas fa-check"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <h6 class="mb-1">Order Confirmed</h6>
                                            <p class="mb-0 text-muted">Your order has been received and confirmed.</p>
                                        </div>
                                    </div>
                                    <div class="timeline-item">
                                        <div class="timeline-marker bg-secondary">
                                            <i class="fas fa-box"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <h6 class="mb-1">Processing</h6>
                                            <p class="mb-0 text-muted">We're preparing your order for shipment.</p>
                                        </div>
                                    </div>
                                    <div class="timeline-item">
                                        <div class="timeline-marker bg-secondary">
                                            <i class="fas fa-shipping-fast"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <h6 class="mb-1">Shipped</h6>
                                            <p class="mb-0 text-muted">Your order is on its way to you.</p>
                                        </div>
                                    </div>
                                    <div class="timeline-item">
                                        <div class="timeline-marker bg-secondary">
                                            <i class="fas fa-home"></i>
                                        </div>
                                        <div class="timeline-content">
                                            <h6 class="mb-1">Delivered</h6>
                                            <p class="mb-0 text-muted">Your order will be delivered to your address.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Important Notes -->
                            <div class="alert alert-info">
                                <h6 class="alert-heading">
                                    <i class="fas fa-info-circle"></i> Important Notes:
                                </h6>
                                <ul class="mb-0">
                                    <li>You will receive an email confirmation shortly.</li>
                                    <li>Estimated delivery time: 2-5 business days.</li>
                                    <c:if test="${payment.paymentMethod == 'CASH_ON_DELIVERY'}">
                                        <li><strong>Cash on Delivery:</strong> Please have the exact amount ready when receiving your order.</li>
                                    </c:if>
                                    <li>You can track your order status in your profile page.</li>
                                </ul>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="text-center">
                                <a href="/Itel/main?action=homePage" class="btn btn-primary btn-lg me-3">
                                    <i class="fas fa-home"></i> Tiếp tục mua sắm
                                </a>
                                <a href="/Itel/main?action=orderHistory" class="btn btn-outline-primary btn-lg me-3">
                                    <i class="fas fa-shopping-bag"></i> Xem đơn hàng
                                </a>
                                <a href="/Itel/main?action=profilePage" class="btn btn-outline-secondary btn-lg">
                                    <i class="fas fa-user"></i> Xem hồ sơ
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!--Footer-->                                 
        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>
        
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Confetti effect -->
        <script>
            // Simple confetti effect
            function createConfetti() {
                const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#ffeaa7', '#dda0dd'];
                
                for (let i = 0; i < 50; i++) {
                    setTimeout(() => {
                        const confetti = document.createElement('div');
                        confetti.style.position = 'fixed';
                        confetti.style.top = '0px';
                        confetti.style.left = Math.random() * window.innerWidth + 'px';
                        confetti.style.width = '10px';
                        confetti.style.height = '10px';
                        confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                        confetti.style.borderRadius = '50%';
                        confetti.style.pointerEvents = 'none';
                        confetti.style.zIndex = '9999';
                        confetti.style.animation = 'fall 3s linear forwards';
                        
                        document.body.appendChild(confetti);
                        
                        setTimeout(() => {
                            confetti.remove();
                        }, 3000);
                    }, i * 50);
                }
            }
            
            // Add CSS animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes fall {
                    to {
                        transform: translateY(${window.innerHeight}px) rotate(360deg);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);
            
            // Trigger confetti on page load
            window.addEventListener('load', createConfetti);
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
    }
    
    .info-box {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 1rem;
        height: 100%;
    }
    
    .timeline {
        position: relative;
        padding-left: 2rem;
    }
    
    .timeline::before {
        content: '';
        position: absolute;
        left: 15px;
        top: 0;
        bottom: 0;
        width: 2px;
        background: #dee2e6;
    }
    
    .timeline-item {
        position: relative;
        margin-bottom: 1.5rem;
    }
    
    .timeline-marker {
        position: absolute;
        left: -23px;
        top: 0;
        width: 30px;
        height: 30px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 0.8rem;
    }
    
    .timeline-content {
        margin-left: 1rem;
    }
    
    .timeline-item.active .timeline-marker {
        background: #28a745 !important;
    }
    
    .card {
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        border: none;
    }
    
    .card-header {
        border-bottom: none;
    }
    
    .btn-lg {
        padding: 0.75rem 2rem;
        font-size: 1.1rem;
    }
    
    @media (max-width: 768px) {
        .timeline {
            padding-left: 1.5rem;
        }
        
        .timeline-marker {
            left: -18px;
            width: 24px;
            height: 24px;
            font-size: 0.7rem;
        }
        
        .btn-lg {
            width: 100%;
            margin-bottom: 0.5rem;
        }
    }
</style>
