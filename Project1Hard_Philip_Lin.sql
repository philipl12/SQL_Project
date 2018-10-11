--1

SELECT Production.Categories.categoryname
	,Production.Products.productname
	,Production.Products.productid
	,sum(Sales.OrderDetails.unitprice) AS totalCost
	,sum(Sales.OrderDetails.qty) AS totalDiscontinued
FROM Production.Categories
INNER JOIN Production.Products ON Production.Categories.categoryid = Production.Products.categoryid
INNER JOIN Sales.OrderDetails ON Production.Products.productid = Sales.OrderDetails.productid
WHERE discontinued = 1
GROUP BY categoryname
	,productname
	,Production.Products.productid

--2
SELECT HR.Employees.empid
	,Sales.Shippers.shipperid
	,Sales.Shippers.companyname
	,Sales.Orders.custid
	,Sales.Orders.shipcountry
FROM HR.Employees
INNER JOIN Sales.Orders ON HR.Employees.empid = Sales.Orders.empid
INNER JOIN Sales.Shippers ON Sales.Orders.shipperid = Sales.Shippers.shipperid
WHERE shipcountry = 'Canada'

UNION

SELECT HR.Employees.empid
	,Sales.Shippers.shipperid
	,Sales.Shippers.companyname
	,Sales.Orders.custid
	,Sales.Orders.shipcountry
FROM HR.Employees
INNER JOIN Sales.Orders ON HR.Employees.empid = Sales.Orders.empid
INNER JOIN Sales.Shippers ON Sales.Orders.shipperid = Sales.Shippers.shipperid
WHERE shipcountry = 'Mexico'

--3
SELECT TOP 20 (Sales.OrderDetails.unitprice * Sales.OrderDetails.qty) AS totalProductPrice
	,Sales.OrderDetails.orderid
	,Production.Products.productid
	,Production.Products.productname
	,Sales.OrderDetails.unitprice
	,Sales.OrderDetails.qty
	,Production.Products.supplierid
	,Production.Categories.categoryid
FROM Sales.OrderDetails
INNER JOIN Production.Products ON Sales.OrderDetails.productid = Production.Products.productid
INNER JOIN Production.Categories ON Production.Products.categoryid = Production.Categories.categoryid
ORDER BY totalProductPrice DESC

--4
use AdventureWorksDW2014;
SELECT
   DimReseller.ResellerName,
   DimReseller.OrderFrequency,
   DimGeography.StateProvinceName,
   DimCustomer.FirstName,
   DimCustomer.LastName,
   DimCustomer.YearlyIncome
FROM
   DimGeography
   INNER JOIN
      DimCustomer
      ON DimGeography.GeographyKey = DimCustomer.GeographyKey
   INNER JOIN
      DimReseller
      ON DimGeography.GeographyKey = DimReseller.GeographyKey
WHERE
   yearlyincome > 130000
   AND OrderFrequency = 'Q'
   AND DimGeography.CountryRegionCode = 'US'
ORDER BY
   YearlyIncome
