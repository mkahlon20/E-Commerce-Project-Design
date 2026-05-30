/*
========================================================
Tadpole Marketplace Database
Operations Schema
Martin Lam

This script creates the operational tables that depend
on the foundation tables

Tables 
- Product
- Inventory
- Orders        (the word "Order" is a keyword in SQL
                 so the table is named "Orders")
- OrderItem
- Payment
- Review

notes:
- Product is connected to Seller and Category.
- Inventory is connected to Product.
- Orders is connected to Buyer.
- OrderItem is connected to Orders and Product.
- Payment is connected to Orders.
- Review is connected to Buyer and Product
- Run 01_foundation_schema.sql BEFORE this file.
========================================================
*/

USE tadpole_marketplace;

CREATE TABLE Product (
    ProductID INT NOT NULL AUTO_INCREMENT,
    SellerID INT NOT NULL,
    CategoryID INT,
    ProductName VARCHAR(150) NOT NULL,
    Description VARCHAR(500),
    Price DECIMAL(10,2) NOT NULL,
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (ProductID),
    FOREIGN KEY (SellerID) REFERENCES Seller(SellerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Inventory (
    InventoryID INT NOT NULL AUTO_INCREMENT,
    ProductID INT NOT NULL UNIQUE,
    QuantityAvailable INT NOT NULL DEFAULT 0,
    LastUpdated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (InventoryID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Orders (
    OrderID INT NOT NULL AUTO_INCREMENT,
    BuyerID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    OrderStatus VARCHAR(20) NOT NULL DEFAULT 'Processing',
    TotalAmount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (BuyerID) REFERENCES Buyer(BuyerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE OrderItem (
    OrderItemID INT NOT NULL AUTO_INCREMENT,
    OrderID INT NOT NULL,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    LineTotal DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderItemID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Payment (
    PaymentID INT NOT NULL AUTO_INCREMENT,
    OrderID INT NOT NULL UNIQUE,
    PaymentDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(30) NOT NULL,
    PaymentStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',
    AmountPaid DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (PaymentID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Review (
    ReviewID INT NOT NULL AUTO_INCREMENT,
    BuyerID INT NOT NULL,
    ProductID INT NOT NULL,
    Rating INT NOT NULL,
    ReviewText VARCHAR(1000),
    ReviewDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ReviewID),
    FOREIGN KEY (BuyerID) REFERENCES Buyer(BuyerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
