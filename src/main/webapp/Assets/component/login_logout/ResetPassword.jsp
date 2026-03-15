<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
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

<div class="container1">
    <h2 class="title">Đổi mật khẩu</h2>

    <c:if test="${not empty message}">
        <p style="color: green; text-align:center;">${message}</p>
    </c:if>

    <c:if test="${not empty error}">
        <p style="color: red; text-align:center;">${error}</p>
    </c:if>

    <c:if test="${tokenValid}">
        <form action="${pageContext.request.contextPath}/reset-password" method="post">
            <input type="hidden" name="token" value="${token}" />

            <input class="input" type="password" name="newPassword" placeholder="Mật khẩu mới" required><br>
            <input class="input" type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required><br>

            <button class="button" type="submit">Xác nhận</button>
        </form>
    </c:if>

    <c:if test="${not tokenValid}">
        <p style="color: red; text-align:center;">Link không hợp lệ hoặc đã hết hạn</p>
    </c:if>
</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />
</body>
</html>
