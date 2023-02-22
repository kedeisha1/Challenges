-- Advanced SQL for Data Analysts

------ Window functions ------

-- 1. Select the order_id, product_id, quantity, and maximum quantity across all products bought.
SELECT
	order_id,
	product_id,
	quantity,
	MAX(quantity) OVER() AS max_quantity
FROM 
	northwind.order_details;
	

-- 2. For all available products, show the ids, unit price, and average price across 
-- all available products.
SELECT 
  product_id,
  unit_price,
  AVG(unit_price) OVER() AS average_unit_price
FROM northwind.products
WHERE discontinued = 1 ;



-- 3. We're going to divide the products into 5 price groups and show the id, name, category, unit price, 
--and price group.

-- (1) – very cheap
-- (2) – cheap
-- (3) – neither cheap nor expensive
-- (4) – expensive
-- (5) – very expensive

SELECT
  products.product_id,
  products.product_name,
  categories.category_name,
  products.unit_price,
  NTILE(5) OVER(ORDER BY products.unit_price) AS price_group
FROM northwind.products
JOIN northwind.categories
  ON products.category_id = categories.category_id;
  




------- Subqueries & Common Table Expressions -------

--1. Select the products that have a unit price higher than the average unit price 
-- of all products
SELECT DISTINCT 
	product_name, 
	unit_price
FROM
	northwind.products
WHERE
	unit_price > 
		(SELECT AVG(unit_price) 
		 FROM northwind.products)
ORDER BY
	unit_price;


-- 2. Show customers who have never made an order
SELECT 
	customer_id
FROM 
	northwind.customers
WHERE NOT EXISTS
(
	Select customer_id
	FROM northwind.orders
	WHERE orders.customer_id = customers.customer_id
);


-- 3. Group customers based on how much they ordered in the year 1996.
-- Low: 0 - 1k 
-- Medium: 1k - 5k
-- High: 5k - 10k
-- Very High: 10k+

WITH orders_1996 as 
(
SELECT
	customers.customer_id,
	customers.company_name,
	SUM(quantity * unit_price) AS total_order_amount
FROM northwind.customers
INNER JOIN northwind.orders
USING (customer_id)
INNER JOIN northwind.order_details
ON orders.order_id = order_details.order_id
WHERE
	order_date >= '19960101' AND order_date < '19970101'
GROUP BY
	customers.customer_id,
	customers.company_name
)


SELECT
	customer_id,
	company_name,
	total_order_amount,
CASE
	WHEN total_order_amount >= 0 and total_order_amount < 1000 then 'Low'
	WHEN total_order_amount >= 1000 and total_order_amount < 5000 then 'Medium'
	WHEN total_order_amount >= 5000 and total_order_amount <10000 then 'High'
	WHEN total_order_amount >= 10000 then 'Very High'
	END customer_group
FROM orders_1996




----- Date Time Manipulation -----
SELECT
	order_id,
	order_date,
	EXTRACT(YEAR FROM order_date) AS year,
	EXTRACT(DAY FROM order_date) AS day,
	EXTRACT(MONTH FROM order_date) AS month
FROM 
	northwind.orders






