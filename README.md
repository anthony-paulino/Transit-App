Here’s a comprehensive README document for your project, outlining the current structure, components, schema, and implementation details. This will provide a detailed overview of what you have completed so far.

---

# Transit Web App

## Project Overview

This project is an online railway booking system built as part of the CS 336 course. It allows users (customers, customer representatives, and managers) to interact with a train booking service. Customers can browse available train schedules, make reservations, and manage their accounts, while employees have additional administrative privileges.

The project is developed using a three-tier architecture:
- **Database Layer**: MySQL database to store information.
- **Application Layer**: Java code to manage business logic and interact with the database.
- **Presentation Layer**: JSP pages to provide a user interface.

## Schema

### Database Schema Overview

The database schema is organized to support train schedules, stations, transit lines, customers, employees, and reservations.

- **TransitLine** represents an entire route that a train can take, covering all stations from origin to destination.
- **Train_Schedules** holds schedules for all possible journeys that can be made within a given route, from segments to the entire route. For example, if a transit line runs from `Perth Amboy` to `New York Penn Station` with stops in between, `Train_Schedules` will have entries for the full route as well as segments like `Rahway` to `New York Penn Station`.

### Schema Structure

1. **Trains**
   - `trainID` (Primary Key): Unique ID for each train.

2. **Stations**
   - `stationID` (Primary Key): Unique ID for each station.
   - `name`: Name of the station.
   - `city`: City where the station is located.
   - `state`: State where the station is located.

3. **TransitLine**
   - `transitID` (Primary Key): Unique ID for each transit line.
   - `transitLineName`: Name of the transit line.
   - `baseFare`: The base fare for the full route.

4. **Train_Schedules**
   - `scheduleID` (Primary Key): Unique ID for each schedule.
   - `transitID` (Foreign Key): Refers to `TransitLine`.
   - `trainID` (Foreign Key): Refers to `Trains`.
   - `originID` (Foreign Key): Refers to `Stations` as the origin of the schedule.
   - `destinationID` (Foreign Key): Refers to `Stations` as the destination of the schedule.
   - `departureDateTime`: Date and time of departure.
   - `arrivalDateTime`: Date and time of arrival.
   - `fare`: Fare for the journey from origin to destination.
   - `travelTime`: Total travel time.

5. **Reservations**
   - `reservationNumber` (Primary Key): Unique ID for each reservation.
   - `dateMade`: Date the reservation was made.
   - `totalFare`: Total fare for the reservation.
   - `scheduleID` (Foreign Key): Refers to `Train_Schedules`.
   - `customerID` (Foreign Key): Refers to `Customers`.

6. **Customers**
   - `customerID` (Primary Key): Unique ID for each customer.
   - `lastName`: Last name of the customer.
   - `firstName`: First name of the customer.
   - `emailAddress`: Email address of the customer.
   - `username`: Unique username.
   - `password`: Password for the account.

7. **Employees**
   - `employeeID` (Primary Key): Unique ID for each employee.
   - `ssn`: Social Security Number (unique).
   - `lastName`: Last name of the employee.
   - `firstName`: First name of the employee.
   - `username`: Unique username.
   - `password`: Password for the account.
   - `isAdmin`: Boolean to identify if the employee is a manager (true for manager, false for customer representative).

8. **Stops_At**
   - `scheduleID` (Composite Key with `stationID`): Refers to `Train_Schedules`.
   - `stationID` (Composite Key with `scheduleID`): Refers to `Stations`.
   - `stopNumber`: The order of the stop in the schedule.

9. **Handles**
   - `employeeID` (Composite Key with `reservationNumber`): Refers to `Employees`.
   - `reservationNumber` (Composite Key with `employeeID`): Refers to `Reservations`.

## Implementation Details

### Java Files

#### 1. **DatabaseConnection.java**

This class handles the database connection using the JDBC driver. It provides a `getConnection` method that returns a connection object, which is used in all DAO (Data Access Object) classes to interact with the database.

#### 2. **Customer.java and Employee.java (Models)**

- **Customer.java**: Represents a customer entity in the system, with fields like `customerID`, `username`, `password`, `emailAddress`, `firstName`, and `lastName`.
- **Employee.java**: Represents an employee entity, including fields like `employeeID`, `username`, `password`, and `isAdmin` to distinguish between managers and customer representatives.

#### 3. **CustomerDAO.java and EmployeeDAO.java (Data Access Objects)**

- **CustomerDAO.java**: Manages database operations related to customers, including `getCustomerByUsernameAndPassword` (for login) and `addCustomer` (for registration).
- **EmployeeDAO.java**: Manages database operations related to employees, including `getEmployeeByUsernameAndPassword` for employee login.

#### 4. **Session Management**

Sessions are used to manage user logins. Once a user logs in, their `user` and `role` information is stored in the session. This allows for page redirection and access control based on roles (customer, rep, or manager). Sessions also prevent logged-in users from revisiting the login page.

### JSP Files

#### 1. **login.jsp**

The login page where users (customers, reps, and managers) authenticate themselves. It checks the credentials against the database and redirects them to their respective dashboards based on their roles.

#### 2. **register.jsp**

The registration page allows new customers to create accounts. It checks for unique usernames and email addresses to prevent duplication. Successful registrations are redirected to the login page.

#### 3. **customerDashboard.jsp**

The dashboard page specifically for customers, providing access to their bookings, schedule searches, and reservation management.

#### 4. **repDashboard.jsp**

The dashboard for customer representatives, allowing them to manage train schedules and respond to customer questions.

#### 5. **managerDashboard.jsp**

The dashboard for managers (admins), where they can view reports, manage employees, and review revenue and reservations.

#### 6. **logout.jsp**

This page ends the user’s session, logging them out and redirecting them to the login page.

### CSS (styles.css)

The CSS file is used to style the login, register, and dashboard pages, making the UI user-friendly and consistent across different pages.

## Summary of Current Progress

1. **Database Structure**: A schema has been established, modeling entities like `Customers`, `Employees`, `Trains`, `Stations`, `TransitLine`, `Train_Schedules`, etc.
2. **User Account Management**:
   - **Login and Registration**: JSP pages (`login.jsp` and `register.jsp`) and Java classes (DAOs and models) for user authentication.
   - **Session Management**: Role-based redirection and access control using sessions.
3. **Dashboards**:
   - **Customer Dashboard**: Allows customers to access booking and schedule information.
   - **Customer Representative Dashboard**: Allows reps to manage schedules and respond to questions.
   - **Manager Dashboard**: Allows managers to view reports and manage staff.

This project is well-structured for future development, with a robust schema that supports role-based user interactions and database integrity. The current setup lays a strong foundation to implement features such as advanced search, booking, reservation management, and administrative reporting.

### Guide: Running the SQL Script

Here's a step-by-step guide on how to run the SQL script for your database setup. This guide assumes you're using MySQL Workbench, but the general steps are similar in other SQL environments.

#### Prerequisites:
- MySQL server installed and running.
- MySQL Workbench or any SQL client connected to your MySQL server.

---

### Step 1: Connect to Your Database Server

1. **Open MySQL Workbench** (or any SQL client you’re using).
2. **Create a new connection** or **open an existing connection** to your MySQL server.
   - Enter your server details (hostname, port, username, and password).
   - Click **Connect**.

---

### Step 2: Open Your SQL Script

1. Once connected to the server, go to the **File** menu.
2. Click on **Open SQL Script…**.
3. Navigate to the location where your SQL script file (e.g., `schema.sql`) is saved and open it.
4. The SQL script will open in a new tab.

---

### Step 3: Execute the SQL Script

1. **Hover over the "Query" menu** at the top of the screen.
2. You have two options:
   - **Execute (All)**: This will run the entire SQL script from top to bottom.
   - **Execute (Selection)**: You can select specific lines of SQL code and execute only the highlighted part.
3. To execute the entire script, click **Execute** (or press `CTRL + SHIFT + ENTER` on Windows or `CMD + SHIFT + ENTER` on Mac).
4. **Monitor the Console Output**:
   - The console at the bottom of the screen will display the execution status.
   - If the script runs successfully, you should see messages like `Query OK` next to each statement.
   - If there are any errors, the console will display an error message, allowing you to troubleshoot specific lines.

---

### Step 4: Verify the Tables and Data

1. In MySQL Workbench, go to the **Navigator** panel on the left side.
2. Under **Schemas**, refresh your database to view the newly created tables and structure.
3. Expand your database to ensure that all tables are created as expected.
4. You can also run simple `SELECT` queries on individual tables to verify that they contain the correct data.

---

### Summary

- **Connect** to your MySQL server.
- **Open the SQL script**.
- **Execute all** or specific parts of the script.
- **Monitor the console** for success or error messages.
- **Verify** the database structure by checking the tables and data.

This process will set up your database schema and populate any necessary initial data. Make sure to save your SQL script in a safe location, as you may need it for reference or future deployments.
