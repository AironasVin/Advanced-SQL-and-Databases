WITH
  LatestAddress AS (
    SELECT
      CustomerID,
      MAX(AddressID) AS MaxAddressID
    FROM
      `adwentureworks_db.customeraddress`
    GROUP BY
      CustomerID
  ),
  --this CTE below returns a count of orders, total amount and the date of the last order
  Sales AS (
    SELECT
      CustomerID,
      COUNT(SalesOrderID) AS number_orders,
      ROUND(SUM(TotalDue), 3) AS total_amount,
      MAX(OrderDate) AS date_last_order
    FROM
      `adwentureworks_db.salesorderheader`
    GROUP BY
      CustomerID
  )
SELECT
  customer.CustomerID,
  contact.FirstName,
  contact.LastName,
  CONCAT(contact.FirstName, ' ', contact.LastName) AS FullName,
  CONCAT(COALESCE(contact.Title, 'Dear'), ' ', contact.LastName) AS addressing_title,
  contact.EmailAddress,
  contact.Phone,
  customer.AccountNumber,
  customer.CustomerType,
  address.City,
  address.AddressLine1,
  COALESCE(address.AddressLine2, '') AS AddressLine2,
  stateprovince.Name AS State,
  countryregion.Name AS Country,
  Sales.number_orders,
  Sales.total_amount,
  Sales.date_last_order
FROM
  `adwentureworks_db.customer` AS customer
JOIN
  `adwentureworks_db.individual` AS individual
  ON customer.CustomerID = individual.CustomerID
JOIN
  `adwentureworks_db.contact` AS contact
  ON individual.ContactID = contact.ContactID
JOIN
  LatestAddress
  ON customer.CustomerID = LatestAddress.CustomerID
JOIN
  `adwentureworks_db.address` AS address
  ON address.AddressID = LatestAddress.MaxAddressID
JOIN
  `adwentureworks_db.stateprovince` AS stateprovince
  ON address.StateProvinceID = stateprovince.StateProvinceID
JOIN
  `adwentureworks_db.countryregion` AS countryregion
  ON stateprovince.CountryRegionCode = countryregion.CountryRegionCode
JOIN
  Sales
  ON Sales.CustomerID = customer.CustomerID
ORDER BY
  Sales.total_amount DESC
LIMIT 200;
