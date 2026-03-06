<%--
  Created by IntelliJ IDEA.
  User: HUU DAT
  Date: 12/6/2025
  Time: 6:49 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>header</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/header.css">
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
    <style>

        .input1 form {
            position: relative;
        }

        .input1 input {
            padding-right: 35px;
        }

        .search-btn {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: none;
            cursor: pointer;
        }

        .search-btn i {
            font-size: 16px;
            color: #e85221;
            margin-top: 35px;
        }

        .search-btn:hover i {
            color: #ae2c00;
        }
    </style>
</head>
<body>
<header class="header">
    <div class="main-header">
        <div class="container">
            <div class="box-header">
                <div class="hamburger">
                    <i class="bi bi-list" id="menuBTN"></i>
                    <i class="bi bi-search" style="font-size: 26px"></i>
                </div>
                <div class="menu-small-frame" style="display: none" id="menu-small">
                    <div title="menu" class="menu3">TRANG CHỦ</div>

                    <div title="menu" class="menu3">SẢN PHẨM</div>


                    <div title="menu" class="menu3">GIỚI THIỆU</div>

                    <div title="menu" class="menu3">LIÊN HỆ</div>
                </div>
                <!-- them vao day -->
                <div
                        class="search-box-mobile"
                        style="display: none"
                        id="search-box"
                >
                    <input type="text" placeholder="Tìm kiếm sản phẩm..." />
                </div>
                <!-- ------ -->
                <div class="logo" style="cursor:pointer">
                    <a href="${pageContext.request.contextPath}/home">
                        <img
                                title="${logo.titleLogo}"
                                src="${logo.linkLogo}"
                        />
                    </a>
                </div>

                <div class="center">
                    <div class="center-1 same-icon">
                        <i class="fa-solid fa-headset"></i>
                        <b style="font-size: 13px">HOTLINE:</b>
                        <span title="hotline">
                            ${contactNumber.phone}
                        </span>
                    </div>
                    <div class="center-1 center2 same-icon">
                        <i class="bi bi-geo-alt-fill"></i>
                        <a href="https://www.google.com/maps?q=10.871309739267502, 106.79176838635757" style="color: #333;"><b style="font-size: 13px" class="map">VỊ TRÍ CỬA HÀNG</b></a>
                    </div>
                    <div class="center-1 center3">
                        <div class="input1">
                            <form action="${pageContext.request.contextPath}/search" method="get" class="search-form">
                                <input id="searchInput"
                                       type="text"
                                       name="q"
                                       placeholder="Tìm sản phẩm...">

                                <button type="submit" class="search-btn">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </button>
                            </form>
                            <div id="suggestBox" class="suggest-box"></div>
                        </div>
                    </div>
                </div>

                <div class="right1">

                    <%--Sửa để xử lý đăng nhập--%>
                    <div class="account-wrapper">

                        <!-- ICON -->
                        <div class="icon icon2">
                            <i class="bi bi-person-circle"></i>
                            <p style="margin:0">TÀI KHOẢN</p>
                        </div>


                        <div class="account-dropdown">

                            <c:choose>
                                <c:when test="${empty sessionScope.auth}">
                                    <a href="${pageContext.request.contextPath}/login" class="a-same-nodecoration"><div class="dropdown-item" onclick="goLogin()">Đăng nhập</div></a>
                                    <a href="${pageContext.request.contextPath}/register" class="a-same-nodecoration"><div class="dropdown-item" onclick="goRegister()">Đăng ký</div></a>
                                </c:when>

                                <c:otherwise>
                                    <div class="dropdown-item">
                                        Xin chào, <b>${sessionScope.auth.username}</b>
                                    </div>

                                    <div class="dropdown-item"
                                         onclick="window.location.href='${pageContext.request.contextPath}/profile'">
                                        Trang cá nhân
                                    </div>

                                    <div class="dropdown-item logout"
                                         onclick="window.location.href='${pageContext.request.contextPath}/logout'">
                                        Đăng xuất
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/cart">
                        <div class="icon" style="cursor: pointer" onclick="goCart()">
                            <div class="cart">

                                <%--CẬP NHẬT GIỎ HÀNG SAU KHI THÊM SP --%>
                                <c:set var="cart" value="${sessionScope.cart}" />
                                <c:set var="cartCount" value="0" />

                                <c:if test="${cart != null}">
                                    <c:forEach items="${cart.cartItems.values()}" var="item">
                                        <c:set var="cartCount" value="${cartCount + item.quantity}" />
                                    </c:forEach>
                                </c:if>

                                <i class="bi bi-cart2" title="cart"></i>
                                <div class="num">
                                    <p id="cart_num"
                                       style="
                                        border-radius: 8px;
                                        padding: 2px;
                                        background-color: #e85221;
                                        color: white;">
                                        <c:out value="${cartCount}" default="0"/>
                                    </p>
                                </div>
                            </div>
                            <p class="cart3">GIỎ HÀNG</p>
                        </div>
                    </a>
                </div>
            </div>
        </div>

        <div class="menu">
            <div class="container">
                <div class="menu2">

                    <a href="${pageContext.request.contextPath}/home"><div title="menu" class="menu3" >TRANG CHỦ</div></a>

                    <a href="${pageContext.request.contextPath}/product"><div title="menu" class="menu3" >SẢN PHẨM</div></a>


                    <a href="${pageContext.request.contextPath}/about"><div title="menu" class="menu3" >GIỚI THIỆU</div></a>

                    <a href="${pageContext.request.contextPath}/contact"><div title="menu" class="menu3" >LIÊN HỆ</div></a>

                </div>
            </div>
        </div>
    </div>
</header>

<script>
    const input = document.getElementById("searchInput");
    const box = document.getElementById("suggestBox");

    input.addEventListener("keyup", function (e) {
        const keyword = this.value.trim();

        if (keyword.length < 2) {
            box.innerHTML = "";
            return;
        }

        fetch("${pageContext.request.contextPath}/search-suggest?q=" + encodeURIComponent(keyword))
            .then(res => res.json())
            .then(data => {
                box.innerHTML = "";
                data.forEach(p => {
                    box.innerHTML += `
                    <div class="suggest-item"
                         onclick="window.location.href='product-detail?slug=${p.metatitle}'">
                        <img src="${p.image}" width="40">
                        <span>${p.name}</span>
                    </div>
                `;
                });
            });
    });
</script>

</body>
</html>

