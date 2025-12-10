<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Danh Sách Phòng" scope="request"/>

<jsp:include page="../header_footer/header.jsp" />

<!-- Css Styles -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/font-awesome.min.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/elegant-icons.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/flaticon.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/owl.carousel.min.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/nice-select.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/magnific-popup.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/slicknav.min.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" type="text/css">

<div class="container my-5">
    <div class="text-center mb-5">
        <h1>Các Loại Phòng Của Chúng Tôi</h1>
        <p class="lead">Chọn cho mình không gian nghỉ dưỡng lý tưởng.</p>
    </div>

    <!-- Thanh tim kiem -->

    <div class="card card-body mb-5 shadow-sm">
        <form action="${pageContext.request.contextPath}/list-rooms" method="GET">
            <div class="row g-3 align-items-end">
                <div class="col-lg-4">
                    <label for="keyword" class="form-label">Tên phòng hoặc loại phòng</label>
                    <input type="text" class="form-control" id="keyword" name="keyword"
                           placeholder="VD: Phòng Tổng Thống..." value="${param.keyword}">
                </div>

                <%-- Ô giá --%>
                <div class="col-lg-3">
                    <label for="minPriceDisplay" class="form-label">Giá từ (VND)</label>
                    <%-- Input này chỉ để hiển thị cho người dùng --%>
                    <input type="text" class="form-control price-format" id="minPriceDisplay"
                           placeholder="0" value="<fmt:formatNumber value="${param.minPrice}" pattern="#,##0"/>">
                    <%-- Input ẩn này mới thực sự gửi dữ liệu đi --%>
                    <input type="hidden" id="minPrice" name="minPrice" value="${param.minPrice}">
                </div>

                <%-- Ô giá--%>
                <div class="col-lg-3">
                    <label for="maxPriceDisplay" class="form-label">Giá đến (VND)</label>
                     <%-- Input này chỉ để hiển thị cho người dùng --%>
                    <input type="text" class="form-control price-format" id="maxPriceDisplay"
                           placeholder="10,000,000" value="<fmt:formatNumber value="${param.maxPrice}" pattern="#,##0"/>">
                    <%-- Input ẩn này mới thực sự gửi dữ liệu đi --%>
                    <input type="hidden" id="maxPrice" name="maxPrice" value="${param.maxPrice}">
                </div>

                <div class="col-lg-2 d-grid">
                    <button type="submit" class="btn btn-primary fw-bold">Tìm Kiếm</button>
                </div>
            </div>
        </form>
    </div>


    <!-- danh sách phòng -->
    <div class="row">
        <c:if test="${empty listRooms}">
             <div class="col-12 text-center">
                 <p class="lead text-muted">Không tìm thấy phòng nào phù hợp với yêu cầu của bạn.</p>
             </div>
        </c:if>

        <c:forEach var="room" items="${listRooms}">
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card h-100 shadow-sm">
                    <img src="${room.imageUrl}" class="card-img-top" alt="${room.roomName}" style="height: 250px; object-fit: cover;">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">${room.roomName}</h5>
                        <p class="card-text text-muted">${room.roomType}</p>
                        <p class="card-text">Số lượng khách: ${room.capacity} người</p>
                        <h6 class="text-primary mt-auto">
                            <fmt:formatNumber value="${room.price}" type="currency" currencyCode="VND" maxFractionDigits="0" /> / đêm
                        </h6>
                    </div>
                    <div class="card-footer bg-white border-0 text-center">
                        <div class="btn-group w-100">
                            <a href="${pageContext.request.contextPath}/room-detail?id=${room.roomId}" class="btn btn-outline-primary">Xem Chi Tiết</a>
                            <a href="${pageContext.request.contextPath}/book-room?room_id=${room.roomId}" class="btn btn-warning fw-bold">Đặt Ngay</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>


    <!-- phân trang -->

    <c:if test="${totalPages > 1}">
        <div class="row mt-4">
            <div class="col-12 d-flex justify-content-center">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                             <c:url var="prevUrl" value="/list-rooms">
                                <c:param name="page" value="${currentPage - 1}" />
                                <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}" /></c:if>
                                <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}" /></c:if>
                                <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}" /></c:if>
                             </c:url>
                            <a class="page-link" href="${prevUrl}" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <c:url var="pageUrl" value="/list-rooms">
                                    <c:param name="page" value="${i}" />
                                    <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}" /></c:if>
                                    <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}" /></c:if>
                                    <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}" /></c:if>
                                </c:url>
                                <a class="page-link" href="${pageUrl}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <c:url var="nextUrl" value="/list-rooms">
                                <c:param name="page" value="${currentPage + 1}" />
                                <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}" /></c:if>
                                <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}" /></c:if>
                                <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}" /></c:if>
                            </c:url>
                            <a class="page-link" href="${nextUrl}" aria-label="Next"><span aria-hidden="true">&raquo;</span></a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="../header_footer/footer.jsp" />


<!-- script định dạng số tiền -->

<script>
document.addEventListener("DOMContentLoaded", function() {
    // Hàm để định dạng số
    function formatNumber(n) {
        // Loại bỏ tất cả các ký tự không phải là số
        const rawValue = n.toString().replace(/[^0-9]/g, '');
        // Định dạng lại với dấu phẩy
        return rawValue.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    // Hàm để xử lý sự kiện cho các ô input giá
    function setupPriceInput(displayInputId, hiddenInputId) {
        const displayInput = document.getElementById(displayInputId);
        const hiddenInput = document.getElementById(hiddenInputId);

        if (displayInput) {
            // Xử lý khi người dùng gõ
            displayInput.addEventListener('input', function(e) {
                // Lấy giá trị hiện tại, loại bỏ dấu phẩy
                const rawValue = e.target.value.replace(/,/g, '');
                
                // Cập nhật giá trị cho ô input ẩn (để gửi đi)
                hiddenInput.value = rawValue;

                // Định dạng lại và hiển thị trong ô input người dùng thấy
                e.target.value = formatNumber(rawValue);
            });
        }
    }

    setupPriceInput('minPriceDisplay', 'minPrice');
    setupPriceInput('maxPriceDisplay', 'maxPrice');
});
</script>