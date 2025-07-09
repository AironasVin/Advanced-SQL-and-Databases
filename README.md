# Advanced SQL and Databases
## Main objective
Main objective is to implement more advanced SQL queries solving various business questions and exploring the Adventureworks 2005 database in BigQuery.
## Database

# Tasks

## 1. An Overview of Customers
#### 1.1. Overview of all individual customers

You've been tasked with creating a detailed overview of all individual customers. Individual customers are defined by `CustomerType = 'I'` and/or are stored in the individual customer table.

The output should include the following columns:

**Column List:** `CustomerId`, `FirstName`, `LastName`, `FullName`,  
`addressing_title`, `Email`, `Phone`, `AccountNumber`, `CustomerType`, `City`,  
`State`, `Country`, `Address`, `NumberOfOrders`, `TotalAmountWithTax`,  
`LastOrderDate`

**Solution:** [1.1. Query](https://github.com/AironasVin/Advanced-SQL-and-Databases/blob/main/1.1.%20query.sql)
<br>

#### 1.2. Add top 200 highest-value customers with no orders in the last 365 days.
The business found the original query valuable and now wants to extend it. Specifically, they need the data for the top 200 customers with the highest total amount (including tax) who have not placed an order in the last 365 days.

**Solution:** [1.2. Query](https://github.com/AironasVin/Advanced-SQL-and-Databases/blob/main/1.2.%20query.sql)
<br>

#### 1.3. Add an `Active/Inactive` flag (based on orders in the last 365 days) and return the top 500 rows ordered by `CustomerId` descending.
Enhance your original 1.1 SELECT by adding a new column that flags customers as Active or Inactive, based on whether they have placed an order within the last 365 days.

Return only the top 500 rows, ordered by `CustomerId` in descending order.

**Solution:** [1.3. Query](https://github.com/AironasVin/Advanced-SQL-and-Databases/blob/main/1.3.%20query.sql)
<br>

#### 1.4. Return all active customers from North America with either total amount (with tax) ≥ 2500 or 5+ orders.  
The business requires data on all active customers from North America. Only include customers who meet either of the following criteria:

- Total amount (with tax) is no less than 2500, or
- They have placed 5 or more orders.
Additionally, split the customers' address into two separate columns in the output.

**Solution:** [1.4. Query](https://github.com/AironasVin/Advanced-SQL-and-Databases/blob/main/1.4.%20query.sql)
<br>

# 2. Reporting Sales Numbers

#### 2.1. Monthly sales figures by Country and Region 
Create a query to report monthly sales figures by Country and Region. For each month, include:

- Number of orders
- Number of unique customers
- Number of salespersons
- Total amount (with tax) earned

**Solution:** [2.1. Query](https://github.com/AironasVin/Advanced-SQL-and-Databases/blob/main/2.1.%20query.sql)
<br>

#### 2.2. Cumulative Sum
Enhance the 2.1 query by adding a cumulative sum of the total amount (with tax) earned, calculated per Country and Region.

**Solution:** [2.2. Query](https://github.com/AironasVin/Advanced-SQL-and-Databases/blob/main/2.2.%20query.sql)
<br>

#### 2.3.Sales Rank
Enhance the 2.2 query by adding a `sales_rank` column that ranks rows from highest to lowest total amount (with tax) earned per country and month.

For each country, assign rank 1 to the region with the highest total amount in a given month, and so on.

**Solution:** [2.3. Query](https://github.com/AironasVin/Advanced-SQL-and-Databases/blob/main/2.3.%20query.sql)
<br>

#### 2.4. Tax details
Enhance the 2.3 query by adding country-level tax details. Since tax rates can vary by province, include the `mean_tax_rate column` to reflect the average tax rate per country. Additionally, for transparency, add the `perc_provinces_w_tax` column to show the percentage of provinces with available tax data for each country.

- `mean_tax_rate`: The average tax rate per country. If a province/state has multiple tax rates, use the highest rate. Do not double-count provinces/states when calculating the average.
- `perc_provinces_w_tax`: The percentage of provinces/states within each country that have available tax rates. Example: If a country has 5 provinces and tax rates exist for 2, the value should be 0.40.

**Solution:** [2.4. Query](https://github.com/AironasVin/Advanced-SQL-and-Databases/blob/main/2.4.%20query.sql)
<br>
