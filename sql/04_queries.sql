/*
Tadpole Marketplace Database
Required Queries / Operations
Martin Lam

Tasks covered:
  1. List products currently in inventory
  2. Create a new product
  3. Modify the amount of a product in inventory
  4. Delete a product from inventory
  5. Most popular products for a given time range
  6. Least popular products for a given time range
  7. Users who haven't purchased in a few months
     (+ the products they normally purchase)

*/

USE tadpole_marketplace;

/* 
   1. List which products we currently have in inventory
*/
SELECT p.ProductID,
       p.ProductName,
       c.CategoryName,
       p.Price,
       i.QuantityAvailable,
       i.LastUpdated
FROM Product p
JOIN Inventory i ON p.ProductID = i.ProductID
LEFT JOIN Category c ON p.CategoryID = c.CategoryID
WHERE p.IsActive = 1
ORDER BY p.ProductName;


/*
   2. Create new product
*/
INSERT INTO Product (SellerID, CategoryID, ProductName, Description, Price, IsActive)
VALUES (1, 1, 'Portable Speaker', 'Waterproof Bluetooth speaker', 49.99, 1);

INSERT INTO Inventory (ProductID, QuantityAvailable)
VALUES (LAST_INSERT_ID(), 50);


/*
   3. Modify the amount of a particular product that we have in inventory
 */
UPDATE Inventory
SET QuantityAvailable = 100,
    LastUpdated = CURRENT_TIMESTAMP
WHERE ProductID = 3;


/*
   4. Delete a product from inventory
*/
DELETE FROM Product
WHERE ProductID = 13;


/* 
   5. Get a list of the most popular products for a given time range
*/
SELECT p.ProductID,
       p.ProductName,
       SUM(oi.Quantity) AS UnitsSold,
       COUNT(DISTINCT o.OrderID) AS OrderCount

/*
   We INNER JOIN from OrderItem to Orders and Product because we only
   want products that were sold in the time range. The date
   range conditions go in the WHERE clause because they apply to Orders.
*/
FROM OrderItem oi
JOIN Orders o   ON oi.OrderID = o.OrderID
JOIN Product p  ON oi.ProductID = p.ProductID
WHERE o.OrderDate >= '2026-01-01'
  AND o.OrderDate <  '2026-04-01'
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC
LIMIT 5;


/*
   6. Get a list of the least popular products for a given time range
*/
SELECT p.ProductID,
       p.ProductName,
       COALESCE(SUM(oi.Quantity), 0) AS UnitsSold

/*
   We want to include products with zero sales, so we LEFT JOIN
   from Product to OrderItem and Orders. The date range conditions
   go in the ON clause of the Orders join so they don't turn the
   LEFT JOIN into an INNER JOIN.
*/
FROM Product p
LEFT JOIN OrderItem oi
       ON p.ProductID = oi.ProductID
LEFT JOIN Orders o
       ON oi.OrderID = o.OrderID
      AND o.OrderDate >= '2026-01-01'
      AND o.OrderDate <  '2026-04-01'
WHERE p.IsActive = 1
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold ASC, p.ProductName
LIMIT 5;


/* 
   7a. Get a list of users who haven't purchased something 
   in a few months to send promotional emails to
*/
SELECT u.UserID,
       u.FirstName,
       u.LastName,
       u.Email,
       MAX(o.OrderDate) AS LastOrderDate
/*
   We INNER JOIN from User to Buyer and Orders because we only
   want users who have made purchases before.
*/
FROM User u
JOIN Buyer b  ON u.UserID = b.UserID
JOIN Orders o ON b.BuyerID = o.BuyerID
GROUP BY u.UserID, u.FirstName, u.LastName, u.Email
HAVING MAX(o.OrderDate) < DATE_SUB('2026-05-29', INTERVAL 3 MONTH)
ORDER BY LastOrderDate;


/* 
   7b. Get a list of products that lapsed users normally purchase
*/
SELECT u.UserID,
       u.FirstName,
       u.LastName,
       p.ProductName,
       SUM(oi.Quantity)        AS TotalUnitsBought,
       COUNT(DISTINCT o.OrderID) AS TimesOrdered
/*
   We INNER JOIN from User to Buyer, Orders, OrderItem, and Product
   because we only want products that were purchased by lapsed users.
*/
FROM User u
JOIN Buyer b     ON u.UserID = b.UserID
JOIN Orders o    ON b.BuyerID = o.BuyerID
JOIN OrderItem oi ON o.OrderID = oi.OrderID
JOIN Product p   ON oi.ProductID = p.ProductID
WHERE b.BuyerID IN (
        SELECT b2.BuyerID
        FROM Buyer b2
        JOIN Orders o2 ON b2.BuyerID = o2.BuyerID
        GROUP BY b2.BuyerID
        HAVING MAX(o2.OrderDate) < DATE_SUB('2026-05-29', INTERVAL 3 MONTH)
      )
GROUP BY u.UserID, u.FirstName, u.LastName, p.ProductName
ORDER BY u.UserID, TotalUnitsBought DESC;
