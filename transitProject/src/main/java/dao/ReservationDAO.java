package dao;

import java.sql.*;
import model.Reservation;
import transit.DatabaseConnection;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.math.BigDecimal;

public class ReservationDAO {

    // Method to add a reservation
    public boolean addReservation(Reservation reservation) {
        String sql = "INSERT INTO Reservations (dateMade, scheduleID, customerID, originID, destinationID, ticketType, tripType, fare) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(reservation.getDateMade().getTime()));
            stmt.setInt(2, reservation.getScheduleID());
            stmt.setInt(3, reservation.getCustomerID());
            stmt.setInt(4, reservation.getOriginID());
            stmt.setInt(5, reservation.getDestinationID());
            stmt.setString(6, reservation.getTicketType());
            stmt.setString(7, reservation.getTripType());
            stmt.setBigDecimal(8, reservation.getFare());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method to retrieve reservations by customer ID
    public List<Reservation> getReservationsByCustomerID(int customerID) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM Reservations WHERE customerID = ?";

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerID);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Reservation reservation = new Reservation(
                    rs.getInt("reservationNumber"),
                    rs.getDate("dateMade"),
                    rs.getInt("scheduleID"),
                    rs.getInt("customerID"),
                    rs.getInt("originID"),
                    rs.getInt("destinationID"),
                    rs.getString("ticketType"),
                    rs.getString("tripType"),
                    rs.getBigDecimal("fare")
                );
                reservations.add(reservation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    // Optional: Method to delete or cancel a reservation based on reservationNumber
    public boolean cancelReservation(int reservationNumber) {
        String sql = "DELETE FROM Reservations WHERE reservationNumber = ?";

        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservationNumber);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
