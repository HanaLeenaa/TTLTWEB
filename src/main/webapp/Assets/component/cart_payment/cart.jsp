<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Giỏ Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/cart_payment/cart.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/same_style/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
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

        .product-info{
            display:flex;
            flex-direction:column;
            gap:4px;
        }

        .stock-error{
            color:#e53935;
            font-size:14px;
            font-weight:500;
        }

        .btn-order:disabled{
            background:#ccc;
            cursor:not-allowed;
        }

        .cart-error{
            background:#ffebee;
            color:#d32f2f;
            padding:12px;
            border-radius:8px;
            margin-bottom:16px;
            font-weight:500;
        }

    </style>
</head>
<body>

<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<div class="container" id="cart-item">
    <a href="${pageContext.request.contextPath}/product" class="back-btn">
        ← Tiếp tục mua sắm
    </a>

    <div class="title">
        <p>Giỏ hàng của bạn: <span id="for_you">${sessionScope.auth.username}</span></p>
        <div class="edit-area">
            <button type="button" id="editBtn">Sửa</button>
            <form id="deleteAllForm" action="${pageContext.request.contextPath}/cartAction" method="post">
                <input type="hidden" name="action" value="clear">
                <button type="submit" id="deleteAllBtn">Xóa tất cả</button>
            </form>
        </div>
    </div>

    <c:set var="cart" value="${sessionScope.cart}" />

    <c:if test="${not empty sessionScope.cartError}">
        <div class="cart-error">
                ${sessionScope.cartError}
        </div>

        <c:remove var="cartError" scope="session"/>
    </c:if>

    <table class="cart-table">
        <tbody id="cart-items">
        <%-- CHUẨN HÓA: Quét trực tiếp requestScope do Servlet đẩy sang, triệt tiêu c:set lỗi --%>
        <c:choose>
            <c:when test="${empty requestScope.cart}">
                <tr>
                    <td colspan="4" style="text-align: center; padding: 50px 0;">
                        <i class="bi bi-cart-x" style="font-size: 48px; color: #ccc;"></i>
                        <h3 style="margin-top: 15px; color: #666;">Hiện chưa có sản phẩm nào trong giỏ hàng của bạn</h3>
                    </td>
                </tr>
            </c:when>

            <c:otherwise>
                <c:forEach items="${requestScope.cart}" var="item">
                    <tr>
                        <td class="select-col" style="width: 5%;">
                            <input type="checkbox"
                                   name="selectedItems"
                                   value="${item.product.ID}"
                                   class="select-item"
                                   form="mainForm"
                                   data-price="${item.product.price}"
                                   data-id="${item.product.ID}"
                                   checked>
                        </td>

                        <td style="width: 10%;">
                            <img src="${item.product.image}" width="80" style="border-radius: 5px; object-fit: cover;">
                        </td>

                        <td class="product-cell" style="width: 80%;">
                                    <div class="product-row">
                                        <div class="product-info">
                                            <span class="product-name">${item.product.name}</span>
                                            
                                            <%-- ĐOẠN HIỂN THỊ LỖI KHO REALTIME (Gộp từ develop qua) --%>
                                            <c:if test="${not empty item.error}">
                                                <p class="stock-error" style="color: red; font-size: 0.85rem; margin: 4px 0 0 0;">
                                                    ${item.error}
                                                </p>
                                            </c:if>
                                        </div>

                                        <%-- CHUẨN HÓA: Đọc chính xác thuộc tính định dạng chuỗi từ Product model của bạn --%>
                                        <span class="product-price">${item.product.priceFormatted}đ</span>

                                        <div class="quantity">
                                            <%-- Nút giảm số lượng của bạn --%>
                                            <form action="${pageContext.request.contextPath}/cartAction" method="post" style="margin:0;">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="${item.product.ID}">
                                                <input type="hidden" name="productName" value="${item.product.name}">
                                                <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                                <button type="submit" class="qty-btn">−</button>
                                            </form>

                                            <span class="qty-number" data-id="${item.product.ID}">
                                                ${item.quantity}
                                            </span>

                                            <%-- Nút tăng số lượng của bạn --%>
                                            <form action="${pageContext.request.contextPath}/cartAction" method="post" style="margin:0;">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="${item.product.ID}">
                                                <input type="hidden" name="productName" value="${item.product.name}">
                                                <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                                <button type="submit" class="qty-btn">+</button>
                                            </form>
                                        </div>
                                    </div>
                                </td>

                        <td style="width: 5%; text-align: center;">
                            <form action="${pageContext.request.contextPath}/cartAction" method="post" style="margin:0;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="productId" value="${item.product.ID}">
                                <button type="submit" style="border:none;background:none;cursor:pointer;">
                                    <i class="fa fa-trash"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>

                <tr class="summary-row">
                    <td colspan="2"></td>
                    <td colspan="2">
                        <span>Tổng tiền thanh toán tạm tính: </span>
                        <span id="total-price" class="total-amount">0đ</span>
                    </td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

<form id="mainForm" action="${pageContext.request.contextPath}/payment" method="get">
        <button type="submit" class="btn-order" ${hasStockError ? 'disabled' : ''}>Đặt hàng</button>
</form>
</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />

<script>
    // Logic ẩn/hiện nút xóa tất cả
    const editBtn = document.getElementById("editBtn");
    const deleteAllBtn = document.getElementById("deleteAllBtn");
    let editing = false;

    if (editBtn && deleteAllBtn) {
        editBtn.addEventListener("click", () => {
            editing = !editing;
            deleteAllBtn.style.display = editing ? "block" : "none";
            editBtn.innerText = editing ? "Xong" : "Sửa";
        });
    }
</script>

<script>
    // Tự động tính tiền dựa trên Checkbox
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
                    const price = Number(cb.dataset.price) || 0;
                    const id = cb.dataset.id;
                    const qtyEl = document.querySelector(".qty-number[data-id='" + id + "']");

                    if (qtyEl) {
                        const qty = Number(qtyEl.innerText.trim()) || 0;
                        total += price * qty;
                    }
                }
            });
            if(totalPriceEl) {
                totalPriceEl.innerText = formatVND(total);
            }
        }

        checkboxes.forEach(cb => {
            cb.addEventListener("change", calculateTotal);
        });

        calculateTotal();
    });
</script>
</body>
</html>