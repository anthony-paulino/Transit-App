<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ReservationDAO, java.util.List, java.util.Map" %>
<%
    // Check if user is logged in as a manager
    String role = (String) session.getAttribute("role");
    if (role == null || !"manager".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reservations by Transit Line</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <h2>Reservations by Transit Line</h2>
    <%
        ReservationDAO reservationDAO = new ReservationDAO();
        List<Object[]> reservations = reservationDAO.getReservationsByTransitLine();
    %>
    <table border="1">
        <tr>
            <th>Transit Line</th>
            <th>Reservation Number</th>
            <th>Date Made</th>
            <th>Customer Name</th>
            <th>Fare</th>
        </tr>
        <%
            String currentTransitLine = "";
            for (Object[] row : reservations) {
                String transitLineName = (String) row[0];
                if (!transitLineName.equals(currentTransitLine)) {
                    currentTransitLine = transitLineName;
        %>
        <tr>
            <td colspan="5" style="background-color: #f0f0f0;"><strong><%= transitLineName %></strong></td>
        </tr>
        <%
                }
        %>
        <tr>
            <td></td> <!-- Empty column for grouped row -->
            <td><%= row[1] %></td>
            <td><%= row[2] %></td>
            <td><%= row[3] + " " + row[4] %></td>
            <td><%= row[5] %></td>
        </tr>
        <%
            }
        %>
    </table>
    <form action="managerDashboard.jsp" method="get" style="margin-top:20px;">
        <button type="submit">Back to Dashboard</button>
    </form>
</body>
</html>