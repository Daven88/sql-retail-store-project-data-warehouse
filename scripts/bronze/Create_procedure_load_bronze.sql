/* 
============================================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
============================================================================================================
Script Purpose:
	This stored procedure loads data into the 'bronze' schema from external CSV files.
	It performs the following actions:
	- Truncates the bronze tables before loading data.
	- Uses the 'BULK INSERT' command to load data from csv files to bronze tables.

Parameters:
	None.
	This stored procedure does not accept any parameters or return any values.

Usage Example:
	EXEC bronze.load_bronze;
============================================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
	SET @batch_start_time = GETDATE();
		PRINT '=============================================================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=============================================================================================';
	
		PRINT '---------------------------------------------------------------------------------------------';
		PRINT 'Loading Tables';
		PRINT '---------------------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.brands';
		TRUNCATE TABLE bronze.brands;

		PRINT '>> Inserting Data into: bronze.brands';
		BULK INSERT bronze.brands
		FROM 'C:\Users\User\OneDrive\Documents\Data storage\SQL\SQL_Retail_Store_Database\datasets\brands.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.finance';
		TRUNCATE TABLE bronze.finance;

		PRINT '>> Inserting Data into: bronze.finance';
		BULK INSERT bronze.finance
		FROM 'C:\Users\User\OneDrive\Documents\Data storage\SQL\SQL_Retail_Store_Database\datasets\finance.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.info';
		TRUNCATE TABLE bronze.info;

		PRINT '>> Inserting Data: bronze.info';
		BULK INSERT bronze.info
		FROM 'C:\Users\User\OneDrive\Documents\Data storage\SQL\SQL_Retail_Store_Database\datasets\info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.reviews';
		TRUNCATE TABLE bronze.reviews;

		PRINT '>> Inserting Data: bronze.reviews';
		BULK INSERT bronze.reviews
		FROM 'C:\Users\User\OneDrive\Documents\Data storage\SQL\SQL_Retail_Store_Database\datasets\reviews.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.traffic';
		TRUNCATE TABLE bronze.traffic;

		PRINT '>> Inserting Data: bronze.traffic';
		BULK INSERT bronze.traffic
		FROM 'C:\Users\User\OneDrive\Documents\Data storage\SQL\SQL_Retail_Store_Database\datasets\traffic.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '================================================';
		PRINT ' Loading Bronze Layer has been Completed';
		PRINT '		- Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '================================================';
	END TRY
	BEGIN CATCH
		PRINT '================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================================';
	END CATCH
END
