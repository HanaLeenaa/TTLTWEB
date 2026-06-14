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

</head>

<body>

<jsp:include page="/Assets/component/recycleFiles/header.jsp"/>

<div class="order-detail-container">
    <h2>CHI TIẾT ĐƠN HÀNG</h2>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <c:if test="${confirmed}">
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                Swal.fire({
                    icon: 'success',
                    title: 'Đặt hàng thành công!',
                    text: 'Cảm ơn bạn đã mua hàng tại cửa hàng của chúng tôi!',
                    confirmButtonText: 'OK'
                });
            });
        </script>
    </c:if>

    <p><strong>Ngày đặt:</strong>
        <fmt:formatDate value="${order.createAt}" pattern="dd/MM/yyyy HH:mm"/>
    </p>

    <div class="order-info">
        <h3>THÔNG TIN KHÁCH HÀNG</h3>
        <p><strong>Họ tên:</strong> ${order.receiver_name}</p>
        <p><strong>Số điện thoại:</strong> ${order.receiver_phone}</p>
        <p><strong>Địa chỉ:</strong> ${order.receiver_address}</p>
        <c:if test="${not empty order.ghnOrderCode}">
            <p>
                <strong>Mã vận đơn GHN:</strong>
                    ${order.ghnOrderCode}
            </p>
        </c:if>

        <p><strong>Phương thức thanh toán:</strong>
            <c:choose>
                <c:when test="${order.payment_method == 'VNPAY'}">
                    VNPay
                </c:when>
                <c:otherwise>
                    Thanh toán khi nhận hàng (COD)
                </c:otherwise>
            </c:choose>
        </p>

        <p><strong>Trạng thái thanh toán:</strong>
            <c:choose>
                <c:when test="${order.payment_status == 'PAID' || order.payment_status == 'Paid'}">
               <span style="color: green; font-weight: bold;">
                    Đã thanh toán
                </span>
                </c:when>
                <c:when test="${order.payment_status == 'UNPAID' || order.payment_status == 'Unpaid'}">
                 <span style="color: orange; font-weight: bold;">
                    Chưa thanh toán
                </span>
                </c:when>
                <c:otherwise>
                <span style="color: red; font-weight: bold;">
                    Không xác định
                </span>
                </c:otherwise>
            </c:choose>
        </p>
    </div>

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
                        <fmt:formatNumber value="${item.product_price * item.quantity}" type="number"
                                          groupingUsed="true"/> ₫
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="order-summary">
        <c:if test="${order.expectedDeliveryFrom != null}">
            <p>
                <strong>Dự kiến giao hàng:</strong><br/>

                <fmt:formatDate value="${order.expectedDeliveryFrom}" pattern="dd/MM"/>
                -
                <fmt:formatDate value="${order.expectedDeliveryTo}" pattern="dd/MM/yyyy"/>
            </p>
        </c:if>

        <p>
            <strong>Tạm tính:</strong>
            <fmt:formatNumber value="${order.price}"
                                type="number"
                                groupingUsed="true"/> đ
        </p>

        <c:if test="${order.discount_amount > 0}">
            <p style="color: green">
                <strong>Giảm giá:</strong>
                -
                <fmt:formatNumber value="${order.discount_amount}"
                                    type="number"
                                    groupingUsed="true"/> đ
            </p>
        </c:if>

        <p>
            <strong>Thanh toán:</strong>
            <span class="total">
                <fmt:formatNumber value="${order.final_amount}"
                                  type="number"
                                  groupingUsed="true"/> đ
            </span>
        </p>
        <p>
            <strong>Tổng thanh toán:</strong>
            <c:set var="ship" value="${empty shippingFee ? 0 : shippingFee}" />
            <fmt:formatNumber value="${order.price + ship}" type="number" groupingUsed="true"/> ₫
        </p>

    </div>

    <div class="order-actions" style="margin-bottom: 10px">
        <c:if test="${!confirmed}">
            <form id="finalConfirmForm" action="" method="post">
                <button type="submit" class="confirm-btn">
                    <i class="fa-solid fa-check"></i> Xác nhận đặt hàng
                </button>
            </form>
        </c:if>
    </div>

    <a href="${pageContext.request.contextPath}/product" class="back-btn">
        Tiếp tục mua hàng
    </a>

</div>

<c:if test="${confirmed}">
    <c:remove var="pendingOrder" scope="session"/>
    <c:remove var="pendingOrderItems" scope="session"/>
    <c:remove var="orderConfirmed" scope="session"/>
    <c:remove var="confirmedOrderId" scope="session"/>
</c:if>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

<script>
    // Chuẩn hóa chuỗi phương thức thanh toán từ JSTL EL sang JavaScript
    const method = "${order.payment_method}".toUpperCase().trim();
    const finalForm = document.getElementById("finalConfirmForm");

    if (finalForm) {
        if (method === "VNPAY") {
            // Nếu chọn VNPay -> Gửi tới servlet tạo link thanh toán kết nối ngân hàng VNPay
            finalForm.action = "${pageContext.request.contextPath}/vnpay-payment";
        } else {
            // Nếu chọn COD -> Gửi tới servlet mới tạo để thực thi lưu vào database chính thức
            finalForm.action = "${pageContext.request.contextPath}/submit-order-database";
        }
    }
</script>

</body>
</html>