<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Panel</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/AdminPage/admin.css">
    <style>
        .admin-wrapper {
            display: flex !important;
            min-height: 100vh;
            background: #f4f6fb;
        }

        .content {
            flex: 1;
            min-width: 0;
            padding: 25px;
            box-sizing: border-box;
        }
    </style>
</head>
<body>

<div class="admin-wrapper">

    <jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>

    <div class="content">
        <jsp:include page="${contentPage}" />
    </div>

</div>

</body>
</html>