<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký thành công</title>
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

        .success-container {
            background: white;
            padding: 3rem 2.5rem;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 100%;
            position: relative;
            overflow: hidden;
        }

        .success-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }

        .success-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #4CAF50, #45a049);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            animation: bounce 0.6s ease-out;
        }

        .success-icon::after {
            content: '✓';
            color: white;
            font-size: 2.5rem;
            font-weight: bold;
        }

        @keyframes bounce {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            50% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }

        h2 {
            color: #333;
            font-size: 2rem;
            margin-bottom: 1rem;
            font-weight: 600;
            animation: fadeInUp 0.8s ease-out 0.2s both;
        }

        p {
            color: #666;
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 2.5rem;
            animation: fadeInUp 0.8s ease-out 0.4s both;
        }

        .login-button {
            display: inline-block;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            text-decoration: none;
            padding: 1rem 2.5rem;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            animation: fadeInUp 0.8s ease-out 0.6s both;
        }

        .login-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            background: linear-gradient(135deg, #5a6fd8, #6a42a0);
        }

        .login-button:active {
            transform: translateY(0);
        }

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

        .decorative-elements {
            position: absolute;
            top: -50px;
            right: -50px;
            width: 100px;
            height: 100px;
            background: linear-gradient(45deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            border-radius: 50%;
            z-index: -1;
        }

        .decorative-elements::after {
            content: '';
            position: absolute;
            bottom: -100px;
            left: -100px;
            width: 150px;
            height: 150px;
            background: linear-gradient(45deg, rgba(118, 75, 162, 0.1), rgba(102, 126, 234, 0.1));
            border-radius: 50%;
        }

        @media (max-width: 480px) {
            .success-container {
                padding: 2rem 1.5rem;
                margin: 1rem;
            }

            h2 {
                font-size: 1.5rem;
            }

            p {
                font-size: 1rem;
            }

            .login-button {
                padding: 0.8rem 2rem;
                font-size: 1rem;
            }

            .success-icon {
                width: 60px;
                height: 60px;
            }

            .success-icon::after {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="decorative-elements"></div>
        <div class="success-icon"></div>
        <h2>Đăng ký thành công!</h2>
        <p>Cảm ơn bạn đã đăng ký tài khoản. Chào mừng bạn đến với cộng đồng của chúng tôi!</p>
        <a href="${pageContext.request.contextPath}/main?action=loginPage" class="login-button">Đăng nhập ngay</a>
    </div>
</body>
</html>
