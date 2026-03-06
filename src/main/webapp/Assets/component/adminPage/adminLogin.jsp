<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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

<form action="${pageContext.request.contextPath}/admin-login" method="post">
    <div class="container1">

        <c:if test="${not empty ERROR}">
            <p class="error-msg">${ERROR}</p>
        </c:if>

        <h2 class="title">ĐĂNG NHẬP</h2>
        <input class="input"
               type="text"
               type="email"
               name="username"
               id="username"
               placeholder="Tên đăng nhập/Email"><br>

        <input class="input"
               type="password"
               name="password"
               id="password"
               placeholder="Mật Khẩu"><br>

        <button class="button" type="submit">Đăng nhập</button>
        <p id="message"></p>


    </div>
</form>

</body>
</html>
