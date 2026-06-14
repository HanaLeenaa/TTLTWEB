<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Lịch sử nhập kho</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">

    <style>
        body {
            font-family: "Poppins";
            background: #f5f6fa;
        }

        .admin-wrapper {
            display: flex;
        }

        .content {
            flex: 1;
            padding: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background: #f1f3f9;
            color: #555555;
        }
    </style>
</head>

<body>

<div class="admin-wrapper">

    <!--SIDEBAR-->
    <jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>

    <div class="content">
        <h2><i class="fa-light fa-receipt"></i> Lịch sử nhập kho</h2>

        <table>
            <tr>
                <th>ID</th>
                <th>Sản phẩm</th>
                <th>Số lượng</th>
                <th>Loại</th>
                <th>Người nhập</th>
                <th>Thời gian</th>
            </tr>

            <c:forEach var="h" items="${historyList}">
                <tr>
                    <td>${h.ID}</td>
                    <td>${h.productName}</td>
                    <td>+${h.quantity}</td>
                    <td>${h.type}</td>
                    <td>${h.userName}</td>
                    <td>${h.createdAt}</td>
                </tr>
            </c:forEach>

        </table>
    </div>

</div>

</body>
</html>