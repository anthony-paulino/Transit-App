<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"customer".equals(role)) {
        response.sendRedirect("login.jsp"); // Redirect to login if not a customer
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <div class="dashboard-container">
        <div class="navbar">
            <a href="customerDashboard.jsp">Home</a>
            <a href="logout.jsp">Logout</a>
        </div>
        <div class="content">
            <h2>Welcome to the Customer Dashboard</h2>
            <p>This is where customers will view their bookings, search schedules, and manage reservations.</p>
        </div>
    </div>
</body>
</html>
