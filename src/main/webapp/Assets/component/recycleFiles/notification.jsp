<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Thông báo</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">

    <style>
        body {
            font-family: Arial;
            background: #f5f6fa;
            padding: 0 10px;
        }

        .container {
            width: 700px;
            margin: 40px auto;
        }

        h2 {
            margin-bottom: 20px;
        }
        h2 i.fa-bell{
            color: orange;
        }

        .notify-card {
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: 0.2s;
        }

        .notify-card:hover {
            transform: translateY(-2px);
        }

        .unread {
            border-left: 5px solid #e95211;
            background: #eef6ff;
        }

        .title {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .msg {
            margin: 4px 0;
        }

        .reply {
            color: green;
        }

        .time {
            font-size: 12px;
            color: gray;
        }

        .empty {
            text-align: center;
            color: gray;
            margin-top: 40px;
        }

    </style>
</head>

<body>
<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<div class="container">

    <h2><i class="fa-solid fa-bell"></i> Thông báo của bạn</h2>

    <c:if test="${empty notifications}">
        <div class="empty">Không có thông báo nào</div>
    </c:if>

    <c:forEach var="c" items="${notifications}">
        <div class="notify-card ${c.read == false ? 'unread' : ''}"
             onclick="goDetail(${c.ID})">

            <div class="title"><i class="fa-regular fa-envelope"></i>Bạn đã gửi:</div>
            <div class="msg">${c.message}</div>

            <div class="title"><i class="fa-solid fa-reply"></i> Admin phản hồi:</div>
            <div class="msg reply">${c.reply}</div>

            <div class="time">${c.createdAt}</div>
        </div>
    </c:forEach>

</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

<script>
    function goDetail(id){
        window.location.href =
            "${pageContext.request.contextPath}/user/notification/read?id=" + id;
    }
</script>

</body>
</html>