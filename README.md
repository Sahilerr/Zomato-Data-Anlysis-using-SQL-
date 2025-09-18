Zomato Data Analysis – SQL Project
📌 Project Overview
This project analyzes Zomato-like food delivery data using SQL. The dataset consists of multiple CSV files representing customers, restaurants, orders, delivery details, and riders. After importing the CSVs into a relational database, relationships were created to perform Exploratory Data Analysis (EDA) and generate business insights.

The project covers:

Data cleaning and validation

Understanding customer behavior

Restaurant performance analysis

Delivery and rider efficiency tracking

Revenue and growth trends

[![https://github.com/Sahilerr/Zomato-Data-Anlysis-using-SQL-/blob/main/Screenshot%202025-09-19%20005850.png](4]


📂 Dataset Description
The project uses 5 key tables (imported from CSVs):

customers

customer_id (PK)

name

city

contact

restaurants

restaurant_id (PK)

restaurant_name

city

cuisine

orders

order_id (PK)

customer_id (FK → customers.customer_id)

restaurant_id (FK → restaurants.restaurant_id)

order_item

order_date

order_time

order_status

total_amount

delivery

delivery_id (PK)

order_id (FK → orders.order_id)

rider_id (FK → riders.rider_id)

delivery_time

delivery_status

riders

rider_id (PK)

rider_name

sign_up

🛠️ Data Cleaning & Preparation
Removed null values from delivery and riders tables.

Standardized text fields and applied formatting.

Ensured referential integrity between tables.

Updated pending orders to Delivered (for realistic analysis).

📊 Analysis & SQL Queries
Customer Insights
Top 5 most frequently ordered dishes by specific customers (e.g., Priya Sharma, Amit Varma).

Most frequent customers overall.

Revenue per customer (LTV) – total spend across all orders.

Restaurant Insights
Top restaurants by revenue.

Most orders by city.

Most popular dish ordered in each city.

Order & Delivery Insights
Popular ordering time slots (in 2-hour intervals).

Most ordered dishes per popular time slot.

Cancelled vs Delivered orders.

Average delivery time by city.

Revenue & Growth Insights
Monthly & yearly revenue trends.

Quarterly revenue growth (Q1–Q4 comparison).

High-value customers (top spenders).

Yearly comparison of total revenue.

Daily order trends.

📈 Key Business Insights
Certain customers (e.g., Priya Sharma and Amit Varma) have high order frequency, making them ideal for loyalty programs.

Evening time slots (6–10 PM) show the highest order volumes.

Popular dishes such as Biryani, Pizza, and Momos dominate across multiple cities.

Cities like Mumbai and Delhi NCR generate significantly higher revenue and orders.

Average delivery time varies across cities; optimization opportunities exist in underperforming areas.

Revenue shows consistent year-on-year growth, with clear spikes during festive months.

📑 Key SQL Features Used
Joins across multiple tables (INNER JOIN, LEFT JOIN).

Window functions and aggregates (COUNT, SUM, AVG).

Date functions (EXTRACT, DATE_PART, TO_CHAR).

Subqueries for city/dish-level insights.

Updates and deletions for EDA and data cleaning.

Run the analysis queries to generate insights.
