<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa sản phẩm</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/Assets/css/AdminPage/addProduct.css">
</head>
<body>

<div class="admin-page">
    <div class="page-header">
        <div>
            <p class="breadcrumb">Admin / Quản lý sản phẩm / Sửa sản phẩm</p>
            <h1>Sửa sản phẩm</h1>
        </div>

        <%--Them thong bao thanh cong--%>
        <c:if test="${param.success == '1'}">
            <div class="alert-success">
                <i class="fa-solid fa-circle-check"></i>
                Cập nhật thành công!
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/admin/products" class="btn-back">
             <i class="fa-solid fa-arrow-left"></i> Quay lại
         </a>
    </div>

    <form method="post"
          action="${pageContext.request.contextPath}/admin/products/edit"
          class="product-form"
          enctype="multipart/form-data">

        <input type="hidden" name="id" value="${product.ID}">


        <div class="left-column">

            <div class="card">
                <h3>Thông tin cơ bản</h3>

                <div class="form-group">
                    <label>Tên sản phẩm</label>
                    <input type="text" name="name" id="productName"
                           value="${product.name}" required
                            placeholder="Ví dụ:Xbox Series X 1TB">
                </div>

                <div class="image-block">
                    <h4>Ảnh chính sản phẩm</h4>

                    <div class="form-group">
                        <label>Ảnh chính (URL)</label>
                        <input type="text" name="image" id="imageMainUrl"
                               value="${product.image}"
                               placeholder="Dán link ảnh chính">
                    </div>

                    <div class="form-group">
                        <label>Hoặc tải ảnh chính lên</label>
                        <input type="file" name="imageMainFile" id="imageMainFile" accept="image/*">
                    </div>

                    <div class="image-preview-wrapper main-preview">
                        <c:choose>
                            <c:when test="${not empty product.image && product.image.startsWith('http')}">
                                <img id="mainPreview"
                                src="${product.image}"
                                alt="Ảnh chính preview"
                                style="${not empty product.image ? 'display:block;' : 'display:none;'}">
                            </c:when>
                            <c:when test="${not empty product.image}">
                                <img id="mainPreview"
                                     src="${pageContext.request.contextPath}/${product.image}"
                                     alt="Ảnh chính preview"
                                     style="display:block;">
                            </c:when>
                        </c:choose>
                        <p id="mainPreviewText"
                           style="${not empty product.image ? 'display:none;' : 'display:block;'}">
                            Xem trước ảnh chính
                        </p>
                    </div>
                </div>

                <div class="image-block">
                    <h4>Gallery ảnh phụ</h4>

                    <div class="sub-images-grid">


                        <div class="sub-image-card">
                            <label>Ảnh phụ 1 (URL)</label>
                            <input type="text" name="galleryUrl1" class="subImageUrl"
                                   data-preview="subPreview1"
                                   value="${gallaryList.size() > 0 ? gallaryList[0].img : ''}"
                                   placeholder="Dán link ảnh phụ 1">

                            <label>Tải ảnh phụ 1</label>
                            <input type="file" name="galleryFile1" class="subImageFile"
                                   data-preview="subPreview1" accept="image/*">

                            <div class="sub-preview-box">
                                <c:choose>
                                    <c:when test="${gallaryList.size() > 0 && gallaryList[0].img.startsWith('http')}">
                                        <img id="subPreview1"
                                        src="${gallaryList[0].img}"
                                        alt="Ảnh phụ 1"
                                        style="${gallaryList.size() > 0 ? 'display:block;' : 'display:none;'}">
                                    </c:when>
                                    <c:when test="${gallaryList.size() > 0}">
                                        <img id="subPreview1"
                                             src="${pageContext.request.contextPath}/${gallaryList[0].img}"
                                             alt="Ảnh phụ 1"
                                             style="display:block;">
                                    </c:when>
                                    <c:otherwise>
                                        <img id="subPreview1"
                                             src=""
                                             alt="Ảnh phụ 1"
                                             style="display:none;">
                                    </c:otherwise>
                                </c:choose>
                                <span>Preview 1</span>
                            </div>
                        </div>


                        <div class="sub-image-card">
                            <label>Ảnh phụ 2 (URL)</label>
                            <input type="text" name="galleryUrl2" class="subImageUrl"
                                   data-preview="subPreview2"
                                   value="${gallaryList.size() > 1 ? gallaryList[1].img : ''}"
                                   placeholder="Dán link ảnh phụ 2">

                            <label>Tải ảnh phụ 2</label>
                            <input type="file" name="galleryFile2" class="subImageFile"
                                   data-preview="subPreview2" accept="image/*">

                            <div class="sub-preview-box">
                                <c:choose>
                                    <c:when test="${gallaryList.size() > 1 && gallaryList[1].img.startsWith('http')}">
                                        <img id="subPreview2"
                                        src="${gallaryList[1].img}"
                                        alt="Ảnh phụ 2"
                                        style="${gallaryList.size() > 1 ? 'display:block;' : 'display:none;'}">
                                    </c:when>
                                    <c:when test="${gallaryList.size() > 1}">
                                        <img id="subPreview2"
                                             src="${pageContext.request.contextPath}/${gallaryList[1].img}"
                                             alt="Ảnh phụ 2"
                                             style="display:block;">
                                    </c:when>
                                    <c:otherwise>
                                        <img id="subPreview2"
                                             src=""
                                             alt="Ảnh phụ 2"
                                             style="display:none;">
                                    </c:otherwise>
                                </c:choose>
                                <span>Preview 2</span>
                            </div>
                        </div>


                        <div class="sub-image-card">
                            <label>Ảnh phụ 3 (URL)</label>
                            <input type="text" name="galleryUrl3" class="subImageUrl"
                                   data-preview="subPreview3"
                                   value="${gallaryList.size() > 2 ? gallaryList[2].img : ''}"
                                   placeholder="Dán link ảnh phụ 3">

                            <label>Tải ảnh phụ 3</label>
                            <input type="file" name="galleryFile3" class="subImageFile"
                                   data-preview="subPreview3" accept="image/*">

                            <div class="sub-preview-box">
                                <c:choose>
                                    <c:when test="${gallaryList.size() > 2 && gallaryList[2].img.startsWith('http')}">
                                        <img id="subPreview3"
                                        src="${gallaryList[2].img}"
                                        alt="Ảnh phụ 3"
                                        style="${gallaryList.size() > 2 ? 'display:block;' : 'display:none;'}">
                                    </c:when>
                                    <c:when test="${gallaryList.size() > 2}">
                                        <img id="subPreview3"
                                             src="${pageContext.request.contextPath}/${gallaryList[2].img}"
                                             alt="Ảnh phụ 3"
                                             style="display:block;">
                                    </c:when>
                                    <c:otherwise>
                                        <img id="subPreview3"
                                             src=""
                                             alt="Ảnh phụ 3"
                                             style="display:none;">
                                    </c:otherwise>
                                </c:choose>
                                <span>Preview 3</span>
                            </div>
                        </div>

                    </div>
                </div>
            </div>


                    <div class="card">
                        <h3>Mô tả sản phẩm</h3>

                        <div class="form-group">
                            <label>Mô tả ngắn</label>
                            <textarea name="short_description"
                                      placeholder="Mô tả ngắn hiển thị ngoài trang sản phẩm...">${product.short_description}</textarea>
                        </div>

                        <div class="form-group">
                            <label>Mô tả chi tiết</label>
                            <textarea name="full_description" rows="6"
                                      placeholder="Nhập mô tả chi tiết về sản phẩm...">${product.full_description}</textarea>
                        </div>

                        <div class="form-group">
                            <label>Thông tin bổ sung</label>
                            <textarea name="information" rows="5"
                                      placeholder="Ví dụ: bộ sản phẩm gồm những gì, chính sách bảo hành...">${product.information}</textarea>
                        </div>
                    </div>


                    <div class="card">
                        <h3>Thông số kỹ thuật</h3>

                        <div class="spec-grid">
                            <div class="form-group">
                                <label>Năng lượng</label>
                                <input type="number" name="energy" value="${product.energy}" placeholder="Ví dụ: 5000">
                            </div>

                            <div class="form-group">
                                <label>Thời gian sử dụng</label>
                                <input type="number" name="useTime" value="${product.useTime}" placeholder="Ví dụ: 8">
                            </div>

                            <div class="form-group">
                                <label>Khối lượng</label>
                                <input type="number" name="weight" value="${product.weight}" placeholder="Ví dụ: 650">
                            </div>

                            <div class="form-group">
                                <label>Hỗ trợ</label>
                                <input type="text" name="suports" value="${product.suports}"
                                       placeholder="Ví dụ: Android, Steam, Cloud Gaming">
                            </div>

                            <div class="form-group">
                                <label>Kết nối</label>
                                <input type="text" name="connect" value="${product.connect}"
                                       placeholder="Ví dụ: WiFi, Bluetooth, USB-C">
                            </div>

                            <div class="form-group">
                                <label>Ưu đãi</label>
                                <input type="text" name="endow" value="${product.endow}"
                                       placeholder="Ví dụ: Tặng bao da, freeship">
                            </div>
                        </div>
                    </div>

            </div>

        <div class="right-column">


            <div class="card">
                <h3>Giá bán</h3>

                <div class="form-group">
                    <label>Giá hiện tại</label>
                    <input type="number" name="price" min="0"
                           value="${product.priceValue}" required
                           placeholder="Ví dụ: 15990000">
                </div>

                <div class="form-group">
                    <label>Giá cũ</label>
                    <input type="number" name="priceOld" min="0"
                           value="${product.priceOldValue}"
                           placeholder="Ví dụ: 17990000">
                </div>
            </div>


            <div class="card">
                <h3>Phân loại</h3>

                <div class="form-group">
                    <label>Category ID</label>
                    <input type="number" name="categories_id"
                           value="${product.categories_id}" required
                           placeholder="Nhập ID danh mục">
                </div>

                <div class="form-group">
                    <label>Brand ID</label>
                    <input type="number" name="brand_id"
                           value="${product.brand_id}" required
                           placeholder="Nhập ID thương hiệu">
                </div>
            </div>


            <div class="card">
                <h3>Meta</h3>

                <div class="form-group">
                    <label>Meta title</label>
                    <input type="text" name="metatitle" id="metaTitle"
                           value="${product.metatitle}"
                           placeholder="Tự động tạo theo tên sản phẩm">
                </div>
            </div>


            <div class="card">
                <h3>Trạng thái hiển thị</h3>

                <div class="checkbox-group modern-check">
                    <label class="check-item">
                        <input type="checkbox" name="active"
                        ${product.active ? "checked" : ""}>
                        <span>Active</span>
                    </label>

                    <label class="check-item">
                        <input type="checkbox" name="ispremium"
                        ${product.ispremium ? "checked" : ""}>
                        <span>Premium</span>
                    </label>
                </div>
            </div>


            <div class="card sticky-card">
                <button type="submit" class="btn-save">Cập nhật sản phẩm</button>
                <a href="${pageContext.request.contextPath}/admin/products" class="btn-cancel">Huỷ</a>
            </div>

        </div>
    </form>
    </div>

<%--Thông báo update thành công--%>
<script>
    setTimeout(() =>{
        const alertBox = document.querySelector('.alert-success');
        if (alertBox){
            alertBox.style.transaction = "0.4s ease";
            alertBox.style.opacity = "0";
            alertBox.style.transform = "translateY(-6px)";
            setTimeout(() => alertBox.remove(), 400);
        }
    }, 4000);
</script>

<script>
    const imageMainFile = document.getElementById("imageMainFile");
    const imageMainUrl = document.getElementById("imageMainUrl");
    const mainPreview = document.getElementById("mainPreview");
    const mainPreviewText = document.getElementById("mainPreviewText");

    // chọn file từ máy
    imageMainFile.addEventListener("change", function () {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                mainPreview.src = e.target.result;
                mainPreview.style.display = "block";
                mainPreviewText.style.display = "none";
            };
            reader.readAsDataURL(file);
        }
    });

    //nhập URL ảnh
    imageMainUrl.addEventListener("input", function () {
        const url = this.value.trim();
        if (url !== "") {
            mainPreview.src = url;
            mainPreview.style.display = "block";
            mainPreviewText.style.display = "none";
        } else {
            mainPreview.style.display = "none";
            mainPreviewText.style.display = "block";
        }
    });
</script>
<script>
    // Preview khi nhập URL ảnh phụ
    document.querySelectorAll(".subImageUrl").forEach(input => {
        input.addEventListener("input", function () {
            const previewId = this.dataset.preview;
            const previewImg = document.getElementById(previewId);
            const url = this.value.trim();

            if (url !== "") {
                previewImg.src = url;
                previewImg.style.display = "block";
            } else {
                previewImg.style.display = "none";
            }
        });
    });

    // Preview khi chọn file ảnh phụ
    document.querySelectorAll(".subImageFile").forEach(input => {
        input.addEventListener("change", function () {
            const previewId = this.dataset.preview;
            const previewImg = document.getElementById(previewId);
            const file = this.files[0];

            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    previewImg.src = e.target.result;
                    previewImg.style.display = "block";
                };
                reader.readAsDataURL(file);
            }
        });
    });
</script>
</body>
</html>

