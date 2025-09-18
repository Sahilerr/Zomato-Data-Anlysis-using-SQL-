--- EDA
truncate table orders cascade;

select * from customers;
select* from restaurants;
select * from orders;
select * from delivery;
select * from riders;

delete from delivery where delivery_id isnull or
order_id isnull or
delivery_status isnull or
delivery_time isnull or rider_id isnull ;

delete from riders where 
rider_id isnull or
rider_name isnull or
sign_up isnull ;

-----------------------
--Analysis And Repoprt
-----------------------

--Q1 Write a query to find the top 5 most frequently ordered dishes by customer called "Priya Sharma" in the last 1 year.
--  join cx and orders
--  filter for last 1 year
--  filter arjun mehta'
--  group by cx id, dishes, cnt

SELECT
  c.customer_id,
  c.name,
  o.order_item as dishes,
  COUNT(*) as total_orders
FROM orders o
JOIN customers as c
ON c.customer_id= o.customer_id
WHERE
  o.order_date > CURRENT_DATE - INTERVAL '1 Year'
GROUP BY 1, 2, 3
ORDER BY 1, 4 DESC;


-- SELECT
--   c.customer_id,
--   c.name,
--   o.order_item AS dishes,
--   COUNT(*) AS total_orders
-- FROM orders o
-- JOIN customers c ON c.customer_id = o.customer_id
-- WHERE o.order_date > CURRENT_DATE - INTERVAL '1 year'
-- GROUP BY c.customer_id, c.name, o.order_item
-- order BY 1,4 desc;

-- highest Orders 
SELECT
  c.customer_id,
  c.name,
  COUNT(*) AS total_orders
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC
LIMIT 10;


--Top N Orders of Amit Varma
SELECT 
    o.order_item AS dish,
    COUNT(*) AS total_orders
FROM orders AS o
JOIN customers AS c 
    ON c.customer_id = o.customer_id
WHERE c.name = 'Amit Varma'
 -- AND o.order_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY order_item
ORDER BY total_orders DESC
LIMIT 10;


--Q2 Popular Time Slots
--Question: Identify the time slots during which the most orders are placed. based on 2-hour intervals.
SELECT 
    CONCAT(
        LPAD((FLOOR(EXTRACT(HOUR FROM o.order_time) / 2) * 2)::TEXT, 2, '0'),
        ':00 - ',
        LPAD(((FLOOR(EXTRACT(HOUR FROM o.order_time) / 2) * 2 + 2) % 24)::TEXT, 2, '0'),
        ':00'
    ) AS time_slot,
    COUNT(*) AS total_orders
FROM orders AS o
GROUP BY time_slot
ORDER BY total_orders DESC;

-- most orderes dish in popular dish
SELECT 
    t.time_slot,
    t.dish,
    t.total_orders
FROM (
    SELECT 
        CONCAT(
            LPAD((FLOOR(EXTRACT(HOUR FROM o.order_time::time) / 2) * 2)::TEXT, 2, '0'),
            ':00 - ',
            LPAD(((FLOOR(EXTRACT(HOUR FROM o.order_time::time) / 2) * 2 + 2) % 24)::TEXT, 2, '0'),
            ':00'
        ) AS time_slot,
        o.order_item AS dish,
        COUNT(*) AS total_orders
    FROM orders AS o
    GROUP BY time_slot, dish
) t
ORDER BY total_orders DESC
LIMIT 10;

--SELECT c.customer_name, COUNT(*) AS total_orders
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY  c.customer_id,c.name
ORDER BY total_orders DESC
LIMIT 10;

--Most frequent customers
SELECT c.customer_name, COUNT(*) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC
LIMIT 10;

--Revenue per customer (LTV - Lifetime Value)
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 10;

-----------------------
-- Restaurants insights
-----------------------
--Top restaurants by revenue
SELECT r.restaurant_name, SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 10;

--Which city generates most orders
SELECT r.city, COUNT(*) AS total_orders
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.city
ORDER BY total_orders DESC;


-----------------------
-- Days insights
-----------------------
--Day-of-week analysis → busiest days:
SELECT TO_CHAR(order_date, 'Day') AS day_of_week, COUNT(*) AS total_orders
FROM orders
GROUP BY day_of_week
ORDER BY total_orders DESC;

--Average order value (AOV)
SELECT ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders;

------------------
-- Trend Analysis
------------------
-- Monthly revenue trend
SELECT 
    TO_CHAR(order_date, 'Month YYYY') AS month, 
    SUM(total_amount) AS revenue
FROM orders
GROUP BY month
ORDER BY revenue DESC;

--Top 5 dishes overall
SELECT order_item, COUNT(*) AS total_orders
FROM orders
GROUP BY order_item
ORDER BY total_orders DESC
LIMIT 5;












--Q3 Order Value Analysis
--Find the average order value per customer who has placed more than 750 orders.
--Return customer name, and aov(average order value)
--Q4 


