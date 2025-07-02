<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Main Controller Error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="alert alert-danger">
            <h4>Main Controller Error</h4>
            <p><strong>Action:</strong> <%= request.getParameter("action") %></p>
            <p><strong>Method:</strong> <%= request.getMethod() %></p>
            <p><strong>URL:</strong> <%= request.getRequestURL() %></p>
            <p><strong>Query String:</strong> <%= request.getQueryString() %></p>
        </div>
        <a href="/Itel/main?action=homePage" class="btn btn-primary">Back to Home</a>
    </div>
</body>
</html>
