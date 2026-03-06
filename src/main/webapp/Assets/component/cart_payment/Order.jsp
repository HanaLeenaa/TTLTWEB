<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <title>Chi tiết đơn hàng</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/cart_payment/OrderDetails.css"/>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css"/>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>

<!-- HEADER -->
<jsp:include page="/Assets/component/recycleFiles/header.jsp"/>

<div class="order-detail-container">
    <h2>CHI TIẾT ĐƠN HÀNG</h2>

    <!-- thông báo đặt hàng thành công -->
    <c:if test="${confirmed}">
        <div class="order-success">
            <i class="fa-solid fa-circle-check"></i>
            Đặt hàng thành công!
        </div>
    </c:if>

    <p><strong>Ngày đặt:</strong>
        <fmt:formatDate value="${order.createAt}" pattern="dd/MM/yyyy HH:mm"/>
    </p>

    <!-- thông tin khách hàng -->
    <div class="order-info">
        <h3>THÔNG TIN KHÁCH HÀNG</h3>
        <p><strong>Họ tên:</strong> ${order.receiver_name}</p>
        <p><strong>Số điện thoại:</strong> ${order.receiver_phone}</p>
        <p><strong>Địa chỉ:</strong> ${order.receiver_address}</p>
    </div>

    <!-- sản phẩm -->
    <div class="order-products">
        <h3>SẢN PHẨM</h3>
        <table>
            <thead>
            <tr>
                <th>Sản phẩm</th>
                <th>Số lượng</th>
                <th>Giá</th>
                <th>Thành tiền</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${orderItems}">
                <tr>
                    <td>${item.product_name}</td>
                    <td>${item.quantity}</td>
                    <td>
                        <fmt:formatNumber value="${item.product_price}" type="number" groupingUsed="true"/> ₫
                    </td>
                    <td>
                        <fmt:formatNumber value="${item.product_price * item.quantity}" type="number" groupingUsed="true"/> ₫
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- tổng tiền -->
    <div class="order-summary">
        <p>
            <strong>Tổng cộng:</strong>
            <span class="total">
                <fmt:formatNumber value="${order.price}" type="number" groupingUsed="true"/> ₫
            </span>
        </p>
    </div>

    <!-- button -->
    <div class="order-actions" style="margin-bottom: 10px">
        <c:if test="${!confirmed}">
            <form action="${pageContext.request.contextPath}/confirm-order" method="post">
                <button type="submit" class="confirm-btn">
                    <i class="fa-solid fa-check"></i> Xác nhận đặt hàng
                </button>
            </form>
        </c:if>
    </div>
    <a href="${pageContext.request.contextPath}/product"
       class="btn btn-secondary">
        Tiếp tục mua hàng
    </a>

</div>

<c:if test="${confirmed}">
    <c:remove var="pendingOrder" scope="session"/>
    <c:remove var="pendingOrderItems" scope="session"/>
    <c:remove var="orderConfirmed" scope="session"/>
    <c:remove var="confirmedOrderId" scope="session"/>
</c:if>


<!-- FOOTER -->
<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

</body>
</html>
