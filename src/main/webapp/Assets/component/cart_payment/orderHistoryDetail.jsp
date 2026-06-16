<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            margin-right: auto;
        }

        .back-btn:hover {
            opacity: 0.9;
        }
        .action-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .cancel-order-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 12px 22px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: 0.3s;
        }
        .cancel-order-btn:hover {
            background: #bb2d3b;
        }

        .review-btn{
            background:#ff9800;
            color:white;
            text-decoration:none;
            padding:12px 22px;
            border-radius:8px;
            font-size:15px;
            font-weight:600;
        }

        .review-btn:hover{
            background:#f57c00;
        }

        .order-table td {
            vertical-align: top;
        }

        .product-info span {
            display: block;
            word-break: break-word;
            max-width: 300px;
        }

        .order-table td:last-child {
            vertical-align: top;
            width: 140px;
        }

    </style>
</head>
<body>

<jsp:include page="/Assets/component/recycleFiles/header.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<%-- Thông báo hủy đơn thành công --%>
<c:if test="${not empty sessionScope.success}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                icon: 'success',
                title: 'Thông báo',
                text: '${sessionScope.success}'
            });
        });
    </script>
    <c:remove var="success" scope="session"/>
</c:if>

<div class="order-detail-container">
    <div class="order-detail-title">Chi tiết lịch sử mua hàng</div>

    <div class="order-info-box">
        <p><strong>Mã đơn hàng:</strong> #${order.ID}</p>

        <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.createAt}" pattern="dd/MM/yyyy HH:mm:ss" /></p>

        <p><strong>Người nhận:</strong> ${order.receiver_name} - ${order.receiver_phone}</p>
        <p><strong>Địa chỉ nhận:</strong> ${order.receiver_address}</p>
        <p><strong>Phương thức thanh toán:</strong> ${order.payment_method}</p>
        <p><strong>Trạng thái thanh toán:</strong> ${order.payment_status}</p>
        <p><strong>Trạng thái đơn hàng:</strong> <span style="font-weight: bold; color: #e85221;">${order.status}</span></p>
        <p><strong>Ghi chú đơn hàng:</strong> ${not empty order.receiver_note ? order.receiver_note : 'Không có ghi chú'}</p>

        <hr style="border: 0; border-top: 1px dashed #ccc; margin: 15px 0;">

        <p>
            <strong>Phí vận chuyển:</strong>
            <fmt:formatNumber value="${order.shippingFee}" type="number"/> đ
        </p>
        <p>
            <strong>Giảm giá voucher:</strong>
            <fmt:formatNumber value="${order.discount_amount}" type="number"/> đ
        </p>
        <p>
            <strong>Tổng tiền thanh toán:</strong>
            <span style="font-size: 18px; color: #e85221; font-weight: bold;">
                <fmt:formatNumber value="${order.final_amount}" type="number"/> đ
            </span>
        </p>
    </div>

    <table class="order-table">
        <thead>
        <tr>
            <th>Sản phẩm</th>
            <th>Đơn giá</th>
            <th>Số lượng</th>
            <th>Thành tiền</th>
            <th>Thao tác</th>
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

                <td class="action-cell">
                    <c:if test="${order.status == 'Đã giao'}">
                        <a class="review-btn"
                           href="${pageContext.request.contextPath}/product-detail?id=${item.product_id}&review=true#review-section">
                            Đánh giá
                        </a>
                    </c:if>
                </td>

            </tr>
        </c:forEach>
        </tbody>
    </table>

    <div class="total-box">
        Tổng cộng: <fmt:formatNumber value="${order.final_amount}" type="number"/> đ
    </div>

    <div class="action-buttons">

    <a class="back-btn" href="${pageContext.request.contextPath}/profile?tab=orders">
        ← Quay lại lịch sử mua hàng
    </a>

        <c:if test="${order.status == 'Đã giao'}">

            <a class="review-btn"
               href="${pageContext.request.contextPath}/product-detail?id=${reviewProductId}&review=true#review-section">

                Đánh giá sản phẩm

            </a>

        </c:if>

    <%--NÚT HỦY ĐƠN--%>
    <c:if test="${order.status == 'Chờ xác nhận'
                || order.status == 'Đã xác nhận'
                || order.status == 'Đang giao'}">

        <form id="cancelOrderForm"
              action="${pageContext.request.contextPath}/cancel-order"
              method="post">

            <input type="hidden"
                    name="orderId"
                    value="${order.ID}">

            <button type="button"
                    class="cancel-order-btn"
                    onclick="confirmCancelOrder()">
                Hủy đơn hàng
            </button>

        </form>

    </c:if>
    </div>
</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

<script>
    function confirmCancelOrder() {
        Swal.fire({
            title: 'Xác nhận hủy đơn?',
            text: 'Bạn có chắc chắn muốn hủy đơn hàng này?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Có, hủy đơn',
            cancelButtonText: 'Không'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('cancelOrderForm').submit();
            }
        });
    }
</script>
</body>
</html>