<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Checkout - Itel Shop</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <div>
            <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>
        </div>

        <div class="content container mt-5">
            <!-- Checkout Steps -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="checkout-steps">
                        <div class="step completed">
                            <i class="fas fa-shopping-cart"></i>
                            <span>Giỏ hàng</span>
                        </div>
                        <div class="step active">
                            <i class="fas fa-clipboard-list"></i>
                            <span>Thanh toán</span>
                        </div>
                        <div class="step">
                            <i class="fas fa-credit-card"></i>
                            <span>Thanh toán</span>
                        </div>
                        <div class="step">
                            <i class="fas fa-check-circle"></i>
                            <span>Hoàn thành</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-8">
                    <!-- Checkout Form -->
                    <form id="checkoutForm" action="/Itel/payment" method="post">
                        <!-- Hidden input to track checkout type -->
                        <input type="hidden" name="checkoutType" value="${checkoutType}">

                        <!-- Hidden inputs for selected items (when checkoutType is 'selected') -->
                        <c:if test="${checkoutType == 'selected'}">
                            <c:forEach var="item" items="${cart.items}" varStatus="status">
                                <input type="hidden" name="selectedItems[${status.index}].productId" value="${item.product.productId}">
                                <input type="hidden" name="selectedItems[${status.index}].quantity" value="${item.quantity}">
                            </c:forEach>
                        </c:if>
                        <!-- Shipping Information -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-truck"></i> Thông tin giao hàng</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="firstName" class="form-label">Tên *</label>
                                        <input type="text" class="form-control" id="firstName" name="firstName" 
                                               value="${user.firstName}" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="lastName" class="form-label">Họ *</label>
                                        <input type="text" class="form-control" id="lastName" name="lastName" 
                                               value="${user.lastName}" required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="email" class="form-label">Email *</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${user.email}" required>
                                </div>

                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại *</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           value="${user.phoneNumber}" required>
                                </div>

                                <div class="mb-3">
                                    <label for="address" class="form-label">Địa chỉ *</label>
                                    <textarea class="form-control" id="address" name="address" rows="2" 
                                              placeholder="Nhập địa chỉ của bạn" required>${user.address}</textarea>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="city" class="form-label">Thành phố *</label>
                                        <input type="text" class="form-control" id="city" name="city" 
                                               placeholder="Thành phố" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="district" class="form-label">Quận/Huyện *</label>
                                        <input type="text" class="form-control" id="district" name="district" 
                                               placeholder="Quận/Huyện" required>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Payment Method -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-credit-card"></i> Phương thức thanh toán</h5>
                            </div>
                            <div class="card-body">
                                <div class="payment-methods">
                                    <div class="form-check payment-option mb-3">
                                        <input class="form-check-input" type="radio" name="paymentMethod" 
                                               id="cod" value="CASH_ON_DELIVERY" checked>
                                        <label class="form-check-label payment-label" for="cod">
                                            <div class="payment-content">
                                                <i class="fas fa-money-bill-wave text-success"></i>
                                                <div>
                                                    <strong>Thanh toán khi nhận hàng</strong>
                                                    <small class="text-muted d-block">Thanh toán khi nhận sản phẩm</small>
                                                </div>
                                            </div>
                                        </label>
                                    </div>

                                    <div class="form-check payment-option mb-3">
                                        <input class="form-check-input" type="radio" name="paymentMethod" 
                                               id="banking" value="BANKING">
                                        <label class="form-check-label payment-label" for="banking">
                                            <div class="payment-content">
                                                <i class="fas fa-university text-primary"></i>
                                                <div>
                                                    <strong>Chuyển khoản ngân hàng</strong>
                                                    <small class="text-muted d-block">Thanh toán qua chuyển khoản</small>
                                                </div>
                                            </div>
                                        </label>
                                    </div>

                                    <div class="form-check payment-option">
                                        <input class="form-check-input" type="radio" name="paymentMethod" 
                                               id="card" value="CASH">
                                        <label class="form-check-label payment-label" for="card">
                                            <div class="payment-content">
                                                <i class="fas fa-credit-card text-info"></i>
                                                <div>
                                                    <strong>Thẻ tín dụng/Ghi nợ</strong>
                                                    <small class="text-muted d-block">Thanh toán bằng thẻ (Demo)</small>
                                                </div>
                                            </div>
                                        </label>
                                    </div>
                                </div>

                                <!-- Fake Card Form (shown when card payment selected) -->
                                <div id="cardForm" class="mt-3" style="display: none;">
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle"></i> Đây là form thanh toán demo. Không có giao dịch thật sự.
                                    </div>
                                    <div class="row">
                                        <div class="col-12 mb-3">
                                            <label for="cardNumber" class="form-label">Số thẻ</label>
                                            <input type="text" class="form-control" id="cardNumber" 
                                                   placeholder="1234 5678 9012 3456" maxlength="19">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="expiryDate" class="form-label">Ngày hết hạn</label>
                                            <input type="text" class="form-control" id="expiryDate" 
                                                   placeholder="MM/YY" maxlength="5">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="cvv" class="form-label">CVV</label>
                                            <input type="text" class="form-control" id="cvv" 
                                                   placeholder="123" maxlength="3">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Order Notes -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-sticky-note"></i> Ghi chú đơn hàng (Tùy chọn)</h5>
                            </div>
                            <div class="card-body">
                                <textarea class="form-control" name="orderNotes" rows="3" 
                                          placeholder="Các yêu cầu đặc biệt cho đơn hàng của bạn..."></textarea>
                            </div>
                        </div>
                        
                        <!-- Discount Code -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-tag"></i> Mã giảm giá</h5>
                            </div>
                            <div class="card-body">
                                <div class="dropdown w-100 mb-3">
                                    <button class="btn btn-outline-secondary dropdown-toggle w-100 d-flex justify-content-between align-items-center" type="button" id="couponDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                        <span id="selectedCouponText">Chọn mã giảm giá</span>
                                        <i class="fas fa-tags"></i>
                                    </button>
                                    <ul class="dropdown-menu w-100" aria-labelledby="couponDropdown">
                                        <li><a class="dropdown-item coupon-item" href="#" data-code="" data-discount="0">Không áp dụng mã giảm giá</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><h6 class="dropdown-header">Ưu đãi mùa tựu trường</h6></li>
                                        <li>
                                            <a class="dropdown-item coupon-item" href="#" data-code="BACKTOSCHOOL10" data-discount="10" data-min="5000000">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <strong>BACKTOSCHOOL10</strong>
                                                        <div class="small text-muted">Giảm 10% cho đơn từ 5 triệu</div>
                                                    </div>
                                                    <span class="badge bg-primary align-self-center">-10%</span>
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item coupon-item" href="#" data-code="BACKTOSCHOOL15" data-discount="15" data-min="10000000">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <strong>BACKTOSCHOOL15</strong>
                                                        <div class="small text-muted">Giảm 15% cho đơn từ 10 triệu</div>
                                                    </div>
                                                    <span class="badge bg-primary align-self-center">-15%</span>
                                                </div>
                                            </a>
                                        </li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><h6 class="dropdown-header">Ưu đãi tháng 8</h6></li>
                                        <li>
                                            <a class="dropdown-item coupon-item" href="#" data-code="AUGUST10" data-discount="10" data-min="5000000">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <strong>AUGUST10</strong>
                                                        <div class="small text-muted">Giảm 10% cho đơn từ 5 triệu</div>
                                                    </div>
                                                    <span class="badge bg-primary align-self-center">-10%</span>
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item coupon-item" href="#" data-code="AUGUST15" data-discount="15" data-min="10000000">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <strong>AUGUST15</strong>
                                                        <div class="small text-muted">Giảm 15% cho đơn từ 10 triệu</div>
                                                    </div>
                                                    <span class="badge bg-primary align-self-center">-15%</span>
                                                </div>
                                            </a>
                                        </li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><h6 class="dropdown-header">Ưu đãi đặc biệt</h6></li>
                                        <li>
                                            <a class="dropdown-item coupon-item" href="#" data-code="FRESHMAN" data-discount="7" data-min="0">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <strong>FRESHMAN</strong>
                                                        <div class="small text-muted">Giảm 7% cho sinh viên năm nhất</div>
                                                    </div>
                                                    <span class="badge bg-success align-self-center">-7%</span>
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item coupon-item" href="#" data-code="BLACKFRIDAY" data-discount="5" data-min="0">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <strong>BLACKFRIDAY</strong>
                                                        <div class="small text-muted">Giảm 5% dịp Black Friday</div>
                                                    </div>
                                                    <span class="badge bg-dark align-self-center">-5%</span>
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item coupon-item" href="#" data-code="FIRSTORDER" data-discount="500000" data-min="7000000" data-type="fixed">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <strong>FIRSTORDER</strong>
                                                        <div class="small text-muted">Giảm 500.000đ cho đơn đầu tiên từ 7 triệu</div>
                                                    </div>
                                                    <span class="badge bg-danger align-self-center">-500K</span>
                                                </div>
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item coupon-item" href="#" data-code="SCHOOL1M" data-discount="1000000" data-min="15000000" data-type="fixed">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <strong>SCHOOL1M</strong>
                                                        <div class="small text-muted">Giảm 1 triệu đồng cho đơn từ 15 triệu</div>
                                                    </div>
                                                    <span class="badge bg-danger align-self-center">-1M</span>
                                                </div>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                                <input type="hidden" id="couponCode" name="couponCode" value="">
                                <input type="hidden" id="couponDiscountType" name="couponDiscountType" value="percent">
                                <div id="couponMessage" class="mt-2" style="display: none;"></div>
                                
                                <c:if test="${not empty user.membershipLevel && user.membershipLevel.levelId != 5}">
                                    <div class="alert alert-info mt-3">
                                        <div class="d-flex align-items-center">
                                            <c:choose>
                                                <c:when test="${user.membershipLevel.levelId == 1}">
                                                    <span class="me-2">🥉</span>
                                                </c:when>
                                                <c:when test="${user.membershipLevel.levelId == 2}">
                                                    <span class="me-2">🥈</span>
                                                </c:when>
                                                <c:when test="${user.membershipLevel.levelId == 3}">
                                                    <span class="me-2">🥇</span>
                                                </c:when>
                                                <c:when test="${user.membershipLevel.levelId == 4}">
                                                    <span class="me-2">💎</span>
                                                </c:when>
                                            </c:choose>
                                            <div>
                                                <strong>Ưu đãi thành viên ${user.membershipLevel.value}</strong>
                                                <div>Bạn được giảm <strong>${user.membershipLevel.levelId == 1 ? '3%' : user.membershipLevel.levelId == 2 ? '5%' : user.membershipLevel.levelId == 3 ? '7%' : '10%'}</strong> cho đơn hàng này</div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Order Summary -->
                <div class="col-lg-4">
                    <div class="card sticky-top" style="top: 150px;">
                        <div class="card-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Tổng kết đơn hàng</h5>
                                <c:if test="${checkoutType == 'selected'}">
                                    <span class="badge bg-info">Sản phẩm đã chọn</span>
                                </c:if>
                            </div>
                            <c:if test="${checkoutType == 'selected'}">
                                <small class="text-muted">Thanh toán ${selectedItemsCount} sản phẩm đã chọn</small>
                            </c:if>
                        </div>
                        <div class="card-body">
                            <!-- Selected items info -->
                            <c:if test="${checkoutType == 'selected'}">
                                <div class="alert alert-info mb-3">
                                    <i class="fas fa-info-circle"></i>
                                    <small>Bạn đang thanh toán ${cart.totalItems} sản phẩm đã chọn từ giỏ hàng</small>
                                </div>
                            </c:if>

                            <!-- Cart Items -->
                            <c:forEach var="item" items="${cart.items}">
                                <div class="d-flex align-items-center mb-3">
                                    <img src="${item.product.imageUrl}" class="rounded me-3" 
                                         style="width: 50px; height: 50px; object-fit: cover;">
                                    <div class="flex-grow-1">
                                        <h6 class="mb-1">${item.product.name}</h6>
                                        <small class="text-muted">Số lượng: ${item.quantity}</small>
                                    </div>
                                    <div class="text-end">
                                        <fmt:formatNumber value="${item.subtotal}" pattern="#,###.###"/> VNĐ
                                    </div>
                                </div>
                            </c:forEach>

                            <hr>

                            <!-- Order Totals -->
                            <div class="d-flex justify-content-between mb-2">
                                <span>Tạm tính (${cart.totalItems} sản phẩm):</span>
                                <span><fmt:formatNumber value="${cart.totalAmount}" pattern="#,###.###"/> VNĐ</span>
                            </div>

                            <div class="d-flex justify-content-between mb-2">
                                <span>Phí giao hàng:</span>
                                <span class="text-success">Miễn phí</span>
                            </div>
                            
                            <!-- Membership Discount -->
                            <c:if test="${not empty user.membershipLevel && user.membershipLevel.levelId != 5}">
                                <div class="d-flex justify-content-between mb-2 text-success">
                                    <span>
                                        <c:choose>
                                            <c:when test="${user.membershipLevel.levelId == 1}">🥉</c:when>
                                            <c:when test="${user.membershipLevel.levelId == 2}">🥈</c:when>
                                            <c:when test="${user.membershipLevel.levelId == 3}">🥇</c:when>
                                            <c:when test="${user.membershipLevel.levelId == 4}">💎</c:when>
                                        </c:choose>
                                        Giảm giá thành viên (${user.membershipLevel.levelId == 1 ? '3%' : user.membershipLevel.levelId == 2 ? '5%' : user.membershipLevel.levelId == 3 ? '7%' : '10%'}):
                                    </span>
                                    <span>-<span id="membershipDiscountAmount"><fmt:formatNumber value="${cart.totalAmount * (user.membershipLevel.levelId == 1 ? 0.03 : user.membershipLevel.levelId == 2 ? 0.05 : user.membershipLevel.levelId == 3 ? 0.07 : 0.1)}" pattern="#,###.###"/></span> VNĐ</span>
                                </div>
                            </c:if>
                            
                            <!-- Coupon Discount -->
                            <div class="d-flex justify-content-between mb-2 text-success" id="couponDiscountRow" style="display: none !important;">
                                <span>Mã giảm giá (<span id="couponDiscountPercent">0</span>%):</span>
                                <span>-<span id="couponDiscountAmount">0</span> VNĐ</span>
                            </div>

                            <div class="d-flex justify-content-between mb-2">
                                <span>Thuế:</span>
                                <span>0 VNĐ</span>
                            </div>

                            <hr>

                            <div class="d-flex justify-content-between mb-3">
                                <strong>Tổng cộng:</strong>
                                <strong class="text-primary">
                                    <c:choose>
                                        <c:when test="${not empty user.membershipLevel && user.membershipLevel.levelId != 5}">
                                            <span id="finalTotal">
                                                <fmt:formatNumber value="${cart.totalAmount * (1 - (user.membershipLevel.levelId == 1 ? 0.03 : user.membershipLevel.levelId == 2 ? 0.05 : user.membershipLevel.levelId == 3 ? 0.07 : 0.1))}" pattern="#,###.###"/>
                                            </span> VNĐ
                                            <input type="hidden" name="originalAmount" value="${cart.totalAmount}">
                                            <input type="hidden" name="membershipDiscountPercent" value="${user.membershipLevel.levelId == 1 ? 3 : user.membershipLevel.levelId == 2 ? 5 : user.membershipLevel.levelId == 3 ? 7 : 10}">
                                            <input type="hidden" name="finalAmount" value="${cart.totalAmount * (1 - (user.membershipLevel.levelId == 1 ? 0.03 : user.membershipLevel.levelId == 2 ? 0.05 : user.membershipLevel.levelId == 3 ? 0.07 : 0.1))}">
                                        </c:when>
                                        <c:otherwise>
                                            <span id="finalTotal"><fmt:formatNumber value="${cart.totalAmount}" pattern="#,###.###"/></span> VNĐ
                                            <input type="hidden" name="originalAmount" value="${cart.totalAmount}">
                                            <input type="hidden" name="membershipDiscountPercent" value="0">
                                            <input type="hidden" name="finalAmount" value="${cart.totalAmount}">
                                        </c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>

                            <!-- Action Buttons -->
                            <button type="submit" form="checkoutForm" class="btn btn-primary w-100 mb-2">
                                <i class="fas fa-lock"></i> 
                                <c:choose>
                                    <c:when test="${checkoutType == 'selected'}">
                                        Đặt ${cart.totalItems} sản phẩm đã chọn
                                    </c:when>
                                    <c:otherwise>
                                        Đặt hàng
                                    </c:otherwise>
                                </c:choose>
                            </button>

                            <a href="/Itel/main?action=cartPage" class="btn btn-outline-secondary w-100">
                                <i class="fas fa-arrow-left"></i> Quay lại giỏ hàng
                            </a>

                            <c:if test="${checkoutType == 'selected'}">
                                <div class="mt-3">
                                    <small class="text-muted">
                                        <i class="fas fa-lightbulb"></i>
                                        Sau khi đặt hàng, các sản phẩm này sẽ được xóa khỏi giỏ hàng
                                    </small>
                                </div>
                            </c:if>
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

        <!-- Checkout JavaScript -->
        <script>
            // Show/hide card form based on payment method
            document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
                radio.addEventListener('change', function () {
                    const cardForm = document.getElementById('cardForm');
                    if (this.value === 'CASH') {
                        cardForm.style.display = 'block';
                    } else {
                        cardForm.style.display = 'none';
                    }
                });
            });

            // Format card number input
            document.getElementById('cardNumber')?.addEventListener('input', function (e) {
                let value = e.target.value.replace(/\s/g, '').replace(/[^0-9]/gi, '');
                let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
                if (value.length <= 16) {
                    e.target.value = formattedValue;
                }
            });

            // Format expiry date input
            document.getElementById('expiryDate')?.addEventListener('input', function (e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length >= 2) {
                    value = value.substring(0, 2) + '/' + value.substring(2, 4);
                }
                e.target.value = value;
            });

            // CVV input validation
            document.getElementById('cvv')?.addEventListener('input', function (e) {
                e.target.value = e.target.value.replace(/[^0-9]/g, '');
            });
            
            // Coupon selection and application
            document.querySelectorAll('.coupon-item').forEach(item => {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    // Get coupon data from data attributes
                    const couponCode = this.dataset.code;
                    const discountValue = parseFloat(this.dataset.discount);
                    const minPurchase = parseFloat(this.dataset.min || 0);
                    const discountType = this.dataset.type || 'percent'; // 'percent' or 'fixed'
                    
                    // Get UI elements
                    const couponMessageDiv = document.getElementById('couponMessage');
                    const couponDiscountRow = document.getElementById('couponDiscountRow');
                    const couponDiscountPercent = document.getElementById('couponDiscountPercent');
                    const couponDiscountAmount = document.getElementById('couponDiscountAmount');
                    const finalTotal = document.getElementById('finalTotal');
                    const selectedCouponText = document.getElementById('selectedCouponText');
                    
                    // Get original amount and membership discount
                    const originalAmount = parseFloat(document.querySelector('input[name="originalAmount"]').value);
                    const membershipDiscountPercent = parseFloat(document.querySelector('input[name="membershipDiscountPercent"]').value);
                    
                    // Clear previous message
                    couponMessageDiv.style.display = 'none';
                    
                    // If no coupon selected or clearing coupon
                    if (!couponCode) {
                        // Reset UI
                        selectedCouponText.textContent = 'Chọn mã giảm giá';
                        couponDiscountRow.style.display = 'none';
                        
                        // Calculate final amount with only membership discount
                        const membershipDiscount = (originalAmount * membershipDiscountPercent / 100).toFixed(0);
                        const finalAmount = originalAmount - parseFloat(membershipDiscount);
                        
                        // Update UI
                        finalTotal.textContent = new Intl.NumberFormat('vi-VN').format(finalAmount);
                        
                        // Update hidden fields
                        document.getElementById('couponCode').value = '';
                        document.getElementById('couponDiscountType').value = 'percent';
                        document.querySelector('input[name="finalAmount"]').value = finalAmount;
                        
                        // Remove coupon discount input if exists
                        let couponDiscountInput = document.querySelector('input[name="couponDiscountPercent"]');
                        if (couponDiscountInput) {
                            couponDiscountInput.value = '0';
                        }
                        
                        return;
                    }
                    
                    // Check minimum purchase requirement
                    if (originalAmount < minPurchase) {
                        couponMessageDiv.innerHTML = '<div class="alert alert-warning">Đơn hàng tối thiểu ' + new Intl.NumberFormat('vi-VN').format(minPurchase) + 'đ để sử dụng mã này</div>';
                        couponMessageDiv.style.display = 'block';
                        return;
                    }
                    
                    // Calculate discount amount
                    let couponDiscount;
                    if (discountType === 'fixed') {
                        couponDiscount = discountValue;
                        couponDiscountPercent.textContent = new Intl.NumberFormat('vi-VN').format(discountValue) + 'đ';
                    } else {
                        couponDiscount = (originalAmount * discountValue / 100).toFixed(0);
                        couponDiscountPercent.textContent = discountValue + '%';
                    }
                    
                    const membershipDiscount = (originalAmount * membershipDiscountPercent / 100).toFixed(0);
                    const totalDiscount = parseFloat(couponDiscount) + parseFloat(membershipDiscount);
                    const finalAmount = originalAmount - totalDiscount;
                    
                    // Update UI
                    selectedCouponText.textContent = couponCode;
                    couponDiscountAmount.textContent = new Intl.NumberFormat('vi-VN').format(couponDiscount);
                    finalTotal.textContent = new Intl.NumberFormat('vi-VN').format(finalAmount);
                    couponDiscountRow.style.display = 'flex !important';
                    couponDiscountRow.setAttribute('style', 'display: flex !important');
                    
                    // Update hidden fields
                    document.getElementById('couponCode').value = couponCode;
                    document.getElementById('couponDiscountType').value = discountType;
                    document.querySelector('input[name="finalAmount"]').value = finalAmount;
                    
                    // Add hidden field for coupon discount
                    let couponDiscountInput = document.querySelector('input[name="couponDiscountPercent"]');
                    if (!couponDiscountInput) {
                        couponDiscountInput = document.createElement('input');
                        couponDiscountInput.type = 'hidden';
                        couponDiscountInput.name = 'couponDiscountPercent';
                        document.getElementById('checkoutForm').appendChild(couponDiscountInput);
                    }
                    
                    if (discountType === 'fixed') {
                        couponDiscountInput.value = discountValue;
                    } else {
                        couponDiscountInput.value = discountValue;
                    }
                    
                    // Show success message
                    couponMessageDiv.innerHTML = '<div class="alert alert-success">Mã giảm giá đã được áp dụng thành công!</div>';
                    couponMessageDiv.style.display = 'block';
                });
            });

            // Form validation before submit
            document.getElementById('checkoutForm').addEventListener('submit', function (e) {
                const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

                if (paymentMethod === 'CASH') {
                    const cardNumber = document.getElementById('cardNumber').value;
                    const expiryDate = document.getElementById('expiryDate').value;
                    const cvv = document.getElementById('cvv').value;

                    if (!cardNumber || cardNumber.replace(/\s/g, '').length < 16) {
                        e.preventDefault();
                        alert('Please enter a valid card number');
                        return;
                    }

                    if (!expiryDate || expiryDate.length < 5) {
                        e.preventDefault();
                        alert('Please enter a valid expiry date');
                        return;
                    }

                    if (!cvv || cvv.length < 3) {
                        e.preventDefault();
                        alert('Please enter a valid CVV');
                        return;
                    }
                }

                // Show loading state
                const submitBtn = document.querySelector('button[type="submit"]');
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                submitBtn.disabled = true;
            });
        </script>
        <div id="bankTransferInfo" class="alert alert-success mt-3" style="display:none;">
            <strong>Thông tin chuyển khoản:</strong><br>
            Ngân hàng: <b>Vietcombank (VCB)</b><br>
            Số tài khoản: <b>0123456789</b><br>
            Chủ tài khoản: <b>NGUYEN VAN A</b><br>
            <span style="color:red;">Nội dung chuyển khoản: <b>DH${user.userId}${System.currentTimeMillis()}</b> hoặc số điện thoại của bạn</span>
            <br><span class="text-muted">Vui lòng chuyển khoản đúng nội dung để được xác nhận đơn hàng nhanh nhất.</span>
        </div>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const bankRadio = document.getElementById('banking');
                const bankInfo = document.getElementById('bankTransferInfo');
                if (bankRadio && bankInfo) {
                    bankRadio.addEventListener('change', function () {
                        if (this.checked) {
                            bankInfo.style.display = 'block';
                        }
                    });
                }
                // Ẩn khi chọn phương thức khác
                document.querySelectorAll('input[name="paymentMethod"]').forEach(function (radio) {
                    if (radio.value !== 'BANKING') {
                        radio.addEventListener('change', function () {
                            bankInfo.style.display = 'none';
                        });
                    }
                });
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
    }

    .checkout-steps {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-bottom: 2rem;
        padding: 1rem;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .step {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 1rem;
        margin: 0 1rem;
        position: relative;
        color: #6c757d;
    }

    .step i {
        font-size: 1.5rem;
        margin-bottom: 0.5rem;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 2px solid #dee2e6;
        background: white;
    }

    .step.completed i {
        background: #28a745;
        color: white;
        border-color: #28a745;
    }

    .step.active i {
        background: #007bff;
        color: white;
        border-color: #007bff;
    }

    .step.completed,
    .step.active {
        color: #212529;
    }

    .step:not(:last-child):after {
        content: '';
        position: absolute;
        top: 20px;
        right: -50%;
        width: 100%;
        height: 2px;
        background: #dee2e6;
        z-index: -1;
    }

    .step.completed:not(:last-child):after {
        background: #28a745;
    }

    .payment-option {
        border: 2px solid #e9ecef;
        border-radius: 8px;
        padding: 1rem;
        transition: all 0.3s ease;
    }

    .payment-option:hover {
        border-color: #007bff;
        background-color: #f8f9ff;
    }

    .payment-option input:checked + .payment-label {
        color: #007bff;
    }

    .payment-option:has(input:checked) {
        border-color: #007bff;
        background-color: #f8f9ff;
    }

    .payment-label {
        width: 100%;
        margin: 0;
        cursor: pointer;
    }

    .payment-content {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .payment-content i {
        font-size: 1.5rem;
        width: 30px;
    }

    .card {
        box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        border: 1px solid rgba(0, 0, 0, 0.125);
    }

    @media (max-width: 768px) {
        .checkout-steps {
            flex-direction: column;
        }

        .step {
            margin: 0.5rem 0;
        }

        .step:not(:last-child):after {
            display: none;
        }
    }
</style>
