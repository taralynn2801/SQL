/*In this SQL, I'm querying a database with multiple tables in it to quantify statistics about customer and order data.*/


/*How many orders were placed in January? */
select count(orderID)
from BIT_DB.JanSales
where length(orderid) = 6 
and orderid <> 'Order ID'



/*How many of those orders were for an iPhone?*/
select count(orderID)
from BIT_DB.JanSales
where Product = 'iPhone'
and length(orderid) = 6 
and orderid <> 'Order ID'



/*Select the customer account numbers for all the orders that were placed in February.*/
select distinct cust.acctnum
from customers as cust
join FebSales as feb
on cust.order_id = feb.orderID
where length(orderid) = 6 
and orderid <> 'Order ID'



/*Which product was the cheapest one sold in January, and what was the price?*/
select distinct Product, price
from JanSales
order by price asc 
limit 1



/*What is the total revenue for each product sold in January?
(Revenue can be calculated using the number of products sold and the price of the products)*/
SELECT sum(quantity)*price as revenue, product
FROM BIT_DB.JanSales
GROUP BY product



/*Which products were sold in February at 548 Lincoln St, Seattle,
WA 98101, how many of each were sold, and what was the total revenue?*/
select product, sum(quantity), sum(quantity)*price as revenue
from BIT_DB.FebSales 
where location = '548 Lincoln St, Seattle, WA 98101'
group by product



/*How many customers ordered more than 2 products at a time in February, and what was the average amount
spent for those customers?*/
select 
count (distinct cust.acctnum),
avg(quantity*price)
from customers cust
join FebSales feb
on cust.order_id = feb.orderID
where feb.quantity > 2
AND length(orderid) = 6 
AND orderid <> 'Order ID'
