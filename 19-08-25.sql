create database zepto;

use zepto;

drop table if exists zepto;

create table zepto(
category varchar(120) primary key,
name varchar(150) not null, 
mrp numeric(8,2),
discountpercent numeric(5,2),
availablequantity integer,
discountedsellingprice numeric(8,2),
weightingms integer,
outofstock boolean,
quantity integer
);

select * from zepto_v2;
-- data exploration

-- count of rows

select count(*) from zepto_v2;

select * from zepto_v2
-- sample data

-- null values
where name is null
OR
Category is null
OR
mrp is null
OR
discountPercent is null
OR
discountedSellingPrice is null
OR
weightinGms is null
or
availableQuantity is null
OR 
outOfStock is null
OR
quantity is null;

-- different product categories
select distinct Category
from zepto_v2
order by Category;

-- products in stock vs out of stock
select outOfStock, count(quantity)
from zepto_v2
group by outOfStock;

-- product names present multiple times
select name, count(quantity) as "number of quantities"
from zepto_v2
group by name
having (quantity) > 1
order by count(quantity)desc;

-- data cleaning

-- products with price = 0
select * from zepto_v2 where mrp = 0 or discountedSellingPrice = 0;

delete from zepto_v2 where mrp = 0;

-- convert paise to rupees
update zepto_v2 
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;


select mrp, discountedSellingPrice from zepto_v2;

-- data analysis
-- Q1.Find the top 10 best-value products based on the discount percentage.

select distinct name, mrp, discountedSellingPrice
from zepto_v2
ORDER BY discountPercent desc
limit 5;

-- Q2.What are the Products with High MRP but Out of Stock
select distinct name, mrp
from zepto_v2
where outOfStock = true and mrp > 50
order by mrp desc;

-- Q3.Calculate Estimated Revenue for each category
select Category,
sum(discountedSellingPrice * availableQuantity) AS total_revenue
from zepto_v2
group by Category
order by total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is le
select distinct name, mrp, discountPercent
from zepto_v2
where mrp > 20 and discountPercent < 10
order by mrp desc, discountPercent desc;

-- Q5. Identify the top 5 categories offering the highest average discount
select Category,
avg(discountPercent) as avg_discount
from zepto_v2
group by Category
order by avg_discount desc
limit 10;

-- Q6. Find the price per gram for products above 100g and sort by best va
select distinct name, weightInGms, discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto_v2
where weightInGms >=100
order by price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name, weightInGms, 
case when weightInGms < 1000 Then 'low'
     when weightInGms < 5000 Then 'medium'
	else 'bulk'
    end as weight_category
from zepto_v2;

-- Q8.What is the Total Inventory Weight Per Category 
select Category,
sum(weightInGms * availableQuantity) as total_weight
from zepto_v2
group by Category
order by total_weight;