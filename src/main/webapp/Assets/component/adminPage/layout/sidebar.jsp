<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <style>
        body {
            margin: 0;
            font-family: "Poppins", sans-serif;
            background-color: #f5f6fa;
        }

        .admin-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 230px;
            background-color: #1e272e;
            color: white;
            padding: 20px;
        }

        .sidebar .logo {
            text-align: center;
            margin-bottom: 30px;
            color: #ff6b35;
        }

        .menu {
            list-style: none;
            padding: 0;
        }

        .menu li {
            margin-bottom: 15px;
        }

        .menu a {
            color: white;
            text-decoration: none;
            font-size: 16px;
            display: block;
            padding: 10px;
            border-radius: 6px;
            transition: 0.3s;
        }

        .menu a:hover {
            background-color: #ff6b35;
        }
        .menu a.active{
            background: #e95211;
        }
    </style>
</head>

<body>
<div class="sidebar">
    <h2 class="logo">${sessionScope.admin.username}</h2>

    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/admin/dashboard"
            class="${activePage == 'dashboard' ? 'active' : ''}">
            🏠 Dashboard</a></li>

        <li><a href="${pageContext.request.contextPath}/admin/products"
               class="${activePage == 'products' ? 'active' : ''}">
            📦 Quản lý sản phẩm</a></li>

        <li><a href="${pageContext.request.contextPath}/admin/orders"
               class="${activePage == 'orders' ? 'active' : ''}" >
            🧾 Quản lý đơn hàng</a></li>

        <li><a href="${pageContext.request.contextPath}/admin/users"
            class="${activePage == 'users' ? 'active' : ''}">
            👤 Quản lý user</a></li>

        <li><a href="${pageContext.request.contextPath}/admin-logout">🚪 Đăng xuất</a></li>
    </ul>
</div>
</body>
</html>
