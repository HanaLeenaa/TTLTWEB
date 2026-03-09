<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm sản phẩm</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/AdminPage/addProduct.css">
</head>
<body>

<div class="container">
    <h1>THÊM SẢN PHẨM</h1>

    <form method="post"
          action="${pageContext.request.contextPath}/admin/products/add">

        <div class="form-group">
            <label>Tên sản phẩm</label>
            <input type="text" name="name" required>
        </div>

        <div class="form-group">
            <label>Giá</label>
            <input type="number" name="price" min="0" required>
        </div>

        <div class="form-group">
            <label>Giá cũ</label>
            <input type="number" name="priceOld" min="0">
        </div>

        <div class="form-group">
            <label>Ảnh (URL)</label>
            <input type="text" name="image">
        </div>


        <div class="form-group">
            <label>Category ID</label>
            <input type="number" name="categories_id" required>
        </div>

        <div class="form-group">
            <label>Brand ID</label>
            <input type="number" name="brand_id" required>
        </div>


        <div class="form-group">
            <label>Mô tả ngắn</label>
            <textarea name="short_description"></textarea>
        </div>

        <div class="form-group">
            <label>Mô tả chi tiết</label>
            <textarea name="full_description"></textarea>
        </div>

        <div class="form-group">
            <label>Thông tin</label>
            <textarea name="information"></textarea>
        </div>


        <div class="form-group">
            <label>Năng lượng</label>
            <input type="number" name="energy">
        </div>

        <div class="form-group">
            <label>Thời gian sử dụng</label>
            <input type="number" name="useTime">
        </div>

        <div class="form-group">
            <label>Khối lượng</label>
            <input type="number" name="weight">
        </div>


        <div class="form-group">
            <label>Meta title</label>
            <input type="text" name="metatitle">
        </div>

        <div class="form-group">
            <label>Hỗ trợ</label>
            <input type="text" name="suports">
        </div>

        <div class="form-group">
            <label>Kết nối</label>
            <input type="text" name="connect">
        </div>

        <div class="form-group">
            <label>Ưu đãi</label>
            <input type="text" name="endow">
        </div>


        <div class="form-group checkbox-group">
            <label>
                <input type="checkbox" name="active"> Active
            </label>

            <label>
                <input type="checkbox" name="ispremium"> Premium
            </label>
        </div>


        <div class="actions">
            <button type="submit">💾 Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/products"
               class="back-link">← Quay lại</a>
        </div>

    </form>
</div>

</body>
</html>
