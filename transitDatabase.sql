-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS transitDatabase;
USE transitDatabase;

-- Step 2: Create the tables

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

-- Train_Schedules Table 
CREATE TABLE IF NOT EXISTS Train_Schedules (
    scheduleID INT PRIMARY KEY,
    transitID INT,
    trainID INT,
    originID INT,
    destinationID INT,
    departureDateTime DATETIME,
    arrivalDateTime DATETIME,
    tripDirection ENUM('forward', 'return') NOT NULL, -- Added field to distinguish forward and return trips
    FOREIGN KEY (transitID) REFERENCES TransitLine(transitID),
    FOREIGN KEY (trainID) REFERENCES Trains(trainID),
    FOREIGN KEY (originID) REFERENCES Stations(stationID),
    FOREIGN KEY (destinationID) REFERENCES Stations(stationID)
);

-- Reservations Table
CREATE TABLE IF NOT EXISTS Reservations (
    reservationID INT PRIMARY KEY AUTO_INCREMENT, -- Unique ID for the reservation
    customerID INT NOT NULL,                               -- Customer making the reservation
    dateMade DATE NOT NULL,                       -- Date the reservation was created
    totalFare DECIMAL(10, 2) NOT NULL,            -- Total fare for the reservation
    FOREIGN KEY (customerID) REFERENCES Customers(customerID)
);

-- Tickets Table
CREATE TABLE IF NOT EXISTS Tickets (
    ticketID INT PRIMARY KEY AUTO_INCREMENT,
    reservationID INT,
    scheduleID INT,
    dateMade DATE,
    originID INT,
    destinationID INT,
    ticketType ENUM('adult', 'child', 'senior', 'disabled') NOT NULL,
    tripType ENUM('oneWay', 'roundTrip') NOT NULL,
    fare DECIMAL(10, 2) NOT NULL,
    linkedTicketID INT DEFAULT NULL, -- Link to the incoming ticket for round trips
    FOREIGN KEY (reservationID) REFERENCES Reservations(reservationID),
    FOREIGN KEY (scheduleID) REFERENCES Train_Schedules(scheduleID),
    FOREIGN KEY (originID) REFERENCES Stations(stationID),
    FOREIGN KEY (destinationID) REFERENCES Stations(stationID),
    FOREIGN KEY (linkedTicketID) REFERENCES Tickets(ticketID) -- Self-referencing foreign key
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

-- Table to store questions posted by customers
CREATE TABLE IF NOT EXISTS QuestionPost (
    questionID INT AUTO_INCREMENT PRIMARY KEY,
    question TEXT NOT NULL,
    customerID INT,
    customerName VARCHAR(255),
    username VARCHAR(255),
    datePosted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(225),
    FOREIGN KEY (customerID) REFERENCES Customers(customerID)
);

-- Table to store replies or comments on questions
CREATE TABLE IF NOT EXISTS CommentReply (
    commentID INT AUTO_INCREMENT PRIMARY KEY,
    comment TEXT NOT NULL,
    customerID INT,
    employeeID INT,
    datePosted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customerID) REFERENCES Customers(customerID),
    FOREIGN KEY (employeeID) REFERENCES Employees(employeeID)
);

-- Junction table to associate comments/replies with specific questions
CREATE TABLE IF NOT EXISTS QuestionHasComment (
    questionID INT,
    commentID INT,
    PRIMARY KEY (questionID, commentID),
    FOREIGN KEY (questionID) REFERENCES QuestionPost(questionID),
    FOREIGN KEY (commentID) REFERENCES CommentReply(commentID)
);

-- Step 3: Insert sample data

-- Sample data for Customers
INSERT INTO Customers (customerID, lastName, firstName, emailAddress, username, password) VALUES
(1, 'Doe', 'John', 'johndoe@example.com', 'johndoe', '123'),
(2, 'Smith', 'Jane', 'janesmith@example.com', 'janesmith', '123'),
(3, 'Johnson', 'Mark', 'markjohnson@example.com', 'markjohnson', '123');

-- Sample data for Employees
INSERT INTO Employees (employeeID, ssn, lastName, firstName, username, password, isAdmin) VALUES
(1, '123-45-6789', 'Johnson', 'Alice', 'alicejohnson', 'admin', TRUE),
(2, '987-65-4321', 'Brown', 'Bob', 'bobbrown', 'rep', FALSE);

-- Trains
INSERT INTO Trains (trainID) VALUES (1001), (1002), (1003), (1004), (1005);

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
(2, 'Atlantic City Line', 30.00, 5);

-- Train_Schedules Table (including realistic forward and return trips)

INSERT INTO Train_Schedules (scheduleID, transitID, trainID, originID, destinationID, departureDateTime, arrivalDateTime, tripDirection) VALUES

-- Northeast Corridor (transitID = 1) forward and return trips
(1001, 1, 1001, 1, 7, '2024-11-13 06:00:00', '2024-11-13 07:30:00', 'forward'),  -- Forward trip 1
(1002, 1, 1001, 7, 1, '2024-11-13 08:00:00', '2024-11-13 09:30:00', 'return'),   -- Return trip 1
(1003, 1, 1002, 1, 7, '2024-11-13 10:00:00', '2024-11-13 11:30:00', 'forward'),  -- Forward trip 2
(1004, 1, 1002, 7, 1, '2024-11-13 12:00:00', '2024-11-13 13:30:00', 'return'),   -- Return trip 2
(1005, 1, 1003, 1, 7, '2024-11-13 14:00:00', '2024-11-13 15:30:00', 'forward'),  -- Forward trip 3
(1006, 1, 1003, 7, 1, '2024-11-13 16:00:00', '2024-11-13 17:30:00', 'return'),   -- Return trip 3

-- Atlantic City Line (transitID = 2) forward and return trips
(2001, 2, 1004, 2, 5, '2024-11-13 07:00:00', '2024-11-13 08:15:00', 'forward'),  -- Forward trip 1
(2002, 2, 1004, 5, 2, '2024-11-13 09:00:00', '2024-11-13 10:15:00', 'return'),   -- Return trip 1
(2003, 2, 1005, 2, 5, '2024-11-13 11:00:00', '2024-11-13 12:15:00', 'forward'),  -- Forward trip 2
(2004, 2, 1005, 5, 2, '2024-11-13 13:00:00', '2024-11-13 14:15:00', 'return');   -- Return trip 2

-- Stops_At Data for Forward and Return trips

-- Stops for Northeast Corridor forward trip 1 (scheduleID 1001)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(1001, 1, 1, NULL, '2024-11-13 06:00:00'),
(1001, 2, 2, '2024-11-13 06:15:00', '2024-11-13 06:20:00'),
(1001, 3, 3, '2024-11-13 06:30:00', '2024-11-13 06:35:00'),
(1001, 4, 4, '2024-11-13 06:50:00', '2024-11-13 06:55:00'),
(1001, 5, 5, '2024-11-13 07:05:00', '2024-11-13 07:10:00'),
(1001, 6, 6, '2024-11-13 07:20:00', '2024-11-13 07:25:00'),
(1001, 7, 7, '2024-11-13 07:30:00', NULL);

-- Stops for Northeast Corridor return trip 1 (scheduleID 1002)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(1002, 7, 1, NULL, '2024-11-13 08:00:00'),
(1002, 6, 2, '2024-11-13 08:15:00', '2024-11-13 08:20:00'),
(1002, 5, 3, '2024-11-13 08:30:00', '2024-11-13 08:35:00'),
(1002, 4, 4, '2024-11-13 08:50:00', '2024-11-13 08:55:00'),
(1002, 3, 5, '2024-11-13 09:05:00', '2024-11-13 09:10:00'),
(1002, 2, 6, '2024-11-13 09:20:00', '2024-11-13 09:25:00'),
(1002, 1, 7, '2024-11-13 09:30:00', NULL);

-- Stops for Northeast Corridor forward trip 2 (scheduleID 1003)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(1003, 1, 1, NULL, '2024-11-13 10:00:00'),
(1003, 2, 2, '2024-11-13 10:15:00', '2024-11-13 10:20:00'),
(1003, 3, 3, '2024-11-13 10:30:00', '2024-11-13 10:35:00'),
(1003, 4, 4, '2024-11-13 10:50:00', '2024-11-13 10:55:00'),
(1003, 5, 5, '2024-11-13 11:05:00', '2024-11-13 11:10:00'),
(1003, 6, 6, '2024-11-13 11:20:00', '2024-11-13 11:25:00'),
(1003, 7, 7, '2024-11-13 11:30:00', NULL);

-- Stops for Northeast Corridor return trip 2 (scheduleID 1004)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(1004, 7, 1, NULL, '2024-11-13 12:00:00'),
(1004, 6, 2, '2024-11-13 12:15:00', '2024-11-13 12:20:00'),
(1004, 5, 3, '2024-11-13 12:30:00', '2024-11-13 12:35:00'),
(1004, 4, 4, '2024-11-13 12:50:00', '2024-11-13 12:55:00'),
(1004, 3, 5, '2024-11-13 13:05:00', '2024-11-13 13:10:00'),
(1004, 2, 6, '2024-11-13 13:20:00', '2024-11-13 13:25:00'),
(1004, 1, 7, '2024-11-13 13:30:00', NULL);

-- Stops for Northeast Corridor forward trip 3 (scheduleID 1005)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(1005, 1, 1, NULL, '2024-11-13 14:00:00'),
(1005, 2, 2, '2024-11-13 14:15:00', '2024-11-13 14:20:00'),
(1005, 3, 3, '2024-11-13 14:30:00', '2024-11-13 14:35:00'),
(1005, 4, 4, '2024-11-13 14:50:00', '2024-11-13 14:55:00'),
(1005, 5, 5, '2024-11-13 15:05:00', '2024-11-13 15:10:00'),
(1005, 6, 6, '2024-11-13 15:20:00', '2024-11-13 15:25:00'),
(1005, 7, 7, '2024-11-13 15:30:00', NULL);

-- Stops for Northeast Corridor return trip 3 (scheduleID 1006)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(1006, 7, 1, NULL, '2024-11-13 16:00:00'),
(1006, 6, 2, '2024-11-13 16:15:00', '2024-11-13 16:20:00'),
(1006, 5, 3, '2024-11-13 16:30:00', '2024-11-13 16:35:00'),
(1006, 4, 4, '2024-11-13 16:50:00', '2024-11-13 16:55:00'),
(1006, 3, 5, '2024-11-13 17:05:00', '2024-11-13 17:10:00'),
(1006, 2, 6, '2024-11-13 17:20:00', '2024-11-13 17:25:00'),
(1006, 1, 7, '2024-11-13 17:30:00', NULL);

-- Stops for Atlantic City Line forward trip 1 (scheduleID 2001)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(2001, 2, 1, NULL, '2024-11-13 07:00:00'),
(2001, 3, 2, '2024-11-13 07:15:00', '2024-11-13 07:20:00'),
(2001, 4, 3, '2024-11-13 07:30:00', '2024-11-13 07:35:00'),
(2001, 5, 4, '2024-11-13 07:45:00', NULL);

-- Stops for Atlantic City Line return trip 1 (scheduleID 2002)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(2002, 5, 1, NULL, '2024-11-13 09:00:00'),
(2002, 4, 2, '2024-11-13 09:15:00', '2024-11-13 09:20:00'),
(2002, 3, 3, '2024-11-13 09:30:00', '2024-11-13 09:35:00'),
(2002, 2, 4, '2024-11-13 09:45:00', NULL);

-- Stops for Atlantic City Line forward trip 2 (scheduleID 2003)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(2003, 2, 1, NULL, '2024-11-13 11:00:00'),
(2003, 3, 2, '2024-11-13 11:15:00', '2024-11-13 11:20:00'),
(2003, 4, 3, '2024-11-13 11:30:00', '2024-11-13 11:35:00'),
(2003, 5, 4, '2024-11-13 11:45:00', NULL);

-- Stops for Atlantic City Line return trip 2 (scheduleID 2004)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime) VALUES
(2004, 5, 1, NULL, '2024-11-13 13:00:00'),
(2004, 4, 2, '2024-11-13 13:15:00', '2024-11-13 13:20:00'),
(2004, 3, 3, '2024-11-13 13:30:00', '2024-11-13 13:35:00'),
(2004, 2, 4, '2024-11-13 13:45:00', NULL);


