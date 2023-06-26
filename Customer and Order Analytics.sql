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



/*List all the products sold in Los Angeles in February, and include how many of each were sold.*/
select product, sum(quantity)
from FebSales 
where location like '%Los Angeles%'
group by product



/*Which locations in New York received at least 3 orders in January, and how many orders did they each receive?*/
select distinct location, count(orderID)
from JanSales
where location like '%NY%'
AND length(orderid) = 6 
AND orderid <> 'Order ID'
GROUP BY location
HAVING count(orderID)>2



/*How many of each type of headphone were sold in February?*/
select distinct product, count(product)
from FebSales
where product like '%headphones%'
AND length(orderid) = 6 
AND orderid <> 'Order ID'
group by product



/*What was the average amount spent per account in February?*/
select sum(quantity*price)/count(cust.acctnum) as "average amount spent per account"
from customers cust
left join FebSales feb
on cust.order_id = feb.orderID
WHERE length(orderid) = 6 
AND orderid <> 'Order ID'



/*What was the average quantity of products purchased per account in February?*/
select sum(quantity)/count(acctnum) as "Average Quantitiy of Products Purchased Per Account"
from customers cust
left join FebSales feb
on cust.order_id = feb.orderID
WHERE length(orderid) = 6 
AND orderid <> 'Order ID'



/*Which product brought in the most revenue in January and how much revenue did it bring in total?*/
select product, sum(quantity*price) as "Product That Brought In Most Revenue"
from JanSales
group by product
order by sum(quantity*price) desc
LIMIT 1
