<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Phòng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <%-- Font Awesome để hiển thị icon --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="container mt-4">
        <%-- <jsp:include page="../header_footer/header.jsp" /> --%>

        <!-- Tiêu đề và nút điều hướng -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Danh Sách Phòng</h2>
            <div>
                <a href="${pageContext.request.contextPath}/admin/add-room" class="btn btn-primary me-2">
                    <i class="fas fa-plus"></i> Thêm Phòng Mới
                </a>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay về Dashboard
                </a>
            </div>
        </div>

        <!-- Thanh tìm kiếm -->
        <form action="${pageContext.request.contextPath}/admin/list-rooms" method="get" class="mb-4 d-flex justify-content-end">
            <input type="text" name="keyword" value="<c:out value='${keyword}'/>"
                   class="form-control w-25 me-2" placeholder="Tìm theo tên hoặc loại phòng...">
            <button type="submit" class="btn btn-outline-primary">
                <i class="fas fa-search"></i> Tìm kiếm
            </button>
        </form>

        <!-- Flash message -->
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

        <!-- Bảng danh sách phòng -->
        <table class="table table-bordered table-hover align-middle">
            <thead class="table-dark text-center">
                <tr>
                    <th>ID</th>
                    <th>Tên Phòng</th>
                    <th>Loại Phòng</th>
                    <th>Giá (VND)</th>
                    <th>Sức chứa</th>
                    <th>Trạng Thái</th>
                    <th style="width: 15%;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty listRooms}">
                        <c:forEach var="room" items="${listRooms}">
                            <tr>
                                <td class="text-center">${room.roomId}</td>
                                <td><c:out value="${room.roomName}"/></td>
                                <td><c:out value="${room.roomType}"/></td>
                                <td class="text-end">
                                    <fmt:setLocale value="vi_VN"/>
                                    <fmt:formatNumber value="${room.price}" type="currency" currencySymbol="₫"/>
                                </td>
                                <td class="text-center">${room.capacity}</td>
                                
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${room.status == 'available'}">
                                            <span class="badge bg-success">Sẵn sàng</span>
                                        </c:when>
                                        <c:when test="${room.status == 'maintenance'}">
                                            <span class="badge bg-warning text-dark">Bảo trì</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${room.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/admin/edit-room?roomId=${room.roomId}" class="btn btn-warning btn-sm">
                                        <i class="fas fa-edit"></i> Sửa
                                    </a>
                                    <form action="${pageContext.request.contextPath}/admin/delete-room"
                                          method="POST" style="display:inline;"
                                          onsubmit="return confirm('Bạn có chắc chắn muốn xóa phòng này không?');">
                                        <input type="hidden" name="roomId" value="${room.roomId}">
                                        <button type="submit" class="btn btn-danger btn-sm">
                                            <i class="fas fa-trash"></i> Xóa
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="text-center text-muted py-3">
                                Không tìm thấy phòng nào phù hợp.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <!-- phan chia trang -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <!-- Nút Previous -->
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/list-rooms?page=${currentPage - 1}&keyword=${keyword}">Trước</a>
                        </li>
                    </c:if>

                    <!-- Các nút số trang -->
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${currentPage eq i}">
                                <li class="page-item active" aria-current="page">
                                    <span class="page-link">${i}</span>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/list-rooms?page=${i}&keyword=${keyword}">${i}</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <!-- Nút Next -->
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/list-rooms?page=${currentPage + 1}&keyword=${keyword}">Sau</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>
</body>
</html>