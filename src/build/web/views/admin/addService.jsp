<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Dịch Vụ Mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Thêm Dịch Vụ Mới</h2>

        <form action="${pageContext.request.contextPath}/admin/add-service" method="POST" class="mt-4">
            <div class="mb-3">
                <label for="serviceName" class="form-label">Tên Dịch Vụ</label>
                <input type="text" class="form-control" id="serviceName" name="serviceName" required>
            </div>
            
            <div class="mb-3">
                <label for="price" class="form-label">Giá (VND)</label>
                <input type="number" class="form-control" id="price" name="price" step="1000" min="0" required>
            </div>
            
            <div class="mb-3">
                <label for="description" class="form-label">Mô Tả</label>
                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
            </div>

            <button type="submit" class="btn btn-primary">Thêm Dịch Vụ</button>
            <a href="${pageContext.request.contextPath}/admin/list-services" class="btn btn-secondary">Hủy</a>
        </form>
    </div>
</body>
</html>