------ US GOVERNMENT REAL ESTSTAE ANALYSIS OF REAL ESTATE RECORD PROJECT-------
==================================================================================


DROP TABLE IF EXISTS property_sales;

CREATE TABLE property_sales (
    serial_numb VARCHAR,
    list_year INTEGER,
    date_record DATE,
    town VARCHAR,
    address TEXT,
    assessed_val INTEGER,
    sale_amount INTEGER,
    sales_ratio NUMERIC(6,4),
    property_type VARCHAR
);


------------US Real Government Analysis Record Business Question:
====================================================================

-- 1. Count of NULLs per column
-- 2. Find all rows with at least one NULL
-- 3. Which towns or regions have the highest and lowest property assessment ratios?
--    Why might these differences exist, and what are their tax implications?
-- 4. How do property sales and prices vary by property type 
--    (e.g., single family, condo, multi family)?
-- 5. What seasonal trends can be observed in real estate sales volume over the years?
-- 6. Is there a correlation between average property price and assessment ratio across towns?
-- 7. Which property types are consistently over- or under-assessed relative to their market values?
-- 8. How does the distribution of property types impact the overall property tax base and 
--   What is the effective property tax burden across different states or counties based on assessment ratios?
-- 9. Which months or seasons consistently show the highest sales activity, and what factors contribute to this pattern?



SELECT * FROM property_sales;

--1: Count of NULLs per column


SELECT 
    COUNT(*) FILTER (WHERE serial_numb IS NULL) AS serial_numb_nulls,
    COUNT(*) FILTER (WHERE list_year IS NULL) AS list_year_nulls,
    COUNT(*) FILTER (WHERE date_record IS NULL) AS date_record_nulls,
    COUNT(*) FILTER (WHERE town IS NULL) AS town_nulls,
    COUNT(*) FILTER (WHERE address IS NULL) AS address_nulls,
    COUNT(*) FILTER (WHERE assessed_val IS NULL) AS assessed_val_nulls,
    COUNT(*) FILTER (WHERE sale_amount IS NULL) AS sale_amount_nulls,
    COUNT(*) FILTER (WHERE sales_ratio IS NULL) AS sales_ratio_nulls,
    COUNT(*) FILTER (WHERE property_type IS NULL) AS property_type_nulls
FROM property_sales;

-- 2: Find all rows with at least one NULL


SELECT *
FROM property_sales
WHERE serial_numb IS NULL
   OR list_year IS NULL
   OR date_record IS NULL
   OR town IS NULL
   OR address IS NULL
   OR assessed_val IS NULL
   OR sale_amount IS NULL
   OR sales_ratio IS NULL
   OR property_type IS NULL;
   
   
-- 3. Which towns or regions have the highest and lowest property assessment ratios?
--This helps identify areas where assessed values are close to or far from actual sale prices.

  

-- Step 1: Find the average assessment ratio for each town
SELECT 
    town,
    ROUND(AVG(sales_ratio), 4) AS avg_sales_ratio
FROM property_sales
WHERE sales_ratio IS NOT NULL
GROUP BY town
ORDER BY avg_sales_ratio DESC;


-- The top 5 and bottom 5 towns:

WITH average_ratios AS (
    SELECT 
        town,
        ROUND(AVG(sales_ratio), 4) AS avg_sales_ratio
    FROM property_sales
    WHERE sales_ratio IS NOT NULL
    GROUP BY town
)

-- To Combine top 5 and bottom 5 towns using subqueries
SELECT * FROM (
    SELECT * FROM average_ratios
    ORDER BY avg_sales_ratio DESC
    LIMIT 5
) AS top_towns

UNION ALL

SELECT * FROM (
    SELECT * FROM average_ratios
    ORDER BY avg_sales_ratio ASC
    LIMIT 5
) AS bottom_towns;

-- Note:

-- AVG(sales_ratio):  This gives the average assessment ratio in each town.
--GROUP BY town : Groups the data so we analyze by town.
--ORDER BY ... DESC  Sorts from highest to lowest.
--LIMIT 5: Returns only the top or bottom 5 towns.

--Tax Implication Summary 
----High Ratios: People may be paying higher taxes than the home is worth (over-assessed).
----Low Ratios: People may be paying less tax than market value (under-assessed).
----This affects tax fairness and government revenue.


--Interpretation and Business Insight
--High Ratio (e.g., ≥ 0.9) Assessed value is close to or exceeds sale price
--Implication: May indicate over-assessment property owners could be overpaying property taxes.
--Low Ratio (e.g., ≤ 0.5) Assessed value is far below sale price
--Implication: Under-assessment potentially lower tax revenue for the town.




-- 4. How do property sales and prices vary by property type 
--    (e.g., singlefamily, condo, multifamily)?
--This helps stakeholders compare market activity and value trends across different property types.


SELECT 
    property_type,
    COUNT(*) AS total_sales,
    ROUND(AVG(sale_amount), 2) AS avg_sale_price,
    ROUND(MIN(sale_amount), 2) AS min_sale_price,
    ROUND(MAX(sale_amount), 2) AS max_sale_price
FROM property_sales
WHERE sale_amount IS NOT NULL AND property_type IS NOT NULL
GROUP BY property_type
ORDER BY avg_sale_price DESC;

--Explanation of the Code

--==Property_type	Groups results by property type
-- COUNT(*) AS total_sales	Counts how many properties of that type were sold
--AVG(sale_amount)	Calculates the average sale price
--MIN(sale_amount), MAX()	Shows price range within each type
--ORDER BY avg_sale_price DESC	Sorts by most expensive type first

-- Insight Ideas
--Condos may have higher average prices in city centers.
--Single Family homes may have more consistent pricing in suburbs.
--Multifamily properties may sell less often but be attractive to investors.




-- 5. What seasonal trends can be observed in real estate sales volume over the years?

-- Count sales per month across all years
SELECT 
    EXTRACT(MONTH FROM date_record)::INT AS sale_month,
    TO_CHAR(date_record, 'Month') AS month_name,
    COUNT(*) AS total_sales
FROM property_sales
WHERE date_record IS NOT NULL
GROUP BY sale_month, month_name
ORDER BY sale_month;

-- Count sales per month and year for year-over-year trends
SELECT 
    EXTRACT(YEAR FROM date_record)::INT AS sale_year,
    EXTRACT(MONTH FROM date_record)::INT AS sale_month,
    TO_CHAR(date_record, 'Month') AS month_name,
    COUNT(*) AS total_sales
FROM property_sales
WHERE date_record IS NOT NULL
GROUP BY sale_year, sale_month, month_name
ORDER BY sale_year, sale_month;


--Insights You Can Expect
--Spring/Summer (April–August) usually shows higher sales due to better weather, school transitions, and moving flexibility.
--Winter months (Dec–Feb) often have lower sales volume.
--COVID-19 or policy shifts may create unusual patterns in specific years (like 2020 or 2021).



-- 6. Is there a correlation between average property price and assessment ratio across towns?

--This helps evaluate whether higher-priced towns tend to have higher or lower assessment accuracy (i.e., how close assessed values are to actual sales).

-- Average sale price and sales ratio per town
SELECT 
    town,
    ROUND(AVG(sale_amount), 2) AS avg_sale_price,
    ROUND(AVG(sales_ratio), 4) AS avg_sales_ratio,
    COUNT(*) AS total_sales
FROM property_sales
WHERE sale_amount IS NOT NULL AND sales_ratio IS NOT NULL
GROUP BY town
ORDER BY avg_sale_price DESC;

--What the Correlation of the real market refleted
--Positive Correlation (near +1): High-priced towns also have high assessment ratios.
--Negative Correlation (near -1): High-priced towns tend to have low assessment ratios.
--Near 0: No consistent relationship.

--Business Interpretation
-- A strong negative correlation might suggest undervaluation in high-value markets (tax under-assessment).
-- A positive correlation might indicate fair assessments but could also result in higher property taxes in expensive areas.


-- 7. Which property types are consistently over- or under-assessed relative to their market values?

-- Compare assessed value and sale amount per property type
SELECT 
    property_type,
    COUNT(*) AS total_sales,
    ROUND(AVG(assessed_val), 2) AS avg_assessed_value,
    ROUND(AVG(sale_amount), 2) AS avg_sale_price,
    ROUND(AVG(assessed_val)::numeric / NULLIF(AVG(sale_amount), 0), 4) AS assessment_ratio
FROM property_sales
WHERE assessed_val IS NOT NULL AND sale_amount IS NOT NULL AND property_type IS NOT NULL
GROUP BY property_type
ORDER BY assessment_ratio DESC;


-- Interpretation
--assessment_ratio > 1.0  Over-assessed (assessed value > market value)
--assessment_ratio < 1.0  Under-assessed (assessed value < market value)

--Business Insights
--If Multi-Family homes consistently have a lower ratio, they may be under-assessed 
--(leading to lower taxes).

--If Single Family homes have higher ratios, they may be more accurately assessed or 
-- over-assessed, impacting homeowners' property tax burden.


--8. How does the distribution of property types impact the overall property tax base and 
--what is the effective property tax burden across different states or counties based on assessment ratios?

--Goal:
--Understand which property types contribute most to the total assessed value, which affects municipal tax revenue.


--PART 1: How does the distribution of property types impact the overall property tax base?

---- Distribution of property types and their contribution to the tax base
SELECT 
    property_type,
    COUNT(*) AS total_properties,
    ROUND(SUM(assessed_val), 2) AS total_assessed_value,
    ROUND(SUM(assessed_val) * 100.0 / SUM(SUM(assessed_val)) OVER (), 2) AS percent_of_tax_base
FROM property_sales
WHERE assessed_val IS NOT NULL AND property_type IS NOT NULL
GROUP BY property_type
ORDER BY percent_of_tax_base DESC;

--Interpretation:
--Single Family homes dominate the tax base, so changes in their assessment directly affect town revenue.

--Condo-heavy towns may have smaller tax bases but higher density.

--If one property type is under-assessed, it shifts the burden to others.


--PART 2: What is the effective property tax burden across different states or counties based on assessment ratios?

--Goal:
--Estimate effective tax burden: how much tax owners pay relative to actual market value, not just assessed value.

-- Estimate effective tax burden across towns using assessment ratios
SELECT 
    town AS region,
    ROUND(AVG(assessed_val), 2) AS avg_assessed_value,
    ROUND(AVG(sale_amount), 2) AS avg_market_value,
    ROUND(AVG(assessed_val)::numeric / NULLIF(AVG(sale_amount), 0), 4) AS effective_ratio,
    COUNT(*) AS total_sales
FROM property_sales
WHERE assessed_val IS NOT NULL AND sale_amount IS NOT NULL
GROUP BY town
ORDER BY effective_ratio DESC;

--Higher effective ratio (e.g., 0.90) i.e More of the market value is taxed higher burden

--Lower ratio (e.g., 0.50) i.e Under-assessment lower tax burden


--Tax Equity Implications
--Uneven ratios between towns or counties Leads to inequitable tax burdens

--Under-assessment in wealthier areas may result in revenue gaps or unfair burdens on lower-income areas

--Policy can target standardizing reassessments or capping disparities




-- 9. Which months or seasons consistently show the highest sales activity, and what factors contribute to this pattern?


-- Step 1: Monthly Sales Activity

-- Total number of sales per calendar month (across all years)
SELECT 
    EXTRACT(MONTH FROM date_record)::INT AS sale_month,
    TO_CHAR(date_record, 'Month') AS month_name,
    COUNT(*) AS total_sales
FROM us_real_estate_sales
WHERE date_record IS NOT NULL
GROUP BY sale_month, month_name


--Step 2: Group Months into Seasons

-- Group sales by season
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM date_record) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM date_record) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM date_record) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM date_record) IN (9, 10, 11) THEN 'Fall'
    END AS season,
    COUNT(*) AS total_sales
FROM property_sales
WHERE date_record IS NOT NULL
GROUP BY season
ORDER BY total_sales DESC;


--Factors Contributing to Seasonal Patterns

--School Calendar	Families prefer to move in summer before school resumes.
--Weather Conditions	Easier to inspect, move, and renovate in warm months.
--Holidays/Winter	Distractions and harsh weather reduce listings and sales.
--Market Strategy	Sellers list in spring/summer to attract more buyers.

--Summary Insight
--"Sales activity peaks in Spring and Summer, especially in May–July, due to favorable weather, family relocation timing, and increased inventory. Winter months show the lowest activity due to holidays and weather."




