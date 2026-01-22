-- Performance analysis
-- Comparing the current value to a target value
-- There seems to be a lot of product is sold within one year only
-- there are quite a lot of 'No Change' results for the year on year analysis for the 'avg_change' flag column 
-- The same is true for the avg_change column, the majority of the product average and total matches the same
-- When viewing the metrics by brand, we can see a disctinct increase in sales from 2018 to 2019
-- The year on year sales were much higher for the Nike brand in terms of growth from 2018 to 2019
-- This suggests that there could be room for increased sales for the Nike brand in the future
-- The year on year drop significantly from 2019 to 2020 but this is to be expected as the data stops at March


-- By product
WITH yearly_product_sales AS (
	SELECT
		YEAR(f.visit_date) AS visit_year,
		p.product_name,
		SUM(f.revenue) AS total_revenue
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE f.visit_date IS NOT NULL
	GROUP BY 
		YEAR(f.visit_date),
		p.product_name
	)

SELECT 
	visit_year,
	product_name,
	total_revenue,
	AVG(total_revenue) OVER (PARTITION BY product_name) AS avg_sales,
	total_revenue - AVG(total_revenue) OVER (PARTITION BY product_name) AS diff_avg, 
	CASE WHEN total_revenue - AVG(total_revenue) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN total_revenue - AVG(total_revenue) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END avg_change,
	-- Year-over-year Analysis
	LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY visit_year) AS py_sales,
	total_revenue - LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY visit_year) AS diff_py,
	CASE WHEN total_revenue - LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY visit_year)  > 0 THEN 'Increase'
		 WHEN total_revenue - LAG(total_revenue) OVER (PARTITION BY product_name ORDER BY visit_year)  < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END py_change
FROM yearly_product_sales
WHERE product_name IS NOT NULL
ORDER BY product_name, visit_year;

-- By brand
WITH yearly_product_sales AS (
	SELECT
		YEAR(f.visit_date) AS visit_year,
		p.brand,
		SUM(f.revenue) AS total_revenue
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE f.visit_date IS NOT NULL
	GROUP BY 
		YEAR(f.visit_date),
		p.brand
	)

SELECT 
	visit_year,
	brand,
	total_revenue,
	AVG(total_revenue) OVER (PARTITION BY brand) AS avg_sales,
	total_revenue - AVG(total_revenue) OVER (PARTITION BY brand) AS diff_avg, 
	CASE WHEN total_revenue - AVG(total_revenue) OVER (PARTITION BY brand) > 0 THEN 'Above Avg'
		 WHEN total_revenue - AVG(total_revenue) OVER (PARTITION BY brand) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END avg_change,
	-- Year-over-year Analysis
	LAG(total_revenue) OVER (PARTITION BY brand ORDER BY visit_year) AS py_sales,
	total_revenue - LAG(total_revenue) OVER (PARTITION BY brand ORDER BY visit_year) AS diff_py,
	CASE WHEN total_revenue - LAG(total_revenue) OVER (PARTITION BY brand ORDER BY visit_year)  > 0 THEN 'Increase'
		 WHEN total_revenue - LAG(total_revenue) OVER (PARTITION BY brand ORDER BY visit_year)  < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END py_change
FROM yearly_product_sales
WHERE brand IS NOT NULL
ORDER BY brand, visit_year
