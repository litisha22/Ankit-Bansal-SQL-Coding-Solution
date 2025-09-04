--Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

--1- write a query to get total sales for each profit group. Profit groups are defined as  
--profit < 0 -> Loss
--profit < 50 -> Low profit
--profit < 100 -> High profit
--profit >=100 -> very High profit

select 
case when profit < 0 then 'loss'
	 when profit < 50 then 'Low Profit'
	 when profit < 100 then 'High Profit'
	 when profit >=100 then 'Very High Profit'
end as profit_category,
sum(sales) as total_sales
from dbo.orders
group by 
case when profit < 0 then 'loss'
	 when profit < 50 then 'Low Profit'
	 when profit < 100 then 'High Profit'
	 when profit >=100 then 'Very High Profit'
end  


--2- orders table can have multiple rows for a particular order_id when customers buys more than 1 product in an order.
--write a query to find order ids where there is only 1 product bought by the customer.

select order_id from dbo.orders
group by order_id
having count(order_id) = 1

--3- write a query to get total profit, first order date and latest order date for each category

select category, sum(profit) as total_profit, min(order_date) as first_order_dt,
max(order_date) as latest_order_dt from dbo.orders
group by category

--4- write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category (validate the output using excel)

select sub_category from dbo.orders
group by sub_category
having avg(profit) > max(profit)/2

--5- create the exams table with below script;
--create table exams (student_id int, subject varchar(20), marks int);

--insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
--,(2,'Chemistry',80),(2,'Physics',90)
--,(3,'Chemistry',80),(3,'Maths',80)
--,(4,'Chemistry',71),(4,'Physics',54)
--,(5,'Chemistry',79);

--write a query to find students who have got same marks in Physics and Chemistry.

select a.student_id from 
((select * from dbo.exams where subject = 'Chemistry') a
inner join (select * from dbo.exams where subject = 'Physics') b
on a.student_id = b.student_id and a.marks = b.marks)

select student_id , marks
from exams
where subject in ('Physics','Chemistry')
group by student_id , marks
having count(1)=2

--6- write a query to find total number of products in each category.

select category, count(distinct product_id) from dbo.orders
group by category

--7- write a query to find top 5 sub categories in west region by total quantity sold

select top 5 sub_category, sum(quantity) as total_quantity
from dbo.orders
where region = 'West'
group by sub_category
order by total_quantity desc

--8- write a query to find total sales for each region and ship mode combination for orders in year 2020

select region, ship_mode, sum(sales) as total_sales 
from dbo.orders
where order_date like '2020-%'
group by region, ship_mode

--9- write a query to get region wise count of return orders

select o.region, count(distinct o.order_id)
from dbo.orders o
inner join dbo.returns r on o.order_id = r.order_id
group by o.region

--10- write a query to get category wise sales of orders that were not returned

select o.category, sum(o.sales) as total_sales
from dbo.orders o
left join dbo.returns r on o.order_id = r.order_id
where r.order_id is null
group by o.category

--11- write a query to print dep name and average salary of employees in that dep .

select d.dep_name, avg(e.salary) as avg_sal
from dbo.employee e
inner join dbo.dept d on e.dept_id =d.dep_id
group by d.dep_name

--12- write a query to print dep names where none of the emplyees have same salary.

select d.dep_name
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name
having count(e.emp_id)=count(distinct e.salary)

--13- write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)

select o.sub_category, count(r.return_reason)
from dbo.returns r
inner join dbo.orders o on r.order_id = o.order_id
group by o.sub_category
having count(distinct r.return_reason) = 3

--14- write a query to find cities where not even a single order was returned.

select city
from orders o
left join returns r on o.order_id=r.order_id
group by city
having count(r.order_id)=0

--15- write a query to find top 3 subcategories by sales of returned orders in east region

select top 3 o.sub_category, sum(o.sales) as total_sales 
from dbo.orders o
inner join dbo.returns r on o.order_id = r.order_id
where o.region = 'East'
group by o.sub_category
order by total_sales desc

--16- write a query to print dep name for which there is no employee

select d.dep_name
from dbo.dept d
left join dbo.employee e on d.dep_id = e.dept_id
where e.dept_id is null

--17- write a query to print employees name for which dep id is not present in dept table

select e.emp_name from dbo.employee e
left join dbo.dept d on e.dept_id = d.dep_id
where d.dep_id is null

--18- write a query to print 3 columns : category, total_sales and (total sales of returned orders)

select o.category, sum(o.sales) as total_sales,
sum(case when r.order_id is not null then sales else null end) as return_sales
from dbo.orders o
left join dbo.returns r on o.order_id = r.order_id
group by category

