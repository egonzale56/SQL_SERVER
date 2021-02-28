USE TimeSeries;
GO
---------------------------------------------------------
DECLARE
	@SomeTime DATETIME2(7) = SYSUTCDATETIME();
-- Retrive year, month, and date from the computer system
SELECT
	YEAR(@SomeTime) AS TheYear,
	MONTH(@SomeTime) AS TheMonth,
	Day(@SomeTime) AS TheDay
;
GO
---------------------------------------------------------

-- Using Datepart() and Datename()
DECLARE @BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294856';
SELECT
	DATEPART(YEAR, @BerlinWallFalls) AS TheYear,
	DATEPART(MONTH, @BerlinWallFalls) AS TheMonth,
	DATEPART(DAY, @BerlinWallFalls) AS TheDay,
	DATEPART(DAYOFYEAR, @BerlinWallFalls) AS ThedayOfYear,
	DATEPART(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATEPART(WEEK, @BerlinWallFalls) AS TheWeek,
	DATEPART(SECOND, @BerlinWallFalls) AS TheSecond,
	DATEPART(NANOSECOND, @BerlinWallFalls) AS TheNanoSecond
;
GO

DECLARE @BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294856';
SELECT
	DATENAME(YEAR, @BerlinWallFalls) AS TheYear,
	DATENAME(MONTH, @BerlinWallFalls) AS TheMonth,
	DATENAME(DAY, @BerlinWallFalls) AS TheDay,
	DATENAME(DAYOFYEAR, @BerlinWallFalls) AS ThedayOfYear,
	DATENAME(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATENAME(WEEK, @BerlinWallFalls) AS TheWeek,
	DATENAME(SECOND, @BerlinWallFalls) AS TheSecond,
	DATENAME(NANOSECOND, @BerlinWallFalls) AS TheNanoSecond
;
GO
---------------------------------------------------------

-- Using DATEADD() and DATEDIFF() for handling Leap Years
DECLARE 
	@LeapDay DATETIME2(7) = '2012-02-29 18:00:09';

SELECT 
	DATEADD(DAY, -1, @LeapDay) AS PriorDay,
	DATEADD(DAY, 1, @LeapDay) AS NextDay,
	DATEADD(YEAR, -4, @LeapDay) AS PriorLeapYear,
	DATEADD(YEAR, 4, @LeapDay) AS NextLeapYear,
	DATEADD(YEAR, -1, @LeapDay) AS PriorYear
;
GO

DECLARE 
	@PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00',
	@TwoDaysAgo DATETIME2(7)
;

SELECT
	@TwoDaysAgo = DATEADD(DAY, -2, @PostLeapDay);

SELECT
	@TwoDaysAgo AS TwoDaysAgo,
	@PostLeapDay AS SomeTime,
	DATEDIFF(DAY, @TwoDaysAgo, @PostLeapDay) AS DaysDifference,
	DATEDIFF(HOUR, @TwoDaysAgo, @PostLeapDay) AS HoursDifference,
	DATEDIFF(MINUTE, @TwoDaysAgo, @PostLeapDay) AS MinutesDifference
;
GO
---------------------------------------------------------

-- Round values with DATEADD() and DATEDIFF()
DECLARE @SomeTime DATETIME2(7) = '2018-06-14 16:29:36.2248941';

SELECT
	DATEADD(DAY, DATEDIFF(DAY, 0, @SomeTime), 0) AS RoundedDay,
	DATEADD(HOUR, DATEDIFF(HOUR, 0, @SomeTime), 0) AS RoundedHour,
	DATEADD(MINUTE, DATEDIFF(MINUTE, 0, @SomeTime), 0) AS RoundedMinute
;
GO
---------------------------------------------------------

-- Using CAST(), CONVERT(), and FORMAT()
-- CAST
DECLARE
	@SomeDate DATETIME2(3) = '1991-06-04 08:00:09',
	@SomeString NVARCHAR(30) = '1991-06-04 08:00:09',
	@OldDateTime DATETIME = '1991-06-04 08:00:09'
;

SELECT 
	CAST(@SomeDate AS NVARCHAR(30)) AS DateToString,
	CAST(@SomeString AS DATETIME2(3)) AS StringToDate,
	CAST(@OldDateTime AS NVARCHAR(30)) AS OldDateToString
;
GO
-- CONVERT
DECLARE
	@SomeDate DATETIME2(3) = '1991-06-04 08:00:09'
;

SELECT
	CONVERT(NVARCHAR(30), @SomeDate, 0) AS DefaultForm,
	CONVERT(NVARCHAR(30), @SomeDate, 1) AS US_mdy,
	CONVERT(NVARCHAR(30), @SomeDate, 101) AS US_mdyyyy,
	CONVERT(NVARCHAR(30), @SomeDate, 120) AS ODBC_sec
;
GO

-- FORMAT
DECLARE
	@SomeDate DATETIME2(3) = '1991-06-04 08:00:09'
;

SELECT
	FORMAT(@SomeDate, 'd', 'en_US') AS US_d,
	FORMAT(@SomeDate, 'd', 'de_DE') AS DE_d,
	FORMAT(@SomeDate, 'D', 'de_DE') AS DE_D,
	FORMAT(@SomeDate, 'yyyy-MM-dd') AS yMd
;
GO

---------------------------------------------------------
SELECT TOP(2)* 
FROM calendar;
GO

-- DATEFROMPARTS() Obtain the date from different parts using different columns
SELECT TOP(10)
	   c.CalendarQuarterName,
	   c.MonthName,
	   c.CalendarDayofYear
FROM
	dbo.calendar c
WHERE
	DATEFROMPARTS (
		c.CalendarYear,
		c.CalendarMonth,
		c.Day ) <= '2000-06-01'
			AND
		c.DayName = 'Tuesday'
ORDER BY
	c.FiscalYear,
	c.FiscalDayOfYear 
;
GO

-- DATETIME2FROMPARTS() Datetime2 has 7 positions of especificity
SELECT
/* Mark date and time the lunar module touched down
use 24 hr notation for hours*/
DATETIME2FROMPARTS(
	1969, 07, 20, 20, 17, 00, 000, 0) AS TheEagleHasLanded,
/* Mark date and time the lunar module took back off
use 24 hr notation for hours*/
DATETIME2FROMPARTS(
	1969, 07, 21, 21, 18, 54, 000, 0) AS MoonDeparture
;
GO

-- Using CAST to convert STRING to DATETIME
SELECT
	d.DateText AS String,
	CAST(d.DateText AS DATE) AS StringToDate,
	CAST(d.DateText AS datetime2(7)) AS StringToDatetime2
FROM
	dbo.Dates d
;
GO

-- Using CONVERT to convert STRING to DATETIME
SET LANGUAGE 'German'

SELECT 
	d.Datetext AS String,
	CONVERT(DATE, d.DateText) AS StringAsDate,
	CONVERT(datetime2(7), d.DateText) AS StringToDatetime2
FROM
	dbo.Dates d
;
GO

-- Using PARSE to convert STRING to DATETIME
SET LANGUAGE 'German'

SELECT 
	d.Datetext AS String,
	PARSE(d.DateText AS DATE USING 'de-de') AS StringAsDateGerman,
	PARSE(d.DateText AS datetime2(7) USING 'de-de') AS StringToDatetime2German
FROM
	dbo.Dates d
;
GO

-- SWITCHOFFSET() allows to switch from different timezones
/* The N denotes that the string is UNICODE meaning you are
using NCHAR, NVARCHAR, NTEXT. In this case it represents a 
National Language Character set*/
DECLARE @OlympicsUTC NVARCHAR(50) = N'2016-08-08 23:00:00';

SELECT 
	SWITCHOFFSET(@OlympicsUTC, '-03:00') AS BrasiliaTime,
	SWITCHOFFSET(@OlympicsUTC, '+05:30') AS NewDelhiTime
;
GO

-- Handling invalid Dates with TRY_CONVERT(), TRY_CAST() and TRY_PARSE()
-- If the Date is not valid it simply return NULL instead of Error
-- As a side note, Both TRY_CONVERT() and TRY_CAST() are faster thanTRY_PARSE()
DECLARE @GoodDateINT NVARCHAR(30) = '2019-03-01 18:27:29';

SELECT
	TRY_CAST(@GoodDateINT AS DATETIME2(7)) AS GoodDateINTCast,
	TRY_CONVERT(DATETIME2(3), @GoodDateINT) AS GoodDateINTConvert,
	TRY_PARSE(@GoodDateINT AS DATETIME2(3)) AS GoodDateINTParse;
GO

-- Basic aggregate functions
SELECT 
	COUNT(DISTINCT c.CalendarYear) AS years,
	COUNT(DISTINCT NULLIF(c.CalendarYear, 2000)) AS y2k
FROM dbo.calendar c
;
GO

-- Filtering aggregates with CASE
SELECT
	MAX(
		CASE WHEN ir.IncidentTypeId = 1
			 THEN ir.IncidentDate
			 ELSE NULL
		END) AS I1,
	MAX(
		CASE WHEN ir.IncidentTypeId = 2
			 THEN ir.IncidentDate
			 ELSE NULL
		END) AS I2
FROM
	dbo.incident_rollup ir
;
GO

-- Finding the Median with Percentile_Cont
SELECT
	DISTINCT(it.IncidentType),
	AVG(CAST(ir.NumofIncidents AS DECIMAL(4,2)))
		OVER(PARTITION BY it.IncidentType) AS MeanNumberOfIncidents,
	PERCENTILE_CONT(0.5)
		WITHIN GROUP (ORDER BY ir.NumofIncidents DESC)
		OVER(PARTITION BY it.IncidentType) AS Median,
		COUNT(1) OVER (Partition by it.incidentType) AS NumberOfRows
FROM dbo.incident_rollup;
GO
			
-- Downsampling
SELECT 
-- Downsampling to a weekly grain
	DATEPART(WEEK, dsv.CustomerVisitStart) AS weekly,
	SUM(dsv.AmenityUseInMinutes) AS AmenityUse,
	MAX(dsv.CustomerID) AS HighestCustomerID,
	-- This next line counts 1 by 1 the total number
	COUNT(1) AS NumberAttendes
FROM dbo.day_spa_visit dsv
WHERE
	dsv.CustomerVisitStart >= '2020-01-01'
		AND
	dsv.CustomerVisitStart < '2021-01-01'
GROUP BY
	DATEPART(
		WEEK, dsv.CustomerVisitStart)
ORDER BY
	weekly;
GO

-- Using Rollup
SELECT
	DATEPART(MONTH, dsv.CustomerVisitStart) AS Monthly,
	DATEPART(DAY, dsv.CustomerVisitStart) AS Daily,
	SUM(dsv.AmenityUseInMinutes) AS AmenityUse
FROM 
	dbo.day_spa_visit dsv
GROUP BY 
	DATEPART(MONTH, dsv.CustomerVisitStart),
	DATEPART(DAY, dsv.CustomerVisitStart)
WITH ROLLUP
ORDER BY
	Monthly,
	Daily
;
GO

-- Using CUBE
SELECT
	DATEPART(MONTH, dsv.CustomerVisitStart) AS Monthly,
	DATEPART(DAY, dsv.CustomerVisitStart) AS Daily,
	SUM(dsv.AmenityUseInMinutes) AS AmenityUse
FROM 
	dbo.day_spa_visit dsv
GROUP BY 
	DATEPART(MONTH, dsv.CustomerVisitStart),
	DATEPART(DAY, dsv.CustomerVisitStart)
WITH CUBE
ORDER BY
	Monthly,
	Daily
;
GO

-- Using GROUPING SETS
SELECT
	DATEPART(MONTH, dsv.CustomerVisitStart) AS Monthly,
	DATEPART(DAY, dsv.CustomerVisitStart) AS Daily,
	SUM(dsv.AmenityUseInMinutes) AS AmenityUse
FROM 
	dbo.day_spa_visit dsv
GROUP BY GROUPING SETS 
	(
		(DATEPART(MONTH, dsv.CustomerVisitStart)),
		(DATEPART(DAY, dsv.CustomerVisitStart)),
		()
	)
ORDER BY
	Monthly,
	Daily
;
GO

-- Ranking Functions --------------------------
USE Orders_USA;
GO

SELECT TOP(5) * FROM market;
GO

-- Using RANK() and DENSE_RANK()
SELECT TOP(10)
	m.gross_income,
	RANK() OVER(
		ORDER BY m.gross_income DESC
		) AS Ranking,
	DENSE_RANK() OVER(
		ORDER BY m.gross_income DESC
		) AS Dense_Ranking
FROM dbo.market m
ORDER BY 
	m.gross_income DESC
;
GO

-- Aggregation functions over windows
SELECT
	m.branch AS Branch,
	m.gross_income AS Gross_Income,
	ROW_NUMBER() OVER(
		PARTITION BY m.branch
		ORDER BY m.gross_income DESC
		) AS RowNumber,
	DATEPART(MONTH, date) AS TheMonth
FROM 
	dbo.market m
ORDER BY
	Branch,
	TheMonth
;
GO

USE TimeSeries;
GO

SELECT TOP(5) * FROM dbo.incident_rollup;
GO

SELECT
	ir.IncidentDate,
	ir.NumberOfIncidents,
	ROW_NUMBER() OVER (ORDER BY ir.NumberOfIncidents DESC) AS rownum,
	RANK() OVER (ORDER BY ir.NumberOfIncidents DESC) AS rk,
	DENSE_RANK() OVER (ORDER BY ir.NumberOfIncidents DESC) AS dr
FROM 
	dbo.incident_rollup ir
WHERE
	ir.IncidentTypeID = 3
		AND
	ir.NumberOfIncidents >= 4
ORDER BY
	ir.NumberOfIncidents DESC
;
GO

-- Running Totals
USE Orders_USA;
GO

SELECT
	m.branch,
	DATEPART(MONTH, date) as _month,
	m.gross_income,
	SUM(m.gross_income) OVER (
		PARTITION BY m.branch
		ORDER BY DATEPART(MONTH, date)
		RANGE BETWEEN 
			UNBOUNDED PRECEDING
				AND
			CURRENT ROW
		) AS TotalGrossIncome
FROM market m
;
GO

USE TimeSeries;
GO

-- Using LEAD and LAG to obtain past a future values
SELECT 
	ir.incidentDate,
	ir.IncidentTypeID,
	LAG(ir.NumberOfIncidents, 1) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.incidentDate) AS PriorDayIncidents,
	ir.numberOfIncidents AS CurrentDayIncidents,
	LEAD(ir.NumberOFIncidents, 1) OVER (
		PARTITION BY ir.incidentTypeID
		ORDER BY ir.incidentDate) AS NextDayIncidents
FROM
	dbo.incident_rollup ir
WHERE 
	ir.IncidentDate >= '2019-07-02'
		AND
	ir.IncidentDate <= '2019-07-31'
		AND
	ir.IncidentTypeID IN (1, 2)
ORDER BY
	ir.IncidentTypeID,
	ir.IncidentDate
;
GO

-- Calculatiing days elapsed between incidents
SELECT
	ir.IncidentDate,
	ir.IncidentTypeId,
	-- Fill in the days since last incident
	DATEDIFF(DAY, ir.incidentDate, LAG(ir.incidentDate, 1) OVER (
		PARTITION BY ir.incidentTypeID
		ORDER BY ir.IncidentDate
	)) AS DaysSinceLastIncident,
	-- fill in the days until next incident
	DATEDIFF(DAY, ir.incidentDate, LEAD(ir.IncidentDate, 1) OVER (
		PARTITION BY ir.IncidentTypeID
		ORDER BY ir.incidentDate
	)) AS DaysUntilNextIncident
FROM dbo.incident_rollup ir
WHERE 
	ir.IncidentDate >= '2019-07-02'
		AND
	ir.IncidentDate <= '2019-07-31'
		AND
	ir.IncidentTypeID IN (1, 2)
ORDER BY
	ir.IncidentTypeID,
	ir.IncidentDate
;
GO

-- Analyzing client data for potential fraud
-- Which customers has used some entry twice or more
SELECT 
	-- this section focuses on entrances: Customer visits
	dsv.CustomerID,
	dsv.CustomerVisitStart AS TIMEUTC,
	1 AS entryCount,
	-- we want to know each customer's entrance stream
	-- Get a unique, ascending row number
	ROW_NUMBER() OVER (
	-- Break this out by Customer_ID
		PARTITION BY dsv.CustomerID
		ORDER BY dsv.CustomerVisitStart
		) AS StartOrdinal
INTO #StartStopPoints
FROM dbo.day_spa_visit dsv
UNION ALL
-- This section focuses on departures: CustomerVisitEnd
SELECT
	dsv.CustomerID,
	dsv.CustomerVisitEnd AS TimeUTC,
	-1 AS EntryCount,
	Null AS StartOrdinal
FROM dbo.day_spa_visit dsv
;
/* So far we broken out spa data into a stream of
entrances and exists. Now let's find the maximum 
number of concurrent visits. The results from the prior 
exercise are now in a temporary table called #StartStopPoints
*/
SELECT s.*,
    -- Build a stream of all check-in and check-out events
	ROW_NUMBER() OVER (
      -- Break this out by customer ID
      PARTITION BY s.CustomerID
      -- Order by event time and then the start ordinal
      -- value (in case of exact time matches)
      ORDER BY s.TimeUTC, s.StartOrdinal
    ) AS StartOrEndOrdinal
INTO #StartStopOrder
FROM #StartStopPoints s;
/* This final part completes the query
to get the person who has more than one entrance */
SELECT
	s.CustomerID,
	MAX(2 * s.StartOrdinal - s.StartOrEndOrdinal) AS MaxConcurrentCustomerVisits
FROM #StartStopOrder s
WHERE s.EntryCount = 1
GROUP BY s.CustomerID
-- The difference between 2 * start ordinal and the start/end
-- ordinal represents the number of concurrent visits
HAVING MAX(2 * s.StartOrdinal - s.StartOrEndOrdinal) > 2
-- Sort by the largest number of max concurrent customer visits
ORDER BY MaxConcurrentCustomerVisits DESC
;
GO