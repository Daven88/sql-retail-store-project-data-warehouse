/*
=====================================================================================
DDL SCRIPT: Create Gold Views
=====================================================================================
Script Purpose:
	This script creates views for the Gold layer in the data warehouse.
	This Gold Layer represents the final dimension and fact tables (Star Schema)

	Each view performs transformations and combines data from the Silver layer
	to product a clean, enriched and business ready datasets.

Usage:
	- These views can be queried directly for analytics and reporting.
=====================================================================================
*/

-- ==================================================================================
-- Create Dimension: gold.dim_products
--===================================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY b.product_id) AS product_key, --Surrogate Key
	b.product_id,
	b.brand,
	i.product_name,
	i.description
FROM silver.brands as b
LEFT JOIN silver.info as i
ON b.product_id = i.product_id;
GO

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT 
	p.product_key, -- surrogate key created in gold.dim table
	f.listing_price,
	f.sale_price,
	f.discount,
	f.revenue,
	r.rating,
	r.review_count,
	t.last_visited,
	YEAR(t.last_visited) AS visit_year,
	MONTH(t.last_visited) AS visit_month,
	CAST(t.last_visited AS DATE) AS visit_date
FROM silver.finance AS f
LEFT JOIN gold.dim_products AS p
ON f.product_id = p.product_id
LEFT JOIN silver.reviews AS r
ON f.product_id = r.product_id
LEFT JOIN silver.traffic AS t
ON f.product_id = t.product_id;
GO
