<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            position: relative;
            overflow: hidden;
        }

        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }

        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 600;
            position: relative;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 3px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 2px;
        }

        .message {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
            text-align: center;
            animation: slideIn 0.3s ease-out;
        }

        .error-message {
            background-color: #fee;
            color: #c53030;
            border: 1px solid #feb2b2;
        }

        .success-message {
            background-color: #f0fff4;
            color: #38a169;
            border: 1px solid #9ae6b4;
        }

        .form-group {
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 14px;
        }

        input[type="password"] {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: #f8fafc;
        }

        input[type="password"]:focus {
            outline: none;
            border-color: #667eea;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }

        input[type="password"]:hover {
            border-color: #cbd5e0;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
            align-items: center;
        }

        button[type="submit"] {
            flex: 1;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 14px 24px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            min-width: 180px;
        }

        button[type="submit"]::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        button[type="submit"]:hover::before {
            left: 100%;
        }

        button[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        button[type="submit"]:active {
            transform: translateY(0);
        }

        .back-link {
            color: #667eea;
            text-decoration: none;
            padding: 14px 24px;
            border: 2px solid #667eea;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            text-align: center;
            min-width: 120px;
        }

        .back-link:hover {
            background-color: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
            text-decoration: none;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 30px 20px;
                margin: 10px;
            }

            h2 {
                font-size: 24px;
            }

            .button-group {
                flex-direction: column;
            }

            button[type="submit"],
            .back-link {
                min-width: 100%;
            }
        }

        /* Form styling improvements */
        form {
            width: 100%;
        }

        /* Focus ring for accessibility */
        input[type="password"]:focus-visible {
            outline: 2px solid #667eea;
            outline-offset: 2px;
        }

        /* Loading state for form submission */
        .form-loading {
            pointer-events: none;
            opacity: 0.7;
        }

        .form-loading button[type="submit"] {
            background: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Đổi mật khẩu</h2>
        
        <c:if test="${not empty errorMessage}">
            <div class="message error-message">${errorMessage}</div>
        </c:if>
        
        <c:if test="${not empty successMessage}">
            <div class="message success-message">${successMessage}</div>
        </c:if>
        
        <form method="post" action="${pageContext.request.contextPath}/changePassword">
            <div class="form-group">
                <label>Mật khẩu hiện tại:</label>
                <input type="password" name="currentPassword" required>
            </div>
            
            <div class="form-group">
                <label>Mật khẩu mới:</label>
                <input type="password" name="newPassword" required>
            </div>
            
            <div class="form-group">
                <label>Nhập lại mật khẩu mới:</label>
                <input type="password" name="confirmPassword" required>
            </div>
            
            <div class="button-group">
                <button type="submit">Xác nhận đổi mật khẩu</button>
                <a href="${pageContext.request.contextPath}/profilePage?action=viewProfile" class="back-link">Quay lại</a>
            </div>
        </form>
    </div>

    <script>
        // Add loading state when form is submitted
        document.querySelector('form').addEventListener('submit', function() {
            this.classList.add('form-loading');
        });

        // Simple client-side password confirmation validation
        const form = document.querySelector('form');
        const newPassword = document.querySelector('input[name="newPassword"]');
        const confirmPassword = document.querySelector('input[name="confirmPassword"]');

        form.addEventListener('submit', function(e) {
            if (newPassword.value !== confirmPassword.value) {
                e.preventDefault();
                alert('Mật khẩu mới và xác nhận mật khẩu không khớp!');
                return false;
            }
        });

        // Add real-time password confirmation check
        confirmPassword.addEventListener('input', function() {
            if (this.value && this.value !== newPassword.value) {
                this.style.borderColor = '#f56565';
            } else {
                this.style.borderColor = '#e2e8f0';
            }
        });
    </script>
</body>
</html>