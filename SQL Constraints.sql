/* Ex 7 Constraints */

/*The deliverable for this exercise is a Word document. Put your name
and the exercise number (Ex 7) as a header in a Word document 
as you begin the exercise. Name the Word document 
ex7_lastname_firstname_section#.docx.*/

/*Here in the exercise instructions, you are prompted to (1) complete 
tasks, (2) take screen shots that document your hands-on work and 
insert them into the deliverable document, and/or (3) write something 
in the deliverable document. Use the Windows Snipping Tool or something 
like it to capture just the portion of the screen you need to document 
your work.

Whenever you capture work with a screenshot, include your name in 
the screenshot. This guideline applies to any screenshots you take 
to document your hands-on work throughout the semester. You may not 
get credit for something if you do not include your name as 
requested. */


/* The tasks refer to the ITAM schema tables that you created on your
own instance of Oracle in the cloud. */


/* Task 1. Create a Default Constraint
A default constraint can added to a column to help assure domain
integrity. These are added using the alter table command as demonstrated in class. 
For example, here are some ITAM business rules that may or may not be supported 
with default constraints.*/


--Ex 7 Task 1 Command 1 Create the Constraint
--Tara Bussey
--Implementing: (3) When a CI is first added to inventory, the status of the
-- CI should be 'WORKING'.

alter table ci_inventory
modify ci_status_code default 'WORKING';

select * from ci_inventory;

rollback;

insert into asset_desc
values (38, 1, 'Apple', 'Mac Mini OS 8',
'Mac Mini OS');

--Ex 7 Task 1 Command 2 Demonstrate the Constraint Working with Insert
--Tara Bussey
--Implementing: (3) When a CI is first added to inventory, the status of the
-- CI should be 'WORKING'.
insert into asset_desc
values (38, 1, 'Apple', 'Mac Mini OS 8',
'Mac Mini OS');

insert into ci_inventory 
(ci_inv_id, asset_desc_id, purchase_or_rental, unique_id, ci_acquired_date, ci_status_date)
values (38, 38, 'RENTAL', 'Serial No. 872234599999', '18-MAR-23', '18-MAR-23');


--Ex 7 Task 1 Command 3 Demonstrate the Constraint Working with Select After 
--Insert
--Tara Bussey
--Implementing: (3) When a CI is first added to inventory, the status of the
-- CI should be 'WORKING'.

select * from ci_inventory where ci_inv_id = 38;


/* Task 2. Create a Unique Constraint */


ALTER TABLE department  DROP CONSTRAINT DEPT_PK;


--Ex 7 Task 2 Command 1 - Create a Unique Constraint
--Tara Bussey
--Implementing: (1) Department names are unique.
alter table department
add constraint dept_name_constraint unique (dept_name);

select * from employee spjohns@abcco.com;



select * from department;



--Ex 7 Task 2 Command 2 - Demonstrate the Constraint Working (Prevent Incorrect
--Data)
--Tara Bussey
--Implementing: (1) Department names are unique.
insert into department 
values ('Hum Res', 'Human Resources');



--Ex 7 Task 2 Command 3 - Demonstrate the Constraint Working (Allow Correct
--Data)
--Tara Bussey
--Implementing: (1) Department names are unique.
insert into department 
values ('SALE', 'Sales Team');


/* Task 3. Create a Check Constraint */

--Ex 7 Task 3 Command 1 - Create the Constraint
--Tara Bussey
--Implementing: (4) The values allowed for the use or support attribute of the
--employee_CI table are either USE or SUPPORT.
alter table employee_ci
add constraint use_or_support_constraint
check (use_or_support in ('USE', 'SUPPORT'));


--Ex 7 Task 3 Command 2 - Demonstrate the Constraint Working (Prevent Bad Data)
--Tara Bussey
--Implementing: (4) The values allowed for the use or support attribute of the
--employee_CI table are either USE or SUPPORT.
insert into employee_ci values (1104, 942, 'RENT',
to_date ('05-FEB-23 09:40:15 AM', 'DD-MON-RR HH:MI:SS PM'),
to_date ('05-FEB-23 09:40:15 AM', 'DD-MON-RR HH:MI:SS PM'));


select * from employee;

--Ex 7 Task 3 Command 3 - Demonstrate the Constraint Working (Allow Good Data)
--Tara Bussey
--Implementing: (4) The values allowed for the use or support attribute of the
--employee_CI table are either USE or SUPPORT.
insert into employee
values (40, 'Angela', 'Martin', 9184,
'281-832-9458', 'amartin@abcco.com', 'HIRE',
'05-FEB-23', 'SALE','Sales Woman', 2);

insert into employee_ci values (38, 40, 'USE',
to_date ('05-FEB-23 09:40:15 AM', 'DD-MON-RR HH:MI:SS PM'),
to_date ('05-FEB-23 09:40:15 AM', 'DD-MON-RR HH:MI:SS PM'));
