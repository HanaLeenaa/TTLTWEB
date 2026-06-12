<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa người dùng</title>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; background: #f4f6fb; }
        .admin-wrapper { display: flex; min-height: 100vh; }
        .content { flex: 1; padding: 24px; }

        .box { background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 8px 20px rgba(0,0,0,0.05); max-width: 600px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #333; }
        input[type="text"], select {
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px;
        }
        .btn-group { margin-top: 24px; display: flex; gap: 10px; }
        .btn-save { background: #3498db; color: white; padding: 12px 24px; border: none; border-radius: 8px; cursor: pointer; font-weight: bold; }
        .btn-cancel { background: #dfe6e9; color: #2d3436; padding: 12px 24px; text-decoration: none; border-radius: 8px; font-weight: bold; }
    </style>
</head>
<body>

<div class="admin-wrapper">
    <jsp:include page="/Assets/component/adminPage/sidebar.jsp"/>

    <div class="content">
        <div class="box">
            <h2>Chỉnh sửa người dùng: <span style="color: #3498db;">${u.username}</span></h2>
            <hr style="border: 0; border-top: 1px solid #eee; margin-bottom: 25px;">

            <form action="${pageContext.request.contextPath}/admin/edit-user" method="post">
                <input type="hidden" name="id" value="${u.id}">

                <div class="form-group">
                    <label>ID người dùng:</label>
                    <input type="text" value="#${u.id}" disabled style="background: #f9f9f9;">
                </div>

                <div class="form-group">
                    <label>Địa chỉ Email:</label>
                    <input type="text" value="${u.email}" disabled style="background: #f9f9f9;">
                </div>

                <div class="form-group">
                    <label>Họ và tên:</label>
                    <input type="text" name="username" value="${u.username}" required placeholder="Nhập tên mới...">
                </div>

                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="text" name="phone" value="${u.phoneNum}" placeholder="Nhập số điện thoại...">
                </div>

                <div class="form-group">
                    <label>Địa chỉ:</label>
                    <input type="text" name="address" value="${u.location}" placeholder="Nhập địa chỉ chi tiết...">
                </div>

                <div class="form-group">
                    <label>Quyền truy cập:</label>
                    <select name="role">
                        <option value="USER" ${u.role == 'user' ? 'selected' : ''}>user (Khách hàng)</option>
                        <option value="STAFF" ${u.role == 'staff' ? 'selected' : ''}>staff (Nhân viên)</option>
                        <option value="ADMIN" ${u.role == 'admin' ? 'selected' : ''}>admin (Quản trị viên)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                        <input type="checkbox" name="active" ${u.active ? 'checked' : ''} style="width: 18px; height: 18px;">
                        Cho phép tài khoản hoạt động
                    </label>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn-save">Lưu thông tin</button>
                    <a href="users" class="btn-cancel">Quay về danh sách</a>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>