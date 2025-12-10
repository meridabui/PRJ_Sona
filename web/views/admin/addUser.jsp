<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Người Dùng Mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Thêm Người Dùng Mới</h2>

        <form action="${pageContext.request.contextPath}/admin/add-user" method="POST" class="mt-4">
            <div class="mb-3">
                <label for="username" class="form-label">Tên Đăng Nhập</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            
            <div class="mb-3">
                <label for="password" class="form-label">Mật Khẩu</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            
            <div class="mb-3">
                <label for="fullName" class="form-label">Họ và Tên</label>
                <input type="text" class="form-control" id="fullName" name="fullName" required>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            
            <div class="mb-3">
                <label for="phone" class="form-label">Số Điện Thoại</label>
                <input type="text" class="form-control" id="phone" name="phone">
            </div>

            <div class="mb-3">
                <label for="role" class="form-label">Vai Trò</label>
                <select class="form-select" id="role" name="role" required>
                    <option value="user" selected>User (Người dùng)</option>
                    <option value="admin">Admin (Quản trị viên)</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Thêm Người Dùng</button>
            <a href="${pageContext.request.contextPath}/admin/list-users" class="btn btn-secondary">Hủy</a>
        </form>
    </div>
</body>
</html>