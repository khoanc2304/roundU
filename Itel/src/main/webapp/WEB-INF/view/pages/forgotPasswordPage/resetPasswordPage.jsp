<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thay đổi mật khẩu</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <h2>Thay đổi mật khẩu</h2>
            <form action="ResetPasswordServlet" method="post">
<!--                <input type="hidden" name="action" value="resetPassword">-->
                <input type="hidden" name="email" value="${requestScope.email}" />

                <div class="form-group">
                    <label for="newPassword">Mật khẩu mới</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required />
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required />
                </div>

                <div class="mt-3">
                    <button type="submit" class="btn btn-primary">Thay đổi mật khẩu</button>
                </div>
            </form>

        </div>
    </body>
</html>
