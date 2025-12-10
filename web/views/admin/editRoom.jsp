<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Sửa Thông Tin Phòng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <h2>Sửa Thông Tin Phòng - ID: ${room.roomId}</h2>

            <form action="${pageContext.request.contextPath}/admin/edit-room" method="POST" class="mt-4">


                <input type="hidden" name="roomId" value="${room.roomId}">

                <div class="mb-3">
                    <label for="roomName" class="form-label">Tên Phòng</label>
                    <input type="text" class="form-control" id="roomName" name="roomName" value="${room.roomName}" required>
                </div>

                <div class="mb-3">
                    <label for="roomType" class="form-label">Loại Phòng</label>
                    <input type="text" class="form-control" id="roomType" name="roomType" value="${room.roomType}" required>
                </div>

                <div class="mb-3">
                    <label for="price" class="form-label">Giá (VND/đêm)</label>
                    <input type="number" class="form-control" id="price" name="price" step="1000" min="0" value="${room.price}" required>
                </div>
                <div class="mb-3">
                    <label for="capacity" class="form-label">Số Lượng</label>
                    <input type="number" class="form-control" id="capacity" name="capacity" step="1" min="0" value="${room.capacity}" required>
                </div>
                <div class="mb-3">
                    <label for="status" class="form-label">Trạng Thái</label>
                    <select class="form-select" id="status" name="status" required>

                        <option value="available" ${room.status == 'available' ? 'selected' : ''}>Sẵn sàng (Available)</option>
                        <option value="maintenance" ${room.status == 'maintenance' ? 'selected' : ''}>Đang bảo trì (Maintenance)</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Mô Tả</label>
                    <textarea class="form-control" id="description" name="description" rows="3">${room.description}</textarea>
                </div>

                <div class="mb-3">
                    <label for="imageUrl" class="form-label">URL Hình Ảnh</label>
                    <input type="text" class="form-control" id="imageUrl" name="imageUrl" value="${room.imageUrl}">
                </div>

                <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
                <a href="${pageContext.request.contextPath}/admin/list-rooms" class="btn btn-secondary">Hủy</a>
            </form>
        </div>
    </body>
</html>