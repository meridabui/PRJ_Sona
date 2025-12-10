<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Dịch Vụ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Danh Sách Dịch Vụ</h2>
            <a href="${pageContext.request.contextPath}/admin/add-service" class="btn btn-primary">Thêm Dịch Vụ Mới</a>
            
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Quay về Dashboard
        </a>
        </div>

        <!-- Vùng hiển thị thông báo -->
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Tên Dịch Vụ</th>
                    <th>Giá (VND)</th>
                    <th>Mô Tả</th>
                    <th style="width: 15%;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%-- Lặp qua danh sách 'listServices' đã được gửi từ servlet --%>
                <c:forEach var="service" items="${listServices}">
                    <tr>
                        <td>${service.serviceId}</td>
                        <td><c:out value="${service.serviceName}"/></td>
                        <td>${String.format("%,.0f", service.price)}</td>
                        <td><c:out value="${service.description}"/></td>
                        <td>
                            <!-- Nút Sửa -->
                            <a href="${pageContext.request.contextPath}/admin/edit-service?serviceId=${service.serviceId}" class="btn btn-warning btn-sm">Sửa</a>
                            
                            <!-- Form Xóa -->
                            <form action="${pageContext.request.contextPath}/admin/delete-service" method="POST" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa dịch vụ này không?');">
                                <input type="hidden" name="serviceId" value="${service.serviceId}">
                                <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                
                <%-- Hiển thị thông báo nếu không có dịch vụ nào --%>
                <c:if test="${empty listServices}">
                    <tr>
                        <td colspan="5" class="text-center">Không có dữ liệu dịch vụ.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</body>
</html>