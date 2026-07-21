-- =============================================================================
-- RETAIL ANALYTICS CAPSTONE: DATABASE VIEWS (QUESTIONS 1 - 10)
-- =============================================================================

-- QUESTION 1: Revenue vs Net Profit & Margin %
DROP VIEW IF EXISTS question_1_revenue_vs_margin CASCADE;
CREATE VIEW question_1_revenue_vs_margin AS
WITH calc AS (
    SELECT  
        ft."Date",
        p."Category Name" AS category, 
        (ft."Unit Selling Price (RMB/kg)" * ft."Quantity Sold (kilo)") AS revenue,
        (ft."Quantity Sold (kilo)" * ph."Wholesale Price (RMB/kg)") AS cogs,
        (ft."Quantity Sold (kilo)" * (lr."Loss Rate (%)" / 100.0) * ph."Wholesale Price (RMB/kg)") AS wastage_cost 
    FROM "Fact Transactions" ft
    JOIN "Pricing History" ph ON ph."Item Code" = ft."Item Code" AND ft."Date" = ph."Date"
    JOIN "Loss Rates" lr ON ft."Item Code" = lr."Item Code" 
    JOIN "Products" p ON p."Item Code" = ft."Item Code"
)
SELECT 
    ft."Date", 
    category, 
    SUM(revenue) AS "Gross revenue", 
    (SUM(revenue) - SUM(cogs) - SUM(wastage_cost)) AS "Net Profit",
    ROUND(((SUM(revenue) - SUM(cogs) - SUM(wastage_cost)) / NULLIF(SUM(revenue), 0))::numeric * 100.0, 2) AS "Net Profit Margin (%)"
FROM calc ft 
GROUP BY ft."Date", category 
ORDER BY "Net Profit" DESC;


-- QUESTION 2: Discount Impact Analysis
DROP VIEW IF EXISTS question_2_discount_impact CASCADE;
CREATE VIEW question_2_discount_impact AS
WITH metrics AS (
    SELECT 
        ft."Date", 
        ft."Discount (Yes/No)" AS discount_status,
        (ft."Unit Selling Price (RMB/kg)" * ft."Quantity Sold (kilo)") AS revenue,
        (ft."Quantity Sold (kilo)" * ph."Wholesale Price (RMB/kg)") AS cogs,
        (ft."Quantity Sold (kilo)" * (lr."Loss Rate (%)" / 100.0) * ph."Wholesale Price (RMB/kg)") AS wastage_cost
    FROM "Fact Transactions" ft
    JOIN "Pricing History" ph ON ph."Item Code" = ft."Item Code" AND ft."Date" = ph."Date"
    JOIN "Loss Rates" lr ON ft."Item Code" = lr."Item Code"
)
SELECT 
    "Date", 
    discount_status, 
    COUNT(*) AS "Total Transaction Rows", 
    SUM(revenue) AS "Total Revenue Generated",
    SUM(revenue - cogs - wastage_cost) AS "Total Net Profit",
    ROUND((SUM(revenue - cogs - wastage_cost) / NULLIF(SUM(revenue), 0))::numeric * 100.0, 2) AS "Net Margin (%)"
FROM metrics 
GROUP BY "Date", discount_status;


-- QUESTION 3: Category Actual ROI Analysis
DROP VIEW IF EXISTS question_3_roi_analysis CASCADE;
CREATE VIEW question_3_roi_analysis AS
WITH calc AS (
    SELECT 
        p."Category Name" AS category, 
        (ft."Unit Selling Price (RMB/kg)" * ft."Quantity Sold (kilo)") AS revenue,
        (ft."Quantity Sold (kilo)" * ph."Wholesale Price (RMB/kg)") AS cogs_sold,
        (ft."Quantity Sold (kilo)" * (lr."Loss Rate (%)" / 100.0) * ph."Wholesale Price (RMB/kg)") AS cogs_wasted
    FROM "Fact Transactions" ft 
    JOIN "Products" p ON ft."Item Code" = p."Item Code" 
    JOIN "Pricing History" ph ON ft."Item Code" = ph."Item Code" AND ft."Date" = ph."Date"
    JOIN "Loss Rates" lr ON lr."Item Code" = ft."Item Code" 
)
SELECT 
    category,
    SUM(revenue) AS "Total Revenue Realized",
    (SUM(cogs_sold) + SUM(cogs_wasted)) AS "Total Cost Basis",
    ROUND(((SUM(revenue) - (SUM(cogs_sold) + SUM(cogs_wasted))) / NULLIF(SUM(cogs_sold) + SUM(cogs_wasted), 0))::numeric * 100.0, 2) AS "Actual ROI (%)"
FROM calc
GROUP BY category
ORDER BY "Actual ROI (%)" DESC;


-- QUESTION 4: Item Level Waste Cost
DROP VIEW IF EXISTS question_4_waste_cost CASCADE;
CREATE VIEW question_4_waste_cost AS
SELECT 
    ft."Date", 
    p."Category Name", 
    p."Item Name", 
    SUM(ft."Quantity Sold (kilo)" * ph."Wholesale Price (RMB/kg)") AS "Wholesale Cost Spent", 
    lr."Loss Rate (%)",
    ((SUM(ft."Quantity Sold (kilo)" * ph."Wholesale Price (RMB/kg)")) * lr."Loss Rate (%)" / 100.0) AS "amount lost"
FROM "Fact Transactions" ft 
JOIN "Loss Rates" lr ON ft."Item Code" = lr."Item Code" 
JOIN "Products" p ON p."Item Code" = ft."Item Code" 
JOIN "Pricing History" ph ON ft."Item Code" = ph."Item Code" AND ft."Date" = ph."Date"
GROUP BY ft."Date", p."Category Name", p."Item Name", lr."Loss Rate (%)" 
ORDER BY "amount lost" DESC;


-- QUESTION 5: Price Vulnerability Analysis
DROP VIEW IF EXISTS question_5_price_vulnerability CASCADE;
CREATE VIEW question_5_price_vulnerability AS
SELECT 
    p."Item Name",
    (MAX(ph."Wholesale Price (RMB/kg)") - MIN(ph."Wholesale Price (RMB/kg)")) AS "Wholesale Price Variance",
    (MAX(ft."Unit Selling Price (RMB/kg)") - MIN(ft."Unit Selling Price (RMB/kg)")) AS "Selling Price Variance"
FROM "Fact Transactions" ft 
JOIN "Pricing History" ph ON ft."Item Code" = ph."Item Code" AND ft."Date" = ph."Date"
JOIN "Products" p ON ft."Item Code" = p."Item Code" 
GROUP BY p."Item Name" 
ORDER BY ((MAX(ph."Wholesale Price (RMB/kg)") - MIN(ph."Wholesale Price (RMB/kg)")) - (MAX(ft."Unit Selling Price (RMB/kg)") - MIN(ft."Unit Selling Price (RMB/kg)"))) DESC;


-- QUESTION 6: Seasonal Spoilage Analysis
DROP VIEW IF EXISTS question_6_seasonal_spoilage CASCADE;
CREATE VIEW question_6_seasonal_spoilage AS
SELECT 
    ft."Date", 
    p."Category Name", 
    TO_CHAR(ft."Date"::date, 'Month') AS Sales_Month,
    EXTRACT(MONTH FROM ft."Date"::date) AS Month_Number,
    SUM(ft."Quantity Sold (kilo)") AS Total_Quantity_Sold,
    SUM(ft."Quantity Sold (kilo)" * (lr."Loss Rate (%)" / 100.0)) AS Imputed_Spoilage_Volume
FROM "Fact Transactions" ft
JOIN "Products" p ON ft."Item Code" = p."Item Code"
JOIN "Loss Rates" lr ON ft."Item Code" = lr."Item Code"
GROUP BY ft."Date", p."Category Name", TO_CHAR(ft."Date"::date, 'Month'), EXTRACT(MONTH FROM ft."Date"::date)
ORDER BY p."Category Name", EXTRACT(MONTH FROM ft."Date"::date);


-- QUESTION 7: Peak Shopping Hours
DROP VIEW IF EXISTS question_7_peak_hours CASCADE;
CREATE VIEW question_7_peak_hours AS
WITH time_count AS (
    SELECT 
        ft."Date", 
        p."Category Name" AS Category,
        EXTRACT(HOUR FROM ft."Time"::time) AS "Hour", 
        COUNT(ft."Item Code") AS Sales_amount
    FROM "Fact Transactions" ft 
    JOIN "Products" p ON ft."Item Code" = p."Item Code" 
    GROUP BY ft."Date", EXTRACT(HOUR FROM ft."Time"::time), "Category Name" 
)
SELECT 
    "Date", 
    Category, 
    "Hour",
    (CASE 
        WHEN "Hour" >= 0 AND "Hour" < 12 THEN 'Morning'
        WHEN "Hour" >= 12 AND "Hour" < 17 THEN 'Afternoon'
        ELSE 'Evening' 
    END) AS "Day Period",
    Sales_amount
FROM time_count 
ORDER BY Category, "Hour";


-- QUESTION 8: Return Patterns (Weekday vs Weekend)
DROP VIEW IF EXISTS question_8_return_patterns CASCADE;
CREATE VIEW question_8_return_patterns AS
SELECT 
    ft."Date", 
    CASE WHEN DATE_PART('DOW', ft."Date"::date) IN (6, 0) THEN 'Weekend' ELSE 'Weekday' END AS "Day Type",
    p."Category Name", 
    p."Item Name", 
    COUNT(ft."Item Code") AS return_amount
FROM "Fact Transactions" ft 
JOIN "Products" p ON ft."Item Code" = p."Item Code" 
WHERE ft."Sale or Return" = 'return'
GROUP BY ft."Date", CASE WHEN DATE_PART('DOW', ft."Date"::date) IN (6, 0) THEN 'Weekend' ELSE 'Weekday' END, p."Category Name", p."Item Name"
ORDER BY p."Category Name", p."Item Name", "Day Type";


-- QUESTION 9: Return Timing Analysis
DROP VIEW IF EXISTS question_9_return_timing CASCADE;
CREATE VIEW question_9_return_timing AS
SELECT 
    ft."Date", 
    EXTRACT(HOUR FROM ft."Time"::time) AS "Hour",
    COUNT(ft."Item Code") AS return_amount
FROM "Fact Transactions" ft 
WHERE ft."Sale or Return" = 'return'
GROUP BY ft."Date", EXTRACT(HOUR FROM ft."Time"::time)
ORDER BY EXTRACT(HOUR FROM ft."Time"::time) ASC;


-- QUESTION 10: Discount vs Freshness/Loss Rate Strategy
DROP VIEW IF EXISTS question_10_discount_freshness CASCADE;
CREATE VIEW question_10_discount_freshness AS
SELECT 
    lr."Item Name", 
    lr."Loss Rate (%)",
    (COUNT(CASE WHEN ft."Discount (Yes/No)" = 'Yes' THEN 1 END)::numeric / COUNT(ft."Item Code")) * 100.0 AS "Percentage of Transactions Discounted"
FROM "Fact Transactions" ft 
JOIN "Loss Rates" lr ON ft."Item Code" = lr."Item Code" 
GROUP BY lr."Item Name", lr."Loss Rate (%)"
ORDER BY lr."Loss Rate (%)" DESC;
