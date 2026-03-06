<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực OTP</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/login_logout/verify.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/same_style/style.css">
</head>
<body>
<%@ include file="../recycleFiles/header.jsp" %>

<div class="container1">
    <h2 class="title">Xác thực tài khoản</h2>
    <p>Vui lòng nhập mã OTP 6 chữ số được gửi tới email của bạn.</p>

    <%-- Thông báo từ session --%>
    <% if (session.getAttribute("msg") != null) { %>
    <div class="alert alert-info">
        <%= session.getAttribute("msg") %>
    </div>
    <% session.removeAttribute("msg"); %>
    <% } %>

    <%-- Form OTP --%>
    <form action="<%= request.getContextPath() %>/verify-otp" method="post" class="form-register">
        <input class="input" type="text" name="otp" placeholder="Nhập mã OTP" required maxlength="6"><br>
        <button class="button" type="submit">Xác thực</button>
    </form>

    <form action="${pageContext.request.contextPath}/resend-otp" method="post">
        <button type="submit" class="btn-resend">
            Gửi lại mã OTP
        </button>
    </form>

    <p>Nếu bạn không nhận được email OTP, vui lòng kiểm tra hộp thư spam hoặc thử đăng ký lại.</p>
</div>

<%@ include file="../recycleFiles/footer.jsp" %>
</body>
</html>
