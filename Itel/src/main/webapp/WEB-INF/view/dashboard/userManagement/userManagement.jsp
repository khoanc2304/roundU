<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý người dùng</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: #334155;
            }

            .container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 2rem 1rem;
            }

            .page-header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 24px;
                padding: 2rem;
                margin-bottom: 2rem;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .page-title {
                font-size: 2.5rem;
                font-weight: 700;
                color: #1e293b;
                text-align: center;
                margin-bottom: 0.5rem;
                letter-spacing: -0.025em;
            }

            .page-subtitle {
                text-align: center;
                color: #64748b;
                font-size: 1.125rem;
                margin-bottom: 2rem;
            }

            .controls-section {
                display: flex;
                flex-direction: column;
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .search-controls {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 16px;
                padding: 1.5rem;
                box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .search-form {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1rem;
                align-items: end;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 0.5rem;
            }

            .form-label {
                font-size: 0.875rem;
                font-weight: 500;
                color: #374151;
            }

            .form-input,
            .form-select {
                padding: 0.75rem 1rem;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                font-size: 1rem;
                background: white;
                transition: all 0.3s ease;
                outline: none;
            }

            .form-input:focus,
            .form-select:focus {
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
                transform: translateY(-1px);
            }

            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
                padding: 0.75rem 1.5rem;
                border-radius: 12px;
                font-weight: 500;
                text-decoration: none;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 0.875rem;
            }

            .btn-primary {
                background: linear-gradient(135deg, #3b82f6, #1d4ed8);
                color: white;
                box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px -5px rgba(59, 130, 246, 0.4);
            }

            .btn-success {
                background: linear-gradient(135deg, #10b981, #059669);
                color: white;
                box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.3);
            }

            .btn-success:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px -5px rgba(16, 185, 129, 0.4);
            }

            .btn-warning {
                background: linear-gradient(135deg, #f59e0b, #d97706);
                color: white;
                box-shadow: 0 4px 6px -1px rgba(245, 158, 11, 0.3);
            }

            .btn-warning:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px -5px rgba(245, 158, 11, 0.4);
            }

            .btn-danger {
                background: linear-gradient(135deg, #ef4444, #dc2626);
                color: white;
                box-shadow: 0 4px 6px -1px rgba(239, 68, 68, 0.3);
            }

            .btn-danger:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px -5px rgba(239, 68, 68, 0.4);
            }

            .btn-sm {
                padding: 0.5rem 1rem;
                font-size: 0.75rem;
            }

            .create-user-section {
                display: flex;
                justify-content: center;
            }

            .data-section {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 16px;
                box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                overflow: hidden;
            }

            .table-header {
                background: linear-gradient(135deg, #f8fafc, #e2e8f0);
                padding: 1rem 1.5rem;
                border-bottom: 1px solid #e2e8f0;
            }

            .table-title {
                font-size: 1.125rem;
                font-weight: 600;
                color: #1e293b;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .user-count {
                background: #3b82f6;
                color: white;
                padding: 0.25rem 0.75rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 500;
            }

            .table-container {
                overflow-x: auto;
            }

            .users-table {
                width: 100%;
                border-collapse: collapse;
            }

            .users-table th {
                background: #f8fafc;
                padding: 1rem;
                text-align: left;
                font-weight: 600;
                color: #374151;
                font-size: 0.875rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                border-bottom: 2px solid #e2e8f0;
            }

            .users-table td {
                padding: 1rem;
                border-bottom: 1px solid #f1f5f9;
                vertical-align: middle;
            }

            .users-table tbody tr {
                transition: all 0.3s ease;
            }

            /*        .users-table tbody tr:hover {
                        background: #f8fafc;
                        transform: scale(1.01);
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                    }*/

            .user-id {
                font-family: monospace;
                background: #f1f5f9;
                padding: 0.25rem 0.5rem;
                border-radius: 6px;
                font-size: 0.875rem;
                color: #64748b;
            }

            .username {
                font-weight: 500;
                color: #1e293b;
            }

            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .status-active {
                background: linear-gradient(135deg, #dcfce7, #bbf7d0);
                color: #166534;
                border: 1px solid #86efac;
            }

            .status-inactive {
                background: linear-gradient(135deg, #fee2e2, #fecaca);
                color: #991b1b;
                border: 1px solid #fca5a5;
            }

            .status-dot {
                width: 8px;
                height: 8px;
                border-radius: 50%;
            }

            .status-active .status-dot {
                background: #22c55e;
            }

            .status-inactive .status-dot {
                background: #ef4444;
            }

            .actions {
                display: flex;
                gap: 0.5rem;
                align-items: center;
            }

            .empty-state {
                text-align: center;
                padding: 3rem 2rem;
                color: #64748b;
            }

            .empty-icon {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1rem;
                color: #94a3b8;
            }

            .empty-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #374151;
                margin-bottom: 0.5rem;
            }

            .empty-description {
                font-size: 1rem;
                margin-bottom: 1.5rem;
            }

            .loading {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 3px solid rgba(255, 255, 255, 0.3);
                border-radius: 50%;
                border-top-color: white;
                animation: spin 1s ease-in-out infinite;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }

            @media (max-width: 768px) {
                .container {
                    padding: 1rem;
                }

                .page-header {
                    padding: 1.5rem;
                    border-radius: 16px;
                }

                .page-title {
                    font-size: 2rem;
                }

                .search-form {
                    grid-template-columns: 1fr;
                }

                .table-container {
                    border-radius: 0;
                }

                .users-table {
                    font-size: 0.875rem;
                }

                .users-table th,
                .users-table td {
                    padding: 0.75rem 0.5rem;
                }

                .actions {
                    flex-direction: column;
                    gap: 0.25rem;
                }

                .btn-sm {
                    width: 100%;
                    justify-content: center;
                }
            }

            @media (max-width: 480px) {
                .users-table thead {
                    display: none;
                }

                .users-table,
                .users-table tbody,
                .users-table tr,
                .users-table td {
                    display: block;
                    width: 100%;
                }

                .users-table tr {
                    background: white;
                    border-radius: 12px;
                    margin-bottom: 1rem;
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                    border: 1px solid #e2e8f0;
                    overflow: hidden;
                }

                .users-table td {
                    text-align: left;
                    padding: 1rem;
                    position: relative;
                    border-bottom: 1px solid #f1f5f9;
                }

                .users-table td:last-child {
                    border-bottom: none;
                }

                .users-table td::before {
                    content: attr(data-label);
                    font-weight: 600;
                    color: #64748b;
                    font-size: 0.75rem;
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                    display: block;
                    margin-bottom: 0.5rem;
                }

                .actions {
                    flex-direction: row;
                    gap: 0.5rem;
                }
            }

            .toast {
                position: fixed;
                top: 2rem;
                right: 2rem;
                background: white;
                border-radius: 12px;
                padding: 1rem 1.5rem;
                box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
                border: 1px solid #e2e8f0;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                transform: translateX(100%);
                transition: transform 0.3s ease;
                z-index: 1000;
            }

            .toast.show {
                transform: translateX(0);
            }

            .toast-success {
                border-left: 4px solid #22c55e;
            }

            .toast-error {
                border-left: 4px solid #ef4444;
            }

            .toast-icon {
                width: 20px;
                height: 20px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 0.75rem;
            }

            .toast-success .toast-icon {
                background: #22c55e;
            }

            .toast-error .toast-icon {
                background: #ef4444;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../../components/sidebar.jsp" />
        <jsp:include page="../../components/toast.jsp" />

        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="page-title">Quản lý người dùng</h1>
                <p class="page-subtitle">Quản lý thông tin và quyền hạn của người dùng trong hệ thống</p>
            </div>

            <!-- Controls Section -->
            <div class="controls-section">
                <!-- Search Controls -->
                <div class="search-controls">
                    <form class="search-form" action="${pageContext.request.contextPath}/userManagement" method="get">
                        <input type="hidden" name="action" value="searchUsers">

                        <div class="form-group">
                            <label class="form-label" for="username">Tên đăng nhập</label>
                            <input type="text" id="username" name="username" class="form-input" placeholder="Nhập tên đăng nhập..." value="${param.username}">
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="status">Trạng thái</label>
                            <select id="status" name="status" class="form-select">
                                <option value="">Tất cả trạng thái</option>
                                <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>Không hoạt động</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="11" cy="11" r="8"/>
                                <path d="m21 21-4.35-4.35"/>
                                </svg>
                                Tìm kiếm
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Create User Button -->
                <div class="create-user-section">
                    <form action="${pageContext.request.contextPath}/userManagement" method="get">
                        <input type="hidden" name="action" value="createForm">
                        <button type="submit" class="btn btn-success">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                            <line x1="20" y1="8" x2="20" y2="14"/>
                            <line x1="23" y1="11" x2="17" y2="11"/>
                            </svg>
                            Thêm người dùng mới
                        </button>
                    </form>
                </div>
            </div>

            <!-- Data Section -->
            <div class="data-section">
                <div class="table-header">
                    <div class="table-title">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                        </svg>
                        Danh sách người dùng
                        <span class="user-count"></span>
                    </div>
                </div>

                <div class="table-container">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên đăng nhập</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td data-label="ID">
                                        <span class="user-id">#${user.userId}</span>
                                    </td>
                                    <td data-label="Tên đăng nhập">
                                        <span class="username">${user.username}</span>
                                    </td>
                                    <td data-label="Trạng thái">
                                        <span class="status-badge status-${user.status == 'ACTIVE' ? 'active' : 'inactive'}">
                                            <span class="status-dot"></span>
                                            ${user.status == 'ACTIVE' ? 'Hoạt động' : 'Không hoạt động'}
                                        </span>
                                    </td>
                                    <td data-label="Thao tác">
                                        <div class="actions">
                                            <form action="${pageContext.request.contextPath}/userManagement" method="get">
                                                <input type="hidden" name="action" value="viewUser">
                                                <input type="hidden" name="id" value="${user.userId}">
                                                <button type="submit" class="btn btn-primary btn-sm">
                                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                                    <circle cx="12" cy="12" r="3"/>
                                                    </svg>
                                                    Xem
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/userManagement" method="get">
                                                <input type="hidden" name="action" value="editForm">
                                                <input type="hidden" name="id" value="${user.userId}">
                                                <button type="submit" class="btn btn-warning btn-sm">
                                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                                    <path d="m18.5 2.5 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                                    </svg>
                                                    Sửa
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/userManagement" method="post"
                                                  onsubmit="return confirm('Bạn có chắc chắn muốn xóa người dùng ${user.username} không?');">
                                                <input type="hidden" name="action" value="deleteUser">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <button type="submit" class="btn btn-danger btn-sm">
                                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <polyline points="3,6 5,6 21,6"/>
                                                    <path d="m19,6v14a2,2 0 0,1-2,2H7a2,2 0 0,1-2-2V6m3,0V4a2,2 0 0,1,2-2h4a2,2 0 0,1,2,2v2"/>
                                                    <line x1="10" y1="11" x2="10" y2="17"/>
                                                    <line x1="14" y1="11" x2="14" y2="17"/>
                                                    </svg>
                                                    Xóa
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- Empty State -->
                    <c:if test="${empty users}">
                        <div class="empty-state">
                            <div class="empty-icon">
                                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                <circle cx="12" cy="7" r="4"/>
                                </svg>
                            </div>
                            <h3 class="empty-title">Không tìm thấy người dùng</h3>
                            <p class="empty-description">Không có người dùng nào phù hợp với tiêu chí tìm kiếm của bạn.</p>
                            <button class="btn btn-primary" onclick="clearSearch()">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M3 6h18"/>
                                <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/>
                                <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/>
                                </svg>
                                Xóa bộ lọc
                            </button>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Toast Notification -->
        <div class="toast toast-success" id="toast">
            <div class="toast-icon">✓</div>
            <div class="toast-message">Thao tác thành công!</div>
        </div>

        <script>
            function clearSearch() {
                document.getElementById('username').value = '';
                document.getElementById('status').value = '';
                window.location.href = '${pageContext.request.contextPath}/userManagement';
            }

            function showToast(message, type = 'success') {
                const toast = document.getElementById('toast');
                const toastMessage = toast.querySelector('.toast-message');
                const toastIcon = toast.querySelector('.toast-icon');

                toastMessage.textContent = message;
                toast.className = `toast toast-${type}`;

                if (type === 'success') {
                    toastIcon.textContent = '✓';
                } else if (type === 'error') {
                    toastIcon.textContent = '✕';
                }

                toast.classList.add('show');

                setTimeout(() => {
                    toast.classList.remove('show');
                }, 3000);
            }

            function updateUserCount() {
                const rows = document.querySelectorAll('.users-table tbody tr');
                const count = rows.length;
                const countElement = document.querySelector('.user-count');
                countElement.textContent = count + ' người dùng';

                if (count === 0) {
                    document.querySelector('.table-container .users-table').style.display = 'none';
                    document.querySelector('.empty-state').style.display = 'block';
                } else {
                    document.querySelector('.table-container .users-table').style.display = 'table';
                    document.querySelector('.empty-state').style.display = 'none';
                }
            }

            document.querySelector('.search-form').addEventListener('submit', function (e) {
                const submitBtn = this.querySelector('button[type="submit"]');
                const originalContent = submitBtn.innerHTML;

                submitBtn.innerHTML = '<div class="loading"></div> Đang tìm...';
                submitBtn.disabled = true;

                setTimeout(() => {
                    submitBtn.innerHTML = originalContent;
                    submitBtn.disabled = false;
                    this.submit();
                }, 1500);
            });

            document.addEventListener('DOMContentLoaded', function () {
                updateUserCount();
            });
        </script>
    </body>
</html>