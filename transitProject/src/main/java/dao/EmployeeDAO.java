package dao;

//This is for customer-Rep and Manager DAOs
import model.Employee;
import transit.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {
	public Employee getEmployeeByUsernameAndPassword(String username, String password) {
	    String query = "SELECT * FROM Employees WHERE username = ? AND password = ?";
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query)) {
	        stmt.setString(1, username);
	        stmt.setString(2, password);
	        ResultSet rs = stmt.executeQuery();
	        if (rs.next()) {
	            return new Employee(
	                rs.getInt("employeeID"),
	                rs.getString("firstName"),
	                rs.getString("lastName"),
	                rs.getString("username"),
	                rs.getString("password"),
	                rs.getBoolean("isAdmin"),
	                rs.getString("ssn")
	            );
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}

    
    
    // New code
	public boolean addCustomerRep(Employee employee) {
	    String query = "INSERT INTO Employees (firstName, lastName, username, password, ssn, isAdmin) VALUES (?, ?, ?, ?, ?, 0)";
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query)) {
	        stmt.setString(1, employee.getFirstName());
	        stmt.setString(2, employee.getLastName());
	        stmt.setString(3, employee.getUsername());
	        stmt.setString(4, employee.getPassword());
	        stmt.setString(5, employee.getSsn());
	        return stmt.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
    
	public boolean updateCustomerRep(Employee employee) {
	    String query = "UPDATE Employees SET firstName = ?, lastName = ?, username = ?, password = ?, ssn = ? WHERE employeeID = ?";
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query)) {
	        stmt.setString(1, employee.getFirstName());
	        stmt.setString(2, employee.getLastName());
	        stmt.setString(3, employee.getUsername());
	        stmt.setString(4, employee.getPassword());
	        stmt.setString(5, employee.getSsn());
	        stmt.setInt(6, employee.getEmployeeID());
	        return stmt.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
    
	public boolean deleteCustomerRep(int employeeID) {
	    String query = "DELETE FROM Employees WHERE employeeID = ?";
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query)) {
	        stmt.setInt(1, employeeID);
	        return stmt.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}

	public List<Employee> getAllCustomerReps() {
	    String query = "SELECT * FROM Employees WHERE isAdmin = 0";
	    List<Employee> customerReps = new ArrayList<>();
	    
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query);
	         ResultSet rs = stmt.executeQuery()) {
	        
	        while (rs.next()) {
	            Employee employee = new Employee(
	                rs.getInt("employeeID"),
	                rs.getString("firstName"),
	                rs.getString("lastName"),
	                rs.getString("username"),
	                rs.getString("password"),
	                rs.getBoolean("isAdmin"),
	                rs.getString("ssn")
	            );
	            customerReps.add(employee);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return customerReps;
	}
	public Employee getEmployeeById(int employeeID) {
	    String query = "SELECT * FROM Employees WHERE employeeID = ?";
	    try (Connection conn = DatabaseConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query)) {
	        stmt.setInt(1, employeeID);
	        ResultSet rs = stmt.executeQuery();
	        if (rs.next()) {
	            return new Employee(
	                rs.getInt("employeeID"),
	                rs.getString("firstName"),
	                rs.getString("lastName"),
	                rs.getString("username"),
	                rs.getString("password"),
	                rs.getBoolean("isAdmin"),
	                rs.getString("ssn")
	            );
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}
	
	public List<Object[]> getReservationsByTransitLine() {
        String query = "SELECT tl.transitLineName, r.reservationNumber, r.dateMade, c.firstName, c.lastName, r.fare " +
                       "FROM reservations r " +
                       "JOIN train_schedules ts ON r.scheduleID = ts.scheduleID " +
                       "JOIN transitline tl ON ts.transitID = tl.transitID " +
                       "JOIN customers c ON r.customerID = c.customerID " +
                       "ORDER BY tl.transitLineName, r.dateMade";

        List<Object[]> results = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Object[] row = {
                    rs.getString("transitLineName"),
                    rs.getInt("reservationNumber"),
                    rs.getDate("dateMade"),
                    rs.getString("firstName"),
                    rs.getString("lastName"),
                    rs.getBigDecimal("fare")
                };
                results.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return results;
    }
    //////
    public List<Object[]> getReservationsByCustomerName() {
        String query = "SELECT CONCAT(c.firstName, ' ', c.lastName) AS customerName, " +
                       "r.reservationNumber, r.dateMade, tl.transitLineName, r.fare " +
                       "FROM reservations r " +
                       "JOIN customers c ON r.customerID = c.customerID " +
                       "JOIN train_schedules ts ON r.scheduleID = ts.scheduleID " +
                       "JOIN transitline tl ON ts.transitID = tl.transitID " +
                       "ORDER BY customerName, r.dateMade";

        List<Object[]> results = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Object[] row = {
                    rs.getString("customerName"),
                    rs.getInt("reservationNumber"),
                    rs.getDate("dateMade"),
                    rs.getString("transitLineName"),
                    rs.getBigDecimal("fare")
                };
                results.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return results;
    }

}