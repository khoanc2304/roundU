<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Management Page</title>
        <style>
            body {
                min-height: 100vh;
                margin: 0;
                font-family: 'Roboto', 'Segoe UI', Arial, sans-serif;
                background: #f4f6fb;
            }
            #main-content {
                margin-left: 50px;
                padding: 72px 0 32px 0;
                width: calc(100% - 250px);
                min-height: 100vh;
                background: #f4f6fb;
                transition: margin-left 0.3s;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .order-title {
                text-align: center;
                margin-bottom: 28px;
                font-size: 2rem;
                color: #2c3e50;
                letter-spacing: 1px;
                font-weight: 700;
                margin-top: 0;
                padding-top: 0;
                background: none;
                z-index: 2;
            }
            .order-table {
                width: 100%;
                max-width: 1100px;
                border-collapse: separate;
                border-spacing: 0;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 24px rgba(44,123,184,0.08), 0 1.5px 4px rgba(0,0,0,0.04);
                overflow: hidden;
                margin: 0 auto;
            }
            .order-table th, .order-table td {
                padding: 16px 10px;
                font-size: 16px;
            }
            .order-table th {
                background: linear-gradient(90deg, #e9ecef 60%, #d1ecf1 100%);
                color: #2c3e50;
                font-weight: 700;
                text-align: center;
                letter-spacing: 1px;
                border-bottom: 2.5px solid #dee2e6;
                text-transform: uppercase;
                font-size: 17px;
            }
            .order-table td {
                background: #fff;
                border-bottom: 1.5px solid #f0f0f0;
                vertical-align: middle;
                font-size: 15px;
            }
            .order-table tr:last-child td {
                border-bottom: none;
            }
            .order-table tr {
                transition: background 0.18s;
            }
            .order-table tr:hover {
                background: #eaf6ff;
            }
            .order-table td.status-cell {
                text-align: center;
            }
            .order-table td.amount-cell {
                text-align: right;
                font-weight: 700;
                color: #2c7bb8;
                font-size: 16px;
            }
            .order-table td {
                text-align: center;
            }
            .order-table td.amount-cell, .order-table td:last-child {
                text-align: right;
            }
            .order-table td:first-child {
                text-align: center;
                font-weight: 600;
                color: #398cb6;
                font-size: 16px;
            }
            .order-status {
                font-weight: bold;
                padding: 6px 18px 6px 14px;
                border-radius: 18px;
                display: inline-block;
                font-size: 15px;
                letter-spacing: 1px;
                box-shadow: 0 1px 2px rgba(44,123,184,0.04);
                min-width: 120px;
                text-align: left;
            }
            .order-status.pending {
                background: #fff3cd;
                color: #b8860b;
            }
            .order-status.completed {
                background: #d4edda;
                color: #218838;
            }
            .order-status.canceled {
                background: #f8d7da;
                color: #c82333;
            }
            .order-status.shipped {
                background: #d1ecf1;
                color: #117a8b;
            }
            .order-status i {
                margin-right: 8px;
                font-size: 1.1em;
                vertical-align: middle;
            }
            .action-cell {
                text-align: center;
                vertical-align: middle;
                white-space: nowrap;
            }
            @media (max-width: 1200px) {
                .order-table {
                    max-width: 1000px;
                }
                #main-content {
                    padding: 56px 0 32px 0;
                }
            }
            @media (max-width: 900px) {
                #main-content {
                    margin-left: 0 !important;
                    width: 100vw !important;
                    padding: 48px 0 8px 0 !important;
                }
                .l-navbar {
                    position: fixed;
                    left: 0;
                    top: 0;
                    width: 60px !important;
                    min-width: 60px !important;
                    max-width: 60px !important;
                    z-index: 1000;
                    transition: width 0.3s;
                }
                .l-navbar .nav_list,
                .l-navbar .nav_logo,
                .l-navbar .nav_link span,
                .l-navbar .nav_name {
                    display: none !important;
                }
                .l-navbar .nav_icon {
                    font-size: 1.5rem;
                    margin: 0 auto;
                }
                .order-table th, .order-table td {
                    font-size: 13px;
                    padding: 10px 4px;
                }
            }
            @media (max-width: 600px) {
                .order-table th, .order-table td {
                    font-size: 12px;
                    padding: 7px 2px;
                }
                #main-content {
                    padding: 32px 0 2px 0;
                }
                .order-table th, .order-table td {
                    white-space: nowrap;
                }
                .order-table {
                    font-size: 12px;
                }
            }
        </style>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    </head>
    <body>
        <jsp:include page="../../components/navbar.jsp" />
        <jsp:include page="../../components/sidebar.jsp" />
        <jsp:include page="../../components/toast.jsp" />
        <div id="main-content">
            <h4 class="order-title">Order Management Page</h4>
            <table class="order-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Order Time</th>
                        <th>Status</th>
                        <th>User</th>
                        <th>Email</th>
                        <th>Shipping Address</th>
                        <th>Total amount</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty orders}">
                            <c:forEach var="order" items="${orders}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.orderDate != null}">
                                                ${order.orderDateFormatted}
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:#aaa;">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="status-cell">
                                        <span class="order-status ${order.status}">
                                            <c:choose>
                                                <c:when test="${order.status eq 'pending'}">
                                                    <i class="fa-regular fa-clock"></i> PENDING
                                                </c:when>
                                                <c:when test="${order.status eq 'completed'}">
                                                    <i class="fa-solid fa-check"></i> COMPLETED
                                                </c:when>
                                                <c:when test="${order.status eq 'canceled'}">
                                                    <i class="fa-solid fa-xmark"></i> CANCELED
                                                </c:when>
                                                <c:when test="${order.status eq 'shipped'}">
                                                    <i class="fa-solid fa-truck"></i> SHIPPED
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-solid fa-question"></i> ${order.status}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <c:out value="${order.user != null ? order.user.fullName : 'N/A'}"/>
                                    </td>
                                    <td>
                                        <c:out value="${order.user != null ? order.user.email : 'N/A'}"/>
                                    </td>
                                    <td style="text-align:left;">${order.shippingAddress}</td>
                                    <td class="amount-cell">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$"/>
                                    </td>
                                    <td class="action-cell">
                                        <form action="main" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="manageOrder"/>
                                            <input type="hidden" name="orderId" value="${order.orderId}"/>
                                            <select name="status" style="padding:4px 8px; border-radius:8px;" 
                                                    <c:if test="${order.status eq 'completed' || order.status eq 'canceled'}">disabled</c:if>>
                                                <option value="pending" ${order.status eq 'pending' ? 'selected' : ''}>Pending</option>
                                                <option value="shipped" ${order.status eq 'shipped' ? 'selected' : ''}>Shipped</option>
                                                <option value="completed" disabled ${order.status eq 'completed' ? 'selected' : ''}>Completed</option>
                                                <option value="canceled" disabled ${order.status eq 'canceled' ? 'selected' : ''}>Canceled</option>
                                            </select>
                                            <button type="submit" style="margin-left:6px; padding:4px 10px; border-radius:8px; background:#2c7bb8; color:#fff; border:none; cursor:pointer;"
                                                    <c:if test="${order.status eq 'completed' || order.status eq 'canceled'}">disabled</c:if>>Cập nhật</button>
                                            </form>
                                            <a href="main?action=viewOrderDetail&orderId=${order.orderId}" style="margin-left:8px; color:#2c7bb8; text-decoration:underline;">Xem chi tiết</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" style="text-align:center; color:#888;">Không có đơn hàng nào.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </body>
</html>

