<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đánh giá</title>

    <style>

        body{
            margin:0;
            font-family:Arial,sans-serif;
            background:#f4f6fb;
        }

        .admin-wrapper{
            display:flex;
            min-height:100vh;
        }

        .content{
            flex:1;
            padding:24px;
        }

        .box{
            background:white;
            padding:20px;
            border-radius:12px;
            box-shadow:0 8px 20px rgba(0,0,0,0.05);
        }

        h2{
            margin-top:0;
            margin-bottom:20px;
        }

        table{
            width:100%;
            border-collapse:collapse;
        }

        th{
            background:#f1f3f9;
            text-align:left;
            padding:12px;
        }

        td{
            padding:12px;
            border-bottom:1px solid #eee;
        }

        .active{
            background:#55efc4;
            padding:4px 10px;
            border-radius:20px;
        }

        .inactive{
            background:#fab1a0;
            padding:4px 10px;
            border-radius:20px;
        }

        .btn-hide{
            background:#e95211;
            color:white;
            border:none;
            border-radius:8px;
            padding:8px 14px;
            cursor:pointer;
        }

        .btn-show{
            background:#00b894;
            color:white;
            border:none;
            border-radius:8px;
            padding:8px 14px;
            cursor:pointer;
        }

        img{
            border-radius:8px;
        }

        .btn-delete{
            background:#d63031;
            color:white;
            border:none;
            border-radius:8px;
            padding:8px 14px;
            cursor:pointer;
        }

        .reply-box{
            margin-top:8px;
            display:flex;
            gap:6px;
            align-items:center;
        }

        .reply-box input{
            flex:1;
            padding:5px;
            border:1px solid #ccc;
            border-radius:4px;
        }

        .reply-box button{
            padding:5px 10px;
            border:none;
            border-radius:5px;
            background:#27ae60;
            color:white;
            cursor:pointer;
        }

        .reply-display{
            margin-top:5px;
            font-size:13px;
            color:#2d3436;
        }

    </style>

</head>

<body>

<div class="admin-wrapper">

    <jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>

    <div class="content">

        <div class="box">

            <h2>⭐ Quản lý đánh giá sản phẩm</h2>

            <table>

                <thead>

                <tr>
                    <th>ID</th>
                    <th>Sản phẩm</th>
                    <th>Khách hàng</th>
                    <th>Sao</th>
                    <th>Nội dung</th>
                    <th>Ảnh</th>
                    <th>Ngày đánh giá</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                    <th>Phản hồi</th>
                </tr>

                </thead>

                <tbody>

                <c:forEach items="${reviews}" var="r">

                    <tr>

                        <td>#${r.ID}</td>

                        <td>${r.productName}</td>

                        <td>${r.username}</td>

                        <td>${r.rating} ⭐</td>

                        <td>${r.review_text}</td>

                        <td>

                            <c:if test="${not empty r.imgReviews}">
                                <img src="${pageContext.request.contextPath}/${r.imgReviews}"
                                     width="80">
                            </c:if>

                        </td>

                        <td>${r.reviewDateOnly}</td>

                        <td>

                            <span class="${r.status ? 'active' : 'inactive'}">

                                <c:choose>

                                    <c:when test="${r.status}">
                                        Hiển thị
                                    </c:when>

                                    <c:otherwise>
                                        Đã ẩn
                                    </c:otherwise>

                                </c:choose>

                            </span>

                        </td>

                        <td>

                            <!-- Ẩn/Hiện -->
                            <button type="button"
                                    class="${r.status ? 'btn-hide' : 'btn-show'}"
                                    onclick="toggleStatus(${r.ID}, ${r.status})">
                                <c:choose>
                                    <c:when test="${r.status}">Ẩn</c:when>
                                    <c:otherwise>Hiện</c:otherwise>
                                </c:choose>
                            </button>

<%--                            Xoá--%>
                            <button type="button"
                                    class="btn-delete"
                                    onclick="deleteReview(${r.ID}, this)">
                                Xóa
                            </button>

                        </td>

                        <td>

                            <!-- REPLY FORM -->
                            <form class="reply-box"
                                  method="post"
                                  action="${pageContext.request.contextPath}/admin/review-reply">

                                <input type="hidden" name="id" value="${r.ID}" />

                                <input type="text"
                                       name="reply"
                                       placeholder="Phản hồi..."
                                       value="${r.admin_reply}" />

                                <button type="submit">
                                    Gửi
                                </button>

                            </form>

                            <c:if test="${not empty r.admin_reply}">
                                <div class="reply-display">
                                    <b>Admin:</b> ${r.admin_reply}
                                </div>
                            </c:if>

                        </td>

                    </tr>

                </c:forEach>

                <c:if test="${empty reviews}">
                    <tr>
                        <td colspan="9"
                            style="text-align:center;color:#999;">
                            Chưa có đánh giá nào
                        </td>
                    </tr>
                </c:if>

                </tbody>

            </table>

        </div>

    </div>

</div>

</body>

<script>

    function toggleStatus(id, status) {
        fetch('${pageContext.request.contextPath}/admin/review-status', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams({
                id: id,
                status: status
            })
        })
            .then(res => res.text())
            .then(data => {
                // reload nhẹ 1 dòng hoặc đổi UI luôn
                location.reload(); // nếu muốn đơn giản
            });
    }

    function deleteReview(id, btn) {
        if (!confirm("Xóa đánh giá này?")) return;

        fetch('${pageContext.request.contextPath}/admin/review-delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams({
                id: id
            })
        })
            .then(res => res.text())
            .then(data => {
                btn.closest("tr").remove();
            });
    }

</script>
</html>