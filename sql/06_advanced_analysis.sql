-- ============================================================
-- GLOBAL ELECTRONICS SALES ANALYSIS
-- Phase 6: Advanced SQL & Executive Analytics
-- Queries: 38-42
-- Database: global_elecdb
-- Tool: MySQL
-- ============================================================


-- ============================================================
-- Query 38: Monthly Revenue Analysis
-- ============================================================

SELECT
    YEAR(s.order_date) AS sales_year,
    MONTH(s.order_date) AS sales_month,

    ROUND(
        SUM(s.quantity * p.unit_price_new),
        2
    ) AS monthly_revenue

FROM fact_sales AS s
JOIN dim_product AS p
    ON p.product_key = s.product_key

GROUP BY
    YEAR(s.order_date),
    MONTH(s.order_date)

ORDER BY
    sales_year,
    sales_month;


-- ============================================================
-- Query 39: Month-over-Month Revenue Growth
-- ============================================================

WITH monthly_sales AS (
    SELECT
        YEAR(s.order_date) AS sales_year,
        MONTH(s.order_date) AS sales_month,

        SUM(
            s.quantity * p.unit_price_new
        ) AS monthly_revenue

    FROM fact_sales AS s
    JOIN dim_product AS p
        ON p.product_key = s.product_key

    GROUP BY
        YEAR(s.order_date),
        MONTH(s.order_date)
),

sales_with_previous AS (
    SELECT
        sales_year,
        sales_month,
        monthly_revenue,

        LAG(monthly_revenue) OVER (
            ORDER BY sales_year, sales_month
        ) AS previous_month_revenue

    FROM monthly_sales
)

SELECT
    sales_year,
    sales_month,

    ROUND(monthly_revenue, 2) AS monthly_revenue,

    ROUND(
        previous_month_revenue,
        2
    ) AS previous_month_revenue,

    ROUND(
        (
            (
                monthly_revenue -
                previous_month_revenue
            )
            /
            NULLIF(previous_month_revenue, 0)
        ) * 100,
        2
    ) AS monthly_growth_pct

FROM sales_with_previous

ORDER BY
    sales_year,
    sales_month;


-- ============================================================
-- Query 40: Year-over-Year Revenue Growth
-- ============================================================

WITH yearly_sales AS (
    SELECT
        YEAR(s.order_date) AS sales_yearly,

        SUM(
            s.quantity * p.unit_price_new
        ) AS total_revenue

    FROM fact_sales AS s
    JOIN dim_product AS p
        ON p.product_key = s.product_key

    GROUP BY sales_yearly
),

sales_with_previous AS (
    SELECT
        sales_yearly,
        total_revenue,

        LAG(total_revenue) OVER (
            ORDER BY sales_yearly
        ) AS previous_year_revenue

    FROM yearly_sales
)

SELECT
    sales_yearly,

    ROUND(
        total_revenue,
        2
    ) AS total_revenue,

    ROUND(
        previous_year_revenue,
        2
    ) AS previous_year_revenue,

    ROUND(
        (
            (
                total_revenue -
                previous_year_revenue
            )
            /
            NULLIF(previous_year_revenue, 0)
        ) * 100,
        2
    ) AS yearly_growth_pct

FROM sales_with_previous

ORDER BY sales_yearly;


-- ============================================================
-- Query 41: Running Total Revenue
-- ============================================================

WITH monthly_sales AS (
    SELECT
        YEAR(s.order_date) AS sales_year,
        MONTH(s.order_date) AS sales_month,

        SUM(
            s.quantity * p.unit_price_new
        ) AS monthly_revenue

    FROM fact_sales AS s
    JOIN dim_product AS p
        ON p.product_key = s.product_key

    GROUP BY
        YEAR(s.order_date),
        MONTH(s.order_date)
)

SELECT
    sales_year,
    sales_month,

    ROUND(
        monthly_revenue,
        2
    ) AS monthly_revenue,

    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY sales_year, sales_month
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS running_total_revenue

FROM monthly_sales

ORDER BY
    sales_year,
    sales_month;


-- ============================================================
-- Query 42: Category Revenue Contribution
-- ============================================================

WITH category_sales AS (
    SELECT
        p.category,

        SUM(
            s.quantity * p.unit_price_new
        ) AS total_revenue

    FROM fact_sales AS s
    JOIN dim_product AS p
        ON p.product_key = s.product_key

    GROUP BY p.category
)

SELECT
    category,

    ROUND(
        total_revenue,
        2
    ) AS total_revenue,

    ROUND(
        (
            total_revenue /
            SUM(total_revenue) OVER ()
        ) * 100,
        2
    ) AS revenue_contribution_pct

FROM category_sales

ORDER BY total_revenue DESC;