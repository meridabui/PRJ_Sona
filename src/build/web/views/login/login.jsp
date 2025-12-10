
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Đăng nhập - Hotel Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .login-container {
            max-width: 450px;
            width: 100%;
        }
        
        .login-card {
            background: white;
            border-radius: 25px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .login-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
        }
        
        .login-header .logo-icon {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            backdrop-filter: blur(10px);
        }
        
        .login-header .logo-icon i {
            font-size: 40px;
        }
        
        .login-header h3 {
            margin: 0;
            font-weight: 700;
            font-size: 28px;
            margin-bottom: 8px;
        }
        
        .login-header p {
            margin: 0;
            opacity: 0.9;
            font-size: 14px;
        }
        
        .login-body {
            padding: 40px 35px;
        }
        
        .alert {
            border-radius: 12px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            animation: shake 0.5s ease-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
        
        .alert-danger {
            background: #fee;
            color: #c33;
        }
        
        .alert i {
            margin-right: 10px;
            font-size: 18px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #4a5568;
            font-weight: 600;
            font-size: 14px;
        }
        
        .input-wrapper {
            position: relative;
        }
        
        .input-wrapper i {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            font-size: 16px;
            transition: color 0.3s ease;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 20px 14px 50px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f7fafc;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .form-control:focus + i {
            color: #667eea;
        }
        
        .password-toggle {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #a0aec0;
            transition: color 0.3s ease;
        }
        
        .password-toggle:hover {
            color: #667eea;
        }
        
        .btn-login {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 12px;
            color: white;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(102, 126, 234, 0.4);
        }
        
        .btn-login:active {
            transform: translateY(0);
        }
        
        .form-footer {
            text-align: center;
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #e2e8f0;
        }
        
        .form-footer a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .form-footer a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            margin: 20px 0;
        }
        
        .remember-me input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin-right: 8px;
            cursor: pointer;
            accent-color: #667eea;
        }
        
        .remember-me label {
            margin: 0;
            font-size: 14px;
            color: #4a5568;
            cursor: pointer;
        }
        
        .divider {
            display: flex;
            align-items: center;
            margin: 25px 0;
            color: #a0aec0;
            font-size: 14px;
        }
        
        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e2e8f0;
        }
        
        .divider span {
            padding: 0 15px;
        }
        
        @media (max-width: 576px) {
            .login-body {
                padding: 30px 25px;
            }
            
            .login-header {
                padding: 30px 20px;
            }
            
            .login-header h3 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <!-- Header -->
            <div class="login-header">
                <div class="logo-icon">
                    <i class="fas fa-hotel"></i>
                </div>
                <h3>Chào mừng trở lại!</h3>
                <p>Đăng nhập để tiếp tục quản lý khách sạn</p>
            </div>
            
            <!-- Body -->
            <div class="login-body">
                <% String error = (String) request.getAttribute("errorMessage");
                   if (error != null) { %>
                   <div class="alert alert-danger">
                       <i class="fas fa-exclamation-circle"></i>
                       <span><%= error %></span>
                   </div>
                <% } %>
                
                <form action="<%= request.getContextPath() %>/login" method="post">
                    <!-- Username Field -->
                    <div class="form-group">
                        <label for="username">
                            <i class="fas fa-user me-1"></i>Tên đăng nhập
                        </label>
                        <div class="input-wrapper">
                            <input 
                                type="text" 
                                id="username"
                                name="username" 
                                class="form-control" 
                                placeholder="Nhập tên đăng nhập"
                                required
                                autofocus>
                            <i class="fas fa-user"></i>
                        </div>
                    </div>
                    
                    <!-- Password Field -->
                    <div class="form-group">
                        <label for="password">
                            <i class="fas fa-lock me-1"></i>Mật khẩu
                        </label>
                        <div class="input-wrapper">
                            <input 
                                type="password" 
                                id="password"
                                name="password" 
                                class="form-control" 
                                placeholder="Nhập mật khẩu"
                                required>
                            <i class="fas fa-lock"></i>
                            <i class="fas fa-eye password-toggle" style="margin-left: 330px" onclick="togglePassword()"></i>
                        </div>
                    </div>
                        

                    
                    <!-- Submit Button -->
                    <button type="submit" class="btn-login">
                        <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                    </button>
                </form>
                
                <!-- Footer -->
                <div class="form-footer">
                    <p style="color: #718096; margin-bottom: 10px; font-size: 14px;">
                        Chưa có tài khoản?
                    </p>
                    <a href="<%= request.getContextPath() %>/register">
                        <i class="fas fa-user-plus me-1"></i>Đăng ký ngay
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Copyright -->
        <div class="text-center mt-4">
            <p style="color: rgba(255, 255, 255, 0.8); font-size: 14px; margin: 0;">
                <i class="fas fa-shield-alt me-1"></i>
                Bảo mật & An toàn
            </p>
        </div>
    </div>
    
    <script>
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const toggleIcon = document.querySelector('.password-toggle');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
        
        // Auto-hide alert after 5 seconds
        const alert = document.querySelector('.alert');
        if (alert) {
            setTimeout(() => {
                alert.style.animation = 'slideUp 0.5s ease-out reverse';
                setTimeout(() => alert.remove(), 500);
            }, 5000);
        }
    </script>
</body>
</html>