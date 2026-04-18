<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
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

        .submenu {
            list-style: none;
            padding-left: 15px;
            display: none;
        }

        .submenu li a {
            font-size: 14px;
            padding: 8px;
            background-color: #2f3640;
            margin-top: 5px;
        }

        .submenu li a:hover {
            background-color: #ff6b35;
        }

        .submenu li a.active-sub {
            background-color: #e95211;
        }

        .menu li:has(.active-sub) > a.active {
            background: transparent;
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

        <li>
            <a href="${pageContext.request.contextPath}/admin/import"
               onclick="toggleWarehouse()"
               class="${activePage == 'warehouse' ? 'active' : ''}">
                <i class="fa-solid fa-cart-flatbed"></i>
                Quản lý nhập kho
                <i class="fa-solid fa-caret-down" style="float:right;"></i>
            </a>


            <ul id="warehouseMenu" class="submenu"
            style="${activePage == 'warehouse' ? 'display:block;' : 'display:none;'}">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/import"
                       class="${subPage == 'import-create' ? 'active-sub' : ''}">
                        <i class="fa-solid fa-plus"></i> Nhập vào kho
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/import-history"
                       class="${subPage == 'import-history' ? 'active-sub' : ''}">
                        <i class="fa-solid fa-newspaper"></i> Lịch sử nhập kho
                    </a>
                </li>
            </ul>
        </li>


        <li><a href="${pageContext.request.contextPath}/admin-logout">🚪 Đăng xuất</a></li>
    </ul>
</div>
<script>
    function toggleWarehouse() {
        var menu = document.getElementById("warehouseMenu");

        if (menu.style.display === "block") {
            menu.style.display = "none";
        } else {
            menu.style.display = "block";
        }
    }
</script>

<script>
    window.onload = function() {
        var activePage = "${activePage}";
        if (activePage === "warehouse") {
            document.getElementById("warehouseMenu").style.display = "block";
        }
    }
</script>
</body>
</html>
