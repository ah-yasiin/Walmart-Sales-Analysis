-- Connection Id: 17
-- User: root
-- Host: localhost
-- DB: walmart_db
-- Command: Sleep
-- Time: 20915
-- State: None
USE walmart_db;
select * from walmart;
select count(*) from walmart;
select count(distinct branch) from walmart;

/*Business Problems*/

/* Find Different Payment Methods and Number of Transactions 
& Number of Quantity Sold*/
select payment_method, 
count(*) as num_payments, 
sum(quantity) as no_qty_sold from walmart group by payment_method;

/*Identify the highest-rated category in each branch*/
select branch, category, avg(rating) as avg_rating
from walmart
group by branch, category
order by avg_rating desc;

/*Identify the busiest day for each branch based on number of transaction*/

SELECT 
    branch,
    DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%y'), '%W') AS day_name,
    COUNT(*) AS num_transactions
FROM walmart
GROUP BY branch, day_name
ORDER BY num_transactions DESC;

/*Calculate the total quantity of items sold by payment method */
select payment_method,
sum(quantity) as no_qty_sold
from walmart
group by payment_method;




/*Determine the average, minimum, and maximum rating of products for each city*/
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM walmart
GROUP BY city, category
ORDER BY avg_rating DESC;

/* Calculate the total profit for each category */
SELECT
	category,
    sum(total * profit_margin) as profit
    from walmart
    group by category;
    
/* Determine the most common payment method for each Branch */
WITH PaymentRank AS (
    SELECT 
        branch, 
        payment_method, 
        COUNT(*) AS total_trans,
        RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method, total_trans
FROM PaymentRank
WHERE rnk = 1;


 /* Identify 5 branch with highest decrease in revenue compared to last year (From 2023 to 2022) */
 
WITH revenue_2022 AS (
    SELECT 
        branch, 
        SUM(total) AS revenue_2022
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch, 
        SUM(total) AS revenue_2023
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023
    GROUP BY branch
)
SELECT 
    r22.branch, 
    revenue_2022, 
    revenue_2023, 
    (revenue_2022 - revenue_2023) AS revenue_decrease
FROM revenue_2022 r22
JOIN revenue_2023 r23 ON r22.branch = r23.branch
ORDER BY revenue_decrease DESC
LIMIT 5;














