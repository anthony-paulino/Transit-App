package dao;

import model.Customer;
import transit.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CustomerDAO {
   public Customer getCustomerByUsernameAndPassword(String username, String password) {
       String query = "SELECT * FROM Customers WHERE username = ? AND password = ?";
       try (Connection conn = DatabaseConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)) {
           stmt.setString(1, username);
           stmt.setString(2, password);
           ResultSet rs = stmt.executeQuery();
           if (rs.next()) {
               return new Customer(
                   rs.getInt("customerID"),
                   rs.getString("username"),
                   rs.getString("password"),
                   rs.getString("emailAddress"),
                   rs.getString("firstName"),
                   rs.getString("lastName")
               );
           }
       } catch (SQLException e) {
           e.printStackTrace();
       }
       return null;
   }
   
   public Customer getCustomerByUsername(String username) {
	    String query = "SELECT * FROM Customers WHERE username = ?";
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(query)) {
	        ps.setString(1, username);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return new Customer(
	                rs.getInt("customerID"),
	                rs.getString("username"),
	                rs.getString("password"),
	                rs.getString("emailAddress"),
	                rs.getString("firstName"),
	                rs.getString("lastName")
	            );
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}

   public boolean addCustomer(Customer customer) {
       String query = "INSERT INTO Customers (username, password, emailAddress, firstName, lastName) VALUES (?, ?, ?, ?, ?)";
       try (Connection conn = DatabaseConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)) {
           stmt.setString(1, customer.getUsername());
           stmt.setString(2, customer.getPassword());
           stmt.setString(3, customer.getEmailAddress());
           stmt.setString(4, customer.getFirstName());
           stmt.setString(5, customer.getLastName());
           return stmt.executeUpdate() > 0;
       } catch (SQLException e) {
           e.printStackTrace();
       }
       return false;
   }

   public boolean isUsernameOrEmailAddressTaken(String username, String emailAddress) {
       String query = "SELECT * FROM Customers WHERE username = ? OR emailAddress = ?";
       try (Connection conn = DatabaseConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)) {
           stmt.setString(1, username);
           stmt.setString(2, emailAddress);
           ResultSet rs = stmt.executeQuery();
           return rs.next();
       } catch (SQLException e) {
           e.printStackTrace();
       }
       return false;
   }
}
