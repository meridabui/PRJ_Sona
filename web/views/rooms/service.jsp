<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Dịch Vụ Của Chúng Tôi - Khách Sạn ABC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-gold: #D4AF37;
            --dark-blue: #1a2332;
            --light-gray: #f8f9fa;
            --accent-blue: #2c5f8d;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light-gray);
        }

        .hero-section {
            background: linear-gradient(135deg, var(--dark-blue) 0%, var(--accent-blue) 100%);
            color: white;
            padding: 80px 0 60px;
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.05)" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,138.7C960,139,1056,117,1152,101.3C1248,85,1344,75,1392,69.3L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat bottom;
            background-size: cover;
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .hero-subtitle {
            font-size: 1.3rem;
            opacity: 0.95;
            max-width: 700px;
            margin: 0 auto;
        }

        .services-container {
            padding: 60px 0;
        }

        .service-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            height: 100%;
            border: none;
            position: relative;
        }

        .service-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-gold), var(--accent-blue));
            transform: scaleX(0);
            transition: transform 0.4s ease;
        }

        .service-card:hover::before {
            transform: scaleX(1);
        }

        .service-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .service-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, var(--primary-gold), #f4d77e);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 32px;
            color: white;
            transition: all 0.3s ease;
        }

        .service-card:hover .service-icon {
            transform: rotate(360deg) scale(1.1);
        }

        .card-body {
            padding: 30px 25px;
        }

        .card-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark-blue);
            margin-bottom: 15px;
            text-align: center;
        }

        .card-price {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--primary-gold);
            text-align: center;
            margin-bottom: 15px;
        }

        .price-label {
            font-size: 0.9rem;
            color: #6c757d;
            font-weight: 400;
        }

        .card-text {
            color: #555;
            line-height: 1.7;
            text-align: center;
            font-size: 0.95rem;
        }

        .empty-state {
            padding: 80px 20px;
            text-align: center;
        }

        .empty-state-icon {
            font-size: 80px;
            color: var(--primary-gold);
            opacity: 0.6;
            margin-bottom: 20px;
        }

        .empty-state-text {
            font-size: 1.2rem;
            color: #666;
        }

        .section-badge {
            display: inline-block;
            background: rgba(212, 175, 55, 0.1);
            color: var(--primary-gold);
            padding: 8px 20px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            
            .hero-subtitle {
                font-size: 1.1rem;
            }
        }

        /* Service category icons mapping - customize based on your service types */
        .icon-spa { color: #e91e63; }
        .icon-restaurant { color: #ff5722; }
        .icon-pool { color: #00bcd4; }
        .icon-gym { color: #4caf50; }
        .icon-wifi { color: #2196f3; }
        .icon-parking { color: #607d8b; }
        .icon-laundry { color: #9c27b0; }
        .icon-transport { color: #ff9800; }
    </style>
</head>
<body>
    <jsp:include page="../header_footer/header.jsp" />
    
    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container">
            <div class="hero-content text-center">
                <span class="section-badge">Dịch Vụ Cao Cấp</span>
                <h1 class="hero-title" style="color: white">Dịch Vụ & Tiện Ích</h1>
                <p class="hero-subtitle" style="color: wheat">
                    Trải nghiệm sự sang trọng và tiện nghi đẳng cấp thế giới với bộ sưu tập dịch vụ được thiết kế để mang đến kỳ nghỉ hoàn hảo nhất cho bạn
                </p>
            </div>
        </div>
    </div>

    <!-- Services Section -->
    <div class="services-container">
        <div class="container">
            <c:choose>
                <c:when test="${not empty listServices}">
                    <div class="row g-4">
                        <c:forEach var="service" items="${listServices}" varStatus="status">
                            <div class="col-lg-4 col-md-6">
                                <div class="card service-card">
                                    <div class="card-body">
                                        <!-- Service Icon -->
                                        <div class="service-icon">
                                            <i class="fas fa-concierge-bell"></i>
                                        </div>
                                        
                                        <!-- Service Name -->
                                        <h5 class="card-title">${service.serviceName}</h5>
                                        
                                        <!-- Service Price -->
                                        <div class="card-price">
                                            <span class="price-label">Từ </span>${String.format("%,.0f", service.price)} VND
                                        </div>
                                        
                                        <!-- Service Description -->
                                        <p class="card-text">
                                            <c:out value="${service.description}"/>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-tools"></i>
                        </div>
                        <p class="empty-state-text">
                            Hiện tại chúng tôi đang cập nhật danh sách dịch vụ.<br>
                            Vui lòng quay lại sau hoặc liên hệ đội ngũ chăm sóc khách hàng để biết thêm thông tin.
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <jsp:include page="../header_footer/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>