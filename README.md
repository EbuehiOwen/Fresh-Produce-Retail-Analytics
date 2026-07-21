# Fresh Produce Retail Analytics — Capstone Project

## Overview

A comprehensive data analytics project analyzing 800,000+ transactions from a fresh produce retailer (July 2020 - December 2023) to identify profitability drivers, operational inefficiencies, and customer behavior patterns.

**Objective:** Answer 10 strategic business questions using SQL analysis and Power BI visualization.

---

## Project Components

### 1. **SQL Analysis (PostgreSQL)**
- 10 complex SQL views answering core business questions
- Multi-table joins, CTEs, aggregations, window functions
- Data cleaning and transformation logic
- File: `sql_views.sql`

### 2. **Power BI Dashboard**
- 3-page interactive report with 10 visualizations
- Page 1: Financial Analysis (Revenue, Profit, ROI)
- Page 2: Operations & Spoilage (Waste costs, Seasonality, Price volatility)
- Page 3: Customer Behavior (Peak hours, Returns, Discounting patterns)
- Progressive disclosure navigation with date filtering
- File: `retail_analytics_dashboard.pbix`

### 3. **Executive Findings Report**
- Business insights and tactical recommendations
- Financial impact analysis
- Action plan with implementation priorities
- File: `FINDINGS.md`

---

## Technical Stack

| Component | Tool | Version |
|-----------|------|---------|
| Database | PostgreSQL | 12+ |
| SQL IDE | DBeaver | Latest |
| Visualization | Power BI Desktop | Latest |
| Data Volume | 800,000+ transactions | 4 years (2020-2023) |

---

## The 10 Questions

### Pillar A: Financial Analysis
1. Which product categories generate highest revenue vs highest profit margin?
2. How does discounting impact quantity sold and total profit?
3. Which categories show best ROI accounting for loss rates?

### Pillar B: Operations & Spoilage
4. Which products cost most money in waste?
5. Which items have high wholesale price variance but static selling prices?
6. Are there seasonal trends in spoilage by category?

### Pillar C: Customer Behavior
7. What are the busiest hours for sales? Which categories sell when?
8. Do specific items have higher returns on weekends vs weekdays?
9. Which hours have highest return rates?
10. Is there correlation between discount frequency and loss rate?

---

## How to Use

### **Opening the SQL Views**

1. Install PostgreSQL and DBeaver
2. Create a database with your transaction data (structure: Date, Item Code, Quantity Sold, Unit Price, Wholesale Price, Loss Rate, etc.)
3. Run `sql_views.sql` to create all 10 views
4. Query any view: `SELECT * FROM question_1_revenue_vs_margin;`

### **Opening the Power BI Dashboard**

1. Install Power BI Desktop
2. Open `retail_analytics_dashboard.pbix`
3. Connect to your PostgreSQL database (if using live connection) or load CSV exports
4. Use date filter on left sidebar to explore by year
5. Click navigation buttons to move between pages
6. Click "RESET" to clear all filters

### **Reading the Report**

1. Open `FINDINGS.md` for executive summary and recommendations
2. Reference specific metrics and impacts
3. Use as basis for stakeholder presentations

---

## Key Findings Summary

- **Total Revenue:** $3.37M | **Net Profit:** $1.03M | **Margin:** 30.68%
- **Annual Waste Cost:** $209.95K from 46.61K spoiled units
- **Median Loss Rate:** 9.43%
- **Peak Sales Hour:** 16:00 (4pm) with 120,912 transactions
- **Return Rate:** 0.05% (461 total returns)
- **Discounting Impact:** Discounted items generate 75% less profit than non-discounted

Full analysis in `FINDINGS.md`

---

## Skills Demonstrated

✅ SQL (CTEs, JOINs, Window Functions, Aggregations, Data Cleaning)  
✅ PostgreSQL (Complex multi-table queries, VIEW creation)  
✅ Power BI (Dashboard design, DAX measures, Progressive disclosure UX)  
✅ Data Analysis (Business question formulation, Insight extraction)  
✅ Business Acumen (Financial impact calculation, Operational optimization)  

---

## Files & Descriptions

| File | Description | Size |
|------|-------------|------|
| `README.md` | Project overview and setup instructions | 4KB |
| `FINDINGS.md` | Executive report with findings & recommendations | 8KB |
| `sql_views.sql` | 10 SQL views answering all questions | 15KB |
| `retail_analytics_dashboard.pbix` | Interactive 3-page Power BI report | 5-10MB |
| `screenshots/` | Screenshots of all 3 dashboard pages | ~3MB |

---

## How This Project Was Built

1. **Data Exploration:** Analyzed 800K transactions across 4 dimension tables
2. **SQL Analysis:** Wrote 10 views to answer specific business questions
3. **Data Cleaning:** Handled date formatting, price normalization, loss rate calculations
4. **Power BI Modeling:** Created relationships, DAX measures, interactive visualizations
5. **Dashboard Design:** Built 3-page report with progressive disclosure navigation
6. **Insights:** Synthesized findings into actionable business recommendations

---

## Contact

**Project Author:** Owen Ebuehi  
**LinkedIn:** [linkedin.com/in/owenebuehi](https://www.linkedin.com/in/owenebuehi)  
**GitHub:** [github.com/EbuehiOwen](https://github.com/EbuehiOwen)  

---

## License

This project is part of my data analytics portfolio. Feel free to reference but please credit appropriately.
