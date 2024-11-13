package dao;

import model.StopsAt;
import transit.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class StopsAtDAO {

    public List<StopsAt> getStopsByScheduleID(int scheduleID) {
        List<StopsAt> stops = new ArrayList<>();
        String query = "SELECT * FROM Stops_At WHERE scheduleID = ? ORDER BY stopNumber ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, scheduleID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                stops.add(new StopsAt(
                    rs.getInt("scheduleID"),
                    rs.getInt("stationID"),
                    rs.getInt("stopNumber"),
                    rs.getTimestamp("arrivalDateTime"),
                    rs.getTimestamp("departureDateTime")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stops;
    }

    public int getStopNumberForStation(int scheduleID, int stationID) {
        String query = "SELECT stopNumber FROM Stops_At WHERE scheduleID = ? AND stationID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, scheduleID);
            stmt.setInt(2, stationID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("stopNumber");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Default if stop number not found
    }

    public Date getArrivalTimeForStation(int scheduleID, int stationID) {
        String query = "SELECT arrivalDateTime FROM Stops_At WHERE scheduleID = ? AND stationID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, scheduleID);
            stmt.setInt(2, stationID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getTimestamp("arrivalDateTime");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Date getDepartureTimeForStation(int scheduleID, int stationID) {
        String query = "SELECT departureDateTime FROM Stops_At WHERE scheduleID = ? AND stationID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, scheduleID);
            stmt.setInt(2, stationID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getTimestamp("departureDateTime");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}









