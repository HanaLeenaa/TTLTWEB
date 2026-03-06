<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng | Admin</title>

    <!-- CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/admin-orders.css">

    <style>
        body {
            margin: 0;
            font-family: "Poppins", Arial, sans-serif;
            background: #f4f6fb;
        }

        /* wrapper chính */
        .admin-orders-wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* phần content bên phải sidebar */
        .order-list,
        .order-detail {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
        }

        /* grid cho content */
        .admin-orders-wrapper > .order-list {
            flex: 1.2;
            margin: 20px;
        }

        .admin-orders-wrapper > .order-detail {
            flex: 1;
            margin: 20px 20px 20px 0;
        }

        /* tiêu đề */
        h2, h3 {
            margin-top: 0;
            margin-bottom: 15px;
            font-weight: 600;
        }

        /* table */
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .admin-table th {
            text-align: left;
            padding: 12px;
            background: #f1f3f9;
            color: #555;
        }

        .admin-table td {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }

        .admin-table tr:hover {
            background: #f8f9ff;
        }

        .admin-table tr.active {
            background: #eaf0ff;
        }

        /* badge trạng thái */
        .status {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .status.pending {
            background: #fff3cd;
            color: #856404;
        }

        .status.confirmed {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status.shipping {
            background: #cce5ff;
            color: #004085;
        }

        .status.completed {
            background: #d4edda;
            color: #155724;
        }

        .status.cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        /* link */
        a {
            color: #4b7bec;
            text-decoration: none;
            font-weight: 500;
        }

        /* form */
        form {
            margin-top: 10px;
        }

        select {
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        button {
            margin-left: 8px;
            padding: 6px 14px;
            border-radius: 6px;
            border: none;
            background: #4b7bec;
            color: white;
            cursor: pointer;
        }

        button:hover {
            background: #3867d6;
        }

        /* detail info */
        .order-detail p {
            margin: 6px 0;
            font-size: 14px;
        }

        /* table nhỏ */
        .admin-table.small th,
        .admin-table.small td {
            font-size: 13px;
        }

    </style>
</head>

<body>

<div class="admin-orders-wrapper">
    <jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>
    <!-- ================= DANH SÁCH ĐƠN ================= -->
    <div class="order-list">
        <h2>📦 Quản lý đơn hàng</h2>

        <table class="admin-table">
            <tr>
                <th>ID</th>
                <th>Người nhận</th>
                <th>SĐT</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Ngày tạo</th>
                <th></th>
            </tr>

            <c:forEach items="${orders}" var="o">
                <tr class="${selectedOrder.ID == o.ID ? 'active' : ''}">
                    <td>#${o.ID}</td>
                    <td>${o.receiver_name}</td>
                    <td>${o.receiver_phone}</td>
                    <td>${o.price} đ</td>
                    <td>
    <span class="status ${o.status}">
            ${o.status}
    </span>
                    </td>

                    <td>${o.createAt}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/orders?id=${o.ID}">
                            Xem
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>

    <!-- ================= CHI TIẾT ĐƠN ================= -->
    <div class="order-detail">

        <c:if test="${not empty selectedOrder}">
            <h3>🧾 Đơn hàng #${selectedOrder.ID}</h3>

            <p><b>Người nhận:</b> ${selectedOrder.receiver_name}</p>
            <p><b>SĐT:</b> ${selectedOrder.receiver_phone}</p>
            <p><b>Email:</b> ${selectedOrder.receiver_email}</p>
            <p><b>Địa chỉ:</b> ${selectedOrder.receiver_address}</p>

            <p><b>Thanh toán:</b>
                <c:choose>
                    <c:when test="${selectedOrder.payment_method}">Online</c:when>
                    <c:otherwise>COD</c:otherwise>
                </c:choose>
            </p>

            <!-- UPDATE STATUS -->
            <form action="${pageContext.request.contextPath}/admin/order-update" method="post">
                <input type="hidden" name="id" value="${selectedOrder.ID}">

                <select name="status">
                    <option value="pending" ${selectedOrder.status=='pending'?'selected':''}>Pending</option>
                    <option value="confirmed" ${selectedOrder.status=='confirmed'?'selected':''}>Confirmed</option>
                    <option value="shipping" ${selectedOrder.status=='shipping'?'selected':''}>Shipping</option>
                    <option value="completed" ${selectedOrder.status=='completed'?'selected':''}>Completed</option>
                    <option value="cancelled" ${selectedOrder.status=='cancelled'?'selected':''}>Cancelled</option>
                </select>

                <button type="submit">Cập nhật</button>
            </form>

            <hr>

            <table class="admin-table small">
                <tr>
                    <th>Sản phẩm</th>
                    <th>Giá</th>
                    <th>SL</th>
                </tr>

                <c:forEach items="${orderItems}" var="i">
                    <tr>
                        <td>${i.product_name}</td>
                        <td>${i.product_price} đ</td>
                        <td>${i.quantity}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>

        <c:if test="${empty selectedOrder}">
            <p>👈 Chọn đơn hàng để xem chi tiết</p>
        </c:if>

    </div>

</div>

</body>
</html>
