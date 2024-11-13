It looks like you have a comprehensive README structure already! Here's how you can update it to reflect the recent schema and implementation changes, particularly around segment handling and other new functionalities.

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

The database schema is organized to support train schedules, stations, transit lines, customers, employees, and reservations. Recent changes focus on handling full routes as well as dynamically generating segment schedules from these full routes. This enables users to reserve both full routes and specific segments.

- **TransitLine** represents an entire route that a train can take, covering all stations from origin to destination.
- **Train_Schedules** holds schedules for all possible full routes within a given transit line.
- **Stops_At** is used to capture each stop along the full route, with new fields for `arrivalDateTime` and `departureDateTime` at each stop, supporting the generation of dynamic segment schedules.

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
   - `totalStops`: Total number of stops on the full route.

4. **Train_Schedules**
   - `scheduleID` (Primary Key): Unique ID for each schedule.
   - `transitID` (Foreign Key): Refers to `TransitLine`.
   - `trainID` (Foreign Key): Refers to `Trains`.
   - `originID` (Foreign Key): Refers to `Stations` as the origin of the schedule.
   - `destinationID` (Foreign Key): Refers to `Stations` as the destination of the schedule.
   - `departureDateTime`: Date and time of departure from the origin.
   - `arrivalDateTime`: Date and time of arrival at the destination.
   - **Note**: Every entry in `Train_Schedules` now represents a full route. Dynamic segments are generated based on `Stops_At` data.

5. **Reservations**
   - `reservationNumber` (Primary Key): Unique ID for each reservation.
   - `dateMade`: Date the reservation was made.
   - `scheduleID` (Foreign Key): Refers to `Train_Schedules`.
   - `originStopID` and `destinationStopID`: New fields representing the specific segment reserved within the full route.
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
   - `arrivalDateTime`: Arrival time at this stop.
   - `departureDateTime`: Departure time from this stop.
   - **Note**: This table now allows for segment schedules to be dynamically generated based on a full route’s stops.

9. **Handles**
   - `employeeID` (Composite Key with `reservationNumber`): Refers to `Employees`.
   - `reservationNumber` (Composite Key with `employeeID`): Refers to `Reservations`.

## Implementation Details

### Java Files

#### 1. **DatabaseConnection.java**

This class handles the database connection using the JDBC driver. It provides a `getConnection` method that returns a connection object, which is used in all DAO (Data Access Object) classes to interact with the database.

Here's the updated section with details on each model and DAO:


#### 2. **Models**

- **Customer.java**: Represents a customer entity in the system, with fields including `customerID`, `username`, `password`, `emailAddress`, `firstName`, and `lastName`.
- **Employee.java**: Represents an employee entity, with fields like `employeeID`, `username`, `password`, `ssn`, `firstName`, `lastName`, and `isAdmin` to distinguish between managers and customer representatives.
- **TrainSchedule.java**: Represents a train schedule, including `scheduleID`, `trainID`, `originID`, `destinationID`, `departureDateTime`, `arrivalDateTime`, `fare`, and `travelTime`. Each entry in `Train_Schedules` represents a full route.
- **TransitLine.java**: Represents a transit line with fields such as `transitID`, `transitLineName`, `baseFare`, and `totalStops`. This model encapsulates the full route details for a transit line.
- **StopsAt.java**: Represents each stop along a full route within a schedule, with fields including `scheduleID`, `stationID`, `stopNumber`, `arrivalDateTime`, and `departureDateTime`. These additional fields help in generating segment schedules dynamically.
- **Station.java**: Represents a station entity with `stationID`, `name`, `city`, and `state`.
- **Train.java**: Represents a train entity with a unique `trainID`.

#### 3. **Data Access Objects (DAOs)**

- **CustomerDAO.java** and **EmployeeDAO.java**: Manage customer and employee data, respectively. Both DAOs include methods for authentication, registration, and other database operations related to customers and employees.
- **TransitLineDAO.java**: Handles database interactions related to `TransitLine`. This DAO provides methods for retrieving transit line information, including base fare and the total number of stops, which are essential for fare calculations.
- **TrainScheduleDAO.java**: Manages interactions for `Train_Schedules`. This DAO:
  - Retrieves full route schedules.
  - Dynamically generates and manages segment schedules based on data from `Stops_At`.
  - Includes the `calculateFare` method, which calculates fare based on segment stops.
  - Has search functionality that can return both full routes and dynamically generated segments.
- **StopsAtDAO.java**: Handles data for `Stops_At`, which includes each stop along a full route. This DAO provides:
  - Methods for fetching stops for a specific schedule.
  - Calculation of arrival and departure times for each segment.
  - Methods to retrieve stop numbers for calculating segment distances within a route.
- **StationDAO.java**: Manages station-related operations, providing methods for retrieving station details by `stationID`.
- **TrainDAO.java**: Manages train-related data, including retrieving trains by `trainID`.

### 4. JSP Files

- **login.jsp**: The login page where users (customers, reps, and managers) authenticate themselves. It checks the credentials against the database and redirects them to their respective dashboards based on their roles.
- **register.jsp**: The registration page allows new customers to create accounts. It checks for unique usernames and email addresses to prevent duplication. Successful registrations are redirected to the login page.
- **customerDashboard.jsp**: The dashboard page specifically for customers, providing access to their bookings, schedule searches, and reservation management.
- **repDashboard.jsp**: The dashboard for customer representatives, allowing them to manage train schedules and respond to customer questions.
- **managerDashboard.jsp**: The dashboard for managers (admins), where they can view reports, manage employees, and review revenue and reservations.
- **logout.jsp**: This page ends the user’s session, logging them out and redirecting them to the login page.

### CSS (styles.css)
The CSS file is used to style the login, register, and dashboard pages, making the UI user-friendly and consistent across different pages.

### SQL Script for Sample Data

To test all cases, sample data includes:
- Full routes and segment schedules.
- Overlapping schedules for multiple transit lines with shared origins and destinations.
- Properly structured arrival and departure times across `Stops_At` to ensure dynamic segment generation functions as expected.

Refer to the provided SQL script to populate the database with test data covering:
1. Full route schedules.
2. Segment schedules dynamically derived from full routes.
3. Edge cases like matching full routes and segments on overlapping transit lines.
