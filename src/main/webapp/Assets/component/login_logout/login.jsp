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

        <h2 class="title">ĐĂNG NHẬP</h2>

        <input class="input" type="text" name="username" id="username" placeholder="Tên đăng nhập/Email"><br>
        <input class="input" type="password" name="password" id="password" placeholder="Mật Khẩu"><br>

        <button class="button" type="submit">Đăng nhập</button>

        <!-- Thông báo -->
        <p id="forgotMsg" style="color: gray; text-align:center; margin-top:10px;"></p>

        <!-- Link Quên mật khẩu -->
        <a href="#" id="forgotLink">Quên mật khẩu</a>

        <div class="register">
            <span>Bạn chưa có tài khoản?</span>
            <a href="${pageContext.request.contextPath}/Assets/component/login_logout/register.jsp" class="link1">Đăng ký tại đây</a>
        </div>
    </div>
</form>

<script>
    const forgotLink = document.getElementById("forgotLink");
    const forgotMsg = document.getElementById("forgotMsg");

    forgotLink.addEventListener("click", (e) => {
        e.preventDefault();
        const email = prompt("Vui lòng nhập email của bạn để đổi mật khẩu:");
        if(email && email.trim() !== ""){
            fetch("${pageContext.request.contextPath}/forgot-password?email=" + encodeURIComponent(email))
                .then(res => res.json())
                .then(data => {
                    if(data.success){
                        forgotMsg.style.color = "green";
                        forgotMsg.innerText = "Vui lòng kiểm tra email để đổi mật khẩu";
                    } else {
                        forgotMsg.style.color = "red";
                        forgotMsg.innerText = data.message;
                    }
                });
        }
    });
</script>

<script>
    const forgotLink = document.getElementById("forgotLink");
    const forgotMsg = document.getElementById("forgotMsg");
    forgotLink.addEventListener("click", (e) => {
        e.preventDefault();
        const email = prompt("Vui lòng nhập email của bạn để đổi mật khẩu:");
        if(email && email.trim() !== ""){
            // Gọi Ajax gửi yêu cầu quên mật khẩu
            fetch("${pageContext.request.contextPath}/forgot-password?email=" + encodeURIComponent(email))
                .then(res => res.json())
                .then(data => {
                    if(data.success){
                        forgotMsg.style.color = "green";
                        forgotMsg.innerText = "Vui lòng kiểm tra email để đổi mật khẩu";
                    }else{
                        forgotMsg.style.color = "red";
                        forgotMsg.innerText = data.message;
                    }
                });
        }
    });
</script>
<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />
</body>
</html>
