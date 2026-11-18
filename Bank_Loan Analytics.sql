select gender ,sum(purchase_amount) as revenue
from cleaned_sales_data
group by gender


SELECT Customer_id,purchase_amount
from cleaned_sales_data
where discount_applied = 'Yes' and purchase_amount >=(select avg (purchase_amount) from cleaned_sales_data)


SELECT item_purchased, AVG(review_rating)as "Average Product Rating"
from cleaned_sales_data
group by item_purchased
order by avg (review_rating) desc
limit 5;


Select shipping_type,ROUND(AVG(purchase_amount),2)
from cleaned_sales_data
where shipping_type in ('Standard','Express')
group by shipping_type


select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as avg_spend,
Round(SUM(purchase_amount),2) as total_revenue
from cleaned_sales_data
group by subscription_status
order by total_revenue, avg_spend desc;


SELECT item_purchased,
ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) as discount_rate
from cleaned_sales_data
group by item_purchased
order by discount_rate desc
limit 5;


with customer_type as(
select customer_id,previous_purchases,
CASE WHEN previous_purchases = 1 THEN 'NEW'
     WHEN previous_purchases between 2 and 10 THEN 'Returning'
     ELSE 'Loyal'
     END as customer_segment
From cleaned_sales_data     
)
select customer_segment,count(*) as 'Number of Customers'
from customer_type
group by customer_segment


with item_counts as(
select category,
item_purchased,
COUNT(customer_id) as total_orders,
Row_number() over(partition by category order by count(customer_id) desc) as item_rank
from cleaned_sales_data
group by category,item_purchased
)
select item_rank,category,item_purchased,total_orders
from item_counts
where item_rank <=3;


select subscription_status,
COUNT(customer_id) as repeat_buyers
from cleaned_sales_data
where previous_purchases > 5
group by subscription_status


select age_group,
SUM(purchase_amount) as total_revenus
from cleaned_sales_data
group by age_group
order by total_revenus desc;


SELECT COUNT(*) AS Total_Rows
FROM RetailCombined;

SHOW TABLES LIKE 'RetailCombined_Deduped';
SELECT COUNT(*) AS Original_Rows
FROM RetailCombined;
SHOW TABLES;
SHOW TABLES LIKE 'RetailCombined_Deduped';
SELECT DATABASE() AS Current_Database;

SHOW TABLES;

SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM information_schema.tables
WHERE TABLE_NAME IN (
    'RetailCombined',
    'RetailCombined_Deduped'
);
SELECT COUNT(*) AS Original_Rows
FROM RetailCombined;

CREATE TABLE RetailCombined_Deduped AS
WITH Deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY
                Invoice,StockCode,Description,Quantity,InvoiceDate,Price,Customer_ID,Country
            ORDER BY Invoice
        ) AS RowNum
    FROM RetailCombined
)
SELECT
    Invoice,StockCode,Description,Quantity,InvoiceDate,Price,Customer_ID,Country,Sourcesheet
FROM Deduped
WHERE RowNum = 1;

















