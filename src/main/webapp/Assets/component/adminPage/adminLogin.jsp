<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/AdminPage/admin_login.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/same_style/style.css">
</head>
<body>

<div class="login-wrapper">
    <div class="login-left">
        <img src="${pageContext.request.contextPath}/Assets/image/admin_login.png" alt="Admin Login">
    </div>

    <div class="login-right">
        <form action="${pageContext.request.contextPath}/admin-login" method="post" class="login-form">
            <c:if test="${not empty ERROR}">
                <p class="error-msg">${ERROR}</p>
            </c:if>

            <h2 class="title">ĐĂNG NHẬP</h2>

            <input class="input"
                   type="text"
                   name="username"
                   id="username"
                   placeholder="Tên đăng nhập/Email">

            <input class="input"
                   type="password"
                   name="password"
                   id="password"
                   placeholder="Mật khẩu">

            <button class="button" type="submit">Đăng nhập</button>
            <p id="message"></p>
        </form>
    </div>
</div>

</body>
</html>