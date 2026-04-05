<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6fb;
        }

        .admin-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .content {
            flex: 1;
            padding: 24px;
        }

        .box {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
        }

        h2 {
            margin-top: 0;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f1f3f9;
            text-align: left;
            padding: 12px;
            font-size: 14px;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }

        .role-badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
        }

        .role-admin { background: #ffeaa7; }
        .role-staff { background: #74b9ff; color: #fff; }
        .role-user  { background: #dfe6e9; }

        .status-badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
        }

        .active { background: #55efc4; }
        .inactive { background: #fab1a0; }

        .action-col form {
            display: inline;
            margin-right: 6px;
        }

        select {
            padding: 4px;
        }

        .action-col a,
        .action-col button {
            text-decoration: none;
            color: white;
            padding: 8px 14px;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: inline-block;
            transition: 0.2s;
        }

        .btn-edit {
            background: #3498db;
        }

        .btn-edit:hover {
            background: #2980b9;
        }

        .btn-lock {
            background: #e95211;
            color: white;
        }
        .btn-lock:hover {
            background: #ae2c00;
        }

        .btn-unlock {
            background: #00b894;
            color: white;
        }

        .btn-delete {
            background: red;
            color: white;
        }
        .btn-delete:hover {
            background: #d63031;
        }
    </style>
</head>

<body>

<div class="admin-wrapper">

    <!-- SIDEBAR (GIỮ NGUYÊN) -->
    <jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>

    <!-- CONTENT -->
    <div class="content">

        <div class="box">
            <h2>👤 Quản lý người dùng</h2>

            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Quyền</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td>#${u.id}</td>
                        <td>${u.username}</td>
                        <td>${u.email}</td>

                        <!-- ROLE -->
                        <td>
                            <span class="role-badge
                                <c:choose>
                                    <c:when test="${u.role == 'ADMIN'}">role-admin</c:when>
                                    <c:when test="${u.role == 'STAFF'}">role-staff</c:when>
                                    <c:otherwise>role-user</c:otherwise>
                                </c:choose>
                            ">
                                    ${u.role}
                            </span>
                        </td>

                        <!-- STATUS -->
                        <td>
                            <span class="status-badge
                                <c:choose>
                                    <c:when test="${u.active}">active</c:when>
                                    <c:otherwise>inactive</c:otherwise>
                                </c:choose>
                            ">
                                <c:choose>
                                    <c:when test="${u.active}">Hoạt động</c:when>
                                    <c:otherwise>Đã khoá</c:otherwise>
                                </c:choose>
                            </span>
                        </td>

                        <!-- ACTION -->
                        <td class="action-col">

                            <%--SỬA USER --%>
                            <a href="${pageContext.request.contextPath}/admin/edit-user?id=${u.id}"
                                class="btn-edit">
                                Sửa
                            </a>

                            <!-- KHOÁ / MỞ -->
                            <form action="${pageContext.request.contextPath}/admin/toggle-user"
                                  method="post">
                                <input type="hidden" name="userId" value="${u.id}">
                                <button type="submit"
                                        class="${u.active ? 'btn-lock' : 'btn-unlock'}">
                                        ${u.active ? 'Khoá' : 'Mở'}
                                </button>
                            </form>

                            <!-- XOÁ -->
                            <form action="${pageContext.request.contextPath}/admin/delete-user"
                                  method="post"
                                  onsubmit="return confirm('Xoá user này?');">
                                <input type="hidden" name="userId" value="${u.id}">
                                <button type="submit" class="btn-delete">Xoá</button>
                            </form>

                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty users}">
                    <tr>
                        <td colspan="6" style="text-align:center;color:#999;">
                            Không có người dùng nào
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>

        </div>

    </div>
</div>

</body>
</html>
