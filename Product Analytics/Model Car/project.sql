/* Tables and their relationships:
Employees: all employee information
Offices: sales office information (one office links to many employees)

Customers: customer data (many customer links to one employee)
Orders: customers' sales orders (one customer links to many orders)
Payments: customers' payment records (one customer links to one payment)

OrderDetails: sales order line for each sales order (many order details for one order)
Products: a list of scale model cars (many order details for one product)
ProductLines: a list of product line categories (one product line category links to many products)
*/

-- First, display  the number of attributes and number of rows for each table
/* Tables and their relationships:
Employees: all employee information
Offices: sales office information (one office links to many employees)

Customers: customer data (many customer links to one employee)
Orders: customers' sales orders (one customer links to many orders)
Payments: customers' payment records (one customer links to many payments)

OrderDetails: sales order line for each sales order (one order detail for one order)
Products: a list of scale model cars (one order detail for one product)
ProductLines: a list of product line categories (one product line category links to many products)
*/


-- First, display  the number of attributes and number of rows for each Tables
SELECT 'Customers' AS table_name, 
(SELECT COUNT(*)
   FROM pragma_table_info('Customers')) AS number_of_attributes,
COUNT(*) AS number_of_rows
  FROM Customers

UNION ALL 

SELECT 'Products' AS table_name, 
(SELECT COUNT(*)
   FROM pragma_table_info('Products')) AS number_of_attributes,
COUNT(*) AS number_of_rows
  FROM Products 
  
UNION ALL 

SELECT 'ProductLines' AS table_name, 
(SELECT COUNT(*)
   FROM pragma_table_info('ProductLines')) AS number_of_attributes,
COUNT(*) AS number_of_rows
  FROM ProductLines

UNION ALL 

SELECT 'Orders' AS table_name, 
(SELECT COUNT(*)
   FROM pragma_table_info('Orders')) AS number_of_attributes,
 COUNT(*) AS number_of_rows
  FROM Orders
 
UNION ALL 

SELECT 'OrderDetails' AS table_name, 
(SELECT COUNT(*)
   FROM pragma_table_info('OrderDetails')) AS number_of_attributes,
COUNT(*) AS number_of_rows
  FROM OrderDetails
  
UNION ALL 

SELECT 'Payments' AS table_name, 
(SELECT COUNT(*)
   FROM pragma_table_info('Payments')) AS number_of_attributes,
COUNT(*) AS number_of_rows
  FROM Payments

UNION ALL 

SELECT 'Employees' AS table_name, 
(SELECT COUNT(*)
   FROM pragma_table_info('Employees')) AS number_of_attributes,
COUNT(*) AS number_of_rows
  FROM Employees
  
UNION ALL 

SELECT 'Offices' AS table_name, 
(SELECT COUNT(*)
   FROM pragma_table_info('Offices')) AS number_of_attributes,
COUNT(*) AS number_of_rows
  FROM Offices;
  
  --  Problem 1: Which Products Should We Order More of or Less of?
  /* For each product,
   low stock  = SUM(quantityOrdered)/quantityInStock
   product performance = SUM(sales) 
   priority products for restocking are those with high product performance
   that are on the brink of being out of stock
   */
WITH 
lowstock AS(
SELECT productCode, (SELECT ROUND(SUM(od.quantityOrdered)*1.0/p.quantityInStock, 2) 
                       FROM orderdetails od) AS lowStock
  FROM products p
 GROUP BY productCode
 ORDER BY lowStock DESC
 LIMIT 10
)
    
SELECT p.productCode, p.productName, p.productLine, SUM(od.quantityOrdered * od.priceEach) AS sale_perf
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
 WHERE p.productCode IN (SELECT productCode
                         FROM lowstock
                       )                   
 GROUP BY p.productCode
 ORDER BY sale_perf DESC;

/* By the resultant table, we have found that Motorcycles and 
Vintage cars are the priority for restocking. They sell frequently, 
and they are the highest-performance products.

Some reasons for the listed model cars with higher priorities:

1. 1968 Ford Mustang: This is a classic American muscle car, 
highly popular and sought after. Its strong cultural and automotive 
significance, along with a robust market for both original and restored models, 
likely makes it a high priority.

2. 1928 Mercedes-Benz SSK: This car is a rare and historically significant vehicle. 
As a pre-war luxury car, it's highly valued by collectors. Its rarity and the prestige 
associated with the Mercedes-Benz brand make it a likely candidate for high restocking priority.
*/

-- Problem 2:  Match Marketing and Communication Strategies to Customer Behavior
/* Find the VIP customers and those who are less engaged 
VIPs bring in the most profit for the store;
less-engaged customers bring in less profit.
By categorizing the customer type, we could organize some events to drive loyalty for the VIPs 
and launch a campaign for the less engaged. */
WITH 
profit AS (
SELECT o.customerNumber, SUM(od.quantityOrdered * (od.priceEach -
                                                   p.buyPrice))
                                                   AS profitBrought
   FROM products p
    JOIN orderdetails od
         ON p.productCode = od.productCode
     JOIN orders o
         ON od.orderNumber = o.orderNumber
GROUP BY o.customerNumber
)
 
 -- Find the top five least-engaged customers
SELECT c.contactLastName, c.contactFirstName,
       c.city, c.country, pf.profitBrought
  FROM customers c
  JOIN profit pf
    ON c.customerNumber = pf.customerNumber
 ORDER BY pf.profitBrought
 LIMIT 5;
 /* The top five least-engaged customers have a widespread range,
 where the top two least-engaged customers have brought profits 
 under 7000$, and the others have brought profits above 9500$.
 */
 
 -- Problem 3: How Much Can We Spend on Acquiring New Customers?
 -- First, find the number of new customers arriving each month.
 WITH 

payment_with_year_month_table AS (
SELECT *, 
       CAST(SUBSTR(paymentDate, 1,4) AS INTEGER)*100 + CAST(SUBSTR(paymentDate, 6,7) AS INTEGER) AS year_month
  FROM payments p
),

customers_by_month_table AS (
SELECT p1.year_month, COUNT(*) AS number_of_customers, SUM(p1.amount) AS total
  FROM payment_with_year_month_table p1
 GROUP BY p1.year_month
),

new_customers_by_month_table AS (
SELECT p1.year_month, 
       COUNT(*) AS number_of_new_customers,
       SUM(p1.amount) AS new_customer_total,
       (SELECT number_of_customers
          FROM customers_by_month_table c
        WHERE c.year_month = p1.year_month) AS number_of_customers,
       (SELECT total
          FROM customers_by_month_table c
         WHERE c.year_month = p1.year_month) AS total
  FROM payment_with_year_month_table p1
 WHERE p1.customerNumber NOT IN (SELECT customerNumber
                                   FROM payment_with_year_month_table p2
                                  WHERE p2.year_month < p1.year_month)
 GROUP BY p1.year_month
)

SELECT year_month, 
       ROUND(number_of_new_customers*100/number_of_customers,1) AS number_of_new_customers_props,
       ROUND(new_customer_total*100/total,1) AS new_customers_total_props
  FROM new_customers_by_month_table;
 
/*
The number of clients has been decreasing since 2003, and in 2004, 
it reached lowest values.  In 2005, no new customers were recorded 
and thus it become necessary to spend money to acquire new customers.
*/
  -- Second, compute the Customer Lifetime Value (LTV), the average amount of money a customer generates.
WITH 
profit AS (
SELECT o.customerNumber, SUM(od.quantityOrdered * (od.priceEach -
                                                   p.buyPrice))
                                                   AS profitBrought
   FROM products p
    JOIN orderdetails od
         ON p.productCode = od.productCode
     JOIN orders o
         ON od.orderNumber = o.orderNumber
GROUP BY o.customerNumber
)

SELECT AVG(profitBrought) 
  FROM profit;
 -- Suggestion: around ($39039)*0.05 = $1951.95 per new customer spent on marketing.
 


