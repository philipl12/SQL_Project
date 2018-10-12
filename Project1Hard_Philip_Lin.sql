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

 --5
 USE TSQLV4
 GO

 drop function if exists dbo.findCost;
 go

 CREATE FUNCTION dbo.findCost (
 	@currPrice MONEY
 	,@qty INT
 	)
 RETURNS MONEY
 AS
 BEGIN
 	RETURN @currPrice * @qty
 END
 GO

SELECT Production.Products.productid
	,Sales.OrderDetails.orderid
	,Production.Products.unitprice AS OrderedPrice
	,Sales.OrderDetails.unitprice AS SoldPrice
	,Sales.OrderDetails.qty
	,dbo.findCost(Sales.OrderDetails.qty, Sales.OrderDetails.unitprice) AS customerCost
	,Sales.Orders.freight
FROM Production.Products
INNER JOIN Sales.OrderDetails ON Production.Products.productid = Sales.OrderDetails.productid
	AND Production.Products.productid = Sales.OrderDetails.productid
INNER JOIN Sales.Orders ON Sales.OrderDetails.orderid = Sales.Orders.orderid
	AND Sales.OrderDetails.orderid = Sales.Orders.orderid
ORDER BY customerCost DESC

--6
USE TSQLV4
GO

drop function if exists dbo.findCost;
go

CREATE FUNCTION dbo.findCost (
	@wholeSalePrice MONEY
	,@MSRP MONEY
	)
RETURNS MONEY
AS
BEGIN
	RETURN @wholeSalePrice - @MSRP
END
GO

SELECT Production.Products.productid
	,Sales.OrderDetails.orderid
	,Production.Products.unitprice AS OrderedPrice
	,Sales.OrderDetails.unitprice AS SoldPrice
	,dbo.findCost(Production.Products.unitprice, Sales.OrderDetails.unitprice) AS CostDifference
	,(Sales.OrderDetails.qty * Sales.Orders.freight) AS shippingWeight
FROM Production.Products
INNER JOIN Sales.OrderDetails ON Production.Products.productid = Sales.OrderDetails.productid
	AND Production.Products.productid = Sales.OrderDetails.productid
INNER JOIN Sales.Orders ON Sales.OrderDetails.orderid = Sales.Orders.orderid
	AND Sales.OrderDetails.orderid = Sales.Orders.orderid
WHERE dbo.findCost(Production.Products.unitprice, Sales.OrderDetails.unitprice) = 0
	AND (Sales.OrderDetails.qty * Sales.Orders.freight) < 2000
ORDER BY CostDifference
	,shippingWeight DESC

--7
USE TSQLV4
GO

DROP FUNCTION

IF EXISTS dbo.findCost;
GO
CREATE FUNCTION dbo.findCost (
	@wholesalePrice MONEY
	,@MSRP MONEY
	)
RETURNS MONEY
AS
BEGIN
	RETURN @wholesalePrice - @MSRP
END
GO




SELECT Production.Products.productid
	,Sales.OrderDetails.orderid
	,Production.Products.unitprice AS OrderedPrice
	,Sales.OrderDetails.unitprice AS SoldPrice
	,dbo.findCost(Production.Products.unitprice, Sales.OrderDetails.unitprice) AS CostDifference
	,((Sales.OrderDetails.qty * Sales.Orders.freight) / 24910) AS numberOfContainers
FROM Production.Products
INNER JOIN Sales.OrderDetails ON Production.Products.productid = Sales.OrderDetails.productid
	AND Production.Products.productid = Sales.OrderDetails.productid
INNER JOIN Sales.Orders ON Sales.OrderDetails.orderid = Sales.Orders.orderid
	AND Sales.OrderDetails.orderid = Sales.Orders.orderid
WHERE dbo.findCost(Production.Products.unitprice, Sales.OrderDetails.unitprice) = 0
	AND ((Sales.OrderDetails.qty * Sales.Orders.freight) / 24910) > 2
