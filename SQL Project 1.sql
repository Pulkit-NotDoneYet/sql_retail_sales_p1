--SQL Retail Sales Analysis - P1
Create Database sql_project_p1;

--Create Table
CREATE TABLE retail_sales
 (
 transactions_id INT PRIMARY KEY,
 sale_date DATE,
 sale_time TIME,
 customer_id INT,  
 gender VARCHAR(15),
 age INT,
 category VARCHAR(15), 
 quantiy INT,
 price_per_unit FLOAT, 
 cogs FLOAT,
 total_sale FLOAT
 );


--Data Cleaning 
SELECT COUNT(*) FROM retail_sales
WHERE 
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 age IS NULL
	 OR
	 category IS NULL
	 OR
	 quantity IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL

--Data Exploration 
--How many sales we have 
SELECT COUNT(*) AS total_sale FROM retail_sales
	 
--How many unique customers we have
SELECT COUNT(DISTINCT customer_id) AS customers FROM retail_sales

--How many unique categories we have
SELECT DiSTINCT category FROM retail_sales

--Data Analysis & Business Key Problems & Answers

--Q1. Write a SQL query to retrieve all columns fro sales made on '2022-11-05'.
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q2. Write a SQL query to retrieve all  transactions where the category is 'Clothing' and the quantity sold is or more than 4 in the month of Nov-2022.
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

--Q3. Write a SQL query to calculate the totaL sales (total_sale) for each category.
SELECT category, SUM(total_sale) AS total_sales, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

--Q4. Write a SQL query to find the average age of customers who purchased iems from the 'Beauty' category.
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

--Q5 Write a SQL query to find all transactions where th total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

--Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(transactions_id) AS transactions
FROM retail_sales
GROUP BY gender, category;

--Q7. Write a SQL query to find the average sale of each month. Find out best selling month in each year.
SELECT year, month, avg_sale FROM
(
SELECT 
      EXTRACT(YEAR FROM sale_date) AS year,
	  EXTRACT(MONTH FROM sale_date) AS month,
	  AVG(total_sale) AS avg_sale,
	  RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1, 2
) AS t1
WHERE RANK = 1;

--Q8. Write a SQL query to find the top 5 customers based on the highest total sale.
SELECT customer_id, sum(total_sale) AS highest_total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

--Q9. Write a SQl query to find the number of unique customers who purchased itmes from each category.
SELECT COUNT(DISTINCT customer_id) AS unique_customers, category
FROM retail_sales
GROUP BY 2;

--Q10. Write a SQL query to crate each shift and number of orders (Example Morning < 12, Afternoon Between 12 & 17, Evening > 17).
WITH hourly_sale
AS
(
SELECT *,
     CASE
	     WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
		 ELSE 'Evening'
   END as shift
FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale 
GROUP BY shift;

--End of Project

 
