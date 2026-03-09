<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa sản phẩm</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/AdminPage/addProduct.css">
</head>
<body>

<div class="container">
    <h1>SỬA SẢN PHẨM</h1>

    <form method="post"
          action="${pageContext.request.contextPath}/admin/products/edit">

        <input type="hidden" name="id" value="${product.ID}">


        <div class="form-group">
            <label>Tên sản phẩm</label>
            <input type="text" name="name" value="${product.name}" required>
        </div>

        <div class="form-group">
            <label>Giá</label>
            <input type="number" name="price" value="${product.priceValue}" required>
        </div>

        <div class="form-group">
            <label>Giá cũ</label>
            <input type="number" name="priceOld" value="${product.priceOldValue}">
        </div>

        <div class="form-group">
            <label>Ảnh (URL)</label>
            <input type="text" name="image" value="${product.image}">
        </div>


        <div class="form-group">
            <label>Category ID</label>
            <input type="number" name="categories_id"
                   value="${product.categories_id}" required>
        </div>

        <div class="form-group">
            <label>Brand ID</label>
            <input type="number" name="brand_id"
                   value="${product.brand_id}" required>
        </div>


        <div class="form-group">
            <label>Mô tả ngắn</label>
            <textarea name="short_description">${product.short_description}</textarea>
        </div>

        <div class="form-group">
            <label>Mô tả chi tiết</label>
            <textarea name="full_description">${product.full_description}</textarea>
        </div>

        <div class="form-group">
            <label>Thông tin</label>
            <textarea name="information">${product.information}</textarea>
        </div>


        <div class="form-group">
            <label>Năng lượng</label>
            <input type="number" name="energy" value="${product.energy}">
        </div>

        <div class="form-group">
            <label>Thời gian sử dụng</label>
            <input type="number" name="useTime" value="${product.useTime}">
        </div>

        <div class="form-group">
            <label>Khối lượng</label>
            <input type="number" name="weight" value="${product.weight}">
        </div>


        <div class="form-group">
            <label>Meta title</label>
            <input type="text" name="metatitle" value="${product.metatitle}">
        </div>

        <div class="form-group">
            <label>Hỗ trợ</label>
            <input type="text" name="suports" value="${product.suports}">
        </div>

        <div class="form-group">
            <label>Kết nối</label>
            <input type="text" name="connect" value="${product.connect}">
        </div>

        <div class="form-group">
            <label>Ưu đãi</label>
            <input type="text" name="endow" value="${product.endow}">
        </div>


        <div class="form-group checkbox-group">
            <label>
                <input type="checkbox" name="active"
                ${product.active ? "checked" : ""}>
                Active
            </label>

            <label>
                <input type="checkbox" name="ispremium"
                ${product.ispremium ? "checked" : ""}>
                Premium
            </label>
        </div>


        <div class="actions">
            <button type="submit">💾 Cập nhật</button>
            <a href="${pageContext.request.contextPath}/admin/products"
               class="back-link">← Quay lại</a>
        </div>

    </form>
</div>

</body>
</html>

