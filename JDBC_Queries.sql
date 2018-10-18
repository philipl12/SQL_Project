--easy
--1
SELECT testid, studentid, score
FROM Stats.Scores
WHERE testid = 'TEST XYZ' AND score <= 80;

--2
USE AdventureWorks2014;
SELECT Name
FROM Sales.Store
ORDER BY Name

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

--moderate
--1
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

--2
USE AdventureWorks2014
;WITH IndivSalesData AS
(
    SELECT
       SaleYear = YEAR(oh.OrderDate),
       SalesForYear = SUM(od.LineTotal)
    FROM
        Sales.SalesOrderDetail od
    INNER JOIN
        Sales.SalesOrderHeader oh ON od.SalesOrderID = oh.SalesOrderID
    INNER JOIN
        Sales.Customer c ON oh.CustomerID = c.CustomerID
    INNER JOIN
        Person.Person p ON c.PersonID = p.BusinessEntityID
    WHERE
        p.PersonType = 'IN'
    GROUP BY
       YEAR(oh.OrderDate)
),

CorporateSalesData AS
(
    SELECT
       SaleYear = YEAR(oh.OrderDate),
       SalesForYear = SUM(od.LineTotal)
    FROM
        Sales.SalesOrderDetail od
    INNER JOIN
        Sales.SalesOrderHeader oh ON od.SalesOrderID = oh.SalesOrderID
    INNER JOIN
        Sales.Customer c ON oh.CustomerID = c.CustomerID
    INNER JOIN
        Person.Person p ON c.PersonID = p.BusinessEntityID
    WHERE
        p.PersonType = 'SC'
    GROUP BY
       YEAR(oh.OrderDate)
)

SELECT
    Indiv.SaleYear,
    PercentToIndividuals = Indiv.SalesForYear / (Indiv.SalesForYear + SC.SalesForYear) * 100.0,
    PercentToCorporate = SC.SalesForYear / (Indiv.SalesForYear + SC.SalesForYear) * 100.0,
    TotalSales = Indiv.SalesForYear + SC.SalesForYear
FROM
    IndivSalesData Indiv
INNER JOIN
    CorporateSalesData SC ON Indiv.SaleYear = SC.SaleYear
ORDER BY
    Indiv.SaleYear

--3
SELECT C.custid, COUNT( DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
		ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON OD.orderid = O.orderid
		WHERE C.country = N'JPN'
GROUP BY C.custid;

--Difficult
--1
drop function if exists dbo.GetCustOrders;
go
create function dbo.GetCustOrders
	(@cid AS INT) RETURNS TABLE
AS
RETURN
	SELECT orderid, custid, empid, orderdate, requireddate, shipregion, shippostalcode, shipcountry
	FROM Sales.Orders
	WHERE custid = @cid
GO

SELECT C.custid, COUNT( DISTINCT ODA.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM dbo.GetCustOrders(0) AS C
	INNER JOIN Sales.Orders AS O
		ON O.custid = C.custid
	INNER JOIN Sales.OrderDetails AS OD
		ON OD.orderid = O.orderid
	LEFT OUTER JOIN Sales.OrderDetailsAudit AS ODA
		ON O.orderid = ODA.orderid
GROUP BY C.custid;

--2
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
