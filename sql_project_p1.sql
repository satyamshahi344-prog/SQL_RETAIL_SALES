create database sql_project_p1;

use sql_project_p1;

create table retail_sales (
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age int,
category varchar(15),
quantiy int,
price_per_unit float,
cogs float,
total_sale float);

select count(*) from retail_sales;

-- data cleaning 
select * from retail_sales
where 
		transactions_id is null
        or
        sale_date is null
        or 
        sale_time is null
        or 
        gender is null
        or 
        age is null
        or 
        category is null
        or 
        quantiy is null
        or
        price_per_unit is null
        or 
        cogs is null
        or 
        total_sale is null;
        
-- data exploration

-- how many sales we have
select count(*) as total_sale from retail_sales ;

-- --how many customer we have 
select count(distinct(customer_id)) as total_cus from retail_sales;

select count(distinct(category)) as total_cus from retail_sales;

select distinct(category) as total_cus from retail_sales;

-- data analysis 
-- 1 write a sql query to retrive all columns for sales mode on '2022-11-02'

select * from retail_sales
where sale_date = '2022-11-05'; 

-- write a sql query to retrieve all transacation where category is clothing and the quantity sold is more than 10 
   -- the month of nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantiy >= 4;
  
-- write a sql query to calulate the total sales (total_sales) for each categpory

select sum(total_sale) as total_sales,
category,
count(*) as total_orders
from retail_sales
group by 2;

-- write a sql query to find the average age of customer who purchased items from the "beauty' category

select category,avg(age)
from retail_sales
where category = 'beauty';

-- write a sql query to find  the transacation where the total_sale is greater than 1000

select
	transactions_id,sum(total_sale) as total_sales
    from retail_sales
    group by 1
    having total_sales >1000;
    
-- write a sql query to find the total number of transaction (transaction_id)made by each gender in each categroy

select category,gender,count(transactions_id) as total_number
from retail_sales
group by 1,2
order by 1;

-- write a sql query to calculate the average sale for each month . find the best selling month in each year
select * from 
		(select 
			year(sale_date) as year,
			monthname(sale_date) as month,
			avg(total_sale) as total_sales,
			rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rankes
		from retail_sales
		group by 1,2
	) as t1
    where rankes = 1;
-- order by 1,2,3 desc

-- write a sql query to find the top 5 customer based on the highest total sales
select * from retail_sales;
select
	customer_id,
    sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

-- write a sql query to find the number of unique customers who purchased items from each country

select 
	category,
    count(distinct customer_id) as uni_cus
from retail_sales
group by 1;

-- write a sql query to create each shift and number of orders (example morining <=12 afternoon between 12 and 17,evening>17)
with hourly_sales
as(
select *,
	case
		when hour(sale_time) < 12 then 'Morning'
        when  hour(sale_time)between 12 and 17 then 'after noon'
        else 'evening'
	end as shift
from retail_sales
)
select
	shift,
    count(*) as total_orders
from hourly_sales
group by shift;

-- END OF PROJECT