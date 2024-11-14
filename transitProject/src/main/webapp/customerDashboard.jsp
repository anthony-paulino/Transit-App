<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            <p>Select an option below to manage your reservations or browse available train schedules:</p>

            <!-- Button Links for Customer Options -->
            <div class="option-buttons">
                <form action="customerSchedules.jsp" method="get">
                    <button type="submit" class="long-button">Browse/Search Schedules</button>
                </form>
                <form action="customerReservations.jsp" method="get">
                    <button type="submit" class="long-button">Manage Reservations</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
