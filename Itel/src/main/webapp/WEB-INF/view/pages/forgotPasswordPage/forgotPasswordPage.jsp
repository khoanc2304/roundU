<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên mật khẩu</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <h2>Quên mật khẩu</h2>
            <!-- Đảm bảo action là 'forgotPassword' và URL chính xác -->
            <form action="main" method="post">
                <input type="hidden" name="action" value="forgotPassword">
                <div class="form-group">
                    <label for="email">Nhập email của bạn</label>
                    <input type="email" class="form-control" id="email" name="email" required />
                </div>
                <div class="mt-3">
                    <button type="submit" class="btn btn-primary">Gửi yêu cầu</button>
                </div>
            </form>

        </div>
    </body>
</html>
