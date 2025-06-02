<%-- 
    Document   : sidebar
    Created on : May 23, 2025, 12:13:05 AM
    Author     : Admin
--%>

<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!--<!DOCTYPE html>
<html>-->
    <div class="sidebar">
        <h4 class="text-center">RoundU</h4>
        <hr>
        <h5>NAVIGATION</h5>
        <a href="overview.jsp">Dashboard</a>
        <h5>UI COMPONENTS</h5>
        <a href="#">Color</a>
        <a href="#">Typography</a>
        <a href="#">Icons</a>
        <h5>PAGES</h5>
        <a href="#">Login</a>
        <a href="#">Register</a>
        <h5>OTHER</h5>
        <a href="#">Menu levels</a>
        <a href="#">Sample page</a>
    </div>
<!--</html>-->
<style>
    .sidebar a {
        color: white;
        padding: 10px 15px;
        text-decoration: none;
        display: block;
    }
    .sidebar a:hover {
        background-color: #3a3f4b;
    }
</style>
