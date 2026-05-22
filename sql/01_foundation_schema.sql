/*
========================================================
Tadpole Marketplace Database
Foundation Schema
Mohitveer Kahlon

This script creates the tables for the Tadpole Marketplace database system.

Tables:
- User
- Buyer
- Seller
- Category

Notes:
- User is the main parent table.
- Buyer and Seller are connected to User.
- Foreign keys are used to connect tables.
- The database is designed to reduce
  duplicate data and keep relationships
  organized.
========================================================
*/

DROP DATABASE IF EXISTS tadpole_marketplace;
CREATE DATABASE tadpole_marketplace;
USE tadpole_marketplace;

CREATE TABLE User (
    UserID INT NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) UNIQUE,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID)
);

CREATE TABLE Buyer (
    BuyerID INT NOT NULL AUTO_INCREMENT,
    UserID INT NOT NULL UNIQUE,
    ShippingAddress VARCHAR(255) NOT NULL,
    PRIMARY KEY (BuyerID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Seller (
    SellerID INT NOT NULL AUTO_INCREMENT,
    UserID INT NOT NULL UNIQUE,
    StoreName VARCHAR(100) NOT NULL UNIQUE,
    BusinessEmail VARCHAR(100) NOT NULL UNIQUE,
    SellerRating DECIMAL(3,2),
    PRIMARY KEY (SellerID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Category (
    CategoryID INT NOT NULL AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255),
    PRIMARY KEY (CategoryID)
);
