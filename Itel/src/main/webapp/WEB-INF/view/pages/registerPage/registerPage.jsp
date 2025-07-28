<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký</title>
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
            max-width: 500px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        h2 {
            text-align: center;
            color: #333;
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
            width: 60px;
            height: 3px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 2px;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 14px;
            transition: color 0.3s ease;
        }

        input[type="text"],
        input[type="password"],
        input[type="email"] {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e1e5e9;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            outline: none;
        }

        input[type="text"]:focus,
        input[type="password"]:focus,
        input[type="email"]:focus {
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        input[type="text"]:hover,
        input[type="password"]:hover,
        input[type="email"]:hover {
            border-color: #c3c8d4;
            background: #fff;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .btn {
            flex: 1;
            min-width: 120px;
            padding: 15px 25px;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .btn-secondary {
            background: #f8f9fa;
            color: #6c757d;
            border: 2px solid #e9ecef;
        }

        .btn-secondary:hover {
            background: #e9ecef;
            border-color: #dee2e6;
            transform: translateY(-2px);
        }

        /* Responsive design */
        @media (max-width: 600px) {
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

            .btn {
                min-width: 100%;
            }
        }

        /* Animation for form appearance */
        .container {
            animation: slideUp 0.6s ease-out;
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

        /* Input validation styles */
        input:invalid {
            border-color: #dc3545;
        }

        input:valid {
            border-color: #28a745;
        }

        /* Loading state for submit button */
        .btn-primary:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }

        /* Focus indicators for accessibility */
        .btn:focus {
            outline: 3px solid rgba(102, 126, 234, 0.3);
            outline-offset: 2px;
        }

        /* Subtle pattern overlay */
        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23667eea' fill-opacity='0.03'%3E%3Ccircle cx='30' cy='30' r='2'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            border-radius: 20px;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Đăng ký tài khoản</h2>

        <!-- Hiển thị thông báo lỗi nếu có -->
        <c:if test="${not empty requestScope.errorMessage}">
            <div style="color: red; font-weight: bold; margin-bottom: 15px;">
                ${requestScope.errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label for="username">Tên đăng nhập</label>
                <input type="text" id="username" name="username" required 
                       value="${requestScope.username != null ? requestScope.username : ''}" />
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required />
            </div>

            <div class="form-group">
                <label for="fullName">Họ tên</label>
                <input type="text" id="fullName" name="fullName" required 
                       value="${requestScope.fullName != null ? requestScope.fullName : ''}" />
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required 
                       value="${requestScope.email != null ? requestScope.email : ''}" />
            </div>

            <div class="form-group">
                <label for="phone">Số điện thoại</label>
                <input type="text" id="phone" name="phone" required 
                       value="${requestScope.phone != null ? requestScope.phone : ''}" />
            </div>

            <div class="form-group">
                <label for="address">Địa chỉ</label>
                <input type="text" id="address" name="address" required 
                       value="${requestScope.address != null ? requestScope.address : ''}" />
            </div>

            <div class="button-group">
                <input type="submit" value="Đăng ký" class="btn btn-primary" />
                <input type="button" value="Quay lại" onclick="history.back()" class="btn btn-secondary" />
            </div>
        </form>
    </div>
</body>

</html>
