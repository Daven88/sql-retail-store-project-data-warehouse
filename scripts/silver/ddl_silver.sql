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
	modified_brand NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.finance', 'U') IS NOT NULL
	DROP TABLE silver.finance;
CREATE TABLE silver.finance (
	product_id NVARCHAR(50),
	listing_price NVARCHAR(50),
	sale_price NVARCHAR(50),
	discount NVARCHAR(50),
	revenue NVARCHAR(50),
	modified_listing_price NVARCHAR(50),
	modified_sale_price NVARCHAR(50),
	modified_discount NVARCHAR(50),
	modified_revenue NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.info', 'U') IS NOT NULL
	DROP TABLE silver.info;
CREATE TABLE silver.info (
	product_name NVARCHAR(MAX),
	product_id NVARCHAR(50),
	description NVARCHAR(MAX),
	modified_product_name NVARCHAR(MAX),
	modified_description NVARCHAR(MAX),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.reviews', 'U') IS NOT NULL
	DROP TABLE silver.reviews;
CREATE TABLE silver.reviews (
	product_id NVARCHAR(50),
	rating NVARCHAR(50),
	reviews NVARCHAR(50),
	Hour NVARCHAR(50),
	minute NVARCHAR(50),
	real_rating NVARCHAR(50),
	real_reviews NVARCHAR(50),
	unnamed_7 NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.traffic', 'U') IS NOT NULL
	DROP TABLE silver.traffic;
CREATE TABLE silver.traffic (
	product_id NVARCHAR(50),
	last_visited NVARCHAR(50),
	modified_last_visited NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
