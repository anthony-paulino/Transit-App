package dao;

import model.TransitLine;
import transit.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TransitLineDAO {
    
	public String getTransitLineName(int transitID) {
	    String query = "SELECT transitLineName FROM TransitLine WHERE transitID = ?";
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query)) {
	        stmt.setInt(1, transitID);
	        ResultSet rs = stmt.executeQuery();
	        if (rs.next()) {
	            return rs.getString("transitLineName");
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return "Unknown";
	}

	    
    public TransitLine getTransitLine(int transitID) {
        String query = "SELECT * FROM TransitLine WHERE transitID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, transitID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new TransitLine(
                    rs.getInt("transitID"),
                    rs.getString("transitLineName"),
                    rs.getFloat("baseFare"),
                    rs.getInt("totalStops")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public float getBaseFareByTransitID(int transitID) {
        String query = "SELECT baseFare FROM TransitLine WHERE transitID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, transitID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getFloat("baseFare");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getTotalStops(int transitID) {
        String query = "SELECT totalStops FROM TransitLine WHERE transitID = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, transitID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("totalStops");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // Default if no stops found
    }
}


