<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Xem chi tiết thông tin người dùng với giao diện xanh trắng sáng, hiện đại">
        <title>Chi tiết người dùng</title>
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
                padding: 2rem 1rem;
                color: #334155;
            }

            .container {
                max-width: 1000px;
                margin: 0 auto;
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1.5rem;
                background: rgba(255, 255, 255, 0.9);
                color: #475569;
                text-decoration: none;
                border-radius: 12px;
                font-weight: 500;
                margin-bottom: 2rem;
                transition: all 0.3s ease;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            }

            .back-link:hover {
                background: white;
                transform: translateY(-2px);
                box-shadow: 0 8px 25px -5px rgba(0, 0, 0, 0.1);
            }

            .profile-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 24px;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
                border: 1px solid rgba(255, 255, 255, 0.2);
                overflow: hidden;
            }

            .profile-header {
                background: linear-gradient(135deg, #3b82f6, #1d4ed8);
                padding: 2rem;
                text-align: center;
                color: white;
                position: relative;
            }

            .profile-header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.1'%3E%3Ccircle cx='30' cy='30' r='2'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E") repeat;
                opacity: 0.3;
            }

            .avatar {
                width: 120px;
                height: 120px;
                background: linear-gradient(135deg, #60a5fa, #3b82f6);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1.5rem;
                box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3);
                position: relative;
                z-index: 1;
            }

            .profile-name {
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
                position: relative;
                z-index: 1;
            }

            .profile-role {
                font-size: 1.125rem;
                opacity: 0.9;
                position: relative;
                z-index: 1;
            }

            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-size: 0.875rem;
                font-weight: 500;
                margin-top: 1rem;
                position: relative;
                z-index: 1;
            }

            .status-active {
                background: rgba(34, 197, 94, 0.2);
                color: #ffffff;
                border: 1px solid rgba(34, 197, 94, 0.3);
            }

            .status-inactive {
                background: rgba(239, 68, 68, 0.2);
                color: #ffffff;
                border: 1px solid rgba(239, 68, 68, 0.3);
            }

            .profile-content {
                padding: 2rem;
            }

            .section {
                margin-bottom: 2.5rem;
            }

            .section:last-child {
                margin-bottom: 0;
            }

            .section-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 1.5rem;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #e2e8f0;
                position: relative;
            }

            .section-title::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 60px;
                height: 2px;
                background: linear-gradient(135deg, #3b82f6, #1d4ed8);
                border-radius: 1px;
            }

            .details-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 1.5rem;
            }

            .detail-item {
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                padding: 1.25rem;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .detail-item:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px -5px rgba(0, 0, 0, 0.1);
                border-color: #3b82f6;
            }

            .detail-item::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 4px;
                height: 100%;
                background: linear-gradient(135deg, #3b82f6, #1d4ed8);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .detail-item:hover::before {
                opacity: 1;
            }

            .detail-icon {
                width: 2rem;
                height: 2rem;
                background: linear-gradient(135deg, #dbeafe, #bfdbfe);
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 0.75rem;
                color: #3b82f6;
            }

            .detail-label {
                font-size: 0.875rem;
                font-weight: 500;
                color: #64748b;
                margin-bottom: 0.5rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .detail-value {
                font-size: 1rem;
                font-weight: 600;
                color: #1e293b;
                word-break: break-word;
            }

            .detail-value.masked {
                font-family: monospace;
                letter-spacing: 0.1em;
                color: #64748b;
            }

            .membership-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-size: 0.875rem;
                font-weight: 500;
            }

            .membership-bronze {
                background: linear-gradient(135deg, #fef3c7, #fde68a);
                color: #92400e;
                border: 1px solid #f59e0b;
            }

            .membership-silver {
                background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
                color: #475569;
                border: 1px solid #94a3b8;
            }

            .membership-gold {
                background: linear-gradient(135deg, #fef3c7, #fbbf24);
                color: #d97706;
                border: 1px solid #f59e0b;
            }

            .membership-diamond {
                background: linear-gradient(135deg, #dbeafe, #93c5fd);
                color: #1d4ed8;
                border: 1px solid #3b82f6;
            }

            .timestamp {
                color: #64748b;
                font-size: 0.875rem;
            }

            .error-message {
                background: linear-gradient(135deg, #fee2e2, #fecaca);
                color: #dc2626;
                padding: 1rem 1.5rem;
                border-radius: 12px;
                margin-bottom: 2rem;
                border: 1px solid #fca5a5;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                font-weight: 500;
            }

            .error-message.show {
                display: flex;
            }

            .action-buttons {
                display: flex;
                gap: 1rem;
                justify-content: center;
                margin-top: 2rem;
                padding-top: 2rem;
                border-top: 1px solid #e2e8f0;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1.5rem;
                border-radius: 12px;
                font-weight: 500;
                text-decoration: none;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
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

            .btn-secondary {
                background: white;
                color: #64748b;
                border: 1px solid #e2e8f0;
            }

            .btn-secondary:hover {
                background: #f8fafc;
                border-color: #cbd5e1;
                transform: translateY(-1px);
            }

            @media (max-width: 768px) {
                body {
                    padding: 1rem;
                }

                .profile-header {
                    padding: 1.5rem;
                }

                .avatar {
                    width: 100px;
                    height: 100px;
                }

                .profile-name {
                    font-size: 1.75rem;
                }

                .profile-content {
                    padding: 1.5rem;
                }

                .details-grid {
                    grid-template-columns: 1fr;
                }

                .action-buttons {
                    flex-direction: column;
                }
            }

            @media (max-width: 480px) {
                .profile-header {
                    padding: 1rem;
                }

                .profile-name {
                    font-size: 1.5rem;
                }

                .profile-content {
                    padding: 1rem;
                }

                .detail-item {
                    padding: 1rem;
                }

                .back-link {
                    padding: 0.5rem 1rem;
                    font-size: 0.875rem;
                }
            }

            .detail-item {
                animation: slideUp 0.6s ease-out forwards;
                opacity: 0;
                transform: translateY(20px);
            }

            .detail-item:nth-child(1) {
                animation-delay: 0.1s;
            }
            .detail-item:nth-child(2) {
                animation-delay: 0.2s;
            }
            .detail-item:nth-child(3) {
                animation-delay: 0.3s;
            }
            .detail-item:nth-child(4) {
                animation-delay: 0.4s;
            }
            .detail-item:nth-child(5) {
                animation-delay: 0.5s;
            }
            .detail-item:nth-child(6) {
                animation-delay: 0.6s;
            }
            .detail-item:nth-child(7) {
                animation-delay: 0.7s;
            }
            .detail-item:nth-child(8) {
                animation-delay: 0.8s;
            }

            @keyframes slideUp {
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="${ProjectPaths.HREF_TO_USERMANAGEMENT}" class="back-link">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="m15 18-6-6 6-6"/>
                </svg>
                Quay lại danh sách
            </a>

            <div class="profile-card">
                <div class="profile-header">
                    <div class="avatar">
                        <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                        </svg>
                    </div>
                    <h1 class="profile-name">${user.fullName}</h1>
                    <p class="profile-role">${user.role == 'ADMIN' ? 'Quản trị viên' : user.role == 'STAFF' ? 'Nhân viên' : 'Khách hàng'}</p>
                    <div class="status-badge ${user.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                        <span style="width: 8px; height: 8px; background: ${user.status == 'ACTIVE' ? '#22c55e' : '#ef4444'}; border-radius: 50%; display: inline-block;"></span>
                        ${user.status == 'ACTIVE' ? 'Hoạt động' : 'Không hoạt động'}
                    </div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="error-message show" id="errorMessage">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                        </svg>
                        <span>${errorMessage}</span>
                    </div>
                </c:if>

                <div class="profile-content">
                    <div class="section">
                        <h2 class="section-title">Thông tin cơ bản</h2>
                        <div class="details-grid">
                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M16 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                    <circle cx="12" cy="7" r="4"/>
                                    </svg>
                                </div>
                                <div class="detail-label">ID người dùng</div>
                                <div class="detail-value">${user.userId}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                    <circle cx="12" cy="7" r="4"/>
                                    </svg>
                                </div>
                                <div class="detail-label">Tên đăng nhập</div>
                                <div class="detail-value">${user.username}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                    <circle cx="12" cy="16" r="1"/>
                                    <path d="m7 11V7a5 5 0 0 1 10 0v4"/>
                                    </svg>
                                </div>
                                <div class="detail-label">Mật khẩu</div>
                                <div class="detail-value masked">••••••••••</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                                    <circle cx="8.5" cy="7" r="4"/>
                                    <path d="m20 8-6 6"/>
                                    <path d="m14 8 6 6"/>
                                    </svg>
                                </div>
                                <div class="detail-label">Họ và tên</div>
                                <div class="detail-value">${user.fullName}</div>
                            </div>
                        </div>
                    </div>

                    <div class="section">
                        <h2 class="section-title">Thông tin liên hệ</h2>
                        <div class="details-grid">
                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                                    <polyline points="22,6 12,13 2,6"/>
                                    </svg>
                                </div>
                                <div class="detail-label">Email</div>
                                <div class="detail-value">${user.email}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
                                    </svg>
                                </div>
                                <div class="detail-label">Số điện thoại</div>
                                <div class="detail-value">${user.phone}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
                                    <circle cx="12" cy="10" r="3"/>
                                    </svg>
                                </div>
                                <div class="detail-label">Địa chỉ</div>
                                <div class="detail-value">${user.address}</div>
                            </div>
                        </div>
                    </div>

                    <div class="section">
                        <h2 class="section-title">Cài đặt tài khoản</h2>
                        <div class="details-grid">
                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M9 12l2 2 4-4"/>
                                    <path d="M21 12c.552 0 1-.448 1-1V5c0-.552-.448-1-1-1H3c-.552 0-1 .448-1 1v6c0 .552.448 1 1 1h18z"/>
                                    <path d="M21 16H3c-.552 0-1 .448-1 1v2c0 .552.448 1 1 1h18c.552 0 1-.448 1-1v-2c0-.552-.448-1-1-1z"/>
                                    </svg>
                                </div>
                                <div class="detail-label">Vai trò</div>
                                <div class="detail-value">${user.role == 'ADMIN' ? 'Quản trị viên' : user.role == 'STAFF' ? 'Nhân viên' : 'Khách hàng'}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polygon points="12,2 15.09,8.26 22,9.27 17,14.14 18.18,21.02 12,17.77 5.82,21.02 7,14.14 2,9.27 8.91,8.26"/>
                                    </svg>
                                </div>
                                <div class="detail-label">Cấp độ thành viên</div>
                                <div class="detail-value">
                                    <span class="membership-badge membership-${user.membershipLevel.levelId == 1 ? 'bronze' : user.membershipLevel.levelId == 2 ? 'silver' : user.membershipLevel.levelId == 3 ? 'gold' : 'diamond'}">
                                        <c:choose>
                                            <c:when test="${not empty user.membershipLevel}">
                                                ${user.membershipLevel.levelId == 1 ? '🥉 Đồng' : user.membershipLevel.levelId == 2 ? '🥈 Bạc' : user.membershipLevel.levelId == 3 ? '🥇 Vàng' : '💎 Kim Cương'}
                                            </c:when>
                                            <c:otherwise>
                                                Không có cấp độ
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"/>
                                    <path d="M9 12l2 2 4-4"/>
                                    </svg>
                                </div>
                                <div class="detail-label">Trạng thái</div>
                                <div class="detail-value">
                                    <span class="status-badge ${user.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                        <span style="width: 6px; height: 6px; background: ${user.status == 'ACTIVE' ? '#22c55e' : '#ef4444'}; border-radius: 50%; display: inline-block;"></span>
                                        ${user.status == 'ACTIVE' ? 'Hoạt động' : 'Không hoạt động'}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="section">
                        <h2 class="section-title">Thông tin thời gian</h2>
                        <div class="details-grid">
                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"/>
                                    <polyline points="12,6 12,12 16,14"/>
                                    </svg>
                                </div>
                                <div class="detail-label">Ngày tạo</div>
                                <div class="detail-value timestamp">${user.createdAt}</div>
                            </div>

                            <div class="detail-item">
                                <div class="detail-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                    <path d="m18.5 2.5 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                                    </svg>
                                </div>
                                <div class="detail-label">Cập nhật lần cuối</div>
                                <div class="detail-value timestamp">${user.updatedAt}</div>
                            </div>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/userManagement?action=editForm&id=${user.userId}" class="btn btn-primary">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                            <path d="m18.5 2.5 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                            </svg>
                            Chỉnh sửa
                        </a>

                        <button class="btn btn-secondary" onclick="window.print()">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="6,9 6,2 18,2 18,9"/>
                            <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/>
                            <rect x="6" y="14" width="12" height="8"/>
                            </svg>
                            In thông tin
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                setTimeout(() => {
                    document.querySelectorAll('.detail-item').forEach((item, index) => {
                        item.style.animationDelay = `${index * 0.1}s`;
                    });
                }, 100);

                document.querySelectorAll('.detail-value').forEach(element => {
                    const text = element.textContent.trim();
                    if (text.includes('@') || text.match(/^\d{10,11}$/)) {
                        element.style.cursor = 'pointer';
                        element.title = 'Click để sao chép';

                        element.addEventListener('click', function () {
                            navigator.clipboard.writeText(text).then(() => {
                                const originalText = text;
                                this.textContent = 'Đã sao chép!';
                                this.style.color = '#22c55e';

                                setTimeout(() => {
                                    this.textContent = originalText;
                                    this.style.color = '';
                                }, 2000);
                            });
                        });
                    }
                });
            });
        </script>
    </body>
</html>