/*
========================================================
Tadpole Marketplace Database
Seed Data
Martin Lam

Inserts sample data into every table.
Run AFTER 01_foundation_schema.sql and 02_operations_schema.sql.

The data is spread across ~6 months (Nov 2025 - May 2026)
so the queries in 04_queries.sql return useful results:
  - some products are clearly more popular than others
  - some buyers (Frank, Grace) have not ordered in 3+ months
  - one product (Desk Lamp) has never been ordered
  - some products have low / zero stock

IDs below rely on AUTO_INCREMENT starting at 1 on a fresh
database, so the rows are inserted in dependency order.
========================================================
*/

USE tadpole_marketplace;

-- ============ USERS (UserID 1-12) ============
INSERT INTO User (FirstName, LastName, Email, PasswordHash, Phone, CreatedAt) VALUES
('Alice',  'Nguyen', 'alice.nguyen@email.com', 'hash_a1', '206-555-0101', '2025-10-01 09:00:00'),
('Bob',    'Smith',  'bob.smith@email.com',    'hash_b2', '206-555-0102', '2025-10-03 10:15:00'),
('Carla',  'Diaz',   'carla.diaz@email.com',   'hash_c3', '206-555-0103', '2025-10-05 11:30:00'),
('David',  'Kim',    'david.kim@email.com',    'hash_d4', '206-555-0104', '2025-10-08 14:00:00'),
('Emma',   'Brown',  'emma.brown@email.com',   'hash_e5', '206-555-0105', '2025-10-12 08:45:00'),
('Frank',  'Lee',    'frank.lee@email.com',    'hash_f6', '206-555-0106', '2025-10-15 16:20:00'),
('Grace',  'Park',   'grace.park@email.com',   'hash_g7', '206-555-0107', '2025-10-18 13:10:00'),
('Henry',  'Wong',   'henry.wong@email.com',   'hash_h8', '206-555-0108', '2025-09-20 09:00:00'),
('Ivy',    'Chen',   'ivy.chen@email.com',     'hash_i9', '206-555-0109', '2025-09-22 09:30:00'),
('Jack',   'Olsen',  'jack.olsen@email.com',   'hash_j10','206-555-0110', '2025-09-25 10:00:00'),
('Kara',   'Davis',  'kara.davis@email.com',   'hash_k11','206-555-0111', '2025-09-28 11:00:00'),
('Liam',   'Moore',  'liam.moore@email.com',   'hash_l12', NULL,          '2025-10-20 15:30:00');

-- ============ BUYERS (BuyerID 1-8) ============
-- Maps to Users: 1 Alice, 2 Bob, 3 Carla, 4 David, 5 Emma, 6 Frank, 7 Grace, 12 Liam
INSERT INTO Buyer (UserID, ShippingAddress) VALUES
(1,  '123 Maple St, Seattle, WA 98101'),
(2,  '456 Oak Ave, Seattle, WA 98102'),
(3,  '789 Pine Rd, Bellevue, WA 98004'),
(4,  '321 Cedar Ln, Redmond, WA 98052'),
(5,  '654 Birch Blvd, Seattle, WA 98103'),
(6,  '987 Elm Ct, Tacoma, WA 98402'),
(7,  '147 Spruce Way, Kirkland, WA 98033'),
(12, '258 Willow Dr, Renton, WA 98055');

-- ============ SELLERS (SellerID 1-4) ============
-- Maps to Users: 8 Henry, 9 Ivy, 10 Jack, 11 Kara
INSERT INTO Seller (UserID, StoreName, BusinessEmail, SellerRating) VALUES
(8,  'TadGadgets', 'support@tadgadgets.com', 4.70),
(9,  'GreenHome',  'hello@greenhome.com',    4.50),
(10, 'BookNook',   'orders@booknook.com',    4.80),
(11, 'FitGear',    'team@fitgear.com',       4.30);

-- ============ CATEGORIES (CategoryID 1-5) ============
INSERT INTO Category (CategoryName, Description) VALUES
('Electronics',       'Phones, audio, chargers and gadgets'),
('Home & Kitchen',    'Kitchenware and household items'),
('Books',             'Physical books across all genres'),
('Sports & Outdoors', 'Fitness and outdoor equipment'),
('Toys & Games',      'Toys, games and puzzles');

-- ============ PRODUCTS (ProductID 1-13) ============
-- (SellerID, CategoryID, Name, Description, Price, IsActive)
INSERT INTO Product (SellerID, CategoryID, ProductName, Description, Price, IsActive) VALUES
(1, 1, 'Wireless Earbuds',     'Bluetooth 5.3 noise-cancelling earbuds', 79.99,  1),
(1, 1, 'Smart Watch',          'Fitness tracking smart watch',           149.99, 1),
(1, 1, 'USB-C Charger',        '65W fast charging adapter',              19.99,  1),
(2, 2, 'Ceramic Knife Set',    '5-piece ceramic kitchen knife set',      39.99,  1),
(2, 2, 'Coffee Maker',         '12-cup programmable coffee maker',       59.99,  1),
(2, 2, 'Bamboo Cutting Board', 'Large eco-friendly cutting board',       24.99,  1),
(3, 3, 'SQL Fundamentals',     'Beginner guide to relational databases', 34.99,  1),
(3, 3, 'Mystery Novel',        'Best-selling crime mystery novel',       14.99,  1),
(4, 4, 'Yoga Mat',             'Non-slip 6mm exercise mat',              29.99,  1),
(4, 4, 'Dumbbell Set',         'Adjustable 40lb dumbbell set',           89.99,  1),
(4, 4, 'Water Bottle',         'Insulated 32oz stainless steel bottle',  12.99,  1),
(2, 5, 'Building Blocks',      '500-piece creative building block set',  44.99,  1),
(2, 2, 'Desk Lamp',            'LED adjustable desk lamp',               22.99,  1);

-- ============ INVENTORY (one row per product) ============
-- Some products have low stock (<10) or zero stock.
INSERT INTO Inventory (ProductID, QuantityAvailable, LastUpdated) VALUES
(1,  120, '2026-05-20 12:00:00'),
(2,  45,  '2026-05-18 12:00:00'),
(3,  8,   '2026-05-21 12:00:00'),   -- low stock
(4,  60,  '2026-05-15 12:00:00'),
(5,  30,  '2026-05-19 12:00:00'),
(6,  5,   '2026-05-22 12:00:00'),   -- low stock
(7,  75,  '2026-05-17 12:00:00'),
(8,  200, '2026-05-16 12:00:00'),
(9,  90,  '2026-05-20 12:00:00'),
(10, 15,  '2026-05-18 12:00:00'),
(11, 0,   '2026-05-23 12:00:00'),   -- out of stock
(12, 25,  '2026-05-21 12:00:00'),
(13, 40,  '2026-05-12 12:00:00');

-- ============ ORDERS (OrderID 1-20) ============
-- Spread Nov 2025 - May 2026. TotalAmount = sum of the order's line totals.
-- Frank (Buyer 6) last orders Dec 2025; Grace (Buyer 7) last orders Nov 2025
-- => both are "lapsed" relative to today (2026-05-29).
INSERT INTO Orders (BuyerID, OrderDate, OrderStatus, TotalAmount) VALUES
(1, '2025-11-10 10:00:00', 'Delivered',  119.97),  -- 1  Alice
(6, '2025-11-15 11:00:00', 'Delivered',  64.97),   -- 2  Frank
(7, '2025-11-20 12:00:00', 'Delivered',  84.98),   -- 3  Grace
(2, '2025-12-02 09:30:00', 'Delivered',  229.98),  -- 4  Bob
(6, '2025-12-18 14:00:00', 'Delivered',  49.98),   -- 5  Frank (last)
(3, '2026-01-05 16:00:00', 'Delivered',  55.97),   -- 6  Carla
(1, '2026-01-22 10:30:00', 'Delivered',  99.98),   -- 7  Alice
(4, '2026-02-03 13:00:00', 'Delivered',  119.98),  -- 8  David
(2, '2026-02-14 11:15:00', 'Delivered',  159.98),  -- 9  Bob
(8, '2026-02-25 15:45:00', 'Delivered',  59.98),   -- 10 Liam
(3, '2026-03-08 10:00:00', 'Delivered',  42.98),   -- 11 Carla
(1, '2026-03-19 12:30:00', 'Delivered',  119.97),  -- 12 Alice
(5, '2026-03-28 09:00:00', 'Delivered',  99.98),   -- 13 Emma
(4, '2026-04-06 14:30:00', 'Delivered',  119.98),  -- 14 David
(2, '2026-04-17 11:00:00', 'Shipped',    229.98),  -- 15 Bob
(1, '2026-04-29 16:20:00', 'Delivered',  99.98),   -- 16 Alice
(5, '2026-05-08 10:10:00', 'Shipped',    34.99),   -- 17 Emma
(3, '2026-05-15 13:40:00', 'Processing', 38.97),   -- 18 Carla
(8, '2026-05-20 12:00:00', 'Processing', 44.99),   -- 19 Liam
(4, '2026-05-25 15:00:00', 'Processing', 29.99);   -- 20 David

-- ============ ORDER ITEMS ============
-- (OrderID, ProductID, Quantity, UnitPrice, LineTotal)  LineTotal = Quantity * UnitPrice
INSERT INTO OrderItem (OrderID, ProductID, Quantity, UnitPrice, LineTotal) VALUES
(1,  1, 1, 79.99,  79.99), (1,  3, 2, 19.99, 39.98),
(2,  7, 1, 34.99,  34.99), (2,  8, 2, 14.99, 29.98),
(3,  5, 1, 59.99,  59.99), (3,  6, 1, 24.99, 24.99),
(4,  2, 1, 149.99, 149.99),(4,  1, 1, 79.99, 79.99),
(5,  8, 1, 14.99,  14.99), (5,  7, 1, 34.99, 34.99),
(6,  9, 1, 29.99,  29.99), (6, 11, 2, 12.99, 25.98),
(7,  1, 1, 79.99,  79.99), (7,  3, 1, 19.99, 19.99),
(8, 10, 1, 89.99,  89.99), (8,  9, 1, 29.99, 29.99),
(9,  1, 2, 79.99,  159.98),
(10,12, 1, 44.99,  44.99), (10, 8, 1, 14.99, 14.99),
(11, 9, 1, 29.99,  29.99), (11,11, 1, 12.99, 12.99),
(12, 3, 2, 19.99,  39.98), (12, 1, 1, 79.99, 79.99),
(13, 4, 1, 39.99,  39.99), (13, 5, 1, 59.99, 59.99),
(14, 9, 1, 29.99,  29.99), (14,10, 1, 89.99, 89.99),
(15, 1, 1, 79.99,  79.99), (15, 2, 1, 149.99,149.99),
(16, 1, 1, 79.99,  79.99), (16, 3, 1, 19.99, 19.99),
(17, 7, 1, 34.99,  34.99),
(18,11, 3, 12.99,  38.97),
(19,12, 1, 44.99,  44.99),
(20, 9, 1, 29.99,  29.99);

-- ============ PAYMENTS ============
-- One payment per completed order (Orders 1-17).
-- Orders 18-20 are still "Processing" and have no payment yet,
-- which keeps the 1:1 Order<->Payment relationship optional.
INSERT INTO Payment (OrderID, PaymentDate, PaymentMethod, PaymentStatus, AmountPaid) VALUES
(1,  '2025-11-10 10:05:00', 'Credit Card', 'Completed', 119.97),
(2,  '2025-11-15 11:05:00', 'PayPal',      'Completed', 64.97),
(3,  '2025-11-20 12:05:00', 'Credit Card', 'Completed', 84.98),
(4,  '2025-12-02 09:35:00', 'Debit Card',  'Completed', 229.98),
(5,  '2025-12-18 14:05:00', 'PayPal',      'Completed', 49.98),
(6,  '2026-01-05 16:05:00', 'Credit Card', 'Completed', 55.97),
(7,  '2026-01-22 10:35:00', 'Credit Card', 'Completed', 99.98),
(8,  '2026-02-03 13:05:00', 'Debit Card',  'Completed', 119.98),
(9,  '2026-02-14 11:20:00', 'Credit Card', 'Completed', 159.98),
(10, '2026-02-25 15:50:00', 'PayPal',      'Completed', 59.98),
(11, '2026-03-08 10:05:00', 'Credit Card', 'Completed', 42.98),
(12, '2026-03-19 12:35:00', 'Credit Card', 'Completed', 119.97),
(13, '2026-03-28 09:05:00', 'Debit Card',  'Completed', 99.98),
(14, '2026-04-06 14:35:00', 'PayPal',      'Completed', 119.98),
(15, '2026-04-17 11:05:00', 'Credit Card', 'Completed', 229.98),
(16, '2026-04-29 16:25:00', 'Credit Card', 'Completed', 99.98),
(17, '2026-05-08 10:15:00', 'Debit Card',  'Completed', 34.99);

-- ============ REVIEWS ============
-- (BuyerID, ProductID, Rating, ReviewText, ReviewDate)
INSERT INTO Review (BuyerID, ProductID, Rating, ReviewText, ReviewDate) VALUES
(1, 1, 5, 'Amazing sound quality and battery life.', '2025-11-20 09:00:00'),
(1, 3, 4, 'Charges fast, slightly bulky.',           '2026-01-25 09:00:00'),
(6, 7, 5, 'Best intro to SQL I have read.',          '2025-12-20 09:00:00'),
(6, 8, 3, 'Decent plot, predictable ending.',        '2025-11-25 09:00:00'),
(7, 5, 4, 'Makes great coffee every morning.',       '2025-11-28 09:00:00'),
(2, 2, 5, 'Tracks my workouts perfectly.',           '2025-12-10 09:00:00'),
(3, 9, 4, 'Good grip, comfortable thickness.',       '2026-01-12 09:00:00'),
(4, 10, 5, 'Solid build, great value.',              '2026-02-10 09:00:00'),
(5, 4, 4, 'Sharp knives, nice handles.',             '2026-04-02 09:00:00'),
(8, 12, 5, 'My kids love building with these.',      '2026-03-01 09:00:00');
