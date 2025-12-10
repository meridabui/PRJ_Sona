<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Sửa Booking #${booking.bookingId}" scope="request"/>
<jsp:include page="../header_footer/header.jsp"/>

<%-- Thêm các style tương tự addBooking.jsp để giao diện nhất quán --%>
<style>
    body {
        font-family: 'Poppins', sans-serif;
        background-color: #f8f9fa;
    }
    .card {
        border-radius: 12px;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
    }
    .card-header.bg-warning {
        background: linear-gradient(135deg, #ffc107, #ff9800) !important;
        color: #fff;
        font-weight: 600;
        font-size: 1.4rem;
        text-align: center;
    }
    .form-label {
        font-weight: 500;
    }
    .form-control, .form-select {
        border-radius: 8px;
    }
    .form-control:focus, .form-select:focus {
        border-color: #ffc107;
        box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25);
    }
    .service-checkbox {
        width: 1.25rem;
        height: 1.25rem;
    }
    .service-quantity {
        border-radius: 6px;
    }
    .btn {
        border-radius: 25px;
        font-weight: 500;
        padding: 0.6rem 1.5rem;
    }
</style>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-lg">
                <div class="card-header bg-warning text-white">
                    <h2 class="mb-0">Chỉnh Sửa Booking #${booking.bookingId}</h2>
                </div>
                <div class="card-body p-4">
                    
                    <form action="${pageContext.request.contextPath}/admin/edit-booking" method="POST">

                        <input type="hidden" name="bookingId" value="${booking.bookingId}">

                        <%-- CHỌN USER VÀ PHÒNG --%>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="userSearch" class="form-label"><strong>Tìm Khách Hàng:</strong></label>
                                <%-- Tìm tên khách hàng hiện tại để hiển thị trong ô input --%>
                                <c:set var="selectedUserText" value=""/>
                                
                                <c:forEach var="user" items="${users}">
                                    <c:if test="${user.userId == booking.userId}">
                                        <c:set var="selectedUserText" value="${user.fullName}"/>
                                    </c:if>
                                </c:forEach>
                                
                                <input type="text" id="userSearch" class="form-control mb-2" placeholder="Nhập tên khách hàng..." value="${selectedUserText}">

                                <select class="form-select" id="userId" name="userId" required>
                                    <%-- Ban đầu chỉ tải khách hàng đang được chọn của booking này --%>
                                    <c:forEach var="user" items="${users}">
                                        <c:if test="${user.userId == booking.userId}">
                                            <option value="${user.userId}" selected>${user.fullName} (${user.username})</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="roomSearch" class="form-label"><strong>Tìm Phòng:</strong></label>
                                <%-- Tìm tên phòng hiện tại để hiển thị trong ô input --%>
                                <c:set var="selectedRoomText" value=""/>
                                <c:forEach var="room" items="${rooms}">
                                    <c:if test="${room.roomId == booking.roomId}">
                                        <c:set var="selectedRoomText" value="${room.roomName}"/>
                                    </c:if>
                                </c:forEach>
                                <input type="text" id="roomSearch" class="form-control mb-2" placeholder="Nhập tên phòng..." value="${selectedRoomText}">

                                <select class="form-select" id="roomId" name="roomId" required>
                                     <%-- Ban đầu chỉ tải phòng đang được chọn của booking này --%>
                                    <c:forEach var="room" items="${rooms}">
                                        <c:if test="${room.roomId == booking.roomId}">
                                            <option value="${room.roomId}" selected>${room.roomName} - ${room.roomType}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <%-- CHỌN NGÀY --%>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="checkIn" class="form-label"><strong>Ngày Nhận Phòng (Check-in):</strong></label>
                                <input type="date" class="form-control" id="checkIn" name="checkIn"
                                       value="<fmt:formatDate value='${booking.checkIn}' pattern='yyyy-MM-dd'/>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="checkOut" class="form-label"><strong>Ngày Trả Phòng (Check-out):</strong></label>
                                <input type="date" class="form-control" id="checkOut" name="checkOut"
                                       value="<fmt:formatDate value='${booking.checkOut}' pattern='yyyy-MM-dd'/>" required>
                            </div>
                        </div>

                        <%-- CHỌN TRẠNG THÁI --%>
                        <div class="mb-4">
                            <label for="status" class="form-label"><strong>Trạng thái Booking:</strong></label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="confirmed" ${booking.status == 'confirmed' ? 'selected' : ''}>Confirmed</option>
                                <option value="cancelled" ${booking.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                            </select>
                        </div>

                        <%-- CHỌN DỊCH VỤ --%>
                        <hr>
                        <h5 class="mb-3">Chỉnh Sửa Dịch Vụ</h5>
                        <div class="row">
                            <c:forEach var="service" items="${allServices}">
                                <c:set var="selectedServiceInfo" value="${null}"/>
                                   <c:forEach var="bs" items="${booking.services}">
                                    <c:if test="${bs.serviceId == service.serviceId}">
                                        <c:set var="selectedServiceInfo" value="${bs}"/>
                                    </c:if>
                                </c:forEach>

                                <div class="col-md-6 mb-3">
                                    <div class="form-check d-flex align-items-center">
                                        <input class="form-check-input service-checkbox" type="checkbox" name="serviceIds"
                                               value="${service.serviceId}" id="service_${service.serviceId}"
                                               ${not empty selectedServiceInfo ? 'checked' : ''}>
                                        <label class="form-check-label ms-2" for="service_${service.serviceId}">
                                            ${service.serviceName}
                                        </label>
                                    </div>
                                    <input type="number" class="form-control form-control-sm mt-1 service-quantity"
                                           name="quantity_${service.serviceId}"
                                           value="${not empty selectedServiceInfo ? selectedServiceInfo.quantity : '1'}"
                                           min="1"
                                           style="display: ${not empty selectedServiceInfo ? 'block' : 'none'};">
                                </div>
                            </c:forEach>
                        </div>

                        <%-- SUBMIT BUTTONS --%>
                        <hr class="mt-4">
                        <div class="d-flex justify-content-end">
                            <a href="${pageContext.request.contextPath}/admin/list-bookings" class="btn btn-secondary me-2">Hủy</a>
                            <button type="submit" class="btn btn-warning">Lưu Thay Đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // ẩn hiện ô dịch vụ
        $('.service-checkbox').on('change', function() {
            $(this).closest('.col-md-6').find('.service-quantity').toggle(this.checked);
        });


        const checkinInput = $('#checkIn');
        const checkoutInput = $('#checkOut');

        checkinInput.on('change', function() {
            if ($(this).val()) {
                let minCheckoutDate = new Date($(this).val());
                minCheckoutDate.setDate(minCheckoutDate.getDate() + 1);
                checkoutInput.attr('min', minCheckoutDate.toISOString().split('T')[0]);
                // Nếu ngày check-out hiện tại nhỏ hơn ngày check-in mới thì xóa đi
                if (checkoutInput.val() && checkoutInput.val() <= $(this).val()) {
                    checkoutInput.val('');
                }
            } else {
                checkoutInput.removeAttr('min');
            }
        });
        
        // tìm user
        let userSearchTimeout;
        const userSearchInput = $('#userSearch');
        const userSelect = $('#userId');
        const userSearchURL = '${pageContext.request.contextPath}/userSearch';

        userSearchInput.on('keyup', () => {
            clearTimeout(userSearchTimeout);
            const keyword = userSearchInput.val().trim();
            userSearchTimeout = setTimeout(() => {
                fetch(userSearchURL + '?search=' + encodeURIComponent(keyword))
                    .then(response => response.text())
                    .then(html => {
                        userSelect.html(html || '<option value="" disabled selected>-- Không tìm thấy --</option>');
                        userSelect.niceSelect('update');
                    });
            }, 300); 
        });

        // tìm room
        let roomSearchTimeout;
        const roomSearchInput = $('#roomSearch');
        const roomSelect = $('#roomId');
        const roomSearchURL = '${pageContext.request.contextPath}/searchRoom';
        
        roomSearchInput.on('keyup', () => {
            clearTimeout(roomSearchTimeout);
            const keyword = roomSearchInput.val().trim();
            roomSearchTimeout = setTimeout(() => {
                fetch(roomSearchURL + '?q=' + encodeURIComponent(keyword))
                    .then(response => response.text())
                    .then(html => {
                        roomSelect.html(html || '<option value="" disabled selected>-- Không tìm thấy --</option>');
                        roomSelect.niceSelect('update');
                    });
            }, 300);
        });

        // cập nhật input
        userSelect.on('change', function() {
            const selectedText = $(this).find('option:selected').text();
            userSearchInput.val(selectedText);
        });

        roomSelect.on('change', function() {
            const selectedText = $(this).find('option:selected').text();
            roomSearchInput.val(selectedText);
        });

        $('select.form-select').niceSelect();
    });
</script>

<jsp:include page="../header_footer/footer.jsp"/>