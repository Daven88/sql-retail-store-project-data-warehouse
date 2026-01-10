/* 
============================================================================================================
Stored Procedure: Load Silver Layer (Source -> Silver)
============================================================================================================
Script Purpose:
	This stored procedure loads data into the 'silver' schema from the 'bronze' schema.
	It performs the following actions:
	- Truncates the silver tables before loading data.
	- Inserts transformed and cleaned data from the Bronze layer into Silver tables.

Parameters:
	None.
	This stored procedure does not accept any parameters or return any values.

Usage Example:
	EXEC silver.load_silver;
============================================================================================================
*/


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
	SET @batch_start_time = GETDATE();
		PRINT '==============================================================================================';
		PRINT 'Loading Silver Layer';
		PRINT '==============================================================================================';

		PRINT '----------------------------------------------------------------------------------------------';
		PRINT 'Loading Tables';
		PRINT '----------------------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.brand';
		TRUNCATE TABLE silver.brands;

		PRINT'>> Inserting Data Into: silver.brand';
		INSERT INTO silver.brands (product_id, brand)
		SELECT
			product_id,
			CASE
				WHEN TRIM(brand) IN ('', 'None', 'NULL', 'null', 'N/A') THEN NULL
				ELSE TRIM(brand)
			END AS brand
		FROM bronze.brands
		WHERE product_id IS NOT NULL;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.finance';
		TRUNCATE TABLE silver.finance;
		PRINT'>> Inserting Data Into: silver.finance';
		INSERT INTO silver.finance (product_id, listing_price, sale_price, discount, revenue)
		SELECT
			product_id,
			TRY_CAST(CASE 
						WHEN listing_price IS NULL THEN NULL
						WHEN TRIM(listing_price) IN ('', 'None', 'NULL', 'null', 'N/A') THEN NULL
						ELSE TRIM(listing_price)
						END
						AS DECIMAL(10,2)) AS listing_price,
			TRY_CAST(CASE 
						WHEN sale_price IS NULL THEN NULL
						WHEN TRIM(sale_price) IN ('', 'None', 'NULL', 'null', 'N/A') THEN NULL
						ELSE TRIM(sale_price)
						END
						AS DECIMAL(10,2)) AS sale_price,
			TRY_CAST(CASE 
						WHEN discount IS NULL THEN NULL
						WHEN TRIM(discount) IN ('', 'None', 'NULL', 'null', 'N/A') THEN NULL
						ELSE TRIM(discount)
						END
						AS DECIMAL(6,2)) AS discount,
			TRY_CAST(CASE 
						WHEN revenue IS NULL THEN NULL
						WHEN TRIM(revenue) IN ('', 'None', 'NULL', 'null', 'N/A') THEN NULL
						ELSE TRIM(revenue)
						END
						AS DECIMAL(12,2)) AS revenue
		FROM bronze.finance
		WHERE product_id IS NOT NULL
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.info';
		TRUNCATE TABLE silver.info;
		PRINT'>> Inserting Data Into: silver.info';
		INSERT INTO silver.info (product_id, product_name, description)
		SELECT
			product_id,
			UPPER(	
				COALESCE(
					NULLIF(NULLIF(TRIM(product_name), ''), 'None'),
					NULLIF(NULLIF(TRIM(modified_product_name), ''), 'None')
				)
			) AS product_name,
			UPPER(
				COALESCE(
					NULLIF(NULLIF(TRIM(modified_description), ''), 'None'),
					NULLIF(NULLIF(TRIM(description), ''), 'None')
				)
			) AS description
		FROM bronze.info
		WHERE product_id IS NOT NULL;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.reviews';
		TRUNCATE TABLE silver.reviews;
		PRINT'>> Inserting Data Into: silver.reviews';
		INSERT INTO silver.reviews (product_id, rating, review_count)
		SELECT 
			product_id,
			TRY_CAST(Hour AS DECIMAL(3,1)) AS rating,
			TRY_CAST(REPLACE(real_reviews, '"', '') AS INT) AS review_count
		FROM bronze.reviews
		WHERE product_id IS NOT NULL
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.traffic';
		TRUNCATE TABLE silver.traffic;
		PRINT'>> Inserting Data Into: silver.traffic';
		INSERT INTO silver.traffic (product_id, last_visited)
		SELECT 
			product_id,
			TRY_CAST(last_visited AS DATETIME2) AS last_visited
		FROM bronze.traffic
		WHERE product_id IS NOT NULL
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '------------------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '================================================';
		PRINT ' Loading Silver Layer has been Completed';
		PRINT '		- Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '================================================';
	END TRY
	BEGIN CATCH
		PRINT '================================================';
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================================';
	END CATCH	
END
