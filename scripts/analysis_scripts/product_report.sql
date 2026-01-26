/*
===================================================================================
Product Report
===================================================================================
Purpose:
	- This report consolidates key product metrics and behaviours.

Highlights:
	1. Gathers essential fields such as product name, brand, description and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
===================================================================================
*/
IF OBJECT_ID('gold.report_products','V') IS NOT NULL
	DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH base_query AS (
/*---------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------------*/
SELECT
	p.product_key,
	p.brand,
	p.product_name,
	p.description,
	f.listing_price,
	f.sale_price,
	f.discount,
	f.rating,
	f.revenue,
	f.visit_date
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
WHERE listing_price != 0)
, product_aggregation AS (
/*---------------------------------------------------------------------------------
2) Product Aggregations: Summarises key metrics at the product level
---------------------------------------------------------------------------------*/
SELECT 
	product_key,
	product_name,
	brand,
	rating,
	revenue,
	description,
	COUNT(DISTINCT product_key) AS total_products,
	SUM(revenue) AS total_sales,
	SUM(rating) AS total_rating,
	MAX(visit_date) AS last_order_date
FROM base_query
GROUP BY 
	product_key,
	product_name,
	brand,
	rating,
	revenue,
	description
)
SELECT
	product_key,
	brand,
	product_name,
	total_products,
	total_sales,
	CASE WHEN total_sales < 500 THEN 'Under 500'
		 WHEN total_sales between 500 and 1000 THEN '500-1000'
		 WHEN total_sales between 1000 and 2000 THEN '1000-2000'
		 WHEN total_sales between 2000 and 5000 THEN '2000-5000'
		 WHEN total_sales between 5000 and 10000 THEN '5000-1000'
	ELSE '10000 and above'
	END AS revenue_class,
	total_rating,
	last_order_date,
	DATEDIFF (month, last_order_date, GETDATE()) -60 AS recency,
	description
FROM product_aggregation
