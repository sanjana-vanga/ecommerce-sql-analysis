# 🛒 E-Commerce Sales Analysis — SQL Project

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791?style=flat-square&logo=postgresql&logoColor=white)
![Dataset](https://img.shields.io/badge/Dataset-1000%20Rows-brightgreen?style=flat-square)
![Phases](https://img.shields.io/badge/Analysis%20Phases-13-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

A comprehensive end-to-end SQL analysis of an e-commerce sales dataset covering **1,000 orders**, **996 unique customers**, and **6 product categories** across a **2-year period (Jun 2024 – Jun 2026)**.

The project is structured into **13 analytical phases** — from raw data ingestion to advanced window functions, CTE-based segmentation, and day-over-day growth analysis.

---

## 📁 Project Structure

```
ecommerce-sql-analysis/
├── ecommerce_dataset_1000_rows.csv   # Raw dataset (1,000 orders)
├── ecommerce.sql                     # All SQL queries (Phases 2–13)
├── Ecommerce_Analysis_Report.docx    # Full output report with results
└── README.md                         # This file
```

---

## 📊 Dataset Schema

The dataset is loaded into a single table:

```sql
CREATE TABLE ecommerce_sales (
    order_id          INT,
    customer_id       INT,
    order_date        DATE,
    product_category  VARCHAR(50),
    quantity          INT,
    unit_price        NUMERIC(10,2),
    total_amount      NUMERIC(10,2)
);
```

| Column | Type | Description |
|---|---|---|
| `order_id` | INT | Unique order identifier |
| `customer_id` | INT | Customer identifier |
| `order_date` | DATE | Date of the order |
| `product_category` | VARCHAR | One of: Beauty, Books, Electronics, Fashion, Home, Sports |
| `quantity` | INT | Units purchased |
| `unit_price` | NUMERIC | Price per unit (₹) |
| `total_amount` | NUMERIC | `quantity × unit_price` (₹) |

---

## 🚀 Getting Started

### Prerequisites

- **PostgreSQL** 13+ (recommended) — or any SQL engine supporting window functions and `DATE_TRUNC`
- A SQL client: [pgAdmin](https://www.pgadmin.org/), [DBeaver](https://dbeaver.io/), [TablePlus](https://tableplus.com/), or the `psql` CLI

> **Note:** Queries use `DATE_TRUNC` and window functions (`RANK`, `LAG`, `NTILE`, `OVER`). These are standard in PostgreSQL, and largely compatible with MySQL 8+, SQLite 3.25+, and BigQuery. Minor syntax adjustments may be needed for other engines.

---

### Step 1 — Clone the Repository

```bash
git clone https://github.com/<your-username>/ecommerce-sql-analysis.git
cd ecommerce-sql-analysis
```

### Step 2 — Create the Database

```bash
psql -U postgres
```

```sql
CREATE DATABASE ecommerce_db;
\c ecommerce_db
```

### Step 3 — Create the Table

```sql
CREATE TABLE ecommerce_sales (
    order_id          INT,
    customer_id       INT,
    order_date        DATE,
    product_category  VARCHAR(50),
    quantity          INT,
    unit_price        NUMERIC(10,2),
    total_amount      NUMERIC(10,2)
);
```

### Step 4 — Import the CSV

```bash
psql -U postgres -d ecommerce_db -c \
  "\COPY ecommerce_sales FROM 'ecommerce_dataset_1000_rows.csv' CSV HEADER;"
```

> **Windows users:** Use the full absolute path and forward slashes, e.g.:
> `\COPY ecommerce_sales FROM 'C:/Users/you/ecommerce_dataset_1000_rows.csv' CSV HEADER;`

### Step 5 — Run the Queries

Open `ecommerce.sql` in your SQL client and run it in full, or execute individual phases as needed.

```bash
psql -U postgres -d ecommerce_db -f ecommerce.sql
```

---

## 📋 Analysis Phases

| Phase | Title | Key Queries |
|---|---|---|
| **2** | Data Understanding | `COUNT`, `DISTINCT`, `MIN/MAX` on dates |
| **3** | Data Cleaning | Null check, duplicate detection, amount verification |
| **4** | Basic KPIs | Total revenue, avg order value, min/max orders |
| **5** | Category Analysis | Revenue, orders, AOV, and % contribution by category |
| **6** | Customer Analysis | Top 10, multi-order, LTV, average spend |
| **7** | Time Series | Monthly revenue, orders, and quantity sold |
| **8** | Trend Analysis | Cumulative revenue, 7-day moving average |
| **9** | Window Functions | `RANK()`, `DENSE_RANK()`, top-N customers |
| **10** | Segmentation | CASE-based Platinum / Gold / Silver / Bronze tiers |
| **11** | Advanced CTEs | Above-average customers, top category per month |
| **12** | Business Insights | Peak day, peak month, most purchased category |
| **13** | Advanced SQL | `NTILE` top 20%, `LAG` day-over-day growth rate % |

---

## 📌 Key Results

| Metric | Value |
|---|---|
| Total Revenue | ₹7,75,224.12 |
| Total Orders | 1,000 |
| Average Order Value | ₹775.22 |
| Highest Single Order | ₹2,481.35 |
| Best Revenue Month | December 2025 — ₹41,155.02 |
| Best Revenue Day | 4 Feb 2026 — ₹8,141.09 |
| Top Category (Revenue) | Books — ₹1,42,656.81 (18.4%) |
| Most Purchased Category | Books — 537 units |
| Top 20% Customers Drive | 45% of total revenue |
| Repeat Customers | Only 4 (major retention opportunity) |

---

## 💡 Business Insights

- **Books** is the highest-value category — top revenue share *and* highest average order value (₹834).
- **December** is consistently the peak month across both 2024 and 2025 — plan inventory and campaigns accordingly.
- **February and April** show recurring revenue dips — target promotions during these months.
- **Zero Platinum/Gold customers** — no single customer spent over ₹3,000. Loyalty or subscription programs could unlock this tier.
- **Only 4 repeat customers** out of 996 — repeat purchase rate is the single biggest growth lever available.
- **Top 20% of customers** generate 45% of revenue (near-Pareto distribution).

---

## 🗂️ Compatibility Notes

| Feature | PostgreSQL | MySQL 8+ | SQLite 3.25+ | BigQuery |
|---|---|---|---|---|
| `DATE_TRUNC` | ✅ | ❌ Use `DATE_FORMAT` | ❌ Use `strftime` | ✅ |
| Window Functions | ✅ | ✅ | ✅ | ✅ |
| `NTILE` | ✅ | ✅ | ✅ | ✅ |
| `LAG` / `LEAD` | ✅ | ✅ | ✅ | ✅ |
| CTEs (`WITH`) | ✅ | ✅ | ✅ | ✅ |

---

## 🛠️ Tools Used

- **PostgreSQL 15** — primary query engine
- **pgAdmin 4** — query execution and result inspection
- **Python + DuckDB** — data validation and cross-checking
- **Microsoft Word** — final report generation

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 🙋 Author

Built as a structured SQL learning project covering real-world e-commerce analytics patterns.  
Feel free to fork, extend, or adapt the queries for your own datasets.
