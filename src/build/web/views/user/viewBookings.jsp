<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Đơn Đặt Phòng Của Tôi" scope="request"/>
<jsp:include page="../header_footer/header.jsp"/>

<div class="container my-5">
    <h1 class="text-center mb-4">Lịch Sử Đặt Phòng</h1>

    <%-- Vùng hiển thị thông báo --%>
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.message}
            <a href="https://www.facebook.com/nam.duong.586042"> Liên hệ với Page để hoàn thành thủ tục đặt phòng</a>
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

    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th scope="col">Mã Đơn</th>
                            <th scope="col">Phòng</th>
                            <th scope="col">Ngày Nhận/Trả</th>
                            <th scope="col">Dịch Vụ Kèm Theo</th>
                            <th scope="col">Tổng Tiền</th>
                            <th scope="col">Trạng Thái</th>
                            <th scope="col" class="text-center">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td class="text-center"><strong>#${b.bookingId}</strong></td>
                                <td>${b.room.roomName}</td>
                                <td><fmt:formatDate value="${b.checkIn}" pattern="dd/MM/yyyy"/> - <fmt:formatDate value="${b.checkOut}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty b.services}">
                                            <ul class="list-unstyled mb-0 ps-3">
                                                <c:forEach var="s" items="${b.services}">
                                                    <li>• ${s.serviceName}</li>
                                                </c:forEach>
                                            </ul>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Không có</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <fmt:formatNumber value="${b.totalPrice}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                                </td>
                                
                                <%-- Hiển thị trạng thái --%>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${b.status == 'confirmed'}"><span class="badge bg-success">Đã xác nhận</span></c:when>
                                        <c:when test="${b.status == 'pending'}"><span class="badge bg-warning text-dark">Chờ xác nhận</span></c:when>
                                        <c:when test="${b.status == 'pending_cancellation'}"><span class="badge bg-info text-dark">Đang chờ hủy</span></c:when>
                                        <c:when test="${b.status == 'cancelled'}"><span class="badge bg-danger">Đã hủy</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${b.status}</span></c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="text-center">
                                    <%-- Chỉ cho phép yêu cầu hủy khi đơn đã được xác nhận --%>
                                    <c:if test="${b.status == 'confirmed'}">
                                        <form action="${pageContext.request.contextPath}/user/request-cancellation" method="POST" onsubmit="return confirm('Bạn có chắc muốn gửi yêu cầu hủy cho đơn đặt phòng này không?');">
                                            <input type="hidden" name="booking_id" value="${b.bookingId}">
                                            <button type="submit" class="btn btn-warning btn-sm">Yêu cầu hủy</button>
                                        </form>
                                    </c:if>
                                    
                                    <%-- Với các trạng thái khác, không hiển thị nút nào --%>
                                    <c:if test="${b.status != 'confirmed'}">
                                        <span class="text-muted fst-italic">--</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <%-- Trường hợp không có đơn đặt phòng nào --%>
                        <c:if test="${empty bookings}">
                            <tr>
                                <td colspan="8" class="text-center text-muted py-4">
                                    Bạn chưa có đơn đặt phòng nào.
                                    <a href="${pageContext.request.contextPath}/list-rooms" class="btn btn-primary btn-sm ms-2">Đặt Phòng Ngay</a>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../header_footer/footer.jsp"/>