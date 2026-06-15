<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa Voucher</title>

    <style>

        body{
            background:#f5f6fa;
            font-family:Arial,sans-serif;
        }

        .admin-wrapper{
            display:flex;
            min-height:100vh;
        }

        .container{
            flex:1;
            padding:20px;
        }

        .card{
            background:white;
            padding:25px;
            border-radius:10px;
            margin-top:10px;
            max-width:900px;
            box-shadow:0 2px 8px rgba(0,0,0,0.08);
        }

        h2{
            margin-bottom:25px;
        }

        .form-group{
            margin-bottom:18px;
        }

        label{
            display:block;
            margin-bottom:6px;
            font-weight:600;
        }

        input,
        select{
            width:100%;
            padding:10px 12px;
            border:1px solid #ccc;
            border-radius:6px;
            box-sizing:border-box;
        }

        .row{
            display:flex;
            gap:15px;
        }

        .row .form-group{
            flex:1;
        }

        .btn-save{
            background:#28a745;
            color:white;
            border:none;
            padding:10px 18px;
            border-radius:6px;
            cursor:pointer;
        }

        .btn-back{
            background:#6c757d;
            color:white;
            text-decoration:none;
            padding:10px 18px;
            border-radius:6px;
            margin-left:10px;
        }

    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>

<div class="admin-wrapper">

    <jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>

    <div class="container">

        <div class="card">

            <h2>Sửa Voucher</h2>

            <%--Thông báo validate--%>
            <c:if test="${not empty error}">
                <script>
                    Swal.fire({
                        icon: 'error',
                        title: 'Lỗi',
                        text: '${error}',
                        confirmButtonColor: '#dc3545'
                    });
                </script>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/vouchers/edit"
                  method="post">

                <input type="hidden"
                       name="id"
                       value="${voucher.ID}">

                <div class="form-group">
                    <label>Mã Voucher</label>
                    <input type="text"
                           name="code"
                           value="${voucher.code}"
                           required>
                </div>

                <div class="form-group">
                    <label>Tên Voucher</label>
                    <input type="text"
                           name="name"
                           value="${voucher.name}"
                           required>
                </div>

                <div class="row">

                    <div class="form-group">

                        <label>Loại giảm giá</label>

                        <select name="discountType"
                                id="discountType">

                            <option value="PERCENT"
                            ${voucher.discount_type == 'PERCENT' ? 'selected' : ''}>
                                Phần trăm (%)
                            </option>

                            <option value="FIXED"
                            ${voucher.discount_type == 'FIXED' ? 'selected' : ''}>
                                Tiền cố định (VNĐ)
                            </option>

                        </select>

                    </div>

                    <div class="form-group">

                        <label id="discountLabel">
                            Giá trị giảm
                        </label>

                        <input type="number"
                               id="discountValue"
                               name="discountValue"
                               value="${voucher.discount_value}"
                               required>

                    </div>

                </div>

                <div class="row">

                    <div class="form-group"
                         id="maxDiscountGroup">

                        <label>
                            Giảm tối đa (VNĐ)
                        </label>

                        <input type="number"
                               id="maxDiscount"
                               name="maxDiscount"
                               value="${voucher.max_discount}">

                    </div>

                    <div class="form-group">

                        <label>
                            Đơn tối thiểu (VNĐ)
                        </label>

                        <input type="number"
                               name="minOrder"
                               value="${voucher.min_order_amount}"
                               required>

                    </div>

                </div>

                <div class="row">

                    <div class="form-group">

                        <label>Số lượng</label>

                        <input type="number"
                               name="quantity"
                               value="${voucher.quantity}"
                               required>

                    </div>

                    <div class="form-group">

                        <label>Trạng thái</label>

                        <select name="active">

                            <option value="true"
                            ${voucher.active ? 'selected' : ''}>
                                Hoạt động
                            </option>

                            <option value="false"
                            ${!voucher.active ? 'selected' : ''}>
                                Khóa
                            </option>

                        </select>

                    </div>

                </div>

                <div class="row">

                    <div class="form-group">

                        <label>Ngày bắt đầu</label>

                        <fmt:formatDate value="${voucher.start_date}"
                                        pattern="yyyy-MM-dd'T'HH:mm"
                                        var="startDateFormatted"/>

                        <input type="datetime-local"
                               name="startDate"
                               value="${startDateFormatted}"
                               required>

                    </div>

                    <div class="form-group">

                        <label>Ngày kết thúc</label>

                        <fmt:formatDate value="${voucher.end_date}"
                                        pattern="yyyy-MM-dd'T'HH:mm"
                                        var="endDateFormatted"/>

                        <input type="datetime-local"
                               name="endDate"
                               value="${endDateFormatted}"
                               required>

                    </div>

                </div>

                <br>

                <button type="submit"
                        class="btn-save">
                    Cập nhật Voucher
                </button>

                <a href="${pageContext.request.contextPath}/admin/vouchers"
                   class="btn-back">
                    Quay lại
                </a>

            </form>

        </div>

    </div>

</div>

<script>
    const discountType = document.getElementById("discountType");
    const discountLabel = document.getElementById("discountLabel");
    const maxDiscountGroup = document.getElementById("maxDiscountGroup");

    function toggleFields(){

        if(discountType.value === "FIXED"){
            discountLabel.innerText = "Giá trị giảm (VNĐ)";
            maxDiscountGroup.style.display = "none";

        }else{
            discountLabel.innerText = "Giá trị giảm (%)";
            maxDiscountGroup.style.display = "block";
        }
    }
    discountType.addEventListener("change", toggleFields);
    toggleFields();

</script>
</body>
</html>