<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../header_footer/header.jsp" />

<div class="container my-5">
    <div class="row">
        <!-- Cột thông tin phòng và form đặt -->
        <div class="col-lg-7">
            <h2>Đặt Phòng</h2>
            <p class="lead">Vui lòng điền thông tin để hoàn tất đặt phòng cho: <strong>${room.roomName}</strong></p>

            <!-- Vùng hiển thị lỗi từ Servlet -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/book-room" method="post" id="bookingForm">
                <input type="hidden" name="room_id" value="${room.roomId}">
                <input type="hidden" id="roomPrice" value="${room.price}">

                <!-- Phần chọn ngày -->
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="check_in" class="form-label">Ngày nhận phòng</label>
                        <input type="date" name="check_in" id="check_in" class="form-control" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="check_out" class="form-label">Ngày trả phòng</label>
                        <input type="date" name="check_out" id="check_out" class="form-control" required>
                    </div>
                </div>

                <!-- Phần chọn dịch vụ -->
                <h5 class="mt-3">Dịch vụ thêm</h5>
                <div class="row">
                    <c:forEach var="s" items="${services}">
                        <div class="col-md-6 mb-3">
                            <div class="form-check">
                                <input class="form-check-input service-checkbox" type="checkbox" name="service_id" value="${s.serviceId}" id="service_${s.serviceId}" data-price="${s.price}">
                                <label class="form-check-label" for="service_${s.serviceId}">
                                    <strong>${s.serviceName}</strong> - <fmt:formatNumber value="${s.price}" type="number" maxFractionDigits="0"/> VNĐ
                                </label>
                            </div>
                            <!-- Ô nhập số lượng, mặc định bị ẩn -->
                            <input type="number" name="quantity_${s.serviceId}" class="form-control form-control-sm mt-1 service-quantity" value="1" min="1" style="display:none;">
                        </div>
                    </c:forEach>
                </div>

                <button type="submit" class="btn btn-primary btn-lg mt-4">Xác nhận Đặt phòng</button>
            </form>
        </div>

        <!-- Cột hóa đơn tạm tính -->
        <div class="col-lg-5">
            <div class="card shadow-sm sticky-top" style="margin-top: 80px;">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">Hóa Đơn Tạm Tính</h5>
                </div>
                <div class="card-body" id="bill-summary">
                    <p class="text-muted">Vui lòng chọn ngày nhận, trả phòng và dịch vụ để xem chi tiết.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/booking.js"></script>


<jsp:include page="../header_footer/footer.jsp" />