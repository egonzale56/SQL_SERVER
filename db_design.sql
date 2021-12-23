USE Design;

SELECT TOP(5) *
FROM dbo.reviews;
GO 

SELECT product_name, 
       SUM(price)
FROM poducts
GROUP BY product_name
ORDER BY 2 desc;

-- Create a view
CREATE VIEW top_score_2017 AS
SELECT score, title, author
FROM reviews
WHERE score >= 85
;
GO

-- Check al views in the database except the system ones
USE Design;
SELECT table_schema, table_name
FROM INFORMATION_SCHEMA.VIEWS
;

USE Design;
SELECT 
  SCHEMA_NAME(schema_id) AS [Schema],
  Name
FROM sys.views;

-- Return the view query
SELECT definition
FROM sys.views v
INNER JOIN sys.sql_modules m 
ON v.object_id = m.object_id;
GO

-- Drop view

DROP VIEW top_score_2017;

