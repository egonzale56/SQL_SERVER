-- This copy creates a fresh copy of the Landon Hotel Rooms Table
USE LandonHotel;

DROP TABLE IF EXISTS Rooms;

CREATE TABLE Rooms ( 
	RoomId INT IDENTITY(1,1) NOT NULL,
	RoomNumber CHAR(3) NOT NULL,
	BedType VARCHAR(15) NOT NULL,
	Rate SMALLMONEY NOT NULL
);


INSERT INTO Rooms (RoomNumber,BedType,Rate)
	VALUES ('101', 'King', 110),
		   ('102', 'Queen', 10),
		   ('103', 'Two Doubles', 90),
		   ('201', 'King', 120),
		   ('202', 'King', 120),
		   ('203', 'Two Doubles', 90)
;

SELECT RoomId,  
	   BedType,
	   Rate
FROM dbo.Rooms
WHERE BedType = 'King'
;

UPDATE dbo.Rooms
SET Rate = 120
WHERE RoomID = 1;

UPDATE dbo.Rooms
SET Rate = 100
WHERE RoomID = 2;

SELECT *
FROM dbo.Rooms;

SELECT * FROM dbo.Guests;
SELECT * FROM dbo.RoomReservations;
SELECT * FROM dbo.Rooms;


SELECT g.FirstName,
	   g.LastName,
	   r.RoomNumber
FROM dbo.Guests g
	JOIN
dbo.RoomReservations r ON G.GuestID = R.GuestID;

-- This will remove all of the data from the table
TRUNCATE TABLE Rooms;

-- This will eliminate the table
DROP TABLE Rooms;



