<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, dao.TrainScheduleDAO, dao.CustomerDAO, model.TrainSchedule" %>
<%
    // Ensure the user is logged in as a customer
    String role = (String) session.getAttribute("role");
    if (role == null || !"customer".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve schedule details passed from scheduleDetails.jsp
    String scheduleIDParam = request.getParameter("scheduleID");
    String originIDParam = request.getParameter("originID");
    String destinationIDParam = request.getParameter("destinationID");
    String baseFareParam = request.getParameter("baseFare");
    
    int scheduleID = Integer.parseInt(scheduleIDParam);
    int originID = Integer.parseInt(originIDParam);
    int destinationID = Integer.parseInt(destinationIDParam);
    float baseFare = Float.parseFloat(baseFareParam);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reservation Details</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <script>
        // JavaScript function to calculate total fare
        function calculateTotal() {
            const baseFare = parseFloat(<%= baseFare %>);
            let total = 0;

            // Get quantities and trip types for each ticket type
            const ticketTypes = ["adult", "child", "senior", "disabled"];
            const discounts = {
                "adult": 0,
                "child": 0.25,
                "senior": 0.35,
                "disabled": 0.5
            };

            ticketTypes.forEach(type => {
                const quantity = parseInt(document.getElementById(type + "Tickets").value) || 0;
                const tripType = document.getElementById(type + "TripType").value;
                const discount = discounts[type];

                let fare = baseFare * (1 - discount);
                if (tripType === "roundTrip") {
                    fare *= 2;
                }
                
                total += fare * quantity;
            });
				
            // Update the total display
            document.getElementById("totalAmount").textContent = "$"+(total.toFixed(2)).toString();
        }
    </script>
</head>
<body>
	<div class="dashboard-container">
       <div class="navbar">
           <a href="customerDashboard.jsp">Back to Dashboard</a>
       </div>
	    <div class="reservation-details-container">
	        <h2>Reservation Details</h2>
	        <p>Each ticket counts as one reservation</p>
	        <p>Fare per one-way adult ticket: $<%= baseFare %></p>
	        
	        <form action="processReservation.jsp" method="post">
	            <input type="hidden" name="scheduleID" value="<%= scheduleID %>">
	            <input type="hidden" name="originID" value="<%= originID %>">
	            <input type="hidden" name="destinationID" value="<%= destinationID %>">
	            <input type="hidden" name="baseFare" value="<%= baseFare %>">
	            
	            <table>
	                <thead>
	                    <tr>
	                        <th>Ticket Type</th>
	                        <th>Quantity</th>
	                        <th>Trip Type</th>
	                    </tr>
	                </thead>
	                <tbody>
	                    <tr>
	                        <td>Adult</td>
	                        <td><input type="number" id="adultTickets" name="adultTickets" min="0" value="0" onchange="calculateTotal()"></td>
	                        <td>
	                            <select id="adultTripType" name="adultTripType" onchange="calculateTotal()">
	                                <option value="oneWay">One-Way</option>
	                                <option value="roundTrip">Round Trip</option>
	                            </select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td>Child (25% Discount)</td>
	                        <td><input type="number" id="childTickets" name="childTickets" min="0" value="0" onchange="calculateTotal()"></td>
	                        <td>
	                            <select id="childTripType" name="childTripType" onchange="calculateTotal()">
	                                <option value="oneWay">One-Way</option>
	                                <option value="roundTrip">Round Trip</option>
	                            </select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td>Senior (35% Discount)</td>
	                        <td><input type="number" id="seniorTickets" name="seniorTickets" min="0" value="0" onchange="calculateTotal()"></td>
	                        <td>
	                            <select id="seniorTripType" name="seniorTripType" onchange="calculateTotal()">
	                                <option value="oneWay">One-Way</option>
	                                <option value="roundTrip">Round Trip</option>
	                            </select>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td>Disabled (50% Discount)</td>
	                        <td><input type="number" id="disabledTickets" name="disabledTickets" min="0" value="0" onchange="calculateTotal()"></td>
	                        <td>
	                            <select id="disabledTripType" name="disabledTripType" onchange="calculateTotal()">
	                                <option value="oneWay">One-Way</option>
	                                <option value="roundTrip">Round Trip</option>
	                            </select>
	                        </td>
	                    </tr>
	                </tbody>
	            </table>
	
	            <!-- Display Total Amount -->
	            <div class="fare-container">
	                <span class="fare-label">Total Amount: <span id="totalAmount">$0.00</span></span>
	            </div>
	
	            <button type="submit" class="confirm-button">Confirm Reservation</button>
	        </form>
	    </div>
    	</div>
</body>
</html>
