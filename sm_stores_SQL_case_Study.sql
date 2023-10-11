--1. How many records are in SM-Stores Orders table

select count (*) from orders;

--2. How many Cities do SM-stores have properties in.

select count ('PropertyCity') from propertyinfo;

--4. What are the product categories offered by SM’s.
select distinct("ProductCategory") from products;

--5. How many products belong to each category.
select "ProductCategory", count("ProductCategory") from products
group by "ProductCategory";

--6. How many orders were placed in each date stated in the orders table.
select "OrderDate", count(*)
from orders
group by "OrderDate"
order by "OrderDate";

/*7. Can you process the number of orders we had in each year of SM-stores data. In each
month for the year 2016*/

select EXTRACT(YEAR FROM "OrderDate") as theyear, count(*) from orders
group by theyear;

select EXTRACT(Month FROM "OrderDate") as themonth, count(*) as "No of orders" from orders
where EXTRACT(Year FROM "OrderDate") = 2016
group by themonth
order by themonth;

/*select TO_CHAR("OrderDate",'MONTH') as themonth, count(*) as "No of orders" from orders
where EXTRACT(Year FROM "OrderDate") = 2016
group by themonth
order by themonth; This is the query above trying to get month names instead*/

--8. Which category is the most frequented in the year 2015.

select "ProductCategory", count(*) nc 
from products inner join orders  
on products."ProductID" = orders."ProductID"
where EXTRACT(YEAR FROM "OrderDate") = 2015
group by "ProductCategory" 
order by nc Desc
limit 1;

--9. Which category has the highest sales in the year 2016.
select "ProductCategory", count(*) nc, sum("Quantity" * "Price") as sales
from products inner join orders  
on products."ProductID" = orders."ProductID"
where EXTRACT(YEAR FROM "OrderDate") = 2016
group by "ProductCategory" 
order by sales Desc
limit 1;

/*10. Which State has the most properties ordered. Return the sales for each state. (sales
>25000)*/
select "PropertyState", count(*) sc
from propertyinfo inner join orders
on propertyinfo."PropID" = orders."PropertyID"
group by "PropertyState"
order by "sc" desc
limit 1;

select "PropertyState", Sum("Quantity" * "Price") "sc"
from propertyinfo inner join orders
on propertyinfo."PropID" = orders."PropertyID"
inner join products 
using ("ProductID")
group by "PropertyState"
having Sum("Quantity" * "Price") > 25000;

--11. What is the cost of a ‘Coffee Maker’ located in Texas.
select "ProductName", "Price", "PropertyState"
from products p inner join orders o
on p."ProductID" = o."ProductID"
inner join propertyinfo pi 
on pi."PropID" = o."PropertyID"
where "ProductName" = 'Coffee Maker' and "PropertyState" = 'Texas';

--12. Which month in the year 2015 had the highest sales.
select EXTRACT(Month FROM "OrderDate"), sum("Quantity" * "Price") "monthly sales"
from products inner join orders
using ("ProductID")
group by EXTRACT(Month FROM "OrderDate")
order by "monthly sales" desc
limit 2;

--13 What are the product categories with a product id spanning 10 to 30.
select "ProductCategory", "ProductID"
from products
where "ProductID" between 10 and 30
-- or where "ProductID" >= 10 and "ProductID" <= 30;

--14. How many products start with the letter ‘D’.
select count(*)
from products
where "ProductName" LIKE 'D%';

--15. What are the product categories having the letter ‘e’
select count(*), "ProductCategory"
from products
where "ProductCategory" LIKE '%e%'
group by "ProductCategory";

--16. Return all orders where the quantity ordered is above 5.
select (*) from orders
group by "OrderID"
having "Quantity" > 5
--17. Find all instances where the product ‘Bed (King)’ was ordered.
select * from orders
inner join products
using ("ProductID")
where "ProductName" = 'Bed (King)';
/*18. Find the name and category, property city and state of the product with a productid of
105 */

select "ProductName", "ProductCategory", "PropertyCity", "PropertyState"
from products p inner join orders o
on p."ProductID" = o."ProductID"
inner join propertyinfo pi 
on pi."PropID" = o."PropertyID"
where p."ProductID" = 105;


/*19. A customer has requested for a refund claiming they procured goods from our store.
Provide all the details of this order if the OrderID is = ‘3896’ */

select (*)
from products p inner join orders o
on p."ProductID" = o."ProductID"
inner join propertyinfo pi 
on pi."PropID" = o."PropertyID"
where "OrderID" = 3896;

--20. Find the name and category of products whose prices ranges from $1 to $50

select "ProductName", "ProductCategory", "Price"
from products
where "Price" between 1 and 45;

/*21. Find the number of Permanent Markers, ‘Sticky Notes’ and ‘Note Pads’ ordered for the
year 2015. Find all products in the year 2016, where the quantity ordered was greater than
50 */

select "ProductName", count(*) from products
inner join orders 
using ("ProductID")
where "ProductName" in ('Permanent Markers', 'Sticky Notes', 'Note Pads') and EXTRACT(YEAR FROM "OrderDate") = 2015
group by "ProductName";

/* 22. SM-stores wants to re-evaluate the prices of their goods, provide a list of their products,
categories and the corresponding prices. Group their products into cheap(<50),
affordable(<100), expensive */

select "ProductName", "ProductCategory", "Price",
case 
	when "Price" <= 50 then 'cheap'
	when "Price" <= 100 then 'Affordable'
	else 'Expensive'
	end as "PriceCategory"
from products;

--CREATING VIEWS
create view all_tables as
(select *
from products p inner join orders o
using ("ProductID")
inner join propertyinfo pi 
on pi."PropID" = o."PropertyID");

select * from all_tables;