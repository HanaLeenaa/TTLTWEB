<%--
  Created by IntelliJ IDEA.
  User: HUU DAT
  Date: 12/6/2025
  Time: 6:49 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                            <input type="text" placeholder="Tìm sản phẩm..." />
                            <div class="search">
                                <i title="tìm kiếm" class="bi bi-search"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="right1">
<%--                    <div class="icon icon2" id="icon3">--%>
<%--                        <i class="bi bi-person-circle"></i>--%>
<%--                        <p style="margin: 0">TÀI KHOẢN</p>--%>
<%--                    </div>--%>

<%--                    <div class="register-login" id="loginForm" class="a-same-nodecoration"--%>
<%--                        ><div style="cursor: pointer" class="no-margin" onclick="goLogin()">--%>
<%--                            <svg--%>
<%--                                    xmlns="http://www.w3.org/2000/svg"--%>
<%--                                    width="16"--%>
<%--                                    height="16"--%>
<%--                                    fill="currentColor"--%>
<%--                                    class="bi bi-box-arrow-in-right"--%>
<%--                                    viewBox="0 0 16 16"--%>
<%--                            >--%>
<%--                                <path--%>
<%--                                        fill-rule="evenodd"--%>
<%--                                        d="M6 3.5a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 0-1 0v2A1.5 1.5 0 0 0 6.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-8A1.5 1.5 0 0 0 5 3.5v2a.5.5 0 0 0 1 0z"--%>
<%--                                />--%>
<%--                                <path--%>
<%--                                        fill-rule="evenodd"--%>
<%--                                        d="M11.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H1.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708z"--%>
<%--                                />--%>
<%--                            </svg>--%>
<%--                            <p>Đăng nhập</p>--%>
<%--                        </div>--%>


<%--                        <div class="no-margin" onclick="goRegister()" style="cursor: pointer">--%>
<%--                            <svg--%>
<%--                                    xmlns="http://www.w3.org/2000/svg"--%>
<%--                                    width="16"--%>
<%--                                    height="16"--%>
<%--                                    fill="currentColor"--%>
<%--                                    class="bi bi-person-plus"--%>
<%--                                    viewBox="0 0 16 16"--%>
<%--                            >--%>
<%--                                <path--%>
<%--                                        d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"--%>
<%--                                />--%>
<%--                                <path--%>
<%--                                        fill-rule="evenodd"--%>
<%--                                        d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5"--%>
<%--                                />--%>
<%--                            </svg>--%>
<%--                            <p>Đăng ký</p>--%>
<%--                        </div>--%>
<%--                    </div>--%>


    <%--                    <div class="personal_logout" id="personal_logout">--%>
    <%--                        <a--%>
    <%--                                href="./Assets/component/cart_payment/Order.html"--%>
    <%--                                class="a-same-nodecoration1"--%>
    <%--                        ><div class="no-margin1">--%>
    <%--                            <p>Trang cá nhân</p>--%>
    <%--                        </div></a--%>
    <%--                        >--%>
    <%--                        <div class="no-margin1 no-margin2">--%>
    <%--                            <span class="logoutbtn" id="logoutbtn">Đăng xuất</span>--%>
    <%--                        </div>--%>
    <%--                    </div>--%>



    <%--  ====================================================--%>

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
                                     onclick="window.location.href='${pageContext.request.contextPath}/profile.jsp'">
                                    Trang cá nhân
                                </div>

                                <div class="dropdown-item logout"
                                     onclick="window.location.href='${pageContext.request.contextPath}/logout'">
                                    Đăng xuất
                                </div>
                            </c:otherwise>
                        </c:choose>


<%--                    <div class="register-login" id="loginForm" class="a-same-nodecoration"--%>
<%--                        >--%>
<%--                        <a href="${pageContext.request.contextPath}/login" class="a-same-nodecoration">--%>
<%--                        <div style="cursor: pointer" class="no-margin">--%>
<%--                            <i class="bi bi-door-open"></i>--%>
<%--                            <p>Đăng nhập</p>--%>
<%--                        </div>--%>
<%--                        </a>--%>

<%--                        <a href="${pageContext.request.contextPath}/register" class="a-same-nodecoration">--%>
<%--                        <div class="no-margin" onclick="goRegister()" style="cursor: pointer">--%>
<%--                            <i class="bi bi-person-plus"></i>--%>
<%--                            <p>Đăng ký</p>--%>
<%--                        </div>--%>
<%--                        </a>--%>
<%--                    </div>--%>

                    </div>
                </div>


<%--==========================================================================--%>






                    <a href="${pageContext.request.contextPath}/cart">
                    <div class="icon" style="cursor: pointer" onclick="goCart()">
                        <div class="cart">
                            <i class="bi bi-cart2" title="cart"></i>
                            <div class="num">
                                <p
                                        id="cart_num"
                                        style="
                          border-radius: 8px;
                          padding: 2px;
                          background-color: #e85221;
                          color: white;
                        "
                                >
                                    0
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

                    <a href="${pageContext.request.contextPath}/#"><div title="menu" class="menu3" >LIÊN HỆ</div></a>

                </div>
            </div>
        </div>
    </div>
</header>
</body>
</html>

