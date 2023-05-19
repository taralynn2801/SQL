
/* Task 1. Your manager says, "I need a list asset descriptions for items 
that were once in inventory but have been disposed of. I want the make, model, 
extended information, and the type of asset it is. Put the list in alphabetical 
order by make and model. Make the result set have column headers of Make, Model, 
More Info, and Type. The type is what type of asset is being described. Is 
it a computer, a server, and application, etc.? If there is more than one of 
a certain asset description in the results get only one row with the information
(that is, assure no duplicate rows). 

In writing your query, you know that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so you 
decide to use only non-derived data from other tables to determine the count(s).
*/

--Task 1 Assets Descriptions with Disposed CIs
--Tara Bussey
select distinct asset_make as make, asset_model as model,
asset_ext as MoreInfo, asset_type_desc as Type
from jaherna42.asset_desc ad
join jaherna42.ci_inventory cii on ad.asset_desc_id = cii.asset_desc_id
join jaherna42.asset_type at on at.asset_type_id = ad.asset_type_id
where upper (ci_status_code) = 'DISPOSED'
order by asset_make,asset_model;




/* Task 2. Your manager says, "I would like a report with a list of descriptions 
of different IT assets we have in our system that are signed out to an employee 
on the executive team who is using the asset to do their job. I need to know 
the make and model of the asset and what type of asset it is. Is it a computer 
or is it software or is it something else? Make sure the list does not have 
old information for people who are no longer employeed or assets that have 
been disposed of." 

In writing your query, you know that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so you 
decide to use only non-derived data from other tables to determine the count(s).
*/

--Task 2 Asset Description for Assets in Use by Someone on the Executive Team
--Tara Bussey 
select distinct asset_make as make, asset_model as model, asset_type_desc as Type
from jaherna42.asset_desc ad
join jaherna42.ci_inventory cii on ad.asset_desc_id = cii.asset_desc_id
join jaherna42.employee_ci eci on cii.ci_inv_id = eci.ci_inv_id
join jaherna42.employee e on eci.emp_id = e.emp_id
join jaherna42.asset_type at on at.asset_type_id = ad.asset_type_id
where upper (ci_status_code) = 'WORKING' and e.emp_id in
(select eci.emp_id from jaherna42.employee where upper (dept_code) = 'EXEC' and upper (use_or_support) = 'USE')
order by asset_make,asset_model;

-- This include items also in repair
select distinct asset_make as make, asset_model as model, asset_type_desc as Type
from jaherna42.asset_desc ad
join jaherna42.ci_inventory cii on ad.asset_desc_id = cii.asset_desc_id
join jaherna42.employee_ci eci on cii.ci_inv_id = eci.ci_inv_id
join jaherna42.employee e on eci.emp_id = e.emp_id
join jaherna42.asset_type at on at.asset_type_id = ad.asset_type_id
where upper (ci_status_code) in ('WORKING', 'INREPAIR') and e.emp_id in
(select eci.emp_id from jaherna42.employee where upper (dept_code) = 'EXEC' and upper (use_or_support) = 'USE')
order by asset_make,asset_model;

/* Task 3. Your manager says, "Now I would like to know how many Lenovo, Apple, 
and Dell comptuers are currently being used by a member of the executive team. 
I want description information for the make, model, and extended 
information for each Lenovo, Apple, or Dell with a count of how many. And,
of course, I don't want information about computers that are gone." 

In writing your query, you know that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so you 
decide to use only non-derived data from other tables to determine the count(s).
*/

--Task 3 Lenovos Used by Execs and Supported
--Tara Bussey
select distinct ad.asset_make as make, ad.asset_model as model,
ad.asset_ext as MoreInfo,  count(ad.asset_desc_id)
from jaherna42.asset_desc ad
join jaherna42.ci_inventory cii on ad.asset_desc_id = cii.asset_desc_id
join jaherna42.employee_ci eci on cii.ci_inv_id = eci.ci_inv_id
join jaherna42.employee e on eci.emp_id = e.emp_id
join jaherna42.asset_type at on at.asset_type_id = ad.asset_type_id
where lower (ad.asset_make) in ('apple', 'dell', 'lenovo') and lower (at.asset_type_desc) = 'computer'
and upper (ci_status_code) = 'WORKING' and e.emp_id in (select eci.emp_id
from jaherna42.employee where upper (dept_code) = 'EXEC' and upper (use_or_support) = 'USE')
group by ad.asset_make, ad.asset_model, ad.asset_ext, at.asset_type_desc
order by asset_make,asset_model;





/* Task 4. Your manager says, "I need a list of the make, model, and other 
information for computers we have in inventory that are spares that are ready 
to be assigned to someone to do their job. So by spare, I mean that no one is 
currently assigned the computer as the one they use to do their job. A spare 
computer would also not be one that is broken, obsolete (no longer in use), or 
disposed of. 

In writing your query, you know that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so you 
decide to use only non-derived data from other tables to determine the count(s).
*/

--Task 4 Spare CIs 
--Tara Bussey
select distinct asset_make as make, asset_model as model, asset_ext as MoreInfo
from jaherna42.asset_desc ad
join jaherna42.ci_inventory cii on ad.asset_desc_id = cii.asset_desc_id
join jaherna42.employee_ci eci on cii.ci_inv_id = eci.ci_inv_id
join jaherna42.asset_type at on at.asset_type_id = ad.asset_type_id
where upper (ci_status_code) = 'WORKING' and lower (at.asset_type_desc) = 'computer'
and date_unassigned is not null and eci.ci_inv_id in
(select eci.ci_inv_id from jaherna42.employee_ci where date_unassigned
is not null and upper (eci.use_or_support) = 'USE');

select * from jaherna42.employee_ci where date_unassigned is not null and use_or_support = 'USE';
select * from jaherna42.employee where dept_code = 'EXEC';



/* Task 5. From the ITAM tables in the jaherna42 schema, answer this question 
from a manager, "Are there computers that we can use as loaners for employees 
on the executive team when their assigned computer is in for repair or upgrade?
In particular, we need to know if we have any Lenovos, Apples, or Dells on hand
that are spare and how many of each make and model combo we have on hand for 
each brand. The executive team wants to use only these particular makes of c
omputer".

In writing your query, you know that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so you 
decide to use only non-derived data from other tables to determine the count(s).
*/

--Task 5 Count of Spare Lenovos, Apples, and Dells
--Tara Bussey
select ad.asset_make, ad.asset_model,count(ad.asset_desc_id)
from jaherna42.ci_status cis
join jaherna42.ci_inventory cii on cis.ci_status_code = cii.ci_status_code
join jaherna42.asset_desc ad on cii.asset_desc_id = ad.asset_desc_id
join jaherna42.asset_type at on at.asset_type_id =
ad.asset_type_id
where upper(at.asset_type_desc) = upper('Computer')
and upper (trim(ad.asset_make)) in ('DELL','LENOVO','APPLE')
and upper (cis.ci_status_code) = 'WORKING'
and cii.ci_inv_id not in (select eci.ci_inv_id
from jaherna42.employee_ci eci 
where upper(eci.use_or_support) = 'USE' and
eci.date_unassigned is null)
group by ad.asset_make,ad.asset_model
order by asset_make,asset_model;


--Task 5 Count of Spare Lenovos, Apples, and Dells (another way)
--Tara Bussey
select ad.asset_make, ad.asset_model,count(ad.asset_desc_id)
from jaherna42.ci_status cis
join jaherna42.ci_inventory cii on cis.ci_status_code = cii.ci_status_code
join jaherna42.asset_desc ad on cii.asset_desc_id = ad.asset_desc_id
where upper(ad.asset_type_id) = 2
and upper (trim(ad.asset_make)) in ('DELL','LENOVO','APPLE')
and upper (cis.ci_status_code) = 'WORKING'
and cii.ci_inv_id not in (select eci.ci_inv_id
from jaherna42.employee_ci eci 
where upper(eci.use_or_support) = 'USE' and
eci.date_unassigned is null)
group by ad.asset_make,ad.asset_model
order by asset_make,asset_model;







/* Task 6. Write a query that retrieves the same information that was
requested by Task 5, only this time use the summary information in 
it_asset_inv_summary table to get the counts. Note that since there is no 
automation in place that keeps the derived information in it_asset_inv_summary 
table current, the data returned by the Task 6 query could be quite different 
from the data returned by the Task 5 query. */

--Task 6 Count of Spare Dells, Apples, and Lenovos From IT Asset Inventory 
--Summary Table
--Tara Bussey
select ad.asset_make, ad.asset_model,count(iais.it_asset_inv_summary_id)
from jaherna42.ci_status cis
join jaherna42.ci_inventory cii on cis.ci_status_code = cii.ci_status_code
join jaherna42.asset_desc ad on cii.asset_desc_id = ad.asset_desc_id
join jaherna42.it_asset_inv_summary iais on ad.asset_desc_id = iais.asset_desc_id
where upper(ad.asset_type_id) = 2
and upper (trim(ad.asset_make)) in ('DELL','LENOVO','APPLE')
and upper (cis.ci_status_code) = 'WORKING'
and cii.ci_inv_id not in (select eci.ci_inv_id
from jaherna42.employee_ci eci 
where upper(eci.use_or_support) = 'USE' and
eci.date_unassigned is null)
group by ad.asset_make,ad.asset_model
order by asset_make,asset_model;


/* Task 7. Use the union all operator to join the results from the Task 5 query 
with the results from the Task 6 query for an easier comparison of the data 
returned. Add a first column to each column list to indicates which query
(Task 5 or Task 6) generated the retrieved data. To do this, just add:
'Task 5' as "Which Task" as the first column for the Task 5 query and add:
'Task 6' as "Which Task" as the first column for the Task 6 query. 'Task 5'
and 'Task 6' are string literal values that are retrieved in each row, and 
"Whick Task" is the alias for the column name for the first column that 
will contain the literal values.*/

--Task 7 Compare Spare Dells and Lenovos Results from Task 5 and Task 6
--Tara Bussey
select ad.asset_make, ad.asset_model,count(ad.asset_desc_id)
from jaherna42.ci_status cis
join jaherna42.ci_inventory cii on cis.ci_status_code = cii.ci_status_code
join jaherna42.asset_desc ad on cii.asset_desc_id = ad.asset_desc_id
where upper(ad.asset_type_id) = 2
and upper (trim(ad.asset_make)) in ('DELL','LENOVO','APPLE')
and upper (cis.ci_status_code) = 'WORKING'
and cii.ci_inv_id not in (select eci.ci_inv_id
from jaherna42.employee_ci eci 
where upper(eci.use_or_support) = 'USE' and
eci.date_unassigned is null)
group by ad.asset_make,ad.asset_model

union all

select ad.asset_make, ad.asset_model,count(iais.it_asset_inv_summary_id)
from jaherna42.ci_status cis
join jaherna42.ci_inventory cii on cis.ci_status_code = cii.ci_status_code
join jaherna42.asset_desc ad on cii.asset_desc_id = ad.asset_desc_id
join jaherna42.it_asset_inv_summary iais on ad.asset_desc_id = iais.asset_desc_id
where upper(ad.asset_type_id) = 2
and upper (trim(ad.asset_make)) in ('DELL','LENOVO','APPLE')
and upper (cis.ci_status_code) = 'WORKING'
and cii.ci_inv_id not in (select eci.ci_inv_id
from jaherna42.employee_ci eci 
where upper(eci.use_or_support) = 'USE' and
eci.date_unassigned is null)
group by ad.asset_make,ad.asset_model
order by asset_make,asset_model;




/*Task 8. Task 7 asked you to use the union all operator. Look up information 
to determine the difference between the union and union all operators. Run the 
following two queries against your A and B tables that we created in class to 
observe the difference between union and union all. Then, as your deliverable, 
write two or three sentences explaining the difference. Use professional writing
skills. *Note that no screenshot of results from either give query is required.
*/

--Use the two queries to compare union to union all
select a_id,col_2,col_3 from A
union 
select a_id_inb, col_2,col_3 from A join B on a_id = a_id_inb;

select a_id,col_2,col_3 from A
union all
select a_id_inb, col_2,col_3 from A join B on a_id = a_id_inb;

--Task 8 Union versus Union All
--Tara Bussey
 /* Both union and union all are used to commbine the results from one
 or more queries, however union combines the two sets while also removing
 and duplicate rows. Union all combines all the rows from the queries including
 duplicates. In the example above, the union all query returns more than the union
 query because it includes all duplicate rows.*/ 





/* Task 9. Retrieve the employee name, asset_description, and date_assigned, 
for all assets assigned to an employee for use BEFORE XX AM on Month DD of 
YYYY, and that are still in use by the employee. For this task, choose your 
own value of XX, your own value for Month, your own value for DD, and your own 
value for YYYY. Hard code the date/time value to be compared to in your where 
clause and make sure your query returns at least one row.

In writing your query, you know that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so you 
decide to use only non-derived data from other tables to determine the count(s).
*/

--Task 9 Assets Assigned After a Specific Date/Time Value
--Tara Bussey
select e.first_name as firstName, e.last_name as lastName, ad.asset_ext, eci.date_assigned 
from jaherna42.asset_desc ad
join jaherna42.ci_inventory cii on ad.asset_desc_id = cii.asset_desc_id
join jaherna42.employee_ci eci on cii.ci_inv_id = eci.ci_inv_id
join jaherna42.employee e on eci.emp_id = e.emp_id
where date_assigned <= to_date('28-SEP-2022 08:00:00', 'DD-MON-YYYY HH:MI:SS')
and upper(eci.use_or_support) = 'USE';



/* Task 10. Retrieve the employee name, asset_description, and date_assigned, 
for all assets assigned where the assignment happened on a specific date of 
your choosing. When you retrieve the date_assigned, display the time value 
associated with the date as well as the date value (use the to_char function).
Your query must retrieve all rows for the specific date, regardless of the time 
the assignment got recorded on that date. Use the trunc function in the where 
clause so that all matching dates are retrieved regardless of their time parts.
Your query must return at least one row.

In writing your query, you know that the derived information in the 
it_asset_inv_summary table is not kept up to date in an automated way, so you 
decide to use only non-derived data from other tables to determine the count(s).
*/

--Task 10 Assets Assigned on a Specific Date
--Tara Bussey 
select e.first_name as firstName, e.last_name as lastName, ad.asset_ext as assetDESC,
eci.date_assigned as dateAssigned, to_char(eci.date_assigned, 'HH:MI:SS' ) as time
from jaherna42.asset_desc ad
join jaherna42.ci_inventory cii on ad.asset_desc_id = cii.asset_desc_id
join jaherna42.employee_ci eci on cii.ci_inv_id = eci.ci_inv_id
join jaherna42.employee e on eci.emp_id = e.emp_id
where date_assigned = trunc(to_date('21-AUG-2022','DD-MON-YYYY'))
and upper(eci.use_or_support) = 'USE';
