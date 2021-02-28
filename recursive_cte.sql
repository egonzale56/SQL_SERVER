-- Calculate the sum of numbers
WITH calculate_SumOfNumbers AS (
-- Initial query
	SELECT
		1 AS iteration,
		1 AS SumOfNumbers
			UNION ALL
-- Recursion Part
	SELECT
		iteration + 1,
		SumOfNumbers + (iteration + 1)
	FROM
		calculate_SumOfNumbers
	WHERE
		iteration < 6
	)
SELECT 
	SumOfNumbers
FROM 
	calculate_SumOfNumbers
;
GO

-- Define the target factorial number
DECLARE @target FLOAT = 5
-- Initialization of the factorial number
DECLARE @factorial FLOAT = 1

WHILE @target > 0
BEGIN
-- Calculate the factorial number
	SET @factorial = @factorial * @target
-- Reduce the termination condition
	SET @target = @target -1
END
SELECT
	@factorial
;
GO

-- Factorial of 6 recursively
WITH calculate_factorial AS (
	SELECT
-- Initialize the step and factorial number
	1 AS step,
	1 AS factorial
		UNION ALL
	SELECT
		step + 1,
-- Calculate the recursive part by n!*(n-1)
		factorial * (step + 1)
	FROM
		calculate_factorial
-- Stop the recursion reaching the target
	WHERE
		step < 6
	)
SELECT
	factorial
FROM
	calculate_factorial
;
GO

-- Calculate the sum of potencies
WITH calculate_potencies (step, result) AS (
	SELECT
		1,
		1
			UNION ALL
	SELECT 
		step + 1,
		result + POWER(step + 1, step + 1)
	FROM 
		calculate_potencies
	WHERE
		step < 9
)
SELECT
	step,
	result
FROM
	calculate_potencies
;
GO

