/* Segment products into cost ranges and 
count how many products fall into each segment

When exploring the data, it could be seen that there were a lot of products listed
as 0.00 for the price
*/

-- 2766 rows where listing price is greater than 0
-- Compared to 3179
/* 
SELECT COUNT(*) AS positive_price_rows
FROM gold.fact_sales
WHERE listing_price > 0;
*/

-- 354 products which are listed as 0 for price
/*
SELECT COUNT(*) AS zero_price_rows
FROM gold.fact_sales
WHERE listing_price = 0
*/

/*
The highest cartegory for sales is between 50-100 taking more than
50% of the sales. There are few products that are sold above 150
Which is roughly 6% of all the products sold.
*/

WITH product_segments AS (
SELECT
p.product_key,
p.product_name,
p.brand,
s.listing_price,
CASE WHEN listing_price < 50 THEN 'Below 50'
	 WHEN listing_price BETWEEN 50 AND 100 THEN '50-100'
	 WHEN listing_price BETWEEN 100 AND 150 THEN '100-150'
	 ELSE 'over 150'
END AS cost_range
FROM gold.dim_products AS p
LEFT JOIN gold.fact_sales AS s
ON p.product_key = s.product_key
WHERE listing_price != 0)

SELECT
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC
