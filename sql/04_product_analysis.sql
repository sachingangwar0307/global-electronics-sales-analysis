-- ============================================================
-- GLOBAL ELECTRONICS SALES ANALYSIS
-- Phase 4: Product Analytics
-- Queries: 27-31
-- Database: global_elecdb
-- Tool: MySQL
-- ============================================================


-- ============================================================
-- Query 27: Top 10 Products by Revenue
-- ============================================================

SELECT
    p.product_key,
    p.product_name,
    p.category,
    SUM(s.quantity) AS units_sold,
    ROUND(
        SUM(s.quantity * p.unit_price_new),
        2
    ) AS total_revenue
FROM fact_sales AS s
JOIN dim_product AS p
    ON p.product_key = s.product_key
GROUP BY
    p.product_key,
    p.product_name,
    p.category
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- Query 28: Top 10 Products by Profit
-- ============================================================

SELECT
    p.product_key,
    p.product_name,
    p.category,

    SUM(s.quantity) AS units_sold,

    ROUND(
        SUM(
            s.quantity *
            (p.unit_price_new - p.unit_cost_new)
        ),
        2
    ) AS total_profit

FROM fact_sales AS s
JOIN dim_product AS p
    ON p.product_key = s.product_key

GROUP BY
    p.product_key,
    p.product_name,
    p.category

ORDER BY total_profit DESC

LIMIT 10;


-- ============================================================
-- Query 29: Bottom 10 Products by Profit
-- ============================================================

SELECT
    p.product_key,
    p.product_name,
    p.category,

    ROUND(
        SUM(
            s.quantity *
            (p.unit_price_new - p.unit_cost_new)
        ),
        2
    ) AS total_profit

FROM fact_sales AS s
JOIN dim_product AS p
    ON p.product_key = s.product_key

GROUP BY
    p.product_key,
    p.product_name,
    p.category

ORDER BY total_profit ASC

LIMIT 10;


-- ============================================================
-- Query 30: Product Profit Margin Analysis
-- ============================================================

SELECT
    p.product_key,
    p.product_name,
    p.category,

    ROUND(
        SUM(s.quantity * p.unit_price_new),
        2
    ) AS total_revenue,

    ROUND(
        SUM(
            s.quantity *
            (p.unit_price_new - p.unit_cost_new)
        ),
        2
    ) AS total_profit,

    ROUND(
        (
            SUM(
                s.quantity *
                (p.unit_price_new - p.unit_cost_new)
            )
            /
            NULLIF(
                SUM(s.quantity * p.unit_price_new),
                0
            )
        ) * 100,
        2
    ) AS profit_margin_pct

FROM fact_sales AS s
JOIN dim_product AS p
    ON p.product_key = s.product_key

GROUP BY
    p.product_key,
    p.product_name,
    p.category

ORDER BY profit_margin_pct DESC;


-- ============================================================
-- Query 31: Product Revenue Contribution
-- ============================================================

WITH product_sales AS (
    SELECT
        p.product_key,
        p.product_name,
        p.category,

        SUM(
            s.quantity * p.unit_price_new
        ) AS total_revenue

    FROM fact_sales AS s
    JOIN dim_product AS p
        ON p.product_key = s.product_key

    GROUP BY
        p.product_key,
        p.product_name,
        p.category
)

SELECT
    product_key,
    product_name,
    category,

    ROUND(total_revenue, 2) AS total_revenue,

    ROUND(
        (
            total_revenue /
            SUM(total_revenue) OVER ()
        ) * 100,
        2
    ) AS revenue_contribution_pct

FROM product_sales

ORDER BY total_revenue DESC

LIMIT 10;