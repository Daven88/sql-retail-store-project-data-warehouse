/* 
================================================================================
DDL Script: Create Bronze Tables
================================================================================
Script Purpose:
	This script creates tables in the 'bronze' schema,  dropping existing tables
	if they already exist.
	Run this script to re-define the DDL structure of 'bronze' Tables
================================================================================
*/

IF OBJECT_ID ('bronze.brands', 'U') IS NOT NULL 
	DROP TABLE bronze.brands;
CREATE TABLE bronze.brands (
	product_id NVARCHAR(50),
	brand NVARCHAR(50),
	modified_brand NVARCHAR(50)
);

IF OBJECT_ID ('bronze.finance', 'U') IS NOT NULL
	DROP TABLE bronze.finance;
CREATE TABLE bronze.finance (
	product_id NVARCHAR(50),
	listing_price DECIMAL(10,2),
	sale_price DECIMAL(10,2),
	discount DECIMAL(6,4),
	revenue DECIMAL(10,2),
	modified_listing_price DECIMAL(10,2),
	modified_sale_price DECIMAL(10,2),
	modified_discount DECIMAL(6,4),
	modified_revenue DECIMAL(10,2)
);

IF OBJECT_ID ('bronze.info', 'U') IS NOT NULL
	DROP TABLE bronze.info;
CREATE TABLE bronze.info (
	product_name NVARCHAR(255),
	product_id NVARCHAR(50),
	description NVARCHAR(MAX),
	modified_product_name NVARCHAR(255),
	modified_description NVARCHAR(MAX)
);

IF OBJECT_ID ('bronze.reviews', 'U') IS NOT NULL
	DROP TABLE bronze.reviews;
CREATE TABLE bronze.reviews (
	product_id NVARCHAR(50),
	rating NVARCHAR(50),
	reviews NVARCHAR(50),
	Hour INT,
	minute INT,
	real_rating NVARCHAR(50),
	real_reviews INT,
	unnamed_7 NVARCHAR(50)
);

IF OBJECT_ID ('bronze.traffic', 'U') IS NOT NULL
	DROP TABLE bronze.traffic;
CREATE TABLE bronze.traffic (
	product_id NVARCHAR(50),
	last_visited DATETIME,
	modified_last_visited DATETIME
);
