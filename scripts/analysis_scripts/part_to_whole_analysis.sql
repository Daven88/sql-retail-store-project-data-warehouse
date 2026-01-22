/* Part to Whole Analysis

Analyse how an individual part is performing compared to the overall, 
allowing us to understand which category has the greatest impact on the business

We can see clearly that the Addidas brand is doing the heavy lifting for this particular business

It would be recomended to the business on focussing on restocking this particular brand as 
Addidas accounts for more than 93% of the total revenue

*/
WITH product_sales AS (
SELECT 
product_name,
SUM(revenue) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
GROUP BY product_name
)

SELECT 
product_name,
total_revenue,
CONCAT(ROUND((total_revenue / SUM(total_revenue) OVER ()) * 100, 2), '%') AS percentage_of_total
FROM product_sales
ORDER BY total_revenue DESC;

WITH brand_sales AS (
SELECT 
brand,
SUM(revenue) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
WHERE brand IS NOT NULL
GROUP BY brand
)

SELECT 
brand,
total_revenue,
SUM(total_revenue) OVER (),
CONCAT(ROUND((total_revenue / SUM(total_revenue) OVER ()) * 100, 2), '%') AS percentage_of_total
FROM brand_sales
ORDER BY total_revenue DESC
