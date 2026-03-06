<%-- Created by IntelliJ IDEA.--%>
<%--  User: HUU DAT--%>
<%--  Date: 12/6/2025--%>
<%--  Time: 6:46 PM--%>
<%--  To change this template use File | Settings | File Templates.--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm</title>
    <link rel="stylesheet" href="Assets/css/homeStyle/product.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="Assets/css/recycleFilecss/header.css">
    <link rel="stylesheet" href="Assets/css/recycleFilecss/footer.css">
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
<jsp:include page="/Assets/component/recycleFiles/header.jsp"/>


<main id="content">

    <!--  loc san pham          -->
    <div class="filter" id="filter-panel">

        <div class="title">LOẠI SẢN PHẨM</div>
        <c:forEach var="c" items="${categories}">
            <div class="choice">
                <input type="checkbox" class="check filter-brand" value="${c.name}"><label>${c.name}</label>
            </div>
        </c:forEach>

        <div class="title">CHỌN MỨC GIÁ</div>
        <div class="choice">
            <input type="checkbox" class="check filter-price" id="check1" name="checkbox1" value="under500"><label>Giá
            dưới 500.000đ </label>
        </div>
        <div class="choice">
            <input type="checkbox" class="check filter-price" id="check2" name="checkbox1" value="500-1000"><label>500.000đ
            - 1 triệu </label>
        </div>

        <div class="choice">
            <input type="checkbox" class="check filter-price" id="check3" name="checkbox1" value="1000-2000"><label>1 -
            2 triệu </label>
        </div>
        <div class="choice">
            <input type="checkbox" class="check filter-price" id="check4" name="checkbox1" value="2000-3000"><label>2 -
            3 triệu </label>
        </div>
        <div class="choice">
            <input type="checkbox" class="check filter-price" id="check5" name="checkbox1" value="higher3000"><label>Trên
            3 triệu </label>
        </div>


        <div class="title">THƯƠNG HIỆU</div>
        <c:forEach var="c" items="${brands}">
            <div class="choice">
                <input type="checkbox" class="check filter-brand" id="${c.ID}" name="checkbox2" value="${c.brand_name}"><label>${c.brand_name}</label>
            </div>
        </c:forEach>


        <div class="title">
            Pin
        </div>
        <c:forEach var="c" items="${energy}">
            <div class="choice">
                <input type="checkbox" class="check filter-category"
                       value="${c.useTime}"><label>${c.useTime}hours</label>
            </div>
        </c:forEach>

    </div>


    <!-- san pham           -->
    <div class="contain">

        <div class="contain-header">
            <div class="Loai">Console</div>
                <%--Chức năng sắp xếp theo giá tăng/giảm dần và mới nhất--%>
            <form method="get" id="sortForm">
            <div class="sort">
                <i class="fa-solid fa-arrow-down-wide-short"></i></i>
                <label>Sắp xếp:</label>

                <div class="sort-box" onclick="toggleSortMenu()">
                    <span class="sort-selected">
                        <c:choose>
                            <c:when test="${param.sort == 'price_asc'}">Giá tăng dần</c:when>
                            <c:when test="${param.sort == 'price_desc'}">Giá giảm dần</c:when>
                            <c:when test="${param.sort == 'newest'}">Hàng mới nhất</c:when>
                            <c:otherwise>Mặc định</c:otherwise>
                        </c:choose>
                    </span>
                    <i class="fa-solid fa-chevron-down"></i>
                </div>
                    <%--hidden input gui len servlet--%>
                    <input type="hidden" name="sort" id="sortInput" value="${param.sort}">

                    <ul class="sort-menu" id="sortMenu">
                        <li onclick="selectSort('')">Mặc định</li>
                        <li onclick="selectSort('price_asc')">Giá tăng dần</li>
                        <li onclick="selectSort('price_desc')">Giá giảm dần</li>
                        <li onclick="selectSort('newest')">Hàng mới nhất</li>
                    </ul>
                </div>
            </form>
        </div>





        <button id="filter-btn" class="filter-toggle">
            <i class="fa-solid fa-sliders"></i> Bộ lọc
        </button>


        <!--  San Pham -->
        <div id="product-list">
            <!--SP1 -->
            <c:forEach var="c" items="${premium}">
                <a href="${pageContext.request.contextPath}/product-detail?id=${c.ID}">
                    <div class="product-item sony remotehandheld">
                        <img src="${c.image}" alt="">
                        <div class="tag">Premium</div>

                        <div class="product-info">
                            <h4>${c.name}</h4>
                            <p class="price">${c.price}đ</p>
                        </div>
                    </div>
                </a>
            </c:forEach>


            <!--SP2.1 -->
            <c:forEach var="c" items="${products}">
                <a href="${pageContext.request.contextPath}/product-detail?id=${c.ID}">
                    <div class="product-item sony handheldpc">
                        <img src="${c.image}" alt="">

                        <div class="product-info">
                            <h4>${c.name}</h4>
                            <p class="price">${c.price}đ</p>
                        </div>
                    </div>
                </a>
            </c:forEach>


        </div>

        <!-- pagination-->
        <div class="pagination">
            <a href="#" class="active">1</a>
            <a href="#">2</a>
            <a href="#">3</a>
            <a href="#">4</a>
            <a href="#">5</a>
            <a href="#">6</a>
            <a href="#">7</a>
            <a href="#">8</a>
            <a href="#">9</a>
            <a href="#">10</a>
            <a href="#">&raquo;</a>

        </div>
        <div id="no-products-message" style="display:none; text-align: center; margin-top: 20px;">
            ❌ Không có sản phẩm nào phù hợp với tiêu chí lọc.
        </div>

    </div>


</main>

<%-- chức năng sắp xếp sản phẩm theo giá tăng, giảm dần--%>
<script>
    function toggleSortMenu(){
        document.getElementById("sortMenu").classList.toggle("active");
    }

    function selectSort(value){
        document.getElementById("sortInput").value = value;
        document.getElementById("sortForm").submit();
    }

    // đóng menu khi click ra ngoài
    document.addEventListener("click", function (e){
        if (!e.target.closest(".sort")){
            document.getElementById("sortMenu").classList.remove("active");

        }
    });
</script>
<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>
</body>
</html>
