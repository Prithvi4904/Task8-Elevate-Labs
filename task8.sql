-- Cleanup if re-running
DROP PROCEDURE IF EXISTS GetCustomerOrders;
DROP FUNCTION IF EXISTS GetTotalSpent;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(100)
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Amount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert sample data
INSERT INTO Customers VALUES
(1, 'Alice', 'Boston'),
(2, 'Bob', 'New York'),
(3, 'Charlie', 'Chicago');

INSERT INTO Orders VALUES
(101, 1, '2024-01-10', 250.00),
(102, 1, '2024-02-15', 300.00),
(103, 2, '2024-03-05', 150.00);

-- 1️⃣ Stored Procedure: List all orders for a given customer
DELIMITER //
CREATE PROCEDURE GetCustomerOrders(IN cust_id INT)
BEGIN
    SELECT OrderID, OrderDate, Amount
    FROM Orders
    WHERE CustomerID = cust_id;
END;
//
DELIMITER ;

-- Call the procedure
CALL GetCustomerOrders(1);

-- 2️⃣ Stored Function: Return total amount spent by a customer
DELIMITER //
CREATE FUNCTION GetTotalSpent(cust_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(Amount) INTO total
    FROM Orders
    WHERE CustomerID = cust_id;
    RETURN IFNULL(total, 0);
END;
//
DELIMITER ;

-- Use the function
SELECT Name, GetTotalSpent(CustomerID) AS TotalSpent
FROM Customers;
