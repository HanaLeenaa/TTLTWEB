<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Trang cá nhân</title>
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

  <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/login_logout/profile.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">
</head>

<body>

<%@ include file="/Assets/component/recycleFiles/header.jsp" %>

<div class="profile-container">

  <div class="sidebar">
    <h3>THÔNG TIN NGƯỜI DÙNG</h3>

    <p>Xin chào, <b>${user.username}</b></p>
    <p>
      <i class="fa-solid fa-phone"></i>
      <c:out value="${user.phoneNum}" />
    </p>

    <p>
      <i class="fa-solid fa-location-dot"></i>
      <c:out value="${user.location}" />
    </p>

    <ul class="menu">
      <li class="${tab == 'orders' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/profile?tab=orders">
          Lịch sử mua hàng
        </a>
      </li>

      <li class="${tab == 'reviews' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/profile?tab=reviews">
          Lịch sử đánh giá
        </a>
      </li>

      <li class="${tab == 'edit' ? 'active' : ''}">
        <a href="${pageContext.request.contextPath}/profile?tab=edit">
          Chỉnh sửa thông tin
        </a>
      </li>
    </ul>
  </div>

  <div class="content">
    <c:choose>

<%--   order--%>
        <%-- order --%>
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
                                <td>${o.price} đ</td>
                                <td>${o.status}</td>
                                <td>
                                    <a class="detail-link"
                                       href="${pageContext.request.contextPath}/order-detail?id=${o.ID}">
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


        <%-- reviews --%>
      <c:when test="${tab == 'reviews'}">
        <div class = "review-history">
        <h2>Lịch sử đánh giá</h2>
        </div>

        <c:if test="${empty reviews}">
          <p>Chưa có đánh giá nào.</p>
        </c:if>

        <c:forEach var="r" items="${reviews}">
          <div>
            <b>${r.productName}</b>
            <p> ${r.rating}/5</p>
            <p>${r.comment}</p>
          </div>
        </c:forEach>
      </c:when>

      <%-- chỉnh sửa thông tin --%>
      <c:when test="${tab == 'edit'}">
        <div class="edit-profile">

          <h2>Sửa thông tin</h2>

          <form action="${pageContext.request.contextPath}/profile" method="post">

          <label>Email</label>
            <input class="input" name="email" value="${user.email}" />

            <label>Số điện thoại</label>
            <input class="input" name="phoneNum" value="${user.phoneNum}"/>

            <label>Địa chỉ</label>
            <input class="input" name="location" value="${user.location}"/>

            <div class="btn-box">
              <button class="btn1" type="submit">Lưu thay đổi</button>

              <button type="button"
                      class="btn1 cancel"
                      onclick="window.location.href='${pageContext.request.contextPath}/profile?tab=edit'">
                Huỷ
              </button>
            </div>
          </form>
        </div>
      </c:when>

    </c:choose>
  </div>
</div>

<c:if test="${param.success == '1'}">
  <div class="popup-overlay">
    <div class="popup-box">
      <p> Đã cập nhật thông tin</p>
      <button onclick="window.location.href='${pageContext.request.contextPath}/profile?tab=edit'">
        OK
      </button>
    </div>
  </div>
</c:if>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

</body>
</html>
