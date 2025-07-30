<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Danh Mục</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Sidebar -->
    <jsp:include page="../../components/sidebar.jsp" />
    
    <!-- Toast -->
    <jsp:include page="../../components/toast.jsp" />
    
    <!-- Main Content -->
    <div class="main-container">
        <div class="content-wrapper">
            <!-- Header Section -->
            <header class="page-header">
                <div class="header-content">
                    <div class="header-title">
                        <h1><i class="fas fa-layer-group"></i> Quản Lý Danh Mục</h1>
                        <p>Quản lý và tổ chức các danh mục du lịch</p>
                    </div>
                </div>
            </header>

            <!-- Action Bar -->
            <div class="action-bar">
                <div class="search-section">
                    <form action="main" method="get" class="search-form">
                        <input type="hidden" name="action" value="searchCategory">
                        <div class="search-input-group">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" 
                                   class="search-input" 
                                   id="searchCategory" 
                                   name="qCategory"
                                   placeholder="Tìm kiếm danh mục..." 
                                   value="${param.qCategory}">
                            <button type="submit" class="search-btn">
                                Tìm kiếm
                            </button>
                        </div>
                    </form>
                    
                    <c:if test="${not empty param.qCategory}">
                        <a href="<%= ProjectPaths.HREF_TO_CATEGORYMANAGEMENT %>" class="back-btn">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại
                        </a>
                    </c:if>
                </div>

                <div class="action-buttons">
                    <form action="main" method="get">
                        <input type="hidden" name="action" value="createCategoryForm">
                        <button type="submit" class="add-btn">
                            <i class="fas fa-plus"></i>
                            Thêm Danh Mục
                        </button>
                    </form>
                </div>
            </div>

            <!-- Table Section -->
            <div class="table-container">
                <div class="table-wrapper">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th class="col-stt">STT</th>
                                <th class="col-image">Hình Ảnh</th>
                                <th class="col-name">Tên Danh Mục</th>
                                <th class="col-description">Mô Tả</th>
                                <th class="col-status">Trạng Thái</th>
                                <th class="col-actions">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="category" items="${categories}" varStatus="loop">
                                <tr class="table-row">
                                    <td class="stt-cell">${loop.count}</td>
                                    <td class="image-cell">
                                        <div class="image-container">
                                            <img src="${category.imageUrl}" 
                                                 alt="${category.name}" 
                                                 class="category-image"
                                                 loading="lazy">
                                        </div>
                                    </td>
                                    <td class="name-cell">
                                        <div class="category-name">${category.name}</div>
                                    </td>
                                    <td class="description-cell">
                                        <div class="category-description">${category.description}</div>
                                    </td>
                                    <td class="status-cell">
                                        <span class="status-badge ${category.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                            <i class="fas ${category.status == 'ACTIVE' ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                                            ${category.status == 'ACTIVE' ? 'Hoạt động' : 'Không hoạt động'}
                                        </span>
                                    </td>
                                    <td class="actions-cell">
                                        <div class="action-buttons-group">
                                            <a href="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_UPDATE_CATEGORY_FORM%>&id=${category.categoryId}" 
                                               class="btn-edit" 
                                               title="Chỉnh sửa">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form action="<%= ProjectPaths.HREF_TO_MAINCONTROLLER + MainControllerServlet.ACTION_DELETE_CATEGORY %>" 
                                                  method="post" 
                                                  class="delete-form"
                                                  onsubmit="return confirm('Bạn có chắc chắn muốn xóa danh mục này?')">
                                                <input type="hidden" name="categoryId" value="${category.categoryId}">
                                                <button type="submit" class="btn-delete" title="Xóa">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    
                    <c:if test="${empty categories}">
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="fas fa-folder-open"></i>
                            </div>
                            <h3>Không có danh mục nào</h3>
                            <p>Hãy thêm danh mục đầu tiên để bắt đầu quản lý</p>
                            <form action="main" method="get">
                                <input type="hidden" name="action" value="createCategoryForm">
                                <button type="submit" class="add-btn">
                                    <i class="fas fa-plus"></i>
                                    Thêm Danh Mục Đầu Tiên
                                </button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            color: #2d3748;
            line-height: 1.6;
        }

        .main-container {
            margin-top: 30px;
            min-height: 100vh;
            transition: margin-left 0.3s ease;
        }

        .content-wrapper {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-header {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .header-title h1 i {
            color: #4299e1;
        }

        .header-title p {
            color: #718096;
            font-size: 1rem;
            font-weight: 400;
        }

        /* Action Bar */
        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 2rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .search-section {
            flex: 1;
            display: flex;
            gap: 1rem;
            align-items: flex-start;
        }

        .search-form {
            flex: 1;
            max-width: 500px;
        }

        .search-input-group {
            position: relative;
            display: flex;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .search-input-group:focus-within {
            border-color: #4299e1;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.1);
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            z-index: 2;
        }

        .search-input {
            flex: 1;
            padding: 1rem 1rem 1rem 3rem;
            border: none;
            outline: none;
            font-size: 1rem;
            background: transparent;
        }

        .search-input::placeholder {
            color: #a0aec0;
        }

        .search-btn {
            padding: 1rem 1.5rem;
            background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
            color: white;
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            background: linear-gradient(135deg, #3182ce 0%, #2c5282 100%);
            transform: translateY(-1px);
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 1.5rem;
            background: white;
            color: #4a5568;
            text-decoration: none;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .back-btn:hover {
            background: #f7fafc;
            transform: translateY(-2px);
            box-shadow: 0 8px 15px -3px rgba(0, 0, 0, 0.1);
            color: #2d3748;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
        }

        .add-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .add-btn:hover {
            background: linear-gradient(135deg, #38a169 0%, #2f855a 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 15px -3px rgba(0, 0, 0, 0.1);
        }

        /* Table Container */
        .table-container {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .table-wrapper {
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        .data-table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .data-table th {
            padding: 1.5rem 1rem;
            text-align: left;
            font-weight: 600;
            color: white;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-bottom: none;
        }

        .data-table tbody tr {
            transition: all 0.3s ease;
            border-bottom: 1px solid #e2e8f0;
        }

        .data-table tbody tr:hover {
            background: #f8fafc;
            transform: scale(1.01);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .data-table td {
            padding: 1.5rem 1rem;
            vertical-align: middle;
            border-bottom: 1px solid #e2e8f0;
        }

        /* Column Specific Styles */
        .col-stt { width: 80px; }
        .col-image { width: 120px; }
        .col-name { width: 200px; }
        .col-description { width: 300px; }
        .col-status { width: 150px; }
        .col-actions { width: 120px; }

        .stt-cell {
            font-weight: 600;
            color: #4a5568;
            text-align: center;
        }

        .image-container {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .category-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .category-image:hover {
            transform: scale(1.1);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .category-name {
            font-weight: 600;
            color: #2d3748;
            font-size: 1rem;
        }

        .category-description {
            color: #4a5568;
            line-height: 1.5;
            max-width: 280px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        /* Status Badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 500;
            text-transform: capitalize;
        }

        .status-active {
            background: linear-gradient(135deg, #c6f6d5 0%, #9ae6b4 100%);
            color: #22543d;
        }

        .status-inactive {
            background: linear-gradient(135deg, #fed7d7 0%, #feb2b2 100%);
            color: #742a2a;
        }

        /* Action Buttons */
        .action-buttons-group {
            display: flex;
            gap: 0.5rem;
            justify-content: center;
        }

        .btn-edit, .btn-delete {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            font-size: 0.875rem;
        }

        .btn-edit {
            background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
            color: white;
        }

        .btn-edit:hover {
            background: linear-gradient(135deg, #3182ce 0%, #2c5282 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .btn-delete {
            background: linear-gradient(135deg, #fc8181 0%, #f56565 100%);
            color: white;
        }

        .btn-delete:hover {
            background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .delete-form {
            display: inline;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #4a5568;
        }

        .empty-icon {
            font-size: 4rem;
            color: #cbd5e0;
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #2d3748;
        }

        .empty-state p {
            margin-bottom: 2rem;
            color: #718096;
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .main-container {
                margin-left: 0;
            }
            
            .content-wrapper {
                padding: 1rem;
            }
            
            .action-bar {
                flex-direction: column;
                gap: 1rem;
            }
            
            .search-section {
                width: 100%;
            }
        }

        @media (max-width: 768px) {
            .header-title h1 {
                font-size: 1.5rem;
            }
            
            .search-input-group {
                flex-direction: column;
            }
            
            .search-btn {
                border-radius: 0 0 12px 12px;
            }
            
            .data-table {
                font-size: 0.875rem;
            }
            
            .data-table th,
            .data-table td {
                padding: 1rem 0.5rem;
            }
            
            .category-image {
                width: 60px;
                height: 60px;
            }
            
            .action-buttons-group {
                flex-direction: column;
                gap: 0.25rem;
            }
        }

        @media (max-width: 480px) {
            .content-wrapper {
                padding: 0.5rem;
            }
            
            .page-header {
                padding: 1rem;
            }
            
            .header-title h1 {
                font-size: 1.25rem;
            }
            
            .add-btn {
                padding: 0.75rem 1rem;
                font-size: 0.875rem;
            }
        }

        /* Animation Classes */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Loading States */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        /* Focus States */
        .btn-edit:focus,
        .btn-delete:focus,
        .add-btn:focus,
        .search-btn:focus {
            outline: 2px solid #4299e1;
            outline-offset: 2px;
        }

        /* Print Styles */
        @media print {
            .action-bar,
            .action-buttons-group {
                display: none;
            }
            
            .main-container {
                margin-left: 0;
            }
            
            .table-container {
                box-shadow: none;
                border: 1px solid #000;
            }
        }
    </style>
</body>
</html>