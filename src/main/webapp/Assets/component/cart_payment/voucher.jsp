<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Voucher của bạn</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/same_style/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">

<style>
        .voucher-card {
            display: flex;
            align-items: center;
            flex-wrap: nowrap;
            gap: 12px;
            width: 100%;
            max-width: 1000px;
            border: 1px solid #eee;
            border-radius: 12px;
            margin-bottom: 12px;
            background: #fff;
            cursor: pointer;
            padding: 14px 16px;
            transition: 0.2s;
        }
        .voucher-card:hover {
            border-color: #e95211;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .voucher-left {
            width: 110px;
            min-width: 110px;
            height: 70px;
            background: #e95211;
            color: #fff;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            border-radius: 10px;
            position: relative;
            overflow: hidden;
        }

        .voucher-left::after {
            content: "";
            position: absolute;
            right: -10px;
            top: 0;
            width: 20px;
            height: 100%;
            background: #fff;
            border-radius: 20px 0 0 20px;
        }

        .voucher-right {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-width: 0;
        }
        .voucher-radio {
            margin-left: auto;
            display: flex;
            align-items: center;
        }

        .voucher-discount,
        .min_order,
        .voucher-exp {
            white-space: nowrap;
        }
        .voucher-radio input {
            width: 18px;
            height: 18px;
            accent-color: #e95211;
        }

        .voucher-card:has(input:checked) {
            border: 2px solid #d84b1e;
        }
        .voucher-discount {
            font-size: 16px;
            font-weight: 700;
            color: #d84b1e;
        }

        .min_order {
            font-size: 12px;
            color: #777;
            margin-top: 2px;
        }

        .voucher-exp {
            font-size: 12px;
            color: #999;
            margin-top: 2px;
        }
        .apply-btn {
            display: block;
            margin: 20px auto 0 auto;
            padding: 10px 20px;
            background-color: #e95211;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            width: 200px;
            text-align: center;
        }

        .apply-btn:hover {
            background-color: #e85a00;
        }

        .container-voucher {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 100%;
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 15px;
            box-sizing: border-box;
        }

        .container-voucher form {
            width: 100%;
            max-width: 750px;
            display: flex;
            flex-direction: column;
            align-items: center;

            .voucher-card {
                max-width: 100% !important;
                box-sizing: border-box;
            }

            .percent-line {
                display: flex;
                align-items: center;
                gap: 10px;
                white-space: nowrap;
            }

            .max-discount-percent {
                font-size: 12px;
                color: #777;
                white-space: nowrap;
            }
        }

    </style>

</head>

<body>
<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<main>
<div class="container-voucher">

    <h2>Chọn voucher của bạn</h2>

    <form method="post"
          action="${pageContext.request.contextPath}/voucher-list">

        <c:forEach items="${vouchers}" var="v">

            <label class="voucher-card">

                <div class="voucher-left">
                        ${v.code}
                </div>

                <div class="voucher-right">

                    <div class="voucher-discount">
                        <c:choose>

                            <c:when test="${v.discount_type=='PERCENT'}">
                            <div class="percent-line">
                                Giảm <fmt:formatNumber value="${v.discount_value}"
                                maxFractionDigits="0"/> %
                                <span class="max-discount-percent">
                                    Giảm tối đa <fmt:formatNumber value="${v.max_discount}"
                                                maxFractionDigits="0"
                                                type="number"
                                                groupingUsed="true"/> đ
                                </span>
                            </div>
                            </c:when>

                            <c:otherwise>
                                Giảm
                                <fmt:formatNumber value="${v.discount_value}"
                                                  maxFractionDigits="0"
                                                  type="number"
                                                  groupingUsed="true"/> đ
                            </c:otherwise>

                        </c:choose>
                    </div>
                    <div class="min_order">
                        Đơn tối thiểu <fmt:formatNumber value="${v.min_order_amount}"
                                            maxFractionDigits="0"
                                            type="number"
                                            groupingUsed="true"/> đ
                    </div>

                    <div class="voucher-exp">
                        HSD: <fmt:formatDate value="${v.end_date}"
                                        pattern="dd/MM/yyyy"/>
                    </div>

                </div>

                <div class="voucher-radio">
                    <input type="radio"
                           name="voucherId"
                           value="${v.ID}">

                </div>

            </label>

        </c:forEach>

        <button class="apply-btn">
            Áp dụng
        </button>

    </form>

</div>
</main>
<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />
</body>
</html>