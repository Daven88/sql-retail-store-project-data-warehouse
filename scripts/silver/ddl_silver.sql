/* 
================================================================================
DDL Script: Create Silver Tables
================================================================================
Script Purpose:
	This script creates tables in the 'silver' schema,  dropping existing tables
	if they already exist.
	Run this script to re-define the DDL structure of 'silver' Tables
================================================================================
*/

IF OBJECT_ID ('silver.brands', 'U') IS NOT NULL 
	DROP TABLE silver.brands;
CREATE TABLE silver.brands (
	product_id NVARCHAR(50),
	brand NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.finance', 'U') IS NOT NULL
	DROP TABLE silver.finance;
CREATE TABLE silver.finance (
	product_id NVARCHAR(50),
	listing_price DECIMAL(10,2),
	sale_price DECIMAL(10,2),
	discount DECIMAL(6,4),
	revenue DECIMAL(10,2),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.info', 'U') IS NOT NULL
	DROP TABLE silver.info;
CREATE TABLE silver.info (
	product_id NVARCHAR(50),
	product_name NVARCHAR(MAX),
	description NVARCHAR(MAX),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.reviews', 'U') IS NOT NULL
	DROP TABLE silver.reviews;
CREATE TABLE silver.reviews (
	product_id NVARCHAR(50),
	rating DECIMAL(3,1),
	review_count INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.traffic', 'U') IS NOT NULL
	DROP TABLE silver.traffic;
CREATE TABLE silver.traffic (
	product_id NVARCHAR(50),
	last_visited DATETIME2,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
