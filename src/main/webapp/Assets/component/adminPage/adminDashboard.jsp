<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>

    <style>
        body {
            margin: 0;
            font-family: "Poppins", Arial, sans-serif;
            background: #f4f6fb;
        }

        .admin-wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* CONTENT */
        .content {
            flex: 1;
            padding: 25px;
        }

        .header {
            background: white;
            padding: 20px 25px;
            border-radius: 14px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            margin-bottom: 25px;
        }

        .header h1 {
            margin: 0;
            font-size: 26px;
        }

        .header p {
            margin-top: 6px;
            color: #666;
        }

        /* STATS */
        .stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }

        .stat-card h3 {
            margin: 0;
            font-size: 14px;
            color: #777;
        }

        .stat-card p {
            margin: 6px 0 0;
            font-size: 26px;
            font-weight: 600;
        }

        .icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: white;
        }

        .bg-blue { background: #4b7bec; }
        .bg-green { background: #20bf6b; }
        .bg-orange { background: #fa8231; }
        .bg-red { background: #eb3b5a; }

        /* GRID */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }

        .box {
            background: white;
            padding: 20px;
            border-radius: 14px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }

        .box h3 {
            margin-top: 0;
            margin-bottom: 15px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        table th {
            text-align: left;
            padding: 10px;
            background: #f1f3f9;
        }

        table td {
            padding: 10px;
            border-bottom: 1px solid #eee;
        }

        .status {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
        }

        .pending { background: #fff3cd; }
        .completed { background: #d4edda; }
        .shipping { background: #cce5ff; }

        .quick-actions a {
            display: block;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 8px;
            background: #f4f6fb;
            text-decoration: none;
            color: #333;
            transition: 0.3s;
        }

        .quick-actions a:hover {
            background: #4b7bec;
            color: white;
        }

        .statistics-header{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin:30px 0;
        }

        .statistics-header form{
            display:flex;
            gap:10px;
        }

        .statistics-header select,
        .statistics-header button{
            padding:10px 14px;
            border-radius:8px;
            border:1px solid #ddd;
        }

        .statistics-header button{
            background:#ff5b1d;
            color:white;
            border:none;
            cursor:pointer;
        }

        .statistics-table{
            width:100%;
            border-collapse:collapse;
            background:white;
            border-radius:12px;
            overflow:hidden;
        }

        .statistics-table th{
            background:#f3f4f6;
        }

        .statistics-table th,
        .statistics-table td{
            padding:14px;
            border-bottom:1px solid #eee;
            text-align:center;
        }

        .chart-box{
            background:white;
            padding:20px;
            border-radius:14px;
            margin-top:30px;
        }

        #revenueChart{
            height:400px !important;
        }

        .statistics-title i{
            color:#4b7bec;
            background:#eaf1ff;
            padding:12px;
            border-radius:12px;
            margin-right:10px;
            font-size:20px;
        }

        .statistics-table td:last-child,
        .statistics-table th:last-child{
            text-align:center;
            font-weight:600;
        }
        .statistics-table{
            table-layout: fixed;
        }

        .box h3 i.fa-fire{
            color:#ff6b35;
            background:#fff1eb;
            padding:10px;
            border-radius:10px;
            margin-right:10px;
            font-size:18px;
        }
        .top-product-box{
            margin-top:30px;
            margin-bottom:30px;
        }

        .extra-dashboard{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:20px;
            margin-top:30px;
        }
    </style>
</head>

<body>

<div class="admin-wrapper">

    <!-- SIDEBAR (GIỮ NGUYÊN) -->
    <jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>

    <!-- CONTENT -->
    <div class="content">

        <!-- HEADER -->
        <div class="header">
            <h1>Xin chào ${sessionScope.admin.username} 👋</h1>
            <p>Chào mừng bạn quay lại trang quản trị</p>
        </div>

        <!-- STATS -->
        <div class="stats">
            <div class="stat-card">
                <div>
                    <h3>Sản phẩm</h3>
                    <p>${totalProducts}</p>
                </div>
                <div class="icon bg-blue">📦</div>
            </div>

            <div class="stat-card">
                <div>
                    <h3>Đơn hàng</h3>
                    <p>${totalOrders}</p>
                </div>
                <div class="icon bg-green">🧾</div>
            </div>

            <div class="stat-card">
                <div>
                    <h3>Người dùng</h3>
                    <p>${totalUsers}</p>
                </div>
                <div class="icon bg-orange">👤</div>
            </div>

            <div class="stat-card">
                <div>
                    <h3>Doanh thu</h3>
                    <p><fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/>đ</p>
                </div>
                <div class="icon bg-red">💰</div>
            </div>
        </div>

            <%--THỐNG KÊ DOANH THU THEO THÁNG/QUÝ/NĂM--%>
        <div class="statistics-header">

            <h2 class="statistics-title"><i class="fa-solid fa-chart-line"></i>
                Thống kê doanh thu</h2>

            <form method="get"
                  action="${pageContext.request.contextPath}/admin/dashboard">

                <select name="type">

                    <option value="month"
                    ${type=='month'?'selected':''}>
                        Theo tháng
                    </option>

                    <option value="quarter"
                    ${type=='quarter'?'selected':''}>
                        Theo quý
                    </option>

                    <option value="year"
                    ${type=='year'?'selected':''}>
                        Theo năm
                    </option>

                </select>

                <button type="submit">
                    Xem thống kê
                </button>

            </form>

        </div>

                <%--BẢNG THỐNG KÊ--%>
        <table class="statistics-table">
            <thead>
            <tr>
                <th>Thời gian</th>
                <th>Đơn hàng</th>
                <th>Sản phẩm bán</th>
                <th>Doanh thu</th>
            </tr>
            </thead>

            <tbody>

            <c:forEach items="${statistics}" var="s">

                <tr>
                    <td>${s.label}</td>
                    <td>${s.totalOrders}</td>
                    <td>${s.totalProducts}</td>
                    <td>
                        <fmt:formatNumber
                                value="${s.revenue}"
                                type="number"
                                groupingUsed="true"
                                maxFractionDigits="0"
                        />đ
                    </td>
                </tr>

            </c:forEach>

            </tbody>

        </table>

        <div class="chart-box">
            <canvas id="revenueChart"></canvas>
        </div>

        <%--Thống kê top sản phẩm bán chạy theo tháng, quý, năm --%>
        <div class="box top-product-box">

            <h3>
                <i class="fa-solid fa-fire"></i>
                Top sản phẩm bán chạy
            </h3>

            <table class="statistics-table">

                <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Đã bán</th>
                    <th>Doanh thu</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach items="${topProducts}" var="p">

                    <tr>
                        <td>
                                ${p.productName}
                        </td>
                        <td>
                                ${p.totalSold}
                        </td>
                        <td>
                            <fmt:formatNumber
                                    value="${p.revenue}"
                                    type="number"
                                    groupingUsed="true"
                                    maxFractionDigits="0"
                            />đ
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- GRID -->
        <div class="dashboard-grid">

            <!-- RECENT ORDERS -->
            <div class="box">
                <h3>🕒 Đơn hàng gần đây</h3>

                <table>
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Khách</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach var="o" items="${recentOrders}">
                        <tr>
                            <td>#${o.ID}</td>
                            <td>${o.receiver_name}</td>
                            <td>
                    <span class="status
                        ${o.status == 'Chờ xác nhận' ? 'Chờ xác nhận' :
                          o.status == 'Đã xác nhận' ? 'Đã xác nhận' :
                          o.status == 'Đang giao' ? 'Đang giao' :
                          o.status == 'Đã giao' ? 'Đã giao' :
                          o.status == 'Đã huỷ' ? 'Đã huỷ' : ''}">
                            ${o.status}
                    </span>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty recentOrders}">
                        <tr>
                            <td colspan="3" style="text-align:center;color:#999;">
                                Không có đơn hàng nào
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>


            <!-- QUICK ACTION -->
            <div class="box quick-actions">
                <h3>⚡ Thao tác nhanh</h3>
                <a href="${pageContext.request.contextPath}/admin/products">➕ Thêm sản phẩm</a>
                <a href="${pageContext.request.contextPath}/admin/orders">📦 Xem đơn hàng</a>
                <a href="${pageContext.request.contextPath}/admin/users">👤 Quản lý user</a>
                <a href="${pageContext.request.contextPath}/admin-logout">🚪 Đăng xuất</a>
            </div>

        </div>

        <%--THỐNG KÊ ĐƠN HÀNG THEO STATUS--%>
        <div class="extra-dashboard">

            <!-- ORDER STATUS -->
            <div class="box">

                <h3>📦 Trạng thái đơn hàng</h3>

                <table class="statistics-table">

                    <thead>
                    <tr>
                        <th>Trạng thái</th>
                        <th>Số lượng</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:forEach items="${orderStatusStats}" var="entry">

                        <tr>
                            <td>${entry.key}</td>
                            <td>${entry.value}</td>
                        </tr>

                    </c:forEach>
                    </tbody>
                </table>
            </div>

        </div>
</div>

<script>

    const labels = [

        <c:forEach items="${statistics}"
                   var="s">

        '${s.label}',

        </c:forEach>

    ];

    const revenues = [

        <c:forEach items="${statistics}"
                   var="s">

        ${s.revenue},

        </c:forEach>

    ];

    new Chart(
        document.getElementById(
            'revenueChart'
        ),

        {

            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu',
                    data: revenues,
                    borderWidth: 2

                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: true
                    }
                }
            }
        }
    );

</script>

</body>
</html>
