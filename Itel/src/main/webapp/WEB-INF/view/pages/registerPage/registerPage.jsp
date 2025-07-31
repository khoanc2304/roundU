<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
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
                line-height: 1.6;
            }

            /* Container chính */
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

            /* Tiêu đề */
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

            /* Thông báo lỗi */
            .error-message {
                background: linear-gradient(135deg, #ff6b6b, #ee5a52);
                color: white;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                font-weight: 500;
                text-align: center;
                box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
                animation: slideDown 0.3s ease-out;
            }

            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Form groups */
            .form-group {
                margin-bottom: 25px;
                position: relative;
            }

            /* Labels */
            label {
                display: block;
                margin-bottom: 8px;
                color: #555;
                font-weight: 500;
                font-size: 14px;
                transition: color 0.3s ease;
            }

            /* Input fields */
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
                color: #333;
            }

            input[type="text"]:focus,
            input[type="password"]:focus,
            input[type="email"]:focus {
                outline: none;
                border-color: #667eea;
                background: white;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                transform: translateY(-2px);
            }

            input[type="text"]:focus + label,
            input[type="password"]:focus + label,
            input[type="email"]:focus + label {
                color: #667eea;
            }

            /* Button group */
            .button-group {
                display: flex;
                gap: 15px;
                margin-top: 30px;
                flex-wrap: wrap;
            }

            /* Buttons */
            .btn {
                flex: 1;
                padding: 15px 25px;
                border: none;
                border-radius: 12px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                text-align: center;
                display: inline-block;
                min-width: 120px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
                background: linear-gradient(135deg, #5a6fd8, #6a42a0);
            }

            .btn-secondary {
                background: #f8f9fa;
                color: #6c757d;
                border: 2px solid #e9ecef;
            }

            .btn-secondary:hover {
                background: #e9ecef;
                color: #495057;
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
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
                    <a href="${ProjectPaths.HREF_TO_LOGINPAGE}" class="btn btn-secondary">Quay lại</a>
                </div>
            </form>
        </div>

        <!-- Chatbox AI -->
        <jsp:include page="/WEB-INF/view/components/chatbox.jsp" />
    </body>

</html>
