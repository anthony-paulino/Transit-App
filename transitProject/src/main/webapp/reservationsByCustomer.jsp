<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ReservationDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reservations by Customer Name</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <h2>Reservations by Customer Name</h2>
    <%
        ReservationDAO reservationDAO = new ReservationDAO();
        List<Object[]> reservations = reservationDAO.getReservationsByCustomerName();
    %>
    <table border="1">
        <tr>
            <th>Customer Name</th>
            <th>Reservation Number</th>
            <th>Date Made</th>
            <th>Transit Line</th>
            <th>Fare</th>
        </tr>
        <%
            String currentCustomerName = "";
            for (Object[] row : reservations) {
                String customerName = (String) row[0];
                if (!customerName.equals(currentCustomerName)) {
                    currentCustomerName = customerName;
        %>
        <tr>
            <td colspan="5" style="background-color: #f0f0f0;"><strong><%= customerName %></strong></td>
        </tr>
        <%
                }
        %>
        <tr>
            <td></td> <!-- Empty column for grouped row -->
            <td><%= row[1] %></td>
            <td><%= row[2] %></td>
            <td><%= row[3] %></td>
            <td><%= row[4] %></td>
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