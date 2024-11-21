package dao;

import model.StopsAt;
import model.TrainSchedule;
import transit.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class TrainScheduleDAO {

    private TransitLineDAO transitLineDAO = new TransitLineDAO();
    private StopsAtDAO stopsAtDAO = new StopsAtDAO();

    public TrainSchedule getTrainSchedule(int scheduleID) {
        String query = "SELECT * FROM Train_Schedules WHERE scheduleID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, scheduleID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int transitID = rs.getInt("transitID");
                float baseFare = transitLineDAO.getBaseFareByTransitID(transitID);
                return new TrainSchedule(
                    rs.getInt("scheduleID"),
                    transitID,
                    rs.getInt("trainID"),
                    rs.getInt("originID"),
                    rs.getInt("destinationID"),
                    rs.getTimestamp("departureDateTime"),
                    rs.getTimestamp("arrivalDateTime"),
                    baseFare,
                    calculateTravelTime(rs.getTimestamp("departureDateTime"), rs.getTimestamp("arrivalDateTime")),
                    rs.getString("tripDirection") // Assuming tripDirection is stored as 'forward' or 'return'
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<TrainSchedule> searchSchedules(int originID, int destinationID, Date travelDate) {
        List<TrainSchedule> schedules = new ArrayList<>();
        String query = "SELECT ts.* FROM Train_Schedules ts "
                     + "JOIN Stops_At sa1 ON ts.scheduleID = sa1.scheduleID AND sa1.stationID = ? "
                     + "JOIN Stops_At sa2 ON ts.scheduleID = sa2.scheduleID AND sa2.stationID = ? "
                     + "WHERE sa1.stopNumber < sa2.stopNumber "
                     + "AND DATE(ts.departureDateTime) = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, originID);
            stmt.setInt(2, destinationID);
            stmt.setDate(3, new java.sql.Date(travelDate.getTime()));

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int scheduleID = rs.getInt("scheduleID");
                int transitID = rs.getInt("transitID");
                float baseFare = transitLineDAO.getBaseFareByTransitID(transitID);

                Date departureTime = stopsAtDAO.getDepartureTimeForStation(scheduleID, originID);
                Date arrivalTime = stopsAtDAO.getArrivalTimeForStation(scheduleID, destinationID);
                
                if (departureTime != null && arrivalTime != null) {
                    float calculatedFare = calculateFare(baseFare, transitID, scheduleID, originID, destinationID);
                    long travelTime = calculateTravelTime(departureTime, arrivalTime);
                    TrainSchedule schedule = new TrainSchedule(
                        scheduleID,
                        transitID,
                        rs.getInt("trainID"),
                        originID,
                        destinationID,
                        departureTime,
                        arrivalTime,
                        calculatedFare,
                        travelTime,
                        rs.getString("tripDirection") // Include trip direction here
                    );

                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }
    
    public List<TrainSchedule> searchSchedulesByStationWithFares(int stationID, Date travelDate) {
        List<TrainSchedule> schedules = new ArrayList<>();
        String query = "SELECT DISTINCT ts.* FROM Train_Schedules ts "
                     + "JOIN Stops_At sa ON ts.scheduleID = sa.scheduleID "
                     + "WHERE sa.stationID = ? "
                     + "AND DATE(ts.departureDateTime) = ? "
                     + "ORDER BY ts.departureDateTime";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, stationID);
            stmt.setDate(2, new java.sql.Date(travelDate.getTime()));

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int scheduleID = rs.getInt("scheduleID");
                int transitID = rs.getInt("transitID");
                float baseFare = transitLineDAO.getBaseFareByTransitID(transitID);

                // Step 1: Retrieve all stops for the schedule
                List<StopsAt> stops = stopsAtDAO.getStopsByScheduleID(scheduleID);

                for (StopsAt originStop : stops) {
                    for (StopsAt destinationStop : stops) {
                        // Step 2: Ensure the stationID is part of the route (origin or destination)
                        if (originStop.getStationID() == stationID || destinationStop.getStationID() == stationID) {
                            // Ensure the route direction is valid (origin comes before destination)
                            if (originStop.getStopNumber() < destinationStop.getStopNumber()) {
                                // Step 3: Calculate fare for the subroute
                                int segmentStops = destinationStop.getStopNumber() - originStop.getStopNumber();
                                float calculatedFare = (baseFare / (stops.size() - 1)) * segmentStops;

                                // Step 4: Add the schedule to the result
                                TrainSchedule schedule = new TrainSchedule(
                                    scheduleID,
                                    transitID,
                                    rs.getInt("trainID"),
                                    originStop.getStationID(),
                                    destinationStop.getStationID(),
                                    originStop.getDepartureDateTime(),
                                    destinationStop.getArrivalDateTime(),
                                    calculatedFare,
                                    calculateTravelTime(originStop.getDepartureDateTime(), destinationStop.getArrivalDateTime()),
                                    rs.getString("tripDirection") // Include trip direction
                                );

                                schedules.add(schedule);
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }


    public List<TrainSchedule> availableOppositeDirectionSchedules(int transitID, Date afterDateTime, String tripDirection, int originID, int destinationID) { 
        List<TrainSchedule> returnSchedules = new ArrayList<>();
        // Determine opposite direction for return trip search
        String requiredDirection = tripDirection.equals("forward") ? "return" : "forward";
        String query = "SELECT * FROM Train_Schedules "
                     + "WHERE transitID = ? AND tripDirection = ? "
                     + "AND departureDateTime > ? ORDER BY departureDateTime ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, transitID);
            stmt.setString(2, requiredDirection);
            stmt.setTimestamp(3, new java.sql.Timestamp(afterDateTime.getTime()));
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int scheduleID = rs.getInt("scheduleID");
                float baseFare = transitLineDAO.getBaseFareByTransitID(transitID);
                
                // Retrieve segment-specific arrival and departure times for the origin and destination
                Date departureTime = stopsAtDAO.getDepartureTimeForStation(scheduleID, originID);
                Date arrivalTime = stopsAtDAO.getArrivalTimeForStation(scheduleID, destinationID);
                if (departureTime != null && arrivalTime != null) {
                    // Calculate fare based on segment distance
                    float calculatedFare = calculateFare(baseFare, transitID, scheduleID, originID, destinationID);
                    long travelTime = calculateTravelTime(departureTime, arrivalTime);
                    TrainSchedule schedule = new TrainSchedule(
                        scheduleID,
                        transitID,
                        rs.getInt("trainID"),
                        originID,
                        destinationID,
                        departureTime,
                        arrivalTime,
                        calculatedFare,
                        travelTime,
                        requiredDirection
                    );

                    returnSchedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return returnSchedules;
    }

    private float calculateFare(float baseFare, int transitID, int scheduleID, int originID, int destinationID) {
        int totalStopsInFullRoute = transitLineDAO.getTotalStops(transitID);
        int originStopNumber = stopsAtDAO.getStopNumberForStation(scheduleID, originID);
        int destinationStopNumber = stopsAtDAO.getStopNumberForStation(scheduleID, destinationID);
        int segmentStops = Math.abs(destinationStopNumber - originStopNumber);
        return (baseFare / (totalStopsInFullRoute - 1)) * segmentStops;
    }

    private long calculateTravelTime(Date departureDateTime, Date arrivalDateTime) {
        long diffInMillies = Math.abs(arrivalDateTime.getTime() - departureDateTime.getTime());
        return diffInMillies / (1000 * 60);  // return time in minutes
    }
    
    public List<TrainSchedule> getSchedulesByStationAndDate(int stationID, Date travelDate) {
        List<TrainSchedule> schedules = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM TrainSchedules WHERE originID = ? AND DATE(departureDateTime) = ?"
             )) {
            ps.setInt(1, stationID);
            ps.setDate(2, new java.sql.Date(travelDate.getTime()));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TrainSchedule schedule = new TrainSchedule(
                	rs.getInt("scheduleID"),
                	rs.getInt("transitID"),
                	rs.getInt("trainID"),
                	rs.getInt("originID"),
                	rs.getInt("destinationID"),
                	rs.getTimestamp("departureDateTime"),
                	rs.getTimestamp("arrivalDateTime"),
                	rs.getFloat("fare"),
                	rs.getInt("travelTime"),
                	rs.getString("tripDirection")
                	);
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }

}

