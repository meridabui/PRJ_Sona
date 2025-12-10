
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Chi Tiết Phòng - ${room.roomName}" scope="request"/>
<jsp:include page="../header_footer/header.jsp" />

<style>
    .room-detail-hero {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 2rem 0;
        margin-bottom: 2rem;
    }
    
    .room-image-wrapper {
        position: relative;
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 20px 60px rgba(0,0,0,0.25);
        transition: transform 0.3s ease;
    }
    
    .room-image-wrapper:hover {
        transform: translateY(-5px);
    }
    
    .room-image-wrapper img {
        width: 100%;
        height: auto;
        display: block;
    }
    
    .room-badge {
        position: absolute;
        top: 20px;
        right: 20px;
        background: rgba(255,255,255,0.95);
        padding: 8px 16px;
        border-radius: 25px;
        font-weight: 600;
        color: #667eea;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
    }
    
    .info-card {
        background: #fff;
        border-radius: 20px;
        padding: 2rem;
        box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        height: 100%;
    }
    
    .price-tag {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        color: white;
        padding: 1.5rem;
        border-radius: 15px;
        margin: 1.5rem 0;
        text-align: center;
    }
    
    .price-tag h2 {
        margin: 0;
        font-size: 2.5rem;
        font-weight: 800;
    }
    
    .price-tag .price-label {
        font-size: 0.9rem;
        opacity: 0.9;
        margin-top: 0.5rem;
    }
    
    .btn-book-now {
        background: linear-gradient(135deg, #ffd89b 0%, #19547b 100%);
        border: none;
        padding: 1rem 2rem;
        font-size: 1.1rem;
        font-weight: 700;
        border-radius: 50px;
        color: white;
        transition: all 0.3s ease;
        box-shadow: 0 8px 25px rgba(255,193,7,0.4);
    }
    
    .btn-book-now:hover {
        transform: translateY(-3px);
        box-shadow: 0 12px 35px rgba(255,193,7,0.5);
        color: white;
    }
    
    .feature-item {
        display: flex;
        align-items: center;
        padding: 1rem;
        margin-bottom: 0.8rem;
        background: #f8f9fa;
        border-radius: 12px;
        transition: all 0.3s ease;
    }
    
    .feature-item:hover {
        background: #e9ecef;
        transform: translateX(5px);
    }
    
    .feature-icon {
        width: 45px;
        height: 45px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 1rem;
        color: white;
        font-size: 1.2rem;
    }
    
    .amenity-card {
        background: white;
        border-radius: 20px;
        padding: 2rem;
        box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        margin-top: 3rem;
    }
    
    .amenity-card h4 {
        color: #667eea;
        margin-bottom: 1.5rem;
        font-weight: 700;
    }
    
    .amenity-item {
        display: flex;
        align-items: center;
        padding: 0.8rem;
        margin-bottom: 0.5rem;
        border-left: 3px solid #667eea;
        background: #f8f9ff;
        border-radius: 8px;
        transition: all 0.3s ease;
    }
    
    .amenity-item:hover {
        background: #e9ecff;
        padding-left: 1.2rem;
    }
    
    .amenity-item i {
        font-size: 1.3rem;
        margin-right: 1rem;
        width: 30px;
        text-align: center;
    }
    
    .room-title {
        font-size: 2.5rem;
        font-weight: 800;
        color: #2d3748;
        margin-bottom: 0.5rem;
    }
    
    .room-type-badge {
        display: inline-block;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 0.5rem 1.5rem;
        border-radius: 25px;
        font-size: 0.9rem;
        font-weight: 600;
        margin-bottom: 1rem;
    }
    
    .capacity-info {
        display: flex;
        align-items: center;
        color: #718096;
        font-size: 1rem;
        margin-bottom: 1rem;
    }
    
    .capacity-info i {
        margin-right: 0.5rem;
        color: #667eea;
    }
    
    .description-text {
        color: #4a5568;
        line-height: 1.8;
        font-size: 1rem;
        margin: 1.5rem 0;
    }
    
    .section-divider {
        height: 3px;
        background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
        border: none;
        border-radius: 3px;
        margin: 1.5rem 0;
    }
</style>

<div class="container my-5">
    <div class="row g-4">
        <!-- Cột hình ảnh -->
        <div class="col-lg-7">
            <div class="room-image-wrapper">
                <div class="room-badge">
                    <i class="fas fa-star text-warning"></i> Phòng cao cấp
                </div>
                <img src="${room.imageUrl}" alt="Hình ảnh ${room.roomName}">
            </div>
        </div>
        
        <!-- Cột thông tin và đặt phòng -->
        <div class="col-lg-5">
            <div class="info-card">
                <h1 class="room-title">${room.roomName}</h1>
                <span class="room-type-badge">${room.roomType}</span>
                
                <div class="capacity-info">
                    <i class="fas fa-users"></i>
                    <span>Sức chứa: <strong>${room.capacity} người</strong></span>
                </div>
                
                <hr class="section-divider">
                
                <div class="price-tag">
                    <h2>${String.format("%,.0f", room.price)} VND</h2>
                    <div class="price-label">
                        <i class="fas fa-moon me-1"></i>Giá mỗi đêm
                    </div>
                </div>
                
                <p class="description-text">${room.description}</p>
                
                <!-- Nút Đặt Phòng -->
                <div class="d-grid gap-2 mt-4">
                    <a href="${pageContext.request.contextPath}/book-room?room_id=${room.roomId}" class="btn btn-book-now">
                        <i class="fas fa-calendar-check me-2"></i>Đặt Phòng Ngay
                    </a>
                </div>
                
                <div class="text-center mt-3">
                    <small class="text-muted">
                        <i class="fas fa-shield-alt me-1"></i>
                        Đặt phòng an toàn & bảo mật
                    </small>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Phần thông tin chi tiết và tiện nghi -->
    <div class="row mt-5">
        <div class="col-12">
            <div class="amenity-card">
                <h3 class="text-center mb-4" style="color: #2d3748; font-weight: 800;">
                    <i class="fas fa-star-of-life me-2" style="color: #667eea;"></i>
                    Thông Tin & Tiện Nghi
                </h3>
                
                <div class="row g-4">
                    <!-- Thông tin cơ bản -->
                    <div class="col-md-6">
                        <h4><i class="fas fa-info-circle me-2"></i>Thông tin cơ bản</h4>
                        
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="fas fa-ruler-combined"></i>
                            </div>
                            <div>
                                <strong>Diện tích</strong>
                                <div class="text-muted">35 m²</div>
                            </div>
                        </div>
                        
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div>
                                <strong>Số khách tối đa</strong>
                                <div class="text-muted">2 người lớn, 1 trẻ em</div>
                            </div>
                        </div>
                        
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="fas fa-bed"></i>
                            </div>
                            <div>
                                <strong>Loại giường</strong>
                                <div class="text-muted">1 giường King size</div>
                            </div>
                        </div>
                        
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="fas fa-eye"></i>
                            </div>
                            <div>
                                <strong>Hướng nhìn</strong>
                                <div class="text-muted">View hướng biển tuyệt đẹp</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Tiện nghi -->
                    <div class="col-md-6">
                        <h4><i class="fas fa-concierge-bell me-2"></i>Tiện nghi nổi bật</h4>
                        
                        <div class="amenity-item">
                            <i class="fas fa-wifi text-success"></i>
                            <span>Wi-Fi miễn phí tốc độ cao</span>
                        </div>
                        
                        <div class="amenity-item">
                            <i class="fas fa-tv text-primary"></i>
                            <span>TV màn hình phẳng 50-inch</span>
                        </div>
                        
                        <div class="amenity-item">
                            <i class="fas fa-snowflake text-info"></i>
                            <span>Điều hòa không khí hiện đại</span>
                        </div>
                        
                        <div class="amenity-item">
                            <i class="fas fa-bath text-primary"></i>
                            <span>Bồn tắm & vòi sen riêng biệt</span>
                        </div>
                        
                        <div class="amenity-item">
                            <i class="fas fa-coffee text-warning"></i>
                            <span>Máy pha trà & cà phê cao cấp</span>
                        </div>
                        
                        <div class="amenity-item">
                            <i class="fas fa-lock text-danger"></i>
                            <span>Két an toàn cá nhân</span>
                        </div>
                        
                        <div class="amenity-item">
                            <i class="fas fa-wind text-info"></i>
                            <span>Máy sấy tóc chuyên dụng</span>
                        </div>
                        
                        <div class="amenity-item">
                            <i class="fas fa-concierge-bell text-success"></i>
                            <span>Dịch vụ phòng 24/7</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../header_footer/footer.jsp" />