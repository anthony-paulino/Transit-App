package dao;

import model.Reservation;
import transit.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // Create a new reservation
    public int createReservation(Reservation reservation) {
        String sql = "INSERT INTO Reservations (customerID, dateMade, totalFare) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, reservation.getCustomerID());
            stmt.setDate(2, new java.sql.Date(reservation.getDateMade().getTime()));
            stmt.setBigDecimal(3, reservation.getTotalFare());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Return the generated reservation ID
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Indicates failure
    }

    // Retrieve reservations by customer ID
    public List<Reservation> getReservationsByCustomerID(int customerID) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM Reservations WHERE customerID = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Reservation reservation = new Reservation(
                    rs.getInt("reservationID"),
                    rs.getInt("customerID"),
                    rs.getDate("dateMade"),
                    rs.getBigDecimal("totalFare")
                );
                reservations.add(reservation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    // Update total fare for a reservation
    public boolean updateReservationTotalFare(int reservationID, BigDecimal totalFare) {
        String sql = "UPDATE Reservations SET totalFare = ? WHERE reservationID = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBigDecimal(1, totalFare);
            stmt.setInt(2, reservationID);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteReservation(int reservationID) {
        Connection conn = null;
        PreparedStatement deleteLinkedTicketsStmt = null;
        PreparedStatement deleteUnlinkedTicketsStmt = null;
        PreparedStatement deleteReservationStmt = null;
        boolean success = false;

        try {
            conn = DatabaseConnection.getConnection();

            // Step 1: Delete tickets with non-null linkedTicketID
            String deleteLinkedTicketsQuery = "DELETE FROM tickets WHERE reservationID = ? AND linkedTicketID IS NOT NULL";
            deleteLinkedTicketsStmt = conn.prepareStatement(deleteLinkedTicketsQuery);
            deleteLinkedTicketsStmt.setInt(1, reservationID);
            deleteLinkedTicketsStmt.executeUpdate();

            // Step 2: Delete tickets with null linkedTicketID
            String deleteUnlinkedTicketsQuery = "DELETE FROM tickets WHERE reservationID = ? AND linkedTicketID IS NULL";
            deleteUnlinkedTicketsStmt = conn.prepareStatement(deleteUnlinkedTicketsQuery);
            deleteUnlinkedTicketsStmt.setInt(1, reservationID);
            deleteUnlinkedTicketsStmt.executeUpdate();

            // Step 3: Delete the reservation itself
            String deleteReservationQuery = "DELETE FROM reservations WHERE reservationID = ?";
            deleteReservationStmt = conn.prepareStatement(deleteReservationQuery);
            deleteReservationStmt.setInt(1, reservationID);
            int rowsAffected = deleteReservationStmt.executeUpdate();

            success = (rowsAffected > 0); // If the reservation row was deleted, consider it a success
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (deleteLinkedTicketsStmt != null) deleteLinkedTicketsStmt.close();
                if (deleteUnlinkedTicketsStmt != null) deleteUnlinkedTicketsStmt.close();
                if (deleteReservationStmt != null) deleteReservationStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return success;
    }

}

