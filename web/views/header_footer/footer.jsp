<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.Year" %>

<footer class="bg-dark text-white pt-5 pb-4">
    <div class="container">
        <!-- Hàng chứa các cột thông tin chính -->
        <div class="row mt-3">

            <!-- Cột 1: Giới thiệu về khách sạn -->
            <div class="col-md-3 col-lg-4 col-xl-3 mx-auto mb-4">
                <h6 class="text-uppercase fw-bold mb-4 text-warning">
                    <i class="fas fa-hotel me-2"></i>Sona Resort
                </h6>
                <p>
                    Tận hưởng không gian sang trọng và dịch vụ đẳng cấp. Chúng tôi cam kết mang đến cho bạn một kỳ nghỉ khó quên với những trải nghiệm tuyệt vời nhất.
                </p>
            </div>

            <!-- Cột 2: Các liên kết trang chính -->
            <div class="col-md-2 col-lg-2 col-xl-2 mx-auto mb-4">
                <h6 class="text-uppercase fw-bold mb-4 text-warning">
                    Khám phá
                </h6>
                <p><a href="${pageContext.request.contextPath}/home" class="text-white-50 text-decoration-none">Trang Chủ</a></p>
                <p><a href="${pageContext.request.contextPath}/list-rooms" class="text-white-50 text-decoration-none">Các Loại Phòng</a></p>
                <p><a href="${pageContext.request.contextPath}/services" class="text-white-50 text-decoration-none">Dịch Vụ</a></p>
                <p><a href="#" class="text-white-50 text-decoration-none">Ưu Đãi</a></p>
            </div>

            <!-- Cột 3: Các liên kết hữu ích -->
            <div class="col-md-3 col-lg-2 col-xl-2 mx-auto mb-4">
                <h6 class="text-uppercase fw-bold mb-4 text-warning">
                    Hỗ trợ
                </h6>
                <p><a href="#" class="text-white-50 text-decoration-none">Trung tâm trợ giúp</a></p>
                <p><a href="#" class="text-white-50 text-decoration-none">Điều khoản dịch vụ</a></p>
                <p><a href="#" class="text-white-50 text-decoration-none">Chính sách bảo mật</a></p>
                <p><a href="#" class="text-white-50 text-decoration-none">Câu hỏi thường gặp</a></p>
            </div>

            <!-- Cột 4: Thông tin liên hệ -->
            <div class="col-md-4 col-lg-3 col-xl-3 mx-auto mb-md-0 mb-4">
                <h6 class="text-uppercase fw-bold mb-4 text-warning">
                    Liên hệ
                </h6>
                <p><i class="fas fa-home me-3"></i> Trung tâm công nghệ cao Hòa Lạc </p>
                <p><i class="fas fa-envelope me-3"></i> info@Sona Resort.com</p>
                <p><i class="fas fa-phone me-3"></i> +84 28 3812 3456</p>
            </div>
        </div>

        <!-- Dòng kẻ ngang phân cách -->
        <hr class="my-4">

        <!-- Hàng chứa bản quyền và mạng xã hội -->
        <div class="row d-flex align-items-center">
            <!-- Cột bản quyền -->
            <div class="col-md-7 col-lg-8 text-center text-md-start">
                
            </div>

            <!-- Cột mạng xã hội -->
            <div class="col-md-5 col-lg-4 text-center text-md-end">
                <a href="#" class="btn btn-outline-light btn-floating m-1" role="button"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="btn btn-outline-light btn-floating m-1" role="button"><i class="fab fa-twitter"></i></a>
                <a href="#" class="btn btn-outline-light btn-floating m-1" role="button"><i class="fab fa-instagram"></i></a>
                <a href="#" class="btn btn-outline-light btn-floating m-1" role="button"><i class="fab fa-youtube"></i></a>
            </div>
        </div>
    </div>
</footer>
<!-- jQuery (Phiên bản đầy đủ) -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<!-- Popper.js (Bắt buộc cho dropdown của Bootstrap 4) -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>

<!-- Bootstrap 4.4.1 JS -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>

<!-- Các plugin khác -->
<script src="${pageContext.request.contextPath}/js/jquery.magnific-popup.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.nice-select.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.slicknav.js"></script>
<script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
<script src="${pageContext.request.contextPath}/js/main.js"></script>

</body>
</html>