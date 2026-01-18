-- Changes Over Time
--Changes over years: High level overview insights that help with strategic decision making

SELECT
  YEAR(visit_date) AS order_year,
  SUM(revenue) AS total_sales,
  COUNT(revenue) AS count_sales,
  SUM(review_count) AS customer_reviews
FROM gold.fact_sales
WHERE visit_date IS NOT NULL
GROUP BY YEAR(visit_date)
ORDER BY YEAR(visit_date)

--Changes over months: Detailed insight to discover the sales for different seasons for this business
--Interestingly the best months for sales are March, February and January which does not allign with Christmas

SELECT
  MONTH(visit_date) AS order_year,
  SUM(revenue) AS total_sales,
  COUNT(revenue) AS count_sales,
  SUM(review_count) AS customer_reviews
FROM gold.fact_sales
WHERE visit_date IS NOT NULL
GROUP BY MONTH(visit_date)
ORDER BY MONTH(visit_date)

-- Further monitoring of revenue over time here we can see the performance of the company over each month for each year.
-- Upon further inspection, it can be observed that the there were only four months recorded in 2020 which explains 
-- why there was more revenue in Jan, Feb and March.

SELECT
  DATETRUNC(MONTH, visit_date) AS order_date,
  SUM(revenue) AS total_sales,
  COUNT(revenue) AS count_sales,
  SUM(review_count) AS customer_reviews
FROM gold.fact_sales
WHERE visit_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, visit_date)
ORDER BY DATETRUNC(MONTH, visit_date)

-- Repeat the season measurements disregarding 2020
-- The strongest performing months looks to be around Aug - October.
-- The second largest sales were in December, but there must have been a sale as the revenue was average compared to other 
-- months.
SELECT
  MONTH(visit_date) AS order_year,
  SUM(revenue) AS total_sales,
  COUNT(revenue) AS count_sales,
  SUM(review_count) AS customer_reviews
FROM gold.fact_sales
WHERE visit_date IS NOT NULL AND visit_date < '2020-01-01'
GROUP BY MONTH(visit_date)
ORDER BY MONTH(visit_date)
