<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Payment</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/same_style/style.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/cart_payment/payment.css" />
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

</head>

<body>

<!-- HEADER -->
<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<main>

    <form action="${pageContext.request.contextPath}/place-order" method="post">

        <div class="container1">
            <div class="payment-grid">

                <!--thông tin nhận hàng-->
                <div class="information1">
                    <p class="title title1">Thông tin nhận hàng</p>

                    <div class="name_infor">
                        <p class="p1 p-same">Họ và tên người nhận hàng</p>
                        <p class="p2">${sessionScope.auth.username}</p>
                    </div>

                    <div class="name_infor">
                        <p class="p1 p-same">Số điện thoại</p>
                        <p class="p2">${sessionScope.auth.phoneNum}</p>
                    </div>

                    <!-- địa chỉ -->
                    <c:choose>
                        <c:when test="${sessionScope.auth.location == null || fn:trim(sessionScope.auth.location) == ''}">
                            <div class="same-style">
                                <div class="parent">
                                    <input class="input11"
                                           type="text"
                                           id="address"
                                           name="address"
                                           placeholder="Nhập địa chỉ"
                                           required />
                                    <div class="child">
                                        <p class="p3 p-same">Địa chỉ</p>
                                    </div>
                                </div>
                                <button type="button"
                                        class="btn btn-primary btn-sm mt-2"
                                        onclick="saveLocation()">
                                    Lưu
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="name_infor">
                                <p class="p1 p-same">Địa chỉ</p>
                                <p class="p2">${sessionScope.auth.location}</p>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="name_infor">
                        <p class="p1 p-same">Email</p>
                        <p class="p2">${sessionScope.auth.email}</p>
                    </div>

                    <div class="same-style">
                        <div class="parent">
                            <input class="input11" type="text" name="note"/>
                            <div class="child">
                                <p class="p3 p-same">Ghi chú đơn hàng (tùy chọn)</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- đơn hàng + thanh toán -->
                <div class="product1">

            <p class="title title3">
                Đơn hàng (${quantity} sản phẩm)
            </p>

            <c:forEach var="item" items="${cartItems}">
                <div class="flex_infor_product padding-same same">

                    <div class="part1">
                        <div class="parent2">
                            <img src="${item.product.image}"
                                 alt="${item.product.metatitle}" />
                            <div class="child2">
                                <p class="number">${item.quantity}</p>
                            </div>
                        </div>
                    </div>

                    <div>
                        <p class="title-item">${item.product.name}</p>
                    </div>

                    <div class="part3">
                        <p>
                                ${item.product.priceValue * item.quantity}đ
                        </p>
                    </div>

                </div>
            </c:forEach>

            <hr>

<%--    <p><b>Tổng số lượng:</b> ${quantity}</p>--%>
<%--    <p><b>Tổng tiền:</b> ${totalPrice}đ</p>--%>


    <!-- data submit -->
                    <input type="hidden" name="productName" value="${product.name}">
                    <input type="hidden" name="quantity" value="${quantity}">
                    <input type="hidden" name="totalPrice" value="${totalPrice}">

                    <!-- thanh toán -->
                    <div class="payment-main same">
                        <p class="title title2">Thanh toán</p>

                        <div class="payment_method_1 payment">
                            <label>
                                <input type="radio"
                                       name="paymentMethod"
                                       value="COD"
                                       checked
                                       required />
                                Thanh toán khi nhận hàng (COD)
                            </label>
                        </div>

                        <div class="payment_method_2 payment">
                            <label>
                                <input type="radio"
                                       name="paymentMethod"
                                       value="BANK" />
                                Thanh toán qua ngân hàng
                            </label>
                        </div>
                    </div>

                    <!-- buttons -->
                    <div class="update_and_order same grid-same">
                        <div>
                            <button class="same-btn btn-green" type="button" style="cursor: pointer"
                                    onclick="location.href='${pageContext.request.contextPath}/cart'">
                                Sửa giỏ hàng
                            </button>

                            <button class="same-btn btn-green" type="button" style="cursor: pointer"
                                    onclick="location.href='${pageContext.request.contextPath}/profile'">
                                Sửa địa chỉ
                            </button>
                        </div>

                        <button type="submit"
                                class="same-btn btn-red"
                                style="cursor:pointer">
                            Đặt hàng
                        </button>
                    </div>

                </div>

            </div>
        </div>

    </form>

</main>

<!-- FOOTER -->
<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />

<style>
    .container1 {
        max-width: 1200px;
        margin: 40px auto;
        padding: 0 20px;
    }

    .payment-grid {
        display: flex;
        gap: 40px;
        align-items: flex-start;
    }

    .information1 {
        flex: 0 0 58%;
        background: #fff;
        padding: 24px;
        border-radius: 8px;
    }

    .product1 {
        flex: 0 0 38%;
        background: #f9f9f9;
        padding: 36px 26px;
        border-radius: 10px;
        border: 1px solid #ddd;
    }

    .product1 > * {
        margin-bottom: 22px;
    }

    .name_infor {
        border: 1px solid #ccc;
        border-radius: 6px;
        margin-bottom: 14px;
        padding: 12px 14px;
        background: #fff;
    }

    @media (max-width: 800px) {
        .payment-grid {
            flex-direction: column;
        }
        .information1,
        .product1 {
            width: 100%;
        }
    }
</style>
<script>
    function saveLocation() {
        const address = document.getElementById("address").value.trim();
        if (!address) return;

        fetch("save-location", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "address=" + encodeURIComponent(address)
        })
            .then(res => res.text())
            .then(() => {
                location.reload(); // reload nhẹ để đổi UI
            });
    }
</script>

</body>
</html>

