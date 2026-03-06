<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/same_style/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/login_logout/register.css">
</head>
<body>

<jsp:include page="/Assets/component/recycleFiles/header.jsp"/>

<form action="${pageContext.request.contextPath}/register" method="post" class="form-register">
    <div class="container1">

        <h2 class="title">ĐĂNG KÝ</h2>
        <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a></p>

        <!-- MESSAGE -->
        <% if (session.getAttribute("msg") != null) { %>
        <div class="alert alert-info">
            <%= session.getAttribute("msg") %>
        </div>
        <% session.removeAttribute("msg"); %>
        <% } %>

        <input class="input" type="text" name="username"
               placeholder="Tên đăng nhập (*)" required>

        <input class="input" type="email" name="email"
               placeholder="Email (*)" required>

        <input class="input" type="text" name="phoneNum"
               placeholder="Số điện thoại">

        <input class="input" type="password" name="password"
               placeholder="Mật khẩu (*)" required>

        <input class="input" type="password" name="confirm_password"
               placeholder="Nhập lại mật khẩu (*)" required>

        <button class="button" type="submit">ĐĂNG KÝ</button>

    </div>
</form>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

</body>
</html>
