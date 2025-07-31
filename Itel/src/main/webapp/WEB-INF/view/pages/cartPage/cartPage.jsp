<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
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
<form id="checkoutForm" method="POST" action="/Itel/checkoutPage">
    <div class="content container">
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-shopping-cart"></i> Giỏ hàng của bạn</h2>
                <hr>
            </div>
        </div>

        <c:choose>
            <c:when test="${cart.isEmpty()}">
                <div class="row">
                    <div class="col-12 text-center py-5">
                        <i class="fas fa-shopping-cart fa-5x text-muted mb-4"></i>
                        <h3 class="text-muted">Giỏ hàng của bạn đang trống</h3>
                        <p class="text-muted">Hãy thêm sản phẩm để bắt đầu mua sắm!</p>
                        <a href="<%= ProjectPaths.HREF_TO_HOMEPAGE %>" class="btn btn-primary btn-lg">
                            <i class="fas fa-home"></i> Về trang chủ
                        </a>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="row">
                    <!-- Sản phẩm trong giỏ -->
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <div class="form-check me-3">
                                    <input class="form-check-input" type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                                    <label class="form-check-label fw-bold" for="selectAll">Chọn tất cả</label>
                                </div>
                                <span class="text-muted">(<span id="selectedCount">0</span>/<span id="totalCount">0</span> sản phẩm được chọn)</span>
                                <button class="btn btn-outline-danger btn-sm" onclick="removeSelectedItems()" id="removeSelectedBtn" type="button" disabled>
                                    <i class="fas fa-trash"></i> Xóa đã chọn
                                </button>
                            </div>
                            <div class="card-body p-0">
                                <c:forEach var="item" items="${cart.items}">
                                    <div class="cart-item border-bottom p-3" data-product-id="${item.product.productId}">
                                        <div class="row align-items-center">
                                            <div class="col-md-1">
                                                <input class="form-check-input item-checkbox" type="checkbox"
                                                       data-product-id="${item.product.productId}"
                                                       data-price="${item.product.price}"
                                                       data-quantity="${item.quantity}"
                                                       data-subtotal="${item.subtotal}"
                                                       onchange="updateSelection()">
                                            </div>
                                            <div class="col-md-2">
                                                <img src="${item.product.imageUrl}" class="img-fluid rounded" alt="${item.product.name}" style="height: 80px;">
                                            </div>
                                            <div class="col-md-3">
                                                <h6>${item.product.name}</h6>
                                                <p class="text-muted">
                                                    <fmt:formatNumber value="${item.product.price}" pattern="#,###.###"/> VNĐ
                                                </p>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="input-group" style="width: 120px;">
                                                    <button class="btn btn-outline-secondary btn-sm" type="button" onclick="updateQuantity(${item.product.productId}, ${item.quantity - 1})">-</button>
                                                    <input type="number" class="form-control form-control-sm text-center" value="${item.quantity}" min="1" data-stock="${item.product.stockQuantity}" onchange="updateQuantity(${item.product.productId}, this.value)">
                                                    <button class="btn btn-outline-secondary btn-sm" type="button" onclick="updateQuantity(${item.product.productId}, ${item.quantity + 1})">+</button>
                                                </div>
                                            </div>
                                            <div class="col-md-2 text-end">
                                                <fmt:formatNumber value="${item.subtotal}" pattern="#,###.###"/> VNĐ
                                            </div>
                                            <div class="col-md-1 text-end">
                                                <button class="btn btn-link text-danger p-0" onclick="removeItem(${item.product.productId})" type="button">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        <div class="mt-3">
                            <a href="<%= ProjectPaths.HREF_TO_HOMEPAGE %>" class="btn btn-outline-primary">
                                <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                            </a>
                            <button class="btn btn-outline-danger ms-2" onclick="clearCart()" type="button">
                                <i class="fas fa-trash"></i> Xóa toàn bộ
                            </button>
                        </div>
                    </div>

                    <!-- Tổng kết -->
                    <div class="col-lg-4">
                        <div class="card">
                            <div class="card-header"><h5>Tổng kết đơn hàng</h5></div>
                            <div class="card-body">
                                <div class="alert alert-info">
                                    <small><i class="fas fa-info-circle"></i> Chọn sản phẩm để thanh toán</small>
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
                                    <strong id="selectedTotal" class="text-primary">0 VNĐ</strong>
                                </div>

                                <c:choose>
                                    <c:when test="${sessionScope.loggedUser != null}">
                                        <button class="btn btn-primary btn-lg w-100" id="checkoutBtn" type="button" onclick="proceedToCheckout()" disabled>
                                            <i class="fas fa-credit-card"></i> Thanh toán sản phẩm đã chọn
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info text-center">
                                            <i class="fas fa-info-circle"></i> Vui lòng đăng nhập để thanh toán
                                        </div>
                                        <a href="<%= ProjectPaths.HREF_TO_LOGINPAGE %>" class="btn btn-outline-primary w-100">Đăng nhập</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="card mt-3">
                            <div class="card-header"><h6 class="text-muted">Tổng giỏ hàng</h6></div>
                            <div class="card-body d-flex justify-content-between">
                                <small class="text-muted">Tổng ${cart.totalItems} sản phẩm:</small>
                                <small class="text-muted">
                                    <fmt:formatNumber value="${cart.totalAmount}" pattern="#,###.###"/> VNĐ
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</form>
        <!-- Footer -->
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
                                                        const totalCount = document.getElementById('totalCount');
                                                        const removeSelectedBtn = document.getElementById('removeSelectedBtn');
                                                        const checkoutBtn = document.getElementById('checkoutBtn');

                                                        // Đếm tổng quantity được chọn và tổng quantity trong giỏ
                                                        selectedItems = [];
                                                        let totalSelectedQty = 0;
                                                        let totalQty = 0;
                                                        let totalAmount = 0;
                                                        itemCheckboxes.forEach(checkbox => {
                                                            const quantity = parseInt(checkbox.dataset.quantity);
                                                            totalQty += quantity;
                                                            if (checkbox.checked) {
                                                                const productId = parseInt(checkbox.dataset.productId);
                                                                const price = parseFloat(checkbox.dataset.price);
                                                                const subtotal = parseFloat(checkbox.dataset.subtotal);
                                                                selectedItems.push({
                                                                    productId: productId,
                                                                    quantity: quantity,
                                                                    price: price,
                                                                    subtotal: subtotal
                                                                });
                                                                totalSelectedQty += quantity;
                                                                totalAmount += subtotal;
                                                            }
                                                        });

                                                        // Update UI
                                                        selectedCount.textContent = totalSelectedQty;
                                                        totalCount.textContent = totalQty;
                                                        document.getElementById('selectedItemCount').textContent = totalSelectedQty + ' sản phẩm';
                                                        document.getElementById('selectedSubtotal').textContent = formatCurrency(totalAmount);
                                                        document.getElementById('selectedTotal').textContent = formatCurrency(totalAmount);

                                                        // Update buttons
                                                        removeSelectedBtn.disabled = totalSelectedQty === 0;
                                                        if (checkoutBtn) {
                                                            checkoutBtn.disabled = totalSelectedQty === 0;
                                                        }

                                                        // Update select all checkbox
                                                        selectAllCheckbox.checked = totalSelectedQty === totalQty && totalSelectedQty > 0;
                                                        selectAllCheckbox.indeterminate = totalSelectedQty > 0 && totalSelectedQty < totalQty;
                                                    }

                                                    function formatCurrency(amount) {
                                                        return new Intl.NumberFormat('vi-VN').format(amount) + ' VNĐ';
                                                    }

                                                    function proceedToCheckout() {
                                                        if (selectedItems.length === 0) {
                                                            alert('Vui lòng chọn ít nhất 1 sản phẩm để thanh toán');
                                                            return;
                                                        }

                                                        const form = document.getElementById('checkoutForm');
                                                        if (!form) {
                                                            alert('Không tìm thấy form để thanh toán');
                                                            return;
                                                        }

                                                        // Xóa các input hidden cũ (nếu có)
                                                        form.querySelectorAll('input[name^="selectedItems"]').forEach(el => el.remove());

                                                        // Thêm input ẩn vào form
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
                                                                        location.reload(); // Reload để cập nhật tổng
                                                                    } else {
                                                                        alert(data.message); // Hiển thị thông báo lỗi từ server
                                                                        location.reload();

                                                                        const input = document.querySelector(`.cart-item[data-product-id="${productId}"] input[type="number"]`);
                                                                        let stock = parseInt(input.dataset.stock) || 1; // Fallback từ data-stock

                                                                        // Parse stock từ message (ví dụ: lấy 45 từ "Số lượng vượt quá tồn kho (45)!")
                                                                        const match = data.message.match(/\(\d+\)/);
                                                                        if (match) {
                                                                            stock = parseInt(match[0].replace(/\(|\)/g, '')); // Lấy số từ ngoặc đơn
                                                                        }

                                                                        if (input) {
                                                                            input.value = stock; // Nhảy về stock sau khi nhấn OK
                                                                        }
                                                                        updateSelection(); // Cập nhật tổng tiền sau khi thay đổi
                                                                    }
                                                                })
                                                                .catch(error => {
                                                                    console.error('Error:', error);
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

        <!-- Chatbox AI -->
        <jsp:include page="/WEB-INF/view/components/chatbox.jsp" />
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
