import pandas as pd
import pyodbc

conn = pyodbc.connect(
    'Driver={SQL Server};'
    'server=localhost\\SQLEXPRESS;'
    'database=DataWarehouse_Project_Retail;'
    'trusted_connection=yes;'
)

query = """
SELECT 
    product_name,
    description,
    total_rating
FROM gold.report_products
"""

df = pd.read_sql(query, conn)

conn.close()

print(df.head())
