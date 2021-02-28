USE [WideWorldImporters]
GO

/****** Object:  StoredProcedure [Website].[SearchForPeople]    Script Date: 07/09/2020 8:15:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Website].[SearchForPeople]
@SearchText nvarchar(1000),
@MaximumRowsToReturn int
AS
BEGIN
    SELECT TOP(@MaximumRowsToReturn)
           p.PersonID,
           p.FullName,
           p.PreferredName,
           CASE WHEN p.IsSalesperson <> 0 THEN N'Salesperson'
                WHEN p.IsEmployee <> 0 THEN N'Employee'
                WHEN c.CustomerID IS NOT NULL THEN N'Customer'
                WHEN sp.SupplierID IS NOT NULL THEN N'Supplier'
                WHEN sa.SupplierID IS NOT NULL THEN N'Supplier'
           END AS Relationship,
           COALESCE(c.CustomerName, sp.SupplierName, sa.SupplierName, N'WWI') AS Company
    FROM [Application].People AS p
    LEFT OUTER JOIN Sales.Customers AS c
    ON c.PrimaryContactPersonID = p.PersonID
    LEFT OUTER JOIN Purchasing.Suppliers AS sp
    ON sp.PrimaryContactPersonID = p.PersonID
    LEFT OUTER JOIN Purchasing.Suppliers AS sa
    ON sa.AlternateContactPersonID = p.PersonID
    WHERE p.SearchName LIKE N'%' + @SearchText + N'%'
    ORDER BY p.FullName
    FOR JSON AUTO, ROOT(N'People');
END;
GO

EXEC Website.SearchForPeople 'Adam', 10

-- Creating our own Procedure
-- create a stored procedure to identify inventory
CREATE PROCEDURE Warehouse.uspLowInventory
AS
SELECT	Warehouse.StockItems.StockItemID AS ID,
		Warehouse.StockItems.StockItemName AS 'Item Name',
		Warehouse.StockItemHoldings.QuantityOnHand AS 'On Hand',
		Warehouse.StockItemHoldings.ReorderLevel AS 'Reorder Level'
FROM	Warehouse.StockItems INNER JOIN
		Warehouse.StockItemHoldings ON Warehouse.StockItems.StockItemID = Warehouse.StockItemHoldings.StockItemID
ORDER BY 'On Hand';
GO

-- execute the stored procedure
EXECUTE Warehouse.uspLowInventory

-- alter the procedure to locate low inventory
ALTER PROCEDURE Warehouse.uspLowInventory
AS
SELECT	Warehouse.StockItems.StockItemID AS ID,
		Warehouse.StockItems.StockItemName AS 'Item Name',
		Warehouse.StockItemHoldings.QuantityOnHand AS 'On Hand',
		Warehouse.StockItemHoldings.ReorderLevel AS 'Reorder Level'
FROM	Warehouse.StockItems INNER JOIN
		Warehouse.StockItemHoldings ON Warehouse.StockItems.StockItemID = Warehouse.StockItemHoldings.StockItemID
WHERE	ReorderLevel > QuantityOnHand
ORDER BY 'On Hand';
GO

-- execute the stored procedure
EXECUTE Warehouse.uspLowInventory

-- clean up the WideWorldImporters database
DROP PROCEDURE Warehouse.uspLowInventory;
GO

-- create procedure with parameter
CREATE PROCEDURE Warehouse.uspSelectProductsByColor
    @paramColor char(20)
AS
SELECT	Warehouse.StockItems.StockItemID,
		Warehouse.StockItems.StockItemName,
		Warehouse.StockItemHoldings.QuantityOnHand,
		Warehouse.StockItems.RecommendedRetailPrice,
		Warehouse.Colors.ColorName
FROM	Warehouse.Colors INNER JOIN
		Warehouse.StockItems ON Warehouse.Colors.ColorID = Warehouse.StockItems.ColorID INNER JOIN
		Warehouse.StockItemHoldings ON Warehouse.StockItems.StockItemID = Warehouse.StockItemHoldings.StockItemID
WHERE ColorName = @paramColor
;
GO

-- execute the stored procedure with various parameters
EXEC Warehouse.uspSelectProductsByColor 'Black';
GO
EXEC Warehouse.uspSelectProductsByColor 'Blue';
GO
EXEC Warehouse.uspSelectProductsByColor;
GO

-- alter the procedure to include a default value and error handling
ALTER PROCEDURE Warehouse.uspSelectProductsByColor
    @paramColor char(20) = NULL
AS
IF @paramColor IS NULL
BEGIN
   PRINT 'A valid product color is required.'
   RETURN
END
SELECT  Warehouse.StockItems.StockItemID,
        Warehouse.StockItems.StockItemName,
        Warehouse.StockItemHoldings.QuantityOnHand,
        Warehouse.StockItems.RecommendedRetailPrice,
        Warehouse.Colors.ColorName
FROM    Warehouse.Colors INNER JOIN
        Warehouse.StockItems ON Warehouse.Colors.ColorID = Warehouse.StockItems.ColorID INNER JOIN
        Warehouse.StockItemHoldings ON Warehouse.StockItems.StockItemID = Warehouse.StockItemHoldings.StockItemID
WHERE ColorName = @paramColor
;
GO

EXEC Warehouse.uspSelectProductsByColor;
GO
EXEC Warehouse.uspSelectProductsByColor 'Red';
GO

-- clean up the WideWorldImporters database
DROP PROCEDURE Warehouse.uspSelectProductsByColor;
GO

