-- ============================================================
-- GLOBAL ELECTRONICS SALES ANALYSIS
-- SQL Analysis: Sales & Revenue Analytics
-- Queries: 01-10
-- Database: global_elecdb
-- ============================================================

-- =====================================================
-- 1. TOTAL SALES
-- =====================================================

select sum(s.quantity* p.unit_price_new) as total_sales
from fact_sales as s
join dim_product as p 
on p.product_key = s.product_key;

-- ====================================================
-- 2 TOTAL UNIT SOLD 
-- ====================================================

select sum(quantity)as total_unit_sold
from fact_sales;

-- =====================================================
-- 3 TOTAL ORDER
-- =====================================================

select count(distinct order_number) as total_order_count
from fact_sales;

-- ======================================================
--  4 TOTAL CUSTOMER
-- ======================================================

select count(distinct customer_key) as total_customer
from dim_customers;

-- ======================================================
-- 5 AVERAGE ORDER VALUE 
-- ======================================================
select sum(s.quantity* p.unit_price_new) / count(distinct order_number) as avg_order_value
from fact_sales as s
join dim_product as p 
on p.product_key = s.product_key;

-- ===========================================================
-- 6 Create our first KPI summary 
-- ===========================================================

SELECT 
    SUM(s.quantity * p.unit_price_new) AS total_sales,
    SUM(s.quantity) AS total_unit_sold,
    COUNT(DISTINCT s.order_number) AS total_order_count,
    COUNT(DISTINCT s.customer_key) AS total_customer,
    ROUND(SUM(s.quantity * p.unit_price_new) / COUNT(DISTINCT s.order_number),
            2) AS avg_order_value
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key;
    
-- ========================================================================================
-- 7 Monthly Sales Trend 📈
-- ========================================================================================

SELECT 
    YEAR(s.order_date) AS year,
    MONTH(s.order_date) AS month,
    QUARTER(s.order_date) AS quarter,
    SUM(s.quantity * p.unit_price_new) AS total_sales
FROM
    fact_Sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key
GROUP BY year , month , quarter
ORDER BY year , month , quarter;

-- ==================================================================
-- 8 Sales by Country
-- ==================================================================

SELECT 
    c.country,
    SUM(quantity) AS total_qty,
    SUM(s.quantity * p.unit_price_new) AS total_sales
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key
        JOIN
    dim_customers AS c ON c.customer_key = s.customer_key
GROUP BY country
ORDER BY total_sales desc;
 
-- ===============================================================
-- 9 Top 10 Products
-- ===============================================================

SELECT 
    p.product_key,
    p.product_name,
    p.brand,
    ROUND(SUM(s.quantity * p.unit_price_new), 2) AS sales_usd,
    SUM(s.quantity) AS qty_sold
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key
GROUP BY product_key , product_name , brand
ORDER BY sales_usd DESC
LIMIT 10;

-- ===================================================================
-- 10 Sales by Category
-- ===================================================================

SELECT 
    p.category,
    ROUND(SUM(s.quantity * p.unit_price_new), 2) AS sales_usd,
    SUM(s.quantity) AS qty_sold
FROM
    fact_sales AS s
        JOIN
    dim_product AS p ON p.product_key = s.product_key
GROUP BY p.category
ORDER BY sales_usd DESC;

-- ===================================================================
-- BASIC ANALYTICS END
-- ===================================================================






