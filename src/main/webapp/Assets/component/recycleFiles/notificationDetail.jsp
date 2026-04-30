<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Chi tiết thông báo</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <style>
        body {
            background: #f5f6fa;
            font-family: Arial;
        }

        .container {
            width: 700px;
            margin: 40px auto;
        }

        .card {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .section {
            margin-bottom: 15px;
        }

        .label {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .user-msg {
            background: #f1f1f1;
            padding: 10px;
            border-radius: 6px;
        }

        .admin-reply {
            background: #e8f8f0;
            padding: 10px;
            border-radius: 6px;
            color: green;
        }

        .time {
            font-size: 12px;
            color: gray;
        }

        .back {
            margin-top: 15px;
            display: inline-block;
            text-decoration: none;
            color: #e85221;
        }
    </style>
</head>
<body>

<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<div class="container">

    <div class="card">

        <h3><i class="fa-regular fa-envelope"></i> Chi tiết thông báo</h3>

        <div class="section">
            <div class="label">Bạn đã gửi:</div>
            <div class="user-msg">
                ${notify.message}
            </div>
        </div>

        <div class="section">
            <div class="label">Admin phản hồi:</div>

            <c:choose>
                <c:when test="${empty notify.reply}">
                    <div style="color: gray">Chưa có phản hồi</div>
                </c:when>
                <c:otherwise>
                    <div class="admin-reply">
                            ${notify.reply}
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="time">
            ${notify.createdAt}
        </div>

        <a href="${pageContext.request.contextPath}/user/notifications"
           class="back">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>

    </div>

</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

</body>
</html>