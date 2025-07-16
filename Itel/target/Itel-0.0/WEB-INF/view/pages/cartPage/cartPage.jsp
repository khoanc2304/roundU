<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Shopping Cart - Itel Shop</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>

        <div class="content container">
            <div class="row">
                <div class="col-12">
                    <h2><i class="fas fa-shopping-cart"></i> Giỏ hàng của bạn</h2>
                    <hr>
                </div>
            </div>

            <c:choose>
                <c:when test="${cart.isEmpty()}">
                    <!-- Empty Cart -->
                    <div class="row">
                        <div class="col-12 text-center py-5">
                            <i class="fas fa-shopping-cart fa-5x text-muted mb-4"></i>
                            <h3 class="text-muted">Giỏ hàng của bạn đang trống</h3>
                            <p class="text-muted">Hãy thêm sản phẩm để bắt đầu mua sắm!</p>
                            <a href="/Itel/main?action=homePage" class="btn btn-primary btn-lg">
                                <i class="fas fa-home"></i> Về trang chủ
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Cart Items -->
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center">
                                        <div class="form-check me-3">
                                            <input class="form-check-input" type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                                            <label class="form-check-label fw-bold" for="selectAll">
                                                Chọn tất cả
                                            </label>
                                        </div>
                                        <span class="text-muted">(<span id="selectedCount">0</span>/${cart.totalItems} sản phẩm được chọn)</span>
                                    </div>
                                    <button class="btn btn-outline-danger btn-sm" onclick="removeSelectedItems()" id="removeSelectedBtn" disabled>
                                        <i class="fas fa-trash"></i> Xóa đã chọn
                                    </button>
                                </div>
                                <div class="card-body p-0">
                                    <c:forEach var="item" items="${cart.items}">
                                        <div class="cart-item border-bottom p-3" data-product-id="${item.product.productId}">
                                            <div class="row align-items-center">
                                                <!-- Checkbox Column -->
                                                <div class="col-md-1">
                                                    <div class="form-check">
                                                        <input class="form-check-input item-checkbox" 
                                                               type="checkbox" 
                                                               data-product-id="${item.product.productId}"
                                                               data-price="${item.product.price}"
                                                               data-quantity="${item.quantity}"
                                                               data-subtotal="${item.subtotal}"
                                                               onchange="updateSelection()">
                                                    </div>
                                                </div>

                                                <!-- Product Image -->
                                                <div class="col-md-2">
                                                    <img src="${item.product.imageUrl}" class="img-fluid rounded" alt="${item.product.name}" style="height: 80px; object-fit: cover;">
                                                </div>

                                                <!-- Product Info -->
                                                <div class="col-md-3">
                                                    <h6 class="mb-1">${item.product.name}</h6>
                                                    <p class="text-muted mb-0">
                                                        <fmt:formatNumber value="${item.product.price}" pattern="#,###.###"/> VNĐ
                                                    </p>
                                                </div>

                                                <!-- Quantity Controls -->
                                                <div class="col-md-3">
                                                    <div class="input-group" style="width: 120px;">
                                                        <button class="btn btn-outline-secondary btn-sm qty-btn" type="button" onclick="updateQuantity(${item.product.productId}, ${item.quantity - 1})">
                                                            <i class="fas fa-minus"></i>
                                                        </button>
                                                        <input type="number" class="form-control form-control-sm text-center" value="${item.quantity}" min="1" onchange="updateQuantity(${item.product.productId}, this.value)">
                                                        <button class="btn btn-outline-secondary btn-sm qty-btn" type="button" onclick="updateQuantity(${item.product.productId}, ${item.quantity + 1})">
                                                            <i class="fas fa-plus"></i>
                                                        </button>
                                                    </div>
                                                </div>

                                                <!-- Subtotal -->
                                                <div class="col-md-2 text-end">
                                                    <h6 class="mb-1">
                                                        <fmt:formatNumber value="${item.subtotal}" pattern="#,###.###"/> VNĐ
                                                    </h6>
                                                </div>

                                                <!-- Remove Button -->
                                                <div class="col-md-1 text-end">
                                                    <button class="btn btn-link text-danger p-0" onclick="removeItem(${item.product.productId})" title="Remove item">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Cart Actions -->
                            <div class="mt-3">
                                <a href="/Itel/main?action=homePage" class="btn btn-outline-primary">
                                    <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                                </a>
                                <button class="btn btn-outline-danger ms-2" onclick="clearCart()">
                                    <i class="fas fa-trash"></i> Xóa toàn bộ
                                </button>
                            </div>
                        </div>

                        <!-- Cart Summary -->
                        <div class="col-lg-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Tổng kết đơn hàng</h5>
                                </div>
                                <div class="card-body">
                                    <!-- Selected Items Summary -->
                                    <div class="alert alert-info">
                                        <small>
                                            <i class="fas fa-info-circle"></i>
                                            Chọn sản phẩm để thanh toán
                                        </small>
                                    </div>

                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Sản phẩm được chọn:</span>
                                        <span id="selectedItemCount">0 sản phẩm</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Tạm tính:</span>
                                        <span id="selectedSubtotal">0 VNĐ</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Phí giao hàng:</span>
                                        <span class="text-success">Miễn phí</span>
                                    </div>
                                    <hr>
                                    <div class="d-flex justify-content-between mb-3">
                                        <strong>Tổng cộng:</strong>
                                        <strong class="text-primary" id="selectedTotal">0 VNĐ</strong>
                                    </div>

                                    <c:choose>
                                        <c:when test="${sessionScope.loggedUser != null}">
                                            <button class="btn btn-primary btn-lg w-100" id="checkoutBtn" onclick="proceedToCheckout()" disabled>
                                                <i class="fas fa-credit-card"></i> Thanh toán sản phẩm đã chọn
                                            </button>
                                            <small class="text-muted mt-2 d-block text-center">Vui lòng chọn ít nhất 1 sản phẩm</small>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-info">
                                                <i class="fas fa-info-circle"></i> Vui lòng đăng nhập để thanh toán
                                            </div>
                                            <a href="/Itel/main?action=loginPage" class="btn btn-outline-primary w-100 mb-2">
                                                <i class="fas fa-sign-in-alt"></i> Đăng nhập
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- All Items Summary (for reference) -->
                            <div class="card mt-3">
                                <div class="card-header">
                                    <h6 class="mb-0 text-muted">Tổng giỏ hàng (tham khảo)</h6>
                                </div>
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <small class="text-muted">Tổng ${cart.totalItems} sản phẩm:</small>
                                        <small class="text-muted">
                                            <fmt:formatNumber value="${cart.totalAmount}" pattern="#,###.###"/> VNĐ
                                        </small>
                                    </div>
                                </div>
                            </div>

                            <!-- Payment Methods -->
                            <div class="card mt-3">
                                <div class="card-header">
                                    <h6 class="mb-0">Chúng tôi chấp nhận</h6>
                                </div>
                                <div class="card-body">
                                    <div class="d-flex justify-content-around">
                                        <i class="fas fa-money-bill-wave fa-2x text-success" title="Cash on Delivery"></i>
                                        <i class="fas fa-university fa-2x text-primary" title="Bank Transfer"></i>
                                        <i class="fas fa-credit-card fa-2x text-info" title="Credit Card"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!--Footer-->                                 
        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Cart JavaScript -->
        <script>
                                                let selectedItems = [];

                                                function toggleSelectAll() {
                                                    const selectAllCheckbox = document.getElementById('selectAll');
                                                    const itemCheckboxes = document.querySelectorAll('.item-checkbox');

                                                    itemCheckboxes.forEach(checkbox => {
                                                        checkbox.checked = selectAllCheckbox.checked;
                                                    });

                                                    updateSelection();
                                                }

                                                function updateSelection() {
                                                    const itemCheckboxes = document.querySelectorAll('.item-checkbox');
                                                    const selectAllCheckbox = document.getElementById('selectAll');
                                                    const selectedCount = document.getElementById('selectedCount');
                                                    const removeSelectedBtn = document.getElementById('removeSelectedBtn');
                                                    const checkoutBtn = document.getElementById('checkoutBtn');

                                                    // Count selected items
                                                    selectedItems = [];
                                                    let totalSelected = 0;
                                                    let totalAmount = 0;

                                                    itemCheckboxes.forEach(checkbox => {
                                                        if (checkbox.checked) {
                                                            const productId = parseInt(checkbox.dataset.productId);
                                                            const quantity = parseInt(checkbox.dataset.quantity);
                                                            const price = parseFloat(checkbox.dataset.price);
                                                            const subtotal = parseFloat(checkbox.dataset.subtotal);

                                                            selectedItems.push({
                                                                productId: productId,
                                                                quantity: quantity,
                                                                price: price,
                                                                subtotal: subtotal
                                                            });

                                                            totalSelected++;
                                                            totalAmount += subtotal;
                                                        }
                                                    });

                                                    // Update UI
                                                    selectedCount.textContent = totalSelected;
                                                    document.getElementById('selectedItemCount').textContent = totalSelected + ' sản phẩm';
                                                    document.getElementById('selectedSubtotal').textContent = formatCurrency(totalAmount);
                                                    document.getElementById('selectedTotal').textContent = formatCurrency(totalAmount);

                                                    // Update buttons
                                                    removeSelectedBtn.disabled = totalSelected === 0;
                                                    if (checkoutBtn) {
                                                        checkoutBtn.disabled = totalSelected === 0;
                                                    }

                                                    // Update select all checkbox
                                                    selectAllCheckbox.checked = totalSelected === itemCheckboxes.length && totalSelected > 0;
                                                    selectAllCheckbox.indeterminate = totalSelected > 0 && totalSelected < itemCheckboxes.length;
                                                }

                                                function formatCurrency(amount) {
                                                    return new Intl.NumberFormat('vi-VN').format(amount) + ' VNĐ';
                                                }

                                                function proceedToCheckout() {
                                                    if (selectedItems.length === 0) {
                                                        alert('Vui lòng chọn ít nhất 1 sản phẩm để thanh toán');
                                                        return;
                                                    }

                                                    // Create form to submit selected items
                                                    const form = document.createElement('form');
                                                    form.method = 'POST';
                                                    form.action = '/Itel/main?action=checkoutPage';

                                                    // Add selected items as form data
                                                    selectedItems.forEach((item, index) => {
                                                        const productIdInput = document.createElement('input');
                                                        productIdInput.type = 'hidden';
                                                        productIdInput.name = 'selectedItems[' + index + '].productId';
                                                        productIdInput.value = item.productId;
                                                        form.appendChild(productIdInput);

                                                        const quantityInput = document.createElement('input');
                                                        quantityInput.type = 'hidden';
                                                        quantityInput.name = 'selectedItems[' + index + '].quantity';
                                                        quantityInput.value = item.quantity;
                                                        form.appendChild(quantityInput);
                                                    });

                                                    document.body.appendChild(form);
                                                    form.submit();
                                                }

                                                function removeSelectedItems() {
                                                    if (selectedItems.length === 0) {
                                                        alert('Vui lòng chọn sản phẩm để xóa');
                                                        return;
                                                    }

                                                    if (confirm('Xóa ' + selectedItems.length + ' sản phẩm đã chọn khỏi giỏ hàng?')) {
                                                        const promises = selectedItems.map(item => {
                                                            return fetch('/Itel/cart/remove', {
                                                                method: 'POST',
                                                                headers: {
                                                                    'Content-Type': 'application/x-www-form-urlencoded',
                                                                },
                                                                body: 'productId=' + item.productId
                                                            });
                                                        });

                                                        Promise.all(promises)
                                                                .then(() => {
                                                                    location.reload();
                                                                })
                                                                .catch(error => {
                                                                    console.error('Error:', error);
                                                                    alert('Có lỗi xảy ra khi xóa sản phẩm');
                                                                });
                                                    }
                                                }

                                                function updateQuantity(productId, quantity) {
                                                    if (quantity < 1) {
                                                        removeItem(productId);
                                                        return;
                                                    }

                                                    fetch('/Itel/cart/update', {
                                                        method: 'POST',
                                                        headers: {
                                                            'Content-Type': 'application/x-www-form-urlencoded',
                                                        },
                                                        body: 'productId=' + productId + '&quantity=' + quantity
                                                    })
                                                            .then(response => response.json())
                                                            .then(data => {
                                                                if (data.success) {
                                                                    location.reload(); // Reload to update totals
                                                                } else {
                                                                    alert('Error updating cart');
                                                                }
                                                            })
                                                            .catch(error => {
                                                                console.error('Error:', error);
                                                                alert('Error updating cart');
                                                            });
                                                }

                                                function removeItem(productId) {
                                                    if (confirm('Remove this item from cart?')) {
                                                        fetch('/Itel/cart/remove', {
                                                            method: 'POST',
                                                            headers: {
                                                                'Content-Type': 'application/x-www-form-urlencoded',
                                                            },
                                                            body: 'productId=' + productId
                                                        })
                                                                .then(response => response.json())
                                                                .then(data => {
                                                                    if (data.success) {
                                                                        location.reload();
                                                                    } else {
                                                                        alert('Error removing item');
                                                                    }
                                                                })
                                                                .catch(error => {
                                                                    console.error('Error:', error);
                                                                    alert('Error removing item');
                                                                });
                                                    }
                                                }

                                                function clearCart() {
                                                    if (confirm('Clear all items from cart?')) {
                                                        fetch('/Itel/cart/clear', {
                                                            method: 'POST'
                                                        })
                                                                .then(response => response.json())
                                                                .then(data => {
                                                                    if (data.success) {
                                                                        location.reload();
                                                                    } else {
                                                                        alert('Error clearing cart');
                                                                    }
                                                                })
                                                                .catch(error => {
                                                                    console.error('Error:', error);
                                                                    alert('Error clearing cart');
                                                                });
                                                    }
                                                }

                                                // Initialize on page load
                                                document.addEventListener('DOMContentLoaded', function () {
                                                    updateSelection();
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
        padding-top: 50px;
    }

    .cart-item:hover {
        background-color: #f8f9fa;
    }

    .cart-item.selected {
        background-color: #e3f2fd;
        border-left: 4px solid #2196f3;
    }

    .qty-btn {
        border-radius: 0;
    }

    .card {
        box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        border: 1px solid rgba(0, 0, 0, 0.125);
    }

    .form-check-input:checked {
        background-color: #2196f3;
        border-color: #2196f3;
    }

    .form-check-input:indeterminate {
        background-color: #6c757d;
        border-color: #6c757d;
    }
</style>
