-- View table
SELECT * 
FROM customer LIMIT 10;

-- Creating reusable view so logic (segmentation by previous purchases) doesn't need to be repeated
CREATE OR REPLACE VIEW customer_segments AS
SELECT 
    customer_id, 
    previous_purchases, 
    purchase_amount, 
    review_rating,
    subscription_status,
    CASE 
        WHEN previous_purchases = 1 THEN 'New'
        WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
        ELSE 'Loyal'
    END AS segment
FROM customer;

-- Total revenue by gender

SELECT gender, SUM(purchase_amount) AS revenue
FROM customer
GROUP by gender;

-- Total revenue by age group

SELECT age_group, SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;

-- Average spend by gender and age (clustered column chart)

SELECT
    age_group,
    gender,
    ROUND(AVG(purchase_amount),2) AS avg_purchase
FROM customer
GROUP BY age_group, gender
ORDER BY age_group;

-- Locations contributing to 80% of total revenue (Pareto analysis)

WITH location_revenue AS (
	SELECT location, SUM(purchase_amount) AS total_revenue, COUNT(customer_id) AS num_customers
    FROM customer
    GROUP BY location
),
location_ranked AS (
	SELECT location, total_revenue, num_customers, 
    SUM(total_revenue) OVER (ORDER BY total_revenue DESC) AS running_total,
    SUM(total_revenue) OVER () AS grand_total
    FROM location_revenue
)
SELECT location, total_revenue, num_customers, ROUND(100 * running_total/grand_total,2) as cumulative_pct,
	CASE 
		WHEN 100* running_total/grand_total <= 80 THEN 'Vital Few' 
        ELSE 'Trivial Many' 
	END as pareto_segment
FROM location_ranked
ORDER BY total_revenue DESC;

-- Categories with most revenue (bar chart/treemap)
SELECT
    category,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY category
ORDER BY total_revenue DESC;

-- Top 5 items with the highest average review rating

SELECT item_purchased, ROUND(AVG(review_rating),2) AS 'Average Product Rating'
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

-- Top 3 most purchased items per category

WITH item_counts AS (
	SELECT category, item_purchased, COUNT(customer_id) AS total_orders,
    ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT item_rank, category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <= 3;

-- Top-selling colors per season

WITH color_season_counts AS (
    SELECT
        season,
        color,
        COUNT(*) AS total_orders,
        RANK() OVER (PARTITION BY season ORDER BY COUNT(*) DESC) AS color_rank
    FROM customer
    GROUP BY season, color
)
SELECT
    season,
    color AS top_color,
    total_orders,
    color_rank
FROM color_season_counts
WHERE color_rank <= 3
ORDER BY season, color_rank;

-- The 5 items which have the highest percentage of discounted purchases

WITH discount_rates AS (
    SELECT 
        item_purchased,
        ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate
    FROM customer
    GROUP BY item_purchased
)
SELECT
    RANK() OVER (ORDER BY discount_rate DESC) AS rank_num,
    item_purchased,
    discount_rate
FROM discount_rates
ORDER BY discount_rate DESC
LIMIT 5;

-- Customers who used a discount but still spent more than the average purchase amount

SELECT customer_id, purchase_amount
FROM customer
WHERE discount_applied = 'Yes' AND purchase_amount >= (SELECT AVG(purchase_amount) FROM customer);

-- Average purchase amounts between Standard and Express Shipping

SELECT shipping_type, ROUND(AVG(purchase_amount),2) AS avg_purchase_amount
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

-- Customer Segments (New, Returning, Loyal) based on their previous purchases

SELECT segment, COUNT(*) AS num_customers
FROM customer_segments
GROUP BY segment;

-- Average review rating across customer loyalty tiers

SELECT segment, COUNT(*) AS num_customers, 
	ROUND(AVG(review_rating), 3) AS avg_rating,
	ROUND(AVG(previous_purchases), 1) AS avg_previous_purchases
FROM customer_segments
GROUP BY segment
ORDER BY avg_previous_purchases;

-- Customer segments by revenue (treemap)

SELECT segment, SUM(purchase_amount) AS revenue
FROM customer_segments
GROUP BY segment;

-- Subscription status among repeat buyers (more than 5 previous purchases)

SELECT subscription_status, COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- Subscriber spend, revenue, and discount

SELECT  subscription_status, COUNT(customer_id) AS total_customers,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    ROUND(SUM(purchase_amount), 2) AS total_revenue,
    SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) AS sum_discounted_purchases,
    ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(customer_id), 2) AS discount_rate_pct
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC;

-- Subscribers prefererance for Standard or Express Shipping

SELECT
    subscription_status,
    shipping_type,
    COUNT(*) AS total_orders
FROM customer
GROUP BY subscription_status, shipping_type;

-- KPI Summary

SELECT
    COUNT(customer_id) AS total_customers,
    ROUND(SUM(purchase_amount), 2) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,
    ROUND(AVG(review_rating), 2) AS avg_review_rating,
    ROUND(AVG(previous_purchases), 1) AS avg_previous_purchases,
    SUM(CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END) AS total_subscribers,
    ROUND(100 * SUM(CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END) / COUNT(customer_id), 2) AS subscription_rate_pct,
    SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) AS total_discounted_orders,
    ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(customer_id), 2) AS discount_rate_pct
FROM customer;