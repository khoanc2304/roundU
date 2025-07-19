<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên mật khẩu</title>
        <style>
            /* Reset và base styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
                line-height: 1.6;
            }
            /* Container styling */
            .container {
                background: white;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 450px;
                position: relative;
                overflow: hidden;
                animation: slideInUp 0.6s ease-out;
            }
            /* Decorative element */
            .container::before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #667eea, #764ba2);
            }
            /* Heading styles */
            h2 {
                color: #333;
                margin-bottom: 15px;
                font-size: 28px;
                font-weight: 600;
                text-align: center;
                position: relative;
            }
            h2::after {
                content: "🔐";
                display: block;
                font-size: 40px;
                margin: 10px 0 20px;
            }
            /* Form group styling */
            .form-group {
                margin-bottom: 25px;
            }
            /* Label styling */
            label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: 500;
                font-size: 14px;
                letter-spacing: 0.5px;
            }
            /* Input styling */
            .form-control {
                width: 100%;
                padding: 15px 20px;
                border: 2px solid #e1e5e9;
                border-radius: 10px;
                font-size: 16px;
                transition: all 0.3s ease;
                background: #f8f9fa;
                color: #333;
            }
            .form-control:focus {
                outline: none;
                border-color: #667eea;
                background: white;
                box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
                transform: translateY(-2px);
            }
            .form-control::placeholder {
                color: #adb5bd;
                font-style: italic;
            }
            /* Button container */
            .mt-3 {
                margin-top: 30px;
                text-align: center;
            }

            /* Button group styling */
            .button-group {
                display: flex;
                gap: 15px;
                justify-content: center;
                align-items: center;
            }

            /* Button styling */
            .btn {
                display: inline-block;
                padding: 15px 30px;
                font-size: 16px;
                font-weight: 600;
                text-align: center;
                text-decoration: none;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                min-width: 150px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }

            /* Back button styling */
            .btn-secondary {
                background: linear-gradient(135deg, #6c757d, #5a6268);
                color: white;
                box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
            }

            .btn-secondary:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(108, 117, 125, 0.4);
                background: linear-gradient(135deg, #5a6268, #495057);
            }

            .btn-primary:active,
            .btn-secondary:active {
                transform: translateY(-1px);
            }

            /* Button ripple effect */
            .btn::before {
                content: "";
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.3);
                transition: width 0.6s, height 0.6s;
                transform: translate(-50%, -50%);
                z-index: 0;
            }
            .btn:active::before {
                width: 300px;
                height: 300px;
            }
            .btn span {
                position: relative;
                z-index: 1;
            }

            /* Loading state */
            .btn:disabled {
                opacity: 0.7;
                cursor: not-allowed;
                transform: none;
            }

            /* Animation cho form khi load */
            @keyframes slideInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Focus states cho accessibility */
            .form-control:focus,
            .btn:focus {
                outline: 2px solid #667eea;
                outline-offset: 2px;
            }

            /* Hover effect cho container */
            .container:hover {
                box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
                transition: box-shadow 0.3s ease;
            }

            /* Responsive design */
            @media (max-width: 768px) {
                .container {
                    padding: 30px 25px;
                    margin: 10px;
                    max-width: 90%;
                }
                h2 {
                    font-size: 24px;
                }
                .form-control {
                    padding: 12px 15px;
                    font-size: 16px;
                }
                .btn {
                    padding: 12px 25px;
                    font-size: 15px;
                    min-width: 120px;
                }

                .button-group {
                    flex-direction: column;
                    gap: 10px;
                }

                .btn {
                    width: 100%;
                }
            }

            @media (max-width: 480px) {
                body {
                    padding: 15px;
                }
                .container {
                    padding: 25px 20px;
                }
                h2 {
                    font-size: 22px;
                }
                h2::after {
                    font-size: 35px;
                }

                .button-group {
                    gap: 12px;
                }
            }

            /* Custom scrollbar */
            ::-webkit-scrollbar {
                width: 8px;
            }
            ::-webkit-scrollbar-track {
                background: #f1f1f1;
            }
            ::-webkit-scrollbar-thumb {
                background: linear-gradient(135deg, #667eea, #764ba2);
                border-radius: 4px;
            }
            ::-webkit-scrollbar-thumb:hover {
                background: linear-gradient(135deg, #5a6fd8, #6a4190);
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Quên mật khẩu</h2>
            <!-- Đảm bảo action là 'forgotPassword' và URL chính xác -->
            <form action="main" method="post">
                <input type="hidden" name="action" value="forgotPassword">
                <div class="form-group">
                    <label for="email">Nhập email của bạn</label>
                    <input type="email" class="form-control" id="email" name="email"
                           placeholder="example@email.com" required />
                </div>
                <div class="mt-3">
                    <div class="button-group">
                        <button type="button" class="btn btn-secondary" onclick="goBack()">
                            <span>← Quay lại</span>
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <span>Gửi yêu cầu</span>
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <script>
            function goBack() {
                // Option 1: Go back to previous page in browser history
                if (window.history.length > 1) {
                    window.history.back();
                } else {
                    // Option 2: Redirect to login page if no history
                    window.location.href = 'main?action=showLogin';
                }
            }

            // Optional: Add keyboard support for better accessibility
            document.addEventListener('keydown', function (event) {
                if (event.key === 'Escape') {
                    goBack();
                }
            });
        </script>
    </body>
</html>