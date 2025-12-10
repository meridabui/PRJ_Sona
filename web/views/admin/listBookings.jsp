<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Quản Lý Đặt Phòng" scope="request"/>
<jsp:include page="../header_footer/header.jsp" />

<div class="container-fluid my-4">
    <%-- tieu de va nut --%>
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Quản Lý Đặt Phòng</h1>
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/admin/add-booking" class="btn btn-primary shadow-sm">
                <i class="fas fa-plus fa-sm text-white-50 me-2"></i>Thêm Booking Mới
            </a>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-1"></i>Quay về Dashboard
            </a>
        </div>
    </div>

    <%-- Vùng hiển thị thông báo từ session --%>
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
    
    <!-- form tim kiem -->
    <div class="card shadow mb-4">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/list-bookings" method="GET" class="row g-3 align-items-end">
                <div class="col-md-6">
                    <label for="keyword" class="form-label">Tên khách hàng / Tên phòng</label>
                    <input type="text" class="form-control" id="keyword" name="keyword" 
                           placeholder="Nhập từ khóa..." 
                           value="<c:out value='${param.keyword}'/>">
                </div>
                <div class="col-md-4">
                    <label for="searchDate" class="form-label">Tìm theo ngày check-in/out</label>
                    <input type="date" class="form-control" id="searchDate" name="searchDate"
                           value="<c:out value='${param.searchDate}'/>">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search fa-sm me-2"></i>Tìm Kiếm
                    </button>
                </div>
            </form>
        </div>
    </div>

    <%-- Bảng chứa danh sách các đơn đặt phòng --%>
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
            <h6 class="m-0 font-weight-bold text-primary">Danh sách Booking</h6>
            <%-- Nút để xóa bộ lọc và quay về danh sách đầy đủ --%>
            <c:if test="${not empty param.keyword || not empty param.searchDate}">
                <a href="${pageContext.request.contextPath}/admin/list-bookings" class="btn btn-sm btn-outline-secondary">
                    <i class="fas fa-times me-1"></i> Xóa bộ lọc tìm kiếm
                </a>
            </c:if>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover" id="dataTable" width="100%" cellspacing="0">
                    <thead class="table-light text-center">
                        <tr>
                            <th>Mã Đơn</th>
                            <th>Khách Hàng</th>
                            <th>Phòng</th>
                            <th>Ngày Nhận/Trả</th>
                            <th>Dịch Vụ (Số lượng)</th>
                            <th>Tổng Tiền</th>
                            <th>Trạng Thái</th>
                            <th style="min-width: 180px;">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- Hiển thị thông báo phù hợp khi danh sách trống --%>
                        <c:if test="${empty bookings}">
                            <tr>
                                <td colspan="8" class="text-center text-muted py-4">
                                    <c:choose>
                                        <c:when test="${not empty param.keyword || not empty param.searchDate}">
                                            Không tìm thấy kết quả nào phù hợp với tiêu chí của bạn.
                                        </c:when>
                                        <c:otherwise>
                                            Chưa có đơn đặt phòng nào trong hệ thống.
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td class="text-center align-middle"><strong>#${b.bookingId}</strong></td>
                                <td class="align-middle">${b.user.fullName}</td>
                                <td class="align-middle">${b.room.roomName}</td>
                                <td class="text-center align-middle small">
                                    <fmt:formatDate value="${b.checkIn}" pattern="dd/MM/yyyy"/><br>
                                    <i class="fas fa-long-arrow-alt-down text-muted"></i><br>
                                    <fmt:formatDate value="${b.checkOut}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td class="align-middle">
                                    <c:choose>
                                        <c:when test="${not empty b.services}">
                                            <ul class="list-unstyled mb-0 ps-2 small">
                                                <c:forEach var="s" items="${b.services}">
                                                    <li>• ${s.serviceName} <span class="text-muted">(x${s.quantity})</span></li>
                                                </c:forEach>
                                            </ul>
                                        </c:when>
                                        <c:otherwise><span class="text-muted fst-italic">Không có</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end align-middle">
                                    <fmt:formatNumber value="${b.totalPrice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                </td>
                                
                                <td class="text-center align-middle">
                                    <c:set var="statusClass" value="bg-secondary"/>
                                    <c:if test="${b.status == 'confirmed'}"><c:set var="statusClass" value="bg-success"/></c:if>
                                    <c:if test="${b.status == 'pending'}"><c:set var="statusClass" value="bg-warning text-dark"/></c:if>
                                    <c:if test="${b.status == 'pending_cancellation'}"><c:set var="statusClass" value="bg-info text-dark"/></c:if>
                                    <c:if test="${b.status == 'cancelled'}"><c:set var="statusClass" value="bg-danger"/></c:if>
                                    <c:if test="${b.status == 'completed'}"><c:set var="statusClass" value="bg-primary"/></c:if>
                                    <%-- Sử dụng text-capitalize để tự động viết hoa chữ cái đầu --%>
                                    <span class="badge ${statusClass} text-capitalize">${b.status.replace("_", " ")}</span>
                                </td>
                                
                                <td class="text-center align-middle">
                                    <div class="btn-group" role="group">
                                        <%-- Nút Sửa: Luôn hiển thị --%>
                                        <a href="${pageContext.request.contextPath}/admin/edit-booking?booking_id=${b.bookingId}" class="btn btn-sm btn-outline-warning" title="Sửa Booking">
                                            <i class="fas fa-edit"></i>
                                        </a>

                                        <%-- Các nút thay đổi trạng thái chỉ hiển thị khi cần thiết --%>
                                        <c:if test="${b.status == 'pending'}">
                                            <form action="${pageContext.request.contextPath}/admin/update-booking-status" method="POST" class="d-inline">
                                                <input type="hidden" name="booking_id" value="${b.bookingId}">
                                                <input type="hidden" name="newStatus" value="confirmed">
                                                <button type="submit" class="btn btn-sm btn-outline-success" title="Xác nhận đơn"><i class="fas fa-check"></i></button>
                                            </form>
                                        </c:if>

                                        <c:if test="${b.status == 'pending_cancellation'}">
                                             <form action="${pageContext.request.contextPath}/admin/update-booking-status" method="POST" class="d-inline">
                                                <input type="hidden" name="booking_id" value="${b.bookingId}">
                                                <input type="hidden" name="newStatus" value="cancelled">
                                                <button type="submit" class="btn btn-sm btn-outline-info" title="Duyệt Hủy"><i class="fas fa-check-double"></i></button>
                                            </form>
                                        </c:if>

                                        <%-- Nút Xóa: Luôn hiển thị nhưng có cảnh báo nguy hiểm --%>
                                        <form action="${pageContext.request.contextPath}/admin/delete-booking" method="POST" onsubmit="return confirm('HÀNH ĐỘNG NGUY HIỂM!\nBạn có chắc muốn XÓA VĨNH VIỄN đơn #${b.bookingId} không?');" class="d-inline">
                                            <input type="hidden" name="booking_id" value="${b.bookingId}" />
                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Xóa vĩnh viễn">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div> 

            <!-- phan chia trang 10 booking 1 trang-->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center mt-4">
                        <%-- Nút Previous --%>
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/list-bookings?page=${currentPage - 1}&keyword=${param.keyword}&searchDate=${param.searchDate}">Trước</a>
                            </li>
                        </c:if>
                        <c:if test="${currentPage <= 1}">
                             <li class="page-item disabled">
                                <span class="page-link">Trước</span>
                            </li>
                        </c:if>

                        <%-- Các nút số trang --%>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:choose>
                                <c:when test="${currentPage eq i}">
                                    <li class="page-item active" aria-current="page">
                                        <span class="page-link">${i}</span>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/admin/list-bookings?page=${i}&keyword=${param.keyword}&searchDate=${param.searchDate}">${i}</a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <%-- Nút Next --%>
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/list-bookings?page=${currentPage + 1}&keyword=${param.keyword}&searchDate=${param.searchDate}">Sau</a>
                            </li>
                        </c:if>
                         <c:if test="${currentPage >= totalPages}">
                             <li class="page-item disabled">
                                <span class="page-link">Sau</span>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
            
        </div>
    </div>
</div>

<jsp:include page="../header_footer/footer.jsp"/>