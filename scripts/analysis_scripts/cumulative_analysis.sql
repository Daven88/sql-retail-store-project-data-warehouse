-- Cumulative Analysis

-- Calculate the total sales per month
-- and the running total of sales over time
-- The sales seem to increase during the second year. However, the third year seemed be similar to the first year
-- showing that the sales have stagnated/declined
SELECT
	visit_month,
	total_revenue,
	SUM(total_revenue) OVER (PARTITION BY visit_year ORDER BY visit_month) AS running_total_revenue
-- window function
FROM (
	SELECT
		YEAR(visit_date) AS visit_year,
		DATETRUNC(month, visit_date) AS visit_month,
		SUM(revenue) AS total_revenue
	FROM gold.fact_sales
	WHERE visit_date IS NOT NULL
	GROUP BY 
		YEAR(visit_date),
		DATETRUNC(month, visit_date)
) t

-- Showing the moving average of sale price for each year compared to the total revenue
SELECT
	visit_month,
	total_revenue,
	SUM(total_revenue) OVER (ORDER BY visit_month) AS running_total_revenue,
	ROUND(AVG(average_sale_price) OVER (ORDER BY visit_month), 2) AS moving_average_price
-- window function
FROM (
	SELECT
		DATETRUNC(YEAR, visit_date) AS visit_month,
		SUM(revenue) AS total_revenue,
		AVG(sale_price) AS average_sale_price
	FROM gold.fact_sales
	WHERE visit_date IS NOT NULL
	GROUP BY 
		YEAR(visit_date),
		DATETRUNC(YEAR, visit_date)
) t
