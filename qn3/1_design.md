## Section3: System Design

### Design 1
We will be referencing the database from Section2 in this design.. This database will be used by several teams within the company to track the orders of members. You are required to implement a strategy for accessing this database based on the various teams' needs. These teams include:
- Logistics: 
    - Get the sales details (in particular the weight of the total items bought)
    - Update the table for completed transactions
- Analytics:
    - Perform analysis on the sales and membership status
    - Should not be able to perform updates on any tables
- Sales:
    - Update databse with new items
    - Remove old items from database

### Database Architecture
This section will cover some of the design considerations when building out the database architecture.

1. SQL vs NoSQL
    - SQL database will likely offer a better choice here
    - `Structured Data`: For the purpose of the ecommerce use case where the data structure is generally consistent, the SQL approach offers well-defined data structures for defining the data relationships and integrity.
    - `ACID Transactions`: Since the e-commerce business is likely to have a heavy real-time operatonal component, SQL databases offer better consistency and reliability, which is crucial for tracking and serving orders
    - `Data Joins`: Given that different teams have different needs, being able to join multiple tables to surface the relevant information would be useful for the rest of the organisation
    - `Scale`: NoSQL generally scales better than SQL due to it's flexibility and design for horizontal scaling. Depending on the expected traffic, this could be an important factor. That being said, based on the constraints in question 2, it does not seem like this would be a hard requirement for the moment. To improve performance, there are a number of methods we can consider, for example, data archival of old data or index / partitioning of data.

2. User Permissioning
    - For the use cases listed above, it seems like the teams will require the following permissions. While these permissions are retrictive, we can use stored procedures to improve the accuracy of updates and reduce the impact of potential human error.
    - Logistics: Universal read permissions, with write permissions for the `transactions` table. Specifically, only the `UPDATE` write permission is needed. When transactions are completed, users can updated the `completed` value for the given transaction, to show that it has been fulfilled.
    - Analytics: Universal read permissions only.
    - Sales: `UPDATE` write permission for the `inventory` table. In general it's not good practice to hard delete data (e.g. when removing items from the database), so we could add a column `deleted` with a boolean flag that gets updated so that users will know if the item is still available or not.