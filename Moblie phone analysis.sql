						-- Basic MYSQL Query's--
                        
-- 1. List all smartphone brands
SELECT DISTINCT brand_name FROM mobile_info;

-- 2. Count total number of smartphone models
SELECT COUNT(*) AS total_models FROM mobile_info;

-- 3. Find smartphones priced below ₹20,000
SELECT brand_name, model, price FROM mobile_info WHERE price < 20000;
 
-- 4.List all smartphone models with battery_capacity greater then 5000 and priced below then 20000
SELECT brand_name, model, battery_capacity,price 
FROM mobile_info
WHERE battery_capacity > 5000 and price <20000
order by battery_capacity;

-- 5. Show models with 5G support and NFC support and priced below 20000
SELECT brand_name, model, has_5g,has_nfc, price
FROM mobile_info
WHERE has_5g = "TRUE" and price <= 20000 AND has_nfc = "TRUE"
order by price;

-- Find top 5 highest rated smartphones
SELECT brand_name, model, rating
FROM mobile_info
ORDER BY rating DESC
LIMIT 5;

								-- Intermediate Query's

-- List models with more than 6 GB Ram, Internal memory more than 128 price below ₹20,000
SELECT brand_name, model,ram_capacity, internal_memory, price
FROM mobile_info
WHERE ram_capacity >= 6 AND internal_memory >=128 and price >10000 and price < 20000
order by ram_capacity,price
limit	10;

-- Get count of models per brand
SELECT brand_name, COUNT(*) AS model_count
FROM mobile_info
GROUP BY brand_name
order by model_count desc;

-- Find the most common screen size
SELECT 
    screen_size,
    COUNT(*) AS count
FROM mobile_info
GROUP BY screen_size
ORDER BY count DESC
LIMIT 5;

-- the average price of smartphones grouped by brand
SELECT 
    brand_name,
    ROUND(AVG(price), 2) AS avg_price
FROM mobile_info
GROUP BY brand_name
ORDER BY avg_price;

				-- Adavance Query's--

-- Window Function: Rank smartphones by rating within each brand
select * FROM(
SELECT brand_name, model, rating,
       RANK() OVER (PARTITION BY brand_name ORDER BY rating DESC) AS brand_rank
FROM mobile_info) As ranked_models
where brand_rank <= 5;

-- Running total of price by brand
SELECT brand_name, model, price,
       SUM(price) OVER (PARTITION BY brand_name ORDER BY model) AS Running_total_price
FROM mobile_info;

-- Compare screen resolution (width × height) across models
SELECT brand_name, model,
       resolution_width * resolution_height AS total_pixels
FROM mobile_info
ORDER BY total_pixels DESC;

 -- cte to find smartphones that have above-average battery capacity and below-average price
WITH avg_values AS (
    SELECT 
        AVG(battery_capacity) AS avg_battery,
        AVG(price) AS avg_price
    FROM mobile_info
)
SELECT 
    brand_name,
    model,
    price,
    battery_capacity,
    rating
FROM mobile_info
JOIN avg_values
    ON mobile_info.battery_capacity > avg_values.avg_battery
   AND mobile_info.price < avg_values.avg_price
ORDER BY rating DESC;

-- Top-Rated Phone per Brand
SELECT brand_name, model, rating
FROM mobile_info AS m
WHERE rating = (
    SELECT MAX(rating)
    FROM mobile_info
    WHERE brand_name = m.brand_name
)
ORDER BY brand_name;