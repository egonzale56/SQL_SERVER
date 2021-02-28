USE voters;
GO

SELECT TOP(5) *
FROM votes;

SELECT TOP(5) *
FROM ratings;

-- CAST examples
SELECT
	first_name + ' ' + last_name +  ' ' + CAST(YEAR(birthdate) AS nvarchar) AS Profiles
FROM votes
;


SELECT
	CAST(total_votes/5.5 AS INT) AS Divided_Votes
FROM
	votes
;

SELECT
	first_name,
	last_name,
	total_votes
FROM votes
WHERE
	CAST(total_votes AS CHAR(10)) LIKE '5%'
;
GO

-- CONVERT examples
SELECT
	email,
	-- 107 means datetype format = Mon dd, yyyy
	CONVERT(VARCHAR, birthdate, 107) AS birthdate
FROM
	votes
;

SELECT 
	company,
	bean_origin,
	rating
FROM
	ratings
WHERE
	CONVERT(INT, rating) = 3
;

SELECT
	first_name,
	last_name, 
	CONVERT(VARCHAR(10), birthdate, 11) AS birthdate,
	gender,
	country,
	'Voted ' + CAST(total_votes AS NVARCHAR) + ' times' AS Comments
FROM 
	votes
WHERE 
	country = 'Belgium'
		AND
	gender = 'F'
		AND
	total_votes > 20
;
GO

-- Higher Precision date / time
SELECT
	SYSDATETIME() AS [SYSDATETIME],
	SYSDATETIMEOFFSET() AS [SYSDATETIMEOFFSET],
	SYSUTCDATETIME() AS [SYSUTCDATETIME]
;

-- Lower Precision date / time
SELECT
	CURRENT_TIMESTAMP AS [CURRENT_TIMESTAMP],
	GETDATE() AS [GETDATE],
	GETUTCDATE() AS [GETUTCDATE]
;

-- CONVERT sys datetimes to dates
SELECT 
	CONVERT(DATE, SYSDATETIME()) AS [SYSDATETIME],
	CONVERT(DATE, SYSDATETIMEOFFSET()) AS [SYSDATETIMEOFFSET],
	CONVERT(DATE, SYSUTCDATETIME()) AS [SYSUTCDATETIME],
	CONVERT(DATE, CURRENT_TIMESTAMP) AS [CURRENT_TIMESTAMP],
	CONVERT(DATE, GETDATE()) AS [GETDATE],
	CONVERT(DATE, GETUTCDATE()) AS [GETUTCDATE]
;
GO

-- Check for all the databases in the environment
SELECT name, database_id, create_date  
FROM sys.databases ;  
GO  

-- DATENAME, DATEPART examples
SELECT
	DATENAME(WEEKDAY, first_vote_date) AS TheDay,
	DATENAME(MONTH, first_vote_date) AS TheMonth,
	DATEPART(YEAR, first_vote_date) AS TheYear
FROM
	votes
WHERE 
	customer_id = 1
;
GO

-- DATEADD and DATEDIFF examples
SELECT
	TOP 5
	birthdate,
	DATEADD(YEAR, 18, birthdate)
FROM
	votes;


SELECT
	first_name,
	last_name,
	first_vote_date,
	DATEDIFF(YEAR, DATEADD(YEAR, 18, birthdate), first_vote_date) AS Adults_years_until_vote
FROM
	votes
;

SELECT
	DATEDIFF(WEEK, '2019-01-01', GETDATE()) AS weeks_passed_tillNow
;
GO

-- Using ISDATE() to determine valid date type data
DECLARE @date1 NVARCHAR(20) = '2019-05-05'
DECLARE @date2 NVARCHAR(20) = '2019-xx-01'
DECLARE @date3 CHAR(20) = '2019-05-05 12:45:09.99999999'
DECLARE @date4 CHAR(20) = '2019-05-05 12:45:09'
;

SELECT
	ISDATE(@date1) AS valid_date,
	ISDATE(@date2) AS invalid_date2,
	ISDATE(@date3) AS invalid_date3,
	ISDATE(@date4) AS valid_date4
;
GO

-- SET DATEFORMAT example
DECLARE @date1 NVARCHAR(20) = '12-30-2019'
DECLARE @date2 CHAR(20) = '30-12-2019'

SET DATEFORMAT dmy;

SELECT
	ISDATE(@date1) AS invalid_dmy,
	ISDATE(@date2) as valid_dmty
;
GO

-- Set correct language
DECLARE @date1 NVARCHAR(20) = '30-03-2019';
SET LANGUAGE English;

SELECT
	@date1 AS initial_date,
	-- check that the date is valid
	ISDATE(@date1) AS is_valid,
	-- select the name of the month
	DATENAME(MONTH, @date1) AS month_name
;
GO

SELECT
	first_name,
	last_name,
	birthdate,
	first_vote_date,
	DATENAME(WEEKDAY, first_vote_date) AS firstVoteDate,
	YEAR(first_vote_date) AS firstVoteYear,
	DATEDIFF(YEAR, birthdate, first_vote_date) AS age_vote_day,
	DATEDIFF(YEAR, birthdate, GETDATE()) AS current_age
FROM votes
;
GO

/* Manipulating Strings
LEN() = length of observation
CHARINDEX() = starting position of a strin
PATINDEX() = starting position of a pattern
LOWER() = lowercase
UPPER() = uppercase
LEFT() = left index cut
RIGHT() = right index cut
LTRIM() = returns strings after removing white space on the left
RTRIM() = returns string after removing white space on the right
TRIM() = returns string after removing white space
REPLACE() = returns a string replaced with another one
SUBSTRING() = returns parts of a string
*/

SELECT
	first_name,
	last_name,
	email
FROM votes
-- Look for names with "rr" in the middle
WHERE PATINDEX('%rr%', first_name) > 0
;

SELECT
	first_name,
	last_name,
	email
FROM
	votes
-- finds a name that starts with C and
-- the 3rd letter is r
WHERE first_name LIKE 'C%'
	AND
PATINDEX('%r%', first_name) = 3
;

SELECT
	first_name,
	last_name
FROM 
	votes
WHERE
	PATINDEX('%[xwq]%', first_name) > 0
;

-- Using CONCAT() and CONCAT_WS()
SELECT
	CONCAT('Apples', 'and', 'oranges') AS result_concat,
	CONCAT_WS(' ', 'Apples', 'and', 'oranges') AS X,
	CONCAT_WS('***', 'Apples', 'and', 'oranges') AS y
;
GO

-- Using STRING_AGG() to create lists with separators
SELECT 
	DISTINCT(STRING_AGG(first_name, ', ')) AS list_of_names,
	COUNT(DISTINCT(first_name)) AS ctr
FROM
	votes
;
GO