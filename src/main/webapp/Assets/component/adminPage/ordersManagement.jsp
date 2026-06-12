<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng | Admin</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/admin-orders.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: "Poppins", Arial, sans-serif;
            background: #f4f6fb;
        }

        .admin-orders-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .order-list,
        .order-detail {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
        }

        .admin-orders-wrapper {
            display: flex;
            min-height: 100vh;
            transition: all 0.3s ease;
        }

        .admin-orders-wrapper .order-list {
            flex: 1;
            margin: 20px;
            transition: all 0.3s ease;
        }

        .admin-orders-wrapper .order-detail {
            width: 0;
            opacity: 0;
            overflow: hidden;
            margin: 20px 0;
            transition: all 0.3s ease;
        }

        .admin-orders-wrapper.show-detail .order-list {
            flex: 0.6;
        }

        .admin-orders-wrapper.show-detail .order-detail {
            flex: 0.4;
            width: auto;
            opacity: 1;
            margin: 20px 20px 20px 0;
        }

        h2, h3 {
            margin-top: 0;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .admin-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .admin-table th {
            text-align: left;
            padding: 12px;
            background: #f1f3f9;
            color: #555;
        }

        .admin-table td {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }

        .admin-table tr:hover {
            background: #f8f9ff;
        }

        .admin-table tr.active {
            background: #eaf0ff;
        }

        .status {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .status.pending {
            background: #fff3cd;
            color: #856404;
        }

        .status.confirmed {
            background: #d1ecf1;
            color: #0c5460;
        }

        .status.shipping {
            background: #cce5ff;
            color: #004085;
        }

        .status.completed {
            background: #d4edda;
            color: #155724;
        }

        .status.cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        a {
            color: #4b7bec;
            text-decoration: none;
            font-weight: 500;
        }

        form {
            margin-top: 10px;
        }

        select {
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        button {
            margin-left: 8px;
            padding: 6px 14px;
            border-radius: 6px;
            border: none;
            background: #4b7bec;
            color: white;
            cursor: pointer;
        }

        button:hover {
            background: #3867d6;
        }

        .order-detail p {
            margin: 6px 0;
            font-size: 14px;
        }

        .admin-table.small th,
        .admin-table.small td {
            font-size: 13px;
        }

        .toolbar {
            display: flex;
            align-items: center;
            gap: 12px;
            width: 100%;
            background: #fff;
            padding: 10px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            box-sizing: border-box;
            margin-bottom: 20px;
        }

        .search-box,
        .status-filter {
            flex: 1;
            height: 40px;
            box-sizing: border-box;
        }

        .search-box input {
            width: 100%;
            height: 100%;
            padding: 0 12px;
            border-radius: 8px;
            border: 1px solid #ddd;
            background: #f9fafc;
            font-family: inherit;
            box-sizing: border-box;
            transition: all 0.3s;
        }

        .search-box input:focus {
            border-color: #4b7bec;
            background: #fff;
            outline: none;
        }

        .status-filter {
            padding: 0 10px;
            border-radius: 8px;
            border: 1px solid #ddd;
            background: #fff;
            font-family: inherit;
            cursor: pointer;
            outline: none;
        }

        .filter-wrapper {
            flex: 0 0 auto;
            position: relative;
        }

        .btn-filter {
            height: 40px;
            padding: 0 16px;
            border-radius: 8px;
            border: 1px solid #ddd;
            background: #fff;
            cursor: pointer;
            color: #333;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            white-space: nowrap;
            transition: all 0.3s;
        }

        .btn-filter:hover {
            border-color: #4b7bec;
            color: #4b7bec;
        }

        .filter-dropdown {
            position: absolute;
            top: calc(100% + 10px);
            right: 0;
            width: 280px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            padding: 20px;
            display: none;
            z-index: 1000;
            border: 1px solid #eee;
        }

        .filter-dropdown.active {
            display: block;
        }

        .filter-dropdown h4 {
            margin: 0 0 15px;
            font-size: 15px;
            color: #333;
        }

        .filter-dropdown label {
            display: block;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 600;
            color: #666;
        }

        .range {
            display: flex;
            gap: 8px;
            align-items: center;
            margin-bottom: 15px;
        }

        .filter-dropdown input {
            width: 100%;
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ddd;
            font-size: 13px;
        }

        .filter-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .btn-primary {
            background: #4b7bec;
            color: white;
            padding: 8px 20px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-reset {
            font-size: 13px;
            color: #888;
            text-decoration: none;
        }

        .btn-reset:hover {
            color: #ff4757;
        }
        .order-detail .fa-hand-point-left {
            color:#e95211;
        }

        .order-list .fa-box {
            color: #e95211;
        }
        .status.cancel-request {
            background: #ffe0e0;
            color: #c0392b;
            font-weight: bold;
            border: 1px solid #ff4d4d;
            padding: 5px 10px;
            border-radius: 20px;
            animation: glow 1.2s infinite;
        }

        @keyframes glow {
            0% {
                box-shadow: 0 0 0 rgba(255, 0, 0, 0);
            }
            50% {
                box-shadow: 0 0 10px rgba(255, 0, 0, 0.7);
            }
            100% {
                box-shadow: 0 0 0 rgba(255, 0, 0, 0);
            }
        }
    </style>
</head>

<body>

<div class="admin-orders-wrapper ${not empty selectedOrder ? 'show-detail' : ''}">
    <jsp:include page="/Assets/component/adminPage/sidebar.jsp"/>
    <!-- ================= DANH SÁCH ĐƠN ================= -->
    <div class="order-list">
        <h2><i class="fa-solid fa-box"></i> Quản lý đơn hàng</h2>

<%--THÔNG BÁO DUYỆT HỦY ĐƠN --%>
        <c:if test="${param.success == 'cancel-approved'}">
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    Swal.fire({
                        icon: 'success',
                        title: 'Duyệt hủy đơn thành công',
                        text: 'Đơn hàng đã được cập nhật sang trạng thái đã hủy',
                        confirmButtonColor: '#28a745'
                    });
                });
            </script>
        </c:if>

        <c:if test="${param.error == 'cancel-failed'}">
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    Swal.fire({
                        icon: 'error',
                        title: 'Duyệt hủy thất bại',
                        text: 'Không thể cập nhật trạng thái đơn hàng',
                        confirmButtonColor: '#d33'
                    });
                });
            </script>
        </c:if>

<%--Thông báo khi cập nhật status đơn hàng --%>
        <c:if test="${param.success == 'updated'}">
        <div id="success-alert"
             style="
            background: #d4edda;
            color: #155724;
            border-left: 6px solid #28a745;
            padding: 14px 18px;
            margin: 15px 0;
            border-radius: 8px;
            font-weight: bold;
            font-size: 16px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            animation: fadeIn 0.4s ease;
         ">
            <i class="fa-solid fa-check"></i> Cập nhật trạng thái thành công
        </div>

        <script>
            setTimeout(() => {
                const alertBox = document.getElementById("success-alert");

                if (alertBox) {
                    alertBox.style.transition = "0.5s";
                    alertBox.style.opacity = "0";

                    setTimeout(() => {
                        alertBox.remove();
                    }, 500);
                }
            }, 3000);
        </script>
        </c:if>

        <c:if test="${param.error == 'invalid-status'}">
        <div id="error-alert"
             style="
            background: #f8d7da;
            color: #721c24;
            border-left: 6px solid #dc3545;
            padding: 14px 18px;
            margin: 15px 0;
            border-radius: 8px;
            font-weight: bold;
            font-size: 16px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            animation: fadeIn 0.4s ease;
         ">
            <i class="fa-solid fa-x"></i> Chuyển trạng thái không hợp lệ
        </div>

        <script>
            setTimeout(() => {
                const alertBox = document.getElementById("error-alert");

                if (alertBox) {
                    alertBox.style.transition = "0.5s";
                    alertBox.style.opacity = "0";

                    setTimeout(() => {
                        alertBox.remove();
                    }, 500);
                }
            }, 3000);
        </script>
        </c:if>


        <form method="get" action="${pageContext.request.contextPath}/admin/orders">
            <div class="toolbar">

                <!-- SEARCH -->
                <div class="search-box">
                    <input type="text" name="keyword"
                           placeholder="Tìm ID, tên, SĐT..."
                           value="${param.keyword}">
                </div>

                <!-- STATUS -->
                <select name="status" class="status-filter" onchange="this.form.submit()">
                    <option value="">Tất cả trạng thái</option>
                    <option value="Chờ xác nhận" ${param.status=='Chờ xác nhận'?'selected':''}>Chờ xác nhận</option>
                    <option value="Đã xác nhận" ${param.status=='Đã xác nhận'?'selected':''}>Đã xác nhận</option>
                    <option value="Đang giao" ${param.status=='Đang giao'?'selected':''}>Đang giao</option>
                    <option value="Đã giao" ${param.status=='Đã giao'?'selected':''}>Đã giao</option>
                    <option value="Đã huỷ" ${param.status=='Đã huỷ'?'selected':''}>Đã huỷ</option>
                    <option value="Yêu cầu hủy" ${param.status=='Yêu cầu hủy'?'selected':''}>Yêu cầu hủy</option>

                </select>

                <!-- FILTER BUTTON -->
                <div class="filter-wrapper">
                    <button type="button" class="btn-filter" onclick="toggleFilter()">
                        <i class="fa-solid fa-filter"></i> Bộ lọc
                    </button>

                    <div id="filterDropdown" class="filter-dropdown">

                        <h4>Bộ lọc nâng cao</h4>

                        <!-- DATE -->
                        <label>Ngày tạo</label>
                        <div class="range">
                            <input type="date" name="fromDate" value="${param.fromDate}">
                            <span>→</span>
                            <input type="date" name="toDate" value="${param.toDate}">
                        </div>

                        <!-- PRICE -->
                        <label>Khoảng giá</label>
                        <div class="range">
                            <input type="number" name="minPrice" placeholder="Từ" value="${param.minPrice}">
                            <input type="number" name="maxPrice" placeholder="Đến" value="${param.maxPrice}">
                        </div>

                        <div class="filter-actions">
                            <button type="submit" class="btn-primary">Áp dụng</button>
                            <a href="${pageContext.request.contextPath}/admin/orders" class="btn-reset">Reset</a>
                        </div>

                    </div>
                </div>

            </div>
        </form>

        <table class="admin-table">
            <tr>
                <th>ID</th>
                <th>Người nhận</th>
                <th>SĐT</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Ngày tạo</th>
                <th></th>
            </tr>

            <c:forEach items="${orders}" var="o">
                <tr class="${selectedOrder.ID == o.ID ? 'active' : ''}">
                    <td>#${o.ID}</td>
                    <td>${o.receiver_name}</td>
                    <td>${o.receiver_phone}</td>
                    <td><fmt:formatNumber value="${o.price}" type="number" groupingUsed="true"/>đ</td>
                    <td>
                        <c:choose>
                            <c:when test="${o.status == 'Yêu cầu hủy'}">
                              <span class="status cancel-request">
                                     <i class="fa-solid fa-triangle-exclamation"></i> ${o.status}
                              </span>
                            </c:when>

                            <c:otherwise>
                                <span class="status ${o.status}">
                                    ${o.status}
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>${o.createAt}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/orders?id=${o.ID}">
                            Xem
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>

    <!-- ================= CHI TIẾT ĐƠN ================= -->
    <div class="order-detail">

        <c:if test="${not empty selectedOrder}">
            <h3><i class="fa-solid fa-receipt"></i> Đơn hàng #${selectedOrder.ID}</h3>

            <p><b>Người nhận:</b> ${selectedOrder.receiver_name}</p>
            <p><b>SĐT:</b> ${selectedOrder.receiver_phone}</p>
            <p><b>Email:</b> ${selectedOrder.receiver_email}</p>
            <p><b>Địa chỉ:</b> ${selectedOrder.receiver_address}</p>

            <p><b>Phương thức thanh toán:</b>
                <c:choose>
                    <c:when test="${selectedOrder.payment_method == 'VNPAY'}">
                        VNPay
                    </c:when>
                    <c:otherwise>COD</c:otherwise>
                </c:choose>
            </p>

            <p><b>Trạng thái thanh toán:</b>
                <c:choose>
                    <c:when test="${selectedOrder.payment_status == 'PAID'}">
                     Đã thanh toán
                    </c:when>

                    <c:otherwise>Chưa thanh toán</c:otherwise>
                </c:choose>
            </p>

            <!-- UPDATE STATUS -->
            <form action="${pageContext.request.contextPath}/admin/order-update" method="post">
                <input type="hidden" name="id" value="${selectedOrder.ID}">

                <select name="status">
                    <option value="Chờ xác nhận" ${selectedOrder.status=='Chờ xác nhận'?'selected':''}>Chờ xác nhận</option>
                    <option value="Đã xác nhận" ${selectedOrder.status=='Đã xác nhận'?'selected':''}>Đã xác nhận</option>
                    <option value="Đang giao" ${selectedOrder.status=='Đang giao'?'selected':''}>Đang giao</option>
                    <option value="Đã giao" ${selectedOrder.status=='Đã giao'?'selected':''}>Đã giao</option>
                    <option value="Đã huỷ" ${selectedOrder.status=='Đã huỷ'?'selected':''}>Đã huỷ</option>
                </select>

                <button type="submit">Cập nhật</button>
            </form>

            <%--Nút duyệt hủy--%>
            <c:if test="${selectedOrder.status == 'Yêu cầu hủy'}">
                <form action="${pageContext.request.contextPath}/admin/approve-cancel-order"
                      method="post"
                      style="margin-top:10px">

                    <input type="hidden"
                            name="orderId"
                            value="${selectedOrder.ID}">

                    <button type="submit"
                            style="background: red">
                        Duyệt hủy đơn
                    </button>
                </form>
            </c:if>

            <hr>

            <table class="admin-table small">
                <tr>
                    <th>Sản phẩm</th>
                    <th>Giá</th>
                    <th>SL</th>
                </tr>

                <c:forEach items="${orderItems}" var="i">
                    <tr>
                        <td>${i.product_name}</td>
                        <td><fmt:formatNumber value="${i.product_price}" type="number" groupingUsed="true"/>đ</td>
                        <td>${i.quantity}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>

        <c:if test="${empty selectedOrder}">
            <p><i class="fa-regular fa-hand-point-left"></i>
                Chọn đơn hàng để xem chi tiết</p>
        </c:if>

    </div>

</div>

<script>
    function toggleFilter() {
        document.getElementById("filterDropdown").classList.toggle("active");
    }

    document.addEventListener("click", function(e) {
        const dropdown = document.getElementById("filterDropdown");
        const button = document.querySelector(".btn-filter");

        if (!dropdown.contains(e.target) && !button.contains(e.target)) {
            dropdown.classList.remove("active");
        }
    });
</script>
</body>
</html>
