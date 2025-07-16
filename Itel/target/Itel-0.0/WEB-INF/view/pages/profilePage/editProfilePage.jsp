<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa thông tin cá nhân - TourismApp</title>
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
/*            padding: 120px 1rem 2rem;*/
        }

        /* Form Card */
        .form-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            border: 1px solid rgba(255, 255, 255, 0.2);
            overflow: hidden;
            animation: slideUp 0.8s ease-out;
            margin-bottom: 100px;
        }

        @keyframes slideUp {
            from Glas from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Form Header */
        .form-header {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            padding: 3rem 2rem;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .form-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.1'%3E%3Ccircle cx='30' cy='30' r='2'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E") repeat;
            opacity: 0.3;
        }

        .form-icon {
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
        }

        .form-icon:hover {
            transform: scale(1.05);
        }

        .form-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            z-index: 1;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .form-subtitle {
            font-size: 1.25rem;
            opacity: 0.9;
            margin-bottom: 1rem;
            position: relative;
            z-index: 1;
            font-weight: 500;
        }

        /* Back Link */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            margin-top: 1rem;
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

        /* Messages */
        .user-info-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            color: #0369a1;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-weight: 500;
            margin-bottom: 2rem;
            border: 1px solid #7dd3fc;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
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
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
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
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .success-message.show {
            display: flex;
        }

        /* Form Section */
        .form-section {
            margin-bottom: 3rem;
            padding: 2.5rem;
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

        /* Form Grid */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        /* Form Group */
        .form-group {
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

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-group:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 25px -5px rgba(0, 0, 0, 0.15);
            border-color: #3b82f6;
            background: #ffffff;
        }

        .form-group::before {
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

        .form-group:hover::before {
            opacity: 1;
        }

        .form-label {
            font-size: 0.875rem;
            font-weight: 500;
            color: #64748b;
            margin-bottom: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .required {
            color: #dc2626;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .form-input {
            width: 100%;
            padding: 0.875rem 0.875rem 0.875rem 3rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 1rem;
            background: white;
            transition: all 0.3s ease;
            outline: none;
        }

        .form-input:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            transform: translateY(-1px);
        }

        .form-input.error {
            border-color: #dc2626;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
        }

        .form-input.success {
            border-color: #10b981;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
        }

        .form-input.changed {
            background: #f8fafc;
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

        .form-input:focus + .input-icon {
            color: #3b82f6;
        }

        .change-indicator {
            position: absolute;
            right: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            width: 8px;
            height: 8px;
            background: #3b82f6;
            border-radius: 50%;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .form-input.changed + .input-icon + .change-indicator {
            opacity: 1;
        }

        .error-text {
            color: #dc2626;
            font-size: 0.875rem;
            margin-top: 0.5rem;
            display: none;
            align-items: center;
            gap: 0.25rem;
        }

        .error-text.show {
            display: flex;
        }

        /* Button Group */
        .button-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2.5rem;
            padding-top: 2rem;
            border-top: 1px solid #e2e8f0;
        }

        .submit-button {
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
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3);
        }

        .submit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px -5px rgba(59, 130, 246, 0.4);
        }

        .submit-button.loading {
            pointer-events: none;
            opacity: 0.8;
        }

        .submit-button.loading .loading-spinner {
            display: inline-block;
        }

        .btn-secondary {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.875rem 1.75rem;
            border-radius: 12px;
            font-weight: 500;
            text-decoration: none;
            border: 1px solid #e2e8f0;
            background: white;
            color: #64748b;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
            transform: translateY(-1px);
        }

        .loading-spinner {
            display: none;
            width: 1.25rem;
            height: 1.25rem;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 120px 1rem 2rem;
            }

            .form-header {
                padding: 2rem 1rem;
            }

            .form-icon {
                width: 100px;
                height: 100px;
            }

            .form-title {
                font-size: 2rem;
            }

            .form-section {
                padding: 1.5rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .section-title {
                font-size: 1.25rem;
            }

            .button-group {
                flex-direction: column;
            }
        }

        @media (max-width: 480px) {
            .form-header {
                padding: 1.5rem 1rem;
            }

            .form-title {
                font-size: 1.75rem;
            }

            .form-section {
                padding: 1rem;
            }

            .form-group {
                padding: 1rem;
            }

            .back-link {
                padding: 0.5rem 1rem;
                font-size: 0.875rem;
            }
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

        /* Smooth Scrolling */
        html {
            scroll-behavior: smooth;
        }

        /* Focus States for Accessibility */
        .form-input:focus {
            outline: 2px solid #3b82f6;
            outline-offset: 2px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/components/navbar.jsp" />

    <div class="container">
        <a href="<%= ProjectPaths.PREFIX_WEB_PATH %>/main?action=viewProfile" class="back-link">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="m15 18-6-6 6-6"/>
            </svg>
            Quay lại hồ sơ
        </a>

        <div class="form-card">
            <div class="form-header">
                <div class="form-icon">
                    <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="m18.5 2.5 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                </div>
                <h1 class="form-title">Chỉnh sửa thông tin cá nhân</h1>
                <p class="form-subtitle">Cập nhật thông tin của bạn để có trải nghiệm tốt nhất</p>
            </div>

            <div class="form-section">
                <div class="user-info-badge">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                    <span>Đang chỉnh sửa: <strong>${user.fullName}</strong></span>
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

                <c:if test="${not empty successMessage}">
                    <div class="success-message show">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                            <polyline points="22,4 12,14.01 9,11.01"/>
                        </svg>
                        <span>${successMessage}</span>
                    </div>
                </c:if>

                <form id="editForm" action="<%= ProjectPaths.PREFIX_WEB_PATH %>/main" method="post">
                    <input type="hidden" name="action" value="updateProfile"/>

                    <h2 class="section-title">
                        <svg class="section-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                        </svg>
                        Thông tin cá nhân
                    </h2>

                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="fullName">
                                Họ và tên <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <input type="text" id="fullName" name="fullName" class="form-input" value="${user.fullName}" placeholder="Nhập họ và tên đầy đủ" required data-original="${user.fullName}">
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                                    <circle cx="8.5" cy="7" r="4"/>
                                    <path d="m20 8-6 6"/>
                                    <path d="m14 8 6 6"/>
                                </svg>
                                <div class="change-indicator"></div>
                            </div>
                            <div class="error-text" id="fullName-error"></div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="email">
                                Email <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <input type="email" id="email" name="email" class="form-input" value="${user.email}" placeholder="example@email.com" required data-original="${user.email}">
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                                    <polyline points="22,6 12,13 2,6"/>
                                </svg>
                                <div class="change-indicator"></div>
                            </div>
                            <div class="error-text" id="email-error"></div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="phone">
                                Số điện thoại <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <input type="text" id="phone" name="phone" class="form-input" value="${user.phone}" placeholder="0123456789" required data-original="${user.phone}">
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
                                </svg>
                                <div class="change-indicator"></div>
                            </div>
                            <div class="error-text" id="phone-error"></div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="address">
                                Địa chỉ <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <input type="text" id="address" name="address" class="form-input" value="${user.address}" placeholder="Nhập địa chỉ hiện tại" required data-original="${user.address}">
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/>
                                    <circle cx="12" cy="10" r="3"/>
                                </svg>
                                <div class="change-indicator"></div>
                            </div>
                            <div class="error-text" id="address-error"></div>
                        </div>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="submit-button" id="submitBtn">
                            <div class="loading-spinner"></div>
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                                <polyline points="17,21 17,13 7,13 7,21"/>
                                <polyline points="7,3 7,8 15,8"/>
                            </svg>
                            <span id="submitText">Lưu thay đổi</span>
                        </button>
                        <a href="<%= ProjectPaths.PREFIX_WEB_PATH %>/main?action=viewProfile" class="btn-secondary">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M18 6L6 18"/>
                                <path d="M6 6l12 12"/>
                            </svg>
                            Hủy
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/components/footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('editForm');
            const submitBtn = document.getElementById('submitBtn');
            const submitText = document.getElementById('submitText');
            const loadingSpinner = submitBtn.querySelector('.loading-spinner');
            const inputs = form.querySelectorAll('input[type="text"], input[type="email"]');
            let hasChanges = false;

            // Validation patterns
            const patterns = {
                fullName: /^[a-zA-ZÀ-ỹ\s]{2,50}$/,
                email: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
                phone: /^[0-9]{10,11}$/,
                address: /^.{5,200}$/
            };

            const messages = {
                fullName: {
                    invalid: 'Tên phải từ 2-50 ký tự, chỉ chứa chữ cái và khoảng trắng'
                },
                email: {
                    invalid: 'Vui lòng nhập email hợp lệ'
                },
                phone: {
                    invalid: 'Số điện thoại phải có 10-11 chữ số'
                },
                address: {
                    invalid: 'Địa chỉ phải từ 5-200 ký tự'
                }
            };

            // Validate input
            function validateInput(input) {
                const name = input.name;
                const value = input.value.trim();
                const pattern = patterns[name];
                const errorEl = document.getElementById(name + '-error');

                if (!value) {
                    input.classList.remove('success', 'error');
                    errorEl.style.display = 'none';
                    errorEl.textContent = '';
                    return false;
                }

                const isValid = pattern.test(value);

                if (isValid) {
                    input.classList.remove('error');
                    input.classList.add('success');
                    errorEl.style.display = 'none';
                    errorEl.textContent = '';
                } else {
                    input.classList.remove('success');
                    input.classList.add('error');
                    errorEl.style.display = 'flex';
                    errorEl.innerHTML = `
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="15" y1="9" x2="9" y2="15"/>
                            <line x1="9" y1="9" x2="15" y2="15"/>
                        </svg>
                        ${messages[name].invalid}
                    `;
                }

                return isValid;
            }

            // Check for changes
            function checkForChanges() {
                hasChanges = false;
                inputs.forEach(input => {
                    if (input.value.trim() !== input.dataset.original) {
                        hasChanges = true;
                        input.classList.add('changed');
                    } else {
                        input.classList.remove('changed');
                    }
                });

                if (hasChanges) {
                    submitBtn.style.background = 'linear-gradient(135deg, #22c55e, #16a34a)';
                    submitText.textContent = 'Lưu thay đổi';
                } else {
                    submitBtn.style.background = 'linear-gradient(135deg, #3b82f6, #1d4ed8)';
                    submitText.textContent = 'Không có thay đổi';
                }
            }

            // Add event listeners
            inputs.forEach(input => {
                input.addEventListener('input', function () {
                    validateInput(this);
                    checkForChanges();
                });

                input.addEventListener('blur', function () {
                    validateInput(this);
                });

                // Add keyboard navigation
                input.setAttribute('tabindex', '0');
                input.addEventListener('keydown', function (e) {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        this.focus();
                    }
                });
            });

            // Form submission
            form.addEventListener('submit', function (e) {
                e.preventDefault();

                let isFormValid = true;
                inputs.forEach(input => {
                    if (!validateInput(input)) {
                        isFormValid = false;
                    }
                });

                const errorMsg = document.querySelector('.error-message') || document.createElement('div');
                errorMsg.className = 'error-message';
                if (!isFormValid) {
                    errorMsg.innerHTML = `
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="12" y1="8" x2="12" y2="12"/>
                            <line x1="12" y1="16" x2="12.01" y2="16"/>
                        </svg>
                        <span>Vui lòng kiểm tra lại thông tin đã nhập</span>
                    `;
                    errorMsg.classList.add('show');
                    if (!errorMsg.parentNode) form.parentNode.insertBefore(errorMsg, form);
                    return;
                }

                if (!hasChanges) {
                    errorMsg.innerHTML = `
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="12" y1="8" x2="12" y2="12"/>
                            <line x1="12" y1="16" x2="12.01" y2="16"/>
                        </svg>
                        <span>Không có thay đổi nào để lưu</span>
                    `;
                    errorMsg.classList.add('show');
                    if (!errorMsg.parentNode) form.parentNode.insertBefore(errorMsg, form);
                    return;
                }

                if (confirm('Bạn có chắc chắn muốn lưu các thay đổi?')) {
                    submitBtn.classList.add('loading');
                    submitBtn.disabled = true;
                    submitText.textContent = 'Đang lưu...';
                    loadingSpinner.style.display = 'inline-block';
                    form.submit();
                }
            });

            // Prevent leaving with unsaved changes
            window.addEventListener('beforeunload', function (e) {
                if (hasChanges) {
                    e.preventDefault();
                    e.returnValue = 'Bạn có thay đổi chưa được lưu. Bạn có chắc chắn muốn rời khỏi trang?';
                }
            });

            // Cancel button confirmation
            document.querySelector('.btn-secondary').addEventListener('click', function (e) {
                if (hasChanges) {
                    if (!confirm('Bạn có thay đổi chưa được lưu. Bạn có chắc chắn muốn hủy?')) {
                        e.preventDefault();
                    }
                }
            });

            // Animate form groups on scroll
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.animationPlayState = 'running';
                    }
                });
            });

            document.querySelectorAll('.form-group').forEach(item => {
                observer.observe(item);
            });

            // Initial validation and change check
            inputs.forEach(input => {
                if (input.value.trim()) {
                    validateInput(input);
                }
            });
            checkForChanges();

            // Show success message if present
            <c:if test="${not empty successMessage}">
                document.querySelector('.success-message').classList.add('show');
            </c:if>
        });
    </script>
</body>
</html>