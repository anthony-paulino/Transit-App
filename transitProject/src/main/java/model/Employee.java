package model;

public class Employee {
    private int employeeID;
    private String username;
    private String password;
    private boolean isAdmin;

    // Constructor, getters, and setters
    public Employee(int employeeID, String username, String password, boolean isAdmin) {
        this.employeeID = employeeID;
        this.username = username;
        this.password = password;
        this.isAdmin = isAdmin;
    }

    public int getEmployeeID() { return employeeID; }
    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public boolean isAdmin() { return isAdmin; }

    public void setEmployeeID(int employeeID) { this.employeeID = employeeID; }
    public void setUsername(String username) { this.username = username; }
    public void setPassword(String password) { this.password = password; }
    public void setAdmin(boolean isAdmin) { this.isAdmin = isAdmin; }
}
