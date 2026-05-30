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

<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<div class="container1">

  <h2 class="title">Xác thực OTP</h2>

  <p>
    Vui lòng nhập mã OTP đã được gửi tới email của bạn.
  </p>

  <%-- Hiển thị lỗi --%>
  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-info">
    <%= request.getAttribute("error") %>
  </div>
  <% } %>

  <%-- Form xác thực OTP --%>
  <form action="${pageContext.request.contextPath}/verify-forgot-otp"
        method="post"
        class="form-register">

    <input class="input"
           type="text"
           name="otp"
           placeholder="Nhập mã OTP"
           maxlength="6"
           required>

    <br>

    <button class="button" type="submit">
      Xác thực
    </button>

  </form>

</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />

</body>
</html>