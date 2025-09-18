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



--Q1 highest Orders 
SELECT
  c.customer_id,
  c.name,
  COUNT(*) AS total_orders
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC
LIMIT 10;


-- Q2 Top N Orders of Amit Varma
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


-- Q3) most orderes dish in popular dish
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


-- Q4 Top Cusomer
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY  c.customer_id,c.name
ORDER BY total_orders DESC
LIMIT 10;


-- Q5 Most frequent customers
SELECT c.customer_name, COUNT(*) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC
LIMIT 10;

-- Q6 Revenue per customer (LTV - Lifetime Value)
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 10;

-----------------------
-- Restaurants insights
-----------------------
-- Q7 Top restaurants by revenue
SELECT r.restaurant_name, SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Q8 Which city generates most orders
SELECT r.city, COUNT(*) AS total_orders
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.city
ORDER BY total_orders DESC;


-----------------------
--  insights
-----------------------

--Q9 Order Value Analysis
--Find the average order value per customer who has placed more than 750 orders.
--Return customer name, and aov(average order value)
SELECT 
    c.name,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_orders DESC;


-- 10 orders without delivery
SELECT
    r.restaurant_name,
    o.order_item,
    o.order_status
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_status IN ('Cancelled','Pending');
SELECT
    r.restaurant_name,
    o.order_item,
    o.order_status
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_status IN ('Delivered');

UPDATE orders
SET order_status = 'Delivered'
WHERE order_item IN ('Vada Pav','Poha','Pizza','Veg Pizza','Burgar', 'Pasta','Chicken 65', 'Chicken Biryani','Momos','Veg Thali','Spring Rolls');


-- 11 most popular dish by city
SELECT
    r.city,
    o.order_item,
    COUNT(*) AS order_count
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.city, o.order_item
HAVING COUNT(*) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM orders o2
        JOIN restaurants r2 ON o2.restaurant_id = r2.restaurant_id
        WHERE r2.city = r.city
        GROUP BY o2.order_item
    ) subquery
)
ORDER BY order_count DESC;


-- Q12 Last Year Revenue Vs This Year Revenue
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year DESC;


-- Q13 Busy Ordering Day
SELECT 
    TO_CHAR(order_date, 'Day') AS weekday,
    COUNT(order_id) AS total_orders
FROM orders
WHERE order_status = 'Delivered'
GROUP BY TO_CHAR(order_date, 'Day'), EXTRACT(DOW FROM order_date)
ORDER BY total_orders DESC
LIMIT 7;


-- Q15 Monthly Revenue Trend
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY total_revenue DESC;

-- Q16 Average Delivery Time by City
SELECT 
    r.city,
    ROUND(AVG(EXTRACT(EPOCH FROM (
        (o.order_date + o.order_time)::timestamp - (o.order_date + d.delivery_time)::timestamp
    )) / 60), 2) AS avg_delivery_minutes
FROM orders o
JOIN delivery d 
    ON o.order_id = d.order_id
JOIN restaurants r 
    ON o.restaurant_id = r.restaurant_id
WHERE d.delivery_status = 'Delivered'
GROUP BY r.city
ORDER BY avg_delivery_minutes;

-- Q17 Quarterly Growth – Revenue Q1 vs Q2 vs Q3 vs Q4
SELECT 
    DATE_PART('year', order_date) AS year,
    DATE_PART('quarter', order_date) AS quarter,
    SUM(total_amount) AS revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY year, quarter
ORDER BY  revenue DESC;


-- Q18 Best-Selling Dishes Across All Restaurants
SELECT o.order_item, COUNT(*) AS total_orders
FROM orders o
GROUP BY o.order_item
ORDER BY total_orders DESC
LIMIT 10;


-- Q19 High-Value Customers (Top Spenders)
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 10;

-- Q20 Yearly Revenue Comparison
SELECT DATE_PART('year', order_date) AS year, SUM(total_amount) AS revenue
FROM orders
GROUP BY year
ORDER BY year DESC;


-- Q21 Daily Order Trends
SELECT order_date, COUNT(*) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY order_date , total_orders DESC;




 





