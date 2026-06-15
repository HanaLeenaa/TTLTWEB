<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>

    <meta charset="UTF-8">
    <title>Quản lý Voucher</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>

        body{
            background:#f5f6fa;
            font-family:Arial;
        }

        .admin-wrapper{
            display:flex;
            min-height:100vh;
        }

        .container{
            flex: 1;
            padding: 20px;
            overflow-x: auto;
        }

        .card{
            background:white;
            padding:20px;
            border-radius:10px;
            margin-top:10px;
            overflow-x: auto;
        }

        table{
            width:100%;
            border-collapse:collapse;
        }

        th{
            background: #f1f3f9;
            color: #555;
        }

        th,td{
            padding:12px;
            border:1px solid #ddd;
            text-align:center;
        }

        .active{
            color:green;
            font-weight:bold;
        }

        .inactive{
            color:red;
            font-weight:bold;
        }

        .btn-add{
            background:#28a745;
            color:white;
            padding:10px 15px;
            text-decoration:none;
            border-radius:5px;
        }

        .action-cell{
            display:flex;
            justify-content:center;
            align-items:center;
            gap:12px;
        }

        .btn-edit{
            color:#1e88e5;
            text-decoration:none;
        }

        .btn-edit:hover{
            color:#0d47a1;
        }

        .btn-disable{
            color:#e53935;
            text-decoration:none;
        }

        .btn-disable:hover{
            color:#b71c1c;
        }

        .btn-enable{
            color:#43a047;
            text-decoration:none;
        }

        .btn-enable:hover{
            color:#1b5e20;
        }

        .money {
            white-space: nowrap;
        }
        .date-cell{
            white-space: nowrap;
            min-width: 110px;
        }
        .page-header{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:24px;
        }
        .page-header h2{
            margin:0;
        }
        .search-input{
            width: 300px;
            height:40px;
            border:1px solid #ddd;
            border-radius:10px;
            padding:0 20px;
            font-size:16px;
        }
        .filter-btn{
            height:40px;
            padding:0 28px;
            border:1px solid #ddd;
            border-radius:10px;
            background:#fff;
            cursor:pointer;

            display:flex;
            align-items:center;
            gap:10px;
        }
        .voucher-toolbar{
            display:flex;
            justify-content:space-between;
            align-items:flex-start;
            margin-bottom:20px;
        }
        .search-form{
            flex:1;
        }
        .filter-wrapper{
            margin-left:20px;
            position: relative;
        }
        .filter-panel{
            display:none;
            position:absolute;
            top:55px;
            right:0;

            width:340px;
            background:#fff;
            border-radius:20px;
            padding:20px;

            box-shadow:0 8px 25px rgba(0,0,0,0.12);
            z-index:1000;
        }
        .filter-panel.show{
            display:block;
        }
        .filter-title{
            font-size:16px;
            font-weight:700;
            color:#333;
            margin-bottom:18px;
        }
        .filter-group{
            margin-bottom:15px;
        }
        .filter-group label{
            display:block;
            font-size:14px;
            font-weight:600;
            color:#555;
            margin-bottom:6px;
        }
        .filter-group select,
        .filter-group input{
            width:100%;
            height:40px;
            border:1px solid #ddd;
            border-radius:10px;
            padding:0 12px;
            font-size:14px;
            background:#fff;
            box-sizing:border-box;
        }
        .date-range{
            display:flex;
            align-items:center;
            gap:12px;
        }
        .date-range input{
            flex:1;
        }
        .date-arrow{
            font-size:16px;
            color:#666;
        }
        .filter-footer{
            margin-top:18px;
            padding-top:15px;
            border-top:1px solid #eee;

            display:flex;
            justify-content:space-between;
            align-items:center;
        }
        .apply-filter-btn{
            background:#4e7cf0;
            color:white;
            border:none;
            border-radius:10px;
            height:40px;
            padding:0 22px;
            font-size:14px;
            cursor:pointer;
        }
        .reset-filter{
            color:#888;
            text-decoration:none;
            font-size:14px;
        }

    </style>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<div class="admin-wrapper">
<!-- SIDEBAR -->
<jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>

<div class="container">

    <div class="card">

        <div class="page-header">
        <h2>Quản lý Voucher</h2>

            <a class="btn-add"
               href="${pageContext.request.contextPath}/admin/vouchers/add">
                + Thêm Voucher
            </a>
        </div>

<div class="voucher-toolbar">

    <form action="${pageContext.request.contextPath}/admin/vouchers"
          method="get"
          class="search-form">

        <input type="text"
               name="keyword"
               placeholder="Tìm voucher theo tên hoặc mã..."
               value="${param.keyword}"
               class="search-input">

        <input type="hidden" name="status" value="${param.status}">
        <input type="hidden" name="type" value="${param.type}">
        <input type="hidden" name="fromDate" value="${param.fromDate}">
        <input type="hidden" name="toDate" value="${param.toDate}">

    </form>

    <div class="filter-wrapper">
        <button type="button"
                class="filter-btn"
                id="filterBtn">
            <i class="fa-solid fa-filter"></i>
            Bộ lọc
        </button>

        <div id="filterPanel" class="filter-panel">

            <form action="${pageContext.request.contextPath}/admin/vouchers" method="get">

                <input type="hidden"
                       name="keyword"
                       value="${param.keyword}">

                <div class="filter-title">
                    Bộ lọc
                </div>

                <div class="filter-group">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value=""
                        ${empty param.status ? 'selected' : ''}>
                            Tất cả
                        </option>

                        <option value="true"
                        ${param.status == 'true' ? 'selected' : ''}>
                            Hoạt động
                        </option>

                        <option value="false"
                        ${param.status == 'false' ? 'selected' : ''}>
                            Đã khóa
                        </option>
                    </select>
                </div>

                <div class="filter-group">
                    <label>Loại voucher</label>
                    <select name="type">
                        <option value=""
                        ${empty param.type ? 'selected' : ''}>
                            Tất cả
                        </option>

                        <option value="PERCENT"
                        ${param.type == 'PERCENT' ? 'selected' : ''}>
                            Phần trăm
                        </option>

                        <option value="FIXED"
                        ${param.type == 'FIXED' ? 'selected' : ''}>
                            Tiền mặt
                        </option>
                    </select>
                </div>

                <div class="filter-group">
                    <label>Khoảng ngày</label>

                    <div class="date-range">

                        <input type="date" name="fromDate" value="${param.fromDate}">

                        <span class="date-arrow"><i class="fa-solid fa-arrow-right-long"></i></span>

                        <input type="date" name="toDate" value="${param.toDate}">

                    </div>
                </div>

                <div class="filter-footer">

                    <button type="submit" class="apply-filter-btn">
                        Áp dụng
                    </button>

                    <a href="${pageContext.request.contextPath}/admin/vouchers"
                       class="reset-filter">
                        Reset
                    </a>

                </div>

            </form>

        </div>
    </div>


</div>

    <table>

            <tr>
                <th>ID</th>
                <th>Mã</th>
                <th>Tên</th>
                <th>Loại</th>
                <th>Giảm</th>
                <th>Giảm tối đa</th>
                <th>Đơn tối thiểu</th>
                <th>Số lượng</th>
                <th>Ngày bắt đầu</th>
                <th>Ngày kết thúc</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>

            <c:forEach items="${vouchers}" var="v">

                <tr>

                    <td>${v.ID}</td>

                    <td>${v.code}</td>

                    <td>${v.name}</td>

                    <td>${v.discount_type}</td>

                    <td class="money">
                        <c:choose>
                            <c:when test="${v.discount_type == 'PERCENT'}">
                                <fmt:formatNumber value="${v.discount_value}"
                                                    type="number"
                                                    minFractionDigits="0"/> %
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="${v.discount_value}" type="number" groupingUsed="true"/> đ
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td class="money">
                        <c:choose>
                            <c:when test="${v.discount_type == 'PERCENT'}">
                                <fmt:formatNumber value="${v.max_discount}"
                                                type="number"
                                                groupingUsed="true" /> đ
                            </c:when>
                            <c:otherwise>
                                -
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td class="money">
                            <fmt:formatNumber value="${v.min_order_amount}"
                                                type="number"
                                                groupingUsed="true" /> đ</td>

                    <td>${v.quantity}</td>

                    <td class="date-cell">
                        <fmt:formatDate value="${v.start_date}" pattern="dd-MM-yyyy"/>
                        <br>
                        <fmt:formatDate value="${v.start_date}" pattern="HH:mm:ss"/>
                    </td>

                    <td class="date-cell">
                        <fmt:formatDate value="${v.end_date}" pattern="dd-MM-yyyy"/>
                        <br>
                        <fmt:formatDate value="${v.end_date}" pattern="HH:mm:ss"/>
                    </td>

                    <td>

                        <c:choose>

                            <c:when test="${v.active}">
                                <span class="active">
                                    Hoạt động
                                </span>
                            </c:when>

                            <c:otherwise>
                                <span class="inactive">
                                    Đã khóa
                                </span>
                            </c:otherwise>

                        </c:choose>

                    </td>

                    <td>
                        <div class="action-cell">

                            <a class="btn-edit"
                               href="${pageContext.request.contextPath}/admin/vouchers/edit?id=${v.ID}">
                                <i class="fa-regular fa-pen-to-square"></i> Sửa
                            </a>

                            <a href="#"
                                    class="toggleVoucherBtn ${v.active ? 'btn-disable' : 'btn-enable'}"
                                    data-url="${pageContext.request.contextPath}/admin/vouchers/toggle?id=${v.ID}"
                                    data-action="${v.active ? 'Khóa' : 'Mở'}">

                                <i class="fa-solid ${v.active ? 'fa-lock' : 'fa-lock-open'}"></i>
                                    ${v.active ? 'Khóa' : 'Mở'}

                            </a>

                        </div>
                </td>

                </tr>

            </c:forEach>

        </table>

    </div>

</div>
</div>
<%--thông báo khóa/mở voucher--%>
<script>

    document.querySelectorAll(".toggleVoucherBtn").forEach(btn => {

        btn.addEventListener("click", function(e){

            e.preventDefault();

            const url = this.dataset.url;
            const action = this.dataset.action;

            Swal.fire({
                title: 'Xác nhận',
                text: 'Bạn có chắc muốn ' + action + ' voucher này?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#e95211',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Đồng ý',
                cancelButtonText: 'Hủy'
            }).then((result) => {

                if (result.isConfirmed) {
                    window.location.href = url;
                }

            });

        });

    });

</script>

<c:if test="${param.success == 'toggle'}">
    <script>
        Swal.fire({
            icon: 'success',
            title: 'Thành công',
            text: 'Cập nhật trạng thái voucher thành công!',
            confirmButtonColor: '#e95211'
        });
    </script>
</c:if>

<%--thông báo thêm voucher thành công--%>
<c:if test="${not empty param.success && param.success == 'add'}">
    <script>
        Swal.fire({
            icon: 'success',
            title: 'Thành công!',
            text: 'Thêm voucher thành công!',
            confirmButtonColor: '#3085d6'
        });
    </script>
</c:if>

<c:if test="${not empty param.error && param.error == 'add'}">
    <script>
        Swal.fire({
            icon: 'error',
            title: 'Thất bại!',
            text: 'Thêm voucher không thành công!',
            confirmButtonColor: '#d33'
        });
    </script>
</c:if>

<%--Popup thông báo cập nhật--%>
<c:if test="${param.success == 'updated'}">
    <script>
        Swal.fire({
            icon: 'success',
            title: 'Thành công',
            text: 'Cập nhật voucher thành công!',
            confirmButtonColor: '#28a745'
        });
    </script>
</c:if>

<c:if test="${param.error == 'updateFail'}">
    <script>
        Swal.fire({
            icon: 'error',
            title: 'Thất bại',
            text: 'Không thể cập nhật voucher!',
            confirmButtonColor: '#dc3545'
        });
    </script>
</c:if>

<%--Lọc voucher--%>
<script>
    const filterBtn = document.getElementById("filterBtn");
    const filterPanel = document.getElementById("filterPanel");

    filterBtn.addEventListener("click", function () {
        filterPanel.classList.toggle("show");
    });

    document.addEventListener("click", function(e){

        if(
            !filterBtn.contains(e.target)
            && !filterPanel.contains(e.target)
        ){
            filterPanel.classList.remove("show");
        }

    });

</script>
</body>
</html>