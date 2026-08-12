-- ============================================================
-- GLOBAL ELECTRONICS SALES ANALYSIS
-- Phase 5: Store Analytics
-- Queries: 32-36
-- Database: global_elecdb
-- Tool: MySQL
-- ============================================================


-- ============================================================
-- Query 32: Store Revenue Analysis
-- ============================================================

SELECT
    st.store_key,
    st.state,
    st.country,

    ROUND(
        SUM(s.quantity * p.unit_price_new),
        2
    ) AS total_revenue

FROM fact_sales AS s
JOIN dim_store AS st
    ON st.store_key = s.store_key
JOIN dim_product AS p
    ON p.product_key = s.product_key

GROUP BY
    st.store_key,
    st.state,
    st.country

ORDER BY total_revenue DESC;


-- ============================================================
-- Query 33: Store Profitability Analysis
-- ============================================================

SELECT
    st.store_key,
    st.state,
    st.country,

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
JOIN dim_store AS st
    ON st.store_key = s.store_key
JOIN dim_product AS p
    ON p.product_key = s.product_key

GROUP BY
    st.store_key,
    st.state,
    st.country

ORDER BY total_profit DESC;


-- ============================================================
-- Query 34: Store Sales by Country
-- ============================================================

SELECT
    st.country,

    ROUND(
        SUM(s.quantity * p.unit_price_new),
        2
    ) AS total_revenue,

    SUM(s.quantity) AS units_sold,

    COUNT(DISTINCT s.order_number) AS total_orders

FROM fact_sales AS s
JOIN dim_store AS st
    ON st.store_key = s.store_key
JOIN dim_product AS p
    ON p.product_key = s.product_key

GROUP BY st.country

ORDER BY total_revenue DESC;


-- ============================================================
-- Query 35: Store Order Volume
-- ============================================================

SELECT
    st.store_key,
    st.state,
    st.country,

    COUNT(DISTINCT s.order_number) AS total_orders,

    SUM(s.quantity) AS units_sold

FROM fact_sales AS s
JOIN dim_store AS st
    ON st.store_key = s.store_key

GROUP BY
    st.store_key,
    st.state,
    st.country

ORDER BY total_orders DESC;


-- ============================================================
-- Query 36: Store Performance Ranking
-- ============================================================

WITH store_sales AS (
    SELECT
        st.store_key,
        st.state,
        st.country,

        SUM(
            s.quantity * p.unit_price_new
        ) AS total_revenue

    FROM fact_sales AS s
    JOIN dim_store AS st
        ON st.store_key = s.store_key
    JOIN dim_product AS p
        ON p.product_key = s.product_key

    GROUP BY
        st.store_key,
        st.state,
        st.country
)

SELECT
    store_key,
    state,
    country,

    ROUND(total_revenue, 2) AS total_revenue,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS store_rank

FROM store_sales

ORDER BY store_rank;