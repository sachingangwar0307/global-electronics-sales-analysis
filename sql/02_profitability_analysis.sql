-- ============================================================
-- GLOBAL ELECTRONICS SALES ANALYSIS
-- Phase 2: Profitability Analysis
-- Queries: 11-18
-- Database: global_elecdb
-- Tool: MySQL
-- ============================================================

-- ====================================================
-- 11 Total Cost how much the company spent on the products sold
-- ====================================================

SELECT 
    SUM(s.quantity * p.unit_cost_new) AS total_cost
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key;
    
-- =====================================================
-- 12 TOTAL PROFIT 
-- =====================================================

SELECT 
    SUM(s.quantity * p.unit_price_new) - SUM(s.quantity * p.unit_cost_new)
             as total_profit
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key;
    
-- =======================================================
-- 13 Profit Margin %
-- =======================================================
SELECT 
    ROUND(((SUM(s.quantity * p.unit_price_new) - SUM(s.quantity * p.unit_cost_new)) / SUM(s.quantity * p.unit_price_new)) * 100,
            2) AS Profit_Margin_pct
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key;

-- =======================================================
-- 14 Profit by Category
-- =======================================================

SELECT 
    p.category,
    ROUND(SUM(s.quantity * p.unit_price_new), 2) AS total_sales,
    SUM(s.quantity * p.unit_cost_new) AS total_cost,
    SUM(s.quantity * p.unit_price_new) - SUM(s.quantity * p.unit_cost_new) AS total_profit,
    ROUND(((SUM(s.quantity * p.unit_price_new) - SUM(s.quantity * p.unit_cost_new)) / SUM(s.quantity * p.unit_price_new)) * 100,
            2) AS Profit_Margin_pct
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key
GROUP BY p.category
ORDER BY total_profit DESC;

-- ==================================================================
-- 15 Profit by Country
-- ==================================================================

SELECT 
    c.country,
    ROUND(SUM(s.quantity * p.unit_price_new), 2) AS total_sales,
    SUM(s.quantity * p.unit_cost_new) AS total_cost,
    SUM(s.quantity * p.unit_price_new) - SUM(s.quantity * p.unit_cost_new) AS total_profit,
    ROUND(((SUM(s.quantity * p.unit_price_new) - SUM(s.quantity * p.unit_cost_new)) / SUM(s.quantity * p.unit_price_new)) * 100,
            2) AS Profit_Margin_pct
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key
        JOIN
    dim_customers AS c ON c.customer_key = s.customer_key
GROUP BY c.country
ORDER BY total_profit DESC;

-- ===================================================================
-- 16 Top 10 Most Profitable Products
-- ===================================================================

SELECT 
    p.product_key,
    p.product_name,
    brand,
    SUM(s.quantity * p.unit_price_new) - SUM(s.quantity * p.unit_cost_new) AS total_profit
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key
GROUP BY p.product_key , product_name , brand
ORDER BY total_profit DESC
LIMIT 10;

-- ===================================================================
-- 17 Bottom 10 Least Profitable Products
-- ===================================================================

SELECT 
    p.product_key,
    p.product_name,
    brand,
    SUM(s.quantity * p.unit_price_new) - SUM(s.quantity * p.unit_cost_new) AS total_profit,
    sum(s.quantity) as units_sold
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key
GROUP BY p.product_key , product_name , brand
ORDER BY total_profit asc
LIMIT 10;

-- ========================================================
-- 18 Sales vs Profit
-- ========================================================

SELECT 
    p.category,
    ROUND(SUM(s.quantity * p.unit_price_new), 2) AS total_sales,
    SUM(s.quantity * p.unit_price_new) - SUM(s.quantity * p.unit_cost_new) AS total_profit
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key
GROUP BY p.category
ORDER BY total_profit DESC;










