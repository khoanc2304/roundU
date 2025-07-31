<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chỉnh sửa người dùng</title>
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
                max-width: 900px;
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

            .form-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 24px;
                padding: 3rem;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .form-header {
                text-align: center;
                margin-bottom: 3rem;
            }

            .form-icon {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, #f59e0b, #d97706);
                border-radius: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1.5rem;
                box-shadow: 0 10px 25px -5px rgba(245, 158, 11, 0.4);
            }

            .form-title {
                font-size: 2.5rem;
                font-weight: 700;
                color: #1e293b;
                margin-bottom: 0.5rem;
                letter-spacing: -0.025em;
            }

            .form-subtitle {
                font-size: 1.125rem;
                color: #64748b;
                font-weight: 400;
            }

            .user-info-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                background: linear-gradient(135deg, #e0f2fe, #bae6fd);
                color: #0369a1;
                padding: 0.75rem 1.5rem;
                border-radius: 12px;
                font-weight: 500;
                margin-bottom: 2rem;
                border: 1px solid #7dd3fc;
            }

            .error-message {
                background: linear-gradient(135deg, #fee2e2, #fecaca);
                color: #dc2626;
                padding: 1rem 1.5rem;
                border-radius: 12px;
                margin-bottom: 2rem;
                border: 1px solid #fca5a5;
                display: none;
                align-items: center;
                gap: 0.75rem;
                font-weight: 500;
            }

            .error-message.show {
                display: flex;
            }

            .success-message {
                background: linear-gradient(135deg, #dcfce7, #bbf7d0);
                color: #166534;
                padding: 1rem 1.5rem;
                border-radius: 12px;
                margin-bottom: 2rem;
                border: 1px solid #86efac;
                display: none;
                align-items: center;
                gap: 0.75rem;
                font-weight: 500;
            }

            .form-section {
                margin-bottom: 2.5rem;
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
                background: linear-gradient(135deg, #f59e0b, #d97706);
                border-radius: 1px;
            }

            .form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 1.5rem;
            }

            .form-group {
                position: relative;
            }

            .form-label {
                display: block;
                font-size: 0.875rem;
                font-weight: 500;
                color: #374151;
                margin-bottom: 0.5rem;
            }

            .required {
                color: #dc2626;
            }

            .optional {
                color: #6b7280;
                font-weight: 400;
            }

            .input-wrapper {
                position: relative;
            }

            .form-input,
            .form-select {
                width: 100%;
                padding: 1rem 1rem 1rem 3rem;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                font-size: 1rem;
                background: white;
                transition: all 0.3s ease;
                outline: none;
            }

            .form-input:focus,
            .form-select:focus {
                border-color: #f59e0b;
                box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.1);
                transform: translateY(-1px);
            }

            .form-input.error,
            .form-select.error {
                border-color: #dc2626;
                box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
            }

            .form-input.success,
            .form-select.success {
                border-color: #10b981;
                box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
            }

            .input-icon {
                position: absolute;
                left: 1rem;
                top: 50%;
                transform: translateY(-50%);
                width: 1.25rem;
                height: 1.25rem;
                color: #9ca3af;
                transition: color 0.3s ease;
            }

            .form-input:focus + .input-icon,
            .form-select:focus + .input-icon {
                color: #f59e0b;
            }

            .error-text {
                color: #dc2626;
                font-size: 0.875rem;
                margin-top: 0.5rem;
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }

            .success-text {
                color: #10b981;
                font-size: 0.875rem;
                margin-top: 0.5rem;
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }

            .password-note {
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 0.75rem;
                margin-top: 0.5rem;
                font-size: 0.875rem;
                color: #64748b;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .status-indicator {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.25rem 0.75rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .status-active {
                background: #dcfce7;
                color: #166534;
            }

            .status-inactive {
                background: #fee2e2;
                color: #991b1b;
            }

            .membership-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.25rem 0.75rem;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 500;
            }

            .membership-bronze {
                background: #fef3c7;
                color: #92400e;
            }
            .membership-silver {
                background: #f1f5f9;
                color: #475569;
            }
            .membership-gold {
                background: #fef3c7;
                color: #d97706;
            }
            .membership-diamond {
                background: #dbeafe;
                color: #1d4ed8;
            }

            .submit-button {
                width: 100%;
                max-width: 400px;
                margin: 2rem auto 0;
                display: block;
                padding: 1.25rem 2rem;
                background: linear-gradient(135deg, #f59e0b, #d97706);
                color: white;
                border: none;
                border-radius: 12px;
                font-size: 1.125rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 10px 25px -5px rgba(245, 158, 11, 0.4);
                position: relative;
                overflow: hidden;
            }

            .submit-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 15px 35px -5px rgba(245, 158, 11, 0.5);
            }

            .submit-button:active {
                transform: translateY(0);
            }

            .submit-button.loading {
                pointer-events: none;
                opacity: 0.8;
            }

            .loading-spinner {
                display: none;
                width: 1.25rem;
                height: 1.25rem;
                border: 2px solid rgba(255, 255, 255, 0.3);
                border-top: 2px solid white;
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin-right: 0.5rem;
            }

            .submit-button.loading .loading-spinner {
                display: inline-block;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            .tooltip {
                position: absolute;
                bottom: 100%;
                left: 50%;
                transform: translateX(-50%);
                background: #1e293b;
                color: white;
                padding: 0.5rem 0.75rem;
                border-radius: 6px;
                font-size: 0.75rem;
                white-space: nowrap;
                opacity: 0;
                pointer-events: none;
                transition: opacity 0.3s ease;
                margin-bottom: 0.5rem;
                z-index: 10;
            }

            .tooltip::after {
                content: '';
                position: absolute;
                top: 100%;
                left: 50%;
                transform: translateX(-50%);
                border: 4px solid transparent;
                border-top-color: #1e293b;
            }

            .form-group:hover .tooltip {
                opacity: 1;
            }

            @media (max-width: 768px) {
                body {
                    padding: 1rem;
                }

                .form-card {
                    padding: 2rem;
                    border-radius: 16px;
                }

                .form-title {
                    font-size: 2rem;
                }

                .form-grid {
                    grid-template-columns: 1fr;
                }

                .form-input,
                .form-select {
                    padding: 0.875rem 0.875rem 0.875rem 2.5rem;
                }

                .input-icon {
                    left: 0.75rem;
                    width: 1rem;
                    height: 1rem;
                }
            }

            @media (max-width: 480px) {
                .form-card {
                    padding: 1.5rem;
                }

                .form-title {
                    font-size: 1.75rem;
                }

                .back-link {
                    padding: 0.5rem 1rem;
                    font-size: 0.875rem;
                }
            }

            .form-group {
                animation: slideUp 0.6s ease-out forwards;
                opacity: 0;
                transform: translateY(20px);
            }

            .form-group:nth-child(1) {
                animation-delay: 0.1s;
            }
            .form-group:nth-child(2) {
                animation-delay: 0.2s;
            }
            .form-group:nth-child(3) {
                animation-delay: 0.3s;
            }
            .form-group:nth-child(4) {
                animation-delay: 0.4s;
            }
            .form-group:nth-child(5) {
                animation-delay: 0.5s;
            }
            .form-group:nth-child(6) {
                animation-delay: 0.6s;
            }
            .form-group:nth-child(7) {
                animation-delay: 0.7s;
            }
            .form-group:nth-child(8) {
                animation-delay: 0.8s;
            }
            .form-group:nth-child(9) {
                animation-delay: 0.9s;
            }

            @keyframes slideUp {
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .form-select {
                appearance: none;
                background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
                background-position: right 1rem center;
                background-repeat: no-repeat;
                background-size: 1.5em 1.5em;
                padding-right: 3rem;
            }

            .change-indicator {
                position: absolute;
                right: 0.5rem;
                top: 50%;
                transform: translateY(-50%);
                width: 8px;
                height: 8px;
                background: #f59e0b;
                border-radius: 50%;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .form-input.changed + .change-indicator,
            .form-select.changed + .change-indicator {
                opacity: 1;
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

            <div class="form-card">
                <div class="form-header">
                    <div class="form-icon">
                        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="m18.5 2.5 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                    </div>
                    <h1 class="form-title">Chỉnh sửa người dùng</h1>
                    <p class="form-subtitle">Cập nhật thông tin tài khoản người dùng</p>
                </div>

                <div class="user-info-badge">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                    <circle cx="12" cy="7" r="4"/>
                    </svg>
                    <span>Đang chỉnh sửa: <strong>${user.username}</strong></span>
                    <span class="status-indicator ${user.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                        <span style="width: 6px; height: 6px; background: currentColor; border-radius: 50%; display: inline-block;"></span>
                        ${user.status == 'ACTIVE' ? 'Hoạt động' : 'Không hoạt động'}
                    </span>
                    <span class="membership-badge membership-${user.membershipLevel.levelId == 1 ? 'bronze' : user.membershipLevel.levelId == 2 ? 'silver' : user.membershipLevel.levelId == 3 ? 'gold' : user.membershipLevel.levelId == 4 ? 'diamond' : 'standard'}">
                        ${user.membershipLevel.levelId == 1 ? '🥉 Đồng' : user.membershipLevel.levelId == 2 ? '🥈 Bạc' : user.membershipLevel.levelId == 3 ? '🥇 Vàng' : user.membershipLevel.levelId == 4 ? '💎 Kim Cương' : '👤 Tiêu chuẩn'}
                    </span>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="error-message show">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                        </svg>
                        <span>${errorMessage}</span>
                    </div>
                </c:if>

                <div class="success-message" id="successMessage" style="display: none;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                    <polyline points="22,4 12,14.01 9,11.01"/>
                    </svg>
                    <span>Thông tin đã được cập nhật thành công!</span>
                </div>

                <form id="editForm" action="main" method="post">
                    <input type="hidden" name="action" value="editUser">
                    <input type="hidden" name="id" value="${user.userId}">

                    <div class="form-section">
                        <h2 class="section-title">Thông tin tài khoản</h2>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label" for="username">Tên đăng nhập <span class="required">*</span></label>
                                <div class="input-wrapper">
                                    <input type="text" id="username" name="username" class="form-input <c:if test='${errors.username != null}'>error</c:if>'" value="${user.username}" placeholder="Nhập tên đăng nhập" required>
                                        <!-- icon + indicator như cũ -->
                                    </div>
                                <c:if test="${errors.username != null}">
                                    <div class="error-text">${errors.username}</div>
                                </c:if>
                            </div>

                            <!-- PASSWORD FIELD (optional) -->
                            <div class="form-group">
                                <label class="form-label" for="password">Mật khẩu <span class="optional">(tùy chọn)</span></label>
                                <div class="input-wrapper">
                                    <input type="password" id="password" name="password" class="form-input <c:if test='${errors.password != null}'>error</c:if>'" placeholder="Để trống nếu không thay đổi">
                                        <!-- icon + indicator như cũ -->
                                    </div>
                                <c:if test="${errors.password != null}">
                                    <div class="error-text">${errors.password}</div>
                                </c:if>
                            </div>

                            <!-- FULLNAME FIELD -->
                            <div class="form-group">
                                <label class="form-label" for="fullName">Họ và tên <span class="required">*</span></label>
                                <div class="input-wrapper">
                                    <input type="text" id="fullName" name="fullName" class="form-input <c:if test='${errors.fullName != null}'>error</c:if>'" value="${user.fullName}" placeholder="Nhập họ và tên đầy đủ" required>
                                    </div>
                                <c:if test="${errors.fullName != null}">
                                    <div class="error-text">${errors.fullName}</div>
                                </c:if>
                            </div>

                            <!-- EMAIL FIELD -->
                            <div class="form-group">
                                <label class="form-label" for="email">Email <span class="required">*</span></label>
                                <div class="input-wrapper">
                                    <input type="email" id="email" name="email" class="form-input <c:if test='${errors.email != null}'>error</c:if>'" value="${user.email}" placeholder="example@email.com" required>
                                    </div>
                                <c:if test="${errors.email != null}">
                                    <div class="error-text">${errors.email}</div>
                                </c:if>
                            </div>

                            <!-- PHONE FIELD -->
                            <div class="form-group">
                                <label class="form-label" for="phone">Số điện thoại <span class="required">*</span></label>
                                <div class="input-wrapper">
                                    <input type="text" id="phone" name="phone" class="form-input <c:if test='${errors.phone != null}'>error</c:if>'" value="${user.phone}" placeholder="0123456789" required>
                                    </div>
                                <c:if test="${errors.phone != null}">
                                    <div class="error-text">${errors.phone}</div>
                                </c:if>
                            </div>

                            <!-- ADDRESS FIELD -->
                            <div class="form-group">
                                <label class="form-label" for="address">Địa chỉ <span class="required">*</span></label>
                                <div class="input-wrapper">
                                    <input type="text" id="address" name="address" class="form-input <c:if test='${errors.address != null}'>error</c:if>'" value="${user.address}" placeholder="Nhập địa chỉ hiện tại" required>
                                    </div>
                                <c:if test="${errors.address != null}">
                                    <div class="error-text">${errors.address}</div>
                                </c:if>
                            </div>

                            <!-- ROLE FIELD -->
                            <div class="form-group">
                                <label class="form-label" for="role">Vai trò <span class="required">*</span></label>
                                <div class="input-wrapper">
                                    <select id="role" name="role" class="form-select <c:if test='${errors.role != null}'>error</c:if>'" required>
                                            <option value="">-- Chọn vai trò --</option>
                                            <option value="ADMIN" <c:if test='${user.role == "ADMIN"}'>selected</c:if>>Quản trị viên</option>
                                        <option value="STAFF" <c:if test='${user.role == "STAFF"}'>selected</c:if>>Nhân viên</option>
                                        <option value="CUSTOMER" <c:if test='${user.role == "CUSTOMER"}'>selected</c:if>>Khách hàng</option>
                                        </select>
                                    </div>
                                <c:if test="${errors.role != null}">
                                    <div class="error-text">${errors.role}</div>
                                </c:if>
                            </div>

                            <!-- STATUS FIELD -->
                            <div class="form-group">
                                <label class="form-label" for="status">Trạng thái <span class="required">*</span></label>
                                <div class="input-wrapper">
                                    <select id="status" name="status" class="form-select">
                                        <option value="">-- Chọn trạng thái --</option>
                                        <option value="ACTIVE" <c:if test='${user.status == "ACTIVE"}'>selected</c:if>>Hoạt động</option>
                                        <option value="INACTIVE" <c:if test='${user.status == "INACTIVE"}'>selected</c:if>>Không hoạt động</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- MEMBERSHIP LEVEL FIELD -->
                                <div class="form-group">
                                    <label class="form-label" for="membershipLevelId">Cấp độ thành viên <span class="required">*</span></label>
                                    <div class="input-wrapper">
                                        <select id="membershipLevelId" name="membershipLevelId" class="form-select">
                                            <option value="">-- Chọn cấp độ thành viên --</option>
                                            <option value="1" <c:if test="${user.membershipLevel.levelId == 1}">selected</c:if>>🥉 Đồng</option>
                                        <option value="2" <c:if test="${user.membershipLevel.levelId == 2}">selected</c:if>>🥈 Bạc</option>
                                        <option value="3" <c:if test="${user.membershipLevel.levelId == 3}">selected</c:if>>🥇 Vàng</option>
                                        <option value="4" <c:if test="${user.membershipLevel.levelId == 4}">selected</c:if>>💎 Kim Cương</option>
                                        <option value="5" <c:if test="${user.membershipLevel.levelId == 5}">selected</c:if>>👤 Tiêu Chuẩn</option>
                                        </select>
                                    </div>
                                </div>

                                <button type="submit" class="submit-button" id="submitBtn">
                                    <div class="loading-spinner"></div>
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 0.5rem;">
                                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                                    <polyline points="17,21 17,13 7,13 7,21"/>
                                    <polyline points="7,3 7,8 15,8"/>
                                    </svg>
                                    <span id="submitText">Lưu thay đổi</span>
                                </button>
                                </form>
                            </div>
                        </div>

                        <script>
                            const form = document.getElementById('editForm');

                            form.addEventListener('submit', function (e) {
                                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                const phoneRegex = /^\d{10,11}$/;
                                let isValid = true;

                                document.querySelectorAll('.form-group').forEach(group => {
                                    const input = group.querySelector('input, select');
                                    const errorDiv = group.querySelector('.error-text');

                                    if (input.required && !input.value.trim()) {
                                        input.classList.add('error');
                                        errorDiv.textContent = `${input.name} là bắt buộc.`;
                                        errorDiv.style.display = 'flex';
                                        isValid = false;
                                    } else if (input.name === 'email' && !emailRegex.test(input.value)) {
                                        input.classList.add('error');
                                        errorDiv.textContent = 'Email không hợp lệ.';
                                        errorDiv.style.display = 'flex';
                                        isValid = false;
                                    } else if (input.name === 'phone' && !phoneRegex.test(input.value)) {
                                        input.classList.add('error');
                                        errorDiv.textContent = 'Số điện thoại phải gồm 10-11 chữ số.';
                                        errorDiv.style.display = 'flex';
                                        isValid = false;
                                    } else {
                                        input.classList.remove('error');
                                        errorDiv.style.display = 'none';
                                    }
                                });

                                if (!isValid) {
                                    e.preventDefault(); // Nếu không hợp lệ thì chặn submit
                                    return;
                                }

                                const btn = document.getElementById('submitBtn');
                                btn.classList.add('loading');
                                btn.disabled = true;
                            });
                    </script>

                    </body>
                    </html>