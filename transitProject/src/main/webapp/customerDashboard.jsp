<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.text.*, dao.TrainScheduleDAO, dao.TransitLineDAO, dao.StationDAO, model.TrainSchedule, model.Station" %>
<%
   String role = (String) session.getAttribute("role");
   if (role == null || !"customer".equals(role)) {
       response.sendRedirect("login.jsp"); // Redirect to login if not a customer
       return;
   }

   // DAOs
   StationDAO stationDAO = new StationDAO();
   TrainScheduleDAO scheduleDAO = new TrainScheduleDAO();
   TransitLineDAO transitLineDAO = new TransitLineDAO();

   // Form parameters
   String originIDParam = request.getParameter("origin");
   String destinationIDParam = request.getParameter("destination");
   String travelDateParam = request.getParameter("travelDate");
   String sortBy = request.getParameter("sortBy");

   List<TrainSchedule> schedules = new ArrayList<>();

   // Fetch schedules if search criteria are provided
   if (originIDParam != null && destinationIDParam != null && travelDateParam != null) {
       int originID = Integer.parseInt(originIDParam);
       int destinationID = Integer.parseInt(destinationIDParam);
       Date travelDate = java.sql.Date.valueOf(travelDateParam);

       schedules = scheduleDAO.searchSchedules(originID, destinationID, travelDate);

       // Sort schedules based on criteria selected
       if (sortBy != null) {
           if (sortBy.equals("arrival")) {
               schedules.sort(new Comparator<TrainSchedule>() {
                   public int compare(TrainSchedule a, TrainSchedule b) {
                       return a.getArrivalDateTime().compareTo(b.getArrivalDateTime());
                   }
               });
           } else if (sortBy.equals("departure")) {
               schedules.sort(new Comparator<TrainSchedule>() {
                   public int compare(TrainSchedule a, TrainSchedule b) {
                       return a.getDepartureDateTime().compareTo(b.getDepartureDateTime());
                   }
               });
           } else if (sortBy.equals("fare")) {
               schedules.sort(new Comparator<TrainSchedule>() {
                   public int compare(TrainSchedule a, TrainSchedule b) {
                       return Float.compare(a.getFare(), b.getFare());
                   }
               });
           }
       }
   }
%>
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
           <p>This is where customers will view their bookings, search schedules, and manage reservations.</p>

           <!-- Search form -->
           <form action="customerDashboard.jsp" method="get" class="search-form">
               <label for="origin">Origin:</label>
               <select name="origin" id="origin" required>
                   <% for (Station station : stationDAO.getAllStations()) { %>
                       <option value="<%= station.getStationID() %>"><%= station.getName() %></option>
                   <% } %>
               </select>

               <label for="destination">Destination:</label>
               <select name="destination" id="destination" required>
                   <% for (Station station : stationDAO.getAllStations()) { %>
                       <option value="<%= station.getStationID() %>"><%= station.getName() %></option>
                   <% } %>
               </select>

               <label for="travelDate">Travel Date:</label>
               <input type="date" id="travelDate" name="travelDate" required>

               <label for="sortBy">Sort By:</label>
               <select name="sortBy" id="sortBy">
                   <option value="arrival">Arrival Time</option>
                   <option value="departure">Departure Time</option>
                   <option value="fare">Fare</option>
               </select>

               <button type="submit">Search</button>
           </form>

           <!-- Display search results -->
           <div class="results">
               <h3>Search Results</h3>
               <% if (schedules.isEmpty()) { %>
                   <p>No schedules found for the selected criteria.</p>
               <% } else { %>
                   <table>
                       <thead>
                           <tr>
                           		<th>Transit Line</th>
                               <th>Train</th>
                               <th>Origin</th>
                               <th>Destination</th>
                               <th>Departure</th>
                               <th>Arrival</th>
                               <th>Fare</th>
                               <th>Travel Time</th>
                           </tr>
                       </thead>
                       <tbody>
                           <% for (TrainSchedule schedule : schedules) { %>
                               <tr>
                               	   <td><%= transitLineDAO.getTransitLineName(schedule.getTransitID()) %></td>                          
                                   <td><%= schedule.getTrainID() %></td>
                                   <td><%= stationDAO.getStation(schedule.getOriginID()).getName() %></td>
                                   <td><%= stationDAO.getStation(schedule.getDestinationID()).getName() %></td>
                                   <td><%= schedule.getDepartureDateTime() %></td>
                                   <td><%= schedule.getArrivalDateTime() %></td>
                                   <td><%= schedule.getFare() %></td>
                                   <td><%= schedule.getTravelTime() %> mins</td>
                               </tr>
                           <% } %>
                       </tbody>
                   </table>
               <% } %>
           </div>
       </div>
   </div>
</body>
</html>