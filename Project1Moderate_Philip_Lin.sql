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

 --6

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

--7

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


--8

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

--9

USE wideworldimporters;

SELECT warehouse.colors.colorname,
       Count(warehouse.colors.colorname) AS colorCount
FROM   warehouse.colors
       INNER JOIN warehouse.stockitems
               ON warehouse.colors.colorid = warehouse.stockitems.colorid
GROUP  BY warehouse.colors.colorname

--10

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

--11
--show price per piece and round to two decimal discrepancies

USE tsqlv4;

SELECT sales.ordervalues.orderid,
       sales.ordervalues.qty,
       sales.ordervalues.val,
       ( sales.ordervalues.val / sales.ordervalues.qty )AS pricePerPiece,
       Round(( sales.ordervalues.val / sales.ordervalues.qty ), 2) AS roundedPrice
FROM   sales.ordervalues
       INNER JOIN sales.orders
               ON sales.ordervalues.orderid = sales.orders.orderid

--12
--find me the all orders placed by Paul Suurs

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

--13
--How many different products do we currently sell
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

--14
--Find me employees who hold a graduates degree, own a house
--and make 25000 or less

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

--15
--Find everyone making more than 100,000 who aren't management,
--don't hold a college degree, and own a house

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
