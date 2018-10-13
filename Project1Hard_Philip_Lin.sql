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

--1 edit
USE TSQLV4
GO

DROP FUNCTION

IF EXISTS dbo.countIt;
GO

CREATE FUNCTION dbo.countIt (
	@costOfItem money
	)
RETURNS INT

AS
BEGIN
	declare @total int
	set @total = sum(@costOfItem)
	RETURN @total
END
GO

SELECT Production.Categories.categoryname
	,Production.Products.productname
	,Production.Products.productid
	,dbo.countIt(Sales.OrderDetails.unitprice) AS totalCost
	,sum(Sales.OrderDetails.qty) AS totalDiscontinued
FROM Production.Categories
INNER JOIN Production.Products ON Production.Categories.categoryid = Production.Products.categoryid
INNER JOIN Sales.OrderDetails ON Production.Products.productid = Sales.OrderDetails.productid
WHERE discontinued = 1
GROUP BY categoryname
	,productname
	,Production.Products.productid
	,dbo.countIt(Sales.OrderDetails.unitprice)

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

--2 edit
USE TSQLV4
GO

DROP FUNCTION

IF EXISTS dbo.countIt;
GO

CREATE FUNCTION dbo.countIt (
	@itemQuantity smallint
	)
RETURNS INT

AS
BEGIN
	declare @total int
	set @total = sum(@itemQuantity)
	RETURN @total
END
GO

SELECT Production.Categories.categoryname
	,Production.Products.productname
	,Production.Products.productid
	,sum(Sales.OrderDetails.unitprice) AS totalCost
	,dbo.countIt(Sales.OrderDetails.qty) AS totalDiscontinued
FROM Production.Categories
INNER JOIN Production.Products ON Production.Categories.categoryid = Production.Products.categoryid
INNER JOIN Sales.OrderDetails ON Production.Products.productid = Sales.OrderDetails.productid
WHERE discontinued = 1
GROUP BY categoryname
	,productname
	,Production.Products.productid
	,dbo.countIt(Sales.OrderDetails.qty)

--3
USE TSQLV4
GO

DROP FUNCTION

IF EXISTS dbo.countIt;
GO

CREATE FUNCTION dbo.countIt (
	@price money
	,@qty smallint
	)
RETURNS INT

AS
BEGIN
	RETURN @price * @qty
END
GO

SELECT TOP 20 dbo.countIt(Sales.OrderDetails.unitprice, Sales.OrderDetails.qty) AS totalProductPrice
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
USE AdventureWorksDW2014
GO

DROP FUNCTION

IF EXISTS dbo.estimateYears;
GO

CREATE FUNCTION dbo.estimateYears (
	@startYear int
	,@currYear int
	)
RETURNS INT
AS
BEGIN


	RETURN @currYear - @startYear
END
GO


SELECT DimCustomer.CustomerKey
	,cast(year(DimCustomer.DateFirstPurchase) AS INT) AS YearFirstPurchase
	,DimGeography.StateProvinceName
	,DimReseller.ResellerName
	,DimReseller.AnnualRevenue
	,DimReseller.YearOpened
	,dbo.estimateYears(cast(year(DimCustomer.DateFirstPurchase) AS INT), cast(year(getdate()) AS INT)) AS lengthOfBusinessRelationship
FROM DimCustomer
INNER JOIN DimGeography ON DimCustomer.GeographyKey = DimGeography.GeographyKey
INNER JOIN DimReseller ON DimGeography.GeographyKey = DimReseller.GeographyKey
WHERE dbo.estimateYears(cast(year(DimCustomer.DateFirstPurchase) AS INT), cast(year(getdate()) AS INT)) > 5
ORDER BY CustomerKey

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

--8
USE AdventureWorksDW2014
GO

DROP FUNCTION

IF EXISTS dbo.estimateYears;
GO

CREATE FUNCTION dbo.estimateYears (
	@startYear int
	,@currYear int
	)
RETURNS INT
AS
BEGIN
	RETURN @currYear - @startYear
END
GO

SELECT DimCustomer.CustomerKey
	,cast(year(DimCustomer.DateFirstPurchase) AS INT) AS YearFirstPurchase
	,DimGeography.StateProvinceName
	,DimReseller.ResellerName
	,DimReseller.AnnualRevenue
	,DimReseller.YearOpened
	,dbo.estimateYears(DimReseller.YearOpened, cast(year(DimCustomer.DateFirstPurchase) AS INT)) AS yearsBeforeBusinessRelationship
FROM DimCustomer
INNER JOIN DimGeography ON DimCustomer.GeographyKey = DimGeography.GeographyKey
INNER JOIN DimReseller ON DimGeography.GeographyKey = DimReseller.GeographyKey
WHERE StateProvinceName = 'England'
	AND dbo.estimateYears(DimReseller.YearOpened, cast(year(DimCustomer.DateFirstPurchase) AS INT)) >= 35
ORDER BY yearsBeforeBusinessRelationship DESC

--9
USE AdventureWorksDW2014
GO

DROP FUNCTION

IF EXISTS dbo.estimateYears;
GO

CREATE FUNCTION dbo.estimateYears (
	@startYear int
	,@currYear int
	)
RETURNS INT
AS
BEGIN
	RETURN @currYear - @startYear
END
GO

SELECT DimCustomer.CustomerKey
	,DimGeography.StateProvinceName
	,DimReseller.ResellerName
	,DimReseller.AnnualRevenue
	,DimReseller.YearOpened
	,dbo.estimateYears(DimReseller.YearOpened, cast(year(getdate()) AS INT)) * AnnualRevenue AS totalRevenue
FROM DimCustomer
INNER JOIN DimGeography ON DimCustomer.GeographyKey = DimGeography.GeographyKey
INNER JOIN DimReseller ON DimGeography.GeographyKey = DimReseller.GeographyKey
WHERE dbo.estimateYears(DimReseller.YearOpened, cast(year(getdate()) AS INT)) *	AnnualRevenue > 12000000

--10
USE TSQLV4
GO

DROP FUNCTION

IF EXISTS dbo.countIt;
GO

CREATE FUNCTION dbo.countIt (
	@price money
	,@qty smallint
	)
RETURNS INT

AS
BEGIN
	RETURN @price * @qty
END
GO

SELECT TOP 20 dbo.countIt(Sales.OrderDetails.unitprice, Sales.OrderDetails.qty) AS totalProductPrice
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
ORDER BY totalProductPrice ASC
