<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quên mật khẩu</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/login_logout/verify.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/same_style/style.css">
</head>
<body>

<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<div class="container1">

  <h2 class="title">Quên mật khẩu</h2>

  <p>
    Nhập email tài khoản của bạn để nhận mã OTP đặt lại mật khẩu.
  </p>

  <%-- Hiển thị lỗi --%>
  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-info">
    <%= request.getAttribute("error") %>
  </div>
  <% } %>

  <%-- Form gửi OTP --%>
  <form action="${pageContext.request.contextPath}/forgot-password"
        method="post"
        class="form-register">

    <input class="input"
           type="email"
           name="email"
           placeholder="Nhập email"
           required>

    <br>

    <button class="button" type="submit">
      Gửi OTP
    </button>

  </form>

</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />

</body>
</html>