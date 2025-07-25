CREATE TABLE sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10, 2) NOT NULL,
gross_margin_pct DECIMAL(11,9) NOT NULL,
gross_income DECIMAL(12,4) NOT NULL,
rating decimal(2,1)
);

SELECT 
    *
FROM
    sales;

-- -------------- Feature Engineering ----------------

-- Time_of_day

SELECT 
    time,
    (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_date
FROM
    sales;
    
ALTER TABLE sales ADD COLUMN time_of_date VARCHAR(20);

UPDATE sales 
SET time_of_date = (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END); 
    
    
-- ---- Day_name----------

SELECT 
    date,
     DAYNAME(date)
FROM
    sales;
    
ALTER TABLE sales ADD COLUMN day_name VARCHAR(20);

UPDATE sales 
SET day_name =  DAYNAME(date);

-- --------- month_name ---------------

SELECT 
    date, MONTHNAME(date)
FROM
    sales;
    
ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE sales 
SET month_name = MONTHNAME(date);



-- -------------------------------------- GENERIC QUESTIONS---------------------------

-- Q.How many Unique cities does the data have?
 SELECT DISTINCT
    city
FROM
    sales;
    
-- Q.In Which city is each branch?
   SELECT DISTINCT
    city,branch
FROM
    sales;
    

-- -----------------------Product Related Question--------------------------------

-- Q1.How many unique product lines does the data have? 
SELECT 
    COUNT(DISTINCT product_line)
FROM
    sales;
    
-- Q2.What is the most common payment method?
SELECT 
    payment_method, COUNT(payment_method) AS Cnt
FROM
    sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- Q3.What is the most selling product line?
SELECT 
    product_line, COUNT(product_line) AS Cnt
FROM
    sales
GROUP BY product_line
ORDER BY cnt DESC;

-- Q4.What is the total revenue by month?
SELECT 
    month_name AS month, SUM(total) AS total_revenue
FROM
    sales
GROUP BY month
ORDER BY total_revenue DESC;

-- Q5.What month had the largest COGS?
SELECT 
    month_name AS month, SUM(cogs) AS cogs
FROM
    sales
GROUP BY month
ORDER BY cogs DESC;

-- Q6.What product line had the largest revenue?
SELECT product_line,
   SUM(total) AS total_revenue FROM sales
GROUP BY product_line
ORDER BY  total_revenue DESC;

-- Q7.Which branch sold more products than average product sold?
SELECT 
    branch, SUM(quantity) AS qty
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- Q8.What is the most common product line by gender?
SELECT 
    gender, product_line, COUNT(product_line) AS total_cnt
FROM
    sales
GROUP BY gender , product_line
ORDER BY total_cnt DESC;

-- Q9.What is the average rating of each product line?
SELECT 
    ROUND(AVG(rating),2) AS Average_rating, product_line
FROM
    sales
GROUP BY product_line
ORDER BY Average_rating DESC;


-- -----------------------------------SALES QUESTIONS---------------------------------

-- Q1.Number of sales made in each time of the day per weekday
SELECT 
    time_of_day, COUNT(*) AS total_sales
FROM
    sales
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Q2.Which of the customer types brings the most revenue?
SELECT 
    customer_type, SUM(total) AS total_revenue
FROM
    sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Q3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
    city, AVG(VAT) AS largest_VAT
FROM
    sales
GROUP BY city
ORDER BY largest_VAT DESC;

-- Q4.Which customer type pays the most in VAT?
SELECT 
    customer_type, AVG(VAT) AS VAT
FROM
    sales
GROUP BY customer_type
ORDER BY VAT DESC;


-- ------------------------------ Customer Related Question -----------------------------------

-- Q1.How many unique customer types does the data have?
SELECT DISTINCT
    customer_type
FROM
    sales;
    
-- Q2.How many unique payment methods does the data have?
SELECT DISTINCT
    payment_method
FROM
    sales;

-- Q3.What is the most common customer type?
SELECT 
    customer_type, COUNT(*) AS count
FROM
    sales
GROUP BY customer_type
ORDER BY count DESC
LIMIT 1;

-- Q5.What is the gender of most of the customers?
SELECT gender,COUNT(*) AS cnt
FROM sales
GROUP BY gender
ORDER BY cnt DESC;