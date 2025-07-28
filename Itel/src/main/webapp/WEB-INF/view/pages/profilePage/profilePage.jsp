<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông tin cá nhân - TourismApp</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            /* Reset và Base Styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: #334155;
                line-height: 1.6;
            }

            /* Container */
            .container {
                max-width: 1000px;
                margin: 0 auto;
                /*            padding: 10px 1rem 2rem;*/
            }

            /* Profile Card */
            .profile-card {
                margin-bottom: 100px;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 24px;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
                border: 1px solid rgba(255, 255, 255, 0.2);
                overflow: hidden;
                animation: slideUp 0.8s ease-out;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Profile Header */
            .profile-header {
                background: linear-gradient(135deg, #3b82f6, #1d4ed8);
                padding: 3rem 2rem;
                text-align: center;
                color: white;
                position: relative;
                overflow: hidden;
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
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1.5rem;
                box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3);
                position: relative;
                z-index: 1;
                border: 4px solid rgba(255, 255, 255, 0.3);
                transition: transform 0.3s ease;
                cursor: pointer;
            }

            .avatar:hover {
                transform: scale(1.05);
            }

            .profile-name {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
                position: relative;
                z-index: 1;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .profile-role {
                font-size: 1.25rem;
                opacity: 0.9;
                margin-bottom: 1rem;
                position: relative;
                z-index: 1;
                font-weight: 500;
            }

            /* Status Badge */
            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1.5rem;
                border-radius: 25px;
                font-size: 0.875rem;
                font-weight: 500;
                position: relative;
                z-index: 1;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
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

            /* Profile Content */
            .profile-content {
                padding: 2.5rem;
            }

            /* Section */
            .section {
                margin-bottom: 3rem;
            }

            .section:last-child {
                margin-bottom: 0;
            }

            .section-title {
                font-size: 1.5rem;
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 1.5rem;
                padding-bottom: 0.75rem;
                border-bottom: 2px solid #e2e8f0;
                position: relative;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .section-title::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 80px;
                height: 2px;
                background: linear-gradient(135deg, #3b82f6, #1d4ed8);
                border-radius: 1px;
            }

            .section-icon {
                width: 24px;
                height: 24px;
                color: #3b82f6;
            }

            /* Details Grid */
            .details-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 1.5rem;
            }

            /* Detail Item */
            .detail-item {
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 16px;
                padding: 1.5rem;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                animation: fadeInUp 0.6s ease-out forwards;
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

            @keyframes fadeInUp {
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .detail-item:hover {
                transform: translateY(-4px);
                box-shadow: 0 12px 25px -5px rgba(0, 0, 0, 0.15);
                border-color: #3b82f6;
                background: #ffffff;
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
                width: 2.5rem;
                height: 2.5rem;
                background: linear-gradient(135deg, #dbeafe, #bfdbfe);
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 1rem;
                color: #3b82f6;
            }

            .detail-label {
                font-size: 0.875rem;
                font-weight: 500;
                color: #64748b;
                margin-bottom: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .detail-value {
                font-size: 1.125rem;
                font-weight: 600;
                color: #1e293b;
                word-break: break-word;
                line-height: 1.5;
                transition: color 0.3s ease;
            }

            .detail-value.clickable {
                cursor: pointer;
                position: relative;
            }

            .detail-value.clickable:hover {
                color: #3b82f6;
            }

            .detail-value.clickable::after {
                content: '📋';
                position: absolute;
                right: -25px;
                top: 50%;
                transform: translateY(-50%);
                opacity: 0;
                transition: opacity 0.3s ease;
                font-size: 0.875rem;
            }

            .detail-value.clickable:hover::after {
                opacity: 1;
            }

            /* Membership Badge */
            .membership-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1.25rem;
                border-radius: 25px;
                font-size: 1rem;
                font-weight: 500;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease;
            }

            .membership-badge:hover {
                transform: scale(1.05);
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

            /* Timestamp */
            .timestamp {
                color: #64748b;
                font-size: 1rem;
                font-weight: 500;
                font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
                background: #f1f5f9;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                display: inline-block;
            }

            /* Action Buttons */
            .action-buttons {
                display: flex;
                gap: 1rem;
                justify-content: center;
                margin-top: 2.5rem;
                padding-top: 2rem;
                border-top: 1px solid #e2e8f0;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.875rem 1.75rem;
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

            /* Toast Notification */
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

            .toast-icon {
                width: 20px;
                height: 20px;
                border-radius: 50%;
                background: #22c55e;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.75rem;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .container {
                    padding: 120px 1rem 2rem;
                }

                .profile-header {
                    padding: 2rem 1rem;
                }

                .avatar {
                    width: 100px;
                    height: 100px;
                }

                .profile-name {
                    font-size: 2rem;
                }

                .profile-content {
                    padding: 1.5rem;
                }

                .details-grid {
                    grid-template-columns: 1fr;
                }

                .section-title {
                    font-size: 1.25rem;
                }

                .action-buttons {
                    flex-direction: column;
                }
            }

            @media (max-width: 480px) {
                .profile-header {
                    padding: 1.5rem 1rem;
                }

                .profile-name {
                    font-size: 1.75rem;
                }

                .profile-content {
                    padding: 1rem;
                }

                .detail-item {
                    padding: 1rem;
                }

                .detail-value.clickable::after {
                    display: none;
                }
            }

            /* Loading Animation */
            .loading {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 3px solid rgba(59, 130, 246, 0.3);
                border-radius: 50%;
                border-top-color: #3b82f6;
                animation: spin 1s ease-in-out infinite;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }

            /* Smooth Scrolling */
            html {
                scroll-behavior: smooth;
            }

            /* Focus States for Accessibility */
            .detail-value.clickable:focus {
                outline: 2px solid #3b82f6;
                outline-offset: 2px;
                border-radius: 4px;
            }

            /* Custom Scrollbar */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: #f1f5f9;
            }

            ::-webkit-scrollbar-thumb {
                background: linear-gradient(135deg, #3b82f6, #1d4ed8);
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: linear-gradient(135deg, #1d4ed8, #1e40af);
            }
        </style>
    </head>
</html>
<%-- Navbar --%>
<jsp:include page="/WEB-INF/view/components/navbar.jsp"/>

<div class="container" style="padding-top: 120px;">
    <div class="profile-card">
        <!-- Profile Header -->
        <div class="profile-header">
            <div class="avatar" onclick="changeAvatar()">
                <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
                </svg>
            </div>
            <h1 class="profile-name">${user.fullName}</h1>
            <p class="profile-role">
                <c:choose>
                    <c:when test="${user.role == 'ADMIN'}">Quản trị viên</c:when>
                    <c:when test="${user.role == 'STAFF'}">Nhân viên</c:when>
                    <c:otherwise>Khách hàng</c:otherwise>
                </c:choose>
            </p>
            <div class="status-badge ${user.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                <span style="width: 8px; height: 8px; background: ${user.status == 'ACTIVE' ? '#22c55e' : '#ef4444'}; border-radius: 50%; display: inline-block;"></span>
                ${user.status == 'ACTIVE' ? 'Hoạt động' : 'Không hoạt động'}
            </div>
        </div>

        <!-- Profile Content -->
        <div class="profile-content">
            <!-- Personal Information -->
            <div class="section">
                <h2 class="section-title">
                    <svg class="section-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                    <circle cx="12" cy="7" r="4"/>
                    </svg>
                    Thông tin cá nhân
                </h2>
                <div class="details-grid">
                    <div class="detail-item">
                        <div class="detail-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                            </svg>
                        </div>
                        <div class="detail-label">Tên đăng nhập</div>
                        <div class="detail-value">${user.username}</div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="8.5" cy="7" r="4"/>
                            <path d="m20 8-6 6"/>
                            <path d="m14 8 6 6"/>
                            </svg>
                        </div>
                        <div class="detail-label">Họ và tên</div>
                        <div class="detail-value">${user.fullName}</div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                            <polyline points="22,6 12,13 2,6"/>
                            </svg>
                        </div>
                        <div class="detail-label">Email</div>
                        <div class="detail-value clickable" data-copy="${user.email}">${user.email}</div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
                            </svg>
                        </div>
                        <div class="detail-label">Số điện thoại</div>
                        <div class="detail-value clickable" data-copy="${user.phone}">${user.phone}</div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
                            <circle cx="12" cy="10" r="3"/>
                            </svg>
                        </div>
                        <div class="detail-label">Địa chỉ</div>
                        <div class="detail-value">${user.address}</div>
                    </div>
                </div>
            </div>

            <!-- Account Information -->
            <div class="section">
                <h2 class="section-title">
                    <svg class="section-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M9 12l2 2 4-4"/>
                    <path d="M21 12c.552 0 1-.448 1-1V5c0-.552-.448-1-1-1H3c-.552 0-1 .448-1 1v6c0 .552.448 1 1 1h18z"/>
                    <path d="M21 16H3c-.552 0-1 .448-1 1v2c0 .552.448 1 1 1h18c.552 0 1-.448 1-1v-2c0-.552-.448-1-1-1z"/>
                    </svg>
                    Tài khoản
                </h2>
                <div class="details-grid">
                    <div class="detail-item">
                        <div class="detail-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M9 12l2 2 4-4"/>
                            <path d="M21 12c.552 0 1-.448 1-1V5c0-.552-.448-1-1-1H3c-.552 0-1 .448-1 1v6c0 .552.448 1 1 1h18z"/>
                            <path d="M21 16H3c-.552 0-1 .448-1 1v2c0 .552.448 1 1 1h18c.552 0 1-.448 1-1v-2c0-.552-.448-1-1-1z"/>
                            </svg>
                        </div>
                        <div class="detail-label">Vai trò</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${user.role == 'ADMIN'}">Quản trị viên</c:when>
                                <c:when test="${user.role == 'STAFF'}">Nhân viên</c:when>
                                <c:otherwise>Khách hàng</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polygon points="12,2 15.09,8.26 22,9.27 17,14.14 18.18,21.02 12,17.77 5.82,21.02 7,14.14 2,9.27 8.91,8.26"/>
                            </svg>
                        </div>
                        <div class="detail-label">Cấp độ thành viên</div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${not empty user.membershipLevel}">
                                    <span class="membership-badge membership-${user.membershipLevel.levelId == 1 ? 'bronze' : user.membershipLevel.levelId == 2 ? 'silver' : user.membershipLevel.levelId == 3 ? 'gold' : 'diamond'}">
                                        <c:choose>
                                            <c:when test="${user.membershipLevel.levelId == 1}">🥉 Đồng</c:when>
                                            <c:when test="${user.membershipLevel.levelId == 2}">🥈 Bạc</c:when>
                                            <c:when test="${user.membershipLevel.levelId == 3}">🥇 Vàng</c:when>
                                            <c:when test="${user.membershipLevel.levelId == 4}">💎 Kim Cương</c:when>
                                            <c:otherwise>Tiêu chuẩn</c:otherwise>
                                        </c:choose>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="membership-badge membership-bronze">🥉 Đồng</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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

            <!-- Time Information -->
            <div class="section">
                <h2 class="section-title">
                    <svg class="section-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"/>
                    <polyline points="12,6 12,12 16,14"/>
                    </svg>
                    Thông tin thời gian
                </h2>
                <div class="details-grid">
                    <div class="detail-item">
                        <div class="detail-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <polyline points="12,6 12,12 16,14"/>
                            </svg>
                        </div>
                        <div class="detail-label">Ngày tạo</div>
                        <div class="detail-value timestamp">${user.createdAt}</div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-icon">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                            <path d="m18.5 2.5 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                            </svg>
                        </div>
                        <div class="detail-label">Cập nhật gần nhất</div>
                        <div class="detail-value timestamp">${user.updatedAt}</div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/profilePage?action=editProfile" class="btn btn-primary">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                    <path d="m18.5 2.5 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                    Chỉnh sửa thông tin
                </a>

                <a href="<%= ProjectPaths.HREF_TO_CHANGEPASSWORD %>" class="btn btn-secondary">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                    <circle cx="12" cy="16" r="1"/>
                    <path d="m7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    Đổi mật khẩu
                </a>


            </div>

        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/view/components/footer.jsp" />

<!-- Toast Notification -->
<div class="toast toast-success" id="toast">
    <div class="toast-icon">✓</div>
    <div class="toast-message">Đã sao chép thành công!</div>
</div>

<script>
    // Copy to clipboard functionality
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.detail-value.clickable').forEach(element => {
            element.title = 'Click để sao chép';

            element.addEventListener('click', function () {
                const text = this.getAttribute('data-copy') || this.textContent.trim();

                if (navigator.clipboard) {
                    navigator.clipboard.writeText(text).then(() => {
                        showToast('Đã sao chép: ' + text);

                        // Visual feedback
                        const original = this.textContent;
                        const originalColor = this.style.color;
                        this.textContent = 'Đã sao chép!';
                        this.style.color = '#22c55e';

                        setTimeout(() => {
                            this.textContent = original;
                            this.style.color = originalColor;
                        }, 2000);
                    }).catch(() => {
                        showToast('Không thể sao chép', 'error');
                    });
                } else {
                    // Fallback for older browsers
                    const textArea = document.createElement('textarea');
                    textArea.value = text;
                    document.body.appendChild(textArea);
                    textArea.select();
                    try {
                        document.execCommand('copy');
                        showToast('Đã sao chép: ' + text);
                    } catch (err) {
                        showToast('Không thể sao chép', 'error');
                    }
                    document.body.removeChild(textArea);
                }
            });
        });
    });

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


    function changeAvatar() {
        // Future implementation for avatar upload
        showToast('Tính năng thay đổi ảnh đại diện sẽ được cập nhật sớm!', 'info');
    }

    // Add some interactivity
    document.addEventListener('DOMContentLoaded', function () {
        // Animate detail items on scroll
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.animationPlayState = 'running';
                }
            });
        });

        document.querySelectorAll('.detail-item').forEach(item => {
            observer.observe(item);
        });

        // Add keyboard navigation for clickable elements
        document.querySelectorAll('.detail-value.clickable').forEach(element => {
            element.setAttribute('tabindex', '0');
            element.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    this.click();
                }
            });
        });
    });

    // Add loading state for buttons
    document.querySelectorAll('.btn').forEach(btn => {
        btn.addEventListener('click', function (e) {
            if (this.classList.contains('btn-primary')) {
                const originalContent = this.innerHTML;
                this.innerHTML = '<div class="loading"></div> Đang xử lý...';
                this.disabled = true;

                // Re-enable after navigation (this won't execute if page changes)
                setTimeout(() => {
                    this.innerHTML = originalContent;
                    this.disabled = false;
                }, 2000);
            }
        });
    });
</script>
</body>
</html>