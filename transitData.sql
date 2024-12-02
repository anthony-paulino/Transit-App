-- Insert Customers
INSERT INTO Customers (customerID, lastName, firstName, emailAddress, username, password) VALUES
(1, 'Doe', 'John', 'johndoe@example.com', 'johndoe', '123'),
(2, 'Smith', 'Jane', 'janesmith@example.com', 'jane', '123'),
(3, 'Johnson', 'Mark', 'markjohnson@example.com', 'mark', '123'),
(4, 'Paulino', 'Anthony', 'anthonypaulino@example.com', 'ap2043', '123');

-- Insert Employees
INSERT INTO Employees (employeeID, ssn, firstName, lastname, username, password, isAdmin) VALUES
(1, '123-45-6789', 'Johnson', 'Alice', 'alicejohnson', 'admin', TRUE),
(2, '987-65-4321', 'Brown', 'Bob', 'bobbrown', 'rep', FALSE),
(3, '431-65-2323', 'Edit', 'Me', 'EditTest', 'rep', FALSE),
(4, '931-65-3321', 'Delete', 'Me', 'DeleteTest', 'rep', FALSE);

-- Insert Trains
INSERT INTO Trains (trainID) VALUES
(1001), (1002), (1003), (1004), (1005), (1006), (1007), (1008), (1009), (1010), (1011), (1012);

-- Insert Stations
INSERT INTO Stations (stationID, name, city, state) VALUES
(1, 'Perth Amboy', 'Perth Amboy', 'NJ'),
(2, 'Woodbridge', 'Woodbridge', 'NJ'),
(3, 'Rahway', 'Rahway', 'NJ'),
(4, 'Elizabeth', 'Elizabeth', 'NJ'),
(5, 'Newark Penn', 'Newark', 'NJ'),
(6, 'Secaucus', 'Secaucus', 'NJ'),
(7, 'New York Penn', 'New York', 'NY'),
(8, 'Long Branch', 'Long Branch', 'NJ'),
(9, 'Asbury Park', 'Asbury Park', 'NJ'),
(10, 'Belmar', 'Belmar', 'NJ'),
(11, 'Point Pleasant', 'Point Pleasant', 'NJ'),
(12, 'Toms River', 'Toms River', 'NJ'),
(13, 'Atlantic City', 'Atlantic City', 'NJ');

-- Insert Transit Lines
INSERT INTO TransitLine (transitID, transitLineName, baseFare, totalStops) VALUES
(1, 'Northeast Corridor', 50.00, 7),
(2, 'Atlantic City Line', 30.00, 4),
(3, 'Jersey Shore Line', 40.00, 6),
(4, 'Quick Stop Shuttle', 35.00, 3),
(5, 'Counter Middle Nav', 25.00, 4);

-- Populate Train Schedules for October, November, December
INSERT INTO Train_Schedules (scheduleID, transitID, trainID, originID, destinationID, departureDateTime, arrivalDateTime, tripDirection)
SELECT
    (base_schedule.scheduleID * 100) + day_offset AS scheduleID, -- Ensure unique IDs by adding day offset
    base_schedule.transitID,
    base_schedule.trainID,
    base_schedule.originID,
    base_schedule.destinationID,
    DATE_ADD(base_schedule.departureDateTime, INTERVAL day_offset DAY) AS departureDateTime,
    DATE_ADD(base_schedule.arrivalDateTime, INTERVAL day_offset DAY) AS arrivalDateTime,
    base_schedule.tripDirection
FROM (
    -- Base schedule for one day
    SELECT
        1000 AS scheduleID, 1 AS transitID, 1001 AS trainID, 1 AS originID, 7 AS destinationID,
        '2024-10-01 06:00:00' AS departureDateTime, '2024-10-01 07:30:00' AS arrivalDateTime, 'forward' AS tripDirection
    UNION ALL
    SELECT 1001, 1, 1001, 7, 1, '2024-10-01 08:00:00', '2024-10-01 09:30:00', 'return'
    UNION ALL
    SELECT 1002, 1, 1002, 1, 7, '2024-10-01 10:00:00', '2024-10-01 11:30:00', 'forward'
    UNION ALL
    SELECT 1003, 1, 1002, 7, 1, '2024-10-01 12:00:00', '2024-10-01 13:30:00', 'return'
    UNION ALL
    SELECT 1004, 1, 1003, 1, 7, '2024-10-01 14:00:00', '2024-10-01 15:30:00', 'forward'
    UNION ALL
    SELECT 1005, 1, 1003, 7, 1, '2024-10-01 16:00:00', '2024-10-01 17:30:00', 'return'
    UNION ALL
    SELECT
        2000 AS scheduleID, 2 AS transitID, 1004 AS trainID, 2 AS originID, 5 AS destinationID,
        '2024-10-01 07:00:00' AS departureDateTime, '2024-10-01 08:15:00' AS arrivalDateTime, 'forward' AS tripDirection
    UNION ALL
    SELECT 2001, 2, 1004, 5, 2, '2024-10-01 09:00:00', '2024-10-01 10:15:00', 'return'
    UNION ALL
    SELECT 2002, 2, 1005, 2, 5, '2024-10-01 11:00:00', '2024-10-01 12:15:00', 'forward'
    UNION ALL
    SELECT 2003, 2, 1005, 5, 2, '2024-10-01 13:00:00', '2024-10-01 14:15:00', 'return'
    UNION ALL
    SELECT
        3000 AS scheduleID, 3 AS transitID, 1006 AS trainID, 8 AS originID, 13 AS destinationID,
        '2024-10-01 05:30:00' AS departureDateTime, '2024-10-01 07:10:00' AS arrivalDateTime, 'forward' AS tripDirection -- Foward trip 1
    UNION ALL
    SELECT 3001, 3, 1006, 13, 8, '2024-10-01 7:30:00', '2024-10-01 9:10:00', 'return' -- Return trip 1
    UNION ALL 
    SELECT 3002, 3, 1007, 8, 13, '2024-10-01 10:00:00', '2024-10-01 11:40:00', 'forward' -- Forward trip 2
    UNION ALL
    SELECT 3003, 3, 1007, 13, 8, '2024-10-01 12:00:00', '2024-10-01 13:40:00', 'return' -- Return trip 2
    UNION ALL
    SELECT 3004, 3, 1008, 8, 13, '2024-10-01 15:00:00', '2024-10-01 17:40:00', 'forward' -- Forward trip 3
    UNION ALL 
    SELECT 3005, 3, 1008, 13, 8, '2024-10-01 18:20:00', '2024-10-01 20:00:00', 'return' -- Return trip 3
	UNION ALL

     SELECT
        4000 AS scheduleID, 4 AS transitID, 1009 AS trainID, 1 AS originID, 3 AS destinationID,
        '2024-10-01 07:00:00' AS departureDateTime, '2024-10-01 07:40:00' AS arrivalDateTime, 'forward' AS tripDirection
    UNION ALL
    SELECT 4001, 4, 1009, 3, 1, '2024-10-01 7:50:00', '2024-10-01 8:30:00', 'return'
    UNION ALL
    SELECT 4002, 4, 1010, 1, 3, '2024-10-01 9:00:00', '2024-10-01 9:40:00', 'forward'
    UNION ALL
    SELECT 4003, 4, 1010, 3, 1, '2024-10-01 10:00:00', '2024-10-01 10:40:00', 'return'
    UNION ALL
    
    SELECT
        5000 AS scheduleID, 5 AS transitID, 1011 AS trainID, 2 AS originID, 9 AS destinationID,
        '2024-10-01 07:00:00' AS departureDateTime, '2024-10-01 08:15:00' AS arrivalDateTime, 'forward' AS tripDirection
    UNION ALL
    SELECT 5001, 5, 1011, 9, 6, '2024-10-01 09:00:00', '2024-10-01 10:15:00', 'return'
    UNION ALL
    SELECT 5002, 5, 1012, 6, 9, '2024-10-01 11:00:00', '2024-10-01 12:15:00', 'forward'
    UNION ALL
    SELECT 5003, 5, 1012, 9, 6, '2024-10-01 13:00:00', '2024-10-01 14:15:00', 'return'
    
) base_schedule
-- Generate valid days for October, November, and December (day offsets for the full date range)
CROSS JOIN (
    WITH RECURSIVE day_offsets AS (
        SELECT 0 AS day_offset
        UNION ALL
        SELECT day_offset + 1
        FROM day_offsets
        WHERE day_offset + 1 <= 61 -- 61 days for Oct, Nov
    )
    SELECT DATE_ADD('2024-10-01', INTERVAL day_offset DAY) AS schedule_date, day_offset
    FROM day_offsets
    WHERE DATE_ADD('2024-10-01', INTERVAL day_offset DAY) <= '2024-11-30'
) dates;

-- Stops_At Data for Forward and Return trips (for October, November, December)
INSERT INTO Stops_At (scheduleID, stationID, stopNumber, arrivalDateTime, departureDateTime)
SELECT
    -- Create unique scheduleID by adding day_offset
    (base_schedule.scheduleID * 100) + day_offset AS scheduleID, -- Ensure unique IDs by adding day offset
    base_schedule.stationID,
    base_schedule.stopNumber,
    DATE_ADD(base_schedule.arrivalDateTime, INTERVAL day_offset DAY) AS arrivalDateTime,
    DATE_ADD(base_schedule.departureDateTime, INTERVAL day_offset DAY) AS departureDateTime
FROM (
    -- Base stops for each trip (forward and return) with original scheduleID, stationID, and stop information
    SELECT
        1000 AS scheduleID, 1 AS stationID, 1 AS stopNumber, NULL AS arrivalDateTime, '2024-10-01 06:00:00' AS departureDateTime
    UNION ALL
    SELECT 1000, 2, 2, '2024-10-01 06:15:00', '2024-10-01 06:20:00'
    UNION ALL
    SELECT 1000, 3, 3, '2024-10-01 06:30:00', '2024-10-01 06:35:00'
    UNION ALL
    SELECT 1000, 4, 4, '2024-10-01 06:50:00', '2024-10-01 06:55:00'
    UNION ALL
    SELECT 1000, 5, 5, '2024-10-01 07:05:00', '2024-10-01 07:10:00'
    UNION ALL
    SELECT 1000, 6, 6, '2024-10-01 07:20:00', '2024-10-01 07:25:00'
    UNION ALL
    SELECT 1000, 7, 7, '2024-10-01 07:30:00', NULL
	UNION ALL
    
    SELECT 1001, 7, 1, NULL, '2024-10-01 08:00:00'
    UNION ALL
    SELECT 1001, 6, 2, '2024-10-01 08:15:00', '2024-10-01 08:20:00'
    UNION ALL
    SELECT 1001, 5, 3, '2024-10-01 08:30:00', '2024-10-01 08:35:00'
    UNION ALL
    SELECT 1001, 4, 4, '2024-10-01 08:50:00', '2024-10-01 08:55:00'
    UNION ALL
    SELECT 1001, 3, 5, '2024-10-01 09:05:00', '2024-10-01 09:10:00'
    UNION ALL
    SELECT 1001, 2, 6, '2024-10-01 09:20:00', '2024-10-01 09:25:00'
    UNION ALL
    SELECT 1001, 1, 7, '2024-10-01 09:30:00', NULL
    
    UNION ALL
    SELECT 1002, 1, 1, NULL, '2024-10-01 10:00:00'
    UNION ALL
    SELECT 1002, 2, 2, '2024-10-01 10:15:00', '2024-10-01 10:20:00'
    UNION ALL
    SELECT 1002, 3, 3, '2024-10-01 10:30:00', '2024-10-01 10:35:00'
    UNION ALL
    SELECT 1002, 4, 4, '2024-10-01 10:50:00', '2024-10-01 10:55:00'
    UNION ALL
    SELECT 1002, 5, 5, '2024-10-01 11:05:00', '2024-10-01 11:10:00'
    UNION ALL
    SELECT 1002, 6, 6, '2024-10-01 11:20:00', '2024-10-01 11:25:00'
    UNION ALL
    SELECT 1002, 7, 7, '2024-10-01 11:30:00', NULL
    
    UNION ALL
	SELECT 1003, 7, 1, NULL, '2024-10-01 12:00:00'
    UNION ALL
	SELECT 1003, 6, 2, '2024-10-01 12:15:00', '2024-10-01 12:20:00'
    UNION ALL
	SELECT 1003, 5, 3, '2024-10-01 12:30:00', '2024-10-01 12:35:00'
    UNION ALL
	SELECT 1003, 4, 4, '2024-10-01 12:50:00', '2024-10-01 12:55:00'
    UNION ALL
	SELECT 1003, 3, 5, '2024-10-01 13:05:00', '2024-10-01 13:10:00'
    UNION ALL
	SELECT 1003, 2, 6, '2024-10-01 13:20:00', '2024-10-01 13:25:00'
    UNION ALL
	SELECT 1003, 1, 7, '2024-10-01 13:30:00', NULL

	UNION ALL
	SELECT 1004, 1, 1, NULL, '2024-10-01 14:00:00'
    UNION ALL
	SELECT 1004, 2, 2, '2024-10-01 14:15:00', '2024-10-01 14:20:00'
    UNION ALL
	SELECT 1004, 3, 3, '2024-10-01 14:30:00', '2024-10-01 14:35:00'
    UNION ALL
	SELECT 1004, 4, 4, '2024-10-01 14:50:00', '2024-10-01 14:55:00'
    UNION ALL
	SELECT 1004, 5, 5, '2024-10-01 15:05:00', '2024-10-01 15:10:00'
    UNION ALL
	SELECT 1004, 6, 6, '2024-10-01 15:20:00', '2024-10-01 15:25:00'
    UNION ALL
	SELECT 1004, 7, 7, '2024-10-01 15:30:00', NULL
    
    UNION ALL
	SELECT 1005, 7, 1, NULL, '2024-10-01 16:00:00'
    UNION ALL
	SELECT 1005, 6, 2, '2024-10-01 16:15:00', '2024-10-01 16:20:00'
    UNION ALL
	SELECT 1005, 5, 3, '2024-10-01 16:30:00', '2024-10-01 16:35:00'
    UNION ALL
	SELECT 1005, 4, 4, '2024-10-01 16:50:00', '2024-10-01 16:55:00'
    UNION ALL
	SELECT 1005, 3, 5, '2024-10-01 17:05:00', '2024-10-01 17:10:00'
    UNION ALL
	SELECT 1005, 2, 6, '2024-10-01 17:20:00', '2024-10-01 17:25:00'
    UNION ALL
	SELECT 1005, 1, 7, '2024-10-01 17:30:00', NULL
    
    UNION ALL
	SELECT 2000, 2, 1, NULL, '2024-10-01 07:00:00'
    UNION ALL
	SELECT 2000, 6, 2, '2024-10-01 07:15:00', '2024-10-01 07:20:00'
	UNION ALL
	SELECT 2000, 7, 3, '2024-10-01 07:30:00', '2024-10-01 07:35:00'
    UNION ALL
	SELECT 2000, 5, 4, '2024-10-01 07:45:00', NULL
    
    UNION ALL
	SELECT 2001, 5, 1, NULL, '2024-10-01 09:00:00'
	UNION ALL
	SELECT 2001, 7, 2, '2024-10-01 09:15:00', '2024-10-01 09:20:00'
    UNION ALL
	SELECT 2001, 6, 3, '2024-10-01 09:30:00', '2024-10-01 09:35:00'
    UNION ALL
	SELECT 2001, 2, 4, '2024-10-01 09:45:00', NULL
    
	UNION ALL
	SELECT 2002, 2, 1, NULL, '2024-10-01 11:00:00'
	UNION ALL
	SELECT 2002, 6, 2, '2024-10-01 11:15:00', '2024-10-01 11:20:00'
	UNION ALL
	SELECT 2002, 7, 3, '2024-10-01 11:30:00', '2024-10-01 11:35:00'
	UNION ALL
	SELECT 2002, 5, 4, '2024-10-01 11:45:00', NULL

	UNION ALL
	SELECT 2003, 5, 1, NULL, '2024-10-01 13:00:00'
	UNION ALL
	SELECT 2003, 7, 2, '2024-10-01 13:15:00', '2024-10-01 13:20:00'
	UNION ALL
	SELECT 2003, 6, 3, '2024-10-01 13:30:00', '2024-10-01 13:35:00'
	UNION ALL
	SELECT 2003, 2, 4, '2024-10-01 13:45:00', NULL 
    
    UNION ALL
	SELECT 5000, 6, 1, NULL, '2024-10-01 07:00:00'
    UNION ALL
	SELECT 5000, 7, 2, '2024-10-01 07:15:00', '2024-10-01 07:20:00'
	UNION ALL
	SELECT 5000, 8, 3, '2024-10-01 07:30:00', '2024-10-01 07:35:00'
    UNION ALL
	SELECT 5000, 9, 4, '2024-10-01 07:45:00', NULL
    
    UNION ALL
	SELECT 5001, 9, 1, NULL, '2024-10-01 09:00:00'
	UNION ALL
	SELECT 5001, 8, 2, '2024-10-01 09:15:00', '2024-10-01 09:20:00'
    UNION ALL
	SELECT 5001, 7, 3, '2024-10-01 09:30:00', '2024-10-01 09:35:00'
    UNION ALL
	SELECT 5001, 6, 4, '2024-10-01 09:45:00', NULL
    
	UNION ALL
	SELECT 5002, 6, 1, NULL, '2024-10-01 11:00:00'
	UNION ALL
	SELECT 5002, 7, 2, '2024-10-01 11:15:00', '2024-10-01 11:20:00'
	UNION ALL
	SELECT 5002, 8, 3, '2024-10-01 11:30:00', '2024-10-01 11:35:00'
	UNION ALL
	SELECT 5002, 9, 4, '2024-10-01 11:45:00', NULL

	UNION ALL
	SELECT 5003, 9, 1, NULL, '2024-10-01 13:00:00'
	UNION ALL
	SELECT 5003, 8, 2, '2024-10-01 13:15:00', '2024-10-01 13:20:00'
	UNION ALL
	SELECT 5003, 7, 3, '2024-10-01 13:30:00', '2024-10-01 13:35:00'
	UNION ALL
	SELECT 5003, 6, 4, '2024-10-01 13:45:00', NULL
	
    UNION ALL
	SELECT 3000, 8, 1, NULL, '2024-10-01 05:30:00'
    UNION ALL
	SELECT 3000, 9, 2, '2024-10-01 05:50:00', '2024-10-01 05:55:00'
    UNION ALL
	SELECT 3000, 10, 3, '2024-10-01 06:10:00', '2024-10-01 06:15:00'
    UNION ALL
	SELECT 3000, 11, 4, '2024-10-01 06:30:00', '2024-10-01 06:35:00'
    UNION ALL
	SELECT 3000, 12, 5, '2024-10-01 06:50:00', '2024-10-01 06:55:00'
    UNION ALL
	SELECT 3000, 13, 6, '2024-10-01 7:10:00', NULL
	
	UNION ALL
    SELECT 3001, 13 , 1 , NULL, '2024-10-01 07:30:00'
	UNION ALL
	SELECT 3001, 12, 2, '2024-10-01 07:50:00', '2024-10-01 07:55:00'
	UNION ALL
	SELECT 3001, 11, 3, '2024-10-01 08:10:00', '2024-10-01 08:15:00'
	UNION ALL
	SELECT 3001, 10, 4, '2024-10-01 08:30:00', '2024-10-01 08:35:00'
	UNION ALL
	SELECT 3001, 9, 5, '2024-10-01 08:50:00', '2024-10-01 08:55:00'
	UNION ALL
	SELECT 3001, 8, 6, '2024-10-01 09:10:00', NULL

	UNION ALL
	SELECT 3002, 8, 1, NULL, '2024-10-01 10:00:00'
	UNION ALL
	SELECT 3002, 9, 2, '2024-10-01 10:20:00', '2024-10-01 10:25:00'
	UNION ALL
	SELECT 3002, 10, 3, '2024-10-01 10:40:00', '2024-10-01 10:45:00'
	UNION ALL
	SELECT 3002, 11, 4, '2024-10-01 11:00:00', '2024-10-01 11:05:00'
	UNION ALL
	SELECT 3002, 12, 5, '2024-10-01 11:20:00', '2024-10-01 11:25:00'
	UNION ALL
	SELECT 3002, 13, 6, '2024-10-01 11:40:00', NULL
	UNION ALL
	SELECT 3003, 13, 1, NULL, '2024-10-01 12:00:00'
	UNION ALL
	SELECT 3003, 12, 2, '2024-10-01 12:20:00', '2024-10-01 12:25:00'
	UNION ALL
	SELECT 3003, 11, 3, '2024-10-01 12:40:00', '2024-10-01 12:45:00'
	UNION ALL
	SELECT 3003, 10, 4, '2024-10-01 13:00:00', '2024-10-01 13:05:00'
	UNION ALL
	SELECT 3003, 9, 5, '2024-10-01 13:20:00', '2024-10-01 13:25:00'
	UNION ALL
	SELECT 3003, 8, 6, '2024-10-01 13:40:00', NULL
    
	UNION ALL
	SELECT 3004, 8, 1, NULL, '2024-10-01 15:00:00'
	UNION ALL
	SELECT 3004, 9, 2, '2024-10-01 15:20:00', '2024-10-01 15:25:00'
	UNION ALL
	SELECT 3004, 10, 3, '2024-10-01 15:40:00', '2024-10-01 15:45:00'
	UNION ALL
	SELECT 3004, 11, 4, '2024-10-01 16:00:00', '2024-10-01 16:05:00'
	UNION ALL
	SELECT 3004, 12, 5, '2024-10-01 17:20:00', '2024-10-01 17:25:00'
	UNION ALL
	SELECT 3004, 12, 6, '2024-10-01 17:40:00', NULL
    
	UNION ALL
	SELECT 3005, 13, 1, NULL, '2024-10-01 18:20:00'
	UNION ALL
	SELECT 3005, 12, 2, '2024-10-01 18:40:00', '2024-10-01 19:45:00'
	UNION ALL
	SELECT 3005, 11, 3, '2024-10-01 19:00:00', '2024-10-01 19:05:00'
	UNION ALL
	SELECT 3005, 10, 4, '2024-10-01 19:20:00', '2024-10-01 14:25:00'
	UNION ALL
	SELECT 3005, 9, 5, '2024-10-01 19:40:00', '2024-10-01 19:45:00'
	UNION ALL
	SELECT 3005, 8, 6, '2024-10-01 20:00:00', NULL
    
    UNION ALL
	SELECT 4000, 1, 1, NULL, '2024-10-01 7:00:00'
	UNION ALL
	SELECT 4000, 2, 2, '2024-10-01 7:20:00', '2024-10-01 7:25:00'
	UNION ALL
	SELECT 4000, 3, 3, '2024-10-01 7:40:00', NULL
    
	UNION ALL
	SELECT 4001, 3, 1, NULL, '2024-10-01 7:50:00'
	UNION ALL
	SELECT 4001, 2, 1, '2024-10-01 8:10:00', '2024-10-01 8:15:00'
	UNION ALL
	SELECT 4001, 1, 3, '2024-10-01 8:30:00', NULL
    
    UNION ALL
	SELECT 4002, 3, 1, NULL, '2024-10-01 9:00:00'
	UNION ALL
	SELECT 4002, 2, 1, '2024-10-01 9:20:00', '2024-10-01 9:25:00'
	UNION ALL
	SELECT 4002, 1, 3, '2024-10-01 9:40:00', NULL
    
	UNION ALL
	SELECT 4003, 1, 1, NULL, '2024-10-01 10:00:00'
	UNION ALL
	SELECT 4003, 2, 1, '2024-10-01 10:20:00', '2024-10-01 10:25:00'
	UNION ALL
	SELECT 4003, 3, 3, '2024-10-01 10:40:00', NULL
    
) base_schedule
-- Generate valid days for October, November, and December (day offsets for the full date range)
CROSS JOIN (
    WITH RECURSIVE day_offsets AS (
        SELECT 0 AS day_offset
        UNION ALL
        SELECT day_offset + 1
        FROM day_offsets
        WHERE day_offset + 1 <= 61 -- 61 days for Oct, Nov
    )
    SELECT DATE_ADD('2024-10-01', INTERVAL day_offset DAY) AS schedule_date, day_offset
    FROM day_offsets
    WHERE DATE_ADD('2024-10-01', INTERVAL day_offset DAY) <= '2024-11-30'
) dates;


INSERT INTO reservations (reservationID, customerID, dateMade, totalFare) VALUES 
-- customer 1
(1,1,'2024-10-01',340.00),
(2,1,'2024-10-06',163.20),
(3,1,'2024-10-14',86.00),
(4,1,'2024-10-25',85.00),
(5,1,'2024-11-04',221.64),
(6,1,'2024-11-08',80.00),
(7,1,'2024-11-10',107.50),
(8,1,'2024-11-16',126.00),
(9,1,'2024-11-17',183.32),

-- customer 2
(10,2,'2024-10-01',340.00),
(11,2,'2024-10-14',86.00),
(12,2,'2024-10-25',85.00),
(13,2,'2024-11-04',221.64),
(14,2,'2024-11-10',107.50),
(15,2,'2024-11-16',126.00),
(16,2,'2024-11-17',183.32),
-- customer 3
(17,3,'2024-10-01',340.00),
(18,3,'2024-10-14',86.00),
(19,3,'2024-11-04',221.64),
(20,3,'2024-11-10',107.50),
(21,3,'2024-11-16',126.00),
(22,3,'2024-11-17',183.32),

-- customer 4
(23,4,'2024-10-01',340.00),
(24,4,'2024-10-14',86.00),
(25,4,'2024-11-04',221.64),
(26,4,'2024-11-17',183.32),

-- addititional reservation for transitID 4, 5
(27,1,'2024-10-20',140.00),
(28,2,'2024-10-20',140.00),
(29,3,'2024-10-20',140.00),
(30,4,'2024-10-20',140.00),

(31,1,'2024-11-20',66.68),
(32,2,'2024-11-20',66.68),
(33,3,'2024-11-20',66.68),
(34,4,'2024-11-20',66.68);


INSERT INTO tickets (ticketID, reservationID, scheduleID, dateMade, originID, destinationID, ticketType, tripType, fare, linkedTicketID) VALUES 
(1,1,100000,'2024-10-01',1,7,'adult','roundTrip',50.00,NULL),
(2,1,100100,'2024-10-01',7,1,'adult','roundTrip',50.00,1),
(3,1,100000,'2024-10-01',1,7,'adult','roundTrip',50.00,NULL),
(4,1,100100,'2024-10-01',7,1,'adult','roundTrip',50.00,3),
(5,1,100000,'2024-10-01',1,7,'child','roundTrip',37.50,NULL),
(6,1,100100,'2024-10-01',7,1,'child','roundTrip',37.50,5),
(7,1,100000,'2024-10-01',1,7,'senior','roundTrip',32.50,NULL),
(8,1,100100,'2024-10-01',7,1,'senior','roundTrip',32.50,7),
(9,2,300005,'2024-10-06',8,11,'adult','roundTrip',24.00,NULL),
(10,2,300105,'2024-10-06',11,8,'adult','roundTrip',24.00,9),
(11,2,300005,'2024-10-06',8,11,'adult','roundTrip',24.00,NULL),
(12,2,300105,'2024-10-06',11,8,'adult','roundTrip',24.00,11),
(13,2,300005,'2024-10-06',8,11,'child','roundTrip',18.00,NULL),
(14,2,300105,'2024-10-06',11,8,'child','roundTrip',18.00,13),
(15,2,300005,'2024-10-06',8,11,'senior','roundTrip',15.60,NULL),
(16,2,300105,'2024-10-06',11,8,'senior','roundTrip',15.60,15),
(17,3,300013,'2024-10-14',8,13,'adult','oneWay',40.00,NULL),
(18,3,300013,'2024-10-14',8,13,'senior','oneWay',26.00,NULL),
(19,3,300013,'2024-10-14',8,13,'disabled','oneWay',20.00,NULL),
(20,4,200024,'2024-10-25',2,6,'adult','roundTrip',10.00,NULL),
(21,4,200126,'2024-10-25',6,2,'adult','roundTrip',10.00,20),
(22,4,200024,'2024-10-25',2,6,'adult','roundTrip',10.00,NULL),
(23,4,200126,'2024-10-25',6,2,'adult','roundTrip',10.00,22),
(24,4,200024,'2024-10-25',2,6,'child','roundTrip',7.50,NULL),
(25,4,200126,'2024-10-25',6,2,'child','roundTrip',7.50,24),
(26,4,200024,'2024-10-25',2,6,'child','roundTrip',7.50,NULL),
(27,4,200126,'2024-10-25',6,2,'child','roundTrip',7.50,26),
(28,4,200024,'2024-10-25',2,6,'child','roundTrip',7.50,NULL),
(29,4,200126,'2024-10-25',6,2,'child','roundTrip',7.50,28),
(30,5,100034,'2024-11-04',1,5,'adult','roundTrip',33.33,NULL),
(31,5,100134,'2024-11-04',5,1,'adult','roundTrip',33.33,30),
(32,5,100034,'2024-11-04',1,5,'adult','roundTrip',33.33,NULL),
(33,5,100134,'2024-11-04',5,1,'adult','roundTrip',33.33,32),
(34,5,100034,'2024-11-04',1,5,'child','roundTrip',25.00,NULL),
(35,5,100134,'2024-11-04',5,1,'child','roundTrip',25.00,34),
(36,5,100034,'2024-11-04',1,5,'senior','oneWay',21.66,NULL),
(37,5,100034,'2024-11-04',1,5,'disabled','oneWay',16.67,NULL),
(38,6,300238,'2024-11-08',8,9,'adult','roundTrip',8.00,NULL),
(39,6,300538,'2024-11-08',9,8,'adult','roundTrip',8.00,38),
(40,6,300238,'2024-11-08',8,9,'adult','roundTrip',8.00,NULL),
(41,6,300538,'2024-11-08',9,8,'adult','roundTrip',8.00,40),
(42,6,300238,'2024-11-08',8,9,'child','roundTrip',6.00,NULL),
(43,6,300538,'2024-11-08',9,8,'child','roundTrip',6.00,42),
(44,6,300238,'2024-11-08',8,9,'child','roundTrip',6.00,NULL),
(45,6,300538,'2024-11-08',9,8,'child','roundTrip',6.00,44),
(46,6,300238,'2024-11-08',8,9,'child','roundTrip',6.00,NULL),
(47,6,300538,'2024-11-08',9,8,'child','roundTrip',6.00,46),
(48,6,300238,'2024-11-08',8,9,'child','roundTrip',6.00,NULL),
(49,6,300538,'2024-11-08',9,8,'child','roundTrip',6.00,48),
(50,7,100140,'2024-11-10',7,1,'adult','oneWay',50.00,NULL),
(51,7,100140,'2024-11-10',7,1,'senior','oneWay',32.50,NULL),
(52,7,100140,'2024-11-10',7,1,'disabled','oneWay',25.00,NULL),
(53,8,300346,'2024-11-16',13,8,'adult','oneWay',40.00,NULL),
(54,8,300346,'2024-11-16',13,8,'adult','oneWay',40.00,NULL),
(55,8,300346,'2024-11-16',13,8,'senior','oneWay',26.00,NULL),
(56,8,300346,'2024-11-16',13,8,'disabled','oneWay',20.00,NULL),
(57,9,100047,'2024-11-17',1,5,'adult','roundTrip',33.33,NULL),
(58,9,100147,'2024-11-17',5,1,'adult','roundTrip',33.33,57),
(59,9,100047,'2024-11-17',1,5,'adult','roundTrip',33.33,NULL),
(60,9,100147,'2024-11-17',5,1,'adult','roundTrip',33.33,59),
(61,9,100047,'2024-11-17',1,5,'child','roundTrip',25.00,NULL),
(62,9,100147,'2024-11-17',5,1,'child','roundTrip',25.00,61),
(63,10,100000,'2024-10-01',1,7,'adult','roundTrip',50.00,NULL),
(64,10,100100,'2024-10-01',7,1,'adult','roundTrip',50.00,63),
(65,10,100000,'2024-10-01',1,7,'adult','roundTrip',50.00,NULL),
(66,10,100100,'2024-10-01',7,1,'adult','roundTrip',50.00,65),
(67,10,100000,'2024-10-01',1,7,'child','roundTrip',37.50,NULL),
(68,10,100100,'2024-10-01',7,1,'child','roundTrip',37.50,67),
(69,10,100000,'2024-10-01',1,7,'senior','roundTrip',32.50,NULL),
(70,10,100100,'2024-10-01',7,1,'senior','roundTrip',32.50,69),
(71,11,300013,'2024-10-14',8,13,'adult','oneWay',40.00,NULL),
(72,11,300013,'2024-10-14',8,13,'senior','oneWay',26.00,NULL),
(73,11,300013,'2024-10-14',8,13,'disabled','oneWay',20.00,NULL),
(74,12,200024,'2024-10-25',2,6,'adult','roundTrip',10.00,NULL),
(75,12,200126,'2024-10-25',6,2,'adult','roundTrip',10.00,74),
(76,12,200024,'2024-10-25',2,6,'adult','roundTrip',10.00,NULL),
(77,12,200126,'2024-10-25',6,2,'adult','roundTrip',10.00,76),
(78,12,200024,'2024-10-25',2,6,'child','roundTrip',7.50,NULL),
(79,12,200126,'2024-10-25',6,2,'child','roundTrip',7.50,78),
(80,12,200024,'2024-10-25',2,6,'child','roundTrip',7.50,NULL),
(81,12,200126,'2024-10-25',6,2,'child','roundTrip',7.50,80),
(82,12,200024,'2024-10-25',2,6,'child','roundTrip',7.50,NULL),
(83,12,200126,'2024-10-25',6,2,'child','roundTrip',7.50,82),
(84,13,100034,'2024-11-04',1,5,'adult','roundTrip',33.33,NULL),
(85,13,100134,'2024-11-04',5,1,'adult','roundTrip',33.33,84),
(86,13,100034,'2024-11-04',1,5,'adult','roundTrip',33.33,NULL),
(87,13,100134,'2024-11-04',5,1,'adult','roundTrip',33.33,86),
(88,13,100034,'2024-11-04',1,5,'child','roundTrip',25.00,NULL),
(89,13,100134,'2024-11-04',5,1,'child','roundTrip',25.00,88),
(90,13,100034,'2024-11-04',1,5,'senior','oneWay',21.66,NULL),
(91,13,100034,'2024-11-04',1,5,'disabled','oneWay',16.67,NULL),
(92,14,100140,'2024-11-10',7,1,'adult','oneWay',50.00,NULL),
(93,14,100140,'2024-11-10',7,1,'senior','oneWay',32.50,NULL),
(94,14,100140,'2024-11-10',7,1,'disabled','oneWay',25.00,NULL),
(95,15,300346,'2024-11-16',13,8,'adult','oneWay',40.00,NULL),
(96,15,300346,'2024-11-16',13,8,'adult','oneWay',40.00,NULL),
(97,15,300346,'2024-11-16',13,8,'senior','oneWay',26.00,NULL),
(98,15,300346,'2024-11-16',13,8,'disabled','oneWay',20.00,NULL),
(99,16,100047,'2024-11-17',1,5,'adult','roundTrip',33.33,NULL),
(100,16,100147,'2024-11-17',5,1,'adult','roundTrip',33.33,99),
(101,16,100047,'2024-11-17',1,5,'adult','roundTrip',33.33,NULL),
(102,16,100147,'2024-11-17',5,1,'adult','roundTrip',33.33,101),
(103,16,100047,'2024-11-17',1,5,'child','roundTrip',25.00,NULL),
(104,16,100147,'2024-11-17',5,1,'child','roundTrip',25.00,103),
(105,17,100000,'2024-10-01',1,7,'adult','roundTrip',50.00,NULL),
(106,17,100100,'2024-10-01',7,1,'adult','roundTrip',50.00,105),
(107,17,100000,'2024-10-01',1,7,'adult','roundTrip',50.00,NULL),
(108,17,100100,'2024-10-01',7,1,'adult','roundTrip',50.00,107),
(109,17,100000,'2024-10-01',1,7,'child','roundTrip',37.50,NULL),
(110,17,100100,'2024-10-01',7,1,'child','roundTrip',37.50,109),
(111,17,100000,'2024-10-01',1,7,'senior','roundTrip',32.50,NULL),
(112,17,100100,'2024-10-01',7,1,'senior','roundTrip',32.50,111),
(113,18,300013,'2024-10-14',8,13,'adult','oneWay',40.00,NULL),
(114,18,300013,'2024-10-14',8,13,'senior','oneWay',26.00,NULL),
(115,18,300013,'2024-10-14',8,13,'disabled','oneWay',20.00,NULL),
(116,19,100034,'2024-11-04',1,5,'adult','roundTrip',33.33,NULL),
(117,19,100134,'2024-11-04',5,1,'adult','roundTrip',33.33,116),
(118,19,100034,'2024-11-04',1,5,'adult','roundTrip',33.33,NULL),
(119,19,100134,'2024-11-04',5,1,'adult','roundTrip',33.33,118),
(120,19,100034,'2024-11-04',1,5,'child','roundTrip',25.00,NULL),
(121,19,100134,'2024-11-04',5,1,'child','roundTrip',25.00,120),
(122,19,100034,'2024-11-04',1,5,'senior','oneWay',21.66,NULL),
(123,19,100034,'2024-11-04',1,5,'disabled','oneWay',16.67,NULL),
(124,20,100140,'2024-11-10',7,1,'adult','oneWay',50.00,NULL),
(125,20,100140,'2024-11-10',7,1,'senior','oneWay',32.50,NULL),
(126,20,100140,'2024-11-10',7,1,'disabled','oneWay',25.00,NULL),
(127,21,300346,'2024-11-16',13,8,'adult','oneWay',40.00,NULL),
(128,21,300346,'2024-11-16',13,8,'adult','oneWay',40.00,NULL),
(129,21,300346,'2024-11-16',13,8,'senior','oneWay',26.00,NULL),
(130,21,300346,'2024-11-16',13,8,'disabled','oneWay',20.00,NULL),
(131,22,100047,'2024-11-17',1,5,'adult','roundTrip',33.33,NULL),
(132,22,100147,'2024-11-17',5,1,'adult','roundTrip',33.33,131),
(133,22,100047,'2024-11-17',1,5,'adult','roundTrip',33.33,NULL),
(134,22,100147,'2024-11-17',5,1,'adult','roundTrip',33.33,133),
(135,22,100047,'2024-11-17',1,5,'child','roundTrip',25.00,NULL),
(136,22,100147,'2024-11-17',5,1,'child','roundTrip',25.00,135),
(137,23,100000,'2024-10-01',1,7,'adult','roundTrip',50.00,NULL),
(138,23,100100,'2024-10-01',7,1,'adult','roundTrip',50.00,137),
(139,17,100000,'2024-10-01',1,7,'adult','roundTrip',50.00,NULL),
(140,23,100100,'2024-10-01',7,1,'adult','roundTrip',50.00,139),
(141,23,100000,'2024-10-01',1,7,'child','roundTrip',37.50,NULL),
(142,23,100100,'2024-10-01',7,1,'child','roundTrip',37.50,141),
(143,23,100000,'2024-10-01',1,7,'senior','roundTrip',32.50,NULL),
(144,23,100100,'2024-10-01',7,1,'senior','roundTrip',32.50,143),
(145,24,300013,'2024-10-14',8,13,'adult','oneWay',40.00,NULL),
(146,24,300013,'2024-10-14',8,13,'senior','oneWay',26.00,NULL),
(147,24,300013,'2024-10-14',8,13,'disabled','oneWay',20.00,NULL),
(148,25,100034,'2024-11-04',1,5,'adult','roundTrip',33.33,NULL),
(149,25,100134,'2024-11-04',5,1,'adult','roundTrip',33.33,148),
(150,25,100034,'2024-11-04',1,5,'adult','roundTrip',33.33,NULL),
(151,25,100134,'2024-11-04',5,1,'adult','roundTrip',33.33,150),
(152,25,100034,'2024-11-04',1,5,'child','roundTrip',25.00,NULL),
(153,25,100134,'2024-11-04',5,1,'child','roundTrip',25.00,152),
(154,26,100047,'2024-11-17',1,5,'adult','roundTrip',33.33,NULL),
(155,26,100147,'2024-11-17',5,1,'adult','roundTrip',33.33,154),
(156,26,100047,'2024-11-17',1,5,'child','roundTrip',25.00,NULL),
(157,26,100147,'2024-11-17',5,1,'child','roundTrip',25.00,156),
(158,27,400019,'2024-10-20',1,3,'adult','roundTrip',35.00,NULL),
(159,27,400119,'2024-10-20',3,1,'adult','roundTrip',35.00,158),
(160,27,400019,'2024-10-20',1,3,'adult','roundTrip',35.00,NULL),
(161,27,400119,'2024-10-20',3,1,'adult','roundTrip',35.00,160),
(162,28,400019,'2024-10-20',1,3,'adult','roundTrip',35.00,NULL),
(163,28,400119,'2024-10-20',3,1,'adult','roundTrip',35.00,162),
(164,28,400019,'2024-10-20',1,3,'adult','roundTrip',35.00,NULL),
(165,28,400119,'2024-10-20',3,1,'adult','roundTrip',35.00,164),
(166,29,400019,'2024-10-20',1,3,'adult','roundTrip',35.00,NULL),
(167,29,400119,'2024-10-20',3,1,'adult','roundTrip',35.00,166),
(168,29,400019,'2024-10-20',1,3,'adult','roundTrip',35.00,NULL),
(169,29,400119,'2024-10-20',3,1,'adult','roundTrip',35.00,168),
(170,30,400019,'2024-10-20',1,3,'adult','roundTrip',35.00,NULL),
(171,30,400119,'2024-10-20',3,1,'adult','roundTrip',35.00,170),
(172,30,400019,'2024-10-20',1,3,'adult','roundTrip',35.00,NULL),
(173,30,400119,'2024-10-20',3,1,'adult','roundTrip',35.00,172),
(174,31,500050,'2024-11-20',7,9,'adult','roundTrip',16.67,NULL),
(175,31,500150,'2024-11-20',9,7,'adult','roundTrip',16.67,174),
(176,31,500050,'2024-11-20',7,9,'adult','roundTrip',16.67,NULL),
(177,31,500150,'2024-11-20',9,7,'adult','roundTrip',16.67,176),
(178,32,500050,'2024-11-20',7,9,'adult','roundTrip',16.67,NULL),
(179,32,500150,'2024-11-20',9,7,'adult','roundTrip',16.67,178),
(180,32,500050,'2024-11-20',7,9,'adult','roundTrip',16.67,NULL),
(181,32,500150,'2024-11-20',9,7,'adult','roundTrip',16.67,180),
(182,33,500050,'2024-11-20',7,9,'adult','roundTrip',16.67,NULL),
(183,33,500150,'2024-11-20',9,7,'adult','roundTrip',16.67,182),
(184,33,500050,'2024-11-20',7,9,'adult','roundTrip',16.67,NULL),
(185,33,500150,'2024-11-20',9,7,'adult','roundTrip',16.67,184),
(186,34,500050,'2024-11-20',7,9,'adult','roundTrip',16.67,NULL),
(187,34,500150,'2024-11-20',9,7,'adult','roundTrip',16.67,186),
(188,34,500050,'2024-11-20',7,9,'adult','roundTrip',16.67,NULL),
(189,34,500150,'2024-11-20',9,7,'adult','roundTrip',16.67,188);

