<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home Page</title>
    </head>
    <body>
        <div>
            <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>
        </div>

        <div class="content">
            <h1>Hello, this is home page!</h1>
        </div>

    </body>
</html>

<style>
    body {
        margin: 0;
    }
    .content {
        padding-top: 150px; /* tương ứng với chiều cao navbar */
    }
</style>