<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết lịch sử mua hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">
    <style>
        .order-detail-container {
            width: 1100px;
            margin: 30px auto;
            background: #fff;
        }

        .order-detail-title {
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .order-info-box {
            background: #f8f8f8;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            line-height: 1.9;
        }

        .order-info-box p {
            margin: 6px 0;
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid #ddd;
            background: #fff;
        }

        .order-table th,
        .order-table td {
            border: 1px solid #ddd;
            padding: 14px 10px;
            text-align: center;
            vertical-align: middle;
        }

        .order-table th {
            background: #e95211;
            color: #fff;
        }

        .order-table tbody tr:hover {
            background: #fafafa;
        }

        .product-info {
            display: flex;
            align-items: center;
            gap: 12px;
            text-align: left;
        }

        .product-info img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 8px;
        }

        .total-box {
            margin-top: 20px;
            text-align: right;
            font-size: 20px;
            font-weight: bold;
            color: #e85221;
        }

        .back-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 18px;
            background: #e85221;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }

        .back-btn:hover {
            opacity: 0.9;
        }
    </style>

</head>
<body>

<!-- HEADER -->
<jsp:include page="/Assets/component/recycleFiles/header.jsp"/>

<div class="order-detail-container">
    <div class="order-detail-title">Chi tiết lịch sử mua hàng</div>

    <div class="order-info-box">
        <p><strong>Mã đơn hàng:</strong> #${order.ID}</p>
        <p><strong>Ngày đặt:</strong> ${order.createAt}</p>
        <p><strong>Địa chỉ nhận:</strong> ${order.receiver_address}</p>
        <p><strong>Phương thức thanh toán:</strong> ${order.payment_method}</p>
        <p><strong>Trạng thái thanh toán:</strong> ${order.payment_status}</p>
        <p><strong>Trạng thái:</strong> ${order.status}</p>
        <p><strong>Ghi chú đơn hàng:</strong> ${order.receiver_note}</p>
        <p>
            <strong>Tổng tiền:</strong>
            <fmt:formatNumber value="${order.price}" type="number"/>đ
        </p>
    </div>

    <table class="order-table">
        <thead>
        <tr>
            <th>Sản phẩm</th>
            <th>Đơn giá</th>
            <th>Số lượng</th>
            <th>Thành tiền</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach var="item" items="${orderItems}">
            <tr>
                <td>
                    <div class="product-info">
                        <img src="${item.product_image}" alt="${item.product_name}">
                        <span>${item.product_name}</span>
                    </div>
                </td>
                <td>
                    <fmt:formatNumber value="${item.product_price}" type="number"/>đ
                </td>
                <td>${item.quantity}</td>
                <td>
                    <fmt:formatNumber value="${item.product_price * item.quantity}" type="number"/>đ
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <div class="total-box">
        Tổng cộng: <fmt:formatNumber value="${order.price}" type="number"/>đ
    </div>

    <a class="back-btn" href="${pageContext.request.contextPath}/profile?tab=orders">
        ← Quay lại lịch sử mua hàng
    </a>
</div>


<!-- FOOTER -->
<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

</body>
</html>
