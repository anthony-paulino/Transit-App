<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in as a customer representative
    String role = (String) session.getAttribute("role");
    if (role == null || !"rep".equals(role)) {
        response.sendRedirect("login.jsp"); // Redirect to login if not a customer representative
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Representative Dashboard</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Navbar with Home and Logout -->
        <div class="navbar">
            <a href="repDashboard.jsp">Home</a>
            <a href="logout.jsp">Logout</a>
        </div>

        <!-- Content -->
        <div class="content">
            <h2>Welcome to the Customer Representative Dashboard</h2>
            <p>This is where customer representatives can manage schedules, respond to questions, and view reservations.</p>
        </div>
    </div>
</body>
</html>
