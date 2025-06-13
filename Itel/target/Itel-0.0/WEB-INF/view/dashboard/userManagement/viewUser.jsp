<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Xem chi tiết thông tin người dùng với giao diện xanh trắng sáng, futuristic">
    <title>Xem chi tiết người dùng</title>
    <link rel="icon" type="image/png" href="https://example.com/favicon.png">
    <link href="https://fonts.googleapis.com/css2?family=Oxanium:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Oxanium', sans-serif;
            background: linear-gradient(135deg, #e0f2fe, #f8fafc, #bae6fd);
            background-size: 400%;
            animation: gradientFlow 15s ease infinite;
            color: #1e293b;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 2rem;
        }

        @keyframes gradientFlow {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .container {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(15px);
            padding: 2rem;
            border-radius: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 0 30px rgba(0, 179, 255, 0.3), 0 0 50px rgba(0, 196, 204, 0.2);
            max-width: 800px;
            width: 100%;
            margin: 3rem 0;
            animation: glowPulse 3s ease-in-out infinite;
        }

        @keyframes glowPulse {
            0%, 100% { box-shadow: 0 0 30px rgba(0, 179, 255, 0.3), 0 0 50px rgba(0, 196, 204, 0.2); }
            50% { box-shadow: 0 0 50px rgba(0, 179, 255, 0.5), 0 0 70px rgba(0, 196, 204, 0.4); }
        }

        h2 {
            font-weight: 700;
            text-align: center;
            color: #ffffff;
            margin-bottom: 2rem;
            font-size: 2rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            text-shadow: 0 0 10px rgba(0, 196, 204, 0.7);
            position: relative;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: -0.75rem;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 4px;
            background: linear-gradient(90deg, #00ffcc, #00b3ff, #ff00cc);
            border-radius: 2px;
            animation: neonFlicker 2s ease-in-out infinite;
        }

        @keyframes neonFlicker {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }

        .error-message {
            background: rgba(239, 68, 68, 0.3);
            color: #fef2f2;
            padding: 1rem;
            border-radius: 0.75rem;
            margin-bottom: 1.5rem;
            text-align: center;
            border: 1px solid rgba(239, 68, 68, 0.5);
            box-shadow: 0 0 15px rgba(239, 68, 68, 0.4);
            animation: errorShake 0.5s ease;
            opacity: 0;
            transform: translateY(-20px);
        }

        .error-message.show {
            opacity: 1;
            transform: translateY(0);
            transition: all 0.5s ease;
        }

        @keyframes errorShake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-8px); }
            75% { transform: translateX(8px); }
        }

        .details-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .detail-item {
            padding: 1rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 0.75rem;
            box-shadow: 0 0 10px rgba(0, 196, 204, 0.2);
            animation: slideInField 0.6s ease-out forwards;
            animation-delay: calc(var(--order) * 0.1s);
            --order: 0;
        }

        @keyframes slideInField {
            from { opacity: 0; transform: translateX(-30px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .detail-item span.label {
            font-weight: 600;
            color: #00ffcc;
            margin-right: 0.5rem;
        }

        .detail-item span.value {
            color: #1e293b;
        }

        .status-active {
            color: #00ff00;
            font-weight: bold;
        }

        .status-inactive {
            color: #ff0000;
            font-weight: bold;
        }

        .back-link {
            position: fixed;
            top: 1rem;
            left: 1rem;
            padding: 0.5rem 1rem;
            border-radius: 0.75rem;
            color: #ffffff;
            background: linear-gradient(90deg, #00ffcc, #00b3ff, #ff00cc);
            background-size: 200%;
            border: 1px solid rgba(0, 196, 204, 0.4);
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-position 0.4s ease, transform 0.3s ease;
            box-shadow: 0 0 10px rgba(0, 196, 204, 0.3);
        }

        .back-link:hover {
            background-position: 100%;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 179, 255, 0.5);
        }

        @media (min-width: 768px) {
            .details-grid {
                grid-template-columns: 1fr 1fr;
            }

            .container {
                padding: 3rem;
            }

            h2 {
                font-size: 2.25rem;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 1.5rem;
                margin: 2rem 0.5rem;
            }

            h2 {
                font-size: 1.5rem;
            }

            .detail-item {
                padding: 0.75rem;
            }

            .back-link {
                font-size: 0.85rem;
                padding: 0.4rem 0.8rem;
            }
        }
    </style>
</head>
<body>
    <a href="${ProjectPaths.HREF_TO_USERMANAGEMENT}" class="back-link">
        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M15 18l-6-6 6-6"/>
        </svg> Quay lại danh sách
    </a>
    <div class="container">
        <h2>Xem chi tiết người dùng</h2>
        <c:if test="${not empty errorMessage}">
            <div class="error-message show">${errorMessage}</div>
        </c:if>
        <div class="details-grid">
            <div class="detail-item" style="--order: 1;">
                <span class="label">ID:</span>
                <span class="value">${user.userId}</span>
            </div>
            <div class="detail-item" style="--order: 2;">
                <span class="label">Username:</span>
                <span class="value">${user.username}</span>
            </div>
            <div class="detail-item" style="--order: 3;">
                <span class="label">Password:</span>
                <span class="value">**********</span>
            </div>
            <div class="detail-item" style="--order: 4;">
                <span class="label">Full Name:</span>
                <span class="value">${user.fullName}</span>
            </div>
            <div class="detail-item" style="--order: 5;">
                <span class="label">Email:</span>
                <span class="value">${user.email}</span>
            </div>
            <div class="detail-item" style="--order: 6;">
                <span class="label">Phone:</span>
                <span class="value">${user.phone}</span>
            </div>
            <div class="detail-item" style="--order: 7;">
                <span class="label">Address:</span>
                <span class="value">${user.address}</span>
            </div>
            <div class="detail-item" style="--order: 8;">
                <span class="label">Role:</span>
                <span class="value">${user.role}</span>
            </div>
            <div class="detail-item" style="--order: 9;">
                <span class="label">Membership Level:</span>
                <span class="value">
                    <c:choose>
                        <c:when test="${not empty user.membershipLevel}">
                            ${user.membershipLevel.levelId} (${user.membershipLevel.value})
                        </c:when>
                        <c:otherwise>
                            Không có cấp độ
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="detail-item" style="--order: 10;">
                <span class="label">Status:</span>
                <span class="${user.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">${user.status}</span>
            </div>
            <div class="detail-item" style="--order: 11;">
                <span class="label">Created At:</span>
                <span class="value">${user.createdAt}</span>
            </div>
            <div class="detail-item" style="--order: 12;">
                <span class="label">Updated At:</span>
                <span class="value">${user.updatedAt}</span>
            </div>
        </div>
    </div>
</body>
</html>