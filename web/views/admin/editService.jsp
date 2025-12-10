<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa Thông Tin Dịch Vụ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Sửa Thông Tin Dịch Vụ - ID: ${service.serviceId}</h2>

        <form action="${pageContext.request.contextPath}/admin/edit-service" method="POST" class="mt-4">
            
            <input type="hidden" name="serviceId" value="${service.serviceId}">

            <div class="mb-3">
                <label for="serviceName" class="form-label">Tên Dịch Vụ</label>
                <input type="text" class="form-control" id="serviceName" name="serviceName" value="${service.serviceName}" required>
            </div>
            
            <div class="mb-3">
                <label for="price" class="form-label">Giá (VND)</label>
                <input type="number" class="form-control" id="price" name="price" step="1000" min="0" value="${service.price}" required>
            </div>
            
            <div class="mb-3">
                <label for="description" class="form-label">Mô Tả</label>
                <textarea class="form-control" id="description" name="description" rows="3">${service.description}</textarea>
            </div>

            <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
            <a href="${pageContext.request.contextPath}/admin/list-services" class="btn btn-secondary">Hủy</a>
        </form>
    </div>
</body>
</html>