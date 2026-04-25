<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    <!--  lọc sản phẩm  -->
    <form id="filterForm" action="${pageContext.request.contextPath}/product" method="get">
        <!-- GIỮ SEARCH -->
        <c:if test="${not empty param.q}">
            <input type="hidden" name="q" value="${fn:escapeXml(param.q)}" />
        </c:if>


        <div class="filter" id="filter-panel">
            <div class="filter-header" style="display: flex; justify-content: space-between; align-items: center; padding: 10px 15px;">
                <span style="font-weight: bold;">BỘ LỌC</span>
                <a href="${pageContext.request.contextPath}/product" style="font-size: 12px; color: #E95221; text-decoration: none;">Xóa tất cả</a>
            </div>

            <!-- CATEGORY -->
            <div class="title">LOẠI SẢN PHẨM</div>
            <c:forEach var="cat" items="${categories}">
                <div class="choice">
                    <input type="checkbox" name="categoryId" value="${cat.ID}"
                        <c:if test="${selectedCategoryIds != null && selectedCategoryIds.contains(cat.ID)}">checked</c:if> />
                    <label>${cat.name}</label>
                </div>
            </c:forEach>


            <!-- PRICE -->
            <div class="title">CHỌN MỨC GIÁ</div>
            <c:set var="price" value="${param.priceRange}" />
            <c:forEach var="p" items="under500,500-1m,1-2m,2-3m,over3m" varStatus="st">
                <div class="choice">
                    <input type="radio" name="priceRange" value="${p}" ${price == p ? 'checked' : ''} />
                    <label>
                        <c:choose>
                            <c:when test="${p=='under500'}">Dưới 500.000đ</c:when>
                            <c:when test="${p=='500-1m'}">500.000đ - 1 triệu</c:when>
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
                        ${fn:contains(fn:join(paramValues.brandId, ','), b.ID) ? 'checked' : ''} />
                    <label>${b.brand_name}</label>
                </div>
            </c:forEach>


            <!-- BATTERY -->
            <div class="title">PIN</div>
            <c:forEach var="e" items="${energy}">
                <div class="choice">
                    <input type="checkbox" name="useTime" value="${e.useTime}"
                        ${fn:contains(fn:join(paramValues.useTime, ','), e.useTime) ? 'checked' : ''} />
                    <label>${e.useTime} giờ</label>
                </div>
            </c:forEach>
        </div>
    </form>


    <!-- san pham           -->
    <div class="contain">

        <div class="contain-header">
            <div class="Loai">Sản phẩm</div>
            <%--Chức năng sắp xếp theo giá tăng/giảm dần và mới nhất--%>
            <form method="get" id="sortForm" action="${pageContext.request.contextPath}/product">
                <c:if test="${not empty keyword}">
                    <input type="hidden" name="q" value="${keyword}">
                </c:if>
                <!-- category -->
                <input type="hidden" name="categoryId" value="${param.categoryId}">

                <!-- price -->
                <input type="hidden" name="priceRange" value="${param.priceRange}">

                <!-- brand (multiple checkbox) -->
                <c:forEach var="b" items="${paramValues.brandId}">
                    <input type="hidden" name="brandId" value="${b}">
                </c:forEach>

                <!-- useTime -->
                <c:forEach var="u" items="${paramValues.useTime}">
                    <input type="hidden" name="useTime" value="${u}">
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


        <!-- Card San Pham -->
        <div id="product-list">

            <c:forEach var="c" items="${products}">
                <div class="product-item sony handheldpc">
                    <a href="${pageContext.request.contextPath}/product-detail?id=${c.ID}">
                        <img src="${c.image}" alt="">
                        <h4>${c.name}</h4>
                    </a>

                    <c:if test="${c.ispremium}">
                        <div class="tag">Premium</div>
                    </c:if>

                    <div class="price-actions">
                        <p class="price">${c.price}đ</p>
                        <div class="actions">
                            <!-- Nút thêm vào giỏ hàng -->
                            <form action="${pageContext.request.contextPath}/AddCart" method="post" class="add-cart-form">
                                <input type="hidden" name="productId" value="${c.ID}">
                                <input type="hidden" name="name" value="${c.name}">
                                <input type="hidden" name="price" value="${c.price}">
                                <input type="hidden" name="image" value="${c.image}">
                                <input type="hidden" name="quantity" value="1">

                                <button type="button" class="btn-add" onclick="addToCart(this.form)">
                                    <i class="fa fa-cart-plus"></i>
                                </button>
                            </form>

                            <!-- Nút yêu thích -->
                            <c:choose>
                                <c:when test="${fn:contains(wishlistIdString, c.ID)}">
                                    <!-- Nếu sản phẩm đã nằm trong wishlist -->
                                    <button type="button" class="btn-fav active" data-id="${c.ID}"
                                            onclick="toggleWishlist(this, '${c.ID}')">
                                        <i class="fa fa-heart"></i>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <!-- Nếu sản phẩm chưa nằm trong wishlist -->
                                    <button type="button" class="btn-fav" data-id="${c.ID}"
                                            onclick="toggleWishlist(this, '${c.ID}')">
                                        <i class="fa fa-heart"></i>
                                    </button>
                                </c:otherwise>
                            </c:choose>


                        </div>
                    </div>

                </div>

            </c:forEach>


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

        <div id="no-products-message" style="display:none; text-align: center; margin-top: 20px;">
            Không có sản phẩm nào phù hợp với tiêu chí lọc.
        </div>

    </div>


</main>


<%-- chức năng sắp xếp sản phẩm theo giá tăng, giảm dần--%>
<script>
    function toggleSortMenu() {
        document.getElementById("sortMenu").classList.toggle("active");
    }

    function selectSort(value) {
        document.getElementById("sortInput").value = value;
        document.getElementById("sortForm").submit();
    }

    // đóng menu khi click ra ngoài
    document.addEventListener("click", function (e) {
        if (!e.target.closest(".sort")) {
            document.getElementById("sortMenu").classList.remove("active");

        }
    });
</script>

<script>
    document.querySelectorAll('#filter-panel input').forEach(input => {
        // Lưu trạng thái ban đầu khi vừa load trang (dành cho Radio)
        if (input.type === 'radio' && input.checked) {
            input.wasChecked = true;
        }

        input.addEventListener('click', function(e) {
            if (this.type === 'radio') {
                // Logic bỏ chọn cho Radio
                if (this.wasChecked) {
                    this.checked = false;
                    this.wasChecked = false;
                } else {
                    // Reset trạng thái các radio cùng name
                    document.querySelectorAll('input[name="' + this.name + '"]').forEach(r => r.wasChecked = false);
                    this.wasChecked = true;
                }
            }

            setTimeout(() => {
                document.getElementById('filterForm').submit();
            }, 150);
        });
    });
</script>

<script>
function addToCart(form) {
    const formData = new FormData(form);

    fetch(form.action, {
        method: 'POST',
        body: new URLSearchParams(formData)
    })
    .then(res => {
        if (res.status === 401) {
            // chưa đăng nhập
            alert("Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng");
            window.location.href = contextPath + "/login";
            return null;
        }
        return res.json();
    })
    .then(data => {
        if (!data) return;

        // cập nhật số lượng giỏ hàng trên header
        document.getElementById("cart_num").textContent = data.total;
        alert(data.message);
    })
    .catch(err => console.error("Fetch error:", err));
}
</script>

<script>
function toggleWishlist(btn, productId) {
    fetch(contextPath + '/wishlist/toggle', { // sửa lại đúng endpoint
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'productId=' + encodeURIComponent(productId)
    })
    .then(res => {
        if (res.status === 401) {
            alert("Bạn cần đăng nhập để thêm vào yêu thích");
            window.location.href = contextPath + "/login";
            return null;
        }
        return res.json();
    })
    .then(data => {
        if (!data) return;

        if (data.added) {
            btn.classList.add('active');
            btn.innerHTML = '<i class="fa fa-heart"></i>';
        } else if (data.removed) {
            btn.classList.remove('active');
            btn.innerHTML = '<i class="fa fa-heart"></i>';
        }

        alert(data.message);

        const wishlistNum = document.getElementById("wishlist_num");
        if (wishlistNum) {
            wishlistNum.textContent = data.total;
        }
    })
    .catch(err => console.error("Fetch error:", err));
}
</script>



<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>
</body>
</html>
