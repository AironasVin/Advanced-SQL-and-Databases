WITH
  sum_cte AS (
    SELECT
      LAST_DAY(DATE(sales.OrderDate)) AS order_month,
      salesterritory.CountryRegionCode AS CountryRegionCode,
      salesterritory.name AS Region,
      COUNT(sales.SalesOrderID) AS number_orders,
      COUNT(DISTINCT customer.CustomerID) AS number_customers,
      COUNT(DISTINCT sales.SalesPersonID) AS no_salesPerson,
      CAST(SUM(sales.TotalDue) AS INT) AS Total_w_tax
    FROM
      `adwentureworks_db.salesorderheader` sales
    JOIN
      `adwentureworks_db.customer` customer
    ON
      sales.CustomerID = customer.CustomerID
    JOIN
      `adwentureworks_db.salesterritory` salesterritory
    ON
      sales.TerritoryID = salesterritory.TerritoryID
    GROUP BY
      order_month,
      CountryRegionCode,
      Region
  ),
  tax_rate_cte AS (
    SELECT
      stateprovince.CountryRegionCode AS CountryRegionCode,
      AVG(tax.TaxRate) AS mean_tax_rate,
      ROUND(COUNT(tax.SalesTaxRateID) / COUNT(stateprovince.StateProvinceID), 2) AS perc_provinces_w_tax
    FROM
      `adwentureworks_db.stateprovince` stateprovince
    LEFT JOIN
      `adwentureworks_db.salestaxrate` tax
    ON
      stateprovince.StateProvinceID = tax.StateProvinceID
    GROUP BY
      CountryRegionCode
  )
SELECT
  sum_cte.order_month,
  sum_cte.CountryRegionCode,
  sum_cte.Region,
  sum_cte.number_orders,
  sum_cte.number_customers,
  sum_cte.no_salesPerson,
  sum_cte.Total_w_tax,
  RANK() OVER (
    PARTITION BY sum_cte.Region, sum_cte.CountryRegionCode
    ORDER BY sum_cte.Total_w_tax DESC
  ) AS country_sales_rank,
  SUM(sum_cte.Total_w_tax) OVER (
    PARTITION BY sum_cte.Region, sum_cte.CountryRegionCode
    ORDER BY sum_cte.order_month
  ) AS cumulative_total,
  ROUND(tax_rate_cte.mean_tax_rate, 1) AS mean_tax_rate,
  tax_rate_cte.perc_provinces_w_tax
FROM
  sum_cte
JOIN
  tax_rate_cte
ON
  sum_cte.CountryRegionCode = tax_rate_cte.CountryRegionCode
WHERE
  sum_cte.CountryRegionCode = 'US'
ORDER BY
  sum_cte.Region DESC,
  sum_cte.order_month;

