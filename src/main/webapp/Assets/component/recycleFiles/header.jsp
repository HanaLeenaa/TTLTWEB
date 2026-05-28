<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>header</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/homeStyle/searchSuggest.css">
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
    />
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

        .notification-icon {
            display: inline-flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            vertical-align: top;
            cursor: pointer;
            margin-right: 20px;
            position: relative;
        }

        .notification-icon i {
            font-size: 22px;
            line-height: 1.2;
            display: block;
        }

        .notification-icon p {
            margin: 0;
            font-size: 10px;
            white-space: nowrap;
            line-height: 1.5;
        }

        .bell-wrapper {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 26px;
        }

        .badge {
            position: absolute;
            top: -6px;
            right: -8px;
            background: red;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 11px;
        }

        .notify-dropdown {
            display: none;
            position: absolute;
            right: 0;
            top: 42px;
            width: 340px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            z-index: 999;
            overflow: hidden;
        }

        .notify-header {
            padding: 10px;
            font-weight: bold;
            border-bottom: 1px solid #eee;
            background: #fafafa;
        }

        .notify-item {
            display: flex;
            gap: 10px;
            padding: 12px;
            border-bottom: 1px solid #f1f1f1;
            cursor: pointer;
            transition: 0.2s;
        }

        .notify-item:hover {
            background: #f5f5f5;
        }

        .notify-item.unread {
            background: #eef6ff;
        }

        .notify-icon {
            font-size: 18px;
            color: #e85221;
            margin-top: 4px;
        }

        .notify-content {
            flex: 1;
        }

        .notify-content .title {
            font-size: 13px;
            font-weight: 600;
        }

        .notify-content .msg {
            font-size: 13px;
            color: #333;
        }

        .notify-time {
            font-size: 11px;
            color: gray;
            margin-top: 3px;
        }

        .view-all {
            display: block;
            text-align: center;
            padding: 10px;
            background: #fafafa;
            text-decoration: none;
            color: #e85221;
            font-weight: bold;
        }

        .new-badge{
            background: red;
            color: white;
            font-size: 10px;
            font-weight: bold;
            padding: 2px 6px;
            border-radius: 10px;
            margin-left: 6px;
            vertical-align: middle;
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
                <div
                        class="search-box-mobile"
                        style="display: none"
                        id="search-box"
                >
                    <input type="text" placeholder="Tìm kiếm sản phẩm..." />
                </div>
                <div class="logo" style="cursor:pointer">
                    <a href="${pageContext.request.contextPath}/home">
                        <img
                                title="${not empty logo ? logo.titleLogo : 'Console Shop'}"
                                src="${not empty logo ? logo.linkLogo : 'https://placehold.co/150x50?text=Logo'}"
                        />
                    </a>
                </div>

                <div class="center">
                    <div class="center-1 same-icon">
                        <i class="fa-solid fa-headset"></i>
                        <b style="font-size: 13px">HOTLINE:</b>
                        <span title="hotline">
                            ${not empty contactNumber ? contactNumber.phone : '1900 xxxx'}
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

    <div class="icon notification-icon" id="notifyBtn">

        <div class="bell-wrapper">
            <i class="fa-solid fa-bell"></i>

            <c:if test="${notifyCount > 0}">
                <span class="badge">${notifyCount}</span>
            </c:if>
        </div>

        <p>THÔNG BÁO</p>

        <div class="notify-dropdown" id="notifyBox">

            <div class="notify-header">Thông báo</div>

            <c:if test="${empty notifications}">
                <div class="notify-empty">Không có thông báo</div>
            </c:if>

            <c:forEach var="c" items="${notifications}">
                <div class="notify-item ${!c.read ? 'unread' : ''}"
                     onclick="goNotify(${c.ID})">

                    <div class="notify-icon">
                        <i class="fa-solid fa-reply"></i>
                    </div>

                    <div class="notify-content">
                        <div class="title">Admin đã phản hồi

                        <c:if test="${!c.read}">
                            <span class="new-badge">Mới</span>
                        </c:if>
                        </div>

                        <div class="msg">
                                ${c.reply}
                        </div>

                        <div class="notify-time">
                                ${c.createdAt}
                        </div>
                    </div>
                </div>
            </c:forEach>

            <a href="${pageContext.request.contextPath}/user/notifications"
               class="view-all">
                Xem tất cả →
            </a>

        </div>
    </div>

                    <%--Sửa để xử lý đăng nhập--%>
                    <div class="account-wrapper">
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
                                    <div class="dropdown-item"
                                         onclick="window.location.href='${pageContext.request.contextPath}/wishlist'">
                                         Sản phẩm yêu thích
                                    </div>
                                    <div class="dropdown-item logout"
                                         onclick="window.location.href='${pageContext.request.contextPath}/logout'">
                                        Đăng xuất
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/cart" style="text-decoration: none; color: inherit;">
                        <div class="icon" style="cursor: pointer">
                            <div class="cart">
                                <i class="bi bi-cart2" title="cart"></i>
                                <div class="num">
                                    <p id="cart_num"
                                       style="
                                        border-radius: 8px;
                                        padding: 2px;
                                        background-color: #e85221;
                                        color: white;">
                                        ${not empty sessionScope.cartSize ? sessionScope.cartSize : 0}
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
    <div id="cart-toast"
         style="
         position: absolute;
         top: 60px;
         right: 12px;
         background: #4CAF50;
         color: white;
         padding: 12px 20px;
         border-radius: 8px;
         display: none;
         z-index: 9999;
         font-size: 14px;
         box-shadow: 0 2px 10px rgba(0,0,0,0.2);
     ">
    </div>
</header>

<script>
    const input = document.getElementById("searchInput");
    const box = document.getElementById("suggestBox");
    const contextPath = "${pageContext.request.contextPath}";
    let debounceTimeout = null;

    function formatVND(value) {
        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
    }

    function highlightText(text, keyword) {
        if (!text) return "";
        if (!keyword) return text;
        const regex = new RegExp("(" + keyword.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&') + ")", 'gi');
        return text.replace(regex, '<mark style="background-color: #ffeb3b; padding: 0 2px; color: #000; font-weight: bold;">$1</mark>');
    }

    // Định nghĩa biến cấu trúc ID phân giải thông minh (chấp nhận cả id thường và ID hoa từ Backend)
    function getProp(obj, keys) {
        for (let key of keys) {
            if (obj[key] !== undefined && obj[key] !== null) return obj[key];
        }
        return null;
    }

    function loadSuggestions(keyword) {
        fetch(contextPath + "/search-suggest?q=" + encodeURIComponent(keyword))
            .then(res => res.json())
            .then(data => {
                box.innerHTML = "";

                if (data && data.length > 0) {
                    if (data[0].type === "history") {
                        const headerDiv = document.createElement("div");
                        headerDiv.style = "display: flex; justify-content: space-between; padding: 8px 12px; background: #f5f5f5; font-size: 12px; color: #666; font-weight: bold; border-bottom: 1px solid #eee;";
                        headerDiv.innerHTML = '<span>TÌM KIẾM GẦN ĐÂY</span><span id="clearHistoryBtn" style="color: #e85221; cursor: pointer;"><i class="bi bi-trash3"></i> Xóa tất cả</span>';
                        box.appendChild(headerDiv);

                        headerDiv.querySelector("#clearHistoryBtn").addEventListener("click", (e) => {
                            e.stopPropagation();
                            fetch(contextPath + "/search-suggest", { method: "DELETE" })
                                .then(() => { box.innerHTML = ""; box.style.display = "none"; });
                        });
                    }

                    data.forEach(p => {
                        const item = document.createElement("div");
                        item.className = "suggest-item";

                        if (p.type === "history") {
                            item.innerHTML = '<a href="' + contextPath + '/search?q=' + encodeURIComponent(p.keyword) + '" style="display:flex; align-items:center; text-decoration:none; padding: 10px 12px; width: 100%;">' +
                                '<i class="bi bi-clock-history" style="margin-right: 12px; color: #999;"></i>' +
                                '<span style="color:#333; font-size:14px;">' + p.keyword + '</span>' +
                                '</a>';
                        } else {
                            // 🛠️ ĐỒNG BỘ TOÀN DIỆN BIẾN AN TOÀN TRÁNH CRASH JS
                            const pId = getProp(p, ['id', 'ID']) || '';
                            const pName = p.name || 'Sản phẩm không tên';
                            const pImage = p.image || (contextPath + '/Assets/img/no-image.png');

                            // Kiểm tra stock để cập nhật trạng thái
                            const stockCount = getProp(p, ['stock', 'stock_quantity']) || 0;
                            const pStatus = stockCount > 0 ? 'Còn hàng' : 'Hết hàng';
                            const statusColor = stockCount > 0 ? 'green' : 'red';

                            const rawPrice = p.price || 0;
                            const productPrice = Number(rawPrice);
                            const displayPrice = (isNaN(productPrice) || productPrice === 0) ? "Liên hệ" : formatVND(productPrice);

                            const displayName = highlightText(pName, keyword);

                            // Tiến hành render chuỗi HTML sạch bằng các biến an toàn đã khai báo
                            item.innerHTML = '<a href="' + contextPath + '/product-detail?id=' + pId + '" style="display:flex; align-items:center; text-decoration:none; padding: 8px 12px; width: 100%; border-bottom: 1px solid #fafafa;">' +
                                             '<img src="' + pImage + '" onerror="this.onerror=null; this.src=\'' + contextPath + '/Assets/img/no-image.png\';" style="width:45px; height:45px; object-fit:cover; margin-right:12px; border-radius:4px;">' +
                                             '<div style="display:flex; flex-direction:column; flex: 1;">' +
                                             '<span style="color:#222; font-size:14px; font-weight:500; line-height:1.3;">' + displayName + '</span>' +
                                             '<div style="display:flex; justify-content: space-between; margin-top: 4px; font-size:12px;">' +
                                             '<span style="color:#e85221; font-weight: bold;">' + displayPrice + '</span>' +
                                             '<span style="color: ' + statusColor + '; font-size:11px;">' + pStatus + '</span>' +
                                             '</div>' +
                                             '</div>' +
                                             '</a>';
                        }
                        box.appendChild(item);
                    });
                    box.style.display = "block";
                } else {
                    box.style.display = "none";
                }
            })
            .catch(err => {
                console.error("Lỗi hệ thống gợi ý:", err);
                box.style.display = "none";
            });
    }

    input.addEventListener("focus", function () {
        loadSuggestions(this.value.trim());
    });

    input.addEventListener("input", function () {
        const keyword = this.value.trim();
        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(() => {
            loadSuggestions(keyword);
        }, 250);
    });

    document.addEventListener("click", (e) => {
        if (!box.contains(e.target) && e.target !== input) {
            box.style.display = "none";
        }
    });
</script>

<script>
    function showToast(msg){
        window.scrollTo({
            top:0,
            behavior: "smooth"
        });
        setTimeout(() => {
            const toast = document.getElementById("cart-toast");
            toast.innerText = msg;
            toast.style.display = "block";

            setTimeout(() => {
                toast.style.display = "none";
            }, 3000);
        }, 300);
    }
</script>

<%--thông báo reply từ admin--%>
<script>
    const notifyBtn = document.getElementById("notifyBtn");
    const notifyBox = document.getElementById("notifyBox");

    notifyBtn.addEventListener("click", (e) => {
        e.stopPropagation();
        notifyBox.style.display =
            notifyBox.style.display === "block" ? "none" : "block";
    });

    document.addEventListener("click", () => {
        notifyBox.style.display = "none";

    });

    function goNotify(id){
        window.location.href =
            "${pageContext.request.contextPath}/user/notification/read?id=" + id;
    }
</script>
</body>
</html>