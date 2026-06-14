<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<footer class="footer">
    <div class="footer-container">
        <!-- CONNECT WITH US -->
        <div class="footer-section">
            <h3>Liên Hệ Với Chúng Tôi</h3>
            <form action="${pageContext.request.contextPath}/contact" method="post">
                <div class="subscribe">

                    <textarea name="message" placeholder="Nhập nội dung liên hệ" required></textarea>

                    <button type="submit">
                        <i class="fa-solid fa-paper-plane"></i> Gửi
                    </button>
                </div>
            </form>
            <div class="social-icons">
                <c:forEach var="c" items="${icon}">
                    <a href="#">${c.link_icon}</a>
                </c:forEach>
            </div>
        </div>

        <!-- USEFUL LINKS -->
        <div class="footer-section">
            <h3>Truy cập nhanh</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/contact">Liên Hệ</a></li>
                <li><a href="#">Điều khoản và điều kiện</a></li>
                <li><a href="#">Phương thức thanh toán</a></li>
                <li><a href="#">Giao hàng và trả hàng</a></li>
                <li><a href="#">Chính sách bảo mật</a></li>
            </ul>
        </div>
        <!-- CONTACT -->
        <div class="footer-section">
            <h3>Liên hệ</h3>
            <p>
                <i class="fa-regular fa-envelope" style="color: #e95221"></i>
                ${infor.gmail}
            </p>
            <p>
                <i class="fa-solid fa-phone" style="color: #e95221"></i>
                ${infor.phone}
            </p>
            <p>
                <i class="bi bi-pin-map"  style="color: #e95221"></i>
                ${infor.address}
            </p>
        </div>

        <!-- HELP -->
        <div class="footer-section">
            <h3>Chúng tôi luôn sẵn sàng giúp đỡ bạn</h3>
            <p>
                Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng hỗ trợ bạn mọi thắc mắc,
                đơn hàng hoặc vấn đề. Hãy liên hệ với chúng tôi. Chúng tôi rất vui
                được hỗ trợ!
            </p>
        </div>
    </div>
</footer>
