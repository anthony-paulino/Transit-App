<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ReservationDAO, java.util.List" %>
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
    <title>Reservations by Customer Name</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <div class="reservation-by-customer-container">
        <!-- Navbar -->
        <div class="navbar">
            <a href="managerDashboard.jsp">Back to Dashboard</a>
        </div>
        
        <!-- Page Title -->
        <h2>Reservations by Customer Name</h2>
        
        <%
            ReservationDAO reservationDAO = new ReservationDAO();
            List<Object[]> reservations = reservationDAO.getReservationsByCustomerName();
        %>
        
        <!-- Reservation Table -->
        <table>
            <thead>
                <tr>
                    <th>Reservation Number</th>
                    <th>Date Made</th>
                    <th>Transit Line</th>
                    <th>Fare</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String currentCustomerName = "";
                    for (Object[] row : reservations) {
                        String customerName = (String) row[0];
                        if (!customerName.equals(currentCustomerName)) {
                            currentCustomerName = customerName;
                %>
                <tr class="customer-name-row">
                    <td colspan="4"><strong><%= customerName %></strong></td>
                </tr>
                <%
                        }
                %>
                <tr>
                    <td><%= row[1] %></td>
                    <td><%= row[2] %></td>
                    <td><%= row[3] %></td>
                    <td><%= "$" + row[4] %></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>

