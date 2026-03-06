<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>InfinityTech</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/same_style/style.css" />
    <link rel="stylesheet" href="Assets/css/homeStyle/home.css">
    <link rel="stylesheet" href="Assets/css/recycleFilecss/header.css" />
    <link rel="stylesheet" href="Assets/css/recycleFilecss/footer.css" />
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
    />
    <!-- Font Awesome -->
    <script
            src="https://kit.fontawesome.com/a076d05399.js"
            crossorigin="anonymous"
    ></script>
</head>
<body>
<!--
  Header
-->
<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<div class="slider">
    <div class="slides">
        <c:forEach var="b" items="${banners}" varStatus="st">
            <a href="${pageContext.request.contextPath}/product">
                <img
                        src="${b.link}"
                        class="${st.index == 0 ? 'active' : ''}"
                        alt=""
                />
            </a>
        </c:forEach>
    </div>

    <!-- Mũi tên -->
    <div class="arrows">
        <span class="prev" title="previous">&#10094;</span>
        <span class="next" title="next">&#10095;</span>
    </div>

    <!-- Dấu chấm -->
    <div class="dots">
        <c:forEach var="b" items="${banners}" varStatus="st">
            <span class="dot ${st.index == 0 ? 'active' : ''}"></span>
        </c:forEach>
    </div>
</div>


<div class="features" style="margin-top: 60px">
    <div class="feature-box">
        <svg
                style="color: #e95221"
                xmlns="http://www.w3.org/2000/svg"
                width="30"
                height="30"
                fill="currentColor"
                class="bi bi-truck"
                viewBox="0 0 16 16"
        >
            <path
                    d="M0 3.5A1.5 1.5 0 0 1 1.5 2h9A1.5 1.5 0 0 1 12 3.5V5h1.02a1.5 1.5 0 0 1 1.17.563l1.481 1.85a1.5 1.5 0 0 1 .329.938V10.5a1.5 1.5 0 0 1-1.5 1.5H14a2 2 0 1 1-4 0H5a2 2 0 1 1-3.998-.085A1.5 1.5 0 0 1 0 10.5zm1.294 7.456A2 2 0 0 1 4.732 11h5.536a2 2 0 0 1 .732-.732V3.5a.5.5 0 0 0-.5-.5h-9a.5.5 0 0 0-.5.5v7a.5.5 0 0 0 .294.456M12 10a2 2 0 0 1 1.732 1h.768a.5.5 0 0 0 .5-.5V8.35a.5.5 0 0 0-.11-.312l-1.48-1.85A.5.5 0 0 0 13.02 6H12zm-9 1a1 1 0 1 0 0 2 1 1 0 0 0 0-2m9 0a1 1 0 1 0 0 2 1 1 0 0 0 0-2"
            />
        </svg>
        <div class="text">
            <h4>Vận chuyển toàn quốc</h4>
            <p>Thanh toán khi <b>NHẬN HÀNG</b></p>
        </div>
    </div>

    <div class="feature-box">
        <svg
                style="color: #e95221"
                xmlns="http://www.w3.org/2000/svg"
                width="30"
                height="30"
                fill="currentColor"
                class="bi bi-hand-thumbs-up"
                viewBox="0 0 16 16"
        >
            <path
                    d="M8.864.046C7.908-.193 7.02.53 6.956 1.466c-.072 1.051-.23 2.016-.428 2.59-.125.36-.479 1.013-1.04 1.639-.557.623-1.282 1.178-2.131 1.41C2.685 7.288 2 7.87 2 8.72v4.001c0 .845.682 1.464 1.448 1.545 1.07.114 1.564.415 2.068.723l.048.03c.272.165.578.348.97.484.397.136.861.217 1.466.217h3.5c.937 0 1.599-.477 1.934-1.064a1.86 1.86 0 0 0 .254-.912c0-.152-.023-.312-.077-.464.201-.263.38-.578.488-.901.11-.33.172-.762.004-1.149.069-.13.12-.269.159-.403.077-.27.113-.568.113-.857 0-.288-.036-.585-.113-.856a2 2 0 0 0-.138-.362 1.9 1.9 0 0 0 .234-1.734c-.206-.592-.682-1.1-1.2-1.272-.847-.282-1.803-.276-2.516-.211a10 10 0 0 0-.443.05 9.4 9.4 0 0 0-.062-4.509A1.38 1.38 0 0 0 9.125.111zM11.5 14.721H8c-.51 0-.863-.069-1.14-.164-.281-.097-.506-.228-.776-.393l-.04-.024c-.555-.339-1.198-.731-2.49-.868-.333-.036-.554-.29-.554-.55V8.72c0-.254.226-.543.62-.65 1.095-.3 1.977-.996 2.614-1.708.635-.71 1.064-1.475 1.238-1.978.243-.7.407-1.768.482-2.85.025-.362.36-.594.667-.518l.262.066c.16.04.258.143.288.255a8.34 8.34 0 0 1-.145 4.725.5.5 0 0 0 .595.644l.003-.001.014-.003.058-.014a9 9 0 0 1 1.036-.157c.663-.06 1.457-.054 2.11.164.175.058.45.3.57.65.107.308.087.67-.266 1.022l-.353.353.353.354c.043.043.105.141.154.315.048.167.075.37.075.581 0 .212-.027.414-.075.582-.05.174-.111.272-.154.315l-.353.353.353.354c.047.047.109.177.005.488a2.2 2.2 0 0 1-.505.805l-.353.353.353.354c.006.005.041.05.041.17a.9.9 0 0 1-.121.416c-.165.288-.503.56-1.066.56z"
            />
        </svg>
        <div class="text">
            <h4>Bảo đảm chất lượng</h4>
            <p>Sản phẩm bảo đảm chất lượng</p>
        </div>
    </div>

    <div class="feature-box">
        <svg
                style="color: #e95221"
                xmlns="http://www.w3.org/2000/svg"
                width="30"
                height="30"
                fill="currentColor"
                class="bi bi-credit-card"
                viewBox="0 0 16 16"
        >
            <path
                    d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v1h14V4a1 1 0 0 0-1-1zm13 4H1v5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1z"
            />
            <path
                    d="M2 10a1 1 0 0 1 1-1h1a1 1 0 0 1 1 1v1a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1z"
            />
        </svg>
        <div class="text">
            <h4>Tiến hành thanh toán</h4>
            <p>Với nhiều <b>PHƯƠNG THỨC</b></p>
        </div>
    </div>

    <div class="feature-box">
        <svg
                style="color: #e95221"
                xmlns="http://www.w3.org/2000/svg"
                width="30"
                height="30"
                fill="currentColor"
                class="bi bi-coin"
                viewBox="0 0 16 16"
        >
            <path
                    d="M5.5 9.511c.076.954.83 1.697 2.182 1.785V12h.6v-.709c1.4-.098 2.218-.846 2.218-1.932 0-.987-.626-1.496-1.745-1.76l-.473-.112V5.57c.6.068.982.396 1.074.85h1.052c-.076-.919-.864-1.638-2.126-1.716V4h-.6v.719c-1.195.117-2.01.836-2.01 1.853 0 .9.606 1.472 1.613 1.707l.397.098v2.034c-.615-.093-1.022-.43-1.114-.9zm2.177-2.166c-.59-.137-.91-.416-.91-.836 0-.47.345-.822.915-.925v1.76h-.005zm.692 1.193c.717.166 1.048.435 1.048.91 0 .542-.412.914-1.135.982V8.518z"
            />
            <path
                    d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"
            />
            <path
                    d="M8 13.5a5.5 5.5 0 1 1 0-11 5.5 5.5 0 0 1 0 11m0 .5A6 6 0 1 0 8 2a6 6 0 0 0 0 12"
            />
        </svg>
        <div class="text">
            <h4>Đổi sản phẩm mới</h4>
            <p>Nếu sản phẩm lỗi</p>
        </div>
    </div>
</div>

<!-- Product Category Section -->
<section class="product-category">
    <div class="container">
        <h2 class="section-title">Danh Mục Console & Tay Cầm</h2>

        <div class="category-grid">
            <c:forEach var="c" items="${categories}">
                <div class="category-item"
                     data-url="${pageContext.request.contextPath}/product?categoryId=${c.ID}">
                    <img src="${c.imgLink}" alt="${c.name}">
                    <div class="category-info">
                        <h3>${c.name}</h3>
                        <p>${c.description}</p>
                    </div>
                </div>
            </c:forEach>
        </div>


    </div>
</section>

<!--products section-->
<section class="product-section">
    <h2>Sản Phẩm Mới / Giá Ưu Đãi</h2>
    <div class="container">
        <div class="product-grid">
            <c:forEach var="c" items="${products}">
                <a href="${pageContext.request.contextPath}/product-detail?id=${c.ID}" style="color: black"
                   class="product-link">

                    <div class="product-card">
                        <div class="img-box">
                            <img src="${c.image}" alt="${c.metatitle}"/>

                            <div class="hidden-info">
                                <button
                                        type="button"
                                        class="add-cart"
                                        data-id="${c.ID}"
                                        data-name="${c.name}"
                                        data-image="${c.image}"
                                        data-price="${c.price}">
                                    Thêm vào giỏ hàng
                                </button>
                            </div>
                        </div>

                        <h3>${c.name}</h3>
                        <p class="price">${c.price}đ</p>
                    </div>

                </a>
            </c:forEach>
        </div>
    </div>
</section>

<!-- MACBOOK SECTION -->
<section class="featured-product">
    <div class="featured-content">
        <div class="text">
            <h1>${highest.name}</h1>
            <div class="line"></div>
            <p class="details">Weight: ${highest.weight}g &nbsp; | &nbsp; Use Time: ${highest.useTime}hours</p>
            <div class="price-box">
                <span class="new-price">${highest.price}đ</span>
                <span class="old-price">${highest.priceOld}đ</span>
            </div>
        </div>

        <div class="image">
            <img src="${highest.image}" alt="" />
        </div>
    </div>
</section>

<!-- CAMERA SECTION -->
<section class="camera-section">
    <div class="camera-grid">
        <!-- LEFT: Banner -->
        <div class="camera-banner">
            <img src="${smaller[0].image}" alt="Camera Banner" />
            <div class="banner-text">
                <p class="top">Top Handle Brands</p>
                <h2>Tất cả sản phẩm<br />Dưới $50</h2>
                <button class="shop-btn">Mua ngay</button>
            </div>
        </div>

        <!-- MIDDLE: Video -->
        <!--
        <iframe width="402" height="715" src="https://www.youtube.com/embed/jJRDGkEvrx0" title="A closer look at the Backbone One Xbox Edition. Link in bio. @xbox #backbone #xbox" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
        -->

        <div class="camera-video">
            <iframe
                    src="https://www.youtube.com/embed/jJRDGkEvrx0"
                    title="Mi Home Security Camera"
                    frameborder="0"
                    allowfullscreen
            ></iframe>
            <img src="${smaller[1].image}" alt="Camera Room" />
        </div>

    </div>
</section>

<!--Laptop 2-->
<section class="featured-product">
    <div class="featured-content">
        <div class="text">
            <h1>${smallest.name}</h1>
            <div class="line"></div>
            <p class="details">Weight: ${smallest.weight}g &nbsp; | &nbsp; Use Time: ${smallest.useTime}hours</p>

            <div class="price-box">
                <span class="new-price">${smallest.price}đ</span>
                <span class="old-price">${smallest.priceOld}đ</span>
            </div>
        </div>

        <div class="image">
            <img src="${smallest.image}" alt="Ps5" />
        </div>
    </div>
</section>

<!-- section blog -->
<section class="blog-section">
    <h2>Tin Tức & Blog</h2>

    <div class="blog-list">
        <c:forEach var="c" items="${bloglist}">
        <div class="blog-item">
            <img
                    src="${c.img}"
                    alt="${c.metatitle}"
            />
            <div class="blog-content">
                <h3>${c.title}</h3>
                <p>
                    ${c.description}
                </p>
            </div>
        </div>
        </c:forEach>
    </div>
</section>
<!--Footer-->
<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />
</body>
<script>
    const slides = document.querySelectorAll(".slides img");
    const dots = document.querySelectorAll(".dot");
    let index = 0;

    function showSlide(i) {
        slides.forEach(s => s.classList.remove("active"));
        dots.forEach(d => d.classList.remove("active"));

        slides[i].classList.add("active");
        dots[i].classList.add("active");
    }

    document.querySelector(".next").onclick = () => {
        index = (index + 1) % slides.length;
        showSlide(index);
    };

    document.querySelector(".prev").onclick = () => {
        index = (index - 1 + slides.length) % slides.length;
        showSlide(index);
    };

    dots.forEach((dot, i) => {
        dot.onclick = () => {
            index = i;
            showSlide(index);
        };
    });

    setInterval(() => {
        index = (index + 1) % slides.length;
        showSlide(index);
    }, 4000);
    document.querySelectorAll('.category-item').forEach(item => {
        item.addEventListener('click', () => {
            window.location.href = item.dataset.url;
        });
    });

        document.querySelectorAll('.add-cart').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();    // chặn submit
            e.stopPropagation();   // chặn click lan lên <a>

            const data = new URLSearchParams();
            data.append('productId', this.dataset.id);
            data.append('quantity', 1);
            data.append('name', this.dataset.name);
            data.append('image', this.dataset.image);
            data.append('price', this.dataset.price);

            fetch('${pageContext.request.contextPath}/AddCart', {
                method: 'POST',
                body: data
            })
                .then(res => {
                    if (res.redirected) {
                        window.location.href = res.url; // chưa login
                        return;
                    }
                    alert('Đã thêm vào giỏ hàng');
                });
        });
    });


</script>
</html>