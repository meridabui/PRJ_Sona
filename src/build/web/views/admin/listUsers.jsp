<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Người Dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Danh Sách Người Dùng</h2>
            <div>
                <a href="${pageContext.request.contextPath}/admin/add-user" class="btn btn-primary">Thêm Người Dùng Mới</a>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay về Dashboard
                </a>
            </div>
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

        <!-- Thanh tìm kiếm -->
        <div class="mb-3">
            <form action="${pageContext.request.contextPath}/admin/list-users" method="GET" class="d-flex">
                <input class="form-control me-2" type="search" name="search" placeholder="Tìm kiếm theo tên hoặc email" aria-label="Search" value="<c:out value='${param.search}'/>">
                <button class="btn btn-outline-success" type="submit">Tìm</button>
            </form>
        </div>

        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Tên Đăng Nhập</th>
                    <th>Họ Tên</th>
                    <td>Số điện thoại</td>
                    <th>Email</th>
                    <th>Vai Trò</th>
                    <th style="width: 15%;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%-- Lặp qua danh sách 'listUsers' đã được gửi từ servlet --%>
                <c:forEach var="user" items="${listUsers}">
                    <tr>
                        <td>${user.userId}</td>
                        <td><c:out value="${user.username}"/></td>
                        <td><c:out value="${user.fullName}"/></td>
                        <td><c:out value="${user.phone}"/></td>
                        <td><c:out value="${user.email}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${user.role == 'admin'}">
                                    <span class="badge bg-success">Admin</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">User</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <!-- Nút Sửa -->
                            <a href="${pageContext.request.contextPath}/admin/edit-user?userId=${user.userId}" class="btn btn-warning btn-sm">Sửa</a>
                            
                            <!-- Form Xóa với điều kiện kiểm tra an toàn -->
                            <c:if test="${sessionScope.user.userId != user.userId}">
                                <form action="${pageContext.request.contextPath}/admin/delete-user" method="POST" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa người dùng \'${user.username}\' không?');">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                    <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                
                <%-- Hiển thị thông báo nếu không có người dùng nào --%>
                <c:if test="${empty listUsers}">
                    <tr>
                        <td colspan="6" class="text-center">Không có dữ liệu người dùng.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</body>
</html>