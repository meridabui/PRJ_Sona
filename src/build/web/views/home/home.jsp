<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="Trang Chủ - Chào Mừng Bạn Đến Sona Resort" scope="request"/>
<jsp:include page="../header_footer/header.jsp" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>



<!--  Home SECTION  -->
<!-- Hero SECTION -->
<section class="hero-section">


    <div class="container">
        <div class="row align-items-center">
            <!-- Hero Text -->
            <div class="col-lg-6 text-white">
                <div class="hero-text">
                    <h1 class="display-4 font-weight-bold">Sona Resort</h1>
                    <p class="lead">Trải nghiệm đẳng cấp với dịch vụ cao cấp và không gian thư giãn tuyệt vời.</p>
                    <a href="${pageContext.request.contextPath}/list-rooms" class="btn btn-warning btn-lg mt-3">
                        <i class="fas fa-bed mr-2"></i> Đặt Phòng Ngay
                    </a>
                </div>
            </div>

            <!-- Booking Form -->
            <div class="col-lg-5 offset-lg-1">
                <div class="booking-form bg-white p-4 rounded shadow-lg">
                    <h3 class="mb-4 font-weight-bold text-center text-dark">Đặt Phòng Nhanh</h3>

                    <form action="${pageContext.request.contextPath}/list-rooms" method="GET">
                        <div class="form-group">
                            <label for="checkin">Ngày nhận phòng</label>
                            <input type="date" class="form-control" id="checkin" name="checkin_date" required>
                        </div>
                        <div class="form-group">
                            <label for="checkout">Ngày trả phòng</label>
                            <input type="date" class="form-control" id="checkout" name="checkout_date" required>
                        </div>
                        <div class="form-group">
                            <label for="guests" style="padding-top: 10px; padding-left: 8px">Số khách</label>
                            <select id="guests" class="form-control" name="guests">
                                <option>1</option>
                                <option>2</option>
                                <option>3</option>
                                <option>4+</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="minPrice" style="padding-top: 10px; padding-left: 8px">Giá từ (VNĐ)</label>
                            <input type="number" class="form-control" id="minPrice" name="minPrice"
                                   value="${minPrice != null ? minPrice : ''}" min="0" placeholder="VD: 500000">
                        </div>
                        <div class="form-group">
                            <label for="maxPrice" style="padding-top: 10px; padding-left: 8px">Đến (VNĐ)</label>
                            <input type="number" class="form-control" id="maxPrice" name="maxPrice"
                                   value="${maxPrice != null ? maxPrice : ''}" min="0" placeholder="VD: 2000000">
                        </div>

                        <div class="form-group mb-0 text-center">
                            <button type="submit" class="btn btn-warning btn-block font-weight-bold">Kiểm Tra Phòng</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
    <div class="hero-slider owl-carousel">
        <div class="hs-item set-bg" data-setbg="img/hero/hero-1.jpg"></div>
        <div class="hs-item set-bg" data-setbg="img/hero/hero-2.jpg"></div>
        <div class="hs-item set-bg" data-setbg="img/hero/hero-3.jpg"></div>
    </div>

</section>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const checkinInput = document.getElementById('checkin');
        const checkoutInput = document.getElementById('checkout');

        // --- B1: Lấy ngày hôm nay ---
        const today = new Date();
        const todayStr = today.toISOString().split('T')[0]; // YYYY-MM-DD
        checkinInput.setAttribute('min', todayStr);

        // --- B2: Khi check-in thay đổi ---
        checkinInput.addEventListener('change', function () {
            const checkinDateValue = checkinInput.value;
            if (!checkinDateValue) {
                checkoutInput.removeAttribute('min');
                return;
            }

            // Tối thiểu check-out = checkin + 1 ngày
            const minCheckout = new Date(checkinDateValue);
            minCheckout.setDate(minCheckout.getDate() + 1);
            const minCheckoutStr = minCheckout.toISOString().split('T')[0];

            checkoutInput.setAttribute('min', minCheckoutStr);

            // Nếu check-out hiện tại không hợp lệ → reset
            if (checkoutInput.value && checkoutInput.value <= checkinDateValue) {
                checkoutInput.value = '';
            }
        });

        // --- B3: Khi form load, nếu check-in đã có sẵn, set lại min cho check-out ---
        if (checkinInput.value) {
            checkinInput.dispatchEvent(new Event('change'));
        }
    });
</script>



<section class="py-5">
    <div class="container text-center">
        <h2 class="mb-4 section-title">Chào Mừng Tới Sona Resort</h2>
        <p class="lead text-muted mx-auto" style="max-width: 800px;">
            Nằm ở trung tâm thành phố,  Sona Resort là điểm đến lý tưởng cho cả khách du lịch và doanh nhân. Với thiết kế sang trọng, dịch vụ chuyên nghiệp và tiện nghi hiện đại, chúng tôi cam kết mang đến cho bạn những trải nghiệm đáng nhớ.
        </p>
    </div>
</section>


<section class="py-5 bg-light">
    <div class="container">
        <h2 class="text-center mb-5 section-title">Phòng Nổi Bật Của Chúng Tôi</h2>
        <div class="row">
            <c:if test="${not empty featuredRooms}">
                <c:forEach var="room" items="${featuredRooms}">
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card h-100 shadow-sm border-0 room-card">
                            <img src="${room.imageUrl}" class="card-img-top" alt="${room.roomName}">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">${room.roomName}</h5>
                                <p class="card-text text-muted small">${room.roomType}</p>
                                <div class="mt-auto">
                                    <p class="h5 text-primary fw-bold">
                                        <fmt:formatNumber value="${room.price}" type="number" maxFractionDigits="0"/> VNĐ/đêm
                                    </p>
                                    <a href="${pageContext.request.contextPath}/room-detail?id=${room.roomId}" class="btn btn-outline-primary w-100 mt-2">Xem Chi Tiết</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
        </div>
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/list-rooms" class="btn btn-dark btn-lg">Xem Tất Cả Các Phòng</a>
        </div>
    </div>
</section>


<section class="py-5">
    <div class="container">
        <h2 class="text-center mb-5 section-title">Dịch Vụ & Tiện Ích</h2>
        <div class="row text-center">
            <div class="col-md-3 mb-4">
                <i class="fas fa-wifi service-icon mb-3"></i>
                <h4>Wi-Fi Tốc Độ Cao</h4>
                <p class="text-muted">Miễn phí tại tất cả các khu vực trong khách sạn.</p>
            </div>
            <div class="col-md-3 mb-4">
                <i class="fas fa-swimmer service-icon mb-3"></i>
                <h4>Hồ Bơi Vô Cực</h4>
                <p class="text-muted">Thư giãn và ngắm nhìn toàn cảnh thành phố.</p>
            </div>
            <div class="col-md-3 mb-4">
                <i class="fas fa-utensils service-icon mb-3"></i>
                <h4>Nhà Hàng & Bar</h4>
                <p class="text-muted">Trải nghiệm ẩm thực tinh tế với thực đơn đa dạng.</p>
            </div>
            <div class="col-md-3 mb-4">
                <i class="fas fa-spa service-icon mb-3"></i>
                <h4>Dịch Vụ Spa</h4>
                <p class="text-muted">Các liệu pháp chăm sóc sức khỏe và sắc đẹp chuyên nghiệp.</p>
            </div>
        </div>
    </div>
</section>
<jsp:include page="../header_footer/footer.jsp" />