<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">


    <style>
        h2 {
            margin-bottom: 16px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .btn-add {
            background-color: #43a047;
            color: white;
            padding: 8px 14px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
        }

        .btn-add:hover {
            background-color: #2e7d32;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background-color: #f5f5f5;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        tr:hover {
            background-color: #fafafa;
        }

        .btn-edit {
            color: #1e88e5;
            text-decoration: none;
            margin-right: 8px;
        }

        .btn-edit:hover {
            color: #0d47a1;
        }

        .btn-delete {
            color: #e53935;
            text-decoration: none;
        }

        .btn-delete:hover {
            color: #b71c1c;

        }
        .action-buttons {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
        }

    </style>
</head>

<body>

<div class="top-bar">
    <h2>QUẢN LÝ SẢN PHẨM</h2>
    <a class="btn-add"
       href="${pageContext.request.contextPath}/admin/products/add">
        ➕ Thêm sản phẩm
    </a>
</div>

<table>
    <tr>
        <th>ID</th>
        <th>Tên</th>
        <th>Giá</th>
        <th>Active</th>
        <th>Premium</th>
        <th>Hành động</th>
    </tr>

    <c:forEach items="${products}" var="p">
        <tr>
            <td>${p.ID}</td>
            <td>${p.name}</td>
            <td>${p.price}</td>
            <td>${p.active}</td>
            <td>${p.ispremium}</td>
            <td>
                <div class="action-buttons">
                <a class="btn-edit"
                   href="${pageContext.request.contextPath}/admin/products/edit?id=${p.ID}">
                    <i class="fa-regular fa-pen-to-square"></i> Sửa
                </a>

                <a class="btn-delete"
                   href="${pageContext.request.contextPath}/admin/products/delete?id=${p.ID}"
                   onclick="return confirm('Xóa sản phẩm này?')">
                    <i class="fa-regular fa-trash-can"></i> Xóa
                </a>
                </div>
            </td>
        </tr>
    </c:forEach>
</table>

</body>
</html>

