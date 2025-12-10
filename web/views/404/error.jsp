<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
    if (requestUri == null) requestUri = "Unknown";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <title>404 - Không tìm thấy</title>
  <style>
    body { font-family: Arial, sans-serif; text-align:center; padding:40px; }
    h1 { font-size:48px; color:#d33; }
    p { font-size:18px; color:#333; }
    a { color:#0a66c2; text-decoration:none; }
  </style>
</head>
<body>
  <h1>404 — Trang không tìm thấy</h1>
  <p>Mã lỗi: <strong><%= statusCode %></strong></p>
  <p>Đường dẫn: <strong><%= requestUri %></strong></p>
  <p>Vui lòng quay về <a href="<%= request.getContextPath() %>/">trang chủ</a> hoặc kiểm tra URL.</p>
</body>
</html>
