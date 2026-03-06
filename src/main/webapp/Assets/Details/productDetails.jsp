<%--
  Created by IntelliJ IDEA.
  User: HUU DAT
  Date: 12/6/2025
  Time: 7:00 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chi tiết sản phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/Details/productDetails.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/recycleFilecss/footer.css">
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
    />

</head>
<body>
<!-- <div id="header"></div> -->

<jsp:include page="/Assets/component/recycleFiles/header.jsp" />

<main>
    <section class="product-details">
        <div class="product-container">

            <!-- LEFT -->
            <div class="left">
                <img src="${product.image}" alt="${product.name}" title="${product.name}"/>
                <div class="gallery">
                    <c:forEach var="c" items="${gallary}">
                        <img src="${c.img}" alt="${c.metatitle}">
                    </c:forEach>
                </div>
            </div>

            <!-- RIGHT -->
            <div class="right">
                <h2>${product.name}</h2>

                <p><strong>Mã sản phẩm:</strong> #${product.ID}</p>

                <p><strong>Danh mục:</strong> ${category.name}</p>
                <p><strong>Thương hiệu:</strong> ${brand.brand_name}</p>

                <p class="price">
                    ${product.price}đ
                </p>

                <p>
                    <strong>Tình trạng:</strong>
                    <span style="color:${product.active ? 'green' : 'red'}">
                        ${product.active ? "Còn hàng" : "Hết hàng"}
                    </span>
                </p>

                <div class="product-info-box">
                    <div class="product-offer">
                        <h3>Ưu đãi</h3>
                        <ul class="product-endow">
                            <c:forEach items="${endowList}" var="line">
                                <li>${line}</li>
                            </c:forEach>
                        </ul>
                    </div>

                    <div class="product-description">
                        <h3>Mô tả sản phẩm</h3>
                        <ul class="short-desc">
                            <strong>${product.name}</strong>
                            <c:forEach items="${descLines}" var="line">
                                <li>
                                    <c:out value="${line}" escapeXml="false"/>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <div class="quantity-row">
                    <div class="quantity-control">
                        <button>−</button>
                        <span>1</span>
                        <button>+</button>
                    </div>
                </div>

                <div class="action-row">
                    <a href="./notification.html"><button for="notify-toggle" class="btn-add">Thêm vào giỏ hàng</button></a>
                    <a href="../cart_payment/payment.html"><button>Mua ngay</button></a>
                </div>

                <div class="back-row">
                    <a href="../../../products_afterupdate.html"><button>← Quay lại</button></a>
                </div>
            </div>
        </div>

        <section class="product-detail-info">
            <div class="container">
                <div class="description-section">
                    <h3>Mô tả chi tiết</h3>
                    <p>
                        ${product.full_description}
                    </p>
                </div>

                <div class="description-section">
                    <h3>Giới thiệu về console và tay cầm</h3>
                    <p>
                        Console và tay cầm chơi game mang đến trải nghiệm giải trí sống
                        động, phản hồi nhanh và dễ điều khiển. Tay cầm hiện đại tích hợp
                        nhiều tính năng giúp người chơi linh hoạt và tiện lợi.
                    </p>
                </div>

                <div class="description-section">
                    <h3>Đối tượng phù hợp</h3>
                    <p>
                        Sản phẩm hướng tới game thủ mọi lứa tuổi và những người yêu công
                        nghệ, phù hợp cho giải trí, học tập hay thi đấu eSports.
                    </p>
                </div>

                <div class="description-section">
                    <h3>Công nghệ</h3>
                    <p>
                        Console và tay cầm sử dụng công nghệ không dây, cảm biến chuyển
                        động, rung phản hồi, và màn hình sắc nét, giúp trải nghiệm chơi
                        game mượt mà và chính xác.
                    </p>
                </div>

                <div class="specs-section">
                    <h3>Thông số kỹ thuật</h3>

                    <table>
                        <tr>
                            <th>Thuộc tính</th>
                            <th>Giá trị</th>
                        </tr>
                        <tr>
                            <td>Kết nối</td>
                            <td>${product.connect}</td>
                        </tr>
                        <tr>
                            <td>Pin</td>
                            <td>${product.energy}0mah</td>
                        </tr>
                        <tr>
                            <td>Thời gian sử dụng</td>
                            <td>${product.useTime}hours</td>
                        </tr>
                        <tr>
                            <td>Hỗ trợ</td>
                            <td>${product.suports}</td>
                        </tr>
                        <tr>
                            <td>Khối lượng</td>
                            <td>${product.weight}g</td>
                        </tr>
                    </table>
                </div>
            </div>
        </section>
    </section>
</main>

<!-- <div id="footer"></div> -->
<!-- sản phẩm liên quan -->
<div class="related-section">
    <div class="container">
        <h3>Sản phẩm liên quan</h3>
        <div class="related-grid">
            <span class="position-same position-left"><i class="bi bi-arrow-left"></i></span>
            <span class="position-same position-right"><i class="bi bi-arrow-right"></i></span>
            <div class="related-card">
                <img src="https://cdn2.cellphones.com.vn/x/media/catalog/product/t/a/tay-cam-choi-game-ps5-dualsense-1.png" alt="">
                <div class="related-name">Tay cầm PS5 DualSense</div>
                <div class="related-price">1.590.000đ</div>
            </div>

            <div class="related-card">
                <img src="https://nvs.tn-cdn.net/2021/01/Tay-cam-choi-game-Xbox-Series-X-Controller-den-1-1.jpg" alt="">
                <div class="related-name">Xbox Series Controller</div>
                <div class="related-price">1.450.000đ</div>
            </div>

            <div class="related-card">
                <img src="https://www.droidshop.vn/wp-content/uploads/2022/01/May-choi-game-Nintendo-Switch-OLED-model-with-White-Joy%E2%80%91Con.jpg" alt="">
                <div class="related-name">Nintendo Switch OLED</div>
                <div class="related-price">7.990.000đ</div>
            </div>

            <div class="related-card">
                <img src="https://www.droidshop.vn/wp-content/uploads/2023/05/May-choi-game-Xbox-Series-X.jpg" alt="">
                <div class="related-name">Xbox Series X</div>
                <div class="related-price">12.000.000đ</div>
            </div>

        </div>
    </div>
</div>

<!--
  reviews
 -->
<div class="review-section">
    <div class="container">
        <h2>Đánh giá & nhận xét <span id="product_name"></span></h2>

        <div class="overall-rating">
            <div class="score">
                <h3>5.0/5</h3>
                <div class="stars">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i>
                    <i class="fas fa-star"></i><i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                </div>
                <p>5 đánh giá</p>
            </div>
            <div class="rating-bars">
                <div class="rating-bar">
                    5 <i class="fas fa-star"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: 100%"></div>
                    </div>
                    <span>5 đánh giá</span>
                </div>
                <div class="rating-bar">
                    4 <i class="fas fa-star"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: 0%"></div>
                    </div>
                    <span>0 đánh giá</span>
                </div>
                <div class="rating-bar">
                    3 <i class="fas fa-star"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: 0%"></div>
                    </div>
                    <span>0 đánh giá</span>
                </div>
                <div class="rating-bar">
                    2 <i class="fas fa-star"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: 0%"></div>
                    </div>
                    <span>0 đánh giá</span>
                </div>
                <div class="rating-bar">
                    1 <i class="fas fa-star"></i>
                    <div class="bar-container">
                        <div class="bar" style="width: 0%"></div>
                    </div>
                    <span>0 đánh giá</span>
                </div>
            </div>
        </div>

        <a href="./reviews.html" class="review-button">Đánh giá ngay</a>

        <!-- List reviews -->
        <div class="review-item">
            <h4>Huy Phan <span class="stars">★★★★★</span></h4>
            <p>Nhận xét: Hàng chất lắm đáng mua</p>
            <div class="review-date">2 năm trước</div>
        </div>

        <div class="review-item">
            <h4>Thanh Huy <span class="stars">★★★★★</span></h4>
            <p>Nhận xét: Rất ngon</p>
            <div class="review-date">3 năm trước</div>
        </div>

        <div class="review-item">
            <h4>Nguyễn Phước Thịnh <span class="stars">★★★★★</span></h4>
            <p>Nhận xét: Chất lượng tốt, đáng mua</p>
            <div class="review-date">3 năm trước</div>
        </div>

</div>
</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp" />
</body>
</html>
