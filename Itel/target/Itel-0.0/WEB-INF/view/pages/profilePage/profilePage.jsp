<%-- 
    Document   : profile
    Created on : May 22, 2025, 3:37:17 PM
    Author     : Admin
--%>

<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Profile Page</title>
    </head>
    <body>
        <% request.getRequestDispatcher("/WEB-INF/view/components/navbar.jsp").include(request, response); %>

        <div class="content">
            <h1>Hello, this is profile page!</h1>
        </div>

        <!--Footer-->                                 
        <div class="mt-5">
            <jsp:include page="/WEB-INF/view/components/footer.jsp" />
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
