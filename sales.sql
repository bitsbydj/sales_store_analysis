 create TABLE sales_store(
transaction_id VARCHAR(15),
customer_id VARCHAR(15),
customer_name VARCHAR(30),
customer_age INT,
gender VARCHAR(15),
product_id VARCHAR(15),
product_name VARCHAR(15),
product_category VARCHAR(15),
quantiy INT,
prce FLOAT,
payment_mode VARCHAR(15),
purchase_date DATE,
time_of_purchase TIME,
status VARCHAR(15)
);

select * from sales_store;

select * into sales from sales_store;

select * from sales;

--Data Cleaning

--Step 1: To check the duplicate

select transaction_id ,count(*)
from sales group by transaction_id
having count(transaction_id)>1;

"TXN855235"
"TXN240646"
"TXN342128"
"TXN981773"

 with cte as(
select * ,
row_number() over(partition by transaction_id order by transaction_id) as 
row_num from sales
)
select * from cte;


delete from sales 
where transaction_id in('TXN855235',
'TXN240646',
'TXN342128',
'TXN981773');

select * from sales;

--Step2: Correction of Headers

alter table sales 
rename column  quantitiy to quantity;

alter table sales 
rename column  prce to price;

select * from sales;

--Step:3 To check Datatype

select column_name, data_type 
from information_schema.columns
where table_name ='sales';


--Step:4 To  check null values

--to check null count

select * from sales;
select
count(*) - count(transaction_id), 
count(*) - count(customer_id),
count(*) - count(customer_name),
count(*) - count(customer_age),
count(*) - count(gender),
count(*) - count(product_id),
count(*) - count(product_name),
count(*) - count(product_category),
count(*) - count(quantity),
count(*) - count(price),
count(*) - count(payment_mode),
count(*) - count(time_of_purchase),
count(*) - count(status)
from sales;

--treating null values
select * from sales
where transaction_id is null
or customer_id is null
or customer_name is null
or customer_age is null
or gender is null
or product_id is null
or  product_name is null
or  product_category is null
or quantity is null
or price is null
or payment_mode is null
or purchase_date is null
or time_of_purchase is null
or status is null;

delete from sales 
where transaction_id is null;


select * from sales 
 where customer_name='Ehsaan Ram';

update sales
set customer_id='CUST9494'
where transaction_id='TXN977900';

select * from sales 
 where customer_name='Damini Raju';

update sales 
set customer_id='CUST1401'
where transaction_id='TXN985663';

select * from sales where customer_id='CUST1003';

update sales 
set customer_name='Mahika Saini',customer_age=35,gender='Male'
where transaction_id='TXN432798';

--Step5: Data Cleaning
select distinct gender
from sales;


update sales
set gender='Male'
where gender='M'

update sales
set gender='Female'
where gender='F'


select distinct payment_mode
from sales;

update sales
set payment_mode='Credit Card'
where payment_mode='CC'



--Data Analysis--


--1. What are the top 5 most selling products by quantity?
select distinct status from sales;

select product_name,sum(quantity)
as total_quantity
from sales  
group by product_name 
order by total_quantity desc;

--Buisness Problem: We don't know which products are most in demand.

--Buisness Impact: Helps prioritize stock and boost sales through targeted promotion.





--2: Which products are most frequently canceled?
select product_name,count(*) as total_canceled from sales
where status='canceled'
group by  product_name 
order by  total_canceled desc
limit 5;


--Business Problem : Frequent cancellations affect revenue and customer trust.

--Buisness Impact: Identify poor-performing to improve quality or remove from catlog.



--3. What time of the day has the highest number of purchases?
select * from sales
 select
   case
   when Datepart(hour,time_of_purchase) between 0 and 5 then 'NIGHT'
   when Datepart(hour,time_of_purchase) between 6 and 11 then 'MORNING'
   when Datepart(hour,time_of_purchase) between 12 and 17 then 'AFTERNOON'
   when Datepart(hour,time_of_purchase) between 18 and 23 then 'EVENING'
   end as time_of_day,
   count(*)as total_orders
   from sales
   group by 
   case
   when Datepart(hour,time_of_purchase) between 0 and 5 then 'NIGHT'
   when Datepart(hour,time_of_purchase) between 6 and 11 then 'MORNING'
   when Datepart(hour,time_of_purchase) between 12 and 17 then 'AFTERNOON'
   when Datepart(hour,time_of_purchase) between 18 and 23 then 'EVENING'
   end 
   order by total_orders desc;

--Business Problem Solved: Find peak sales times.

--Business Impact : Optimize staffing,promotions,and server loads.


--4 Who are the top 5 highest spending customers.
select customer_name ,sum(quantity*price) as total_spend
from sales
group  by customer_name
order by total_spend desc
limit 5;

--Business Problem Solved: Identify VIP customers.

--Businees Impact: Personalized offers, loyalty rewards, and retension.

--5 WHich product category generate the highest revenue?
 select * from sales;

  select product_category, sum(quantity*price) as revenue
  from sales
  group by product_category
  order by revenue desc;

--Buisness problem solved :Identify top performing product categories.

--Buisness Impact: Refine product strategy, supply chain,and promotions.
--allowing the buisness to invest more in high-margin or high-demand categories.

--6. What is the return/cancellation rate per product category?

select * from sales;
--cancellation
select product_category,
      count(case when status='cancelled' Then 1 end )*100.0/count(*) 
	  as cancelled_percent
	  from sales
	  group by product_category
	  order by cancelled_percent;

--Return
select product_category,
      count(case when status='Returned' Then 1 end )*100.0/count(*) 
	  as return_percent
	  from sales
	  group by product_category
	  order by return_percent desc;

--Buisness Problem Solved: Monitor dissatisfaction trends per category.

--Buisness impact: Reduce returns, Improve product descriptions/expectations.
--helps identify and fix product or logistics issues.

--7: What is the most preferred payment mode?

select * from sales;
select payment_mode, count(payment_mode)as total_count
from sales
group by payment_mode
order by total_count desc;

--Buisness Problem Solved: Know which payment options customers prefer.

--Buisness Impact: Streamline payment processing, prioritize popular modes.

--8: How does age group affect purchasing behavior?

select * from sales;
 select 
     case 
	     when customer_age between '18' and '25' then '18-15'		  
	     when customer_age between '26' and '35' then '26-35'		  
	     when customer_age between '36' and '50' then '36-50'
		 else '51' 
		 end as customer_age,
		 sum(price* quantity) as total_purchase
		 from sales
		 group by    case 
	     when customer_age between '18' and '25' then '18-15'		  
	     when customer_age between '26' and '35' then '26-35'		  
	     when customer_age between '36' and '50' then '36-50'
		 else '51' 
		 end
		 order by total_purchase desc;

--Buisness problem Solved : Understand customer demographics.

--Business impact : Targeted marketing and product recommendations by age group.

--9:What is the monthly sales trend?
 select * from  sales;

select 
     date_part('year',purchase_date) as year,
	 date_part('month',purchase_date) as month,
	 sum(price*quantity) as total_sales,
	 sum(quantity) as total_quantity
	 from sales
	 group by year, month
	 order by year,month;
--Buisness Problem : Sales Fluctuations go unnoticed.
--Buisness Impect: Plan inventary and marketing according to seasonal tends.


--10: Are certain genders buying more specific product categories?

select gender, product_category,count(product_category) as total_purchase
from sales
group by gender, product_category
order by total_purchase desc;

--Buisness Problem Solved: Gender-based product preferences.
--Buisness Impact: Personalized ads, gender-focused compaigns.






	 
	




		 












	  




   
   
   































 




























 
 



















 
	 )


