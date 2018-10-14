--1

USE tsqlv4;

SELECT productid,
Count(productid) AS totalCount
FROM   sales.orderdetails
GROUP  BY productid

--2

use tsqlv4;
SELECT
o.orderid,
o.shipcity,
s.companyname,
s.city
FROM
production.suppliers AS s
INNER JOIN
sales.orders AS o
ON s.city = o.shipcity
ORDER BY
supplierid

--3

use adventureworks2014;
SELECT
pr.productid,
pr.rating,
sod.orderqty,
sod.unitprice
FROM
production.productreview AS pr
INNER JOIN
sales.salesorderdetail AS sod
ON pr.productid = sod.productid
WHERE
pr.rating >= 4
AND sod.orderqty > 10
ORDER BY
sod.orderqty;



--4

use adventureworks2014;
SELECT
pe.firstname,
pe.lastname,
pa.modifieddate
FROM
person.password AS pa
LEFT OUTER JOIN
person.person AS pe
ON pe.businessentityid = pa.businessentityid
WHERE
pa.modifieddate > '2014-12-31'

--5

use tsqlv4;
SELECT
c.custid,
c.companyname
FROM
sales.customers AS c
LEFT OUTER JOIN
sales.orders AS o
ON c.custid = o.custid
WHERE
o.orderid IS NULL

--6

use TSQLV4;
SELECT
Production.Products.unitprice,
Production.Categories.categoryname,
Production.Products.productname
FROM
Production.Suppliers
INNER JOIN
 Production.Products
 ON Production.Suppliers.supplierid = Production.Products.supplierid
 AND Production.Suppliers.supplierid = Production.Products.supplierid
INNER JOIN
 Production.Categories
 ON Production.Products.categoryid = Production.Categories.categoryid
 AND Production.Products.categoryid = Production.Categories.categoryid

WHERE unitprice > 15 AND categoryname = 'Seafood'

--7

use WorldWideImporters;
SELECT
top 20 Warehouse.StockItemHoldings.QuantityOnHand,
Warehouse.StockItemHoldings.LastStocktakeQuantity,
(
 Warehouse.StockItemHoldings.QuantityOnHand - Warehouse.StockItemHoldings.LastStocktakeQuantity
)
AS Discrepancy,
Warehouse.StockItems.UnitPrice
FROM
Warehouse.StockItemHoldings
INNER JOIN
 Warehouse.StockItems
 ON Warehouse.StockItemHoldings.StockItemID = Warehouse.StockItems.StockItemID
ORDER BY
Discrepancy DESC

--8

use WorldWideImportersDW;
SELECT
Fact.Sale.Description,
Fact.Sale.Quantity,
Fact.Sale.[Unit Price],
Dimension.City.City,
Fact.Sale.Profit
FROM
Dimension.Customer
INNER JOIN
 Fact.Sale
 ON Dimension.Customer.[Customer Key] = Fact.Sale.[Customer Key]
 AND Dimension.Customer.[Customer Key] = Fact.Sale.[Bill TO Customer Key]
INNER JOIN
 Dimension.City
 ON Fact.Sale.[City Key] = Dimension.City.[City Key]
WHERE
Fact.Sale.Profit > 700
AND Dimension.City.City = 'McCall'
ORDER BY
Fact.Sale.Profit DESC


--9

USE TSQLv4;

SELECT Production.Products.productid
,avg(Sales.OrderDetails.qty) AS AvgQtyOrdered
,Sales.OrderDetails.unitprice
,(Sales.OrderDetails.unitprice * avg(Sales.OrderDetails.qty)) AS AvgPricePerOrder
FROM Production.Products
INNER JOIN Sales.OrderDetails ON Production.Products.productid = Sales.OrderDetails.productid
GROUP BY Production.Products.productid
,Sales.OrderDetails.unitprice
ORDER BY Production.Products.productid

--10

use TSQLV4;
SELECT
Production.Suppliers.companyname,
Production.Suppliers.contactname,
Production.Suppliers.contacttitle,
Production.Products.productname,
Production.Suppliers.supplierid,
Production.Suppliers.phone
FROM
Production.Suppliers
INNER JOIN
 Production.Products
 ON Production.Suppliers.supplierid = Production.Products.supplierid
 AND Production.Suppliers.supplierid = Production.Products.supplierid
WHERE
discontinued = 1
ORDER BY
productname

--11

USE tsqlv4;

SELECT sales.orders.custid,
  ( sales.orderdetails.unitprice * sales.orderdetails.qty )   AS
  totalUnitCost,
  sales.orders.orderdate,
  sales.orders.shippeddate,
  Day(sales.orders.shippeddate) - Day(sales.orders.orderdate) AS
  processTime
FROM   sales.customers
  INNER JOIN sales.orders
          ON sales.customers.custid = sales.orders.custid
  INNER JOIN sales.orderdetails
          ON sales.orders.orderid = sales.orderdetails.orderid
WHERE  Day(sales.orders.shippeddate) - Day(sales.orders.orderdate) > 20

--12

USE tsqlv4;

SELECT hr.employees.empid,
  production.products.productname,
  sales.orderdetails.qty
FROM   production.products
  INNER JOIN sales.orderdetails
          ON production.products.productid = sales.orderdetails.productid
  INNER JOIN sales.orders
          ON sales.orderdetails.orderid = sales.orders.orderid
             AND sales.orderdetails.orderid = sales.orders.orderid
             AND sales.orderdetails.orderid = sales.orders.orderid
  INNER JOIN hr.employees
          ON sales.orders.empid = hr.employees.empid
             AND sales.orders.empid = hr.employees.empid
             AND sales.orders.empid = hr.employees.empid
WHERE  sales.orderdetails.qty > 100
ORDER  BY hr.employees.empid

--13

USE wideworldimporters;

SELECT purchasing.suppliertransactions.supplierid,
  purchasing.suppliertransactions.amountexcludingtax,
  purchasing.suppliertransactions.taxamount,
  purchasing.suppliertransactions.finalizationdate
FROM   purchasing.suppliertransactions
  INNER JOIN purchasing.suppliers
          ON purchasing.suppliertransactions.supplierid =
             purchasing.suppliers.supplierid
WHERE  purchasing.suppliertransactions.finalizationdate >= '2016-04-01'
  AND purchasing.suppliertransactions.amountexcludingtax != 0
ORDER  BY purchasing.suppliertransactions.finalizationdate DESC

--14

USE wideworldimporters;

SELECT warehouse.colors.colorname,
  Count(warehouse.colors.colorname) AS colorCount
FROM   warehouse.colors
  INNER JOIN warehouse.stockitems
          ON warehouse.colors.colorid = warehouse.stockitems.colorid
GROUP  BY warehouse.colors.colorname

--15

USE adventureworks2014;

SELECT TOP 10 production.productcosthistory.productid,
         production.productcosthistory.standardcost,
         production.productinventory.shelf,
         production.productinventory.bin,
         production.productinventory.quantity,
         purchasing.purchaseorderdetail.receivedqty,
         purchasing.purchaseorderdetail.rejectedqty
FROM   production.productcosthistory
  INNER JOIN production.productinventory
          ON production.productcosthistory.productid =
             production.productinventory.productid
  INNER JOIN purchasing.purchaseorderdetail
          ON production.productcosthistory.productid =
             purchasing.purchaseorderdetail.productid
WHERE  purchasing.purchaseorderdetail.rejectedqty > 100

--16

USE tsqlv4;

SELECT sales.ordervalues.orderid,
  sales.ordervalues.qty,
  sales.ordervalues.val,
  ( sales.ordervalues.val / sales.ordervalues.qty )AS pricePerPiece,
  Round(( sales.ordervalues.val / sales.ordervalues.qty ), 2) AS roundedPrice
FROM   sales.ordervalues
  INNER JOIN sales.orders
          ON sales.ordervalues.orderid = sales.orders.orderid

--17

use tsqlv4;
SELECT
e.firstname,
e.lastname,
o.shipaddress,
o.shipcity,
o.shipcountry
FROM
sales.orders AS o
INNER JOIN
 hr.employees AS e
 ON o.empid = e.empid
 AND e.empid = 6

--18

USE tsqlv4;

SELECT production.products.productname,
  production.categories.categoryname,
  production.products.unitprice,
  production.categories.description
FROM   production.categories
  FULL JOIN production.products
         ON production.categories.categoryid =
            production.products.categoryid
ORDER  BY production.products.productname

--19

USE adventureworks2014;

SELECT person.person.firstname,
  person.person.middlename,
  person.person.lastname,
  sales.vpersondemographics.birthdate,
  sales.vpersondemographics.maritalstatus,
  sales.vpersondemographics.yearlyincome,
  sales.vpersondemographics.gender,
  sales.vpersondemographics.totalchildren,
  sales.vpersondemographics.education,
  sales.vpersondemographics.occupation,
  sales.vpersondemographics.numbercarsowned
FROM   person.person
  INNER JOIN sales.vpersondemographics
          ON person.person.businessentityid =
             sales.vpersondemographics.businessentityid
WHERE  education = 'Graduate Degree'
  AND homeownerflag = 1
  AND yearlyincome < '25001'

--20

USE adventureworks2014;

SELECT person.person.firstname,
  person.person.middlename,
  person.person.lastname,
  sales.vpersondemographics.birthdate,
  sales.vpersondemographics.maritalstatus,
  sales.vpersondemographics.yearlyincome,
  sales.vpersondemographics.gender,
  sales.vpersondemographics.totalchildren,
  sales.vpersondemographics.education,
  sales.vpersondemographics.occupation,
  sales.vpersondemographics.numbercarsowned
FROM   person.person
  INNER JOIN sales.vpersondemographics
          ON person.person.businessentityid =
             sales.vpersondemographics.businessentityid
WHERE  education = 'Partial College'
  AND homeownerflag = 1
  AND yearlyincome = 'Greater than 100000'
  AND occupation != 'Management'

--21

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

--22

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

--23

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

--24

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

--25

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

--26

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

--27

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

--28

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

--29

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

--30

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
