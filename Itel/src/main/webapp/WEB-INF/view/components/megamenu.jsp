<%-- 
    Document   : megamenu
    Created on : Mar 8, 2025, 6:00:00 PM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="mega-menu">
    <div class="row">
        <!-- Left Categories -->
        <div class="col-md-3">
            <div class="category-list">
                <div class="category-item" data-category="phone">
                    <i class="fas fa-mobile-alt"></i>
                    <span>Điện thoại</span>
                </div>
                <div class="category-item" data-category="laptop">
                    <i class="fas fa-laptop"></i>
                    <span>Laptop</span>
                </div>
                <div class="category-item" data-category="tablet">
                    <i class="fas fa-tablet-alt"></i>
                    <span>Điện máy</span>
                    <span class="badge-hot">Mới</span>
                </div>
                <div class="category-item" data-category="accessories">
                    <i class="fas fa-headphones"></i>
                    <span>Phụ kiện</span>
                </div>
                <div class="category-item" data-category="apple">
                    <i class="fab fa-apple"></i>
                    <span>Chuyên trang Apple</span>
                </div>
                <div class="category-item" data-category="samsung">
                    <i class="fas fa-tv"></i>
                    <span>Chuyên trang Samsung</span>
                </div>
                <div class="category-item" data-category="xiaomi">
                    <i class="fas fa-mobile"></i>
                    <span>Chuyên trang Xiaomi</span>
                </div>
                <div class="category-item" data-category="appliances">
                    <i class="fas fa-air-freshener"></i>
                    <span>Tivi, Tủ lạnh, Máy lạnh - Điều hòa</span>
                </div>
                <div class="category-item" data-category="home">
                    <i class="fas fa-washing-machine"></i>
                    <span>Máy giặt, Máy sấy, Tủ sấy</span>
                </div>
                <div class="category-item" data-category="clean">
                    <i class="fas fa-broom"></i>
                    <span>Quạt, Quạt điều hòa, Máy lọc nước</span>
                </div>
                <div class="category-item" data-category="vacuum">
                    <i class="fas fa-vacuum"></i>
                    <span>Robot hút bụi, Máy hút bụi, Máy lọc khí</span>
                </div>
                <div class="category-item" data-category="kitchen">
                    <i class="fas fa-utensils"></i>
                    <span>Máy in, Phần mềm, Linh kiện</span>
                </div>
            </div>
        </div>

        <!-- Right Content -->
        <div class="col-md-9">
            <!-- Phone Category Content -->
            <div class="category-content" id="phone-content">
                <div class="row">
                    <div class="col-md-4">
                        <div class="suggestions-section">
                            <h6><i class="fas fa-fire text-warning"></i> Gợi ý cho bạn</h6>
                            <div class="suggestion-grid">
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-signal"></i>
                                    </div>
                                    <span>Điện thoại 5G</span>
                                </div>
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-brain"></i>
                                    </div>
                                    <span>Điện thoại AI</span>
                                </div>
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-layer-group"></i>
                                    </div>
                                    <span>Điện thoại gập</span>
                                </div>
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-gamepad"></i>
                                    </div>
                                    <span>Gaming phone</span>
                                </div>
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-network-wired"></i>
                                    </div>
                                    <span>Phổ thông 4G</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="brand-section">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="brand-group">
                                        <h6>Apple (iPhone) <i class="fas fa-chevron-right"></i></h6>
                                        <ul>
                                            <li><a href="#">iPhone 16 Series</a></li>
                                            <li><a href="#">iPhone 15 Series</a></li>
                                            <li><a href="#">iPhone 14 Series</a></li>
                                            <li><a href="#">iPhone 13 Series</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="brand-group">
                                        <h6>Samsung <i class="fas fa-chevron-right"></i></h6>
                                        <ul>
                                            <li><a href="#">Galaxy AI</a></li>
                                            <li><a href="#">Galaxy S Series</a></li>
                                            <li><a href="#">Galaxy Z Series</a></li>
                                            <li><a href="#">Galaxy A Series</a></li>
                                            <li><a href="#">Galaxy M Series</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="brand-group">
                                        <h6>OPPO <i class="fas fa-chevron-right"></i></h6>
                                        <ul>
                                            <li><a href="#">OPPO Reno Series</a></li>
                                            <li><a href="#">OPPO A Series</a></li>
                                            <li><a href="#">OPPO Find Series</a></li>
                                        </ul>
                                        <h6 style="margin-top: 15px;">Thương hiệu khác <i class="fas fa-chevron-right"></i></h6>
                                        <ul>
                                            <li><a href="#">Tecno</a></li>
                                            <li><a href="#">Realme</a></li>
                                            <li><a href="#">Vivo</a></li>
                                            <li><a href="#">Inoi</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Laptop Category Content -->
            <div class="category-content" id="laptop-content" style="display: none;">
                <div class="row">
                    <div class="col-md-4">
                        <div class="suggestions-section">
                            <h6><i class="fas fa-fire text-warning"></i> Gợi ý cho bạn</h6>
                            <div class="suggestion-grid">
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-gamepad"></i>
                                    </div>
                                    <span>Laptop Gaming</span>
                                </div>
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-briefcase"></i>
                                    </div>
                                    <span>Laptop Văn phòng</span>
                                </div>
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-palette"></i>
                                    </div>
                                    <span>Laptop Đồ họa</span>
                                </div>
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-dollar-sign"></i>
                                    </div>
                                    <span>Laptop Sinh viên</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="brand-section">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="brand-group">
                                        <h6>Apple MacBook</h6>
                                        <ul>
                                            <li><a href="#">MacBook Air M3</a></li>
                                            <li><a href="#">MacBook Pro M3</a></li>
                                            <li><a href="#">MacBook Air M2</a></li>
                                            <li><a href="#">MacBook Pro M2</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="brand-group">
                                        <h6>Dell</h6>
                                        <ul>
                                            <li><a href="#">Dell Inspiron</a></li>
                                            <li><a href="#">Dell XPS</a></li>
                                            <li><a href="#">Dell Vostro</a></li>
                                            <li><a href="#">Dell Latitude</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="brand-group">
                                        <h6>HP</h6>
                                        <ul>
                                            <li><a href="#">HP Pavilion</a></li>
                                            <li><a href="#">HP Envy</a></li>
                                            <li><a href="#">HP EliteBook</a></li>
                                            <li><a href="#">HP Spectre</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Accessories Category Content -->
            <div class="category-content" id="accessories-content" style="display: none;">
                <div class="row">
                    <div class="col-md-4">
                        <div class="suggestions-section">
                            <h6><i class="fas fa-fire text-warning"></i> Gợi ý cho bạn</h6>
                            <div class="suggestion-grid">
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-headphones"></i>
                                    </div>
                                    <span>Tai nghe</span>
                                </div>
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-mouse"></i>
                                    </div>
                                    <span>Chuột + Bàn phím</span>
                                </div>
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-battery-three-quarters"></i>
                                    </div>
                                    <span>Sạc dự phòng</span>
                                </div>
                                <div class="suggestion-item">
                                    <div class="suggestion-icon">
                                        <i class="fas fa-cable-car"></i>
                                    </div>
                                    <span>Cáp & Adapter</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="brand-section">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="brand-group">
                                        <h6>Tai nghe</h6>
                                        <ul>
                                            <li><a href="#">AirPods</a></li>
                                            <li><a href="#">Sony WH-1000XM5</a></li>
                                            <li><a href="#">JBL</a></li>
                                            <li><a href="#">Beats</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="brand-group">
                                        <h6>Sạc & Cáp</h6>
                                        <ul>
                                            <li><a href="#">Sạc nhanh</a></li>
                                            <li><a href="#">Sạc không dây</a></li>
                                            <li><a href="#">Cáp Lightning</a></li>
                                            <li><a href="#">Cáp USB-C</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="brand-group">
                                        <h6>Bảo vệ</h6>
                                        <ul>
                                            <li><a href="#">Ốp lưng</a></li>
                                            <li><a href="#">Miếng dán màn hình</a></li>
                                            <li><a href="#">Túi chống sốc</a></li>
                                            <li><a href="#">Kính cường lực</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .mega-menu {
        width: 980px;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        padding: 20px;
        min-height: 400px;
    }

    .category-list {
        border-right: 1px solid #eee;
        padding-right: 15px;
    }

    .category-item {
        display: flex;
        align-items: center;
        padding: 12px 15px;
        cursor: pointer;
        transition: all 0.3s ease;
        border-radius: 6px;
        margin-bottom: 2px;
        position: relative;
    }

    .category-item:hover {
        background: #f8f9fa;
        color: #e74c3c;
    }

    .category-item.active {
        background: #e74c3c;
        color: white;
    }

    .category-item i {
        margin-right: 12px;
        font-size: 16px;
        width: 20px;
        text-align: center;
    }

    .category-item span {
        font-size: 14px;
        font-weight: 500;
    }

    .badge-hot {
        background: #ff4757;
        color: white;
        font-size: 10px;
        padding: 2px 6px;
        border-radius: 3px;
        margin-left: auto;
    }

    .category-content {
        padding-left: 20px;
    }

    .suggestions-section h6 {
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 15px;
        color: #333;
    }

    .suggestion-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 10px;
    }

    .suggestion-item {
        display: flex;
        align-items: center;
        padding: 8px;
        border: 1px solid #eee;
        border-radius: 6px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .suggestion-item:hover {
        border-color: #e74c3c;
        background: #fff5f5;
    }

    .suggestion-icon {
        width: 30px;
        height: 30px;
        background: #f8f9fa;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 8px;
        color: #e74c3c;
    }

    .suggestion-item span {
        font-size: 12px;
        font-weight: 500;
    }

    .brand-section {
        margin-top: 20px;
    }

    .brand-group h6 {
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 10px;
        color: #333;
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .brand-group h6 i {
        font-size: 12px;
        color: #999;
    }

    .brand-group ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .brand-group ul li {
        margin-bottom: 5px;
    }

    .brand-group ul li a {
        color: #666;
        text-decoration: none;
        font-size: 13px;
        transition: color 0.3s ease;
    }

    .brand-group ul li a:hover {
        color: #e74c3c;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .mega-menu {
            width: 100%;
            padding: 15px;
        }
        
        .category-list {
            border-right: none;
            border-bottom: 1px solid #eee;
            padding-right: 0;
            padding-bottom: 15px;
            margin-bottom: 15px;
        }
        
        .category-content {
            padding-left: 0;
        }
        
        .suggestion-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const categoryItems = document.querySelectorAll('.category-item');
        const categoryContents = document.querySelectorAll('.category-content');
        
        // Set default active category
        categoryItems[0].classList.add('active');
        
        categoryItems.forEach(item => {
            item.addEventListener('click', function() {
                // Remove active class from all items
                categoryItems.forEach(i => i.classList.remove('active'));
                
                // Add active class to clicked item
                this.classList.add('active');
                
                // Hide all content
                categoryContents.forEach(content => {
                    content.style.display = 'none';
                });
                
                // Show corresponding content
                const category = this.getAttribute('data-category');
                const content = document.getElementById(category + '-content');
                if (content) {
                    content.style.display = 'block';
                }
            });
        });
    });
</script>