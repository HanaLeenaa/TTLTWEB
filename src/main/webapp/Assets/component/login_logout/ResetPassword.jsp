<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/header.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/login_logout/verify.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/same_style/style.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>

        .alert-error{
            color: red;
            margin-bottom: 15px;
            font-size: 15px;
            text-align: center;
        }

        .alert-success{
            color: green;
            margin-bottom: 15px;
            font-size: 15px;
            text-align: center;
        }

        .reset-form{
            display: flex;
            flex-direction: column;
            gap: 15px;
            width: 100%;
        }

        .reset-form input{
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        .reset-form button{
            padding: 12px;
            border: none;
            border-radius: 6px;
            background: #000;
            color: white;
            font-size: 15px;
            cursor: pointer;
        }

    </style>

</head>

<body>

<jsp:include page="/Assets/component/recycleFiles/header.jsp"/>

<div class="container1">

    <h2 class="title">Đổi mật khẩu</h2>

    <p>Vui lòng nhập mật khẩu mới</p>

    <!-- Hiển thị lỗi -->
    <c:if test="${not empty error}">
        <div class="alert-error">
                ${error}
        </div>
    </c:if>

    <!-- Hiển thị message -->
    <c:if test="${not empty message}">
        <div class="alert-success">
                ${message}
        </div>
    </c:if>

    <form class="reset-form"
          action="${pageContext.request.contextPath}/reset-password"
          method="post">

        <input type="password"
               name="newPassword"
               placeholder="Mật khẩu mới"
               required>

        <input type="password"
               name="confirmPassword"
               placeholder="Nhập lại mật khẩu"
               required>

        <button type="submit">
            Đổi mật khẩu
        </button>

    </form>

</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

</body>
</html>