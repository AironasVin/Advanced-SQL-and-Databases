WITH
  LatestAddress AS (
    SELECT
      customeraddress.CustomerID,
      MAX(customeraddress.AddressID) AS MaxAddressID
    FROM
      `adwentureworks_db.customeraddress` customeraddress
    GROUP BY
      customeraddress.CustomerID
  ),
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
  ),
  CustomerDetails AS (
    SELECT
      customer.CustomerID,
      contact.Firstname,
      contact.LastName,
      CONCAT(contact.Firstname, ' ', contact.LastName) AS FullName,
      CASE
        WHEN contact.Title IS NOT NULL THEN CONCAT(contact.Title, ' ', contact.LastName)
        ELSE CONCAT('Dear ', contact.LastName)
      END AS addressing_title,
      contact.EmailAddress,
      contact.Phone,
      customer.accountnumber,
      customer.CustomerType,
      address.city AS City,
      address.AddressLine1,
      CASE
        WHEN address.AddressLine2 IS NULL THEN ''
        ELSE address.AddressLine2
      END AS AddressLine2,
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
      ON individual.ContactID = contact.ContactId
    JOIN
      LatestAddress
      ON customer.CustomerID = LatestAddress.CustomerID
    JOIN
      `adwentureworks_db.address` address
      ON address.AddressID = LatestAddress.MaxAddressID
    JOIN
      `adwentureworks_db.stateprovince` stateprovince
      ON stateprovince.StateProvinceID = address.StateProvinceID
    JOIN
      `adwentureworks_db.countryregion` countryregion
      ON countryregion.CountryRegionCode = stateprovince.CountryRegionCode
    JOIN
      Sales
      ON Sales.CustomerID = customer.CustomerID
  )

SELECT
  *,
  CASE
    WHEN date_last_order < DATE_SUB(
      (SELECT MAX(OrderDate) FROM `adwentureworks_db.salesorderheader`), INTERVAL 365 DAY
    ) THEN 'Inactive'
    ELSE 'Active'
  END AS active_status
FROM
  CustomerDetails
ORDER BY
  CustomerID DESC
LIMIT
  500;
