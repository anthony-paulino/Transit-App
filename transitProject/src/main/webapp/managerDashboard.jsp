<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in as a manager
    String role = (String) session.getAttribute("role");
    if (role == null || !"manager".equals(role)) {
        response.sendRedirect("login.jsp"); // Redirect to login if not a manager
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Navbar with Home and Logout -->
        <div class="navbar">
            <a href="managerDashboard.jsp">Home</a>
            <a href="logout.jsp">Logout</a>
        </div>

        <!-- Content -->
        <div class="content">
            <h2>Welcome to the Manager Dashboard</h2>
            <p>This is where managers can view reports, manage employees, and review revenue and reservations.</p>
        </div>
    </div>
</body>
</html>
