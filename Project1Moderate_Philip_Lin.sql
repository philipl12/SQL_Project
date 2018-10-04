SELECT
  C.custid, C.companyname, O.orderid,
  OD.productid, OD.qty
FROM Sales.Customers AS C
  INNER JOIN Sales.Orders AS O
    ON C.custid = O.custid
  INNER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid;

--1
--Find seafood where unit price
--is greater than 15
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

--2
--show me the top 20 largest inventory discrepancies

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

--3
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
