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
        <!-- Navbar -->
        <div class="navbar">
            <a href="repDashboard.jsp">Home</a>
            <a href="logout.jsp">Logout</a>
        </div>

        <!-- Content -->
        <div class="content">
            <h2>Welcome to the Employee Dashboard</h2>
            <p>Use the options below to manage reservations, train schedules, or respond to customer inquiries:</p>
            
            <!-- Action Buttons -->
            <div class="option-buttons">
                <!-- Manage Reservations -->
                <form action="manageReservations.jsp" method="get">
                    <button type="submit" class="long-button">Manage Reservations</button>
                </form>
                
                <!-- Manage Train Schedules -->
                <form action="manageSchedules.jsp" method="get">
                    <button type="submit" class="long-button">Manage Train Schedules</button>
                </form>
                
                <!-- Respond to Customer Questions -->
                <form action="respondToCustomerQuestions.jsp" method="get">
                    <button type="submit" class="long-button">Respond to Customer Questions</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>