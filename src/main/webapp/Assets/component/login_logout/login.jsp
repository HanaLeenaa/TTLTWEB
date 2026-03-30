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
</head>
<body>
<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<div class="login-container">
    <!-- Ảnh-->
    <div class="login-left">
        <img src="https://png.pngtree.com/thumb_back/fh260/background/20230706/pngtree-d-illustration-of-a-gaming-enthusiast-with-smartphone-game-console-controller-image_3796915.jpg" alt="Login Image">
    </div>

    <!-- Form đăng nhập-->
    <div class="login-right">
        <c:if test="${not empty sessionScope.loginMessage}">
            <p class="error-msg">${sessionScope.loginMessage}</p>
            <% session.removeAttribute("loginMessage"); %>
        </c:if>

        <c:if test="${not empty error}">
            <p class="error-msg">${error}</p>
        </c:if>

        <h2 class="title">ĐĂNG NHẬP</h2>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <input class="input" type="text" name="username" placeholder="Tên đăng nhập/Email">
            <input class="input" type="password" name="password" placeholder="Mật khẩu">
            <button class="button" type="submit">Đăng nhập</button>
        </form>

        <div class="social-login">
            <a href="${pageContext.request.contextPath}/google-login" class="google-btn">
                <i class="fa-brands fa-google"></i> Đăng nhập bằng Google
            </a>
        </div>

        <div class="social-login">
            <a href="${pageContext.request.contextPath}/google-login" class="google-btn">
                <i class="fa-brands fa-facebook"></i></i> Đăng nhập bằng Facebook
            </a>
        </div>

        <a href="#" class="forgot">Quên mật khẩu?</a>

        <div class="register">
            <span>Bạn chưa có tài khoản?</span>
            <a href="${pageContext.request.contextPath}/Assets/component/login_logout/register.jsp" class="link1">Đăng ký tại đây</a>
        </div>
    </div>
</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />
</body>
</html>