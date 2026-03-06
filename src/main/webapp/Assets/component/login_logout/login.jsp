<%--
  Created by IntelliJ IDEA.
  User: HUU DAT
  Date: 12/27/2025
  Time: 9:05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/login_logout/login.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/same_style/style.css">
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
</head>
<body>
<jsp:include page="/Assets/component/recycleFiles/header.jsp" />
<form action="${pageContext.request.contextPath}/login" method="post">
    <div class="container1">

        <c:if test="${not empty sessionScope.loginMessage}">
            <p style="color: red; text-align: center;">
                    ${sessionScope.loginMessage}
            </p>

            <%
                session.removeAttribute("loginMessage");
            %>
        </c:if>


        <c:if test="${not empty error}">
                    ${error}
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
        <a href="">Quên mật khẩu</a>
        <div class="register">
        <span>Bạn chưa có tài khoản?</span>
        <a href="" class="link1">Đăng ký tại đây</a>
        </div>
    </div>
</form>
<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />
</body>
</html>
