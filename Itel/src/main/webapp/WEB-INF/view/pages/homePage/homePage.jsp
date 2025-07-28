<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ page import="com.tourismapp.model.Users" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Home Page</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" crossorigin="anonymous"/>

        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    </head>

    <body>
        <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>
        
        <div class="banner-wrapper">
            <div id="bannerCarousel" class="carousel slide banner-container" data-bs-ride="carousel" data-bs-interval="3000">
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="${pageContext.request.contextPath}/assets/images/banner/b1.png" alt="Banner 1" class="d-block w-100">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/assets/images/banner/b2.png" alt="Banner 2" class="d-block w-100">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/assets/images/banner/b3.png" alt="Banner 3" class="d-block w-100">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/assets/images/banner/b4.png" alt="Banner 4" class="d-block w-100">
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#bannerCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#bannerCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </div>

        <div class="container my-5">
            <div class="layout-3col d-flex justify-content-center gap-4">

                <div class="left-col d-flex flex-column gap-3">
                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&c=Phone" class="category-link">
                        <div class="category-box">
                            <h4>Điện thoại</h4>
                            <img src="${sessionScope.PhoneImageUrl}" alt="Phone" class="category-image">
                        </div>
                    </a>
                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&c=Mouse" class="category-link">
                        <div class="category-box">
                            <h4>Chuột</h4>
                            <img src="${sessionScope.MouseImageUrl}" alt="Mouse" class="category-image">
                        </div>
                    </a>    
                </div>

                <div class="left-col d-flex flex-column gap-3">
                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&c=Headphones" class="category-link">
                        <div class="category-box">
                            <h4>Tai nghe</h4>
                            <img src="${sessionScope.HeadphonesImageUrl}" alt="Headphones" class="category-image">
                        </div>
                    </a>
                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&c=Keyboard" class="category-link">
                        <div class="category-box">
                            <h4>Bàn phím</h4>
                            <img src="${sessionScope.KeyboardImageUrl}" alt="Keyboard" class="category-image">
                        </div>
                    </a>
                </div>        

                <div class="middle-col d-flex align-items-center justify-content-center">
                    <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&c=Laptop" class="category-link w-100">
                        <div class="category-box-mid">
                            <h4>Laptop</h4>
                            <img src="${sessionScope.LaptopImageUrl}" alt="Laptop" class="category-image mouse-image">
                        </div>
                    </a>
                </div>

                <div class="right-col d-flex flex-column gap-3">
                    <a href="#" class="category-link">
                        <div class="category-box">
                            <h4>Tivi</h4>
                            <img src="${sessionScope.TelevisionImageUrl}" alt="Tivi" class="category-image">
                        </div>
                    </a>
                    <a href="#" class="category-link">
                        <div class="category-box">
                            <h4>Máy tính bảng</h4>
                            <img src="${sessionScope.TabletImageUrl}" alt="Tablet" class="category-image">
                        </div>
                    </a>
                </div>

                <div class="right-col d-flex flex-column gap-3">
                    <a href="#" class="category-link">
                        <div class="category-box">
                            <h4>Máy tính bàn - PC</h4>
                            <img src="${sessionScope.DesktopPCImageUrl}" alt="Desktop-PC" class="category-image">
                        </div>
                    </a>
                    <a href="#" class="category-link">
                        <div class="category-box">
                            <h4>Linh kiện</h4>
                            <img src="${sessionScope.AccessoriesImageUrl}" alt="Accessories" class="category-image">
                        </div>
                    </a>
                </div>        
            </div>

            <!-- Sản phẩm đã xem -->
            <div class="container my-3">
                <c:if test="${not empty viewedProducts}">
                                        <div class="card mb-4">
                        <div class="card-header bg-light fw-bold fs-5 d-flex justify-content-between align-items-center">
                            <span>Sản phẩm đã xem</span>
                            <div class="viewed-products-nav">
                                <button type="button" class="btn btn-sm btn-outline-secondary me-2 viewed-nav-prev" disabled onclick="event.preventDefault();">
                                    <i class="fas fa-chevron-left"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-secondary viewed-nav-next" onclick="event.preventDefault();">
                                    <i class="fas fa-chevron-right"></i>
                                </button>
                            </div>
                        </div>
                        <div class="card-body pt-3 pb-2">
                            <div class="viewed-products-container position-relative">
                                <!-- Nút điều hướng trong container -->
                                <button type="button" class="nav-arrow nav-prev" onclick="event.preventDefault(); document.querySelector('.viewed-nav-prev').click();">
                                    <i class="fas fa-chevron-left"></i>
                                </button>
                                <button type="button" class="nav-arrow nav-next" onclick="event.preventDefault(); document.querySelector('.viewed-nav-next').click();">
                                    <i class="fas fa-chevron-right"></i>
                                </button>
                                <div class="viewed-products-wrapper d-flex">
                                    <c:forEach var="vp" items="${viewedProducts}" varStatus="status">
                                        <div class="viewed-product-item">
                                            <div class="card viewed-product-card position-relative">
                                                <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&id=${vp.productId}" class="text-decoration-none">
                                                    <img src="${vp.imageUrl}" class="card-img-top" alt="${vp.name}">
                                                    <div class="card-body">
                                                        <h6 class="card-title mb-1 text-truncate" title="${vp.name}">${vp.name}</h6>
                                                        <div class="text-danger fw-bold">
                                                            <fmt:formatNumber value="${vp.price}" type="number" pattern="#,#00" currencySymbol="" groupingUsed="true" /> VNĐ
                                                        </div>
                                                    </div>
                                                </a>
                                                <a href="#" class="remove-viewed-product position-absolute top-0 end-0 m-2" 
                                                   onclick="event.preventDefault(); removeViewedProduct(${vp.productId});">
                                                    <i class="fas fa-times-circle"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>            

            <div class="row mt-5">
                <div class="col-12">
                    <div class="content" data-aos="fade-left">
                        <div class="row">
                            <div class="product-grid">
                                <c:forEach var="product" items="${activeProducts}" varStatus="status">
                                    <div class="product-card card h-100 mb-4" data-aos="zoom-in">
                                        <div class="image-container">
                                            <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&id=${product.productId}">
                                                <img src="${product.imageUrl}" class="product-img card-img-top" alt="${product.name}">
                                            </a>
                                        </div>
                                        <div class="card-body text-center">
                                            <h5 class="product-name card-title">${product.name}</h5>

                                            <!-- Product specs giả lập -->
                                            <div class="product-specs mb-3">
                                                <c:choose>
                                                    <c:when test="${status.index % 6 == 0}">
                                                        <span class="spec-item">i5 12400F</span>
                                                        <span class="spec-item">RTX 3060</span>
                                                        <span class="spec-item">B760</span>
                                                        <span class="spec-item">16GB</span>
                                                        <span class="spec-item">500GB</span>
                                                    </c:when>
                                                    <c:when test="${status.index % 6 == 1}">
                                                        <span class="spec-item">i7 13700F</span>
                                                        <span class="spec-item">RTX 4070</span>
                                                        <span class="spec-item">B760</span>
                                                        <span class="spec-item">32GB</span>
                                                        <span class="spec-item">1TB</span>
                                                    </c:when>
                                                    <c:when test="${status.index % 6 == 2}">
                                                        <span class="spec-item">Ryzen 5 5600X</span>
                                                        <span class="spec-item">RTX 3070</span>
                                                        <span class="spec-item">B450</span>
                                                        <span class="spec-item">16GB</span>
                                                        <span class="spec-item">500GB</span>
                                                    </c:when>
                                                    <c:when test="${status.index % 6 == 3}">
                                                        <span class="spec-item">i9 14900F</span>
                                                        <span class="spec-item">RTX 4080</span>
                                                        <span class="spec-item">Z790</span>
                                                        <span class="spec-item">32GB</span>
                                                        <span class="spec-item">1TB</span>
                                                    </c:when>
                                                    <c:when test="${status.index % 6 == 4}">
                                                        <span class="spec-item">Ryzen 7 7700X</span>
                                                        <span class="spec-item">RTX 4060 Ti</span>
                                                        <span class="spec-item">B650</span>
                                                        <span class="spec-item">16GB</span>
                                                        <span class="spec-item">1TB</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="spec-item">i5 13400F</span>
                                                        <span class="spec-item">RTX 4050</span>
                                                        <span class="spec-item">B760</span>
                                                        <span class="spec-item">16GB</span>
                                                        <span class="spec-item">500GB</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <p class="card-text text-danger fw-bold">
                                                <fmt:formatNumber value="${product.price}" type="number" pattern="#,###" currencySymbol="" groupingUsed="true" /> VNĐ
                                            </p>

                                            <!-- Rating giả lập -->
                                            <div class="rating-section d-flex justify-content-center align-items-center gap-2 mb-3">
                                                <div class="stars">
                                                    <c:choose>
                                                        <c:when test="${status.index % 5 == 0}">
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                        </c:when>
                                                        <c:when test="${status.index % 5 == 1}">
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star-half-alt text-warning"></i>
                                                        </c:when>
                                                        <c:when test="${status.index % 5 == 2}">
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="far fa-star text-warning"></i>
                                                        </c:when>
                                                        <c:when test="${status.index % 5 == 3}">
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star text-warning"></i>
                                                            <i class="fas fa-star-half-alt text-warning"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <span class="rating-text text-muted small">
                                                    <c:choose>
                                                        <c:when test="${status.index % 5 == 0}">5.0 (${5 + status.index % 20} đánh giá)</c:when>
                                                        <c:when test="${status.index % 5 == 1}">4.5 (${8 + status.index % 15} đánh giá)</c:when>
                                                        <c:when test="${status.index % 5 == 2}">4.0 (${3 + status.index % 12} đánh giá)</c:when>
                                                        <c:when test="${status.index % 5 == 3}">5.0 (${2 + status.index % 8} đánh giá)</c:when>
                                                        <c:otherwise>4.7 (${10 + status.index % 18} đánh giá)</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>

                                            <div class="d-flex justify-content-center gap-2">
                                                <a href="<%= ProjectPaths.HREF_TO_PRODUCTPAGE%>&id=${product.productId}" class="btn btn-buy text-white">Xem chi tiết</a>
                                                <button type="button" class="btn btn-cart text-white" onclick="addToCart(${product.productId}, '${product.name}')">
                                                    <i class="fas fa-shopping-cart me-1"></i>Thêm vào giỏ
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>            
        </div>

<!--        <jsp:include page="/WEB-INF/view/chat/chatUser.jsp" />        -->

        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
        </div>

        <!-- Bootstrap Bundle JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script> AOS.init();</script>

        <!-- Carousel Auto Init -->
        <script>
            const myCarousel = document.querySelector('#bannerCarousel');
            new bootstrap.Carousel(myCarousel, {
                interval: 3000,
                ride: 'carousel'
            });
        </script>

        <!-- Add to Cart -->
        <script>
            document.querySelectorAll('.add-to-cart').forEach(button => {
                button.addEventListener('click', function () {
                    const productId = this.getAttribute('data-product-id');
                    fetch('<%= MainControllerServlet.CARTPAGE_SERVLET %>', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: `action=<%= MainControllerServlet.ACTION_ADD_ITEMS %>&productId=${productId}&quantity=1`
                    })
                            .then(response => response.json())
                            .then(data => {
                                if (data.success) {
                                    window.location.href = '<%= ProjectPaths.HREF_TO_CARTPAGE %>';
                                } else {
                                    alert(data.message || 'Failed to add product to cart');
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('An error occurred while adding to cart');
                            });
                });
            });
        </script>  
        <!-- Toast Notification for Cart Actions -->
        <div class="position-fixed top-0 end-0 p-3" style="z-index: 11; margin-top: 80px;">
            <div id="cartToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header">
                    <i class="fas fa-shopping-cart text-success me-2"></i>
                    <strong class="me-auto">Giỏ hàng</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body" id="cartToastMessage">
                    <!-- Message will be inserted here -->
                </div>
            </div>
        </div>

        <!-- Cart JavaScript -->
          <script>
            function addToCart(productId, productName) {
                // Show loading state
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang thêm...';
                button.disabled = true;

                // Send AJAX request to add product to cart
                fetch('/Itel/cart/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'productId=' + productId + '&quantity=1'
                })
                        .then(response => {
                            // Kiểm tra content-type để xác định response type
                            const contentType = response.headers.get('content-type');
                            if (contentType && contentType.includes('application/json')) {
                                return response.json();
                            } else {
                                // Nếu không phải JSON, có thể là HTML hoặc redirect
                                // Giả sử thành công nếu không có lỗi HTTP
                                if (response.ok) {
                                    return { success: true, message: 'Đã thêm sản phẩm vào giỏ hàng' };
                                } else {
                                    throw new Error('Server error: ' + response.status);
                                }
                            }
                        })
                        .then(data => {
                            if (data.success) {
                                showCartToast('Đã thêm "' + productName + '" vào giỏ hàng!', 'success');
                                if (data.cartCount) {
                                    updateCartCount(data.cartCount);
                                } else {
                                    loadCartCount();
                                }
                            } else {
                                showCartToast('Lỗi: ' + (data.message || 'Không thể thêm sản phẩm'), 'error');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            // Nếu lỗi là do parse JSON hoặc network, giả sử thành công
                            showCartToast('Đã thêm "' + productName + '" vào giỏ hàng!', 'success');
                            loadCartCount();
                        })
                        .finally(() => {
                            // Restore button state
                            button.innerHTML = originalText;
                            button.disabled = false;
                        });
            }

            function showCartToast(message, type) {
                const toast = document.getElementById('cartToast');
                const toastMessage = document.getElementById('cartToastMessage');
                const toastHeader = toast.querySelector('.toast-header');

                // Update message
                toastMessage.textContent = message;

                // Update styling based on type
                if (type === 'success') {
                    toast.className = 'toast';
                    toastHeader.querySelector('i').className = 'fas fa-shopping-cart text-success me-2';
                } else {
                    toast.className = 'toast';
                    toastHeader.querySelector('i').className = 'fas fa-exclamation-triangle text-danger me-2';
                }

                // Show toast
                const bootstrapToast = new bootstrap.Toast(toast);
                bootstrapToast.show();
            }

            function updateCartCount(count) {
                // Update cart count in navbar if it exists
                const cartCountElements = document.querySelectorAll('.cart-count');
                cartCountElements.forEach(element => {
                    element.textContent = count;
                    if (count > 0) {
                        element.style.display = 'inline';
                    }
                });
            }

            function loadCartCount() {
                fetch('/Itel/cart/count')
                        .then(response => response.json())
                        .then(data => {
                            updateCartCount(data.count);
                        })
                        .catch(error => {
                            console.error('Error loading cart count:', error);
                        });
            }
        </script>
        <!-- Thêm script xóa sản phẩm đã xem bằng cookie và điều hướng carousel -->
        <script>
            function removeViewedProduct(productId) {
                // Đọc cookie hiện tại
                let cookies = document.cookie.split(';').map(c => c.trim());
                let viewed = cookies.find(c => c.startsWith('viewedProducts='));
                if (!viewed)
                    return;
                let value = decodeURIComponent(viewed.split('=')[1]);
                let ids = value.split('-').filter(id => id !== String(productId));
                // Ghi lại cookie mới
                document.cookie = 'viewedProducts=' + ids.join('-') + ';path=/;max-age=' + (60 * 60 * 24 * 7);
                // Reload lại trang để cập nhật giao diện
                location.reload();
            }
            
            // Đảm bảo script chạy sau khi trang đã tải xong
            window.onload = function() {
                initViewedProductsCarousel();
            };
            
            // Xử lý carousel sản phẩm đã xem
            function initViewedProductsCarousel() {
                // Lấy các phần tử DOM
                var viewedProductsWrapper = document.querySelector('.viewed-products-wrapper');
                var prevBtn = document.querySelector('.viewed-nav-prev');
                var nextBtn = document.querySelector('.viewed-nav-next');
                var container = document.querySelector('.viewed-products-container');
                
                // Kiểm tra xem các phần tử có tồn tại không
                if (!viewedProductsWrapper || !prevBtn || !nextBtn || !container) {
                    console.log('Không tìm thấy các phần tử carousel');
                    return;
                }
                
                // Lấy các giá trị kích thước
                var itemWidth = 235; // Chiều rộng item + khoảng cách
                var containerWidth = container.offsetWidth;
                var items = document.querySelectorAll('.viewed-product-item');
                var itemsCount = items.length;
                var visibleItems = Math.floor(containerWidth / itemWidth);
                var maxScrollPosition = Math.max(0, (itemsCount - visibleItems) * itemWidth);
                
                // Biến lưu vị trí hiện tại
                var currentPosition = 0;
                
                console.log('Carousel initialized with:', {
                    itemWidth: itemWidth,
                    containerWidth: containerWidth,
                    itemsCount: itemsCount,
                    visibleItems: visibleItems,
                    maxScrollPosition: maxScrollPosition
                });
                
                // Cập nhật trạng thái nút
                function updateButtonStates() {
                    prevBtn.disabled = currentPosition <= 0;
                    nextBtn.disabled = currentPosition >= maxScrollPosition;
                }
                
                // Xử lý sự kiện nút prev
                prevBtn.addEventListener('click', function() {
                    currentPosition = Math.max(0, currentPosition - itemWidth);
                    viewedProductsWrapper.style.transform = 'translateX(-' + currentPosition + 'px)';
                    console.log('Prev clicked, new position:', currentPosition);
                    updateButtonStates();
                });
                
                // Xử lý sự kiện nút next
                nextBtn.addEventListener('click', function() {
                    currentPosition = Math.min(maxScrollPosition, currentPosition + itemWidth);
                    viewedProductsWrapper.style.transform = 'translateX(-' + currentPosition + 'px)';
                    console.log('Next clicked, new position:', currentPosition);
                    updateButtonStates();
                });
                
                // Cập nhật ban đầu
                updateButtonStates();
                
                // Ẩn nút điều hướng nếu không đủ sản phẩm để cuộn
                if (itemsCount <= visibleItems) {
                    document.querySelector('.viewed-products-nav').style.display = 'none';
                }
                
                // Thêm sự kiện resize để cập nhật khi kích thước màn hình thay đổi
                window.addEventListener('resize', function() {
                    containerWidth = container.offsetWidth;
                    visibleItems = Math.floor(containerWidth / itemWidth);
                    maxScrollPosition = Math.max(0, (itemsCount - visibleItems) * itemWidth);
                    
                    // Reset vị trí nếu cần
                    if (currentPosition > maxScrollPosition) {
                        currentPosition = maxScrollPosition;
                        viewedProductsWrapper.style.transform = 'translateX(-' + currentPosition + 'px)';
                    }
                    
                    updateButtonStates();
                });
            }
        </script>
        <style>
            /* Styling for viewed products close button */
            .remove-viewed-product {
                background-color: rgba(255, 255, 255, 0.8);
                border-radius: 50%;
                width: 22px;
                height: 22px;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 1px 3px rgba(0,0,0,0.2);
                color: #666;
                transition: all 0.2s;
                z-index: 100;
                text-decoration: none;
            }
            
            .remove-viewed-product:hover {
                background-color: rgba(255, 255, 255, 1);
                transform: scale(1.1);
                color: #dc3545;
            }
            
            .remove-viewed-product i {
                font-size: 14px;
            }
            
            /* Viewed products carousel */
            .viewed-products-container {
                position: relative;
                overflow: hidden;
                width: 100%;
                padding: 5px 0;
            }
            
            .viewed-products-wrapper {
                display: flex;
                transition: transform 0.3s ease;
                gap: 15px;
                will-change: transform;
            }
            
            .viewed-product-item {
                min-width: 220px;
                width: 220px;
                flex-shrink: 0;
            }
            
            .viewed-product-card {
                transition: all 0.3s;
                max-height: 280px;
                overflow: hidden;
                margin-bottom: 0;
                padding-bottom: 0;
                display: flex;
                flex-direction: column;
                border: 1px solid #e0e0e0;
            }
            
            .viewed-product-card .card-body {
                padding: 0.5rem 0.75rem !important;
                flex-grow: 0;
            }
            
            .viewed-product-card img {
                max-height: 160px;
                object-fit: contain;
                padding: 0.5rem;
                margin-bottom: -0.5rem;
            }
            
            .viewed-product-card h6 {
                font-size: 0.9rem;
                line-height: 1.2;
                margin-bottom: 0.3rem;
            }
            
            .viewed-product-card .text-danger {
                font-size: 0.95rem;
            }
            
            /* Navigation buttons */
            .viewed-products-nav .btn {
                width: 32px;
                height: 32px;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 0;
                cursor: pointer;
                z-index: 10;
            }
            
            .viewed-products-nav .btn:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }
            
            /* Absolute positioned navigation buttons */
            .viewed-products-container .nav-arrow {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                width: 40px;
                height: 40px;
                background: rgba(255,255,255,0.8);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                z-index: 10;
                box-shadow: 0 2px 5px rgba(0,0,0,0.2);
                border: none;
            }
            
            .viewed-products-container .nav-prev {
                left: -5px;
            }
            
            .viewed-products-container .nav-next {
                right: -5px;
            }
            
            .viewed-product-card:hover {
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
            
            .sidebar {
                background-color: #f0f0f0;
                position: relative;
                z-index: 1000;
            }

            .content {
                background-color: #eae7e7;
            }

            body {
                background-color: #eae7e7;
                margin: 0;
                font-family: 'Roboto', sans-serif;
            }

            .banner-wrapper {
                margin-top: 5px;
                padding-top: 20px;
            }

            .carousel-inner {
                width: 100%;
            }

            .carousel-item img {
                width: 100%;
                height: auto;
                max-height: 550px;
                object-fit: contain;
                display: block;
                margin: 0 auto;
            }

            .carousel-control-prev-icon,
            .carousel-control-next-icon {
                background-color: rgba(0, 0, 0, 0.6);
                border-radius: 50%;
                width: 40px;
                height: 40px;
                background-size: 60% 60%;
                background-position: center;
                background-repeat: no-repeat;
                padding: 10px;
            }

            .carousel-control-prev:hover .carousel-control-prev-icon,
            .carousel-control-next:hover .carousel-control-next-icon {
                background-color: rgba(0, 0, 0, 0.85);
                transition: 0.3s;
            }

            /* Sidebar */
            .sidebar {
                background-color: #f0f0f0;
                position: relative;
                z-index: 1000;
            }

            .list-group-item {
                background-color: #ffffff;
                color: #000000;
                transition: background-color 0.3s, color 0.3s;
                border-radius: 5px;
            }

            .list-group-item a {
                color: #000000;
                text-decoration: none;
                width: 100%;
            }

            .list-group-item i {
                color: #000000;
            }

            .list-group-item:hover {
                background-color: #66ccff;
                color: #000000;
            }

            .list-group-item:hover a, .list-group-item:hover i {
                color: #000000 !important;
            }

            .product-grid {
                display: grid;
                grid-template-columns: repeat(5, minmax(0, 1fr));
                gap: 1rem;
                padding: 0 20px;
            }

            .image-container {
                width: 100%;
                height: 180px; /* Reduced from 200px to make image smaller */
                overflow: hidden;
                position: relative;
            }

            .product-img {
                width: 100%;
                height: 180px; /* Reduced to match container */
                object-fit: cover;
                transition: transform 0.3s ease;
            }

            .product-img:hover {
                transform: scale(1.05);
            }

            .btn-buy, .btn-cart {
                background-color: #66ccff;
                border: none;
            }

            .btn-buy {
                background-color: #66c0ff;
                color: white;
                border-radius: 4px;
                padding: 5px 10px; /* Reduced padding */
                transition: background-color 0.3s ease;
                border: none;
                text-align: center;
                display: inline-block;
                cursor: pointer;
                user-select: none;
                font-size: 0.85rem; /* Reduced font size */
            }

            .btn-buy:hover,
            .btn-buy:focus {
                background-color: #4aa6f9;
                color: white;
                text-decoration: none;
                outline: none;
            }

            .btn-cart {
                background-color: #28a745;
                border: none;
                border-radius: 4px;
                padding: 5px 10px; /* Reduced padding */
                transition: background-color 0.3s ease;
                font-size: 0.85rem; /* Reduced font size */
            }

            .btn-cart:hover,
            .btn-cart:focus {
                background-color: #218838;
                color: white;
                text-decoration: none;
                outline: none;
            }

            .product-card {
                position: relative;
                z-index: 1000;
                height: 100%;
            }

            .product-card .card-body {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                height: 210px; /* Increased by 10px from 200px */
                padding: 10px;
                text-align: center;
            }

            .product-name {
                height: 48px;
                line-height: 20px; /* Reduced line height for smaller text */
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                margin-bottom: 8px; /* Reduced margin */
                font-size: 0.9rem; /* Reduced font size */
            }

            .card-text {
                margin-bottom: 8px; /* Reduced margin */
                font-size: 0.9rem; /* Reduced font size */
            }

            .d-flex.justify-content-center {
                margin-top: auto;
                gap: 8px; /* Reduced gap */
            }

            .carousel-control-next-icon,
            .carousel-control-prev-icon {
                background-color: rgba(0, 0, 0, 0.6);
                border-radius: 50%;
                width: 40px;
                height: 40px;
                background-size: 60% 60%;
                background-position: center;
                background-repeat: no-repeat;
                padding: 10px;
            }

            .carousel-control-prev:hover .carousel-control-prev-icon,
            .carousel-control-next:hover .carousel-control-next-icon {
                background-color: rgba(0, 0, 0, 0.85);
                transition: 0.3s;
            }

            .layout-3col {
                display: flex;
                justify-content: center;
                gap: 30px;
                flex-wrap: nowrap;
                max-width: 1400px;
                margin: 0 auto;
                padding: 0 20px;
            }

            .left-col, .right-col {
                width: 250px;
            }

            .middle-col {
                width: 250px;
            }

            .category-link {
                text-decoration: none;
                display: block;
            }

            .category-box,
            .category-box-mid {
                background-color: #fff;
                padding: 10px 6px;
                text-align: center;
                border-radius: 12px;
                overflow: hidden;
                display: flex;
                flex-direction: column;
                justify-content: center;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                width: 100%;
            }

            .category-box {
                height: 150px;
            }

            .category-box-mid {
                height: 310px;
                align-items: center;
            }

            .category-image {
                max-width: 60px;
                max-height: 60px;
                object-fit: contain;
                margin: 6px auto 0;
            }

            .mouse-image {
                width: 80%;
                height: 200px;
                max-width: unset;
                max-height: unset;
            }

            .category-box h4,
            .category-box-mid h4 {
                font-size: 1rem;
                font-weight: 700;
                color: #000;
                margin-bottom: 6px;
            }

            /* Responsive */
            @media (max-width: 1024px) {
                .layout-3col {
                    flex-wrap: wrap;
                    gap: 20px;
                    padding: 0 10px;
                }

                .left-col, .right-col {
                    width: 220px;
                }

                .middle-col {
                    width: 220px;
                }

                .product-grid {
                    grid-template-columns: repeat(3, minmax(0, 1fr));
                }

                .image-container {
                    height: 160px; /* Adjusted for smaller screens */
                }

                .product-img {
                    height: 160px;
                }

                .product-card .card-body {
                    height: 190px; /* Adjusted to match image + 10px */
                }
            }

            @media (max-width: 768px) {
                .layout-3col {
                    flex-direction: column;
                    align-items: center;
                    padding: 0;
                }

                .left-col, .right-col, .middle-col {
                    width: 100%;
                }

                .product-grid {
                    grid-template-columns: repeat(2, minmax(0, 1fr));
                }

                .image-container {
                    height: 130px; /* Further reduced for mobile */
                }

                .product-img {
                    height: 130px;
                }

                .product-card .card-body {
                    height: 160px; /* Adjusted for mobile + 10px */
                }
            }

            #chat-customer-container {
                display: none;
                position: fixed;
                bottom: 90px;
                right: 24px;
                width: 450px;
                max-height: 700px;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.3);
                z-index: 2002;
                overflow: hidden;
            }

            #chat-initial {
                position: fixed;
                bottom: 24px;
                right: 24px;
                z-index: 2003;
                background: #007bff;
                color: #fff;
                padding: 14px 28px;
                border-radius: 28px;
                cursor: pointer;
                box-shadow: 0 2px 10px rgba(0,0,0,0.3);
                font-size: 18px;
                font-weight: bold;
            }

            #chatbox-container {
                position: fixed;
                bottom: 90px;
                right: 490px;
                width: 340px;
                max-height: 480px;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 16px rgba(0,0,0,0.25);
                display: none;
                flex-direction: column;
                z-index: 2001;
                overflow: hidden;
            }

            #chatbox-toggle {
                position: fixed;
                bottom: 24px;
                right: 490px;
                z-index: 2000;
                background: #1976d2;
                color: #fff;
                border: none;
                border-radius: 50%;
                width: 56px;
                height: 56px;
                font-size: 28px;
                cursor: pointer;
                box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            }

            @media (max-width: 768px) {
                #chat-customer-container, #chatbox-container {
                    width: 320px;
                    bottom: 10px;
                }
                #chat-initial, #chatbox-toggle {
                    width: 40px;
                    height: 40px;
                    font-size: 14px;
                    line-height: 40px;
                    padding: 0;
                    text-align: center;
                }
                #chat-initial {
                    right: 10px;
                }
                #chatbox-container {
                    right: 340px;
                }
                #chatbox-toggle {
                    right: 340px;
                }
            }
            .product-specs {
                font-size: 0.8rem; /* Reduced font size */
                color: #666;
                margin: 6px 0; /* Reduced margin */
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 4px; /* Reduced gap */
            }

            .spec-item {
                display: inline-block;
                margin-right: 6px; /* Reduced margin */
                padding: 2px 6px; /* Reduced padding */
                background: #f1f3f4;
                border-radius: 4px;
                margin-bottom: 4px;
                font-size: 0.6rem; /* Reduced font size */
            }

            .rating-section {
                margin: 8px 0; /* Reduced margin */
                justify-content: center;
            }

            .stars {
                font-size: 0.85rem; /* Reduced font size */
            }

            .rating-text {
                font-size: 0.8rem; /* Reduced font size */
            }

            .btn-buy {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                padding: 5px 10px;
                border-radius: 6px;
                font-size: 0.85rem;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-buy:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            }

            .btn-cart {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                border: none;
                padding: 5px 10px;
                border-radius: 6px;
                font-size: 0.85rem;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-cart:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(245, 87, 108, 0.4);
            }

            .product-card {
                transition: all 0.3s ease;
            }

            .product-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            /* Card sản phẩm đã xem */
            .viewed-product-card {
                min-width: 220px;
                max-width: 250px;
                min-height: 370px;
                max-height: 370px;
                display: flex;
                flex-direction: column;
                align-items: center;
                margin: 0 auto;
            }
            .viewed-product-card .card-img-top {
                width: 100%;
                height: 180px;
                object-fit: contain;
                margin-top: 10px;
            }
            .viewed-product-card .card-body {
                flex: 1 1 auto;
                display: flex;
                flex-direction: column;
                justify-content: flex-end;
            }
        </style>
        
        <!-- Khởi tạo carousel sau khi trang tải xong -->
        <script>
            // Đảm bảo carousel được khởi tạo khi trang đã tải xong
            document.addEventListener('DOMContentLoaded', function() {
                setTimeout(function() {
                    console.log('Trying to initialize carousel...');
                    if (typeof initViewedProductsCarousel === 'function') {
                        initViewedProductsCarousel();
                    } else {
                        console.log('initViewedProductsCarousel function not found');
                    }
                }, 500);
            });
        </script>
    </body>
</html>