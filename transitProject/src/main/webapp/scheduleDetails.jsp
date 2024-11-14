<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat, dao.TrainScheduleDAO, dao.StopsAtDAO, dao.StationDAO, model.StopsAt" %>
<%
   String scheduleIDParam = request.getParameter("scheduleID");
   if (scheduleIDParam == null) {
       response.sendRedirect("customerDashboard.jsp");
       return;
   }

   int scheduleID = Integer.parseInt(scheduleIDParam);

   // DAOs
   TrainScheduleDAO scheduleDAO = new TrainScheduleDAO();
   StopsAtDAO stopsAtDAO = new StopsAtDAO();
   StationDAO stationDAO = new StationDAO();

   // Fetch stops for the selected schedule
   List<StopsAt> stops = stopsAtDAO.getStopsByScheduleID(scheduleID);
   SimpleDateFormat formatter = new SimpleDateFormat("EEEE, MMMM d, yyyy - h:mm a");
%>

<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>Schedule Details</title>
   <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
   <div class="dashboard-container">
       <div class="navbar">
           <a href="customerDashboard.jsp">Back to Dashboard</a>
       </div>
       <div class="schedule-details-container">
           <h2>Schedule Overview</h2>
           <p>Below is the overview of stops for this route:</p>
           <table>
               <thead>
                   <tr>
                       <th>Stop Number</th>
                       <th>Station</th>
                       <th>Arrival Time</th>
                       <th>Departure Time</th>
                   </tr>
               </thead>
               <tbody>
                   <% for (StopsAt stop : stops) { %>
                       <tr>
                           <td><%= stop.getStopNumber() %></td>
                           <td><%= stationDAO.getStation(stop.getStationID()).getName() %></td>
                           <td><%= stop.getArrivalDateTime() != null ? formatter.format(stop.getArrivalDateTime()) : "Start of Route" %></td>
                           <td><%= stop.getDepartureDateTime() != null ? formatter.format(stop.getDepartureDateTime()) : "End of Route" %></td>
                       </tr>
                   <% } %>
               </tbody>
           </table>
       </div>
   </div>
</body>
</html>