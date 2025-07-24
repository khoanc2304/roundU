<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Admin</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                color: #2d3748;
                min-height: 100vh;
                line-height: 1.6;
            }

            /* Keep original sidebar styles */
            #sidebar {
                position: fixed;
                top: 0;
                left: 0;
                width: 260px;
                height: 100%;
                background: #2c3e50;
                color: #fff;
                padding-top: 20px;
                transition: all 0.3s ease;
                z-index: 1000;
            }

            /* Improved Main Content */
            #main-content {
                margin-left: 260px;
                min-height: 100vh;
                background: #f8fafc;
                transition: all 0.3s ease;
            }

            /* Enhanced Header */
            .header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-bottom: 1px solid #e2e8f0;
                padding: 1.5rem 2rem;
                position: sticky;
                top: 0;
                z-index: 100;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .header-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
                max-width: 1400px;
                margin: 0 auto;
            }

            .header-title {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .header h4 {
                font-size: 1.875rem;
                font-weight: 700;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin: 0;
            }

            .header-badge {
                background: #10b981;
                color: white;
                padding: 0.25rem 0.75rem;
                border-radius: 9999px;
                font-size: 0.75rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }

            .time-display {
                font-size: 0.875rem;
                color: #64748b;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                background: white;
                padding: 0.5rem 1rem;
                border-radius: 0.5rem;
                border: 1px solid #e2e8f0;
            }

            /* Dashboard Content */
            .dashboard-content {
                padding: 2rem;
                max-width: 1400px;
                margin: 0 auto;
            }

            /* Welcome Section */
            .welcome-section {
                text-align: center;
                margin-bottom: 3rem;
                background: white;
                padding: 2rem;
                border-radius: 1rem;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                border: 1px solid #e2e8f0;
            }

            .welcome-title {
                font-size: 2.25rem;
                font-weight: 700;
                color: #1a202c;
                margin-bottom: 0.5rem;
            }

            .welcome-subtitle {
                font-size: 1.125rem;
                color: #64748b;
            }

            /* Stats Cards */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 1.5rem;
                margin-bottom: 3rem;
            }

            .stat-card {
                background: white;
                border-radius: 1rem;
                padding: 2rem;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                border: 1px solid #e2e8f0;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .stat-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            }

            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: var(--accent-color);
            }

            .stat-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 1.5rem;
            }

            .stat-icon {
                width: 3.5rem;
                height: 3.5rem;
                border-radius: 1rem;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                color: white;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            }

            .stat-content {
                flex: 1;
            }

            .stat-title {
                font-size: 0.875rem;
                font-weight: 600;
                color: #64748b;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                margin-bottom: 0.5rem;
            }

            .stat-value {
                font-size: 2.5rem;
                font-weight: 700;
                color: #1a202c;
                margin-bottom: 0.5rem;
            }

            .stat-change {
                display: flex;
                align-items: center;
                gap: 0.25rem;
                font-size: 0.875rem;
                font-weight: 600;
                padding: 0.25rem 0.5rem;
                border-radius: 0.375rem;
            }

            .stat-change.positive {
                color: #059669;
                background: #d1fae5;
            }

            .stat-change.negative {
                color: #dc2626;
                background: #fee2e2;
            }

            /* Charts Grid */
            .charts-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
                gap: 2rem;
                margin-bottom: 3rem;
            }

            .chart-card {
                background: white;
                border-radius: 1rem;
                padding: 2rem;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                border: 1px solid #e2e8f0;
                transition: all 0.3s ease;
            }

            .chart-card:hover {
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            }

            .chart-header {
                display: flex;
                align-items: flex-start;
                gap: 1rem;
                margin-bottom: 2rem;
                padding-bottom: 1rem;
                border-bottom: 1px solid #f1f5f9;
            }

            .chart-icon {
                width: 2.5rem;
                height: 2.5rem;
                border-radius: 0.5rem;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.25rem;
                color: white;
            }

            .chart-info {
                flex: 1;
            }

            .chart-title {
                font-size: 1.25rem;
                font-weight: 700;
                color: #1a202c;
                margin-bottom: 0.25rem;
            }

            .chart-subtitle {
                font-size: 0.875rem;
                color: #64748b;
            }

            .chart-container {
                position: relative;
                height: 350px;
            }

            /* Recent Orders Table */
            .table-card {
                background: white;
                border-radius: 1rem;
                padding: 2rem;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                border: 1px solid #e2e8f0;
                margin-bottom: 2rem;
            }

            .table-header {
                display: flex;
                align-items: center;
                gap: 1rem;
                margin-bottom: 2rem;
                padding-bottom: 1rem;
                border-bottom: 1px solid #f1f5f9;
            }

            .table-icon {
                width: 2.5rem;
                height: 2.5rem;
                border-radius: 0.5rem;
                background: #f59e0b;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.25rem;
                color: white;
            }

            .orders-table {
                width: 100%;
                border-collapse: collapse;
                border-radius: 0.5rem;
                overflow: hidden;
            }

            .orders-table th {
                background: #f8fafc;
                padding: 1rem;
                text-align: left;
                font-weight: 600;
                color: #374151;
                border-bottom: 2px solid #e5e7eb;
                font-size: 0.875rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .orders-table td {
                padding: 1rem;
                border-bottom: 1px solid #f1f5f9;
                font-size: 0.875rem;
            }

            .orders-table tr:hover {
                background: #f8fafc;
            }

            .orders-table tr:last-child td {
                border-bottom: none;
            }

            .status-badge {
                padding: 0.375rem 0.75rem;
                border-radius: 9999px;
                font-size: 0.75rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .status-completed {
                background: #dcfce7;
                color: #166534;
            }

            .status-processing {
                background: #dbeafe;
                color: #1e40af;
            }

            .status-shipped {
                background: #f3e8ff;
                color: #7c3aed;
            }

            .status-pending {
                background: #fef3c7;
                color: #92400e;
            }

            /* Debug Section */
            .debug-section {
                background: white;
                border-radius: 1rem;
                padding: 2rem;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                border: 1px solid #e2e8f0;
                margin-top: 2rem;
            }

            .debug-title {
                font-size: 1.25rem;
                font-weight: 700;
                color: #1a202c;
                margin-bottom: 1rem;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #e5e7eb;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .debug-content {
                font-size: 0.875rem;
                color: #64748b;
                line-height: 1.6;
            }

            .debug-content h5 {
                color: #374151;
                margin: 1rem 0 0.5rem;
                font-weight: 600;
            }

            .debug-content ul {
                list-style: none;
                padding: 0;
            }

            .debug-content li {
                padding: 0.5rem 0;
                border-bottom: 1px solid #f1f5f9;
            }

            /* Error Styles */
            .error-message {
                background: #fef2f2;
                border: 1px solid #fecaca;
                color: #dc2626;
                padding: 1rem;
                border-radius: 0.75rem;
                margin-bottom: 2rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 3rem 2rem;
                color: #64748b;
            }

            .empty-state i {
                font-size: 4rem;
                margin-bottom: 1rem;
                opacity: 0.3;
            }

            .empty-state p {
                font-size: 1.125rem;
                margin-bottom: 0.5rem;
            }

            .empty-state small {
                font-size: 0.875rem;
                opacity: 0.7;
            }

            /* Responsive Design */
            @media (max-width: 1024px) {
                #sidebar {
                    transform: translateX(-100%);
                }

                #main-content {
                    margin-left: 0;
                }

                .charts-grid {
                    grid-template-columns: 1fr;
                }

                .stats-grid {
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                }
            }

            @media (max-width: 768px) {
                .dashboard-content {
                    padding: 1rem;
                }

                .header {
                    padding: 1rem;
                }

                .header-content {
                    flex-direction: column;
                    gap: 1rem;
                    text-align: center;
                }

                .welcome-title {
                    font-size: 1.875rem;
                }

                .chart-card {
                    padding: 1.5rem;
                }

                .chart-container {
                    height: 280px;
                }

                .orders-table {
                    font-size: 0.75rem;
                }

                .orders-table th,
                .orders-table td {
                    padding: 0.75rem 0.5rem;
                }

                .stat-card {
                    padding: 1.5rem;
                }

                .stat-value {
                    font-size: 2rem;
                }
            }

            /* Color Variables */
            .stat-card:nth-child(1) {
                --accent-color: #3b82f6;
            }
            .stat-card:nth-child(2) {
                --accent-color: #10b981;
            }
            .stat-card:nth-child(3) {
                --accent-color: #8b5cf6;
            }
            .stat-card:nth-child(4) {
                --accent-color: #f59e0b;
            }

            /* Animation */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .chart-card,
            .stat-card,
            .table-card,
            .welcome-section {
                animation: fadeInUp 0.6s ease-out;
            }

            .stat-card:nth-child(1) {
                animation-delay: 0.1s;
            }
            .stat-card:nth-child(2) {
                animation-delay: 0.2s;
            }
            .stat-card:nth-child(3) {
                animation-delay: 0.3s;
            }
            .stat-card:nth-child(4) {
                animation-delay: 0.4s;
            }

            /* Loading Animation */
            .loading {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 3px solid #f3f3f3;
                border-top: 3px solid #667eea;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* Pulse animation for live badge */
            @keyframes pulse {
                0%, 100% {
                    opacity: 1;
                }
                50% {
                    opacity: 0.5;
                }
            }

            .header-badge i {
                animation: pulse 2s infinite;
            }

            /* Filter card style */
            .filter-card {
                display: flex;
                align-items: center;
                justify-content: center;
                min-width: 260px;
                max-width: 340px;
                background: #fff;
                border-radius: 1rem;
                box-shadow: 0 4px 6px -1px rgba(0,0,0,0.08);
                border: 1px solid #e2e8f0;
                padding: 1.5rem 1rem;
                margin-top: 0;
                margin-bottom: 0;
            }

            .filter-form {
                display: flex;
                flex-direction: column;
                gap: 0.75rem;
                align-items: flex-start;
                width: 100%;
            }

            .filter-form label {
                font-size: 0.95rem;
                color: #64748b;
                font-weight: 600;
                margin-right: 0.5rem;
            }

            .filter-form select {
                padding: 0.4rem 1.2rem 0.4rem 0.5rem;
                border-radius: 0.5rem;
                border: 1px solid #e2e8f0;
                background: #f8fafc;
                font-size: 1rem;
                color: #374151;
                outline: none;
                margin-right: 0.5rem;
                margin-bottom: 0.2rem;
            }

            .filter-btn {
                padding: 0.5rem 1.5rem;
                border-radius: 0.5rem;
                background: #3b82f6;
                color: #fff;
                border: none;
                font-weight: 600;
                font-size: 1rem;
                transition: background 0.2s;
                margin-top: 0.5rem;
                cursor: pointer;
            }

            .filter-btn:hover {
                background: #2563eb;
            }
        </style>
    </head>
    <body>
        <!-- Keep original sidebar -->
        <div id="sidebar">
            <jsp:include page="../components/sidebar.jsp" />
        </div>

        <!-- Toast Notifications -->
        <jsp:include page="../components/toast.jsp" />

        <!-- Main Content -->
        <div id="main-content">
            <!-- Enhanced Header -->
            <div class="header">
                <div class="header-content">
                    <div class="header-title">
                        <i class="fas fa-chart-line" style="color: #667eea; font-size: 1.5rem;"></i>
                        <h4>Xin chào đến với Dashboard Admin</h4>
                        <div class="header-badge">
                            <i class="fas fa-circle" style="font-size: 0.5rem;"></i>
                            Live
                        </div>
                    </div>
                    <div class="time-display" id="current-time">
                        <div class="loading"></div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <!-- Welcome Section -->
                <div class="welcome-section">
                    <h2 class="welcome-title">Dashboard</h2>
                    <p class="welcome-subtitle">Theo dõi và quản lý hoạt động kinh doanh của bạn một cách hiệu quả</p>
                </div>

                <!-- Error Display -->
                <c:if test="${not empty error}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${error}
                    </div>
                </c:if>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-content">
                                <div class="stat-title">Tổng đơn hàng</div>
                                <div class="stat-value" id="total-orders">
                                    <c:choose>
                                        <c:when test="${not empty ordersOfMonth}">
                                            ${ordersOfMonth.size()}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stat-change ${orderPercent != null && orderPercent >= 0 ? 'positive' : 'negative'}">
                                    <c:choose>
                                        <c:when test="${orderPercent != null}">
                                            <i class="fas fa-arrow-${orderPercent >= 0 ? 'up' : 'down'}"></i>
                                            <fmt:formatNumber value="${orderPercent}" type="number" maxFractionDigits="1"/>% từ tháng trước
                                        </c:when>
                                        <c:otherwise>
                                            <span>-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="stat-icon" style="background: #3b82f6;">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-content">
                                <div class="stat-title">Sản phẩm</div>
                                <div class="stat-value">
                                    <c:choose>
                                        <c:when test="${not empty products}">
                                            ${products.size()}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stat-change ${productPercent != null && productPercent >= 0 ? 'positive' : 'negative'}">
                                    <c:choose>
                                        <c:when test="${productPercent != null}">
                                            <i class="fas fa-arrow-${productPercent >= 0 ? 'up' : 'down'}"></i>
                                            <fmt:formatNumber value="${productPercent}" type="number" maxFractionDigits="1"/>% từ tháng trước
                                        </c:when>
                                        <c:otherwise>
                                            <span>-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="stat-icon" style="background: #10b981;">
                                <i class="fas fa-map-marked-alt"></i>
                            </div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-content">
                                <div class="stat-title">Khách hàng</div>
                                <div class="stat-value">
                                    <c:choose>
                                        <c:when test="${not empty activeCustomerCount}">
                                            ${activeCustomerCount}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stat-change ${activeCustomerPercent != null && activeCustomerPercent >= 0 ? 'positive' : 'negative'}">
                                    <c:choose>
                                        <c:when test="${activeCustomerPercent != null}">
                                            <i class="fas fa-arrow-${activeCustomerPercent >= 0 ? 'up' : 'down'}"></i>
                                            <fmt:formatNumber value="${activeCustomerPercent}" type="number" maxFractionDigits="1"/>% từ tháng trước
                                        </c:when>
                                        <c:otherwise>
                                            <span>-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="stat-icon" style="background: #8b5cf6;">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-content">
                                <div class="stat-title">Doanh thu</div>
                                <div class="stat-value">
                                    <c:choose>
                                        <c:when test="${not empty revenueOfMonth}">
                                            ₫${revenueOfMonth}
                                        </c:when>
                                        <c:otherwise>₫0</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stat-change ${revenuePercent != null && revenuePercent >= 0 ? 'positive' : 'negative'}">
                                    <c:choose>
                                        <c:when test="${revenuePercent != null}">
                                            <i class="fas fa-arrow-${revenuePercent >= 0 ? 'up' : 'down'}"></i>
                                            <fmt:formatNumber value="${revenuePercent}" type="number" maxFractionDigits="1"/>% từ tháng trước
                                        </c:when>
                                        <c:otherwise>
                                            <span>-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="stat-icon" style="background: #f59e0b;">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Card filter tháng/năm -->
                    <div class="stat-card filter-card">
                        <form method="get" action="main" class="filter-form">
                            <input type="hidden" name="action" value="dashboardPage" />
                            <label for="month">Tháng:</label>
                            <select name="month" id="month">
                                <c:forEach var="stat" items="${orderStatsByMonth}">
                                    <option value="${stat.month}" <c:if test="${stat.month == selectedMonth}">selected</c:if>>Tháng ${stat.month}</option>
                                </c:forEach>
                            </select>
                            <label for="year">Năm:</label>
                            <select name="year" id="year">
                                <c:forEach var="stat" items="${orderStatsByMonth}">
                                    <option value="${stat.year}" <c:if test="${stat.year == selectedYear}">selected</c:if>>${stat.year}</option>
                                </c:forEach>
                            </select>
                            <button type="submit" class="filter-btn">Xem</button>
                        </form>
                    </div>
                </div>

                <!-- Charts Grid -->
                <div class="charts-grid">
                    <!-- Pie Chart -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-icon" style="background: #3b82f6;">
                                <i class="fas fa-chart-pie"></i>
                            </div>
                            <div class="chart-info">
                                <div class="chart-title">Phân phối đơn hàng theo tháng</div>
                                <div class="chart-subtitle">Tỷ lệ đơn hàng của từng tháng trong năm 2025</div>
                            </div>
                        </div>
                        <div class="chart-container">
                            <canvas id="pieChartMonth"></canvas>
                        </div>
                    </div>

                    <!-- Bar Chart -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-icon" style="background: #10b981;">
                                <i class="fas fa-chart-bar"></i>
                            </div>
                            <div class="chart-info">
                                <div class="chart-title">Đơn hàng theo sản phẩm</div>
                                <div class="chart-subtitle">Số lượng đơn hàng cho từng sản phẩm</div>
                            </div>
                        </div>
                        <div class="chart-container">
                            <canvas id="barChartProduct"></canvas>
                        </div>
                    </div>

                    <!-- Line Chart -->
                    <div class="chart-card">
                        <div class="chart-header">
                            <div class="chart-icon" style="background: #8b5cf6;">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div class="chart-info">
                                <div class="chart-title">Xu hướng đặt hàng</div>
                                <div class="chart-subtitle">Biến động số lượng đơn hàng qua các tháng</div>
                            </div>
                        </div>
                        <div class="chart-container">
                            <canvas id="lineChartMonth"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Recent Orders Table -->
                <!--            <div class="table-card">
                                <div class="table-header">
                                    <div class="table-icon">
                                        <i class="fas fa-list"></i>
                                    </div>
                                    <div class="chart-info">
                                        <div class="chart-title">Đơn hàng gần đây</div>
                                        <div class="chart-subtitle">Danh sách các đơn hàng mới nhất trong hệ thống</div>
                                    </div>
                                </div>
                <c:choose>
                    <c:when test="${not empty allOrders}">
                        <table class="orders-table">
                            <thead>
                                <tr>
                                    <th>Mã đơn hàng</th>
                                    <th>Ngày đặt</th>
                                    <th>Trạng thái</th>
                                    <th>Tổng tiền</th>
                                    <th>Địa chỉ</th>
                                </tr>
                            </thead>
                            <tbody>
                        <c:forEach var="order" items="${allOrders}" begin="0" end="9">
                            <tr>
                                <td><strong>${order.orderId}</strong></td>
                                <td>${order.orderDate}</td>
                                <td>
                            <c:choose>
                                <c:when test="${order.status == 'completed' || order.status == 'Completed'}">
                                    <span class="status-badge status-completed">Hoàn thành</span>
                                </c:when>
                                <c:when test="${order.status == 'processing' || order.status == 'Processing'}">
                                    <span class="status-badge status-processing">Đang xử lý</span>
                                </c:when>
                                <c:when test="${order.status == 'shipped' || order.status == 'Shipped'}">
                                    <span class="status-badge status-shipped">Đã giao hàng</span>
                                </c:when>
                                <c:when test="${order.status == 'canceled' || order.status == 'Canceled'}">
                                    <span class="status-badge status-canceled">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-pending">Chờ xử lý</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><strong>₫${order.totalAmount}</strong></td>
                        <td>${order.shippingAddress}</td>
                    </tr>
                        </c:forEach>
                    </tbody>
                </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-box"></i>
                            <small>Các đơn hàng sẽ hiển thị tại đây khi có khách hàng đặt</small>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>-->

                <!-- Debug Section -->
                <!--            <div class="debug-section">
                                <h4 class="debug-title">
                                    <i class="fas fa-bug"></i>
                                    Thông tin debug hệ thống
                                </h4>
                                <div class="debug-content">
                                    <h5>📊 Dữ liệu thống kê theo tháng:</h5>
                <c:choose>
                    <c:when test="${not empty orderStatsByMonth}">
                        <ul>
                        <c:forEach var="stat" items="${orderStatsByMonth}">
                            <li>📅 Năm ${stat.year}, Tháng ${stat.month}: <strong>${stat.orderCount} đơn hàng</strong></li>
                        </c:forEach>
                    </ul>
                    </c:when>
                    <c:otherwise>
                        <p>⚠️ Không có dữ liệu thống kê theo tháng (orderStatsByMonth).</p>
                    </c:otherwise>
                </c:choose>

                <h5>🎯 Dữ liệu thống kê theo sản phẩm:</h5>
                <c:choose>
                    <c:when test="${not empty orderStatsByProduct}">
                        <ul>
                        <c:forEach var="stat" items="${orderStatsByProduct}">
                            <li>🏷️ Sản phẩm ID ${stat.productId}: <strong>${stat.orderCount} đơn hàng</strong></li>
                        </c:forEach>
                    </ul>
                    </c:when>
                    <c:otherwise>
                        <p>⚠️ Không có dữ liệu thống kê theo sản phẩm (orderStatsByProduct).</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>-->
            </div>
        </div>

        <script>
            // Real-time clock with enhanced styling
            function updateTime() {
                const now = new Date();
                const options = {
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: false,
                    timeZone: 'Asia/Ho_Chi_Minh'
                };
                const timeString = now.toLocaleTimeString('vi-VN', options) + ' +07';
                const dateString = now.toLocaleDateString('vi-VN');
                document.getElementById('current-time').innerHTML = `
                    <i class="fas fa-clock"></i> 
                    <span>${timeString}</span>
                    <span style="opacity: 0.7;">| ${dateString}</span>
                `;
            }

            setInterval(updateTime, 1000);
            updateTime();

            // Check Chart.js availability
            if (typeof Chart === 'undefined') {
            console.error("Chart.js không được tải!");
                    document.querySelectorAll('canvas').forEach(canvas => {
            canvas.parentElement.innerHTML = `
                        <div class="empty-state">
                            <i class="fas fa-exclamation-triangle" style="color: #ef4444;"></i>
                            <p>Lỗi tải thư viện Chart.js</p>
                            <small>Vui lòng kiểm tra kết nối internet</small>
                        </div>
                    `;
            });
            } else {
            // Enhanced Chart.js configuration
            Chart.defaults.font.family = 'Inter, sans-serif';
                    Chart.defaults.color = '#64748b';
                    Chart.defaults.plugins.legend.labels.usePointStyle = true;
                    // Month data
                    var statsMonth = [
            <c:forEach var="stat" items="${orderStatsByMonth}" varStatus="loop">
                { year: ${stat.year}, month: ${stat.month}, count: ${stat.orderCount} }<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
                    ];

            // Product data
            var statsProduct = [
            <c:forEach var="stat" items="${orderStatsByProduct}" varStatus="loop">
            { productId: ${stat.productId}, productName: "${fn:replace(stat.productName, '"', '\\"')}", count: ${stat.orderCount} }<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];
            // Debug
            console.log("statsProduct:", statsProduct);

            // Filter valid data
            var validStatsMonth = statsMonth.filter(stat =>
                stat && stat.year && stat.month && stat.count !== undefined &&
                        !isNaN(stat.month) && !isNaN(stat.count)
            );

            console.log("📊 Dữ liệu biểu đồ:", {validStatsMonth, statsProduct});

            if (validStatsMonth.length > 0 || statsProduct.length > 0) {
                // Enhanced Doughnut Chart
                const pieCtx = document.getElementById('pieChartMonth');
                if (pieCtx) {
                    new Chart(pieCtx, {
                        type: 'doughnut',
                        data: {
                            labels: validStatsMonth.map(stat => 'Tháng ' + stat.month + '/' + stat.year),
                            datasets: [{
                                    data: validStatsMonth.map(stat => stat.count || 0),
                                    backgroundColor: [
                                        '#3b82f6', '#10b981', '#f59e0b', '#ef4444',
                                        '#8b5cf6', '#ec4899', '#06b6d4', '#84cc16'
                                    ],
                                    borderWidth: 4,
                                    borderColor: '#ffffff',
                                    hoverBorderWidth: 6,
                                    hoverOffset: 8
                                }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            cutout: '65%',
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                    labels: {
                                        padding: 25,
                                        usePointStyle: true,
                                        font: {size: 13, weight: '500'},
                                        generateLabels: function (chart) {
                                            const data = chart.data;
                                            return data.labels.map(function (label, i) {
                                                return {
                                                    text: label + ' (' + data.datasets[0].data[i] + ' đơn)',
                                                    fillStyle: data.datasets[0].backgroundColor[i],
                                                    hidden: false,
                                                    index: i
                                                };
                                            });
                                        }
                                    }
                                },
                                tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                    titleColor: '#fff',
                                    bodyColor: '#fff',
                                    borderColor: '#e2e8f0',
                                    borderWidth: 1,
                                    callbacks: {
                                        label: function (context) {
                                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                            const percentage = ((context.parsed / total) * 100).toFixed(1);
                                        return `${context.label}: ${context.parsed} đơn hàng (${percentage}%)`;
                                        }
                                    }
                                }
                            }
                        }
                    });
                }

                // Enhanced Bar Chart
                const barCtx = document.getElementById('barChartProduct');
                if (barCtx) {
                    new Chart(barCtx, {
                        type: 'bar',
                        data: {
                            labels: statsProduct.map(stat => stat.productName || stat.productId),
                            datasets: [{
                                    label: 'Số lượng đơn hàng',
                                    data: statsProduct.map(stat => stat.count || 0),
                                    backgroundColor: 'rgba(16, 185, 129, 0.8)',
                                    borderColor: '#10b981',
                                    borderWidth: 2,
                                    borderRadius: 8,
                                    borderSkipped: false,
                                    hoverBackgroundColor: 'rgba(16, 185, 129, 0.9)',
                                    hoverBorderWidth: 3
                                }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {display: false},
                                tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                    titleColor: '#fff',
                                    bodyColor: '#fff',
                                    callbacks: {
                                    label: (context) => `${context.parsed.y} đơn`
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: {
                                        color: 'rgba(0, 0, 0, 0.05)',
                                        drawBorder: false
                                    },
                                    ticks: {
                                        font: {size: 12},
                                        color: '#64748b'
                                    }
                                },
                                x: {
                                    grid: {display: false},
                                    ticks: {
                                        font: {size: 12},
                                        color: '#64748b'
                                    }
                                }
                            }
                        }
                    });
                }

                // Enhanced Line Chart
                const lineCtx = document.getElementById('lineChartMonth');
                if (lineCtx) {
                    new Chart(lineCtx, {
                        type: 'line',
                        data: {
                            labels: validStatsMonth.map(stat => 'Tháng ' + stat.month),
                            datasets: [{
                                    label: 'Đơn',
                                    data: validStatsMonth.map(stat => stat.count || 0),
                                    borderColor: '#8b5cf6',
                                    backgroundColor: 'rgba(139, 92, 246, 0.1)',
                                    borderWidth: 4,
                                    fill: true,
                                    tension: 0.4,
                                    pointBackgroundColor: '#8b5cf6',
                                    pointBorderColor: '#ffffff',
                                    pointBorderWidth: 3,
                                    pointRadius: 8,
                                    pointHoverRadius: 12,
                                    pointHoverBackgroundColor: '#8b5cf6',
                                    pointHoverBorderColor: '#ffffff',
                                    pointHoverBorderWidth: 4
                                }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {display: false},
                                tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                    titleColor: '#fff',
                                    bodyColor: '#fff',
                                    callbacks: {
                                    label: (context) => `${context.parsed.y} đơn`
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: {
                                        color: 'rgba(0, 0, 0, 0.05)',
                                        drawBorder: false
                                    },
                                    ticks: {
                                        font: {size: 12},
                                        color: '#64748b'
                                    }
                                },
                                x: {
                                    grid: {display: false},
                                    ticks: {
                                        font: {size: 12},
                                        color: '#64748b'
                                    }
                                }
                            }
                        }
                    });
                }
            } else {
                // Enhanced no data message
                document.querySelectorAll('canvas').forEach(canvas => {
                    canvas.parentElement.innerHTML = `
                            <div class="empty-state">
                                <i class="fas fa-chart-bar"></i>
                                <p>Chưa có dữ liệu thống kê</p>
                                <small>Dữ liệu sẽ hiển thị khi có đơn hàng trong hệ thống</small>
                            </div>
                        `;
                });
                }
            }

            // Add smooth scrolling
            document.documentElement.style.scrollBehavior = 'smooth';

            // Add loading states
            document.addEventListener('DOMContentLoaded', function () {
                // Simulate loading for demo
                setTimeout(() => {
                    document.querySelectorAll('.stat-card').forEach((card, index) => {
                        card.style.animationDelay = `${index * 0.1}s`;
                    });
                }, 100);
            });
        </script>
    </body>
</html>