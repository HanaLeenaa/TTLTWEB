<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Voucher</title>

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
            color:#333;
        }

        .form-group{
            margin-bottom:18px;
        }

        label{
            display:block;
            margin-bottom:6px;
            font-weight:600;
            color:#333;
        }

        input,
        select{
            width:100%;
            padding:10px 12px;
            border:1px solid #ccc;
            border-radius:6px;
            box-sizing:border-box;
            font-size:14px;
        }

        input:focus,
        select:focus{
            outline:none;
            border-color:#e95211;
        }

        .row{
            display:flex;
            gap:15px;
        }

        .row .form-group{
            flex:1;
        }

        .btn-group{
            margin-top:25px;
        }

        .btn-save{
            background:#28a745;
            color:white;
            border:none;
            padding:10px 18px;
            border-radius:6px;
            cursor:pointer;
        }

        .btn-save:hover{
            background:#218838;
        }

        .btn-back{
            background:#6c757d;
            color:white;
            text-decoration:none;
            padding:10px 18px;
            border-radius:6px;
            margin-left:10px;
        }

        .btn-back:hover{
            background:#545b62;
        }

    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>

<body>

<div class="admin-wrapper">

    <jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>

    <div class="container">

        <div class="card">

            <h2>Thêm Voucher</h2>

            <form action="${pageContext.request.contextPath}/admin/vouchers/add"
                  method="post">

                <div class="form-group">
                    <label>Mã Voucher</label>
                    <input type="text"
                           name="code"
                           value="${voucher.code}"
                           placeholder="Ví dụ: SALE10, GIAM50K..."
                           required>
                </div>

                <div class="form-group">
                    <label>Tên Voucher</label>
                    <input type="text"
                           name="name"
                           value="${voucher.name}"
                           placeholder="Ví dụ: Giảm 10% cho đơn từ 500.000đ"
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
                            Giá trị giảm (%)
                        </label>

                        <input type="number"
                               id="discountValue"
                               name="discountValue"
                               value="${voucher.discount_value}"
                               min="1"
                               placeholder="Ví dụ: 10"
                               required>

                    </div>

                </div>

                <div class="row">

                    <div class="form-group" id="maxDiscountGroup">

                        <label>
                            Giảm tối đa (VNĐ)
                        </label>

                        <input type="number"
                               id="maxDiscount"
                               name="maxDiscount"
                               value="${voucher.max_discount}"
                               min="1"
                               placeholder="Ví dụ: 50000">

                    </div>

                    <div class="form-group">

                        <label>
                            Đơn tối thiểu (VNĐ)
                        </label>

                        <input type="number"
                               name="minOrder"
                               value="${voucher.min_order_amount}"
                               min="0"
                               placeholder="Ví dụ: 500000"
                               required>

                    </div>

                </div>

                <div class="row">

                    <div class="form-group">

                        <label>
                            Số lượng
                        </label>

                        <input type="number"
                               name="quantity"
                               value="${voucher.quantity}"
                               min="1"
                               placeholder="Ví dụ: 100"
                               required>

                    </div>

                    <div class="form-group">

                        <label>
                            Trạng thái
                        </label>

                        <select name="active">

                            <option value="true" ${voucher.active ? 'selected' : ''}>
                                Hoạt động
                            </option>

                            <option value="false" ${!voucher.active ? 'selected' : ''}>
                                Khóa
                            </option>

                        </select>

                    </div>

                </div>

                <div class="row">

                    <div class="form-group">

                        <label>
                            Ngày bắt đầu
                        </label>

                        <fmt:formatDate value="${voucher.start_date}"
                                        pattern="yyyy-MM-dd'T'HH:mm"
                                        var="startDateFormatted"/>

                        <input type="datetime-local"
                               name="startDate"
                               value="${startDateFormatted}"
                               required>

                    </div>

                    <div class="form-group">

                        <label>
                            Ngày kết thúc
                        </label>

                        <fmt:formatDate value="${voucher.end_date}"
                                        pattern="yyyy-MM-dd'T'HH:mm"
                                        var="endDateFormatted"/>

                        <input type="datetime-local"
                               name="endDate"
                               value="${endDateFormatted}"
                               required>

                    </div>

                </div>

                <div class="btn-group">

                    <button type="submit"
                            class="btn-save">
                        Lưu Voucher
                    </button>

                    <a href="${pageContext.request.contextPath}/admin/vouchers"
                       class="btn-back">
                        Quay lại
                    </a>

                </div>

            </form>

        </div>

    </div>


</div>

<script>

    const discountType = document.getElementById("discountType");
    const discountValue = document.getElementById("discountValue");
    const discountLabel = document.getElementById("discountLabel");
    const maxDiscount = document.getElementById("maxDiscount");
    const maxDiscountGroup = document.getElementById("maxDiscountGroup");

    function toggleFields(){

        if(discountType.value === "FIXED"){

            discountLabel.innerText = "Giá trị giảm (VNĐ)";
            discountValue.placeholder = "Ví dụ: 50000";

            maxDiscountGroup.style.display = "none";
            maxDiscount.removeAttribute("required");

        }else{

            discountLabel.innerText = "Giá trị giảm (%)";
            discountValue.placeholder = "Ví dụ: 10";

            maxDiscountGroup.style.display = "block";
            maxDiscount.setAttribute("required", "required");
        }
    }

    discountType.addEventListener(
        "change",
        toggleFields
    );

    toggleFields();

</script>

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

</body>
</html>
