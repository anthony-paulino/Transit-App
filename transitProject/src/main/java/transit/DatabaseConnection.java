package transit;

import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Connection;

public class DatabaseConnection {
	
	static final String connectionUrl = "jdbc:mysql://localhost:3306/transitdatabase";
	static final String user = "root";
	static final String password = "1234"; // hard-coded password, switch to whatever your root password is 

	public DatabaseConnection(){
		
	}

	public static Connection getConnection(){
		
		Connection connection = null;
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver").newInstance();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try {
			//Create a connection to your DB
			connection = DriverManager.getConnection(connectionUrl,user, password);
			System.out.println("Connection established.");
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return connection;
		
	}
	
	public static void closeConnection(Connection connection){
		try {
			System.out.println("Connection closed.");
			connection.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		Connection connection = DatabaseConnection.getConnection();
		DatabaseConnection.closeConnection(connection);
	}
}
