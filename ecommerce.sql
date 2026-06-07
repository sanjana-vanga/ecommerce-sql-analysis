CREATE TABLE ecommerce_sales (
    order_id INT,
    customer_id INT,
    order_date DATE,
    product_category VARCHAR(50),
    quantity INT,
    unit_price NUMERIC(10,2),
    total_amount NUMERIC(10,2)
);
select * from ecommerce_sales;

--Phase 2:Data Understanding--
--Total Rows--
SELECT COUNT(*)
FROM ecommerce_sales;

--Distinct Customers--
SELECT COUNT(DISTINCT customer_id)
FROM ecommerce_sales;

--Distinct Categories--
SELECT DISTINCT product_category
FROM ecommerce_sales;

--Date Range--
SELECT
MIN(order_date) AS start_date,
MAX(order_date) AS end_date
FROM ecommerce_sales;


--Phase 3: Data Cleaning--
--Null Check--
SELECT *
FROM ecommerce_sales
WHERE order_id IS NULL
OR customer_id IS NULL
OR order_date IS NULL
OR product_category IS NULL
OR quantity IS NULL
OR unit_price IS NULL
OR total_amount IS NULL;

--Duplicate Orders--
SELECT
order_id,
COUNT(*)
FROM ecommerce_sales
GROUP BY order_id
HAVING COUNT(*) > 1;

--Verify Amount Calculation--
SELECT *
FROM ecommerce_sales
WHERE total_amount <> quantity * unit_price;


--Phase 4: Basic KPI Analysis--
--Total Revenue--
SELECT ROUND(SUM(total_amount),2)
AS total_revenue
FROM ecommerce_sales;

--Total Orders--
SELECT COUNT(*)
AS total_orders
FROM ecommerce_sales;

--Average Order Value--
SELECT ROUND(AVG(total_amount),2)
AS avg_order_value
FROM ecommerce_sales;

--Highest Order Value--
SELECT MAX(total_amount)
FROM ecommerce_sales;

--Lowest Order Value--
SELECT MIN(total_amount)
FROM ecommerce_sales;


--Phase 5: Category Analysis---
--Revenue by Category--
SELECT
product_category,
ROUND(SUM(total_amount),2) revenue
FROM ecommerce_sales
GROUP BY product_category
ORDER BY revenue DESC;

--Orders by Category--
SELECT
product_category,
COUNT(*) orders
FROM ecommerce_sales
GROUP BY product_category
ORDER BY orders DESC;

--Average Order Value by Category--
SELECT
product_category,
ROUND(AVG(total_amount),2) avg_order_value
FROM ecommerce_sales
GROUP BY product_category
ORDER BY avg_order_value DESC;

--Revenue Contribution %--
SELECT
product_category,
ROUND(
100.0 * SUM(total_amount) /
(SUM(SUM(total_amount)) OVER()),
2
) revenue_percentage
FROM ecommerce_sales
GROUP BY product_category;


--Phase 6: Customer Analysis---
--Top 10 Customers--
SELECT
customer_id,
SUM(total_amount) revenue
FROM ecommerce_sales
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;

--Customers with Multiple Orders--
SELECT
customer_id,
COUNT(order_id) orders_count
FROM ecommerce_sales
GROUP BY customer_id
HAVING COUNT(order_id) > 1
ORDER BY orders_count DESC;

--Customer Lifetime Value--
SELECT
customer_id,
SUM(total_amount) lifetime_value
FROM ecommerce_sales
GROUP BY customer_id
ORDER BY lifetime_value DESC;

--Average Customer Spend--
SELECT
ROUND(
AVG(customer_total),2
)
FROM
(
SELECT
customer_id,
SUM(total_amount) customer_total
FROM ecommerce_sales
GROUP BY customer_id
) t;


--Phase 7: Time Series Analysis--
--Monthly Revenue--
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(total_amount) AS revenue
FROM ecommerce_sales
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

--Monthly Orders--
SELECT
DATE_TRUNC('month',order_date) AS month,
COUNT(*) orders
FROM ecommerce_sales
GROUP BY month
ORDER BY month;

--Monthly Quantity Sold--
SELECT
DATE_TRUNC('month',order_date) AS month,
SUM(quantity) quantity_sold
FROM ecommerce_sales
GROUP BY month
ORDER BY month;


--Phase 8: Trend Analysis--
--Running Revenue--
SELECT
order_date,
SUM(total_amount) daily_sales,

SUM(
SUM(total_amount)
) OVER(
ORDER BY order_date
) cumulative_revenue

FROM ecommerce_sales

GROUP BY order_date
ORDER BY order_date;

--7-Day Moving Average--
SELECT
order_date,

SUM(total_amount) daily_sales,

ROUND(
AVG(
SUM(total_amount)
)
OVER(
ORDER BY order_date
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
),2
) moving_avg

FROM ecommerce_sales

GROUP BY order_date;


--Phase 9: Window Functions--
--Customer Revenue Ranking--
SELECT
customer_id,
SUM(total_amount) revenue,

RANK() OVER(
ORDER BY SUM(total_amount) DESC
) rank

FROM ecommerce_sales

GROUP BY customer_id;

--Dense Rank--
SELECT
customer_id,
SUM(total_amount),

DENSE_RANK() OVER(
ORDER BY SUM(total_amount) DESC
)

FROM ecommerce_sales

GROUP BY customer_id;

--Top 5 Customers--
WITH customer_rank AS
(
SELECT
customer_id,
SUM(total_amount) revenue,

RANK() OVER(
ORDER BY SUM(total_amount) DESC
) rank

FROM ecommerce_sales

GROUP BY customer_id
)

SELECT *
FROM customer_rank
WHERE rank <= 5;


--Phase 10: Customer Segmentation--
SELECT
customer_id,

SUM(total_amount) revenue,

CASE

WHEN SUM(total_amount) >= 5000
THEN 'Platinum'

WHEN SUM(total_amount) >= 3000
THEN 'Gold'

WHEN SUM(total_amount) >= 1500
THEN 'Silver'

ELSE 'Bronze'

END customer_segment

FROM ecommerce_sales

GROUP BY customer_id;



--Phase 11: Advanced CTE Analysis--
--Customers Above Average Revenue--
WITH customer_revenue AS
(
SELECT
customer_id,
SUM(total_amount) revenue
FROM ecommerce_sales
GROUP BY customer_id
)

SELECT *
FROM customer_revenue

WHERE revenue >
(
SELECT AVG(revenue)
FROM customer_revenue
);

--Top Category Each Month--
WITH monthly_category AS
(
SELECT

DATE_TRUNC('month',order_date) AS month,

product_category,

SUM(total_amount) revenue,

RANK() OVER(
PARTITION BY DATE_TRUNC('month',order_date)
ORDER BY SUM(total_amount) DESC
) rank

FROM ecommerce_sales

GROUP BY month, product_category
)

SELECT *
FROM monthly_category
WHERE rank = 1;


--Phase 12: Business Insights Queries--
--Which Day Generates Maximum Revenue?--
SELECT
order_date,
SUM(total_amount) revenue
FROM ecommerce_sales
GROUP BY order_date
ORDER BY revenue DESC
LIMIT 1;

--Highest Revenue Month--
SELECT
DATE_TRUNC('month',order_date),
SUM(total_amount) revenue
FROM ecommerce_sales
GROUP BY 1
ORDER BY revenue DESC
LIMIT 1;

--Most Purchased Category--
SELECT
product_category,
SUM(quantity) quantity
FROM ecommerce_sales
GROUP BY product_category
ORDER BY quantity DESC
LIMIT 1;

--Revenue per Customer--
SELECT
ROUND(
SUM(total_amount) /
COUNT(DISTINCT customer_id),
2
) revenue_per_customer
FROM ecommerce_sales;


--Phase 13: advanced-Level SQL Queries--
--Top 20% Customers by Revenue--
WITH ranked_customers AS
(
SELECT
customer_id,
SUM(total_amount) revenue,

NTILE(5) OVER(
ORDER BY SUM(total_amount) DESC
) bucket

FROM ecommerce_sales
GROUP BY customer_id
)

SELECT *
FROM ranked_customers
WHERE bucket = 1;

--Revenue Difference from Previous Day--
SELECT
order_date,

SUM(total_amount) revenue,

LAG(
SUM(total_amount)
)
OVER(
ORDER BY order_date
) previous_day,

SUM(total_amount) -
LAG(
SUM(total_amount)
)
OVER(
ORDER BY order_date
) difference

FROM ecommerce_sales

GROUP BY order_date;

--Growth Rate %--
SELECT
order_date,

SUM(total_amount) revenue,

ROUND(
(
SUM(total_amount) -
LAG(SUM(total_amount))
OVER(ORDER BY order_date)
)
/
LAG(SUM(total_amount))
OVER(ORDER BY order_date)
*100,2
)
AS growth_rate

FROM ecommerce_sales

GROUP BY order_date;