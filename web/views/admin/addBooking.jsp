<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="Thêm Booking Mới" scope="request"/>
<jsp:include page="../header_footer/header.jsp"/>

<style>
    body {
        font-family: 'Poppins', sans-serif;
        background-color: #f8f9fa;
    }

    .card {
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
    }

    .card-header {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: #fff;
        font-weight: 600;
        font-size: 1.4rem;
        text-align: center;
    }

    .form-label {
        font-weight: 500;
        color: #495057;
    }

    .form-control, .form-select {
        border-radius: 8px;
        padding: 0.6rem 0.75rem;
        border: 1px solid #ced4da;
    }

    .form-control:focus, .form-select:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
    }
    
    .service-checkbox {
        width: 1.25rem;
        height: 1.25rem;
        cursor: pointer;
    }

    .service-quantity {
        border-radius: 6px;
        padding: 0.4rem 0.5rem;
    }

    .btn-primary {
        background: linear-gradient(135deg, #667eea, #764ba2);
        border: none;
        border-radius: 25px;
        font-weight: 500;
        padding: 0.6rem 1.5rem;
        transition: all 0.3s ease;
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(118, 75, 162, 0.4);
    }

    .btn-secondary {
        border-radius: 25px;
        padding: 0.6rem 1.5rem;
        font-weight: 500;
    }

    h5 {
        color: #333;
        font-weight: 600;
        margin-bottom: 1rem;
    }
</style>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-lg">
                <div class="card-header bg-primary text-white">
                    <h2 class="mb-0">Tạo Booking Mới cho Khách sạn</h2>
                </div>
                <div class="card-body p-4">

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            ${error}
                        </div>
                    </c:if>

                    
                    
                    <form action="${pageContext.request.contextPath}/admin/add-booking" method="POST" id="addBookingForm">
                        <!-- chon user va phong -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="userSearch" class="form-label"><strong>Tìm Khách Hàng:</strong></label>
                                <%-- lay la ten khach da chon --%>
                                <c:set var="selectedUserText" value="" />
                                
                                <c:forEach var="user" items="${users}">
                                    <c:if test="${param.userId == user.userId}">
                                        <c:set var="selectedUserText" value="${user.fullName}" />
                                    </c:if>
                                </c:forEach>
                                
                                <input type="text" id="userSearch" class="form-control mb-2" placeholder="Nhập tên khách hàng..." value="${selectedUserText}">
                                
                                <select class="form-select" id="userId" name="userId" required>
                                    <option value="" disabled ${empty param.userId ? 'selected' : ''}>-- Kết quả tìm kiếm sẽ hiện ở đây --</option>
                                    <%-- Nếu có lỗi, tải lại danh sách và chọn user cũ --%>
                                    <c:forEach var="user" items="${users}">
                                        <option value="${user.userId}" ${param.userId == user.userId ? 'selected' : ''}>${user.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="roomSearch" class="form-label"><strong>Tìm Phòng:</strong></label>
                                 <%-- Lấy lại tên phòng đã chọn --%>
                                <c:set var="selectedRoomText" value="" />
                                <c:forEach var="room" items="${rooms}">
                                    <c:if test="${param.roomId == room.roomId}">
                                        <c:set var="selectedRoomText" value="${room.roomName} - ${room.roomType}" />
                                    </c:if>
                                </c:forEach>
                                
                                <input type="text" id="roomSearch" class="form-control mb-2" placeholder="Nhập tên phòng..." value="${selectedRoomText}">

                                <select class="form-select" id="roomId" name="roomId" required>
                                    <option value="" disabled ${empty param.roomId ? 'selected' : ''}>-- Kết quả tìm kiếm sẽ hiện ở đây --</option>
                                    <%-- Nếu có lỗi, tải lại danh sách và chọn phòng cũ --%>
                                    <c:forEach var="room" items="${rooms}">
                                        <option value="${room.roomId}" ${param.roomId == room.roomId ? 'selected' : ''}>${room.roomName} - ${room.roomType}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- chon ngay -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="checkIn" class="form-label"><strong>Ngày Nhận Phòng (Check-in):</strong></label>
                                <input type="date" class="form-control" id="checkIn" name="checkIn" value="${param.checkIn}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="checkOut" class="form-label"><strong>Ngày Trả Phòng (Check-out):</strong></label>
                                <input type="date" class="form-control" id="checkOut" name="checkOut" value="${param.checkOut}" required>
                            </div>
                        </div>

                        <!-- chon dich vu -->
                        <hr>
                        <h5 class="mb-3">Thêm Dịch Vụ (Tùy chọn)</h5>
                        <div class="row">
                            <c:forEach var="service" items="${services}">
                                <div class="col-md-6 mb-3">
                                    <%-- Kiểm tra và giữ lại các dịch vụ đã check --%>
                                    <c:set var="isChecked" value="false" />
                                    <c:if test="${not empty paramValues.serviceIds}">
                                        <c:forEach var="selectedServiceId" items="${paramValues.serviceIds}">
                                            <c:if test="${selectedServiceId eq service.serviceId}">
                                                <c:set var="isChecked" value="true" />
                                            </c:if>
                                        </c:forEach>
                                    </c:if>

                                    <div class="form-check d-flex align-items-center">
                                        <input class="form-check-input service-checkbox mr-2" type="checkbox" name="serviceIds" 
                                               value="${service.serviceId}" id="service_${service.serviceId}" ${isChecked ? 'checked' : ''}>
                                        <label class="form-check-label" for="service_${service.serviceId}">${service.serviceName}</label>
                                    </div>
                                    <input type="number" class="form-control form-control-sm mt-1 service-quantity" 
                                           name="quantity_${service.serviceId}" 
                                           value="${not empty param['quantity_'.concat(service.serviceId)] ? param['quantity_'.concat(service.serviceId)] : '1'}" 
                                           min="1" style="display: ${isChecked ? 'block' : 'none'};">
                                </div>
                            </c:forEach>
                        </div>

                        <!-- submit button -->
                        <hr class="mt-4">
                        <div class="d-flex justify-content-end">
                            <a href="${pageContext.request.contextPath}/admin/list-bookings" class="btn btn-secondary me-2">Hủy</a>
                            <button type="submit" class="btn btn-primary">Tạo Booking</button>
                        </div>
                    </form>
                            
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        $('.service-checkbox').on('change', function() {
            $(this).closest('.col-md-6').find('.service-quantity').toggle(this.checked);
        });

        const checkinInput = $('#checkIn');
        const checkoutInput = $('#checkOut');
        const today = new Date().toISOString().split('T')[0];
        checkinInput.attr('min', today);

        checkinInput.on('change', function() {
            if ($(this).val()) {
                let minCheckoutDate = new Date($(this).val());
                minCheckoutDate.setDate(minCheckoutDate.getDate() + 1);
                checkoutInput.attr('min', minCheckoutDate.toISOString().split('T')[0]);
                if (checkoutInput.val() && checkoutInput.val() <= $(this).val()) {
                    checkoutInput.val('');
                }
            } else {
                checkoutInput.removeAttr('min');
            }
        });

        // logic tim kiem
        // tim user
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
        //tim phong
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

        // cap nhat input
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