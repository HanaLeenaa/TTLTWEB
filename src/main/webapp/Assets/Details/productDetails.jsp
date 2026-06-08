<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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

    <style>
        .color-selection-section {
            margin: 24px 0;
            padding: 16px;
            border-radius: 12px;
            background: #fafafa;
            border: 1px solid #eee;
        }

        .color-selection-section p {
            margin-bottom: 10px;
            font-size: 14px;
            color: #333;
        }

        .color-swatches {
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }

        .swatch-btn {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.25s ease;
            border: 2px solid transparent;
            position: relative;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .swatch-btn:hover {
            transform: translateY(-2px) scale(1.08);
            box-shadow: 0 6px 14px rgba(0,0,0,0.15);
        }

        .swatch-btn.active {
            border: 2px solid #ff5722;
            transform: scale(1.1);
        }

        .review-modal {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.55);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            backdrop-filter: blur(4px);
        }

        .review-modal.show {
            display: flex;
        }

        .review-modal-box {
            width: 420px;
            max-width: 92%;
            background: #fff;
            border-radius: 16px;
            padding: 22px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.25);
            animation: popIn 0.25s ease;
        }

        @keyframes popIn {
            from {
                transform: scale(0.85);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }

        .review-modal-box h3 {
            margin: 0 0 12px;
            font-size: 18px;
            font-weight: 600;
            color: #222;
        }

        .review-modal-box label {
            display: block;
            margin-top: 12px;
            margin-bottom: 6px;
            font-size: 13px;
            font-weight: 600;
            color: #444;
        }

        .review-modal-box select,
        .review-modal-box textarea,
        .review-modal-box input[type="file"] {
            width: 100%;
            padding: 10px;
            border-radius: 10px;
            border: 1px solid #ddd;
            outline: none;
            font-size: 14px;
            transition: 0.2s;
        }

        .review-modal-box select:focus,
        .review-modal-box textarea:focus,
        .review-modal-box input:focus {
            border-color: #ff5722;
            box-shadow: 0 0 0 3px rgba(255,87,34,0.15);
        }

        .review-modal-box textarea {
            min-height: 90px;
            resize: none;
        }

        .review-actions {
            display: flex;
            gap: 10px;
            margin-top: 18px;
        }

        .review-actions button {
            flex: 1;
            padding: 10px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: 0.2s;
        }

        .review-actions button[type="submit"] {
            background: #ff5722;
            color: white;
        }

        .review-actions button[type="submit"]:hover {
            background: #e64a19;
        }

        .review-actions button[type="button"] {
            background: #f1f1f1;
        }

        .review-actions button[type="button"]:hover {
            background: #ddd;
        }
    </style>
</head>
<body>

<jsp:include page="/Assets/component/recycleFiles/header.jsp"/>

<main>
    <section class="product-details">
        <div class="product-container">

            <div class="left">
                <img id="mainImage"
                     src="${product.image}"
                     alt="${product.name}"
                     title="${product.name}"
                     class="main-img"/>

                <div class="gallery">
                    <%--Ảnh gốc--%>
                    <img id="thumb-base" src="${product.image}"
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

            <div class="right">
                <h2 id="display-product-name">${product.name}</h2>

                <p><strong>Mã sản phẩm:</strong> <span id="display-product-id">#${product.ID}</span></p>

                <p><strong>Danh mục:</strong> ${category.name}</p>
                <p><strong>Thương hiệu:</strong> ${brand.brand_name}</p>

                <p class="price">
                   <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/>đ
                </p>

                <c:if test="${not empty colorVariants && colorVariants.size() > 1}">
                    <div class="color-selection-section">
                        <p><strong>Màu sắc:</strong> <span id="selected-color-name" style="font-weight: 600; color: #ff5722;">${not empty product.color_name ? product.color_name : 'Mặc định'}</span></p>
                        <div class="color-swatches">
                            <c:forEach var="v" items="${colorVariants}">
                                <button type="button"
                                        class="swatch-btn ${v.ID == product.ID ? 'active' : ''}"
                                        style="background-color: ${not empty v.color_code ? v.color_code : '#ccc'}; border: 1px solid #ddd;"
                                        title="${v.color_name}"
                                        onclick="changeProductVariant(this)"
                                        data-id="${v.ID}">
                                </button>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <p>
                    <strong>Tình trạng:</strong>
                    <span id="stock-status-display">
                        <c:choose>
                            <c:when test="${product.stock > 0}">
                                <span style="color: green;font-weight: 600;">Còn hàng</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: red;font-weight: 600;">Hết hàng</span>
                            </c:otherwise>
                        </c:choose>
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
                            <strong id="desc-product-title">${product.name}</strong>
                            <c:forEach items="${descLines}" var="line">
                                <li>
                                    <c:out value="${line}" escapeXml="false"/>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <div class="quantity-control">
                    <button type="button" onclick="decrease()">−</button>
                    <span id="qty-display">1</span>
                    <button type="button" onclick="increase()">+</button>
                </div>

                <form action="${pageContext.request.contextPath}/AddCart" method="post" id="form-add-cart">
                    <input type="hidden" name="productId" id="cart-productId" value="${product.ID}">
                    <input type="hidden" name="name" id="cart-name" value="${product.name}">
                    <input type="hidden" name="price" id="cart-price" value="${product.price}">
                    <input type="hidden" name="image" id="cart-image" value="${product.image}">
                    <input type="hidden" name="quantity" id="quantity-cart" value="1">

                    <button type="button" class="btn-add btn" onclick="addToCart()">
                        <i class="fa fa-cart-plus"></i> Thêm vào giỏ hàng
                    </button>
                </form>

                <form method="post" action="${pageContext.request.contextPath}/buy-now" id="form-buy-now">
                    <input type="hidden" name="productId" id="buy-productId" value="${product.ID}">
                    <input type="hidden" name="quantity" id="quantity-buy" value="1">
                    <c:choose>
                        <c:when test="${product.stock > 0}">
                            <button type="submit" class="btn-buy btn">
                                Mua ngay
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="btn-buy btn"
                                    disabled style="opacity:0.6; cursor: not-allowed;">
                                Mua ngay
                            </button>
                        </c:otherwise>
                    </c:choose>
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
            <div class="swiper-button-prev"></div>
            <div class="swiper-button-next"></div>
        </div>
    </div>
</div>

<%--review--%>
<div class="review-section">
    <div class="container">
        <h2>Đánh giá & nhận xét <span id="product_name">${product.name}</span></h2>

        <div class="overall-rating">
            <div class="score">
                <h3>${avg}/5</h3>
                    <div class="stars">

                        <!-- sao đầy -->
                        <c:forEach begin="1" end="${fullStars}">
                            <i class="fas fa-star" style="color:#ffc107;"></i>
                        </c:forEach>

                        <!-- sao nửa -->
                        <c:if test="${hasHalf}">
                            <i class="fas fa-star-half-alt" style="color:#ffc107;"></i>
                        </c:if>

                        <!-- sao rỗng -->
                        <c:forEach begin="1" end="${5 - fullStars - (hasHalf ? 1 : 0)}">
                            <i class="far fa-star" style="color:#ddd;"></i>
                        </c:forEach>

                    </div>

                    <p>${quantity} đánh giá</p>
            </div>

            <div class="rating-bars">
                <div class="rating-bar">
                    5 <i class="fas fa-star" style="color:#ffc107;"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: ${avg5}%"></div>
                    </div>
                    <span>${fiveStars} đánh giá</span>
                </div>
                <div class="rating-bar">
                    4 <i class="fas fa-star" style="color:#ffc107;"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: ${avg4}%"></div>
                    </div>
                    <span>${fourStars} đánh giá</span>
                </div>
                <div class="rating-bar">
                    3 <i class="fas fa-star" style="color:#ffc107;"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: ${avg3}%"></div>
                    </div>
                    <span>${threeStars} đánh giá</span>
                </div>
                <div class="rating-bar">
                    2 <i class="fas fa-star" style="color:#ffc107;"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: ${avg2}%"></div>
                    </div>
                    <span>${twoStars} đánh giá</span>
                </div>
                <div class="rating-bar">
                    1 <i class="fas fa-star" style="color:#ffc107;"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: ${avg1}%"></div>
                    </div>
                    <span>${oneStar} đánh giá</span>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${canReview}">
                <button class="review-button" onclick="openReviewModal()">
                    Đánh giá ngay
                </button>
            </c:when>
            <c:otherwise>
                <button class="review-button" onclick="alert('Bạn cần mua sản phẩm này trước khi đánh giá!')">
                    Đánh giá ngay
                </button>
            </c:otherwise>
        </c:choose>

        <div id="reviewModal" class="review-modal">
            <div class="review-modal-box">
            <form action="${pageContext.request.contextPath}/add-review"
                  method="post"
                  enctype="multipart/form-data">

                <input type="hidden" name="productId" value="${product.ID}">
                <h3>Đánh giá sản phẩm</h3>

                <label>Số sao:</label>
                <select name="rating" required>
                    <option value="5">5 sao</option>
                    <option value="4">4 sao</option>
                    <option value="3">3 sao</option>
                    <option value="2">2 sao</option>
                    <option value="1">1 sao</option>
                </select>

                <label>Nhận xét:</label>
                <textarea name="comment"></textarea>
                <label>Ảnh review:</label>
                <input type="file" name="review_image" accept="image/*">

                <br><br>
                <button type="submit">Gửi đánh giá</button>
                <button type="button" onclick="closeReviewModal()">Hủy</button>
            </form>
        </div>
    </div>

        <c:if test="${not empty reviews}">
            <c:forEach var="c" items="${reviews}">
                <div class="review-item">
                    <h4>
                            ${c.username}
                        <span class="stars">
                            <c:set var="starCount" value="${empty c.rating ? 0 : c.rating}" />

                            <c:forEach begin="1" end="${starCount}">
                                <i class="fas fa-star" style="color:#ffc107; font-size:10px"></i>
                            </c:forEach>
                        </span>
                    </h4>
                    <p>Nhận xét: ${c.review_text}</p>

                    <c:if test="${not empty c.imgReviews}">
                        <img src="${pageContext.request.contextPath}/uploads/${c.imgReviews}"
                             style="width:100px; margin-top:10px;">
                    </c:if>

                    <div class="review-date">
                        <c:out value="${c.reviewDate}"/>
                    </div>
                </div>
            </c:forEach>
        </c:if>
    </div>
</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

<script>
    function changeProductVariant(element) {
        // 1. Lấy ra ID của biến thể sản phẩm màu sắc được người dùng click
        const variantId = element.getAttribute('data-id');

        // 2. Chuyển hướng trình duyệt sang URL của sản phẩm mới ngay lập tức
        // Server (Servlet) nhận ID mới này sẽ tự động truy vấn lại Database,
        // lôi chuẩn bộ ảnh phụ Gallery và thông số của màu mới ra để render lại trang!
        window.location.href = "${pageContext.request.contextPath}/product-detail?id=" + variantId;
    }
</script>

<script>
    function openReviewModal() {
        document.getElementById("reviewModal").classList.add("show");
    }

    function closeReviewModal() {
        document.getElementById("reviewModal").classList.remove("show");
    }
</script>

<script>
    function handleReviewClick() {
        const canReview = ${canReview};
        if (canReview) {
            openReviewModal();
        } else {
            alert("Bạn cần mua sản phẩm này trước khi đánh giá!");
        }
    }
</script>

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
        document.querySelectorAll('.thumb-img').forEach(img => img.classList.remove('active'));
        el.classList.add('active');
    }
</script>

<%-- Thong bao them san pham vao gio hang --%>
<script>
    function addToCart(){
        const formData = new URLSearchParams();
        formData.append("productId", document.getElementById("cart-productId").value);
        formData.append("name", document.getElementById("cart-name").value);
        formData.append("price", document.getElementById("cart-price").value);
        formData.append("image", document.getElementById("cart-image").value);
        formData.append("quantity", document.getElementById("quantity-cart").value);

        fetch("${pageContext.request.contextPath}/AddCart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: formData
        })
            .then(res => res.json())
            .then(data => {
                if (data.notLoggedIn){
                    window.location.href = data.redirect;
                    return;
                }

                showToast(data.message);
                document.getElementById("cart_num").innerText = data.total;
            });
    }
</script>

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

</body>
</html>