<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Sidebar</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: "Poppins", sans-serif;
            background-color: #f5f6fa;
        }

        .sidebar {
            width: 230px;
            min-width: 230px;
            max-width: 230px;
            flex-shrink: 0;
            background-color: #1e272e;
            color: white;
            padding: 20px;
            min-height: 100vh;
            box-sizing: border-box;
        }

        .sidebar .logo {
            text-align: center;
            margin-bottom: 30px;
            color: #ff6b35;
        }

        .menu {
            list-style: none;
            padding: 0;
            margin: 0;
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

        .submenu.open {
            display: block;
        }
        .contact-badge {
            background: red;
            color: white;
            border-radius: 50%;
            padding: 2px 7px;
            font-size: 12px;
            margin-left: 8px;
        }
    </style>
</head>

<body>
<div class="sidebar">
    <h2 class="logo">
        ${sessionScope.admin.username}
        <br>
        <span style="color: yellow; font-size: 14px;">Role: [${sessionScope.admin.role}]</span>
    </h2>

    <ul class="menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="${activePage == 'dashboard' ? 'active' : ''}">
                <i class="fa-solid fa-house"></i> Dashboard
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/admin/products"
               class="${activePage == 'products' ? 'active' : ''}">
                <i class="fa-solid fa-box"></i> Quản lý sản phẩm
            </a>
        </li>

        <%-- Kiểm tra logic loại trừ Staff Kho (role = 2) một cách chặt chẽ --%>
        <c:if test="${sessionScope.admin.role != 2 && sessionScope.admin.role != '2'}">
            <li>
                <a href="${pageContext.request.contextPath}/admin/orders"
                   class="${activePage == 'orders' ? 'active' : ''}">
                    <i class="fa-solid fa-receipt"></i> Quản lý đơn hàng
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/admin/users"
                   class="${activePage == 'users' ? 'active' : ''}">
                    <i class="fa-solid fa-user"></i> Quản lý user
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/admin/contact"
                   class="${activePage == 'contact' ? 'active' : ''}">
                    <i class="fa-solid fa-envelope"></i> Quản hệ liên hệ
                    <c:if test="${newCount > 0}">
                        <span class="contact-badge">${newCount}</span>
                    </c:if>
                </a>
            </li>
        </c:if>

        <li>
            <a href="javascript:void(0)"
               onclick="toggleWarehouse()"
               class="${activePage == 'warehouse' ? 'active' : ''}">
                <i class="fa-solid fa-cart-flatbed"></i>
                Quản lý nhập kho
                <i class="fa-solid fa-caret-down" style="float:right;"></i>
            </a>

            <ul id="warehouseMenu" class="submenu ${activePage == 'warehouse' ? 'open' : ''}">
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

        <li>
            <a href="${pageContext.request.contextPath}/admin-logout">
                <i class="fa-solid fa-door-closed"></i> Đăng xuất
            </a>
        </li>
    </ul>
</div>

<script>
    function toggleWarehouse() {
        var menu = document.getElementById("warehouseMenu");
        menu.classList.toggle("open");
    }
</script>
</body>
</html>