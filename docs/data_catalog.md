# Data Catolog for Gold Layer

## Overview
The Gold Layer is the business level data representation, structured to support analytical and reporting use cases. It consists of
**dimension tables** and **fact tables** for specific business metrics.

---

### 1. **gold.dim_products**
- **Purpose:** Stores product details enriched with technical infomration for each product
- **Columns:**

| Column Name        | Data Type         | Description                                                                        |
|--------------------|-------------------|------------------------------------------------------------------------------------|
| product_key        | INT               | A Surrogate Key uniquely identifying every product record in the dimension table.  |
| product_id         | NVARCHAR(50)      | An alphanumeric Natural key assigned to each product.                              |
| brand              | NVARCHAR(50)      | The brand of each product (e.g. Addidas).                                          |
| product_name       | NVARCHAR(50)      | The full name for each product.                                                    |
| description        | NVARCHAR(MAX)     | A detailed description for each product.                                           |

---

### 3. **gold.fact_sales**
- **Purpose:** Stores transactional sales data for analytical purposes.
- **Columns:**

| Column Name       | Data Type          | Description                                                                        |
|-------------------|--------------------|------------------------------------------------------------------------------------|
| product_key       | INT                | A Surrogate Key uniquely linking the sale to the product table.                    |
| listing_price     | DECIMAL(10,2)      | The listing price for each product (e.g. 76.00).                                   |
| sale_price        | DECIMAL(10,2)      | The sale price for each product after applying the discount.                       |
| discount          | DECIMAL(6,4)       | The discount applied to each product.                                              |
| revenue           | DECIMAL(10,2)      | The amount of money the product has generated (price * units sold).                |
| rating            | DECIMAL(3,1)       | The rating score for each product from the customer.                               |
| review_count      | INT                | The number of reviews for each product.                                            |
| last_visit        | DATETIME           | The last time the product was visited by a customer on the website.                |
