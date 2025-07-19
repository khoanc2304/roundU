<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thay đổi mật khẩu</title>
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
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 450px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .icon::before {
            content: "🔒";
            font-size: 24px;
        }

        h2 {
            color: #2d3748;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .subtitle {
            color: #718096;
            font-size: 16px;
            margin-bottom: 0;
        }

        .form-group {
            margin-bottom: 25px;
        }

        label {
            display: block;
            color: #4a5568;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .input-wrapper {
            position: relative;
        }

        .form-control {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 16px;
            background: #ffffff;
            transition: all 0.3s ease;
            outline: none;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .form-control:hover {
            border-color: #cbd5e0;
        }

        .btn {
            width: 100%;
            padding: 15px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 10px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }

        .btn:active {
            transform: translateY(0);
        }

        .password-requirements {
            background: #f7fafc;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
            border-left: 4px solid #667eea;
        }

        .requirement {
            font-size: 13px;
            color: #718096;
            margin-bottom: 5px;
        }

        .requirement:last-child {
            margin-bottom: 0;
        }

        .requirement::before {
            content: "✓";
            color: #48bb78;
            font-weight: bold;
            margin-right: 8px;
        }

        .footer-text {
            text-align: center;
            margin-top: 25px;
            color: #718096;
            font-size: 14px;
        }

        .footer-text a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .footer-text a:hover {
            text-decoration: underline;
        }

        /* Responsive Design */
        @media (max-width: 480px) {
            .container {
                padding: 30px 20px;
                margin: 10px;
            }

            h2 {
                font-size: 24px;
            }

            .form-control, .btn {
                padding: 12px 16px;
                font-size: 15px;
            }
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .container {
            animation: fadeInUp 0.6s ease-out;
        }

        /* Input Icons */
        .input-wrapper::before {
            content: "🔑";
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 16px;
            z-index: 1;
        }

        .form-control {
            padding-left: 45px;
        }

        /* Success Message Styles */
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-success {
            background-color: #f0fff4;
            border: 1px solid #9ae6b4;
            color: #276749;
        }

        .alert-error {
            background-color: #fed7d7;
            border: 1px solid #feb2b2;
color: #c53030;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="icon"></div>
            <h2>Thay đổi mật khẩu</h2>
            <p class="subtitle">Tạo mật khẩu mới cho tài khoản của bạn</p>
        </div>

        <form action="ResetPasswordServlet" method="post">
            <input type="hidden" name="email" value="${requestScope.email}" />
            
            <div class="form-group">
                <label for="newPassword">Mật khẩu mới</label>
                <div class="input-wrapper">
                    <input type="password" class="form-control" id="newPassword" name="newPassword" 
                           placeholder="Nhập mật khẩu mới" required />
                </div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                <div class="input-wrapper">
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                           placeholder="Nhập lại mật khẩu mới" required />
                </div>
            </div>

            <div class="password-requirements">
                <div class="requirement">Ít nhất 8 ký tự</div>
                <div class="requirement">Bao gồm chữ hoa và chữ thường</div>
                <div class="requirement">Có ít nhất một số</div>
                <div class="requirement">Có ít nhất một ký tự đặc biệt</div>
            </div>

            <button type="submit" class="btn">Thay đổi mật khẩu</button>
        </form>

        <div class="footer-text">
            Nhớ mật khẩu? <a href="login.jsp">Đăng nhập ngay</a>
        </div>
    </div>

    <script>
        // Simple form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                return false;
            }
            
            if (newPassword.length < 8) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 8 ký tự!');
                return false;
            }
        });

        // Add visual feedback for password matching
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = this.value;
            
            if (confirmPassword && newPassword !== confirmPassword) {
                this.style.borderColor = '#e53e3e';
            } else {
this.style.borderColor = '#e2e8f0';
            }
        });
    </script>
</body>
</html>