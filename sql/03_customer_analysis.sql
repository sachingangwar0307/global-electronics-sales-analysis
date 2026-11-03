-- ============================================================
-- GLOBAL ELECTRONICS SALES ANALYSIS
-- Phase 3: Customer Analytics
-- Queries: 20-26
-- Database: global_elecdb
-- Tool: MySQL
-- ============================================================

-- ===========================================
-- 19 Top 10 Customers by Revenue:
-- ===========================================

SELECT 
    c.customer_key,
    c.name,
    c.country,
    COUNT(DISTINCT s.order_number) AS total_orders,
    SUM(quantity) AS unit_sold,
    ROUND(SUM(s.quantity * p.unit_price_new)) AS total_revenue
FROM
    fact_sales AS s
        JOIN
    dim_customers AS c ON c.customer_key = s.customer_key
        JOIN
    dim_product AS p ON p.product_key = s.product_key
GROUP BY c.customer_key , c.name , c.country
ORDER BY total_revenue DESC
LIMIT 10;

-- ===========================================================
-- 20 — Customer Purchase Frequency
-- ===========================================================

SELECT 
    total_orders, COUNT(*) AS number_of_customers
FROM
    (SELECT 
        customer_key, COUNT(DISTINCT order_number) AS total_orders
    FROM
        fact_sales
    GROUP BY customer_key) AS customer_order
GROUP BY total_orders
ORDER BY total_orders;

-- ===============================================================
-- 21 Average Customer Spend
-- ==============================================================

SELECT 
    ROUND(AVG(customer_revenue), 1) AS avg_customer_spent
FROM
    (SELECT 
        customer_key,
            SUM(s.quantity * p.unit_price_new) AS customer_revenue
    FROM
        fact_sales AS s
    JOIN dim_product AS p ON p.product_key = s.product_key
    GROUP BY s.customer_key) AS customer_sales;
    
-- ======================================================================
-- 22 One-Time vs Repeat Customers
-- ======================================================================

SELECT 
    CASE
        WHEN total_order = 1 THEN 'one time customer'
        ELSE 'repeat customer'
    END AS customer_type,
    COUNT(*) AS number_of_customers
FROM
    (SELECT 
        customer_key, COUNT(DISTINCT order_number) AS total_order
    FROM
        fact_sales
    GROUP BY customer_key) AS customer_number
GROUP BY customer_type
ORDER BY number_of_customers DESC;

-- ====================================================================
-- 23 Customer Segmentation
-- ====================================================================

SELECT 
    customer_key,
    name,
    country,
    CASE
        WHEN total_revenue >= 30000 THEN 'High value'
        WHEN total_revenue >= 15000 THEN 'Medium value'
        WHEN total_revenue >= 50000 THEN 'low value'
        ELSE 'Very low'
    END AS customer_segmentes
FROM
    (SELECT 
        c.customer_key,
            c.name,
            c.country,
            ROUND(SUM(s.quantity * p.unit_price_new), 2) AS total_revenue
    FROM
        fact_sales AS s
    JOIN dim_customers AS c ON c.customer_key = s.customer_key
    JOIN dim_product AS p ON p.product_key = s.product_key
    GROUP BY customer_key , name , country) AS customer_sales
ORDER BY total_revenue DESC;

-- =====================================================
-- 24 Customer Sales by Country
-- =====================================================

SELECT 
    c.country,
    COUNT(DISTINCT c.customer_key) AS total_customer,
    COUNT(DISTINCT s.order_number) AS total_order,
    ROUND(SUM(s.quantity * unit_price_new)) AS total_revenue,
    SUM(s.quantity) AS unit_sold
FROM
    fact_sales AS s
        JOIN
    dim_customers AS c ON c.customer_key = s.customer_key
        JOIN
    dim_product AS p ON p.product_key = s.product_key
GROUP BY c.country
ORDER BY total_revenue DESC;

-- =================================================
-- 25 Customer Profitability
-- =================================================
SELECT 
    c.customer_key,
    c.name,
    c.country,
    ROUND(SUM(s.quantity * (p.unit_price_new - p.unit_cost_new)),
            2) AS total_profit,
    ROUND(SUM(s.quantity * p.unit_price_new), 2) AS total_revenue,
    ROUND((SUM(s.quantity * (p.unit_price_new - p.unit_cost_new)) / SUM(s.quantity * p.unit_price_new)) * 100,
            2) AS profit_margin_pct
FROM
    fact_sales AS s
        JOIN
    dim_customers AS c ON c.customer_key = s.customer_key
        JOIN
    dim_product AS p ON p.product_key = s.product_key
GROUP BY c.customer_key , c.name , c.country
ORDER BY total_profit DESC
LIMIT 10;

-- ==================================================
-- 26 Customer Revenue Concentration
-- ==================================================

WITH customer_sales AS (
    SELECT
        s.customer_key,
        SUM(s.quantity * p.unit_price_new) AS revenue
    FROM fact_sales AS s
    JOIN dim_product AS p
        ON p.product_key = s.product_key
    GROUP BY s.customer_key
),
ranked_customers AS (
    SELECT
        customer_key,
        revenue,
        ROW_NUMBER() OVER (
            ORDER BY revenue DESC
        ) AS customer_rank
    FROM customer_sales
)
SELECT
    ROUND(
        SUM(
            CASE
                WHEN customer_rank <= 10
                THEN revenue
                ELSE 0
            END
        ),
        2
    ) AS top_10_revenue,
ROUND(
        SUM(revenue),
        2
    ) AS total_revenue,

    ROUND(
        SUM(
            CASE
                WHEN customer_rank <= 10
                THEN revenue
                ELSE 0
            END
        )
        / SUM(revenue) * 100,
        2
    ) AS top_10_revenue_contribution_pct

FROM ranked_customers;



















