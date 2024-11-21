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
             <p>This is where managers can perform administrative tasks.</p>

            <!-- Button to Manage Employees -->
            <form action="manageEmployees.jsp" method="get">
                <button type="submit" class="long-button">Manage Employees</button>
            </form>
            
            <!-- Button to View Reservation By Transit Line-->
            <form action="reservationsByTransitLine.jsp" method="get">
			    <button type="submit" class="long-button">View Reservations by Transit Line</button>
			</form>
			
			<!-- Button to View Reservation By Customer Name-->
			<form action="reservationsByCustomer.jsp" method="get">
			    <button type="submit" class="long-button">View Reservations by Customer Name</button>
			</form>
        </div>
    </div>
</body>
</html>
