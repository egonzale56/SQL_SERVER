USE Covid_USA;
GO

SELECT TOP(100) *
FROM short_usa;
GO

-- Using LEN to extract non null values
SELECT COUNT(Admin2) as Admin2Count
FROM short_usa
WHERE LEN(Admin2) > 0
;
GO

-- Substituting Null with other string
SELECT Province_State, ISNULL(Admin2, 'Missing Value') As Administration
FROM short_usa
WHERE Admin2 IS NULL
ORDER BY Province_State
;
GO

-- Replacing Null Values with other columns
SELECT 
	TOP(4)
	Admin2,
	Province_State,
	ISNULL(Admin2, Province_State) AS AdminNotNull
FROM 
	short_usa
;
GO

-- Returning the first not null value with COALESCE
SELECT 
	Admin2,
	Province_State,
	COALESCE(Admin2,Province_State, 'N/A') AS AdminNotNull
FROM 
	short_usa
;
GO

-- Binning data with CASE
SELECT 
	Admin2,
CASE WHEN
		Admin2 IS NULL THEN 'Missing Data'
	ELSE
		Admin2
	END AS Admin3
FROM short_usa;
GO

USE test;
GO

SELECT TOP(10) *
FROM orders;
GO

-- Rounding Values
SELECT OrderPrice, ROUND(OrderPrice, -1) AS RoundedToTens
FROM orders
WHERE OrderId = 40646
;
GO

SELECT OrderPrice, ROUND(OrderPrice, -2) AS RoundedToHundos
FROM orders
WHERE OrderId = 40664
;
GO

-- CASE with ROUND
SELECT 
	OrderPrice,
CASE WHEN
		OrderPrice < 100 THEN ROUND(OrderPrice, -1) 
	ELSE
		ROUND(OrderPrice, -2) 
	END AS RoundedValues
FROM orders
;
GO

-- Truncate Values works with FLOAT though
SELECT
	OrderPrice,
	ROUND(OrderPrice, 0) AS Rounded,
	ROUND(OrderPRice, 0, 1) AS Truncated
FROM orders
;
GO

USE accidents;
GO

SELECT TOP 3 * FROM casualties;

SELECT TOP 3 * FROM bikers;
GO

-- Derived Tables
SELECT a.* 
FROM casualties a
JOIN (SELECT AVG(Number_of_Vehicles) AS avgVehicles FROM casualties) b
ON a.Number_of_Vehicles = b.avgVehicles
;
GO

USE Covid_USA;
GO

SELECT TOP(10) *
FROM heart;
GO

-- CTE query

-- Create the CTE to get maximum cholesterol by age
WITH CholesterolAge (age, MaxCholesterol)
AS (
	SELECT 
		age, 
		MAX(chol) AS MaxCholesterol
	FROM 
		heart
	GROUP BY 
		age
	)
-- Create query to use the CTE as a table
SELECT 
	a.age, 
	MIN(a.chol) AS MinCholesterol, 
	b.MaxCholesterol
FROM 
	heart a
-- Join the CTE with the Table
JOIN CholesterolAge b
	ON a.age = b.age
GROUP BY 
	a.age, b.MaxCholesterol
;
GO

USE Orders_USA;
GO
-- Windows Functions

SELECT TOP 3 * 
FROM market;
GO

SELECT DISTINCT(payment)
FROM market;
GO

SELECT
	DISTINCT(branch),
	YEAR(date) as year_val,
	SUM(gross_income) 
		OVER(PARTITION BY branch) AS YearlyTotal
FROM market
GROUP BY 
	date, 
	branch, 
	gross_income
ORDER BY 
	branch
;
GO

-- Calculating STD-DEV
SELECT
	DISTINCT(branch),
	YEAR(date) as year_val,
	STDEV(gross_income)
		OVER(PARTITION BY branch) AS YearlyStDev
FROM market
GROUP BY 
	date, 
	branch, 
	gross_income
ORDER BY 
	branch
;
GO

-- MODE
WITH ProductCount AS (
	SELECT
		branch,
		product_line,
		YEAR(date) as Year_Val,
		gross_income,
		ROW_NUMBER()
			OVER(PARTITION BY product_line
			ORDER BY product_line) AS modeProduct
	FROM market)
SELECT
	product_line,
	modeProduct AS mode
FROM
	ProductCount
WHERE ModeProduct IN (
	SELECT MAX(modeProduct)
	FROM ProductCount
)
;
GO
