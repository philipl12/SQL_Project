--1
--give a count of different product IDs

USE tsqlv4;

SELECT productid,
       Count(productid) AS totalCount
FROM   sales.orderdetails
GROUP  BY productid

--2
--I want to save on time and shipping costs
--Find all orders in the same city as the suppliers

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
--Find a product that received a rating of four or greater
--and the order contained more than 10 of the same items

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
--show me people who have modifed their passwords recently
--lets say beginning of 2015

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
--Show me  the customers and the compoany name
--of people without orders

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


--example of multijoin

use TSQLV4;
go
select c.companyname
     , o.orderid
     , o.orderdate
     , p.productname
     , od.unitprice
     , od.qty
     , od.discount
     , TotalCost           = (od.unitprice * od.qty)
     , TotalDiscountedCost = (od.unitprice * od.qty) * (1 - od.discount)
from Sales.Customers               as c
    inner join Sales.Orders        as o
        on o.custid = c.custid
    inner join Sales.OrderDetails  as od
        on od.orderid = o.orderid
    inner join Production.Products as p
        on p.productid = od.productid
order by c.companyname
       , o.orderdate;
