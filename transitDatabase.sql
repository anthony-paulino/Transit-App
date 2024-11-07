-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS transitDatabase;
USE transitDatabase;

-- Step 2: Create the tables

-- Trains Table
CREATE TABLE IF NOT EXISTS Trains (
    trainID INT PRIMARY KEY
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
    baseFare FLOAT
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

-- Train_Schedules Table
CREATE TABLE IF NOT EXISTS Train_Schedules (
    scheduleID INT PRIMARY KEY,
    transitID INT,
    trainID INT,
    originID INT,
    destinationID INT,
    departureDateTime DATETIME,
    arrivalDateTime DATETIME,
    fare FLOAT,
    travelTime TIME,
    FOREIGN KEY (transitID) REFERENCES TransitLine(transitID),
    FOREIGN KEY (trainID) REFERENCES Trains(trainID),
    FOREIGN KEY (originID) REFERENCES Stations(stationID),
    FOREIGN KEY (destinationID) REFERENCES Stations(stationID)
);

-- Reservations Table
CREATE TABLE IF NOT EXISTS Reservations (
    reservationNumber INT PRIMARY KEY AUTO_INCREMENT,
    dateMade DATE,
    totalFare FLOAT,
    scheduleID INT,
    customerID INT,
    FOREIGN KEY (scheduleID) REFERENCES Train_Schedules(scheduleID),
    FOREIGN KEY (customerID) REFERENCES Customers(customerID)
);

-- Stops_At Table
CREATE TABLE IF NOT EXISTS Stops_At (
    scheduleID INT,
    stationID INT,
    stopNumber INT,
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

-- Sample data for TransitLine
INSERT INTO TransitLine (transitID, transitLineName, baseFare) VALUES
(1, 'Northeast Corridor', 50.00),
(2, 'Atlantic City Line', 30.00);

-- Sample data for Trains
INSERT INTO Trains (trainID) VALUES
(101),
(102);

-- Sample data for Stations
INSERT INTO Stations (stationID, name, city, state) VALUES
(1, 'Perth Amboy', 'Perth Amboy', 'NJ'),
(2, 'Woodbridge', 'Woodbridge', 'NJ'),
(3, 'Rahway', 'Rahway', 'NJ'),
(4, 'New York Penn', 'New York', 'NY');

-- Sample data for Train_Schedules
INSERT INTO Train_Schedules (scheduleID, transitID, trainID, originID, destinationID, departureDateTime, arrivalDateTime, fare, travelTime) VALUES
(1001, 1, 101, 1, 4, '2024-01-01 08:00:00', '2024-01-01 09:30:00', 50.00, '01:30:00'),
(1002, 2, 102, 1, 2, '2024-01-01 07:00:00', '2024-01-01 07:30:00', 15.00, '00:30:00');

-- Sample data for Customers
INSERT INTO Customers (customerID, lastName, firstName, emailAddress, username, password) VALUES
(1, 'Doe', 'John', 'johndoe@example.com', 'johndoe', 'password123'),
(2, 'Smith', 'Jane', 'janesmith@example.com', 'janesmith', 'securepass');

-- Sample data for Employees
INSERT INTO Employees (employeeID, ssn, lastName, firstName, username, password, isAdmin) VALUES
(1, '123-45-6789', 'Johnson', 'Alice', 'alicejohnson', 'adminpass', TRUE),
(2, '987-65-4321', 'Brown', 'Bob', 'bobbrown', 'password', FALSE);

-- Sample data for Reservations
INSERT INTO Reservations (reservationNumber, dateMade, totalFare, scheduleID, customerID) VALUES
(1, '2024-07-21', 50.00, 1001, 1),
(2, '2024-07-22', 15.00, 1002, 2);

-- Sample data for Stops_At
INSERT INTO Stops_At (scheduleID, stationID, stopNumber) VALUES
(1001, 1, 1),
(1001, 2, 2),
(1001, 3, 3),
(1001, 4, 4),
(1002, 1, 1),
(1002, 2, 2);

-- Sample data for Handles
INSERT INTO Handles (employeeID, reservationNumber) VALUES
(1, 1),
(2, 2);
