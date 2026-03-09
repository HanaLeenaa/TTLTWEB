<%--
  Created by IntelliJ IDEA.
  User: HUU DAT
  Date: 12/6/2025
  Time: 7:00 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Chi tiết sản phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/Details/productDetails.css">
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
</head>
<body>
<!-- <div id="header"></div> -->

<jsp:include page="/Assets/component/recycleFiles/header.jsp"/>

<main>
    <section class="product-details">
        <div class="product-container">

            <!-- LEFT -->
            <div class="left">
                <img id="mainImage"
                     src="${product.image}"
                     alt="${product.name}"
                     title="${product.name}"
                     class="main-img"/>

                <div class="gallery">
                        <%--Ảnh gốc--%>
                    <img src="${product.image}"
                    class="thumb-img active"
                    onclick="changeImage(this)">

                            <%--3 Ảnh phụ--%>
                    <c:forEach var="c" items="${gallary}">
                        <img src="${c.img}"
                             alt="${c.metatitle}"
                             onclick="changeImage(this)"
                             class="thumb-img">
                    </c:forEach>
                </div>
            </div>

            <!-- RIGHT -->
            <div class="right">
                <h2>${product.name}</h2>

                <p><strong>Mã sản phẩm:</strong> #${product.ID}</p>

                <p><strong>Danh mục:</strong> ${category.name}</p>
                <p><strong>Thương hiệu:</strong> ${brand.brand_name}</p>

                <p class="price">
                    ${product.price}đ
                </p>

                <p>
                    <strong>Tình trạng:</strong>
                    <span style="color:${product.active ? 'green' : 'red'}">
                        ${product.active ? "Còn hàng" : "Hết hàng"}
                    </span>
                </p>

                <div class="product-info-box">
                    <div class="product-offer">
                        <h3>Ưu đãi</h3>
                        <ul class="product-endow">
                            <c:forEach items="${endowList}" var="line">
                                <li>${line}</li>
                            </c:forEach>
                        </ul>
                    </div>

                    <div class="product-description">
                        <h3>Mô tả sản phẩm</h3>
                        <ul class="short-desc">
                            <strong>${product.name}</strong>
                            <c:forEach items="${descLines}" var="line">
                                <li>
                                    <c:out value="${line}" escapeXml="false"/>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <!-- quantity control (dùng chung) -->
                <div class="quantity-control">
                    <button type="button" onclick="decrease()">−</button>
                    <span id="qty-display">1</span>
                    <button type="button" onclick="increase()">+</button>
                </div>

                <!-- ADD CART -->
                <form action="${pageContext.request.contextPath}/AddCart" method="post">
                    <input type="hidden" name="productId" value="${product.ID}"> <input type="hidden" name="name"
                                                                                        value="${product.name}"> <input
                        type="hidden" name="price" value="${product.price}"> <input type="hidden" name="image"
                                                                                    value="${product.image}"> <input
                        type="hidden" name="quantity" id="quantity-cart" value="1">

                    <button type="submit" class="btn-add btn">
                        <i class="fa fa-cart-plus"></i> Thêm vào giỏ hàng
                    </button>
                </form>

                <!-- BUY NOW -->
                <form method="post" action="${pageContext.request.contextPath}/buy-now">
                    <input type="hidden" name="productId" value="${product.ID}">
                    <input type="hidden" name="quantity" id="quantity-buy" value="1">
                    <button type="submit" class="btn-buy btn">
                        Mua ngay
                    </button>
                </form>



                <div class="back-row">
                    <a href="${pageContext.request.contextPath}/product" class="btn-back">
                        <button>← Quay lại</button>
                    </a>
                </div>
            </div>
        </div>

        <section class="product-detail-info">
            <div class="container">
                <div class="description-section">
                    <h3>Mô tả chi tiết</h3>
                    <p>
                        ${product.full_description}
                    </p>
                </div>

                <div class="description-section">
                    <h3>Giới thiệu về console và tay cầm</h3>
                    <p>
                        Console và tay cầm chơi game mang đến trải nghiệm giải trí sống
                        động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp
                        nhiều tính năng giúp người chơi linh hoạt và tiện lợi.
                    </p>
                </div>

                <div class="description-section">
                    <h3>Đối tượng phù hợp</h3>
                    <p>
                        Sản phẩm hướng tới game thủ mọi lứa tuổi và những người yêu công
                        nghệ, phù hợp cho giải trí, học tập hay thi đấu eSports.
                    </p>
                </div>

                <div class="description-section">
                    <h3>Công nghệ</h3>
                    <p>
                        Console và tay cầm sử dụng công nghệ không dây, cảm biến chuyển
                        động, rung phản hồi, và màn hình sắc nét, giúp trải nghiệm chơi
                        game mượt mà và chính xác.
                    </p>
                </div>

                <div class="specs-section">
                    <h3>Thông số kỹ thuật</h3>

                    <table>
                        <tr>
                            <th>Thuộc tính</th>
                            <th>Giá trị</th>
                        </tr>
                        <tr>
                            <td>Kết nối</td>
                            <td>${product.connect}</td>
                        </tr>
                        <tr>
                            <td>Pin</td>
                            <td>${product.energy}0mah</td>
                        </tr>
                        <tr>
                            <td>Thời gian sử dụng</td>
                            <td>${product.useTime}hours</td>
                        </tr>
                        <tr>
                            <td>Hỗ trợ</td>
                            <td>${product.suports}</td>
                        </tr>
                        <tr>
                            <td>Khối lượng</td>
                            <td>${product.weight}g</td>
                        </tr>
                    </table>
                </div>
            </div>
        </section>
    </section>
</main>

<!-- <div id="footer"></div> -->
<!-- sản phẩm liên quan -->
<div class="related-section">
    <div class="container">
        <h3>Sản phẩm liên quan</h3>

        <div class="swiper related-swiper">
            <div class="swiper-wrapper">

                <c:forEach var="c" items="${relateProductList}">
                    <div class="swiper-slide">
                        <a href="${pageContext.request.contextPath}/product-detail?id=${c.ID}" class="related-link">
                            <div class="related-card">
                                <img src="${c.image}" alt="${c.metatitle}">
                                <div class="related-name">${c.name}</div>
                                <div class="related-price">${c.price}</div>
                            </div>
                        </a>
                    </div>
                </c:forEach>

            </div>


            <!-- Nút điều hướng -->
            <div class="swiper-button-prev"></div>
            <div class="swiper-button-next"></div>
        </div>

    </div>
</div>


<!--
  reviews
 -->
<div class="review-section">
    <div class="container">
        <h2>Đánh giá & nhận xét <span id="product_name"></span></h2>

        <div class="overall-rating">
            <div class="score">
                <h3>${avg}/5</h3>
                <div class="stars">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i>
                    <i class="fas fa-star"></i><i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                </div>
                <p>${quantity} đánh giá</p>
            </div>
            <div class="rating-bars">
                <div class="rating-bar">
                    5 <i class="fas fa-star"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: ${avg5}%"></div>
                    </div>
                    <span>${fiveStars} đánh giá</span>
                </div>
                <div class="rating-bar">
                    4 <i class="fas fa-star"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: ${avg4}%"></div>
                    </div>
                    <span>${fourStars} đánh giá</span>
                </div>
                <div class="rating-bar">
                    3 <i class="fas fa-star"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: ${avg3}%"></div>
                    </div>
                    <span>${threeStars} đánh giá</span>
                </div>
                <div class="rating-bar">
                    2 <i class="fas fa-star"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: ${avg2}%"></div>
                    </div>
                    <span>${twoStars} đánh giá</span>
                </div>
                <div class="rating-bar">
                    1 <i class="fas fa-star"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: ${avg1}%"></div>
                    </div>
                    <span>${oneStar} đánh giá</span>
                </div>
            </div>
        </div>

        <a href="./reviews.html" class="review-button">Đánh giá ngay</a>

        <!-- List reviews -->
        <c:forEach var="c" items="${reviews}">
            <div class="review-item">
                <h4>
                        ${c.username}
                    <span class="stars">
                <c:forEach begin="1" end="${c.rating}" var="i">
                    <i class="fas fa-star text-warning" style="font-size: 10px"></i>
                </c:forEach>
            </span>
                </h4>

                <p>Nhận xét: ${c.review_text}</p>
                <div class="review-date">${c.reviewDate}</div>
            </div>
        </c:forEach>


    </div>
</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

<script>
    let qty = 1;

    function updateQuantity() {
        document.getElementById("qty-display").innerText = qty;
        document.getElementById("quantity-cart").value = qty;
        document.getElementById("quantity-buy").value = qty;
    }

    function increase() {
        qty++;
        updateQuantity();
    }

    function decrease() {
        if (qty > 1) {
            qty--;
            updateQuantity();
        }
    }
</script>

<script>
    function changeImage(el) {
        document.getElementById("mainImage").src = el.src;

        document.querySelectorAll('.thumb-img')
            .forEach(img => img.classList.remove('active'));

        el.classList.add('active');
    }
</script>

</body>
<script>
    new Swiper('.related-swiper', {
        slidesPerView: 4,
        spaceBetween: 20,
        loop: true,
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev'
        },
        autoplay: {
            delay: 3000,
            disableOnInteraction: false
        },
        breakpoints: {
            0: { slidesPerView: 1 },
            576: { slidesPerView: 2 },
            768: { slidesPerView: 3 },
            992: { slidesPerView: 4 }
        }
    });
</script>

</html>
