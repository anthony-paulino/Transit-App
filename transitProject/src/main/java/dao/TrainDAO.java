package dao;

import model.Train;
import transit.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TrainDAO {

    public Train getTrain(int trainID) {
        String query = "SELECT * FROM Trains WHERE trainID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, trainID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Train(rs.getInt("trainID"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Train> getAllTrains() {
        List<Train> trains = new ArrayList<>();
        String query = "SELECT * FROM Trains";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                trains.add(new Train(rs.getInt("trainID")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trains;
    }
}




