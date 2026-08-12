# Global Electronics Sales Analysis | SQL Data Analytics Project

> Turning transactional sales data into actionable business insights using SQL, advanced analytics, and data-quality validation.

## 📌 Project Overview

This project is an end-to-end **SQL Data Analytics project** built using MySQL to analyze the sales performance of a global electronics business.

The analysis covers **revenue, profitability, customers, products, stores, sales trends, growth rates, and revenue concentration** across multiple dimensions.

Rather than only writing SQL queries, the project follows a practical analytics workflow:

**Data Validation → Business Questions → SQL Analysis → Advanced Analytics → Business Insights**

A total of **42 business-focused SQL queries** were developed, progressing from fundamental aggregations and JOINs to advanced SQL techniques including **CTEs, window functions, LAG(), ROW_NUMBER(), running totals, MoM growth, YoY growth, and contribution analysis.**

---

## 🎯 Business Problem

A global electronics business needs to understand:

- Which products and categories generate the most revenue?
- Which brands and categories are the most profitable?
- Who are the highest-value customers?
- Which stores and countries drive business performance?
- How is revenue changing over time?
- What percentage of total revenue comes from each category?
- Where are potential performance and profitability risks?
- Are the underlying data accurate enough to support business decisions?

The objective was to use SQL to answer these questions and convert raw transactional data into **decision-ready insights**.

---

# 🛠️ Tools & Technologies

**Database & Querying**
- MySQL
- SQL

**SQL Techniques**
- SELECT
- WHERE
- JOIN
- INNER JOIN
- GROUP BY
- HAVING
- ORDER BY
- CASE WHEN
- Aggregate Functions
- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- LAG()
- SUM() OVER()
- Ranking
- Running Totals
- Percentage Contribution
- Month-over-Month (MoM) Analysis
- Year-over-Year (YoY) Analysis

**Analytics Areas**
- Sales Analytics
- Revenue Analytics
- Profitability Analysis
- Customer Analytics
- Product Analytics
- Store Analytics
- Trend Analysis
- Business Performance Analysis
- Data Quality Validation

---

# 📊 Analysis Framework

The project contains **42 SQL queries** organized into six analytical areas.

### 01 — Sales & Revenue Analytics

Analyzed:

- Total revenue
- Sales trends
- Sales by country
- Sales by category
- Revenue distribution
- Order and unit performance

### 02 — Profitability Analytics

Analyzed:

- Total profit
- Profit margins
- Category profitability
- Country profitability
- Brand profitability
- Sales vs. profit performance

### 03 — Customer Analytics

Analyzed:

- Top customers by revenue
- Customer purchase frequency
- Customer spending
- Customer profitability
- Customer concentration
- Customer ranking

### 04 — Product Analytics

Analyzed:

- Top products by revenue
- Top products by profit
- Units sold by product
- Product profitability
- Product revenue contribution

### 05 — Store Analytics

Analyzed:

- Store revenue
- Store profitability
- Store order volume
- Store unit sales
- Store performance by country

### 06 — Advanced SQL Analytics

Analyzed:

- Monthly revenue
- Month-over-Month growth
- Year-over-Year growth
- Running total revenue
- Revenue contribution
- Ranking analysis
- Window-function based analytics

---

# 🔎 Key Business Insights

## 💰 Revenue Concentration

**Computers were the largest revenue-generating category.**

- Revenue: **$19.30M**
- Revenue contribution: **35.44%**

The top four categories — **Computers, Home Appliances, Cameras & Camcorders, and Cell Phones** — generated approximately **76.21% of total revenue**.

### Business implication

Revenue is highly concentrated within a small number of categories, making these categories particularly important for pricing, inventory planning, product strategy, and revenue forecasting.

---

## 📈 Profitability Performance

**Computers were the largest absolute profit contributor**, generating approximately:

**$11.28M profit**

However, the highest revenue category was not necessarily the highest-margin category.

**Music, Movies & Audio Books** achieved the highest category profit margin:

**60.98%**

while **Games & Toys** recorded the lowest analyzed category margin:

**54.73%**

### Business implication

Revenue leadership and profitability efficiency are different dimensions of performance. Management should evaluate both **absolute profit contribution and profit margin** when prioritizing categories.

---

## 🏷️ Brand Performance

**Adventure Works** was the largest brand by business contribution:

- Sales: **$118.5M**
- Profit: **$69.37M**
- Profit margin: **58.54%**

**Proseware** achieved the highest brand profit margin:

**60.24%**

### Business implication

Adventure Works is the strongest contributor in terms of scale, while Proseware demonstrates stronger profitability efficiency.

---

# 📅 Revenue Growth Analysis

Year-over-year analysis revealed significant changes in business performance.

| Year | YoY Revenue Growth |
|------|--------------------:|
| 2017 | +7.80% |
| 2018 | **+71.98%** |
| 2019 | +44.19% |
| 2020 | **-48.95%** |
| 2021 | **-88.64%** |

### Key finding

**2018 recorded the strongest annual revenue growth at 71.98%.**

After strong growth in 2018 and 2019, revenue declined substantially in 2020 and 2021.

### Business implication

The sharp decline after 2019 represents a major performance trend that would warrant deeper investigation into factors such as product mix, customer behavior, store performance, pricing, and market conditions.

---

# 🧹 Data Quality Investigation

One of the most important findings came from **data validation**, not directly from business analysis.

During product-level validation, **144 product records were identified with incorrect imported prices**.

The issue was caused by **comma-separated currency values being incorrectly interpreted during the data import process**, resulting in truncated price values.

For example:

```text
$2,899.99 → 2.00
$1,184.97 → 1.00
$1,099.99 → 1.00
