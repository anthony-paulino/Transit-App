<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, java.util.Date, java.text.SimpleDateFormat, dao.StopsAtDAO, dao.ReservationDAO, dao.TicketDAO, dao.TrainScheduleDAO, model.Reservation, model.Ticket, model.TrainSchedule" %>
<%
    String role = (String) session.getAttribute("role");
    int customerID = (int) session.getAttribute("userID");

    if (role == null || !"customer".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    ReservationDAO reservationDAO = new ReservationDAO();
    TicketDAO ticketDAO = new TicketDAO();
    StopsAtDAO stopsAtDAO = new StopsAtDAO();

    // Retrieve all reservations for the logged-in customer
    List<Reservation> reservations = reservationDAO.getReservationsByCustomerID(customerID);

    // Create separate lists for past and current reservations
    List<Reservation> pastReservations = new ArrayList<>();
    List<Reservation> currentReservations = new ArrayList<>();

    Date now = new Date();
    
    for (Reservation reservation : reservations) {
        System.out.println("--" + reservation.getReservationID() + "--");
        List<Ticket> tickets = ticketDAO.getTicketsByReservationID(reservation.getReservationID());
        boolean isPast = false;

        for (Ticket ticket : tickets) {       	        	
            if ("roundTrip".equals(ticket.getTripType()) && ticket.getLinkedTicketID() != null) {
                // Check return ticket for round trips
               	System.out.println(ticket.getLinkedTicketID());
                Ticket incomingTicket = ticketDAO.getLinkedTicket(ticket.getLinkedTicketID());
                Date departureTime = stopsAtDAO.getDepartureTimeForStation(incomingTicket.getScheduleID(), incomingTicket.getOriginID());
                if (departureTime.before(now)) {
                    isPast = true;
                    break;
                }
            } else if ("oneWay".equals(ticket.getTripType())) {
                // Check departure time for one-way tickets
                Date departureTime = stopsAtDAO.getDepartureTimeForStation(ticket.getScheduleID(), ticket.getOriginID());
                if (departureTime.before(now)) {
                    isPast = true;
                    break;
                }
           }
        }

        if (isPast) {
            pastReservations.add(reservation);
        } else {
            currentReservations.add(reservation);
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Reservations</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <div class="dashboard-container">
        <div class="navbar">
            <a href="customerDashboard.jsp">Back to Dashboard</a>
        </div>
        <div class="customer-reservation-container">
            <h2>Your Reservations</h2>
            <p>View, open, and cancel your reservations below:</p>
            <div class="filter-buttons">
                <button onclick="showReservations('all')" class="filter-button">All Reservations</button>
                <button onclick="showReservations('current')" class="filter-button">Current Reservations</button>
                <button onclick="showReservations('past')" class="filter-button">Past Reservations</button>
            </div>

            <% if (reservations.isEmpty()) { %>
                <p>No reservations found.</p>
            <% } else { %>
                <!-- All Reservations Table -->
                <table id="all-reservations">
                    <thead>
                        <tr>
                            <th>Reservation ID</th>
                            <th>Date Made</th>
                            <th>Total Fare</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Reservation reservation : reservations) { %>
                            <tr>
                                <td><%= reservation.getReservationID() %></td>
                                <td><%= reservation.getDateMade() %></td>
                                <td>$<%= reservation.getTotalFare() %></td>
                                <td>
                                    <form action="viewReservation.jsp" method="get">
                                        <input type="hidden" name="reservationID" value="<%= reservation.getReservationID() %>">
                                        <button type="submit" class="open-button">Open</button>
                                    </form>
                                    <form action="cancelReservation.jsp" method="post">
                                        <input type="hidden" name="reservationID" value="<%= reservation.getReservationID() %>">
                                        <button type="submit" class="cancel-button">Cancel</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>

                <!-- Current Reservations Table -->
                <table id="current-reservations" style="display: none;">
                    <thead>
                        <tr>
                            <th>Reservation ID</th>
                            <th>Date Made</th>
                            <th>Total Fare</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Reservation reservation : currentReservations) { %>
                            <tr>
                                <td><%= reservation.getReservationID() %></td>
                                <td><%= reservation.getDateMade() %></td>
                                <td>$<%= reservation.getTotalFare() %></td>
                                <td>
                                    <form action="viewReservation.jsp" method="get">
                                        <input type="hidden" name="reservationID" value="<%= reservation.getReservationID() %>">
                                        <button type="submit" class="open-button">Open</button>
                                    </form>
                                    <form action="cancelReservation.jsp" method="post">
                                        <input type="hidden" name="reservationID" value="<%= reservation.getReservationID() %>">
                                        <button type="submit" class="cancel-button">Cancel</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>

                <!-- Past Reservations Table -->
                <table id="past-reservations" style="display: none;">
                    <thead>
                        <tr>
                            <th>Reservation ID</th>
                            <th>Date Made</th>
                            <th>Total Fare</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Reservation reservation : pastReservations) { %>
                            <tr>
                                <td><%= reservation.getReservationID() %></td>
                                <td><%= reservation.getDateMade() %></td>
                                <td>$<%= reservation.getTotalFare() %></td>
                                <td>
                                    <form action="viewReservation.jsp" method="get">
                                        <input type="hidden" name="reservationID" value="<%= reservation.getReservationID() %>">
                                        <button type="submit" class="open-button">Open</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>
    <script>
        function showReservations(type) {
            const allTable = document.getElementById('all-reservations');
            const currentTable = document.getElementById('current-reservations');
            const pastTable = document.getElementById('past-reservations');
            allTable.style.display = type === 'all' ? 'table' : 'none';
            currentTable.style.display = type === 'current' ? 'table' : 'none';
            pastTable.style.display = type === 'past' ? 'table' : 'none';
        }

        // Default view shows all reservations
        document.addEventListener('DOMContentLoaded', () => {
            showReservations('all');
        });
    </script>
</body>
</html>


