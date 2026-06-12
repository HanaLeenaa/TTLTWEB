<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Nhập vào kho</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">

    <style>
        body {
            margin: 0;
            font-family: "Poppins", sans-serif;
            background-color: #f5f6fa;
        }

        .admin-wrapper {
            display: flex;
        }

        .content {
            flex: 1;
            padding: 30px;
        }

        h2 {
            margin-bottom: 20px;
        }

        .card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        input, select {
            padding: 8px;
            margin: 5px;
            width: 200px;
        }

        button {
            padding: 8px 15px;
            border: none;
            background: #ff6b35;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background: #e6521f;
        }

        table {
            width: 100%;
            margin-top: 15px;
            border-collapse: collapse;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 10px;
            text-align: center;
        }

    </style>
</head>
<body>


<div class="admin-wrapper">

    <!--SIDEBAR-->
    <jsp:include page="/Assets/component/adminPage/sidebar.jsp"/>

    <div class="content">
<%-- Thông báo nhập hàng thành công--%>
        <c:if test="${not empty message}">
            <div id="alert-message" style="padding: 15px; background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 5px; margin-bottom: 20px;">
                <i class="fa-solid fa-circle-check"></i> ${message}
            </div>
            <c:remove var="message" scope="session" />
        </c:if>

        <h2>Nhập vào kho</h2>

        <!-- TẠO PHIẾU -->
        <div class="card">
            <form action="${pageContext.request.contextPath}/admin/import" method="get">
                <input type="hidden" name="action" value="create"/>
                <button type="submit"><i class="fa-solid fa-plus"></i> Tạo phiếu nhập</button>
            </form>
        </div>

<c:if test="${not empty receiptId}">

<!-- THÊM SẢN PHẨM -->
        <div class="card">
            <h3>Thêm sản phẩm vào phiếu (ID: ${receiptId})</h3>

            <form action="${pageContext.request.contextPath}/admin/import" method="post">
                <input type="hidden" name="action" value="addItem"/>
                <input type="hidden" name="receiptId" value="${receiptId}"/>

                <label>Product:</label>
                <select name="productId">
                    <c:forEach var="p" items="${productList}">
                        <option value="${p.ID}">${p.name}</option>
                    </c:forEach>
                </select>

                <label>Số lượng:</label>
                <input type="number" name="quantity" min="1" required/>

                <button type="submit">Thêm</button>
            </form>
        </div>

        <!-- DANH SÁCH ITEM -->
        <div class="card">
            <h3>Danh sách sản phẩm trong phiếu</h3>

            <table>
                <tr>
                    <th>Product ID</th>
                    <th>Tên</th>
                    <th>Số lượng</th>
                </tr>

                <c:forEach var="item" items="${itemList}">
                    <tr>
                        <td>${item.productId}</td>
                        <td>${item.productName}</td>
                        <td>${item.quantity}</td>
                    </tr>
                </c:forEach>
            </table>
        </div>

        <!-- CONFIRM -->
        <div class="card">
            <form action="${pageContext.request.contextPath}/admin/import" method="post">
                <input type="hidden" name="action" value="confirm"/>
                <input type="hidden" name="receiptId" value="${receiptId}"/>

                <button type="submit">
                    <i class="fa-regular fa-square-check"></i> Xác nhận nhập kho</button>
            </form>
        </div>
</c:if>
    </div>
</div>

<script>
    window.onload = function() {
        var alertBox = document.getElementById('alert-message');
        if (alertBox) {
            setTimeout(function() {
              alertBox.remove();
            }, 5000);
        }
    };
</script>
</body>
</html>
