<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>Danh sách yêu thích</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/login_logout/wishlist.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

</head>
<!-- <div id="header"></div> -->
<jsp:include page="/Assets/component/recycleFiles/header.jsp"/>

<body>
<main>
    <div id="content">
        <!-- Cột trái: bộ lọc -->
        <form id="filterForm" action="${pageContext.request.contextPath}/wishlist" method="get">
            <div class="filter" id="filter-panel">
                <div class="filter-header" style="display: flex; justify-content: space-between; align-items: center; padding: 10px 15px;">
                    <span style="font-weight: bold;">BỘ LỌC</span>
                    <a href="${pageContext.request.contextPath}/wishlist" style="font-size: 12px; color: #E95221; text-decoration: none;">Xóa tất cả</a>
                </div>

                <!-- CATEGORY -->
                <c:forEach var="cat" items="${categories}">
                    <div class="choice">
                        <input type="checkbox" name="categoryId" value="${cat.ID}"
                            <c:if test="${selectedCategoryIds != null && selectedCategoryIds.contains(cat.ID)}">checked</c:if> />
                        <label>${cat.name}</label>
                    </div>
                </c:forEach>

                <!-- PRICE -->
                <div class="title">CHỌN MỨC GIÁ</div>
                <c:forEach var="p" items="${['under500','500-1m','1-2m','2-3m','over3m']}">
                    <div class="choice">
                        <input type="radio" name="priceRange" value="${p}"
                               <c:if test="${selectedPriceRange == p}">checked</c:if> />
                        <label>
                            <c:choose>
                                <c:when test="${p=='under500'}">Dưới 500,000đ</c:when>
                                <c:when test="${p=='500-1m'}">500,000đ - 1 triệu</c:when>
                                <c:when test="${p=='1-2m'}">1 - 2 triệu</c:when>
                                <c:when test="${p=='2-3m'}">2 - 3 triệu</c:when>
                                <c:otherwise>Trên 3 triệu</c:otherwise>
                            </c:choose>
                        </label>
                    </div>
                </c:forEach>

                <!-- BRAND -->
                <div class="title">THƯƠNG HIỆU</div>
                <c:forEach var="b" items="${brands}">
                    <div class="choice">
                        <input type="checkbox" name="brandId" value="${b.ID}"
                            <c:if test="${selectedBrandIds != null && selectedBrandIds.contains(b.ID)}">checked</c:if> />
                        <label>${b.brand_name}</label>
                    </div>
                </c:forEach>
            </div>
        </form>

        <!-- Cột phải: danh sách sản phẩm -->
        <div class="contain">
            <div class="contain-header">
                 <div class="Loai">Danh sách sản phẩm yêu thích</div>
                      <%--Chức năng sắp xếp theo giá tăng/giảm dần và mới nhất--%>
                        <form method="get" id="sortForm" action="${pageContext.request.contextPath}/wishlist">
                            <!-- giữ lại các filter khi sort -->
                            <c:forEach var="c" items="${selectedCategoryIds}">
                                <input type="hidden" name="categoryId" value="${c}">
                            </c:forEach>

                            <input type="hidden" name="priceRange" value="${selectedPriceRange}">

                            <c:forEach var="b" items="${selectedBrandIds}">
                                <input type="hidden" name="brandId" value="${b}">
                            </c:forEach>

                            <div class="sort">
                                <i class="fa-solid fa-arrow-down-wide-short"></i>
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


            <div id="product-list">
                <c:choose>
                    <c:when test="${empty wishlist}">
                        <div class="no-product">
                            Bạn chưa có sản phẩm yêu thích nào.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="c" items="${wishlist}">
                            <div class="product-item">
                                <button type="button" class="remove-icon" onclick="removeWishlist('${c.ID}')">
                                        x
                                </button>
                                <a href="${pageContext.request.contextPath}/product-detail?id=${c.ID}">
                                    <img src="${c.image}" alt="">
                                    <h4>${c.name}</h4>
                                </a>
                                <c:if test="${c.ispremium}">
                                    <div class="tag">Premium</div>
                                </c:if>
                                <div class="price-actions">
                                    <p class="price">${c.price}đ</p>
                                    <form method="post" action="${pageContext.request.contextPath}/buy-now">
                                        <input type="hidden" name="productId" value="${c.ID}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="btn-buy">
                                            Mua ngay
                                        </button>
                                    </form>

                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- pagination-->
            <div class="pagination">
                <c:forEach begin="1" end="${totalPage}" var="i">

                    <c:url var="pageUrl" value="/product">
                        <c:param name="page" value="${i}" />

                        <c:if test="${not empty keyword}">
                            <c:param name="q" value="${keyword}" />
                        </c:if>

                        <c:if test="${not empty param.categoryId}">
                            <c:param name="categoryId" value="${param.categoryId}" />
                        </c:if>

                        <c:if test="${not empty param.priceRange}">
                            <c:param name="priceRange" value="${param.priceRange}" />
                        </c:if>

                        <c:if test="${not empty param.sort}">
                            <c:param name="sort" value="${param.sort}" />
                        </c:if>

                        <c:forEach var="b" items="${paramValues.brandId}">
                            <c:param name="brandId" value="${b}" />
                        </c:forEach>

                        <c:forEach var="u" items="${paramValues.useTime}">
                            <c:param name="useTime" value="${u}" />
                        </c:forEach>
                    </c:url>

                    <a class="${i == currentPage ? 'active' : ''}" href="${pageUrl}">
                            ${i}
                    </a>

                </c:forEach>
            </div>

        </div>
    </div>
</main>


<script>
function removeWishlist(productId) {
    fetch('${pageContext.request.contextPath}/RemoveWishlist', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'productId=' + encodeURIComponent(productId)
    })
    .then(res => res.json())
    .then(data => {
        alert(data.message);
        location.reload();
    })
    .catch(err => console.error(err));
}
</script>

<script>
function toggleSortMenu() {
    const sortDiv = document.querySelector(".sort");
    sortDiv.classList.toggle("open");
}

function selectSort(value) {
    document.getElementById("sortInput").value = value;
    document.getElementById("sortForm").submit();
}
</script>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // Lấy tất cả checkbox và radio trong form
    const inputs = document.querySelectorAll('#filterForm input[type="checkbox"], #filterForm input[type="radio"]');

    inputs.forEach(input => {
        input.addEventListener('change', function() {
            document.getElementById('filterForm').submit();
        });
    });
});
</script>


</body>
</html>
