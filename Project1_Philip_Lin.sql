use TSQLV4;

select e.firstname, e.lastname, o.*
from sales.orders as o
	inner join hr.Employees as e
	on o.empid = e.empid
	and e.empid = 6


use TSQLV4;

select o.orderid, o.shipcity, s.companyname, s.city

from Production.Suppliers as s
	inner join sales.orders as o
	on s.city = o.shipcity

order by supplierid

--I want to save on time and shipping costs
--Find all orders in the same city as the suppliers

use AdventureWorks2014;

select pr.ProductID, pr.Rating, sod.OrderQty, sod.UnitPrice
from production.ProductReview as PR
	inner join sales.SalesOrderDetail as  SOD
	on pr.ProductID = sod.ProductID
	where pr.rating >= 4 and sod.OrderQty > 10

order by sod.OrderQty;

--Find a product that received a rating of four or greater
--and the order contained more than 10 of the same items


use AdventureWorks2014;

select pe.firstname, pe.lastname, pa.modifieddate
from person.Password as pa
	left outer join person.Person as pe
	on pe.BusinessEntityID = pa.BusinessEntityID
where pa.ModifiedDate > '2014-12-31'

--show me people who have modifed their passwords recently
--lets say beginning of 2015
