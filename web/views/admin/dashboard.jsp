<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Bảng Điều Khiển" scope="request"/>
<jsp:include page="../header_footer/header.jsp"/>

<style>
    .dashboard-page {
        padding: 25px;
        background: #f5f6fa;
        min-height: 100vh;
    }
    
    .page-title {
        font-size: 28px;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 30px;
    }
    
    /* Stats Cards */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    
    .stat-card {
        background: white;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        display: flex;
        align-items: center;
        gap: 20px;
    }
    
    .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 26px;
        color: white;
    }
    
    .stat-icon.blue { background: #3498db; }
    .stat-icon.green { background: #27ae60; }
    .stat-icon.orange { background: #e67e22; }
    .stat-icon.purple { background: #9b59b6; }
    
    .stat-info h3 {
        font-size: 32px;
        font-weight: 700;
        color: #2c3e50;
        margin: 0 0 5px 0;
    }
    
    .stat-info p {
        font-size: 14px;
        color: #7f8c8d;
        margin: 0;
    }
    
    /* Content Grid */
    .content-grid {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 20px;
    }
    
    .content-card {
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    
    .card-header {
        padding: 20px 25px;
        border-bottom: 1px solid #ecf0f1;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .card-header h3 {
        font-size: 18px;
        font-weight: 600;
        color: #2c3e50;
        margin: 0;
    }
    
    .card-header a {
        color: #3498db;
        text-decoration: none;
        font-size: 14px;
    }
    
    .card-header a:hover {
        text-decoration: underline;
    }
    
    /* Table */
    .simple-table {
        width: 100%;
    }
    
    .simple-table th {
        background: #f8f9fa;
        padding: 15px 25px;
        text-align: left;
        font-size: 13px;
        font-weight: 600;
        color: #555;
        border-bottom: 2px solid #ecf0f1;
    }
    
    .simple-table td {
        padding: 15px 25px;
        border-bottom: 1px solid #ecf0f1;
        font-size: 14px;
        color: #2c3e50;
    }
    
    .simple-table tr:hover {
        background: #f8f9fa;
    }
    
    .booking-id {
        font-weight: 600;
        color: #3498db;
    }
    
    /* Status Badges */
    .badge {
        padding: 5px 12px;
        border-radius: 5px;
        font-size: 12px;
        font-weight: 600;
    }
    
    .badge.success { background: #d4edda; color: #155724; }
    .badge.warning { background: #fff3cd; color: #856404; }
    .badge.info { background: #d1ecf1; color: #0c5460; }
    .badge.danger { background: #f8d7da; color: #721c24; }
    
    /* Shortcuts */
    .shortcuts {
        padding: 25px;
    }
    
    .shortcut-btn {
        display: block;
        width: 100%;
        padding: 15px 20px;
        margin-bottom: 12px;
        background: #3498db;
        color: white;
        text-decoration: none;
        border-radius: 8px;
        text-align: center;
        font-weight: 500;
        transition: background 0.2s;
    }
    
    .shortcut-btn:hover {
        background: #2980b9;
    }
    
    .shortcut-btn.green { background: #27ae60; }
    .shortcut-btn.green:hover { background: #229954; }
    
    .shortcut-btn.orange { background: #e67e22; }
    .shortcut-btn.orange:hover { background: #d35400; }
    
    .shortcut-btn.purple { background: #9b59b6; }
    .shortcut-btn.purple:hover { background: #8e44ad; }
    
    .empty-message {
        padding: 50px;
        text-align: center;
        color: #95a5a6;
    }
    
    @media (max-width: 992px) {
        .content-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="dashboard-page">
    <div class="page-title">Bảng Điều Khiển</div>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon blue">
                <i class="fas fa-users"></i>
            </div>
            <div class="stat-info">
                <h3>${totalUsers}</h3>
                <p>Người Dùng</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon green">
                <i class="fas fa-bed"></i>
            </div>
            <div class="stat-info">
                <h3>${totalRooms}</h3>
                <p>Phòng</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon orange">
                <i class="fas fa-concierge-bell"></i>
            </div>
            <div class="stat-info">
                <h3>${totalServices}</h3>
                <p>Dịch Vụ</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon purple">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div class="stat-info">
                <h3>${totalBookings}</h3>
                <p>Tổng Đặt Phòng</p>
            </div>
        </div>
    </div>

    <!-- Content -->
    <div class="content-grid">
        <!-- Bookings Table -->
        <div class="content-card">
            <div class="card-header">
                <h3>Đơn Đặt Phòng Gần Đây</h3>
                <a href="${pageContext.request.contextPath}/admin/list-bookings">Xem tất cả →</a>
            </div>
            <table class="simple-table">
                <thead>
                    <tr>
                        <th>Mã Đơn</th>
                        <th>Khách Hàng</th>
                        <th>Phòng</th>
                        <th>Ngày Nhận</th>
                        <th>Trạng Thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="booking" items="${recentBookings}">
                        <tr>
                            <td><span class="booking-id">#${booking.bookingId}</span></td>
                            <td>${booking.user.fullName}</td>
                            <td>${booking.room.roomName}</td>
                            <td><fmt:formatDate value="${booking.checkIn}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${booking.status == 'confirmed'}">
                                        <span class="badge success">Đã xác nhận</span>
                                    </c:when>
                                    <c:when test="${booking.status == 'pending'}">
                                        <span class="badge warning">Chờ xác nhận</span>
                                    </c:when>
                                    <c:when test="${booking.status == 'pending_cancellation'}">
                                        <span class="badge info">Yêu cầu hủy</span>
                                    </c:when>
                                    <c:when test="${booking.status == 'cancelled'}">
                                        <span class="badge danger">Đã hủy</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge">${booking.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty recentBookings}">
                        <tr>
                            <td colspan="5" class="empty-message">Chưa có đơn đặt phòng nào</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Shortcuts -->
        <div class="content-card">
            <div class="card-header">
                <h3>Lối Tắt</h3>
            </div>
            <div class="shortcuts">
                <a href="${pageContext.request.contextPath}/admin/list-rooms" class="shortcut-btn">
                    <i class="fas fa-bed me-2"></i>Quản Lý Phòng
                </a>
                <a href="${pageContext.request.contextPath}/admin/list-services" class="shortcut-btn orange">
                    <i class="fas fa-concierge-bell me-2"></i>Quản Lý Dịch Vụ
                </a>
                <a href="${pageContext.request.contextPath}/admin/list-users" class="shortcut-btn green">
                    <i class="fas fa-users me-2"></i>Quản Lý Người Dùng
                </a>
                <a href="${pageContext.request.contextPath}/admin/list-bookings" class="shortcut-btn purple">
                    <i class="fas fa-calendar-check me-2"></i>Quản Lý Đặt Phòng
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../header_footer/footer.jsp" />