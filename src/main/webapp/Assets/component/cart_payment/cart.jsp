<%--
  Created by IntelliJ IDEA.
  User: HUU DAT
  Date: 12/6/2025
  Time: 6:56 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/cart_payment/cart.css">
    <link rel="stylesheet" href="/Assets/css/same_style/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
    />
</head>
<body>
<!-- <div id="header"></div> -->
<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<div class="container" id="cart-item">
    <div class="title">
        <p>Giỏ hàng của bạn: <span id="for_you">Khách</span></p>
    </div>

    <c:set var="cart" value="${sessionScope.cart}" />

    <table class="cart-table">
        <tbody id="cart-items">

        <c:choose>
<%--            GIO TRONG --%>
            <c:when test="${cart == null || empty cart.cartItems}">

            <tr>
            <td colspan="4" style="text-align: center;">

                <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="45"
                        height="45"
                        fill="currentColor"
                        class="bi bi-cart"
                        viewBox="0 0 16 16"
                >
                    <path
                            d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5M3.102 4l1.313 7h8.17l1.313-7zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4m7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4m-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2m7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2"
                    />
                </svg>
                <h3>Hiện chưa có sản phẩm nào trong giỏ hàng của bạn</h3>
            </td>
        </tr>
            </c:when>


            <c:otherwise>
                <c:forEach items="${cart.cartItems.values()}" var="item">
                    <tr>
                        <td>
                            <img src="${item.product.image}" width="80">
                        </td>
                        <td>
                            <p>${item.product.name}</p>
                        </td>
                        <td>
                                ${item.product.price}đ
                        </td>
                        <td>
                                ${item.quantity}
                        </td>

                        <td>
                            <a href="${pageContext.request.contextPath}/remove-from-cart?id=${item.product.ID}">
                                <i class="fa fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>

</tbody>


        <tr class="summary-row">
            <td colspan="3" style="border-bottom: none">TỔNG TIỀN:</td>
            <td class="total-amount" style="border-bottom: none">
                <span id="total-price">0</span>
            </td>
        </tr>
    </table>

    <a href=""><button class="checkout-btn">ĐẶT HÀNG</button></a>
</div>
<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />
</body>
</html>

