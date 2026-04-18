<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Người dùng đã xóa</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6fb;
        }

        .admin-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .content {
            flex: 1;
            padding: 24px;
        }

        .box {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
        }

        h2 {
            margin-top: 0;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f1f3f9;
            text-align: left;
            padding: 12px;
            font-size: 14px;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }

        .btn-restore {
            background: #00b894;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 16px;
            padding: 8px 14px;
            background: #0984e3;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 14px;
        }

        .btn-confirm-restore {
            background: #00b894;
            color: white;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.45);
            justify-content: center;
            align-items: center;
        }

        .modal.show {
            display: flex;
        }

        .modal-box {
            background: white;
            width: 400px;
            max-width: 90%;
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 6px 16px rgba(52, 152, 219, 0.22);
            text-align: center;
            animation: popupFade 0.2s ease;
        }

        .modal-box h3 {
            margin-top: 0;
            margin-bottom: 10px;
            font-size: 22px;
            color: #222;
        }

        .modal-box p {
            color: #000000;
            font-size: 18px;
            line-height: 1.6;
            margin-bottom: 24px;
        }

        .modal-actions {
            display: flex;
            justify-content: center;
            gap: 12px;
        }

        .modal-actions button {
            min-width: 110px;
            padding: 10px 16px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-cancel {
            background: #dfe6e9;
            color: #2d3436 !important;
        }

        .btn-confirm-restore {
            background: #00b894;
            color: white !important;
        }

        @keyframes popupFade {
            from {
                transform: translateY(-10px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
    </style>
</head>
<body>

<div class="admin-wrapper">

    <jsp:include page="/Assets/component/adminPage/layout/sidebar.jsp"/>

    <div class="content">
        <div class="box">
            <h2>Danh sách người dùng đã xóa</h2>

            <a href="${pageContext.request.contextPath}/admin/users" class="back-link">
                ← Quay lại danh sách người dùng
            </a>

            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Quyền</th>
                    <th>Khôi phục</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="u" items="${userList}">
                    <tr>
                        <td>#${u.id}</td>
                        <td>${u.username}</td>
                        <td>${u.email}</td>
                        <td>${u.role}</td>
                        <td>

                            <button type="button"
                                     class="btn-restore"
                                     onclick="openRestoreModal('${u.id}', '${u.username}')">
                            Khôi phục
                        </button>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty userList}">
                    <tr>
                        <td colspan="5" style="text-align:center;color:#999;">
                            Không có user nào đã bị xóa
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!--MODAL KHÔI PHỤC-->
<div id="restoreModal" class="modal">
    <div class="modal-box">
        <h3>Xác nhận khôi phục</h3>
        <p id="restoreMessage">
            Bạn có chắc muốn khôi phục tài khoản này không?
        </p>

        <div class="modal-actions">
            <button type="button" class="btn-cancel" onclick="closeRestoreModal()">Hủy</button>
            <button type="button" class="btn-confirm-restore" onclick="submitRestoreForm()">Khôi phục</button>
        </div>
    </div>
</div>

<!-- FORM ẨN GỬI KHÔI PHỤC -->
<form id="restoreForm" action="${pageContext.request.contextPath}/admin/restore-user" method="post" style="display:none;">
    <input type="hidden" name="userId" id="restoreUserId">
</form>

<script>
    function openRestoreModal(userId, username) {
        document.getElementById("restoreUserId").value = userId;
        document.getElementById("restoreMessage").innerHTML =
            "Bạn có chắc muốn khôi phục tài khoản <b>" + username + "</b> không?<br>User sẽ có thể đăng nhập và xuất hiện lại trong danh sách.";
        document.getElementById("restoreModal").classList.add("show");
    }

    function closeRestoreModal() {
        document.getElementById("restoreModal").classList.remove("show");
    }

    function submitRestoreForm() {
        document.getElementById("restoreForm").submit();
    }

    window.onclick = function(event) {
        const restoreModal = document.getElementById("restoreModal");
        if (event.target === restoreModal) {
            closeRestoreModal();
        }
    }
</script>
</body>
</html>