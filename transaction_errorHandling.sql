use bikes;
GO

SELECT
  *
FROM
  INFORMATION_SCHEMA.TABLES;
GO

SELECT TOP 5 * 
FROM staff;
GO

-- Display a message if value is duplicated
BEGIN TRY
	INSERT INTO products(product_name, stock, price)
	VALUES('Trek Conduit+', 5, 1234.99);
	SELECT 'Product inserted correctly' AS message;
END TRY
BEGIN CATCH
	SELECT 'An Error Occured, you are in the catch block' AS message;
END CATCH
;
GO

-- Nested try and catch
BEGIN TRY
	INSERT INTO products(product_name, stock, price)
	VALUES('Trek Conduit+', 5, 1234.99);
	SELECT 'Product inserted correctly' AS message
END TRY
BEGIN CATCH
	SELECT 'An Error Occured, you are in the first CATCH block' AS message;
		BEGIN TRY
			INSERT INTO products(product_name, stock, price)
			VALUES('Trek CrossRip+ - 2018',10, 3450.99);
		END TRY
		BEGIN CATCH
			SELECT 'An Error Occured, you are in the second CATCH block' AS message;
		END CATCH
END CATCH
;
GO

-- check all message errors (309540)
SELECT COUNT(*)
FROM sys.messages;
GO

-- Check error functions
BEGIN TRY 
	INSERT INTO products(product_name, stock, price)
	VALUES('Trek Conduit+', 5, 1499.99);
END TRY
BEGIN CATCH
	SELECT 
		ERROR_NUMBER() AS errorNumber,
		ERROR_SEVERITY() AS errorSeverity,
		ERROR_STATE() AS errorState,
		ERROR_LINE() AS errorLine,
		ERROR_PROCEDURE() AS errorProcedure;
END CATCH
GO

-- Using Throw statement with parameters
BEGIN TRY 
	IF NOT EXISTS(SELECT * FROM staff
				  WHERE staff_id = 15)
	THROW 51000, 'This is an example', 1;
END TRY
BEGIN CATCH
	SELECT 
		ERROR_NUMBER() as number,
		ERROR_MESSAGE() as message,
		ERROR_STATE() as state;
END CATCH
GO

-- Using Throw statement without parameters, must be in the CATCH statement
BEGIN TRY 
	INSERT INTO products(product_id, stock, price)
	VALUES('Trek Conduit+', 5, 1499.99);
END TRY
BEGIN CATCH
	INSERT INTO errors
	VALUES('Error inserting duplicated value Trek Conduit+');
	THROW;
END CATCH
GO

-- Customize error message for THROW statement using CONCAT
DECLARE @staff_id INT = 500;
DECLARE @my_message VARCHAR(500) = CONCAT('There is no staff member for that id: ', @staff_id, ' Try another one');
IF NOT EXISTS(SELECT * FROM staff WHERE staff_id = @staff_id)
THROW 50000, @my_message, 1;
GO

-- Customize error message for THROW statement using FORMATMESSAGE
DECLARE @staff_id INT = 500;
DECLARE @my_message VARCHAR(500) = FORMATMESSAGE('There is no staff member for that id %d. %s', @staff_id, 'Try another one');
IF NOT EXISTS(SELECT * FROM staff WHERE staff_id = @staff_id)
THROW 50000, @my_message, 1;
GO

-- Transactions
USE bank;
GO

BEGIN TRAN;
	UPDATE accounts
		SET current_balance = current_balance - 100
		WHERE account_id = 1;
	INSERT INTO transactions
	VALUES(1, -100, GETDATE());

	UPDATE accounts
		SET current_balance = current_balance + 100
		WHERE account_id = 5;
	INSERT INTO transactions
	VALUES(5, 100, GETDATE());
COMMIT TRAN;
GO

-- Using ROLLBACK to revert the transaction
BEGIN TRY
	BEGIN TRAN;
		UPDATE accounts
			SET current_balance = current_balance - 100
			WHERE account_id = 1;
		INSERT INTO transactions
		VALUES(1, -100, GETDATE());

		UPDATE accounts
			SET current_balance = current_balance + 100
			WHERE account_id = 5;
		INSERT INTO transactions
		VALUES(5, 100, GETDATE());
	COMMIT TRAN;
END TRY
BEGIN CATCH
	ROLLBACK TRAN;
END CATCH
GO

SELECT * 
FROM transactions;
GO

-- TRANCOUNT and savepoints
-- Nested transactions
SELECT @@TRANCOUNT AS '@@TRANCOUNT Value';
BEGIN TRAN;
	SELECT @@TRANCOUNT AS '@@TRANCOUNT Value';
	DELETE transactions;
	BEGIN TRAN;
		SELECT @@TRANCOUNT AS '@@TRANCOUNT Value';
		DELETE accounts;
	-- If @@TRANCOUNT > 1 it doesnt commit
	COMMIT TRAN;
	SELECT @@TRANCOUNT AS '@@TRANCOUNT Value';
COMMIT TRAN;
SELECT @@TRANCOUNT AS '@@TRANCOUNT Value';
GO

-- Savepoints
BEGIN TRAN;
	SAVE TRAN savepoint1;
	INSERT INTO customers
	VALUES('Mark', 'Zuck', 'mark@email.com', 5555555555);

	SAVE TRAN savepoint2;
	INSERT INTO customers
	VALUES('Ed', 'Gonz', 'ed@email.com', 5555554555);

	ROLLBACK TRAN savepoint1;
	ROLLBACK TRAN savepoint2;

	SAVE TRAN savepoint3;
	INSERT INTO customers
	VALUES('Alex', 'Smith', 'alex@email.com', 5535554555);
COMMIT TRAN;
GO

-- XACT_ABORT and XACT_STATE
-- Using Raiserror the data gets added after the error
SET XACT_ABORT ON;
BEGIN TRAN;
	INSERT INTO customers
	VALUES('John', 'Wayne', 'wayne@email.com', 5555553421);

	RAISERROR('Raising error', 16, 1);

	INSERT INTO customers
	VALUES('Eduardo', 'Gonzalez', 'eduardo@email.com', 5555354555);
	
COMMIT TRAN;
GO
-- Using Throw non of the data gets added
SET XACT_ABORT ON;
BEGIN TRAN;
	INSERT INTO customers
	VALUES('Eduardo', 'Gonzalez', 'eduardo@email.com', 5555354555);

	THROW 55000, 'Raising Error', 1;

	INSERT INTO customers
	VALUES('John', 'Wayne', 'wayne@email.com', 5555553421);
COMMIT TRAN;
GO

SELECT * FROM customers;
GO

--Doomed transactions
SET XACT_ABORT ON;
BEGIN TRY
	BEGIN TRAN;
		INSERT INTO customers
		VALUES('Yer', 'Tre', 'yer@email.com', 1555354555);

		INSERT INTO customers
		VALUES('Ben', 'Word', 'ben@email.com', 1555553421);
	COMMIT TRAN;
END TRY
BEGIN CATCH
	IF XACT_STATE() = -1
		ROLLBACK TRAN;
	IF XACT_STATE() = 1
		COMMIT TRAN;
	SELECT ERROR_MESSAGE() AS Message;
END CATCH
GO

--Transaction Isolation Levels
-- display the current transaction isolation level from current session
SELECT CASE transaction_isolation_level
	WHEN 0 THEN 'unspecified'
	WHEN 1 THEN 'read committed'
	WHEN 2 THEN 'read uncommitted'
	WHEN 3 THEN 'repeatable read'
	WHEN 4 THEN 'serializable'
	WHEN 5 THEN 'snapshot'
END AS transaction_isolation_level
FROM sys.dm_exec_sessions
WHERE session_id = @@SPID
;
GO

