<%@ page contentType="text-html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa Thông Tin Người Dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Sửa Thông Tin Người Dùng - ${userToEdit.username}</h2>

        <form action="${pageContext.request.contextPath}/admin/edit-user" method="POST" class="mt-4">
            
            <input type="hidden" name="userId" value="${userToEdit.userId}">

            <div class="mb-3">
                <label for="username" class="form-label">Tên Đăng Nhập</label>
                <input type="text" class="form-control" id="username" name="username" value="${userToEdit.username}" required>
            </div>
            
            <div class="mb-3">
                <label for="password" class="form-label">Mật Khẩu Mới</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="Để trống nếu không muốn thay đổi">
            </div>
            
            <div class="mb-3">
                <label for="fullName" class="form-label">Họ và Tên</label>
                <input type="text" class="form-control" id="fullName" name="fullName" value="${userToEdit.fullName}" required>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" value="${userToEdit.email}" required>
            </div>
            
            <div class="mb-3">
                <label for="phone" class="form-label">Số Điện Thoại</label>
                <input type="text" class="form-control" id="phone" name="phone" value="${userToEdit.phone}">
            </div>

            <div class="mb-3">
                <label for="role" class="form-label">Vai Trò</label>
                <select class="form-select" id="role" name="role" required>
                    <option value="user" ${userToEdit.role == 'user' ? 'selected' : ''}>User (Người dùng)</option>
                    <option value="admin" ${userToEdit.role == 'admin' ? 'selected' : ''}>Admin (Quản trị viên)</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
            <a href="${pageContext.request.contextPath}/admin/list-users" class="btn btn-secondary">Hủy</a>
        </form>
    </div>
</body>
</html>