/* Task 1 Most Recent App Download
Write a command to retrieve which app was 
downloaded most recently, when it was downloaded, 
and the name of the customer who downloaded it. */

--Ex 5 Task 1 Command 1 Most Recent Download
--Tara Bussey
select d.app_code as "App Name", d.srvr_timestamp as "Date Downloaded",
c.cust_firstname as "Customer First Name", c.cust_lastname as  "Customer Last Name"
from jaherna42.download d 
join jaherna42.customer c on d.cust_id = c.cust_id
order by srvr_timestamp desc
fetch first 1 rows only;


select d.app_code as "App Name", d.srvr_timestamp as "Date Downloaded",
c.cust_firstname as "Customer First Name", c.cust_lastname as  "Customer Last Name"
from jaherna42.download d 
join jaherna42.customer c on d.cust_id = c.cust_id
order by srvr_timestamp asc
fetch first 1 rows only;
-- ASCENDING





/* Task 2 Compare to Your Time Zone
What time was it in your time zone when the most recent
app was downloaded? Use Oracle's tz_offset function to 
compare the time zone offset value for your time zone to
the server time zone of the most recent downloaded app. 
A template for the command is provided.*/

--Ex 5 Task 2 Compare to Your Time Zone
--Tara Bussey
select 'Central' as zone, tz_offset('America/Chicago')
from dual
union
select 'Most Recent App Download Zone' as zone, 
tz_offset('EUROPE/PRAGUE') from dual;





/* Task 3 Time Zone Arithmetic
Subtract the most recent app download time 
from the current server time (as a timestamp) 
to see what the day/time difference is between 
the two. In addition to the commands and output, 
write a sentence (as a comment) to state what 
the data type of the difference you computed is.*/

--Ex 5 Task 3 Time Zone Arithmetic
--Tara Bussey
select (sysdate - max(srvr_timestamp)) as "Date Difference"
from jaherna42.download;

--Write your sentence to state the data type here

/* The data type of the distance is an INTERVAL DAY TO SECOND data type. 
This data type returns and interval between two dates including days all the
way to a fraction of a second.
source: https://www.oracletutorial.com/oracle-basics/oracle-interval */




/* Task 4 More than One Download
Some customers have downloaded software more than once. 
Write a command to retrieve customer ids for customers 
who have more than downloaded more than once. *Hint: You 
need a group by clause and a having clause that uses the 
count function, but you will not retrieve the count. 
Rather you will retrieve the customer id.*/

--Ex 5 Task 4 More than One Dowload
--Tara Bussey
select cust_id
from jaherna42.download
group by cust_id
having count(*) > 1;



/* Task 5 Time Between Earliest and Latest Download for
Customers with More than One Download
Write a query to compute the time between the earliest 
and latest download times for customer with more than 
one download. *Hint: Use the Task 4 query as a subquery 
with a having clause based on cust_id being in the 
result set of the Task 4 query. */

--Ex 5 Task 5 Time Between Earliest and Latest Download for
--Customers with More than One Download
-- Tara Bussey
select cust_id,
(max(srvr_timestamp) - min(srvr_timestamp))
as "Date Difference"
from jaherna42.download
group by cust_id
having count(*)>1;

-- didnt have to use a subquery


select (max(srvr_timestamp) - min(srvr_timestamp)) as "Date Difference"
from jaherna42.download;



 
/* Task 6. Refer to the ITAM schema tables belonging to 
user JAHERNA42. Write and test a query to report what 
configuration items (CIs) were assigned (or reassigned) 
for use during the nine calendar months prior to the 
current month. (For example, if today is Oct. 3, 2022, 
then I want to see items assigned between January 1, 2022 
and September 30, 2022, inclusive. Or if today were August 
22, 2022, then I want to see items assigned between November
1, 2021 and July 31, 2022.) The identifying 
information for the CIs that you are to retrieve include 
the date the CI was assigned for use, its make, its model, 
its type (description), and other details about the CI 
(such as its serial number).  

Capture a screenshot of the query with your name above it 
and 5 or 6 rows of the result set (after scrolling to the 
end of the result set in order to update the total rows 
fetched value). */

-- Ex 5 Task 6 Write the Query
--*Note that it is OK if you use hard-coded dates
--in the where clause
--Tara Bussey
select eci.date_assigned as "Date Assigned", ad.asset_make as make,
ad.asset_model as model, at.asset_type_desc as type, ad.asset_ext as MoreInfo  
from jaherna42.asset_desc ad
join jaherna42.asset_type at on at.asset_type_id = ad.asset_type_id
join jaherna42.ci_inventory cii on ad.asset_desc_id = cii.asset_desc_id
join jaherna42.employee_ci eci on cii.ci_inv_id = eci.ci_inv_id
where eci.date_assigned >= add_months(trunc(sysdate, 'MM'), -9)
and eci.date_assigned <= trunc(sysdate, 'MM');



/* Task 7. The requesting manager is so pleased with your 
report (from Task 6) she wants you to provide the same 
report no later than the 12th of each month, for the 
nine-month period preceding the start of the current month 
when the report is run. So now you realize that it makes 
sense to create a view based on the query you used to 
deliver the first report. The view will be most useful 
if you generalize the date filter so that it retrieves data 
for the nine month period preceding the start of the current 
month, regardless of when you run the query to select the 
data through the view. 

Here are some steps to help you figure out one way to 
generalize the where clause condition so that the query 
returns data in the proper date range. There is more than 
one way to generalize the condition. You do not have to 
document your work with details of these steps.*/

--Step 1 Run this query to see what it returns.
select add_months(sysdate,-9) from dual;

--Step 2 Run this query to see what it returns.
select to_char(add_months(sysdate,-9),'MM-YY') from dual;

--Step 3 Use the to_date function to turn the string 
--literal returned in the previous step into a date value
--of the form 'MM-YY'.
--Replace X with the expression in the selection list
--of the Step 2 query.
select to_date('06-22','MM-YY') from dual;
select to_date(to_char(add_months(sysdate,-9),'MM-YY'),'MM-YY')
from dual;

--Step 4 (Analyze) The value you see from Step 3  
--should be the lower limit of the 9 month date  
--range you want to use as the boundaries for the   
--rows you want to be returned by your view.

--Step 5 Run this query to see what it returns.
select to_char(sysdate,'MM-YY') from dual;
-- this is the upper limit??

--Step 6 Use the to_date function to turn the string 
--literal returned in the previous step as a date value
--of the form 'MM-YY'.
--Replace X with the expression in the selection list
--of the Step 6 query.
select to_date('03-23','MM-YY') from dual;

--Step 7 (Analyze) The value you see from Step 6  
--should be one day after the upper limit of the 9 
--month date range you want to use as the boundaries 
--for the rows you want to be returned by your view.
--In order to push the upper limit back one day, 
--subtract 1 from the date value. Run the following
--query to check, replacing X with the expression in 
--the selection list of the Step 6 query.
select to_date('03-23','MM-YY')-1 from dual;

--Step 8 (Apply) Use what you learned to create
--a where clause condition that uses the between
--operator to limit the rows returned based on 
--an appropriate stored date value being between
--the lower limit and the upper limit expressed
--by the calculation of Step 7 and Step 3.

/* Once you get the query written to return the requested
data from the ITAM tables of JAHERNA42 and it is limited 
to records in a generalized date range of nine months 
preceding the start of the current month up to the start 
of the current month, create a view in your schema that 
is based on the query.

Capture your name in a comment, the create statement for 
the view, and the response in the Script Output window 
that indicates successful creation of the view.*/


--Ex 5 Task 7 Create the View
--Tara Bussey
create or replace view cis_from_last_9_months as 
    select eci.date_assigned as DateAssigned, ad.asset_make as make,
    ad.asset_model as model, at.asset_type_desc as type, ad.asset_ext as MoreInfo,
    ad.asset_desc_id as CI_ID
    from jaherna42.asset_desc ad
    join jaherna42.asset_type at on at.asset_type_id = ad.asset_type_id
    join jaherna42.ci_inventory cii on ad.asset_desc_id = cii.asset_desc_id
    join jaherna42.employee_ci eci on cii.ci_inv_id = eci.ci_inv_id
    where eci.date_assigned >= to_date(to_char(add_months(sysdate,-9),'MM-YY'),'MM-YY')
    and eci.date_assigned <= to_date('03-23','MM-YY')-1;
    
    
    select * from cis_from_last_9_months;


/* Task 8. Use the View to Return Data
Once you have the view created, use it to return 
the data requested. Take a screenshot of the command where 
you use the view together with about 5 rows of the results 
returned after scrolling down to update the number of rows 
fetched.*/


--Ex 5 Task 8 Use the View to Return Data
--Tara Bussey
select * from cis_from_last_9_months;

/* Task 9. Change Data Through the View
For the view created in Task 7 and used in Task 8,
examine its column details in Oracle SQL Developer by 
selecting it from your Views folder in the Connections pane. 
Write a statement of where data can be changed in a column of a base 
table of the the view by changing data through the view. 
Then write a DML command to demonstrate that data in base table
can be inserted, updated, or deleted through the view. 
The command you write will most likely be an update command.
Capture your name, the command, and the result of 
running the command, and the result of running a select 
command on the base tables that demonstrates the success 
of the update statement. */

--Ex 5 Task 9 Change Data Through the View
--Tara Bussey
--State what columns are insertable, updatable, etc. throu the view
--Screenshot 1 - The command to insert, update, or delete through the view
--and result

-- the date_assigned column is insertable, updatable, and deletable

update cis_from_last_9_months
set cis_from_last_9_months.dateassigned = to_date('15-FEB-2023 08:00:00',
'DD-MON-YYYY HH:MI:SS')
where cis_from_last_9_months.ci_id = 714;



--Tara Bussey
--Screenshot 2 - A select from the base tables that verifies the
--success of the change-through-the-view operation

select * from cis_from_last_9_months
where cis_from_last_9_months.ci_id = 714;




/*Task 10. The requesting manager now decides she does not want 
information returned in the report if it is about IT assets that 
were assigned and then returned during the nine month period of 
the report. Alter the base query of the view to accomodate this 
change in requirements and then recreate the view and use 
it to select the data. Is the updated view updatable? Explain. */

--Ex 5 Task 10 Modify the View and Use the View
--Tara Bussey
create or replace view cis_from_last_9_months_not_returned as 
    select eci.date_assigned as DateAssigned, ad.asset_make as make,
    ad.asset_model as model, at.asset_type_desc as type, ad.asset_ext as MoreInfo,
    ad.asset_desc_id as CI_ID
    from jaherna42.asset_desc ad
    join jaherna42.asset_type at on at.asset_type_id = ad.asset_type_id
    join jaherna42.ci_inventory cii on ad.asset_desc_id = cii.asset_desc_id
    join jaherna42.employee_ci eci on cii.ci_inv_id = eci.ci_inv_id
    where lower (cii.ci_status_code) in ('working', 'inrepair') and eci.date_assigned >=
    to_date(to_char(add_months(sysdate,-9),'MM-YY'),'MM-YY')
    and eci.date_assigned <= to_date('03-23','MM-YY')-1;
    
select * from cis_from_last_9_months_not_returned;
      
--Ex 5 Task 10 Answer the Question Asked
--Tara Bussey
-- Yes, the updated view is updatable. The date_assigned column is still able
-- to be updated, inserted into, and deleted.
