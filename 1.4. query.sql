WITH
  LatestOrderDate AS (
    SELECT MAX(OrderDate) AS latest_order_date
    FROM `adwentureworks_db.salesorderheader`
  ),
  Sales AS (
    SELECT
      CustomerID,
      COUNT(SalesOrderID) AS number_orders,
      ROUND(SUM(TotalDue), 3) AS total_amount,
      MAX(OrderDate) AS date_last_order
    FROM `adwentureworks_db.salesorderheader`
    GROUP BY CustomerID
  ),
  LatestAddress AS (
    SELECT
      customeraddress.CustomerID,
      MAX(customeraddress.AddressID) AS MaxAddressID
    FROM `adwentureworks_db.customeraddress` customeraddress
    GROUP BY customeraddress.CustomerID
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
        WHEN STRPOS(address.AddressLine1, ' ') > 0 THEN LEFT(address.AddressLine1, STRPOS(address.AddressLine1, ' ') - 1)
        ELSE address.AddressLine1
      END AS address_no,
      CASE
        WHEN STRPOS(address.AddressLine1, ' ') > 0 THEN SUBSTR(address.AddressLine1, STRPOS(address.AddressLine1, ' ') + 1)
        ELSE ''
      END AS address_st,
      IFNULL(address.AddressLine2, '') AS AddressLine2,
      stateprovince.Name AS State,
      countryregion.Name AS Country,
      Sales.number_orders,
      Sales.total_amount,
      Sales.date_last_order,
      countryregion.CountryRegionCode AS CountryRegionCode
    FROM `adwentureworks_db.customer` AS customer
    JOIN `adwentureworks_db.individual` AS individual ON customer.CustomerID = individual.CustomerID
    JOIN `adwentureworks_db.contact` AS contact ON individual.ContactID = contact.ContactId
    JOIN LatestAddress ON customer.CustomerID = LatestAddress.CustomerID
    JOIN `adwentureworks_db.address` address ON address.AddressID = LatestAddress.MaxAddressID
    JOIN `adwentureworks_db.stateprovince` stateprovince ON stateprovince.StateProvinceID = address.StateProvinceID
    JOIN `adwentureworks_db.countryregion` countryregion ON countryregion.CountryRegionCode = stateprovince.CountryRegionCode
    JOIN Sales ON Sales.CustomerID = customer.CustomerID
  ),
  ActiveCustomers AS (
    SELECT
      CustomerDetails.*,
      CASE
        WHEN date_last_order < DATE_SUB(
          (SELECT MAX(OrderDate) FROM `adwentureworks_db.salesorderheader`), INTERVAL 365 DAY
        ) THEN 'Inactive'
        ELSE 'Active'
      END AS active_status
    FROM CustomerDetails
  ),
  FilteredCustomers AS (
    SELECT
      ActiveCustomers.*,
      salesterritory.CountryRegionCode
    FROM ActiveCustomers
    JOIN `adwentureworks_db.salesterritory` salesterritory
      ON salesterritory.CountryRegionCode = ActiveCustomers.CountryRegionCode
    WHERE
      salesterritory.Group = "North America"
      AND ActiveCustomers.active_status = "Active"
      AND (total_amount >= 2500 OR number_orders > 5)
  )
SELECT
  DISTINCT CustomerID,
  FullName,
  addressing_title,
  EmailAddress,
  Phone,
  accountnumber,
  CustomerType,
  City,
  address_no,
  address_st,
  AddressLine2,
  State,
  Country,
  number_orders,
  total_amount,
  date_last_order,
  active_status
FROM FilteredCustomers
ORDER BY
  Country,
  State,
  date_last_order DESC;

