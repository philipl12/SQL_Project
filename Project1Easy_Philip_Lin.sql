--1
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
