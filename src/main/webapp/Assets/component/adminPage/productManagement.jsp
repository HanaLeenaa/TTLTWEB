<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/AdminPage/productManagement.css">

<style>
    .content-product-management {
        width: 100%;
        box-sizing: border-box;
        font-family: "Poppins", Arial, sans-serif;
    }

    h2 {
        margin: 0;
        font-size: 26px;
        font-weight: 600;
        color: #333;
    }

    .top-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        width: 100%;
        background: white;
        padding: 20px 25px;
        border-radius: 14px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        box-sizing: border-box;
    }

    .btn-add {
        background-color: #43a047;
        color: white;
        padding: 10px 16px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        transition: background 0.2s;
    }

    .btn-add:hover {
        background-color: #2e7d32;
    }

    .table-box {
        background: white;
        padding: 20px;
        border-radius: 14px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        overflow-x: auto;
        width: 100%;
        box-sizing: border-box;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
        min-width: 800px;
    }

    table th {
        text-align: center;
        padding: 12px 10px;
        background: #f1f3f9;
        color: #333;
        font-weight: 600;
    }

    table td {
        padding: 12px 10px;
        border-bottom: 1px solid #eee;
        text-align: center;
        vertical-align: middle;
    }

    tr:hover {
        background-color: #fafafa;
    }

    .btn-edit {
        color: #1e88e5;
        text-decoration: none;
    }

    .btn-edit:hover {
        color: #0d47a1;
    }

    .btn-delete {
        color: #e53935;
        text-decoration: none;
    }

    .btn-delete:hover {
        color: #b71c1c;
    }

    .action-buttons {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 12px;
    }

    .search-wrapper {
        display: flex;
        justify-content: flex-end;
        width: 100%;
        margin-bottom: 18px;
    }

    .search-box {
        position: relative;
        width: 300px;
    }

    .search-box input {
        width: 100%;
        padding: 10px 44px 10px 14px;
        border: 1px solid #b3d7ff;
        outline: none;
        border-radius: 10px;
        background-color: #cce5ff;
        font-size: 16px;
        box-sizing: border-box;
        transition: all 0.2s;
    }

    .search-box input:focus {
        border-color: #0b74f8;
        background-color: #e6f2ff;
        box-shadow: 0 0 0 3px rgba(11, 116, 248, 0.15);
    }

    /* ==========================================================================
       BỔ SUNG CSS CHI TIẾT CHO MODAL XÓA & ALERT POPUP (BAO ĐẦY ĐỦ)
       ========================================================================== */
    .modal-overlay, .alert-overlay {
        position: fixed;
        top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.5);
        display: none;
        justify-content: center;
        align-items: center;
        z-index: 9999;
    }

    .modal-box, .alert-box {
        background: white;
        padding: 25px;
        border-radius: 12px;
        width: 400px;
        text-align: center;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        animation: fadeIn 0.3s ease;
    }

    .modal-actions {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-top: 20px;
    }

    .btn-cancel, .alert-btn {
        background: #95a5a6;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 6px;
        cursor: pointer;
        font-weight: 500;
    }

    .btn-confirm-delete {
        background: #e53935;
        color: white;
        text-decoration: none;
        padding: 10px 20px;
        border-radius: 6px;
        font-weight: 500;
    }

    /* Định dạng màu sắc popup kết quả */
    .alert-box.success h3 { color: #2ecc71; }
    .alert-box.error h3 { color: #e74c3c; }

    @keyframes fadeIn {
        from { transform: scale(0.9); opacity: 0; }
        to { transform: scale(1); opacity: 1; }
    }
</style>

<div class="content-product-management">

    <div class="top-bar">
        <h2>QUẢN LÝ SẢN PHẨM</h2>
        <a class="btn-add" href="${pageContext.request.contextPath}/admin/products/add">
            ➕ Thêm sản phẩm
        </a>
    </div>

    <div class="search-wrapper">
        <form action="${pageContext.request.contextPath}/admin/products" method="get">
            <div class="search-box">
                <input type="text" name="keyword" placeholder="Tìm sản phẩm..." value="${keyword}">
                <button type="submit" style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; padding: 0;">
                    <i class="fa-solid fa-magnifying-glass" style="color: #0b74f8; font-size: 22px; cursor: pointer;"></i>
                </button>
            </div>
        </form>
    </div>

    <div class="table-box">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Hình ảnh</th>
                    <th>Tên</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Active</th>
                    <th>Premium</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${products}" var="p">
                    <tr>
                        <td>${p.getId()}</td>
                        <td>
                            <c:choose>
                                <c:when test="${empty p.image}">
                                    <span style="color: #999; font-style: italic;">Không có ảnh</span>
                                </c:when>
                                <c:when test="${p.image.startsWith('http')}">
                                    <img src="${p.image}" width="60" alt="${p.name}">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/${p.image}" width="60" alt="${p.name}">
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="text-align: left; font-weight: 500;">${p.name}</td>
                        <td>
                            <span style="font-weight: 600; color: #eb3b5a;">
                                <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ
                            </span>
                        </td>
                        <td>${p.getStock()}</td>
                        <td>${p.active}</td>
                        <td>${p.getIspremium()}</td>
                        <td>
                            <div class="action-buttons">
                                <a class="btn-edit" href="${pageContext.request.contextPath}/admin/products/edit?id=${p.getId()}">
                                    <i class="fa-regular fa-pen-to-square"></i> Sửa
                                </a>
                                <a class="btn-delete openDeleteModal" href="#" data-url="${pageContext.request.contextPath}/admin/products/delete?id=${p.getId()}">
                                    <i class="fa-regular fa-trash-can"></i> Xóa
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
        <div style="display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 25px; font-family: sans-serif;">
            <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/admin/products?page=${currentPage - 1}&keyword=${keyword}" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #4b7bec;">« Trước</a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="${pageContext.request.contextPath}/admin/products?page=${i}&keyword=${keyword}" style="padding: 8px 12px; border: 1px solid ${i == currentPage ? '#4b7bec' : '#ddd'}; background-color: ${i == currentPage ? '#4b7bec' : 'white'}; color: ${i == currentPage ? 'white' : '#333'}; border-radius: 4px; text-decoration: none; font-weight: ${i == currentPage ? 'bold' : 'normal'};">${i}</a>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/admin/products?page=${currentPage + 1}&keyword=${keyword}" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #4b7bec;">Sau »</a>
            </c:if>
        </div>
    </c:if>
</div>

<div id="deleteModal" class="modal-overlay">
    <div class="modal-box">
        <h3>Xác nhận xóa</h3>
        <p>Bạn có muốn xóa sản phẩm này không?</p>
        <div class="modal-actions">
            <button id="cancelDelete" class="btn-cancel">Hủy</button>
            <a id="confirmDeleteBtn" href="#" class="btn-confirm-delete">Xóa</a>
        </div>
    </div>
</div>

<div id="resultModal" class="alert-overlay">
    <div id="resultBox" class="alert-box">
        <h3 id="resultTitle"></h3>
        <p id="resultMessage"></p>
        <button id="closeResultModal" class="alert-btn">Đóng</button>
    </div>
</div>

<script>
    const deleteModal = document.getElementById("deleteModal");
    const confirmDelete = document.getElementById("confirmDeleteBtn");
    const cancelDelete = document.getElementById("cancelDelete");

    document.querySelectorAll(".openDeleteModal").forEach(button => {
        button.addEventListener("click", function (e) {
            e.preventDefault();
            const deleteUrl = this.getAttribute("data-url");
            confirmDelete.setAttribute("href", deleteUrl);
            deleteModal.style.display = "flex";
        });
    });
    cancelDelete.addEventListener("click", function () {
        deleteModal.style.display = "none";
    });

    deleteModal.addEventListener("click", function (e) {
        if (e.target === deleteModal) {
            deleteModal.style.display = "none";
        }
    });

    const resultModal = document.getElementById("resultModal");
    const resultBox = document.getElementById("resultBox");
    const resultTitle = document.getElementById("resultTitle");
    const resultMessage = document.getElementById("resultMessage");
    const closeResultModal = document.getElementById("closeResultModal");

    const urlParams = new URLSearchParams(window.location.search);
    const success = urlParams.get("success");
    const error = urlParams.get("error");
    if (success === "deleted"){
        resultBox.className = "alert-box success";
        resultTitle.textContent = "Thành công";
        resultMessage.textContent = "Sản phẩm đã được xóa thành công!";
        resultModal.style.display = "flex";
    }
    if (error === "deletefail") {
        resultBox.className = "alert-box error";
        resultTitle.textContent = "Thất bại";
        resultMessage.textContent = "Không thể xóa sản phẩm.";
        resultModal.style.display = "flex";
    }
    if (error === "invalidid") {
        resultBox.className = "alert-box error";
        resultTitle.textContent = "Lỗi";
        resultMessage.textContent = "ID sản phẩm không hợp lệ.";
        resultModal.style.display = "flex";
    }

    closeResultModal.addEventListener("click", function () {
        resultModal.style.display = "none";
        const cleanUrl = window.location.pathname;
        window.history.replaceState({}, document.title, cleanUrl);
    });

    resultModal.addEventListener("click", function (e) {
        if (e.target === resultModal) {
            resultModal.style.display = "none";
            const cleanUrl = window.location.pathname;
            window.history.replaceState({}, document.title, cleanUrl);
        }
    });
</script>