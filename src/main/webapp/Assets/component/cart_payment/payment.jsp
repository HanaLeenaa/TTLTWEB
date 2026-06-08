<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thanh Toán Đơn Hàng</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/same_style/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/cart_payment/payment.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
</head>

<body>

<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<main>
    <form id="paymentForm" action="${pageContext.request.contextPath}/confirm-order" method="post">

        <c:forEach items="${paramValues.selectedItems}" var="productId">
            <input type="hidden" name="selectedItems" value="${productId}" />
        </c:forEach>

        <div class="container1">
            <div class="payment-grid">

                <div class="information1">
                    <p class="title title1">Thông tin nhận hàng</p>

                    <div class="name_infor">
                        <p class="p1 p-same">Họ và tên người nhận hàng</p>
                        <input type="hidden" name="fullname" value="${sessionScope.auth.username}" />
                        <p class="p2">${sessionScope.auth.username}</p>
                    </div>

                    <div class="name_infor">
                        <p class="p1 p-same">Số điện thoại</p>
                        <input type="hidden" name="phone" value="${sessionScope.auth.phoneNum}" />
                        <p class="p2">${sessionScope.auth.phoneNum}</p>
                    </div>

                    <c:choose>
                        <c:when test="${sessionScope.auth.location == null || fn:trim(sessionScope.auth.location) == ''}">
                            <div class="same-style">
                                <div class="parent">
                                    <input class="input11" type="text" id="address" name="address" placeholder="Nhập địa chỉ nhận hàng" required />
                                    <div class="child">
                                        <p class="p3 p-same">Địa chỉ</p>
                                    </div>
                                </div>
                                <button type="button" class="btn btn-primary btn-sm mt-2" onclick="saveLocation()">Lưu</button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="name_infor">
                                <p class="p1 p-same">Địa chỉ</p>
                                <input type="hidden" name="address" value="${sessionScope.auth.location}" />
                                <p class="p2">${sessionScope.auth.location}</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="name_infor">
                        <p class="p1 p-same">Email</p>
                        <input type="hidden" name="email" value="${sessionScope.auth.email}" />
                        <p class="p2">${sessionScope.auth.email}</p>
                    </div>

                    <div class="same-style">
                        <div class="parent">
                            <input class="input11" type="text" name="note" placeholder="Ví dụ: Giao giờ hành chính..."/>
                            <div class="child">
                                <p class="p3 p-same">Ghi chú đơn hàng (tùy chọn)</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="product1">
                    <p class="title title3">Đơn hàng (${quantity} sản phẩm)</p>

                    <c:forEach var="item" items="${orderItems}">
                        <div class="flex_infor_product padding-same same">
                            <div class="part1">
                                <div class="parent2">
                                    <img src="${item.product_image}"/>
                                    <div class="child2">
                                        <p class="number">${item.quantity}</p>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <p class="title-item">${item.product_name}</p>
                            </div>
                            <div class="part3">
                                <p><fmt:formatNumber value="${item.product_price * item.quantity}" type="number" groupingUsed="true"/>đ</p>
                            </div>
                        </div>
                    </c:forEach>

                    <%--======VOUCHER=====--%>
                    <hr>
                        <div class="voucher-row">
                        <span>
                            <i class="fa-solid fa-ticket"></i>
                            Voucher
                        </span>

                            <a href="${pageContext.request.contextPath}/voucher-list">

                                <c:choose>

                                    <c:when test="${selectedVoucher != null}">
                                        ${selectedVoucher.code}
                                    </c:when>

                                    <c:otherwise>
                                        Chọn Voucher
                                    </c:otherwise>

                                </c:choose>

                                >
                            </a>

                        </div>
                    <hr>
                    <%--TÍNH TỔNG TIỀN KHI ÁP DỤNG VOUCHER--%>
                    <div class="summary">
                        <p><b>Tổng tiền:</b>
                            <fmt:formatNumber value="${totalAmount}" type="number"/> đ
                        </p>

                        <p><b>Giảm giá:</b>
                            <fmt:formatNumber value="${discountAmount}" type="number"/> đ
                        </p>

                        <p><b>Thanh toán:</b>
                            <span id="finalAmount">
                                <fmt:formatNumber value="${finalAmount}" type="number"/> đ
                            </span>
                        </p>
                    </div>

                    <hr>

                    <div class="payment-main same">
                        <p class="title title2">Thanh toán</p>
                        <div class="payment_method_1 payment">
                            <label>
                                <input type="radio" name="payment_method" value="COD" checked required />
                                Thanh toán khi nhận hàng (COD)
                            </label>
                        </div>
                        <div class="payment_method_2 payment">
                            <label>
                                <input type="radio" name="payment_method" value="VNPAY" required />
                                Thanh toán qua VNPay
                            </label>
                        </div>
                    </div>

                    <div class="update_and_order same grid-same">
                        <div>
                            <button class="same-btn btn-green" type="button" style="cursor: pointer" onclick="location.href='${pageContext.request.contextPath}/cart'">Sửa giỏ hàng</button>
                            <button class="same-btn btn-green" type="button" style="cursor: pointer" onclick="location.href='${pageContext.request.contextPath}/profile'">Sửa địa chỉ</button>
                        </div>
                        <button type="submit" class="same-btn btn-red" style="cursor:pointer">Đặt hàng</button>
                    </div>
                </div>

            </div>
        </div>
    </form>
</main>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />

<style>
    .container1 { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
    .payment-grid { display: flex; gap: 40px; align-items: flex-start; }
    .information1 { flex: 0 0 58%; background: #fff; padding: 24px; border-radius: 8px; }
    .product1 { flex: 0 0 38%; background: #f9f9f9; padding: 36px 26px; border-radius: 10px; border: 1px solid #ddd; }
    .product1 > * { margin-bottom: 22px; }
    .name_infor { border: 1px solid #ccc; border-radius: 6px; margin-bottom: 14px; padding: 12px 14px; background: #fff; }
    @media (max-width: 800px) { .payment-grid { flex-direction: column; } .information1, .product1 { width: 100%; } }
</style>

<script>
    function saveLocation() {
        const address = document.getElementById("address").value.trim();
        if (!address) return;
        fetch("save-location", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "address=" + encodeURIComponent(address)
        }).then(res => res.text()).then(() => { location.reload(); });
    }

    document.getElementById("paymentForm").addEventListener("submit", function(event) {
        // Cả 2 phương thức đều chuyển hướng về servlet trung gian để hiển thị trang Order.jsp (chế độ chưa confirm)
        this.action = "${pageContext.request.contextPath}/confirm-order";
    });
</script>
</body>
</html>