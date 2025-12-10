<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${not empty pageTitle ? pageTitle : "Sona Resort"}</title>

        <!-- Bootstrap 4.4.1 CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <!-- Google Font -->
        <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">

        <!-- jQuery (Bootstrap 4 cần jQuery đầy đủ) -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <!-- jQuery UI CSS + JS -->
        <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
        <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>

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
        <style>
            body {
                font-family: 'Poppins', sans-serif;
            }

            .navbar {
                padding: 1rem 0;
                background: #ffffff !important;
                box-shadow: 0 2px 15px rgba(0, 0, 0, 0.08);
                transition: all 0.3s ease;
            }

            .navbar-brand {
                font-weight: 700;
                font-size: 1.5rem;
                color: #2d3748 !important;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                transition: 0.3s;
            }

            .navbar-brand i {
                font-size: 1.8rem;
                color: #667eea;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.05);
                }
            }

            .navbar-nav .nav-link {
                color: #4a5568 !important;
                font-weight: 500;
                padding: 0.5rem 1rem !important;
                border-radius: 8px;
                transition: all 0.3s ease;
                position: relative;
            }

            .navbar-nav .nav-link:hover {
                background: rgba(102, 126, 234, 0.08);
                color: #667eea !important;
                transform: translateY(-2px);
            }

            .navbar-nav .nav-link.active {
                background: rgba(102, 126, 234, 0.12);
                color: #667eea !important;
                font-weight: 600;
            }

            .dropdown-menu {
                border: none;
                border-radius: 12px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
                padding: 0.5rem;
            }

            .dropdown-item {
                padding: 0.7rem 1.2rem;
                border-radius: 8px;
                transition: all 0.3s ease;
                color: #2d3748;
                font-weight: 500;
            }

            .dropdown-item:hover {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #fff;
            }

            .btn-warning {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                border: none;
                color: #fff;
                font-weight: 600;
                padding: 0.6rem 1.5rem;
                border-radius: 25px;
                box-shadow: 0 4px 15px rgba(245, 87, 108, 0.3);
                transition: all 0.3s ease;
            }

            .btn-warning:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 25px rgba(245, 87, 108, 0.4);
                background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
            }
        </style>
    </head>
    <body>
        <header class="menu">
            <nav class="navbar navbar-expand-lg navbar-light">
                <div class="container">
                    <!-- Logo -->
                    <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-hotel"></i> Sona Resort
                    </a>

                    <!-- Toggle (Bootstrap 4 dùng data-toggle, data-target ) -->
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
                            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>

                    <!-- Navbar links -->
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <!-- Left side -->
                        <ul class="navbar-nav mr-auto">
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/home">
                                    <i class="fas fa-home"></i> Trang Chủ
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/list-rooms">
                                    <i class="fas fa-bed"></i> Xem Phòng
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/services">
                                    <i class="fas fa-concierge-bell"></i> Dịch Vụ
                                </a>
                            </li>
                        </ul>

                        <!-- Right side -->
                        <ul class="navbar-nav ml-auto">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <li class="nav-item dropdown">
                                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <i class="fas fa-user-circle"></i> Xin chào, ${sessionScope.user.fullName}
                                        </a>
                                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/user/viewBookings">
                                                <i class="fas fa-history"></i> Đơn đặt của tôi
                                            </a>
                                            <a class="dropdown-item" href="#"><i class="fas fa-user-cog"></i> Thông tin tài khoản</a>

                                            <c:if test="${sessionScope.user.role == 'admin'}">
                                                <div class="dropdown-divider"></div>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">
                                                    <i class="fas fa-tachometer-alt"></i> Trang Quản Trị
                                                </a>
                                            </c:if>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                                <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                            </a>
                                        </div>
                                    </li>
                                </c:when>

                                <c:otherwise>
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/views/login/login.jsp">
                                            <i class="fas fa-sign-in-alt"></i> Đăng Nhập
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="btn btn-warning" href="${pageContext.request.contextPath}/views/login/register.jsp">
                                            <i class="fas fa-user-plus"></i> Đăng Ký
                                        </a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>

    </body>
</html>
