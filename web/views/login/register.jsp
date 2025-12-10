<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký tài khoản</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .register-container {
                margin: 30px auto;
            }

            .register-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
                overflow: hidden;
            }

            .register-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                text-align: center;
            }

            .register-header h3 {
                margin: 0;
                font-weight: 600;
                font-size: 28px;
            }

            .register-header p {
                margin: 10px 0 0 0;
                opacity: 0.9;
                font-size: 14px;
            }

            .register-body {
                padding: 40px;
            }

            .form-group label {
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
                font-size: 14px;
            }

            .input-group-icon {
                position: relative;
            }

            .input-group-icon i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #667eea;
                z-index: 10;
            }

            .input-group-icon .form-control {
                padding-left: 45px;
                height: 45px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                transition: all 0.3s;
            }

            .input-group-icon .form-control:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.15);
            }

            .btn-register {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                height: 50px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 16px;
                transition: all 0.3s;
                margin-top: 10px;
            }

            .btn-register:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
            }

            .login-link {
                text-align: center;
                margin-top: 25px;
                padding-top: 25px;
                border-top: 1px solid #e0e0e0;
            }

            .login-link a {
                color: #667eea;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s;
            }

            .login-link a:hover {
                color: #764ba2;
                text-decoration: underline;
            }

            .alert {
                border-radius: 8px;
                border: none;
                margin-top: 20px;
            }

            .alert-danger {
                background-color: #fee;
                color: #c33;
            }

            .alert-success {
                background-color: #efe;
                color: #3c3;
            }
        </style>
    </head>
    <body>
        <div class="container register-container">
            <div class="row justify-content-center">
                <div class="col-md-6 col-lg-5">
                    <div class="register-card">
                        <div class="register-header">
                            <h3>Đăng ký tài khoản</h3>
                            <p>Tạo tài khoản mới để bắt đầu</p>
                        </div>

                        <div class="register-body">
                            <!--                        <form action="register" method="post">-->
                            <form action="<%= request.getContextPath() %>/register" method="post">

                                <div class="form-group">
                                    <label>Tên đăng nhập</label>
                                    <div class="input-group-icon">
                                        <i class="fas fa-user"></i>
                                        <input type="text" name="username" class="form-control" placeholder="Nhập tên đăng nhập" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Mật khẩu</label>
                                    <div class="input-group-icon">
                                        <i class="fas fa-lock"></i>
                                        <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Họ và tên</label>
                                    <div class="input-group-icon">
                                        <i class="fas fa-id-card"></i>
                                        <input type="text" name="fullName" class="form-control" placeholder="Nhập họ và tên">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Email (Gmail)</label>
                                    <div class="input-group-icon">
                                        <i class="fas fa-envelope"></i>
                                        <input type="email" name="email" class="form-control" placeholder="example@gmail.com" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Số điện thoại</label>
                                    <div class="input-group-icon">
                                        <i class="fas fa-phone"></i>
                                        <input type="text" name="phone" class="form-control" placeholder="Nhập số điện thoại">
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary btn-register btn-block">
                                    <i class="fas fa-user-plus mr-2"></i>Đăng ký
                                </button>
                            </form>

                            <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-circle mr-2"></i><%= request.getAttribute("error") %>
                            </div>
                            <% } %>

                            <% if (request.getAttribute("message") != null) { %>
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle mr-2"></i><%= request.getAttribute("message") %>
                            </div>
                            <% } %>

                            <div class="login-link">
                                Đã có tài khoản? <a href="<%= request.getContextPath() %>/views/login/login.jsp">Đăng nhập ngay</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
    </body>
</html>