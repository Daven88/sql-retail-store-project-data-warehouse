/*
==========================================================
Create Database and Schemas
==========================================================
Script Purpose:
    This script creates a new database named 'DataWareHouse_Project_Retail' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
    within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWareHouse_Project_Retail' database is it exists.
    All data in the database will be permanently deleted. Proceed with caution and ensure you have 
    proper backups before running the script.
*/

USE master;
GO 

-- Drop and recreate the 'DataWareHouse_Project_Retail' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWareHouse_Project_Retail')
BEGIN
    ALTER DATABASE DataWareHouse_Project_Retail SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWareHouse_Project_Retail;
END;
GO

-- Create the 'DataWareHouse_Project_Retail' database
CREATE DATABASE DataWarehouse_Project_Retail;
GO
  
USE DataWarehouse_Project_Retail;
GO

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
