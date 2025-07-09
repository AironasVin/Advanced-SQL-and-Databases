WITH
  LatestOrderDate AS (
    SELECT
      MAX(OrderDate) AS latest_order_date
    FROM
      `adwentureworks_db.salesorderheader`
  ),
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
      contact.FirstName,
      contact.LastName,
      CONCAT(contact.FirstName, ' ', contact.LastName) AS FullName,
      -- Addressing title: if missing, default to 'Dear LastName'
      CASE
        WHEN contact.Title IS NOT NULL THEN CONCAT(contact.Title, ' ', contact.LastName)
        ELSE CONCAT('Dear ', contact.LastName)
      END AS addressing_title,
      contact.EmailAddress,
      contact.Phone,
      customer.AccountNumber,
      customer.CustomerType,
      address.City,
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
        ON individual.ContactID = contact.ContactID
    JOIN
      LatestAddress
        ON customer.CustomerID = LatestAddress.CustomerID
    JOIN
      `adwentureworks_db.address_
