-- https://www.hackerrank.com/challenges/earnings-of-employees/problem
SELECT MAX(SALARY * MONTHS), COUNT(1)
FROM EMPLOYEE
WHERE SALARY * MONTHS = (SELECT MAX(SALARY * MONTHS) FROM EMPLOYEE)
;

-- Find Duplicates in a table
SELECT
    name, email, COUNT(*)
FROM
    users
GROUP BY
    name, email
HAVING
    COUNT(*) > 1
;

-- SELECT unique multiple rows
SELECT DISTINCT
    first_name,
    last_name,
    email
FROM
    votes
;
GO


