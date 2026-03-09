<%--&lt;%&ndash;--%>
<%--  Created by IntelliJ IDEA.--%>
<%--  User: HUU DAT--%>
<%--  Date: 12/6/2025--%>
<%--  Time: 6:44 PM--%>
<%--  To change this template use File | Settings | File Templates.--%>
<%--&ndash;%&gt;--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Giới thiệu</title>
    <link rel="stylesheet" href="Assets/css/recycleFilecss/header.css">
    <link rel="stylesheet" href="Assets/css/recycleFilecss/footer.css">
    <link rel="stylesheet" href="Assets/css/homeStyle/about.css" />
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
    />
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

<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<!-- INFO -->
<section class="info-wrapper">
    <div class="info-left">
        <div class="service">
            <h2>Đổi mới, Chất lượng và Dịch vụ</h2>
        </div>

        <div class="info-content">
            <c:forEach var="i" items="${infos}">
                <div class="info-box">
                    <h4>${i.title}</h4>
                    <p>${i.description}</p>
                </div>
            </c:forEach>
        </div>
    </div>

    <div class="info-right">
        <img src="${pageContext.request.contextPath}/Assets/image/aboutUs_info.png" alt="About us">
    </div>
</section>

<!-- WHAT WE DO -->
<div class="we">Chúng tôi làm gì</div>

<div class="we-do">
    <c:forEach var="w" items="${works}">
        <div class="do">
            <img src="${pageContext.request.contextPath}/${w.image}" alt="${w.title}">
            <h3>${w.title}</h3>
            <p>${w.description}</p>
        </div>
    </c:forEach>
</div>

<!-- FINAL -->
<div class="final-content">
    <c:forEach var="f" items="${finalItems}">
        <div class="text">
            <p>${f.description}</p>
            <h4>${f.title}</h4>
        </div>
    </c:forEach>
</div>

<!-- <div id="footer"></div> -->

<!--Footer-->

<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />
</body>
</html>
