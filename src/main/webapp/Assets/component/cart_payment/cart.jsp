<%--
  Created by IntelliJ IDEA.
  User: HUU DAT
  Date: 12/6/2025
  Time: 6:56 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/cart_payment/cart.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/same_style/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
    />
    <style>
        .container {
            width: 1200px;
            margin: auto;
        }
        .cart-table {
            width: 100%;
            border-collapse: collapse;
        }
        .cart-table td {
            padding: 16px 0;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        .title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #f7f8f9;
            padding: 10px 15px;
            border-radius: 10px;
            box-shadow: 0 0 10px #cbcbcb;
            margin: 10px 0;
        }

        .title p {
            font-size: 20px;
            font-weight: 700;
            margin: 0;
        }

        .product-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 30px;
        }

        .product-name {
            flex: 1;
            font-weight: 500;
        }

        .product-price {
            min-width: 120px;
            text-align: right;
            font-weight: bold;
            color: #e95221;
            white-space: nowrap;
        }
        .select-item {
            margin: 0 20px;
            transform: scale(1.2);
        }
        .quantity {
            display: flex;
            align-items: center;
        }
        .qty-form {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
        }
        .qty-btn {
            width: 28px;
            height: 28px;
            border: 1px solid #e95221;
            background: white;
            cursor: pointer;
            font-size: 18px;
            line-height: 1;
            border-radius: 5px;
            color: #e95221;
        }
        .qty-number {
            min-width: 24px;
            text-align: center;
            font-weight: bold;
        }
        .fa-trash {
            font-size: 18px;
            color: #666;
            cursor: pointer;
        }
        .summary-row td {
            text-align: right;
            font-size: 18px;
            border-bottom: none;
        }
        .total-amount {
            color: #e95221;
            font-size: 22px;
            font-weight: bold;
        }
        .cart-action {
            display: flex;
            justify-content: center;
            margin: 40px 0;
        }
        .btn-order {
            width: 300px;
            height: 50px;
            border-radius: 30px;
            font-size: 18px;
            font-weight: bold;
            background-color: #e95221;
            color: #fff;
            border: none;
            cursor: pointer;

        }
        .btn-order:hover {
            opacity: 0.9;
        }
        #editBtn {
            background: none;
            border: none;
            font-size: 16px;
            font-weight: bold;
            color: #e95221;
            cursor: pointer;
        }

        #deleteAllBtn {
            display: none;
            margin-top: 6px;
            background: none;
            border: none;
            font-size: 14px;
            color: red;
            cursor: pointer;
        }

        #deleteAllBtn:hover {
            text-decoration: underline;
        }
        .back-btn {
            display: inline-block;
            margin-bottom: 20px;
            color: #e95221;
            font-weight: 600;
            text-decoration: none;
        }
        .back-btn:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>

<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<a href="${pageContext.request.contextPath}/product"
   class="back-btn">
    ← Tiếp tục mua sắm
</a>

<div class="container" id="cart-item">
    <div class="title">
        <p>Giỏ hàng của bạn: <span id="for_you">${sessionScope.auth.username}</span></p>
        <div class="edit-area">
            <button type="button" id="editBtn">Sửa</button>

            <!-- Xóa tất cả sản phẩm trong cart -->
            <form id="deleteAllForm"
                  action="${pageContext.request.contextPath}/cartAction"
                  method="post">
                <input type="hidden" name="action" value="clear">
                <button type="submit" id="deleteAllBtn">Xóa tất cả</button>
            </form>
        </div>
    </div>

    <c:set var="cart" value="${sessionScope.cart}" />
    <form id="mainForm"
          action="${pageContext.request.contextPath}/payment"
          method="get">

    <table class="cart-table">
        <tbody id="cart-items">

        <c:choose>
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
                <c:set var="total" value="0" />

                <c:forEach items="${cart.cartItems.values()}" var="item">
                    <c:set var="total"
                           value="${total + item.product.priceValue * item.quantity}" />

                    <tr>
                            <%--CHECKBOX--%>
                        <td class="select-col">
                            <input type="checkbox"
                                   name="selectedItems"
                                    value="${item.product.ID}"
                                    class="select-item"
                                    data-price="${item.product.priceValue}"
                                    data-id="${item.product.ID}">
                        </td>

                        <td>
                            <img src="${item.product.image}" width="80">
                        </td>

                                <td class="product-cell">
                                    <div class="product-row">
                                        <span class="product-name">${item.product.name}</span>
                                        <span class="product-price">${item.product.price}đ</span>

                                    <%--Tang/giam so luong san pham trng gio--%>
                        <div class="quantity">
                            <form action="${pageContext.request.contextPath}/cartAction" method="post" class="qty-form">
                                <button type="submit"
                                        name="action"
                                        value="decrease_${item.product.ID}"
                                        class="qty-btn">−</button>

                            <span class="qty-number"
                                    data-id="${item.product.ID}">
                                    ${item.quantity}
                            </span>


                                <button type="submit"
                                        name="action"
                                        value="increase_${item.product.ID}"
                                        class="qty-btn">+</button>
                            </form>
                        </div>
                                    </div>
                                </td>

                        <%-- XÓA từng SP --%>
                        <td>
                            <form action="${pageContext.request.contextPath}/cartAction" method="post">
                                <input type="hidden" name="action" value="remove_${item.product.ID}">
                                <button type="submit"
                                        style="border:none;background:none;cursor:pointer;">
                                <i class="fa fa-trash"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>

</tbody>


        <tr class="summary-row">
            <td colspan="3" style="border-bottom: none">TỔNG TIỀN:</td>
            <td class="total-amount" style="border-bottom: none">
                <span id="total-price">0đ</span>
            </td>
        </tr>
    </table>


        <button type="submit" class="btn-order">Đặt hàng</button>
    </form>

</div>
<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />


<script>

    const editBtn = document.getElementById("editBtn");
    const deleteAllBtn = document.getElementById("deleteAllBtn");

    let editing = false;

    deleteAllBtn.style.display = "none";

    editBtn.addEventListener("click", () => {
        editing = !editing;

        deleteAllBtn.style.display = editing ? "block" : "none";

        editBtn.innerText = editing ? "Xong" : "Sửa";
    });
</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {

        const checkboxes = document.querySelectorAll(".select-item");
        const totalPriceEl = document.getElementById("total-price");

        function formatVND(number) {
            return number.toLocaleString("vi-VN") + "đ";
        }

        function calculateTotal() {
            let total = 0;

            checkboxes.forEach(cb => {
                if (cb.checked) {
                    const price = Number(cb.dataset.price);
                    const id = cb.dataset.id;

                    const qtyEl = document.querySelector(
                        ".qty-number[data-id='" + id + "']"
                    );

                    if (!qtyEl) return;

                    const qty = Number(qtyEl.innerText.trim());
                    total += price * qty;
                }
            });

            totalPriceEl.innerText = formatVND(total);
        }

        checkboxes.forEach(cb => {
            cb.addEventListener("change", calculateTotal);
        });

    });
</script>

</body>
</html>

