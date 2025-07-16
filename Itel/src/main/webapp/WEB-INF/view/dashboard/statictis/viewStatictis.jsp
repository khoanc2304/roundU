<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống kê đơn hàng</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .chart-container {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }
        canvas {
            max-width: 100%;
            margin-bottom: 20px;
        }
        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>
    <h2>Thống kê đơn hàng qua từng tháng (2025)</h2>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>
    <div class="chart-container">
        <h3>Biểu đồ tròn</h3>
        <canvas id="pieChart"></canvas>
        <h3>Biểu đồ đường</h3>
        <canvas id="lineChart"></canvas>
    </div>

    <script>
        // Lấy dữ liệu từ JSP
        var stats = [
            <c:forEach var="stat" items="${orderStats}" varStatus="loop">
                { year: ${stat.year}, month: ${stat.month}, count: ${stat.orderCount} }<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        // Kiểm tra nếu stats rỗng
        if (stats.length === 0) {
            document.getElementById('pieChart').style.display = 'none';
            document.getElementById('lineChart').style.display = 'none';
            alert('Không có dữ liệu thống kê để hiển thị.');
        } else {
            // Chuẩn bị dữ liệu cho biểu đồ
            var labels = stats.map(stat => `${stat.month}/${stat.year}`);
            var data = stats.map(stat => stat.count);

            // Biểu đồ tròn
            const pieCtx = document.getElementById('pieChart').getContext('2d');
            new Chart(pieCtx, {
                type: 'pie',
                data: {
                    labels: labels,
                    datasets: [{
                        data: data,
                        backgroundColor: [
                            '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40',
                            '#FF6347', '#4682B4', '#FFD700', '#20B2AA', '#8A2BE2', '#FFA500'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { position: 'top' },
                        title: { display: true, text: 'Phân phối đơn hàng theo tháng' }
                    }
                }
            });

            // Biểu đồ đường
            const lineCtx = document.getElementById('lineChart').getContext('2d');
            new Chart(lineCtx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Số lượng đơn hàng',
                        data: data,
                        fill: false,
                        borderColor: '#36A2EB',
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: { display: true, text: 'Số lượng' }
                        },
                        x: {
                            title: { display: true, text: 'Tháng/Năm' }
                        }
                    },
                    plugins: {
                        legend: { position: 'top' },
                        title: { display: true, text: 'Xu hướng đơn hàng qua tháng' }
                    }
                }
            });
        }
    </script>
</body>
</html>