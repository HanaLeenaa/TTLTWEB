<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>

    <meta charset="UTF-8">
    <title>Quản lý Voucher</title>

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
    </style>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<div class="admin-wrapper">
<!-- SIDEBAR -->
<jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>

<div class="container">

    <div class="card">

        <h2>Quản lý Voucher</h2>

        <br>

        <a class="btn-add"
           href="${pageContext.request.contextPath}/admin/vouchers/add">
            + Thêm Voucher
        </a>

        <br><br>

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

</body>
</html>