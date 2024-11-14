<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat, dao.TrainScheduleDAO, dao.StopsAtDAO, dao.TransitLineDAO, dao.StationDAO, model.StopsAt, model.TrainSchedule" %>
<%
   String scheduleIDParam = request.getParameter("scheduleID");
   String originIDParam = request.getParameter("originID");
   String destinationIDParam = request.getParameter("destinationID");

   if (scheduleIDParam == null || originIDParam == null || destinationIDParam == null) {
       response.sendRedirect("customerDashboard.jsp");
       return;
   }

   int scheduleID = Integer.parseInt(scheduleIDParam);
   int originID = Integer.parseInt(originIDParam);
   int destinationID = Integer.parseInt(destinationIDParam);

   // DAOs
   TrainScheduleDAO scheduleDAO = new TrainScheduleDAO();
   StopsAtDAO stopsAtDAO = new StopsAtDAO();
   StationDAO stationDAO = new StationDAO();
   TransitLineDAO transitLineDAO = new TransitLineDAO();

   // Get the schedule details
   TrainSchedule schedule = scheduleDAO.getTrainSchedule(scheduleID);
   List<StopsAt> stops = stopsAtDAO.getStopsByScheduleID(scheduleID);
   String transitLineName = transitLineDAO.getTransitLineName(schedule.getTransitID());
   
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
           <h2>Schedule Overview for Transit Line: <%= transitLineName %></h2>
           <p>Below is the overview of the transit line that belongs to your schedule. Origin is the start of your schedule, and destination is the end of your schedule.</p>
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
                           <td>
                               <%= stop.getStopNumber() %>
                               <% 
                                   if (stop.getStationID() == originID) { 
                                       out.print(" (Origin)"); 
                                   } else if (stop.getStationID() == destinationID) { 
                                       out.print(" (Destination)"); 
                                   }
                               %>
                           </td>
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

