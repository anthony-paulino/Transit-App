package dao;

import model.Station;
import transit.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StationDAO {

    public Station getStation(int stationID) {
        String query = "SELECT * FROM Stations WHERE stationID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, stationID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Station(
                    rs.getInt("stationID"),
                    rs.getString("name"),
                    rs.getString("city"),
                    rs.getString("state")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Station> getAllStations() {
        List<Station> stations = new ArrayList<>();
        String query = "SELECT * FROM Stations";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                stations.add(new Station(
                    rs.getInt("stationID"),
                    rs.getString("name"),
                    rs.getString("city"),
                    rs.getString("state")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stations;
    }
}
