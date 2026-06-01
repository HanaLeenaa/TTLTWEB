<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang cá nhân</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/login_logout/profile.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/header.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">
</head>

<body>

<%@ include file="/Assets/component/recycleFiles/header.jsp" %>

<div class="profile-container">

<%--    SIDEBAR --%>
    <div class="sidebar">
        <h3>THÔNG TIN NGƯỜI DÙNG</h3>

        <p>
            Xin chào,
            <b>${user.username}</b>
        </p>

        <p>
            <i class="fa-solid fa-phone"></i>
            <c:out value="${user.phoneNum}" />
        </p>
        <p>
            <i class="fa-solid fa-location-dot"></i>
            <c:out value="${user.location}" />
        </p>

        <ul class="menu">

<%--            -- LỊCH SỬ MUA --%>
            <li class="${tab == 'orders' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/profile?tab=orders">
                    Lịch sử mua hàng
                </a>
            </li>

<%--            LỊCH SỬ ĐÁNH GIÁ --%>
            <li class="${tab == 'reviews' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/profile?tab=reviews">
                    Lịch sử đánh giá
                </a>
            </li>

<%--             SỬA THÔNG TIN --%>
            <li class="${tab == 'edit' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/profile?tab=edit">
                    Chỉnh sửa thông tin
                </a>
            </li>

<%--             ĐỔI MẬT KHẨU --%>
            <li class="${tab == 'password' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/profile?tab=password">
                    Đổi mật khẩu
                </a>
            </li>

        </ul>
    </div>

    <div class="content">
        <c:choose>

<%--           LỊCH SỬ MUA HÀNG --%>
            <c:when test="${tab == 'orders'}">
                <div class="order-history">
                    <h2>Lịch sử mua hàng</h2>

                    <c:if test="${empty orders}">
                        <p>Chưa có đơn hàng nào.</p>
                    </c:if>

                    <c:if test="${not empty orders}">
                        <table class="order-table" width="100%" cellpadding="10">
                            <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Ngày đặt</th>
                                <th>Địa chỉ nhận</th>
                                <th>Tổng tiền</th>
                                <th>Thanh toán</th>
                                <th>Trạng thái</th>
                                <th></th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td>#${o.ID}</td>
                                    <td>${o.createAt}</td>
                                    <td>${o.receiver_address}</td>
                                    <td>
                                        <fmt:formatNumber value="${o.price}" type="number"/>đ
                                    </td>
                                    <td>${o.payment_method}</td>
                                    <td>${o.status}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/order-history-detail?id=${o.ID}">
                                            Xem chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                </div>
            </c:when>

<%--            LỊCH SỬ ĐÁNH GIÁ --%>
            <c:when test="${tab == 'reviews'}">
                <div class="review-history">
                    <h2>Lịch sử đánh giá</h2>

                    <c:if test="${empty reviews}">
                        <p>Chưa có đánh giá nào.</p>
                    </c:if>

                    <c:if test="${not empty reviews}">
                        <table class="order-table" width="100%" cellpadding="10">
                            <thead>
                            <tr>
                                <th>Tên sản phẩm</th>
                                <th>Đánh giá</th>
                                <th>Nhận xét</th>
                                <th>Ngày</th>
                                <th>Giờ</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:forEach var="r" items="${reviews}">
                                <tr>
                                    <td>${r.productName}</td>
                                    <td>${r.rating}/5 ⭐</td>
                                    <td>${r.review_text}</td>
                                    <td>${r.reviewDateOnly}</td>
                                    <td>${r.reviewTimeOnly}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>

                        <!-- PAGINATION PHẢI NẰM TRONG REVIEWS -->
                        <div style="margin-top: 20px; text-align: center;">

                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/profile?tab=reviews&page=${currentPage - 1}">
                                    ◀ Trước
                                </a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="${pageContext.request.contextPath}/profile?tab=reviews&page=${i}"
                                   style="margin:0 5px; font-weight:${i == currentPage ? 'bold' : 'normal'}">
                                        ${i}
                                </a>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/profile?tab=reviews&page=${currentPage + 1}">
                                    Sau ▶
                                </a>
                            </c:if>

                        </div>

                    </c:if>
                </div>
            </c:when>

<%--             CHỈNH SỬA THÔNG TIN --%>
            <c:when test="${tab == 'edit'}">
                <div class="edit-profile">
                    <h2>Sửa thông tin</h2>

                    <form action="${pageContext.request.contextPath}/update-profile"
                          method="post">

                        <label>Tên người dùng</label>

                        <input class="input"
                               name="username"
                               value="${user.username}" />

                        <label>Email</label>

                        <input class="input"
                               name="email"
                               value="${user.email}" />

                        <label>Số điện thoại</label>

                        <input class="input"
                               name="phoneNum"
                               value="${user.phoneNum}" />

                        <label>Địa chỉ</label>

                        <input class="input"
                               name="location"
                               value="${user.location}" />

                        <div class="btn-box">

                            <button class="btn1"
                                    type="submit">

                                Lưu thay đổi

                            </button>

                            <button type="button"
                                    class="btn1 cancel"
                                    onclick="window.location.href='${pageContext.request.contextPath}/profile?tab=edit'">
                                Huỷ

                            </button>

                        </div>

                    </form>

                </div>

            </c:when>

<%--             ĐỔI MẬT KHẨU --%>
            <c:when test="${tab == 'password'}">

                <div class="edit-profile">

                    <h2>Đổi mật khẩu</h2>

<%--                    THÔNG BÁO LỖI --%>
                    <c:if test="${not empty sessionScope.error}">

                        <div style="
                            background:#ffe5e5;
                            color:#d8000c;
                            padding:10px;
                            border-radius:6px;
                            margin-bottom:15px;
                        ">

                                ${sessionScope.error}

                        </div>

                        <c:remove var="error"
                                  scope="session"/>

                    </c:if>

<%--                     THÔNG BÁO THÀNH CÔNG --%>
                    <c:if test="${not empty sessionScope.successMessage}">

                        <div style="
                            background:#e6ffed;
                            color:#008a2e;
                            padding:10px;
                            border-radius:6px;
                            margin-bottom:15px;
                        ">

                                ${sessionScope.successMessage}

                        </div>

                        <c:remove var="successMessage"
                                  scope="session"/>

                    </c:if>

                    <form action="${pageContext.request.contextPath}/change-password"
                          method="post">

                        <label>Mật khẩu cũ</label>

                        <input class="input"
                               type="password"
                               name="oldPassword"
                               placeholder="Nhập mật khẩu cũ"
                               required />

                        <label>Mật khẩu mới</label>

                        <input class="input"
                               type="password"
                               name="newPassword"
                               placeholder="Ít nhất 8 ký tự gồm hoa, thường, số, ký tự đặc biệt"
                               required />

                        <label>Xác nhận mật khẩu mới</label>

                        <input class="input"
                               type="password"
                               name="confirmPassword"
                               placeholder="Nhập lại mật khẩu mới"
                               required />

                        <div class="btn-box">

                            <button class="btn1"
                                    type="submit">

                                Đổi mật khẩu

                            </button>
                        </div>
                    </form>
                </div>
            </c:when>
        </c:choose>
    </div>
</div>

<%--POPUP UPDATE SUCCESS --%>
<c:if test="${param.success == '1'}">
    <div class="popup-overlay">
        <div class="popup-box">
            <p>Đã cập nhật thông tin</p>

            <button onclick="
                    window.location.href=
                    '${pageContext.request.contextPath}/profile?tab=edit'
                    ">

                OK
            </button>
        </div>
    </div>
</c:if>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />

</body>
</html>