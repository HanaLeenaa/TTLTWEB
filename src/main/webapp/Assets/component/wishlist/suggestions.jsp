<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>Sản phẩm gợi ý cho bạn</title>
    <link rel="stylesheet" href="Assets/css/homeStyle/product.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/wishlist/suggestions.css">
    <link
                rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        />

    <script
                src="https://kit.fontawesome.com/a076d05399.js"
                crossorigin="anonymous"
        ></script>

    <link
                rel="stylesheet"
                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
        />

</head>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<body>
<div class="back-bar">
    <a href="javascript:history.back()" class="btn-back">← Quay lại</a>
</div>


<c:if test="${not empty auth}">
    <div class="suggestions-page">
        <h2>Sản phẩm gợi ý cho bạn</h2>

        <div class="suggestions-grid">
            <c:forEach var="c" items="${suggestions}">
                <div class="product-item">
                    <a href="${pageContext.request.contextPath}/product-detail?id=${c.ID}">
                        <img src="${c.image}" alt="${c.name}">
                        <h4>${c.name}</h4>
                    </a>

                    <c:if test="${c.ispremium}">
                        <div class="tag">Premium</div>
                    </c:if>

                    <div class="price-actions">
                        <!-- Giá hiện tại -->
                        <div class="price-block">
                             <p class="price">${c.priceFormatted}₫</p>

                             <!-- Giá cũ chỉ hiển thị khi có giảm giá -->
                             <c:if test="${c.priceOld > c.price}">
                                  <p class="old-price"><s>${c.priceOldFormatted}₫</s></p>
                             </c:if>
                        </div>

                        <div class="actions">
                            <!-- Giỏ hàng -->
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

                            <!-- Yêu thích -->
                            <c:choose>
                                <c:when test="${fn:contains(wishlistIdString, c.ID)}">
                                    <button type="button" class="btn-fav active" data-id="${c.ID}"
                                            onclick="toggleWishlist(this, '${c.ID}')">
                                        <i class="fa fa-heart"></i>
                                    </button>
                                </c:when>
                                <c:otherwise>
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

        <div class="suggestions-grid">
            <c:forEach var="c" items="${suggestions}">
                <!-- sản phẩm -->
            </c:forEach>
        </div>

        <!-- pagination -->
<!--        <div class="pagination">
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
-->

    </div>
</c:if>

<c:if test="${empty auth}">
    <p>Bạn cần đăng nhập để xem sản phẩm gợi ý.</p>
</c:if>

<script>
    const contextPath = "${pageContext.request.contextPath}";

    // ===== Thêm vào giỏ hàng =====
    function addToCart(form) {
        const formData = new FormData(form);

        fetch(form.action, {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
        .then(res => {
            // Nếu servlet redirect (chưa login)
            if (res.redirected) {
                window.location.href = res.url;
                return null;
            }
            // Nếu servlet trả về 401 (chưa login)
            if (res.status === 401) {
                alert("Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng");
                window.location.href = contextPath + "/login";
                return null;
            }
            return res.json();
        })
        .then(data => {
            if (!data) return;

            // Cập nhật số lượng giỏ hàng trên header
            const cartNum = document.getElementById("cart_num");
            if (cartNum) {
                cartNum.textContent = data.total;
            }

            alert(data.message);
        })
        .catch(err => console.error("Fetch error:", err));
    }

    // ===== Toggle Wishlist (tim) =====

function toggleWishlist(btn, productId) {
    console.log("Clicked wishlist for product:", productId);

    fetch(contextPath + '/wishlist/toggle', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'productId=' + encodeURIComponent(productId)
    })
    .then(res => res.json())
    .then(data => {
        if (data.added) {
            btn.classList.add('active');
            btn.innerHTML = '<i class="fa fa-heart"></i>';
        } else if (data.removed) {
            btn.classList.remove('active');
            btn.innerHTML = '<i class="fa fa-heart-o"></i>';
        }

        // Hiển thị thông báo từ servlet
        alert(data.message);

        // Cập nhật số lượng wishlist trên header nếu có
        const wishlistNum = document.getElementById("wishlist_num");
        if (wishlistNum) wishlistNum.textContent = data.total;
    })
    .catch(err => console.error("Fetch error:", err));
}
</script>

</body>
</html>
