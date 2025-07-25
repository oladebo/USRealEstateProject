## US Government Real Estate Records Analysis project

Welcome to my project on analyzing US Government Real Estate Records, where I combined data analytics, SQL querying (PostgreSQL), and dashboard storytelling to derive actionable insights into the property sales assessment ratios across U.S. towns.


## Project Overview
This project investigates patterns in real estate records using a dataset of 57,966 property transactions. I built an interactive dashboard (in Excel) and used PostgreSQL to answer complex business questions related to:

- Market value vs. assessed value

- Property type distributions

- Seasonal sales trends

- Town-level valuation inconsistencies

The goal is to help policy makers, real estate investors, and local governments understand the implications of under-assessment on tax revenue and identify where corrective measures may be necessary.

## Business Questions Addressed
- 1. Which towns or regions have the highest and lowest property assessment ratios? Why might these differences exist, and what are their tax implications?
- 2. How do property sales and prices vary by property type (e.g., single family, condo, multi family)?
- 3. What seasonal trends can be observed in real estate sales volume over the years?
- 4. Is there a correlation between average property price and assessment ratio across towns?
- 5. Which property types are consistently over- or under-assessed relative to their market values?
- 6. How does the distribution of property types impact the overall property tax base and What is the effective property tax burden across different states or counties based on    assessment ratios?
- 7. Which months or seasons consistently show the highest sales activity, and what factors contribute to this pattern?


## Tools & Technologies
- SQL: PostgreSQL for querying, cleaning, and extracting insights
- Excel: For building a clean and engaging dashboard

  
## Key Insight
- Single Family properties make up over 70% of all sales, but their assessment ratios vary significantly.
- Several towns (e.g., Waterbury) show assessment ratios well below 0.5, indicating major undervaluation.
- Real estate transactions consistently peak in August and September.
- The average property price was $481,018, while the average sales ratio was only 0.573, suggesting many properties are taxed on values below market reality.


- Before bring in the Business question we first fron csv file of property_sales dataset by import dataset into postress sql database i.e property_sales_db 
including schema adataset file and below is the sql for creating the dataset datatype columns accordingly.


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

### Below are some of the business quetion and answer.
  
## US Real Government Analysis Record Business Question:

-- 1. Count of NULLs per column
-- 2. Find all rows with at least one NULL
-- 3. Which towns or regions have the highest and lowest property assessment ratios? Why might these differences exist, and what are their tax implications?
-- 4. How do property sales and prices vary by property type (e.g., single family, condo, multi family)?
-- 5. What seasonal trends can be observed in real estate sales volume over the years?
-- 6. Is there a correlation between average property price and assessment ratio across towns?
-- 7. Which property types are consistently over- or under-assessed relative to their market values?
-- 8. How does the distribution of property types impact the overall property tax base and What is the effective property tax burden across different states or counties based on assessment ratios?
-- 9. Which months or seasons consistently show the highest sales activity, and what factors contribute to this pattern?



SELECT * FROM property_sales;

- 1: Count of NULLs per column


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

- 2: Find all rows with at least one NULL


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
   
   
### Contact:
Email Address:oladebo_ayanniyi@yahoo.com
Linked:https://www.linkedin.com/in/oladeboayanniyi/
Github:https://github.com/oladebo?tab=repositories

  

