<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Admin - Contact</title>

    <style>
        body {
            font-family: Arial;
            background: #f4f6f9;
            margin: 0;
        }

        .container {
            padding: 20px;
        }

        h2 {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .badge {
            background: red;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }

        th {
            background: #f1f3f9;
            color: #555555;
        }

        tr:hover {
            background: #f1f1f1;
        }

        .status-new {
            color: red;
            font-weight: bold;
        }

        .status-read {
            color: green;
        }

        .btn {
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 13px;
        }

        .btn-read {
            background: #27ae60;
            color: white;
        }

        .btn-delete {
            background: #e74c3c;
            color: white;
        }

        .admin-wrapper {
            display: flex;
        }

        .container {
            flex: 1;
            padding: 20px;
        }

        .action-group {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .btn {
            white-space: nowrap;
        }

        .reply-box {
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .reply-box input {
            flex: 1;
            min-width: 100px;
            padding: 5px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }

        .reply-box button {
            padding: 5px 10px;
            white-space: nowrap;
        }
        .alert-error {
            background: #fdecea;
            color: #e74c3c;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            border-left: 4px solid #e74c3c;
        }
    </style>
</head>

<body>

<div class="admin-wrapper">

<jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>
<div class="container">

    <h2>
        Quản lý liên hệ
        <span class="badge">${newCount} NEW</span>
    </h2>

    <c:if test="${param.error == 'empty'}">
        <div class="alert-error">
            Không được để trống phản hồi!
        </div>
    </c:if>

    <table>
        <tr>
            <th>ID</th>
            <th>User</th>
            <th>Email</th>
            <th>SĐT</th>
            <th>Nội dung</th>
            <th>Trạng thái</th>
            <th>Thời gian</th>
            <th>Hành động</th>
        </tr>

        <c:forEach var="c" items="${contacts}">
            <tr>
                <td>${c.ID}</td>
                <td>${c.name}</td>
                <td>${c.email}</td>
                <td>${c.phone}</td>
                <td>${c.message}</td>

                <td>
                    <c:choose>
                        <c:when test="${c.status == 'NEW'}">
                            <span class="status-new">NEW</span>
                        </c:when>
                        <c:when test="${c.status == 'REPLIED'}">
                            <span style="color: blue; font-weight: bold;">REPLIED</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-read">READ</span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <td>${c.createdAt}</td>

                <td>
                    <div class="action-group">
                    <a class="btn btn-read"
                       href="${pageContext.request.contextPath}/admin/contact/read?id=${c.ID}">
                        <i class="fa-solid fa-check"></i> Read
                    </a>

                    <a class="btn btn-delete"
                       href="${pageContext.request.contextPath}/admin/contact/delete?id=${c.ID}">
                        <i class="fa-solid fa-xmark"></i> Delete
                    </a>
                    </div>

                    <form class="reply-box"
                          action="${pageContext.request.contextPath}/admin/contact/reply"
                          method="post">

                        <input type="hidden" name="id" value="${c.ID}" />

                        <input type="text" name="reply"
                               placeholder="Phản hồi..."
                               value="${c.reply != null ? c.reply : ''}" />

                        <button type="submit" class="btn btn-read">Gửi</button>
                    </form>
                </td>

            </tr>
        </c:forEach>
    </table>

</div>
</div>

<script>
    document.querySelectorAll('.reply-box').forEach(form => {
        const input = form.querySelector('input[name="reply"]');
        const btn = form.querySelector('button');

        const toggle = () => {
            btn.disabled = input.value.trim() === '';
        };


        toggle();

        input.addEventListener('input', toggle);
    });
</script>
</body>
</html>