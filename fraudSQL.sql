Analyzing client data for potential fraud
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
