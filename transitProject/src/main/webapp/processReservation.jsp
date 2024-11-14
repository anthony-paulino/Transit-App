<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.math.BigDecimal, dao.CustomerDAO, dao.ReservationDAO, model.Customer, model.Reservation" %>
<%
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    
    if (role == null || !"customer".equals(role) || username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    CustomerDAO customerDAO = new CustomerDAO();
    ReservationDAO reservationDAO = new ReservationDAO();

    Customer customer = customerDAO.getCustomerByUsername(username);
    int customerID = customer.getCustomerID();
    
    int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
    int originID = Integer.parseInt(request.getParameter("originID"));
    int destinationID = Integer.parseInt(request.getParameter("destinationID"));
    float baseFare = Float.parseFloat(request.getParameter("baseFare"));
    Date dateMade = new Date();
    
    int adultTickets = Integer.parseInt(request.getParameter("adultTickets"));
    String adultTripType = request.getParameter("adultTripType");
    int childTickets = Integer.parseInt(request.getParameter("childTickets"));
    String childTripType = request.getParameter("childTripType");
    int seniorTickets = Integer.parseInt(request.getParameter("seniorTickets"));
    String seniorTripType = request.getParameter("seniorTripType");
    int disabledTickets = Integer.parseInt(request.getParameter("disabledTickets"));
    String disabledTripType = request.getParameter("disabledTripType");

    BigDecimal childFare = new BigDecimal(baseFare * 0.75);
    BigDecimal seniorFare = new BigDecimal(baseFare * 0.65);
    BigDecimal disabledFare = new BigDecimal(baseFare * 0.5);
    boolean success = true;

    try {
        // Process adult tickets
        for (int i = 0; i < adultTickets; i++) {
            BigDecimal fare = new BigDecimal(baseFare);
            if ("roundTrip".equals(adultTripType)) fare = fare.multiply(new BigDecimal(2));
            Reservation reservation = new Reservation(0, dateMade, scheduleID, customerID, originID, destinationID, "adult", adultTripType, fare);
            reservationDAO.addReservation(reservation);
        }
        
        // Process child tickets
        for (int i = 0; i < childTickets; i++) {
            BigDecimal fare = childFare;
            if ("roundTrip".equals(childTripType)) fare = fare.multiply(new BigDecimal(2));
            Reservation reservation = new Reservation(0, dateMade, scheduleID, customerID, originID, destinationID, "child", childTripType, fare);
            reservationDAO.addReservation(reservation);
        }
        
        // Process senior tickets
        for (int i = 0; i < seniorTickets; i++) {
            BigDecimal fare = seniorFare;
            if ("roundTrip".equals(seniorTripType)) fare = fare.multiply(new BigDecimal(2));
            Reservation reservation = new Reservation(0, dateMade, scheduleID, customerID, originID, destinationID, "senior", seniorTripType, fare);
            reservationDAO.addReservation(reservation);
        }
        
        // Process disabled tickets
        for (int i = 0; i < disabledTickets; i++) {
            BigDecimal fare = disabledFare;
            if ("roundTrip".equals(disabledTripType)) fare = fare.multiply(new BigDecimal(2));
            Reservation reservation = new Reservation(0, dateMade, scheduleID, customerID, originID, destinationID, "disabled", disabledTripType, fare);
            reservationDAO.addReservation(reservation);
        }
    } catch (Exception e) {
        e.printStackTrace();
        success = false;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Processing Reservation</title>
    <script type="text/javascript">
        window.onload = function() {
            <% if (success) { %>
                alert("Successfully made reservation");
                window.location.href = "customerDashboard.jsp";
            <% } else { %>
                alert("Failed to make reservation. Please try again.");
                window.location.href = "reservationDetails.jsp?scheduleID=<%= scheduleID %>&originID=<%= originID %>&destinationID=<%= destinationID %>&baseFare=<%= baseFare %>";
            <% } %>
        };
    </script>
</head>
<body>
</body>
</html>


