<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>Liên hệ</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/homeStyle/contact.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/header.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">

    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
    />
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
    />
    <style>
            .toast {
            position: fixed;
            top: 20px;
            right: 20px;
            background: #4CAF50;
            color: white;
            padding: 14px 20px;
            border-radius: 8px;
            font-size: 14px;
            z-index: 9999;
            opacity: 0;
            transform: translateY(-20px);
            animation: slideIn 0.4s forwards;
            }

            @keyframes slideIn {
            to {
            opacity: 1;
            transform: translateY(0);
            }
            }
    </style>
</head>
<body>
<%--Thông báo gửi contact thành công--%>
<c:if test="${param.success == '1'}">
    <div id="toast-msg" class="toast success">
        Gửi liên hệ thành công! Chúng tôi sẽ phản hồi sớm.
    </div>
</c:if>

<jsp:include page="/Assets/component/recycleFiles/header.jsp" />
<main>
    <section class="contact-section">
        <div class="contact-container">

            <div class="contact-info">
                <h4 class="contact-title">Liên hệ</h4>
                <h2 class="store-title">Thông tin cửa hàng</h2>

                <c:if test="${contact != null}">
                    <div class="info-item">
                        <i class="fa-solid fa-building"></i>
                        <p>Địa chỉ: ${contact.address}</p>
                    </div>

                    <div class="info-item">
                        <i class="fa-solid fa-envelope"></i>
                        <p>Email: ${contact.gmail}</p>
                    </div>

                    <div class="info-item">
                        <i class="fa-solid fa-phone"></i>
                        <p>SĐT: ${contact.phone}</p>
                    </div>
                </c:if>

                <h3 class="feedback-title">
                    Chúng tôi luôn sẵn sàng lắng nghe
                </h3>

                <form method="post" action="${pageContext.request.contextPath}/contact">
    <textarea class="feedback-input"
              name="message"
              placeholder="Viết phản hồi của bạn..."
              required></textarea>

                    <button type="submit" class="feedback-btn">Gửi</button>
                </form>
            </div>

            <div class="contact-image">
                <img src="${pageContext.request.contextPath}/Assets/image/contact_support-team.jpg" alt="">
            </div>

        </div>
    </section>
</main>

<!-- Modal thông báo -->
<div id="feedback-modal" class="modal" style="display: none;">
    <div class="modal-content">
        <p id="modal-message"></p>
        <button id="modal-ok">OK</button>
    </div>
</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

<script>
    setTimeout(() => {
        const toast = document.getElementById("toast-msg");
        if (toast) {
            toast.style.transition = "0.5s";
            toast.style.opacity = "0";
            setTimeout(() => toast.remove(), 500);
        }
    }, 5000);
</script>

</body>
</html>
