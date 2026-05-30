<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng thành công</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            display: flex;
            justify-content: center;
            align-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .success-card {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        .success-icon {
            font-size: 70px;
            color: #2ecc71;
            margin-bottom: 20px;
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 28px;
        }
        p {
            color: #7f8c8d;
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .order-id {
            font-weight: bold;
            color: #e74c3c;
            background: #fdeaea;
            padding: 5px 10px;
            border-radius: 4px;
        }
        .btn-home {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 25px;
            font-weight: bold;
            transition: background 0.3s;
        }
        .btn-home:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

<div class="success-card">
    <div class="success-icon">
        <i class="fas fa-check-circle"></i>
    </div>
    <h1>ĐẶT HÀNG THÀNH CÔNG!</h1>
    <p>
        Cảm ơn bạn đã tin tưởng lựa chọn sản phẩm của chúng tôi.<br>
        Mã đơn hàng của bạn là: <span class="order-id">#${orderId}</span><br>
        Nhân viên cửa hàng sẽ liên hệ xác nhận với bạn trong thời gian sớm nhất.
    </p>
    <a href="${pageContext.request.contextPath}/home" class="btn-home">
        <i class="fas fa-home"></i> Quay về trang chủ
    </a>
</div>

</body>
</html>