SELECT
  LAST_DAY(DATE(sales.OrderDate)) AS order_month,
  salesterritory.CountryRegionCode,
  salesterritory.name AS Region,
  COUNT(sales.SalesOrderID) AS number_orders,
  COUNT(DISTINCT customer.CustomerID) AS number_customers,
  COUNT(DISTINCT sales.SalesPersonID) AS no_salesPerson,
  CAST(SUM(sales.TotalDue) AS INT) AS Total_w_tax
FROM
  `adwentureworks_db.salesorderheader` sales
JOIN
  `adwentureworks_db.customer` customer
    ON sales.CustomerID = customer.CustomerID
JOIN
  `adwentureworks_db.salesterritory` salesterritory
    ON sales.TerritoryID = salesterritory.TerritoryID
GROUP BY
  CountryRegionCode,
  Region,
  order_month;
