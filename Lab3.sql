DROP TABLE IF EXISTS dbo.Orders;

CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    Status VARCHAR(10)
);

DROP PROCEDURE IF EXISTS sp_Insert_Orders_Aleena;
GO

CREATE PROCEDURE sp_Insert_Orders_Aleena
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaxCustomerID INT;
    SELECT @MaxCustomerID = ISNULL(MAX(CustomerID), 0) FROM Orders;

    WITH Numbers AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1
        FROM Numbers
        WHERE n < 1000000
    )
    INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
    SELECT 
        n + 1000, -- OrderID (non-PK)
        n + @MaxCustomerID, -- CustomerID (Primary Key)
        DATEADD(DAY, -(n % 365), GETDATE()),
        CAST(100 + (n % 9000) AS DECIMAL(10, 2)),
        CHOOSE((n % 3) + 1, 'Pending', 'Shipped', 'Delivered')
    FROM Numbers
    OPTION (MAXRECURSION 0);
END;
GO

EXEC sp_Insert_Orders_Aleena;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT * FROM Orders WHERE OrderID = 1;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

CREATE CLUSTERED INDEX IX_OrderID ON Orders(OrderID);

