<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Panel</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/AdminPage/admin.css">
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

