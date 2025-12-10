<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm Phòng Mới</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">

            <%-- <jsp:include page="../header_footer/header.jsp" /> --%>

            <h2>Thêm Phòng Mới</h2>

            <form action="${pageContext.request.contextPath}/admin/add-room" method="POST" class="mt-4">
                <div class="mb-3">
                    <label for="roomName" class="form-label">Tên Phòng</label>
                    <input type="text" class="form-control" id="roomName" name="roomName" required>
                </div>

                <div class="mb-3">
                    <label for="roomType" class="form-label">Loại Phòng</label>
                    <input type="text" class="form-control" id="roomType" name="roomType" placeholder="Ví dụ: Standard, Deluxe, Suite" required>
                </div>
                
                 <div class="mb-3">
                    <label for="roomType" class="form-label"> Thêm Loại Phòng</label>
                    <input type="text" class="form-control" id="addRoomType" name="addRoomType" placeholder="Ví dụ: Standard, Deluxe, Suite" required>
                </div>

                <div class="mb-3">
                    <label for="price" class="form-label">Giá (VND/đêm)</label>
                    <input type="number" class="form-control" id="price" name="price" step="1000" min="0" required>
                </div>
                <div class="mb-3">
                    <label for="capacity" class="form-label">Số Lượng</label>
                    <input type="number" class="form-control" id="capacity" name="capacity" step="1" min="0" required>
                </div>
                <div class="mb-3">
                    <label for="status" class="form-label">Trạng Thái</label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="Available" selected>Sẵn sàng (Available)</option>
                        <option value="Booked">Đã được đặt (Booked)</option>
                        <option value="Maintenance">Đang bảo trì (Maintenance)</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Mô Tả</label>
                    <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                </div>

                <div class="mb-3">
                    <label for="imageUrl" class="form-label">URL Hình Ảnh</label>
                    <input type="text" class="form-control" id="imageUrl" name="imageUrl" placeholder="https://example.com/image.jpg">
                </div>

                <button type="submit" class="btn btn-primary">Thêm Phòng</button>
                <a href="${pageContext.request.contextPath}/admin/list-rooms" class="btn btn-secondary">Hủy</a>
            </form>

            <%-- <jsp:include page="../header_footer/footer.jsp" /> --%>
        </div>
    </body>
</html>