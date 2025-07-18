<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhập OTP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Nhập OTP</h2>
        <form action="main" method="post">
            <input type="hidden" name="action" value="verifyOtp">
            <input type="hidden" name="email" value="${requestScope.email}" />  <!-- Lưu email từ trước -->
            
            <div class="form-group">
                <label for="otp">Nhập mã OTP</label>
                <input type="text" class="form-control" id="otp" name="otp" required />
            </div>
            <div class="mt-3">
                <button type="submit" class="btn btn-primary">Xác nhận OTP</button>
            </div>
        </form>
    </div>
</body>
</html>
