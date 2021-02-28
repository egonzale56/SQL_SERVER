USE WideWorldImporters;

CREATE FUNCTION Warehouse.ToFahrenheit(@Celsius DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
	DECLARE @Fahrenheit DECIMAL(10,2);
	SET @Fahrenheit = (@Celsius * 1.8 + 32);
	RETURN @Fahrenheit
END;

-- Call the function in a Query
SELECT TOP 100 VehicleTemperatureID,
	           Temperature AS Celsius,
			   Warehouse.ToFahrenheit(Temperature) AS Fahrenheit
FROM Warehouse.VehicleTemperatures;