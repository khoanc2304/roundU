<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Chỉnh sửa thông tin người dùng với giao diện xanh trắng sáng, futuristic và tương tác đỉnh cao">
    <title>Chỉnh sửa người dùng</title>
    <link rel="icon" type="image/png" href="https://example.com/favicon.png">
    <link href="https://fonts.googleapis.com/css2?family=Oxanium:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Oxanium', sans-serif;
            background: linear-gradient(135deg, #e0f2fe, #f8fafc, #bae6fd);
            background-size: 400%;
            animation: gradientFlow 15s ease infinite;
            color: #1e293b;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        @keyframes gradientFlow {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .container {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(15px);
            padding: 3rem;
            border-radius: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 0 30px rgba(0, 179, 255, 0.3), 0 0 50px rgba(0, 196, 204, 0.2);
            max-width: 800px;
            width: 100%;
            animation: glowPulse 3s ease-in-out infinite;
            z-index: 1;
        }

        @keyframes glowPulse {
            0%, 100% { box-shadow: 0 0 30px rgba(0, 179, 255, 0.3), 0 0 50px rgba(0, 196, 204, 0.2); }
            50% { box-shadow: 0 0 50px rgba(0, 179, 255, 0.5), 0 0 70px rgba(0, 196, 204, 0.4); }
        }

        h2 {
            font-weight: 700;
            text-align: center;
            color: #ffffff;
            margin-bottom: 2.5rem;
            font-size: 2rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            text-shadow: 0 0 10px rgba(0, 196, 204, 0.7);
            position: relative;
            white-space: nowrap;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: -0.75rem;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 4px;
            background: linear-gradient(90deg, #00ffcc, #00b3ff, #ff00cc);
            border-radius: 2px;
            animation: neonFlicker 2s ease-in-out infinite;
        }

        @keyframes neonFlicker {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }

        .error-message {
            background: rgba(239, 68, 68, 0.3);
            color: #fef2f2;
            padding: 1rem;
            border-radius: 0.75rem;
            margin-bottom: 2rem;
            text-align: center;
            border: 1px solid rgba(239, 68, 68, 0.5);
            box-shadow: 0 0 15px rgba(239, 68, 68, 0.4);
            animation: errorShake 0.5s ease;
            opacity: 0;
            transform: translateY(-20px);
        }

        .error-message.show {
            opacity: 1;
            transform: translateY(0);
            transition: all 0.5s ease;
        }

        @keyframes errorShake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-8px); }
            75% { transform: translateX(8px); }
        }

        .form-grid {
            display: grid;
            gap: 2rem;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        }

        .form-group {
            position: relative;
            animation: slideInField 0.6s ease-out forwards;
            animation-delay: calc(var(--order) * 0.1s);
            --order: 0;
        }

        @keyframes slideInField {
            from { opacity: 0; transform: translateX(-30px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .form-group svg {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            width: 1.75rem;
            height: 1.75rem;
            fill: #00ffcc;
            transition: all 0.3s ease;
        }

        .form-group:hover svg {
            fill: #ff00cc;
            transform: translateY(-50%) scale(1.2);
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        select {
            width: 100%;
            padding: 1rem 1rem 1rem 4rem;
            border: none;
            border-radius: 0.75rem;
            background: rgba(255, 255, 255, 0.1);
            color: #1e293b;
            font-size: 1.1rem;
            transition: all 0.4s ease;
            box-shadow: 0 0 10px rgba(0, 196, 204, 0.2);
        }

        input::placeholder, select {
            color: #94a3b8;
            font-style: italic;
        }

        input:focus, select:focus {
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 0 4px rgba(0, 179, 255, 0.5), 0 0 20px rgba(255, 0, 204, 0.4);
            transform: scale(1.03);
            color: #1e293b;
        }

        .form-group.has-error input,
        .form-group.has-error select {
            box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.5);
            animation: shake 0.4s ease;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-6px); }
            75% { transform: translateX(6px); }
        }

        button {
            position: relative;
            width: 100%;
            padding: 1.25rem;
            background: linear-gradient(90deg, #00ffcc, #00b3ff, #ff00cc);
            background-size: 200%;
            border: none;
            border-radius: 0.75rem;
            color: #ffffff;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            transition: background-position 0.4s ease, transform 0.3s ease;
            text-shadow: 0 0 5px rgba(255, 255, 255, 0.7);
        }

        button:hover {
            background-position: 100%;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 179, 255, 0.5);
            color: #ffffff;
        }

        button::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.5);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s ease, height 0.6s ease;
            pointer-events: none;
        }

        button:active::after {
            width: 400px;
            height: 400px;
            opacity: 0;
        }

        button.loading::before {
            content: '';
            position: absolute;
            width: 24px;
            height: 24px;
            border: 4px solid #ffffff;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .back-link {
            position: absolute;
            top: 2rem;
            left: 2rem;
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
            color: #ffffff;
            background: linear-gradient(90deg, #00ffcc, #00b3ff, #ff00cc);
            background-size: 200%;
            border: 1px solid rgba(0, 196, 204, 0.4);
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transition: background-position 0.4s ease, transform 0.3s ease;
            z-index: 2;
            box-shadow: 0 0 10px rgba(0, 196, 204, 0.3);
            text-shadow: 0 0 5px rgba(255, 255, 255, 0.7);
            white-space: nowrap; /* Đảm bảo "Quay lại" không xuống dòng */
        }

        .back-link:hover {
            background-position: 100%;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 179, 255, 0.5);
            color: #ffffff;
        }

        .tooltip {
            position: absolute;
            background: rgba(30, 41, 59, 0.9);
            color: #e0f2fe;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.9rem;
            opacity: 0;
            pointer-events: none;
            transition: all 0.3s ease;
            transform: translateY(15px);
            z-index: 2;
            top: 100%;
            left: 4rem;
        }

        .form-group:hover .tooltip {
            opacity: 1;
            transform: translateY(10px);
        }

        @media (max-width: 768px) {
            body {
                padding: 1.5rem;
            }

            .container {
                padding: 2rem;
            }

            h2 {
                font-size: 1.75rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .back-link {
                top: 1rem;
                left: 1rem;
                padding: 0.5rem 1rem;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1.5rem;
            }

            h2 {
                font-size: 1.5rem;
            }

            input, select, button {
                font-size: 1rem;
                padding: 0.75rem 0.75rem 0.75rem 3.5rem;
            }

            .back-link {
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <a href="${ProjectPaths.HREF_TO_USERMANAGEMENT}" class="back-link">
        <svg viewBox="0 0 24 24"><path d="M15 18l-6-6 6-6"/></svg> ← Quay lại danh sách
    </a>
    <div class="container">
        <h2>Chỉnh sửa người dùng</h2>
        <c:if test="${not empty errorMessage}">
            <div class="error-message show">${errorMessage}</div>
        </c:if>
        <form action="main" method="post" class="form-grid" id="editForm">
            <input type="hidden" name="action" value="editUser" />
            <input type="hidden" name="id" value="${user.userId}" />

            <div class="form-group" style="--order: 1;">
                <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                <input type="text" name="username" value="${user.username}" placeholder="Tên đăng nhập" required />
                <div class="tooltip">Nhập tên đăng nhập duy nhất</div>
            </div>

            <div class="form-group" style="--order: 2;">
                <svg viewBox="0 0 24 24"><path d="M12 4v16m8-12H4"/></svg>
                <input type="password" name="password" placeholder="Để trống nếu không thay đổi" />
                <div class="tooltip">Mật khẩu từ 8 ký tự trở lên</div>
            </div>

            <div class="form-group" style="--order: 3;">
                <svg viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm-8 9H8v-2h4v2zm4 0h-4v-2h4v2z"/></svg>
                <input type="text" name="fullName" value="${user.fullName}" placeholder="Họ và tên" required />
                <div class="tooltip">Nhập họ và tên đầy đủ</div>
            </div>

            <div class="form-group" style="--order: 4;">
                <svg viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm-2 10l-6-3.5-6 3.5V6h12v8z"/></svg>
                <input type="email" name="email" value="${user.email}" placeholder="Địa chỉ email" required />
                <div class="tooltip">Nhập email hợp lệ</div>
            </div>

            <div class="form-group" style="--order: 5;">
                <svg viewBox="0 0 24 24"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.24 1.02l-2.2 2.2z"/></svg>
                <input type="text" name="phone" value="${user.phone}" placeholder="Số điện thoại" required />
                <div class="tooltip">Nhập số điện thoại hợp lệ</div>
            </div>

            <div class="form-group" style="--order: 6;">
                <svg viewBox="0 0 24 24"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>
                <input type="text" name="address" value="${user.address}" placeholder="Địa chỉ" required />
                <div class="tooltip">Nhập địa chỉ hiện tại</div>
            </div>

            <div class="form-group" style="--order: 7;">
                <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/></svg>
                <select name="role" required>
                    <option value="">-- Chọn vai trò --</option>
                    <option value="ADMIN" <c:if test="${user.role == 'ADMIN'}">selected</c:if>>Admin</option>
                    <option value="CUSTOMER" <c:if test="${user.role == 'CUSTOMER'}">selected</c:if>>Customer</option>
                    <option value="STAFF" <c:if test="${user.role == 'STAFF'}">selected</c:if>>Staff</option>
                </select>
                <div class="tooltip">Chọn vai trò của người dùng</div>
            </div>

            <div class="form-group" style="--order: 8;">
                <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
                <select name="status" required>
                    <option value="">-- Chọn trạng thái --</option>
                    <option value="ACTIVE" <c:if test="${user.status == 'ACTIVE'}">selected</c:if>>Active</option>
                    <option value="INACTIVE" <c:if test="${user.status == 'INACTIVE'}">selected</c:if>>Inactive</option>
                </select>
                <div class="tooltip">Chọn trạng thái tài khoản</div>
            </div>

            <div class="form-group" style="--order: 9;">
                <svg viewBox="0 0 24 24"><path d="M12 2l-2.5 8.5H2l7-5.5 2.5 8.5 2.5-8.5 7 5.5h-7.5L12 2z"/></svg>
                <select name="membershipLevelId" required>
                    <option value="">-- Chọn cấp độ thành viên --</option>
                    <option value="1" <c:if test="${user.membershipLevel.levelId == 1}">selected</c:if>>Đồng</option>
                    <option value="2" <c:if test="${user.membershipLevel.levelId == 2}">selected</c:if>>Bạc</option>
                    <option value="3" <c:if test="${user.membershipLevel.levelId == 3}">selected</c:if>>Vàng</option>
                    <option value="4" <c:if test="${user.membershipLevel.levelId == 4}">selected</c:if>>Kim Cương</option>
                </select>
                <div class="tooltip">Chọn cấp độ thành viên</div>
            </div>

            <button type="submit"><svg viewBox="0 0 24 24" style="width: 1.5rem; height: 1.5rem; fill: currentColor; vertical-align: middle; margin-right: 0.75rem;"><path d="M17 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z"/></svg>Lưu thông tin</button>
        </form>
    </div>
    <script>
        // Form Validation
        const form = document.getElementById('editForm');
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            let isValid = true;
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            const phoneRegex = /^\d{10,11}$/;

            document.querySelectorAll('.form-group').forEach(group => {
                const input = group.querySelector('input, select');
                if (input.required && !input.value) {
                    group.classList.add('has-error');
                    isValid = false;
                } else if (input.name === 'email' && input.value && !emailRegex.test(input.value)) {
                    group.classList.add('has-error');
                    isValid = false;
                } else if (input.name === 'phone' && input.value && !phoneRegex.test(input.value)) {
                    group.classList.add('has-error');
                    isValid = false;
                } else {
                    group.classList.remove('has-error');
                }
            });

            if (isValid && confirm('Bạn có chắc chắn muốn lưu các thay đổi?')) {
                const button = form.querySelector('button');
                button.classList.add('loading');
                button.disabled = true;
                setTimeout(() => form.submit(), 1500);
            }
        });
    </script>
</body>
</html>