<%@ page import="com.tourismapp.config.ProjectPaths" %>
<%@ page import="com.tourismapp.controller.mainController.MainControllerServlet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>User Management</title>
        <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600&family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    </head>
    <body>
        <jsp:include page="../../components/sidebar.jsp" />
        <jsp:include page="../../components/toast.jsp" />

        <div id="main-content">
            <h4>User Management</h4>

            <!-- Search Form -->
            <form class="search-form" action="${pageContext.request.contextPath}/usermanagement" method="get">
                <input type="hidden" name="action" value="searchUsers">
                <label>
                    Username:
                    <input type="text" name="username" value="${param.username}" placeholder="Nhập username">
                </label>
                <label>
                    Status:
                    <select name="status">
                        <option value="">Tất cả</option>
                        <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                        <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                    </select>
                </label>
                <button type="submit">Tìm kiếm</button>
            </form>

            <!-- Form Create User -->
            <form class="create-user" action="main" method="get">
                <input type="hidden" name="action" value="createForm">
                <button type="submit">+ Thêm người dùng mới</button>
            </form>

            <!-- Danh sách user -->
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="4">Không tìm thấy người dùng nào.</td>
                        </tr>
                    </c:if>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td data-label="ID">${user.userId}</td>
                            <td data-label="Username">${user.username}</td>
                            <td data-label="Status">
                                <span class="${user.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">${user.status}</span>
                            </td>
                            <td data-label="Action">
                                <!-- Nút Xem -->
                                <form action="${pageContext.request.contextPath}/userManagement" method="get">
                                    <input type="hidden" name="action" value="viewUser">
                                    <input type="hidden" name="id" value="${user.userId}">
                                    <button type="submit" class="view-btn">Xem</button>
                                </form>
                                <!-- Nút Sửa -->
                                <form action="${pageContext.request.contextPath}/userManagement" method="get">
                                    <input type="hidden" name="action" value="editForm">
                                    <input type="hidden" name="id" value="${user.userId}">
                                    <button type="submit" class="edit-btn">Sửa</button>
                                </form>
                                <!-- Nút Xóa -->
                                <form action="${pageContext.request.contextPath}/userManagement" method="post"
                                      onsubmit="return confirm('Bạn có chắc chắn muốn xóa người dùng này không?');">
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                    <button type="submit" class="delete-btn">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Poppins', sans-serif;
        background: linear-gradient(135deg, #d0f0ff, #ffffff);
        color: #1a1a1a;
        min-height: 100vh;
        padding: 40px 20px;
    }

    #main-content {
        max-width: 1400px;
        margin: auto;
        background: #ffffffcc;
        backdrop-filter: blur(6px);
        border-radius: 15px;
        padding: 40px 30px;
        box-shadow: 0 8px 24px rgba(0, 179, 255, 0.2);
    }

    h4 {
        font-family: 'Orbitron', sans-serif;
        font-size: 2rem;
        color: #00b3ff;
        text-align: center;
        margin-bottom: 30px;
        text-shadow: 0 0 10px rgba(0, 179, 255, 0.3);
    }

    /* Search Form */
    .search-form {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        justify-content: center;
        margin-bottom: 20px;
        align-items: center;
    }

    .search-form label {
        display: flex;
        flex-direction: column;
        font-size: 0.9rem;
        color: #00b3ff;
    }

    .search-form input[type="text"],
    .search-form select {
        height: 36px;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 0.9rem;
        width: 200px;
    }

    .search-form button {
        height: 36px;
        padding: 0px 16px;
        margin-top: 20px;
        background: linear-gradient(90deg, #00ffcc, #00b3ff);
        border: none;
        border-radius: 5px;
        color: #ffffff;
        font-size: 0.9rem;
        font-weight: 600;
        cursor: pointer;
        transition: background-position 0.4s ease, transform 0.3s ease;
    }

    .search-form button:hover {
        background-position: 100%;
        transform: translateY(-2px);
        box-shadow: 0 3px 10px rgba(0, 179, 255, 0.4);
    }

    form.create-user {
        text-align: center;
        margin-bottom: 30px;
    }

    form.create-user button {
        padding: 12px 24px;
        background: linear-gradient(90deg, #00ffcc, #00b3ff, #ff00cc);
        background-size: 200%;
        border: none;
        border-radius: 8px;
        color: #ffffff;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: background-position 0.4s ease, transform 0.3s ease;
    }

    form.create-user button:hover {
        background-position: 100%;
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(0, 179, 255, 0.5);
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }

    table th,
    table td {
        padding: 12px 10px;
        border: 1px solid #ddd;
        text-align: center;
        font-size: 0.95rem;
    }

    table thead {
        background: #00b3ff;
        color: #ffffff;
    }

    table tbody tr:nth-child(even) {
        background-color: #f4faff;
    }

    table tbody tr:hover {
        background-color: #e1f5ff;
    }

    table td form {
        display: inline-block;
        margin: 0 2px;
    }

    table td button {
        padding: 6px 14px;
        font-size: 0.9rem;
        border-radius: 6px;
        border: none;
        cursor: pointer;
        color: #1a1a1a;
        font-weight: bold;
        transition: transform 0.3s, box-shadow 0.3s;
    }

    /* Nút Xem */
    table td button.view-btn {
        background: linear-gradient(90deg, #00ffcc, #00b3ff);
    }

    /* Nút Sửa */
    table td button.edit-btn {
        background: linear-gradient(90deg, #ffcc00, #ff9900);
    }

    /* Nút Xóa */
    table td button.delete-btn {
        background: linear-gradient(90deg, #ff6666, #ff3333);
    }

    table td button:hover {
        transform: translateY(-1px);
        box-shadow: 0 3px 10px rgba(0, 179, 255, 0.4);
    }

    /* Màu sắc cho Status */
    .status-active {
        color: #00ff00;
        font-weight: bold;
    }

    .status-inactive {
        color: #ff0000;
        font-weight: bold;
    }

    @media (max-width: 900px) {
        table thead {
            display: none;
        }

        table, table tbody, table tr, table td {
            display: block;
            width: 100%;
        }

        table tr {
            margin-bottom: 1.5rem;
            background: #ffffffee;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 179, 255, 0.1);
        }

        table td {
            text-align: left;
            padding: 10px 20px;
            position: relative;
        }

        table td::before {
            content: attr(data-label);
            font-weight: bold;
            color: #00b3ff;
            position: absolute;
            left: 20px;
            top: 10px;
            font-size: 0.85rem;
        }

        table td form {
            display: block;
            margin: 5px 0;
        }

        .search-form {
            flex-direction: column;
            align-items: center;
        }

        .search-form input[type="text"],
        .search-form select {
            width: 100%;
        }
    }
</style>