# Design Notes

## Strong Entities
- User
- Product
- Category
- Order
- Payment

## Weak Entities
- Buyer
- Seller
- Review
- Inventory
- Order_Item

## Supertype/Subtype
User is the supertype.
Buyer and Seller are subtypes.

## Normalization
The database separates products, orders, inventory, and reviews into separate entities to reduce redundancy and maintain normalization.
