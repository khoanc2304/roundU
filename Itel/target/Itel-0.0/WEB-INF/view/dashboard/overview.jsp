<%-- 
    Document   : overview
    Created on : May 23, 2025, 12:16:33 AM
    Author     : Admin
--%>

<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dashboard - Overview</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            .sidebar {
                height: 100vh;
                width: 250px;
                position: fixed;
                top: 0;
                left: 0;
                background-color: #2f323e;
                padding-top: 20px;
                color: white;
            }
            .content {
                margin-left: 250px;
                padding: 20px;
            }
            .card {
                margin-bottom: 20px;
            }
            .progress {
                height: 10px;
            }
        </style>
    </head>
    <body>
        <!-- Include sidebar -->
        <%@ include file="../components/sidebar.jsp" %>

        <div class="content">
            <h2>Dashboard Overview</h2>
            <div class="row">
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body text-center">
                            <h5>Daily Sales</h5>
                            <h3>$249.95 <span class="text-success">↑ 67%</span></h3>
                            <div class="progress">
                                <div class="progress-bar bg-success" style="width: 67%"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body text-center">
                            <h5>Monthly Sales</h5>
                            <h3>$2,942.32 <span class="text-danger">↓ 36%</span></h3>
                            <div class="progress">
                                <div class="progress-bar bg-danger" style="width: 36%"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body text-center">
                            <h5>Yearly Sales</h5>
                            <h3>$8,638.32 <span class="text-success">↑ 80%</span></h3>
                            <div class="progress">
                                <div class="progress-bar bg-success" style="width: 80%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
</html>
