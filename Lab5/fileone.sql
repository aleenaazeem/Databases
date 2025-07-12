USE WideWorldImporters;
Go;

CREATE OR ALTER PROCEDURE Warehouse.uspInsertColor (@Color AS nvarchar(100))
AS
DECLARE @ColorID INT
SET @ColorID = (SELECT MAX(ColorID) FROM Warehouse.Colors)+1;
INSERT INTO Warehouse.Colors (ColorID, ColorName, LastEditedBy) VALUES (@ColorID, @Color, 1);
SELECT * FROM Warehouse.Colors WHERE ColorID = @ColorID ORDER BY ColorID DESC;

BEGIN TRANSACTION FirstTransaction WITH MARK; -- or BEGIN TRAN
EXEC Warehouse.uspInsertColor 'Sunset Orange';
EXEC Warehouse.uspInsertColor 'Tomato Red';
SELECT * FROM Warehouse.Colors ORDER BY ColorID DESC;
ROLLBACK TRANSACTION FirstTransaction; -- Undo the data input
COMMIT TRANSACTION FirstTransaction;

BEGIN TRANSACTION;
SELECT @@TRANCOUNT AS 'Open Transactions';
EXEC Warehouse.uspInsertColor 'Lemongrass Green';
SAVE TRANSACTION SavePointOne;
EXEC Warehouse.uspInsertColor 'Galaxy Purple';
ROLLBACK TRANSACTION SavePointOne;
COMMIT TRANSACTION;

SELECT * FROM Warehouse.Colors ORDER BY ColorID DESC;
BEGIN TRANSACTION;
EXEC Warehouse.uspInsertColor 'burnished bronze';
SELECT @@TRANCOUNT AS 'Open Transactions';
COMMIT TRANSACTION;
SELECT * FROM Warehouse.Colors ORDER BY ColorID DESC;
SELECT CASE WHEN (16384 & @@OPTIONS) = 16384 THEN 'ON'
ELSE 'OFF'
END AS XACT_ABORT;
SET XACT_ABORT ON; -- or OFF
BEGIN TRANSACTION;
EXEC Warehouse.uspInsertColor 'Glittering Gold';
SELECT * FROM Warehouse.Colors ORDER BY ColorID DESC;
SELECT @@TRANCOUNT AS 'Open Transactions';