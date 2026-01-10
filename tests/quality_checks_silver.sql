/* 
=======================================================================================
Quality Checks
=======================================================================================
Script Purpose:
    This script performs various quality checks for data consistency and 
    standardisation across the Silver layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in sting fields.
    - Data standardisation and consistency.

Usage notes:
    - Run these checks after data loading Silver layer.
    - Investigate and resolve any discrepencies found during the checks.
=======================================================================================
*/

-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result

SELECT 
product_id, 
COUNT(*) 
FROM silver.brands
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL

SELECT
product_id,
COUNT(*)
FROM silver.finance
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL

SELECT 
product_id,
COUNT(*)
FROM silver.info
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL

SELECT 
product_id,
COUNT(*)
FROM silver.reviews
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL

SELECT
product_id,
COUNT(*)
FROM silver.traffic
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL


-- Check for unwanted Spaces
SELECT 
product_id,
brand
FROM silver.brands
WHERE brand != TRIM(brand) 

SELECT 
product_id,
product_name,
description
FROM
silver.info
WHERE 
product_name != TRIM(product_name) 
OR description != TRIM(description)

-- Data Standardisation & Consistency
SELECT DISTINCT brand
FROM silver.brands

