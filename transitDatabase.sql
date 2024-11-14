-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS transitDatabase;
USE transitDatabase;

-- Step 2: Create the tables (same as provided previously)

-- Trains Table
CREATE TABLE IF NOT EXISTS Trains (
    trainID INT CHECK (trainID BETWEEN 1000 AND 9999) PRIMARY KEY
);

-- Stations Table
CREATE TABLE IF NOT EXISTS Stations (
    stationID INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100)
);

-- TransitLine Table
CREATE TABLE IF NOT EXISTS TransitLine (
    transitID INT PRIMARY KEY,
    transitLineName VARCHAR(100),
    baseFare FLOAT,
    totalStops INT
);

-- Customers Table
CREATE TABLE IF NOT EXISTS Customers (
    customerID INT PRIMARY KEY AUTO_INCREMENT,
    lastName VARCHAR(50),
    firstName VARCHAR(50),
    emailAddress VARCHAR(250) UNIQUE,
    username VARCHAR(40) UNIQUE,
    password VARCHAR(50)
);

-- Employees Table
CREATE TABLE IF NOT EXISTS Employees (
    employeeID INT PRIMARY KEY AUTO_INCREMENT,
    ssn VARCHAR(11) UNIQUE,
    lastName VARCHAR(50),
    firstName VARCHAR(50),
    username VARCHAR(40) UNIQUE,
    password VARCHAR(50),
    isAdmin BOOLEAN
);

-- Train_Schedules Table with isFullRoute attribute, without fare and travelTime
CREATE TABLE IF NOT EXISTS Train_Schedules (
    scheduleID INT PRIMARY KEY,
    transitID INT,
    trainID INT,
    originID INT,
    destinationID INT,
    departureDateTime DATETIME,
    arrivalDateTime DATETIME,
    isFullRoute BOOLEAN,
    FOREIGN KEY (transitID) REFERENCES TransitLine(transitID),
    FOREIGN KEY (trainID) REFERENCES Trains(trainID),
    FOREIGN KEY (originID) REFERENCES Stations(stationID),
    FOREIGN KEY (destinationID) REFERENCES Stations(stationID)
);

-- Reservations Table (without totalFare)
CREATE TABLE IF NOT EXISTS Reservations (
    reservationNumber INT PRIMARY KEY AUTO_INCREMENT,
    dateMade DATE,
    scheduleID INT,
    customerID INT,
    originID INT,
    destinationID INT,
    ticketType ENUM('adult', 'child', 'senior', 'disabled') NOT NULL,  
    tripType ENUM('oneWay', 'roundTrip') NOT NULL,                   
    fare DECIMAL(10, 2) NOT NULL,                                      
    FOREIGN KEY (scheduleID) REFERENCES Train_Schedules(scheduleID),
    FOREIGN KEY (customerID) REFERENCES Customers(customerID),
    FOREIGN KEY (originID) REFERENCES Stations(stationID),
    FOREIGN KEY (destinationID) REFERENCES Stations(stationID)
);


-- Stops_At Table
CREATE TABLE IF NOT EXISTS Stops_At (
    scheduleID INT,
    stationID INT,
    stopNumber INT,
    arrivalDateTime DATETIME,
    departureDateTime DATETIME,
    PRIMARY KEY (scheduleID, stationID),
    FOREIGN KEY (scheduleID) REFERENCES Train_Schedules(scheduleID),
    FOREIGN KEY (stationID) REFERENCES Stations(stationID)
);

-- Handles Table
CREATE TABLE IF NOT EXISTS Handles (
    employeeID INT,
    reservationNumber INT,
    PRIMARY KEY (employeeID, reservationNumber),
    FOREIGN KEY (employeeID) REFERENCES Employees(employeeID),
    FOREIGN KEY (reservationNumber) REFERENCES Reservations(reservationNumber)
);

-- Step 3: Insert sample data

-- Sample data for Customers
INSERT INTO Customers (customerID, lastName, firstName, emailAddress, username, password) VALUES
(1, 'Doe', 'John', 'johndoe@example.com', 'johndoe', '123'),
(2, 'Smith', 'Jane', 'janesmith@example.com', 'janesmith', 'securepass'),
(3, 'Johnson', 'Mark', 'markjohnson@example.com', 'markjohnson', 'markpass');

-- Sample data for Employees
INSERT INTO Employees (employeeID, ssn, lastName, firstName, username, password, isAdmin) VALUES
(1, '123-45-6789', 'Johnson', 'Alice', 'alicejohnson', 'adminpass', TRUE),
(2, '987-65-4321', 'Brown', 'Bob', 'bobbrown', 'password', FALSE);

-- Trains
INSERT INTO Trains (trainID) VALUES (1001), (1002), (1003);

-- Stations
INSERT INTO Stations (stationID, name, city, state) VALUES
(1, 'Perth Amboy', 'Perth Amboy', 'NJ'),
(2, 'Woodbridge', 'Woodbridge', 'NJ'),
(3, 'Rahway', 'Rahway', 'NJ'),
(4, 'Elizabeth', 'Elizabeth', 'NJ'),
(5, 'Newark Penn', 'Newark', 'NJ'),
(6, 'Secaucus', 'Secaucus', 'NJ'),
(7, 'New York Penn', 'New York', 'NY');

-- TransitLines
INSERT INTO TransitLine (transitID, transitLineName, baseFare, totalStops) VALUES
(1, 'Northeast Corridor', 50.00, 7),
(2, 'Atlantic City Line', 30.00, 5),
(3, 'North Jersey Coast Line', 40.00, 6);

-- Train Schedules (Full Routes)
INSERT INTO Train_Schedules (scheduleID, transitID, trainID, originID, destinationID, departureDateTime, arrivalDateTime) VALUES
(1001, 1, 1001, 1, 7, '2024-11-13 08:00:00', '2024-11-13 09:45:00'),  -- Full route for Northeast Corridor
(1002, 2, 1002, 2, 5, '2024-11-13 07:30:00', '2024-11-13 08:30:00'),  -- Full route for Atlantic City Line
(1003, 3, 1003, 1, 6, '2024-11-13 06:00:00', '2024-11-13 07:30:00');  -- Full route for North Jersey Coast Line

-- Stops_At with arrival and departure times for each schedule

-- Northeast Corridor (scheduleID 1001)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(1001, 1, 1, NULL, '2024-11-13 08:00:00'), -- Route starts
(1001, 2, 2, '2024-11-13 08:15:00', '2024-11-13 08:20:00'),
(1001, 3, 3, '2024-11-13 08:30:00', '2024-11-13 08:35:00'),
(1001, 4, 4, '2024-11-13 08:50:00', '2024-11-13 08:55:00'),
(1001, 5, 5, '2024-11-13 09:05:00', '2024-11-13 09:10:00'),
(1001, 6, 6, '2024-11-13 09:25:00', '2024-11-13 09:30:00'),
(1001, 7, 7, '2024-11-13 09:45:00', NULL); -- Route ends

-- Atlantic City Line (scheduleID 1002)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(1002, 2, 1, NULL, '2024-11-13 07:30:00'), -- Route starts
(1002, 3, 2, '2024-11-13 07:45:00', '2024-11-13 07:50:00'),
(1002, 4, 3, '2024-11-13 08:00:00', '2024-11-13 08:05:00'),
(1002, 5, 4, '2024-11-13 08:20:00', '2024-11-13 08:25:00'),
(1002, 6, 5, '2024-11-13 08:30:00', NULL); -- Route ends

-- North Jersey Coast Line (scheduleID 1003)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(1003, 1, 1, NULL, '2024-11-13 06:00:00'), -- Route starts
(1003, 2, 2, '2024-11-13 06:15:00', '2024-11-13 06:20:00'),
(1003, 3, 3, '2024-11-13 06:30:00', '2024-11-13 06:35:00'),
(1003, 4, 4, '2024-11-13 06:55:00', '2024-11-13 07:00:00'),
(1003, 5, 5, '2024-11-13 07:15:00', '2024-11-13 07:20:00'),
(1003, 6, 6, '2024-11-13 07:30:00', NULL); -- Route ends

-- Reservations
INSERT INTO Reservations (reservationNumber, dateMade, scheduleID, originID, destinationID, customerID, ticketType, tripType, fare) VALUES
(1, '2024-11-10', 1001, 1, 7, 1, 'adult', 'roundTrip', '100.00'), -- John Doe reservation for Northeast Corridor full route
(2, '2024-11-10', 1002, 2, 6, 2, 'adult', 'roundTrip', '60.00'); -- Jane Smith reservation for Atlantic City Line full route


-- Handles - Linking reservations with employees
INSERT INTO Handles (employeeID, reservationNumber) VALUES
(1, 1), -- Employee Alice Johnson handles reservation 1
(1, 2); -- Employee Alice Johnson handles reservation 2
