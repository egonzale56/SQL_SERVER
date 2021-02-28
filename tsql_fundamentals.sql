USE test;

SELECT TOP(10) * FROM orders;

-- STRINGS LEN, LEFT, CHARINDEX, SUBSTRING, REPLACE

-- LEN
SELECT 
	TOP(1) *
FROM
	orders;

SELECT 
	LEN(territoryName) as lenght,
	territoryName
FROM
	orders
WHERE 
	OrderId = '40646'
;
GO

-- LEFT
SELECT 
	LEFT(territoryName, 3) as lenght,
	territoryName
FROM
	orders
WHERE 
	OrderId = '40646'
;
GO

-- CHARINDEX
SELECT 
	CHARINDEX('Z', OrderDate) as CharLocationZ,
	OrderDate
FROM
	orders
WHERE
	OrderId = '40646'
;
GO

-- SUBSTRING
SELECT 
	TOP(10) SUBSTRING(OrderDate,0,5) AS YearValue,
	OrderDate
FROM
	orders
;
GO

-- REPLACE
SELECT 
	TOP(5) REPLACE(OrderDate, 'Z','') AS replaced_str
FROM
	orders
;
GO

SELECT  
	OrderId as ID,
	LEFT(territoryName, 3) AS Country,
	CHARINDEX('Z', OrderDate) AS ZIndexNumber,
	LEN(OrderID) AS IdLength,
	SUBSTRING(OrderDate,0,5) AS YearValue
FROM
	orders
WHERE 
	OrderId BETWEEN 40646 AND 40705
ORDER BY OrderId
;
GO

-- Grouping by and Having
SELECT
	territoryName AS Country,
	SUM(OrderPrice) AS TotalSales,
	YearOrdered
FROM
	orders
WHERE 
	YearOrdered Between 2015 and 2016
GROUP BY 
	territoryName, 
	OrderPrice, 
	YearOrdered
HAVING 
	SUM(OrderPrice) > 500
ORDER BY 
	Country
;
GO

-- Temporary Table
DECLARE
	@uk VARCHAR(25) = 'United Kingdom';

SELECT
	*
INTO 
	#MyTempTable
FROM
	orders
WHERE territoryName = @uk
;

SELECT * FROM #MyTempTable;
GO
