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
        .search-wrapper{
            display: flex;
            justify-content: flex-end;
            width: 100%;
            margin-bottom: 18px;
        }
        .search-box{
            position: relative;
            width: 300px;
        }
        .search-box input {
            width: 100%;
            padding: 10px 44px 10px 14px;
            border: none;
            outline: none;
            border-radius: 10px;
            background-color: #cce5ff;
            font-size: 16px;
            box-sizing: border-box;
        }

        .search-box i {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #0b74f8;
            font-size: 22px;
            cursor: pointer;
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

<div class="search-wrapper">
    <form action="${pageContext.request.contextPath}/admin/products" method="get">
    <div class="search-box">
        <input type="text" name="keyword" placeholder="Tìm sản phẩm..."
            value="${param.keyword}">
            <i class="fa-solid fa-magnifying-glass"></i>
</div>
    </form>
</div>

<table>
    <tr>
        <th>ID</th>
        <th>Hình ảnh</th>
        <th>Tên</th>
        <th>Giá</th>
        <th>Số lượng</th>
        <th>Active</th>
        <th>Premium</th>
        <th>Hành động</th>
    </tr>

    <c:forEach items="${products}" var="p">
        <tr>
            <td>${p.ID}</td>
            <td>
                <c:choose>
                    <c:when test="${p.image.startsWith('http')}">
                        <img src="${p.image}" width="80" alt="${p.name}">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/${p.image}" width="80" alt="${p.name}">
                    </c:otherwise>
                </c:choose>
            </td>
            <td>${p.name}</td>
            <td>${p.price}</td>
            <td>${p.stock_quantity}</td>
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

